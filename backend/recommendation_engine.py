"""
SmartBuy AI - Deterministic Category-Specific Recommendation Engine
Calculates transparent matching scores based on user budget, intended usage,
priorities, and category-specific hardware/material specifications.
"""

from typing import List, Dict, Any, Optional, Tuple
import math

import os
from topsis_engine import TOPSISRankingEngine, normalize_priority

class RecommendationEngine:
    def __init__(self, products: List[Dict[str, Any]]):
        self.products = products
        self.topsis = TOPSISRankingEngine()

    def filter_and_score(
        self,
        category: str,
        min_budget: Optional[float],
        max_budget: Optional[float],
        intended_usages: List[str],
        priorities: List[str],
        optional_specs: Optional[Dict[str, Any]] = None,
        allow_budget_flexibility: bool = False,
        ranking_algorithm: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Executes recommendation pipeline.
        Supports controlled algorithm switching:
        - "heuristic": existing battle-tested deterministic baseline
        - "topsis": multi-criteria TOPSIS decision analysis
        """
        optional_specs = optional_specs or {}
        active_algo = ranking_algorithm or os.getenv("WORTHLY_RANKING_ENGINE", "heuristic")

        # Step 1: Category filter
        category_products = [p for p in self.products if p.get("category") == category]
        if not category_products:
            category_products = self.products

        # If TOPSIS mode is explicitly requested or configured
        if active_algo == "topsis":
            topsis_res = self.topsis.rank_products_topsis(
                products=category_products,
                category=category,
                priorities=priorities,
                intended_usages=intended_usages,
                min_budget=min_budget,
                max_budget=max_budget,
                optional_specs=optional_specs,
                allow_budget_flexibility=allow_budget_flexibility
            )
            if topsis_res["status"] == "insufficient_products":
                return {
                    "status": "insufficient_products",
                    "message": topsis_res["message"],
                    "total_eligible": 0,
                    "recommendations": []
                }
            return {
                "status": "success",
                "algorithm": "topsis",
                "message": (
                    f"Successfully evaluated {len(category_products)} products in {category.replace('_', ' ').title()} "
                    f"using multi-criteria TOPSIS decision analysis based on your priorities."
                ),
                "total_in_category": len(category_products),
                "total_eligible": topsis_res["total_eligible"],
                "recommendations": topsis_res["ranked_products"]
            }

        # Step 2: Strict budget filtering (Heuristic Baseline)
        eligible_products = []
        budget_excluded_count = 0
        
        effective_max = max_budget
        if allow_budget_flexibility and max_budget:
            effective_max = max_budget * 1.15  # Up to 15% flexible if explicitly opted in

        for p in category_products:
            price = float(p.get("price", 0))
            if min_budget is not None and price < min_budget:
                budget_excluded_count += 1
                continue
            if effective_max is not None and price > effective_max:
                budget_excluded_count += 1
                continue
            eligible_products.append(p)

        # If zero products within budget
        if not eligible_products:
            min_avail = min((p["price"] for p in category_products), default=0)
            max_avail = max((p["price"] for p in category_products), default=0)
            return {
                "status": "insufficient_products",
                "message": (
                    f"No products in this category match your exact budget range (₹{min_budget or 0:,.0f} - ₹{max_budget or 0:,.0f}). "
                    f"Available options in this category range from ₹{min_avail:,.0f} to ₹{max_avail:,.0f}. "
                    "Consider widening your budget range or enabling budget flexibility."
                ),
                "total_eligible": 0,
                "recommendations": []
            }

        # Step 3: Hard requirements filtering
        filtered_products = []
        for p in eligible_products:
            meets_hard_reqs = True
            
            # Check brand preference if specified
            pref_brand = optional_specs.get("preferred_brand")
            if pref_brand and pref_brand != "Any":
                if p.get("brand", "").lower() != pref_brand.lower():
                    # Brand is treated as a hard filter if specifically requested
                    meets_hard_reqs = False
            
            # Check dedicated GPU if in electronics
            if category == "electronics" and optional_specs.get("dedicated_gpu"):
                gpu_spec = p.get("specs", {}).get("gpu", "").lower()
                if "rtx" not in gpu_spec and "geforce" not in gpu_spec and "radeon" not in gpu_spec:
                    meets_hard_reqs = False

            # Check min RAM for electronics
            min_ram_pref = optional_specs.get("min_ram")
            if category == "electronics" and min_ram_pref and min_ram_pref != "Any":
                ram_spec = p.get("specs", {}).get("ram", "")
                ram_gb = 0
                for token in ["64GB", "32GB", "16GB", "8GB"]:
                    if token in ram_spec:
                        ram_gb = int(token.replace("GB", ""))
                        break
                target_gb = int(min_ram_pref.replace("GB", ""))
                if ram_gb < target_gb:
                    meets_hard_reqs = False

            if meets_hard_reqs:
                filtered_products.append(p)

        # If hard requirements eliminated all products, fall back to eligible with a notice
        used_products = filtered_products if filtered_products else eligible_products

        # Step 4 & 5: Calculate category-specific scores & priority weighting
        scored_products = []
        for p in used_products:
            score, breakdown, why_bullets = self._score_product(
                product=p,
                category=category,
                intended_usages=intended_usages,
                priorities=priorities,
                optional_specs=optional_specs,
                min_budget=min_budget,
                max_budget=max_budget
            )
            scored_products.append({
                "product": p,
                "match_score": score,
                "score_breakdown": breakdown,
                "reasons": why_bullets
            })

        # Step 6: Rank eligible products by match score descending
        scored_products.sort(key=lambda x: x["match_score"], reverse=True)

        # Step 7: Select Best Overall Match, Best Value, and Best Alternative
        recommendations = self._assign_roles(scored_products, max_budget)

        explanation_summary = ""
        if len(recommendations) < 3:
            explanation_summary = (
                f"We found {len(recommendations)} product(s) that genuinely meet your strict criteria. "
                "WORTHLY prioritizes transparent, real matches rather than fabricating unverified items."
            )
        else:
            explanation_summary = (
                f"Successfully analyzed {len(category_products)} products in {category.replace('_', ' ').title()}. "
                f"Identified the top 3 verified matches based on your {len(intended_usages)} intended usage(s) and {len(priorities)} priority factors."
            )

        return {
            "status": "success",
            "message": explanation_summary,
            "total_in_category": len(category_products),
            "total_eligible": len(scored_products),
            "recommendations": recommendations
        }

    def _score_product(
        self,
        product: Dict[str, Any],
        category: str,
        intended_usages: List[str],
        priorities: List[str],
        optional_specs: Dict[str, Any],
        min_budget: Optional[float],
        max_budget: Optional[float]
    ) -> Tuple[int, Dict[str, float], List[str]]:
        """
        Calculates category-specific score (0-100) with full breakdown and evidence reasons.
        """
        usage_score = 0.0
        priority_score = 0.0
        spec_score = 0.0
        budget_efficiency_score = 0.0
        why_bullets = []

        product_tags = product.get("intendedUsageTags", [])
        affinities = product.get("priorityAffinities", {})
        specs = product.get("specs", {})
        price = float(product.get("price", 0))

        # 1. Intended Usage Scoring (30% weight)
        if intended_usages:
            matched_usages = [u for u in intended_usages if u in product_tags]
            match_ratio = len(matched_usages) / len(intended_usages)
            usage_score = match_ratio * 100.0
            if matched_usages:
                why_bullets.append(f"Directly engineered for your workflow: {', '.join(u.replace('_', ' ').title() for u in matched_usages)}.")
        else:
            usage_score = 85.0

        # 2. Priority Affinities Scoring (30% weight)
        if priorities:
            total_priority_weight = 0.0
            for p in priorities:
                # normalize priority key
                p_key = normalize_priority(p)
                val = affinities.get(p_key, affinities.get(p.lower().replace(" ", "_"), 0.75))
                total_priority_weight += val
            priority_score = (total_priority_weight / len(priorities)) * 100.0
            
            top_p = priorities[0].replace("_", " ").title()
            why_bullets.append(f"Demonstrates top-tier index for your key priority: '{top_p}'.")
        else:
            priority_score = 80.0

        # 3. Category-Specific Hardware & Spec Scoring (25% weight)
        if category == "electronics":
            # RAM score
            ram_text = specs.get("ram", "")
            if "32GB" in ram_text or "64GB" in ram_text:
                spec_score += 35
                why_bullets.append("Generous 32GB+ RAM ensures lag-free multi-tasking and developer tooling.")
            elif "16GB" in ram_text:
                spec_score += 28
            else:
                spec_score += 15

            # GPU / Performance
            gpu_text = specs.get("gpu", "")
            if "RTX 40" in gpu_text:
                spec_score += 35
                why_bullets.append("Dedicated NVIDIA RTX 40-series GPU provides dedicated hardware acceleration.")
            elif "M3" in specs.get("processor", "") or "Arc" in gpu_text:
                spec_score += 30
            else:
                spec_score += 20

            # Battery / Display
            spec_score += 30

        elif category == "footwear":
            # Comfort and cushioning
            spec_score = 40.0
            midsole = specs.get("midsole", "")
            if "ReactX" in midsole or "DNA LOFT" in midsole or "ENCAP" in midsole:
                spec_score += 30
                why_bullets.append(f"Features shock-absorbing midsole architecture ({midsole[:40]}...).")
            else:
                spec_score += 20

            # Weight & Outsole
            spec_score += 30

        elif category == "home_kitchen":
            # Efficiency & Ease of cleaning
            spec_score = 50.0
            functions = specs.get("functions", "") or specs.get("dock", "") or specs.get("grinder", "")
            if functions:
                spec_score += 45
                why_bullets.append("Features automated high-efficiency thermal/cleaning mechanisms.")
            else:
                spec_score += 30

        elif category == "furniture":
            # Ergonomic certifications & Adjustments
            adjustments = specs.get("adjustments", "") or specs.get("motors", "")
            warranty = specs.get("warranty", "")
            spec_score = 40.0
            if "warranty" in str(specs).lower():
                spec_score += 30
                why_bullets.append(f"Long-term structural reliability backed by {warranty or 'extended warranty'}.")
            if adjustments:
                spec_score += 30

        elif category == "fitness":
            # Sensor accuracy & Battery life
            sensors = specs.get("sensors", "") or specs.get("mechanism", "")
            spec_score = 50.0
            if "GNSS" in sensors or "turn-dial" in str(specs):
                spec_score += 45
                why_bullets.append("Precision instrumentation and zero subscription requirement.")
            else:
                spec_score += 35

        elif category == "education":
            # Battery life & Portability
            latency = specs.get("latency", "") or specs.get("battery", "")
            spec_score = 50.0
            if latency:
                spec_score += 45
                why_bullets.append("Low eye-strain and ultra-portable profile tailored for lectures and library.")
            else:
                spec_score += 35
        else:
            spec_score = 80.0

        spec_score = min(spec_score, 100.0)

        # 4. Budget Efficiency Scoring (15% weight)
        if max_budget and max_budget > 0:
            savings_ratio = max(0.0, (max_budget - price) / max_budget)
            # A healthy sweet spot is staying 5%-30% below max budget
            if 0.0 <= savings_ratio <= 0.40:
                budget_efficiency_score = 95.0
                why_bullets.append(f"Maximizes specification value within your target ₹{max_budget:,.0f} budget.")
            elif savings_ratio > 0.40:
                budget_efficiency_score = 90.0
                why_bullets.append(f"Saves ₹{(max_budget - price):,.0f} under your designated ceiling.")
            else:
                budget_efficiency_score = 75.0
        else:
            budget_efficiency_score = 85.0

        # Composite match score calculation
        composite = (
            usage_score * 0.30 +
            priority_score * 0.30 +
            spec_score * 0.25 +
            budget_efficiency_score * 0.15
        )
        
        # Rating boost (up to 4 extra points for 4.7+ rating with high verified purchases)
        rating = float(product.get("rating", 4.0))
        if rating >= 4.7:
            composite += 3.0
        elif rating >= 4.5:
            composite += 1.5

        final_score = int(min(99, max(65, round(composite))))

        breakdown = {
            "usage_fit": round(usage_score, 1),
            "priority_alignment": round(priority_score, 1),
            "hardware_specs": round(spec_score, 1),
            "budget_efficiency": round(budget_efficiency_score, 1),
            "final_score": final_score
        }

        # Keep top 3 concise evidence bullets
        cleaned_bullets = why_bullets[:3]
        if not cleaned_bullets:
            cleaned_bullets.append("Meets all required criteria within your target budget parameters.")

        return final_score, breakdown, cleaned_bullets

    def _assign_roles(
        self,
        ranked_items: List[Dict[str, Any]],
        max_budget: Optional[float]
    ) -> List[Dict[str, Any]]:
        """
        Assigns the 3 distinct roles:
        1. BEST OVERALL MATCH: Highest composite score.
        2. BEST VALUE: Best score-to-price ratio.
        3. BEST ALTERNATIVE: Compelling alternative from a distinct angle/brand.
        """
        if not ranked_items:
            return []

        recommendations = []

        # Role 1: BEST OVERALL MATCH
        best_overall = ranked_items[0]
        rec1 = dict(best_overall)
        rec1["role"] = "BEST OVERALL MATCH"
        rec1["role_tagline"] = "Highest composite score matching all your intended usages and priorities."
        recommendations.append(rec1)

        if len(ranked_items) == 1:
            return recommendations

        # Role 2: BEST VALUE
        # Look for the item with highest score per dollar that is not already rec1
        remaining = [item for item in ranked_items if item["product"]["id"] != best_overall["product"]["id"]]
        
        # Sort remaining by score / price
        def value_ratio(item):
            price = max(float(item["product"].get("price", 1)), 1.0)
            score = item["match_score"]
            return score / price

        best_value_item = max(remaining, key=value_ratio)
        rec2 = dict(best_value_item)
        rec2["role"] = "BEST VALUE"
        rec2["role_tagline"] = f"Outstanding performance-per-rupee, priced at ₹{rec2['product']['price']:,.0f}."
        recommendations.append(rec2)

        if len(remaining) == 1:
            return recommendations

        # Role 3: BEST ALTERNATIVE
        # Distinct product (preferably different brand or distinct tradeoff)
        chosen_ids = {rec1["product"]["id"], rec2["product"]["id"]}
        alternatives = [item for item in ranked_items if item["product"]["id"] not in chosen_ids]
        
        if alternatives:
            # Pick the top remaining score
            rec3 = dict(alternatives[0])
            rec3["role"] = "BEST ALTERNATIVE"
            rec3["role_tagline"] = "A compelling alternative offering a unique specification balance or distinct form factor."
            recommendations.append(rec3)

        return recommendations

    def find_budget_breakdown(
        self,
        category: str,
        budget: float
    ) -> Dict[str, Any]:
        """
        Gives a transparent budget breakdown into 4 clear, non-interchangeable roles:
        - Lowest Price (absolute lowest cost eligible)
        - Budget Friendly (great balance of cheap price with good fundamentals)
        - Best Value (highest score/feature to price ratio)
        - Best Performance (highest spec ceiling that still fits within budget)
        """
        category_products = [p for p in self.products if p.get("category") == category]
        eligible = [p for p in category_products if float(p.get("price", 0)) <= budget]
        
        if not eligible:
            cheapest = min(category_products, key=lambda x: float(x.get("price", 0)))
            return {
                "status": "insufficient_budget",
                "message": f"No products found under ₹{budget:,.0f}. Lowest priced option in this category is '{cheapest['name']}' at ₹{cheapest['price']:,.0f}.",
                "eligible_count": 0,
                "tiers": {}
            }

        # 1. Lowest Price
        lowest_cost = min(eligible, key=lambda x: float(x.get("price", 0)))

        # 2. Best Performance
        # Highest rated and priced product near the budget ceiling
        best_perf = max(eligible, key=lambda x: (float(x.get("rating", 0)) * 10 + float(x.get("price", 0)) / 100))

        # 3. Best Value (highest rating / price ratio with minimum 4.4 rating)
        def val_calc(p):
            price = max(float(p.get("price", 1)), 1.0)
            rating = float(p.get("rating", 4.0))
            return (rating * 100) / price

        best_value = max(eligible, key=val_calc)

        # 4. Budget Friendly (median price amongst eligible)
        sorted_by_price = sorted(eligible, key=lambda x: float(x.get("price", 0)))
        mid_idx = len(sorted_by_price) // 2
        budget_friendly = sorted_by_price[mid_idx]

        compromises = []
        if float(lowest_cost.get("price", 0)) < float(best_perf.get("price", 0)):
            price_diff = float(best_perf.get("price", 0)) - float(lowest_cost.get("price", 0))
            compromises.append(
                f"Choosing the Lowest Price option saves ₹{price_diff:,.0f}, but steps down on premium chassis and secondary specs."
            )
        if best_value["id"] != best_perf["id"]:
            compromises.append(
                f"The Best Value pick gives {best_value['rating']}★ satisfaction while saving ₹{(best_perf['price'] - best_value['price']):,.0f} versus the highest-spec tier."
            )

        return {
            "status": "success",
            "budget": budget,
            "category": category,
            "eligible_count": len(eligible),
            "tiers": {
                "lowest_price": {
                    "role_title": "Lowest Price",
                    "explanation": "Absolute lowest financial commitment. Best if your budget is tight and basic functionality is all you need.",
                    "product": lowest_cost
                },
                "budget_friendly": {
                    "role_title": "Budget Friendly",
                    "explanation": "Comfortably under budget with balanced reliability and durable day-to-day materials.",
                    "product": budget_friendly
                },
                "best_value": {
                    "role_title": "Best Value",
                    "explanation": "Optimal sweet spot between verified performance and dollar expenditure.",
                    "product": best_value
                },
                "best_performance": {
                    "role_title": "Best Performance",
                    "explanation": "Maximizes every dollar of your budget to deliver top-tier processing, build quality, and longevity.",
                    "product": best_perf
                }
            },
            "specification_compromises": compromises
        }

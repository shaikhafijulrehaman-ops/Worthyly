"""
WORTHLY - TOPSIS Multi-Criteria Decision Analysis (MCDA) Ranking Engine
Implements mathematically rigorous TOPSIS ranking for product comparison
with strict constraint gating, criteria normalization, dynamic trade-off detection,
and explainable evidence tailored to user-specified priorities.
"""

from typing import List, Dict, Any, Optional, Tuple
import math
import re
import numpy as np


def normalize_priority(prio_str: str) -> str:
    """
    Normalizes priority labels and user selections into canonical criteria keys.
    Prevents mismatched text descriptions (e.g. 'Raw Performance (CPU/GPU)' -> 'performance').
    """
    if not prio_str:
        return "performance"
    p = prio_str.lower().strip()
    if any(k in p for k in ["perform", "cpu", "gpu", "speed", "raw", "power", "compute"]):
        return "performance"
    if any(k in p for k in ["batter", "enduran", "charge"]):
        return "battery"
    if any(k in p for k in ["portab", "weight", "light"]):
        return "portability"
    if any(k in p for k in ["ram", "multitask"]):
        return "ram"
    if any(k in p for k in ["valu", "price", "budget"]):
        return "value"
    if any(k in p for k in ["comfort", "cushion", "ergonom", "arch"]):
        return "comfort"
    if any(k in p for k in ["durab", "reliab", "grip"]):
        return "durability"
    if any(k in p for k in ["camera", "photo"]):
        return "camera"
    if any(k in p for k in ["display", "screen"]):
        return "display"
    return p.replace(" ", "_")


class CriterionDefinition:
    def __init__(
        self,
        name: str,
        is_benefit: bool,  # True if higher is better, False if lower is better (cost)
        base_weight: float = 1.0,
        priority_key: Optional[str] = None
    ):
        self.name = name
        self.is_benefit = is_benefit
        self.base_weight = base_weight
        self.priority_key = priority_key


class TOPSISRankingEngine:
    def __init__(self):
        pass

    def extract_numerical_features(
        self,
        product: Dict[str, Any],
        category: str
    ) -> Dict[str, Tuple[Optional[float], bool]]:
        """
        Extracts numerical values for criteria across categories and subcategories.
        Returns dict: criterion_name -> (value, is_missing_flag)
        """
        specs = product.get("specs", {})
        price = float(product.get("price", 0))
        rating = float(product.get("rating", 4.0))
        review_count = float(product.get("reviewCount", product.get("review_count", 0)))

        features: Dict[str, Tuple[Optional[float], bool]] = {}

        # 1. Price in INR (Cost criterion - lower is better)
        features["price"] = (price if price > 0 else None, price <= 0)

        # 2. Rating (Benefit - higher is better)
        features["rating"] = (rating, False)

        # 3. Verified evidence volume (Benefit - log-scaled, 0 if no reviews)
        evidence_score = math.log1p(review_count) if review_count > 0 else 0.0
        features["review_evidence"] = (evidence_score, review_count <= 0)

        # Category and Subcategory specific spec extraction
        if category in ["smartphones", "consumer_electronics"]:
            # RAM in GB
            ram_text = specs.get("ram", "")
            ram_val = None
            for token in ["32GB", "24GB", "16GB", "12GB", "8GB", "6GB", "4GB"]:
                if token.lower() in ram_text.lower():
                    ram_val = float(re.search(r"\d+", token).group())
                    break
            features["ram_gb"] = (ram_val, ram_val is None)

            # Storage in GB
            storage_text = specs.get("storage", "")
            storage_val = None
            if "1tb" in storage_text.lower() or "1 tb" in storage_text.lower():
                storage_val = 1024.0
            elif "512gb" in storage_text.lower() or "512 gb" in storage_text.lower():
                storage_val = 512.0
            elif "256gb" in storage_text.lower() or "256 gb" in storage_text.lower():
                storage_val = 256.0
            elif "128gb" in storage_text.lower() or "128 gb" in storage_text.lower():
                storage_val = 128.0
            features["storage_gb"] = (storage_val, storage_val is None)

            # Camera main MP
            cam_text = specs.get("camera", "")
            cam_val = None
            mp_matches = re.findall(r"(\d+)\s*MP", cam_text, re.IGNORECASE)
            if mp_matches:
                cam_val = float(max(int(m) for m in mp_matches))
            features["camera_mp"] = (cam_val, cam_val is None)

            # Battery in mAh
            batt_text = specs.get("battery", "")
            batt_val = None
            mah_match = re.search(r"(\d{3,5})\s*mAh", batt_text, re.IGNORECASE)
            if mah_match:
                batt_val = float(mah_match.group(1))
            features["battery_mah"] = (batt_val, batt_val is None)

            # Processor tier
            proc_text = specs.get("processor", "").lower()
            if proc_text:
                if any(x in proc_text for x in ["snapdragon 8 elite", "a18 pro", "dimensity 9400"]):
                    proc_tier = 5.5
                elif any(x in proc_text for x in ["snapdragon 8 gen 3", "a17 pro", "dimensity 9300"]):
                    proc_tier = 5.0
                elif any(x in proc_text for x in ["a16", "snapdragon 8 gen 2", "dimensity 8300"]):
                    proc_tier = 4.2
                elif any(x in proc_text for x in ["snapdragon 7", "dimensity 7200", "tensor"]):
                    proc_tier = 3.5
                else:
                    proc_tier = 3.0
                features["processor_tier"] = (proc_tier, False)

            # Weight in g
            weight_text = specs.get("weight", "")
            weight_val = None
            if "g" in weight_text.lower():
                try:
                    weight_val = float(re.findall(r"\d+", weight_text)[0])
                except Exception:
                    pass
            features["weight_g"] = (weight_val, weight_val is None)

        elif category in ["electronics", "laptops"]:
            # RAM in GB
            ram_text = specs.get("ram", "")
            ram_val = None
            for token in ["64GB", "32GB", "16GB", "12GB", "8GB", "6GB", "4GB"]:
                if token.lower() in ram_text.lower():
                    ram_val = float(re.search(r"\d+", token).group())
                    break
            features["ram_gb"] = (ram_val, ram_val is None)

            # Processor compute tier (Benefit - only if specified in specs)
            proc_text = specs.get("processor", "").lower()
            if proc_text:
                if any(x in proc_text for x in ["i9", "ryzen 9", "m3 max", "m3 pro", "ultra 9"]):
                    proc_tier = 5.0
                elif any(x in proc_text for x in ["i7", "ryzen 7", "m3", "ultra 7", "m2 pro"]):
                    proc_tier = 4.0
                elif any(x in proc_text for x in ["i5", "ryzen 5", "m2", "ultra 5", "tensor"]):
                    proc_tier = 3.0
                elif any(x in proc_text for x in ["i3", "ryzen 3", "m1", "snapdragon"]):
                    proc_tier = 2.0
                else:
                    proc_tier = 2.5
                features["processor_tier"] = (proc_tier, False)

            # GPU tier (Benefit - only if specified in specs)
            gpu_text = specs.get("gpu", "").lower()
            if gpu_text:
                if any(x in gpu_text for x in ["rtx 4080", "rtx 4090"]):
                    gpu_tier = 5.0
                elif any(x in gpu_text for x in ["rtx 4070", "rtx 4060"]):
                    gpu_tier = 4.0
                elif any(x in gpu_text for x in ["rtx 4050", "rtx 3050", "arc"]):
                    gpu_tier = 3.0
                elif any(x in gpu_text for x in ["m3", "apple gpu", "radeon"]):
                    gpu_tier = 3.0
                else:
                    gpu_tier = 1.5
                features["gpu_tier"] = (gpu_tier, False)

            # Battery hours / Wh
            batt_text = specs.get("battery", "")
            batt_val = None
            if "Wh" in batt_text:
                try:
                    num_str = batt_text.split("Wh")[0].strip().split()[-1]
                    batt_val = float(num_str)
                except Exception:
                    pass
            elif "hours" in batt_text.lower():
                try:
                    words = re.findall(r"\d+", batt_text)
                    if words:
                        batt_val = float(words[0]) * 5.0  # normalized scale
                except Exception:
                    pass
            elif "mah" in batt_text.lower():
                try:
                    words = re.findall(r"\d+", batt_text)
                    if words:
                        batt_val = float(words[0]) / 50.0  # scale for phones
                except Exception:
                    pass
            features["battery_capacity"] = (batt_val, batt_val is None)

            # Weight in kg (Cost - lower is better)
            weight_text = specs.get("weight", "")
            weight_val = None
            if "kg" in weight_text.lower():
                try:
                    weight_val = float(re.findall(r"[\d\.]+", weight_text)[0])
                except Exception:
                    pass
            elif "g" in weight_text.lower():
                try:
                    weight_val = float(re.findall(r"\d+", weight_text)[0]) / 1000.0
                except Exception:
                    pass
            features["weight_kg"] = (weight_val, weight_val is None)

        elif category == "footwear":
            weight_text = specs.get("weight", "")
            weight_val = None
            if "g" in weight_text.lower():
                try:
                    weight_val = float(re.findall(r"\d+", weight_text)[0])
                except Exception:
                    pass
            features["shoe_weight"] = (weight_val, weight_val is None)

            drop_text = specs.get("drop", "")
            drop_val = None
            if "mm" in drop_text.lower():
                try:
                    drop_val = float(re.findall(r"\d+", drop_text)[0])
                except Exception:
                    pass
            features["drop_mm"] = (drop_val, drop_val is None)

        elif category == "home_kitchen":
            cap_text = specs.get("capacity", "")
            cap_val = None
            for token in ["QT", "qt", "L", "Cup", "cup"]:
                if token in cap_text:
                    try:
                        cap_val = float(re.findall(r"[\d\.]+", cap_text)[0])
                        break
                    except Exception:
                        pass
            features["capacity"] = (cap_val, cap_val is None)

            watt_text = specs.get("wattage", "") or specs.get("heating", "")
            watt_val = None
            if "w" in watt_text.lower():
                try:
                    watt_val = float(re.findall(r"\d+", watt_text)[0])
                except Exception:
                    pass
            features["wattage"] = (watt_val, watt_val is None)

        elif category == "furniture":
            warranty_text = str(specs.get("warranty", ""))
            warranty_val = 1.0
            if "12" in warranty_text or "10" in warranty_text:
                warranty_val = 5.0
            elif "5" in warranty_text:
                warranty_val = 3.5
            features["warranty_years"] = (warranty_val, False)

        elif category == "fitness":
            batt_text = specs.get("battery", "")
            batt_days = None
            if "day" in batt_text.lower():
                try:
                    batt_days = float(re.findall(r"\d+", batt_text)[0])
                except Exception:
                    pass
            features["fitness_battery"] = (batt_days, batt_days is None)

        elif category == "education":
            latency_text = specs.get("latency", "")
            lat_val = None
            if "ms" in latency_text.lower():
                try:
                    lat_val = float(re.findall(r"\d+", latency_text)[0])
                except Exception:
                    pass
            # Lower latency is better (Cost criterion)
            features["stylus_latency"] = (lat_val, lat_val is None)

        elif category == "televisions":
            disp_text = specs.get("display", "").lower()
            screen_size = None
            size_m = re.search(r"(\d{2})\s*[-]?inch", disp_text)
            if size_m:
                screen_size = float(size_m.group(1))
            features["screen_size"] = (screen_size, screen_size is None)

            hz_m = re.search(r"(\d{2,3})\s*hz", disp_text)
            hz_val = float(hz_m.group(1)) if hz_m else 60.0
            features["refresh_rate"] = (hz_val, False)

            if "oled" in disp_text:
                disp_tier = 5.0
            elif "mini led" in disp_text:
                disp_tier = 4.5
            elif "qled" in disp_text:
                disp_tier = 3.8
            else:
                disp_tier = 3.0
            features["display_tier"] = (disp_tier, False)

            audio_text = specs.get("audio", "")
            watt_m = re.search(r"(\d+)\s*w", audio_text, re.IGNORECASE)
            watt_val = float(watt_m.group(1)) if watt_m else None
            features["audio_power"] = (watt_val, watt_val is None)

        elif category == "refrigerators":
            cap_text = specs.get("capacity", "")
            cap_m = re.search(r"(\d+)\s*l", cap_text, re.IGNORECASE)
            cap_val = float(cap_m.group(1)) if cap_m else None
            features["capacity_l"] = (cap_val, cap_val is None)

            star_text = specs.get("energy_rating", "") or specs.get("energy_efficiency", "")
            star_m = re.search(r"(\d)\s*star", star_text, re.IGNORECASE)
            star_val = float(star_m.group(1)) if star_m else 3.0
            features["energy_rating"] = (star_val, False)

        elif category == "washing_machines":
            cap_text = specs.get("capacity", "")
            cap_m = re.search(r"([\d\.]+)\s*kg", cap_text, re.IGNORECASE)
            cap_val = float(cap_m.group(1)) if cap_m else None
            features["capacity_kg"] = (cap_val, cap_val is None)

            rpm_text = specs.get("spin_speed", "")
            rpm_m = re.search(r"(\d+)\s*rpm", rpm_text, re.IGNORECASE)
            rpm_val = float(rpm_m.group(1)) if rpm_m else None
            features["spin_speed"] = (rpm_val, rpm_val is None)

            star_text = specs.get("energy_rating", "")
            star_m = re.search(r"(\d)\s*star", star_text, re.IGNORECASE)
            star_val = float(star_m.group(1)) if star_m else 5.0
            features["energy_rating"] = (star_val, False)

        elif category == "air_conditioners":
            ton_text = specs.get("capacity", "")
            ton_m = re.search(r"([\d\.]+)\s*ton", ton_text, re.IGNORECASE)
            ton_val = float(ton_m.group(1)) if ton_m else None
            features["tonnage"] = (ton_val, ton_val is None)

            cool_text = specs.get("cooling_capacity", "")
            cool_m = re.search(r"(\d+)\s*w", cool_text, re.IGNORECASE)
            cool_val = float(cool_m.group(1)) if cool_m else 4800.0
            features["cooling_power"] = (cool_val, False)

            star_text = specs.get("energy_rating", "")
            star_m = re.search(r"(\d)\s*star", star_text, re.IGNORECASE)
            star_val = float(star_m.group(1)) if star_m else 4.0
            features["energy_rating"] = (star_val, False)

        elif category == "tablets_monitors":
            disp_text = specs.get("display", "").lower()
            size_m = re.search(r"([\d\.]+)\s*[-]?inch", disp_text)
            size_val = float(size_m.group(1)) if size_m else None
            features["screen_size"] = (size_val, size_val is None)

            hz_m = re.search(r"(\d{2,3})\s*hz", disp_text)
            hz_val = float(hz_m.group(1)) if hz_m else 60.0
            features["refresh_rate"] = (hz_val, False)

        return features

    def compute_weights(
        self,
        criteria_keys: List[str],
        priorities: List[str],
        category: str
    ) -> Dict[str, float]:
        """
        Calculates normalized weights for criteria based on user priorities.
        Top user priority receives 2.5x base weight.
        Second priority receives 1.8x base weight.
        Third priority receives 1.4x base weight.
        """
        weights: Dict[str, float] = {k: 1.0 for k in criteria_keys}

        priority_map = {
            "performance": ["ram_gb", "processor_tier", "gpu_tier", "capacity", "wattage", "refresh_rate", "spin_speed", "cooling_power"],
            "battery": ["battery_capacity", "battery_mah", "fitness_battery"],
            "camera": ["camera_mp"],
            "display": ["display_tier", "screen_size", "refresh_rate"],
            "sound": ["audio_power"],
            "cooling": ["cooling_power", "tonnage"],
            "energy": ["energy_rating"],
            "capacity": ["capacity_l", "capacity_kg", "capacity"],
            "portability": ["weight_kg", "weight_g", "shoe_weight", "stylus_latency"],
            "ram": ["ram_gb", "storage_gb"],
            "value": ["price"],
            "comfort": ["shoe_weight", "drop_mm"],
            "durability": ["review_evidence", "warranty_years"],
            "build_quality": ["review_evidence", "warranty_years"]
        }

        mults = [2.5, 1.8, 1.4]
        for idx, prio in enumerate(priorities[:3]):
            mult = mults[idx]
            canon_prio = normalize_priority(prio)
            target_criteria = priority_map.get(canon_prio, [])
            for c in target_criteria:
                if c in weights:
                    weights[c] *= mult

        # Normalize weights so sum equals 1.0
        total_w = sum(weights.values())
        if total_w > 0:
            weights = {k: v / total_w for k, v in weights.items()}

        return weights

    def rank_products_topsis(
        self,
        products: List[Dict[str, Any]],
        category: str,
        priorities: Optional[List[str]] = None,
        intended_usages: Optional[List[str]] = None,
        min_budget: Optional[float] = None,
        max_budget: Optional[float] = None,
        optional_specs: Optional[Dict[str, Any]] = None,
        allow_budget_flexibility: bool = False,
        aspect_sentiments: Optional[Dict[str, Dict[str, float]]] = None
    ) -> Dict[str, Any]:
        """
        Performs TOPSIS multi-criteria decision analysis.
        Strictly applies hard budget constraints when allow_budget_flexibility=False.
        Generates explainable trade-offs and priority-focused rationale.
        """
        priorities = priorities or ["performance"]
        intended_usages = intended_usages or []
        optional_specs = optional_specs or {}
        aspect_sentiments = aspect_sentiments or {}

        if not products or len(products) == 0:
            return {
                "status": "error",
                "message": "No products provided for comparison.",
                "total_eligible": 0,
                "ranked_products": []
            }

        # Step 1: Strict Budget Filtering
        eligible_products = list(products)
        if not allow_budget_flexibility and max_budget and max_budget > 0:
            eligible_products = [
                p for p in products
                if float(p.get("price", 0)) <= float(max_budget)
            ]

        if not eligible_products:
            min_avail = min((float(p.get("price", 0)) for p in products if float(p.get("price", 0)) > 0), default=0)
            max_avail = max((float(p.get("price", 0)) for p in products), default=0)
            return {
                "status": "budget_exceeded",
                "message": (
                    f"All {len(products)} compared products exceed your strict maximum budget of ₹{max_budget:,.0f}. "
                    f"Available options range from ₹{min_avail:,.0f} to ₹{max_avail:,.0f}. "
                    "Adjust your budget ceiling or enable budget flexibility to view ranked comparisons."
                ),
                "total_eligible": 0,
                "ranked_products": []
            }

        if len(eligible_products) == 1:
            sole_prod = eligible_products[0]
            top_p = priorities[0] if priorities else "Performance"
            rec = {
                "product": sole_prod,
                "topsis_score": 1.0,
                "match_score": 95,
                "role": "BEST OVERALL MATCH",
                "role_tagline": "The only product in this comparison set that fully satisfies your strict budget ceiling.",
                "data_completeness": 1.0,
                "reasons": [
                    f"Directly fits within your designated budget ceiling of ₹{max_budget:,.0f}.",
                    f"Selected to satisfy your key priority of '{top_p}'."
                ],
                "tradeoffs": ["Sole eligible candidate under strict budget filter; no cheaper comparison alternatives."],
                "missing_attributes": []
            }
            return {
                "status": "success",
                "message": "1 product satisfied all hard constraints.",
                "total_eligible": 1,
                "ranked_products": [rec]
            }

        # Step 2: Extract criteria and build decision matrix
        extracted_data = []
        all_criteria_keys = set()
        missing_counts = {p["id"]: 0 for p in eligible_products}
        missing_attrs_by_id: Dict[str, List[str]] = {p["id"]: [] for p in eligible_products}

        for p in eligible_products:
            feats = self.extract_numerical_features(p, category)
            p_aspects = aspect_sentiments.get(p["id"], {})
            if p_aspects:
                avg_aspect_polarity = sum(p_aspects.values()) / max(len(p_aspects), 1)
                feats["aspect_sentiment"] = (avg_aspect_polarity, False)

            extracted_data.append((p, feats))
            all_criteria_keys.update(feats.keys())

            for crit_k, (val, is_m) in feats.items():
                if is_m or val is None:
                    missing_attrs_by_id[p["id"]].append(crit_k)

        criteria_list = sorted(list(all_criteria_keys))
        m = len(eligible_products)
        n = len(criteria_list)

        is_benefit_map = {
            "price": False,              # Cost criterion: lower is better
            "weight_kg": False,           # Cost: lighter is better
            "shoe_weight": False,         # Cost: lighter is better
            "stylus_latency": False,      # Cost: lower latency is better
            "rating": True,               # Benefit: higher is better
            "review_evidence": True,      # Benefit
            "ram_gb": True,               # Benefit
            "processor_tier": True,       # Benefit
            "gpu_tier": True,             # Benefit
            "battery_capacity": True,     # Benefit
            "fitness_battery": True,      # Benefit
            "drop_mm": True,              # Benefit
            "capacity": True,             # Benefit
            "wattage": True,              # Benefit
            "warranty_years": True,       # Benefit
            "aspect_sentiment": True      # Benefit
        }

        # Impute missing values with conservative penalty benchmark
        raw_matrix = np.zeros((m, n), dtype=float)
        for j, crit in enumerate(criteria_list):
            valid_vals = [feats[crit][0] for _, feats in extracted_data if feats.get(crit, (None, True))[0] is not None]
            is_benefit = is_benefit_map.get(crit, True)
            if valid_vals:
                if is_benefit:
                    # Conservative penalty: 80% of minimum observed valid value
                    col_impute = float(min(valid_vals)) * 0.8
                else:
                    # Conservative penalty: 120% of maximum observed valid value
                    col_impute = float(max(valid_vals)) * 1.2
            else:
                col_impute = 1.0

            for i, (p, feats) in enumerate(extracted_data):
                val, is_missing = feats.get(crit, (None, True))
                if is_missing or val is None:
                    raw_matrix[i, j] = col_impute
                    missing_counts[p["id"]] += 1
                else:
                    raw_matrix[i, j] = float(val)

        # Step 3: Vector Normalization
        norm_matrix = np.zeros_like(raw_matrix)
        for j in range(n):
            col_norm = np.linalg.norm(raw_matrix[:, j])
            if col_norm == 0 or np.all(raw_matrix[:, j] == raw_matrix[0, j]):
                norm_matrix[:, j] = 1.0 / math.sqrt(m)
            else:
                norm_matrix[:, j] = raw_matrix[:, j] / col_norm

        # Step 4: Apply User-Priority Weighted Normalization
        weights_dict = self.compute_weights(criteria_list, priorities, category)
        w_vector = np.array([weights_dict.get(c, 1.0 / n) for c in criteria_list])
        weighted_matrix = norm_matrix * w_vector

        # Step 5: Positive Ideal (A+) and Negative Ideal (A-)
        ideal_pos = np.zeros(n)
        ideal_neg = np.zeros(n)

        for j, crit in enumerate(criteria_list):
            is_benefit = is_benefit_map.get(crit, True)
            col = weighted_matrix[:, j]
            if is_benefit:
                ideal_pos[j] = np.max(col)
                ideal_neg[j] = np.min(col)
            else:
                ideal_pos[j] = np.min(col)
                ideal_neg[j] = np.max(col)

        # Step 6: Euclidean Distances S+ and S-
        s_pos = np.zeros(m)
        s_neg = np.zeros(m)

        for i in range(m):
            s_pos[i] = np.linalg.norm(weighted_matrix[i, :] - ideal_pos)
            s_neg[i] = np.linalg.norm(weighted_matrix[i, :] - ideal_neg)

        # Step 7: Relative Closeness C_i = S- / (S+ + S-)
        closeness = np.zeros(m)
        for i in range(m):
            denom = s_pos[i] + s_neg[i]
            closeness[i] = 0.5 if denom == 0 else s_neg[i] / denom

        # Step 8: Build Explainable Scored Output Items
        top_canon_prio = normalize_priority(priorities[0]) if priorities else "performance"
        top_raw_prio = priorities[0] if priorities else "Performance"

        # Benchmark prices & specs for dynamic trade-offs
        valid_prices = [float(p.get("price", 0)) for p in eligible_products if float(p.get("price", 0)) > 0]
        min_price = min(valid_prices) if valid_prices else 0.0
        cheapest_item = next((p for p in eligible_products if float(p.get("price", 0)) == min_price), None)

        valid_weights = [f.get("weight_kg", (None, True))[0] for _, f in extracted_data if f.get("weight_kg", (None, True))[0] is not None]
        min_weight = min(valid_weights) if valid_weights else None

        valid_batts = [f.get("battery_capacity", (None, True))[0] for _, f in extracted_data if f.get("battery_capacity", (None, True))[0] is not None]
        max_batt = max(valid_batts) if valid_batts else None

        scored_items = []
        for i, (p, feats) in enumerate(extracted_data):
            c_score = float(closeness[i])
            match_pct = int(min(99, max(65, round(c_score * 35.0 + 64.0))))
            comp_ratio = max(0.5, round(1.0 - (missing_counts[p["id"]] / max(n, 1)), 2))

            # Reasons formulation - STRICTLY focuses on selected priority
            reasons = []
            if top_canon_prio == "performance":
                reasons.append(f"Optimized for high-compute workloads matching your priority of '{top_raw_prio}'.")
                if p.get("specs", {}).get("processor"):
                    proc_short = p["specs"]["processor"].split("(")[0].strip()
                    reasons.append(f"Equipped with {proc_short} compute architecture.")
                elif p.get("specs", {}).get("ram"):
                    reasons.append(f"Provides {p['specs']['ram']} memory capacity for multitasking.")
            elif top_canon_prio == "battery":
                reasons.append(f"High endurance architecture matching your priority of '{top_raw_prio}'.")
                if p.get("specs", {}).get("battery"):
                    reasons.append(f"Verified {p['specs']['battery']} capacity minimizes charger dependency.")
            elif top_canon_prio == "value":
                reasons.append(f"Maximizes specification value per rupee for your '{top_raw_prio}' priority.")
                if float(p.get("price", 0)) == min_price:
                    reasons.append(f"Lowest financial commitment in this shootout at ₹{p['price']:,.0f}.")
            elif top_canon_prio == "portability":
                reasons.append(f"Lightweight chassis tailored for your '{top_raw_prio}' priority.")
                if p.get("specs", {}).get("weight"):
                    reasons.append(f"Weighs only {p['specs']['weight']}, designed for effortless commuting.")
            elif top_canon_prio == "comfort":
                reasons.append(f"Plush ergonomic engineering matching your '{top_raw_prio}' priority.")
                if p.get("specs", {}).get("midsole"):
                    reasons.append(f"Features {p['specs']['midsole'][:35]} shock-absorbing foam.")
            else:
                reasons.append(f"Demonstrates balanced alignment for your '{top_raw_prio}' priority.")

            # Add workflow fit if matching tags exist
            product_tags = p.get("intendedUsageTags", [])
            matched_usages = [u for u in intended_usages if u in product_tags]
            if matched_usages:
                reasons.append(f"Engineered for your workflow: {', '.join(u.replace('_', ' ').title() for u in matched_usages)}.")

            if not reasons:
                reasons.append("Balanced multi-attribute performance across all evaluation criteria.")

            # Dynamic Trade-Offs: where this product performs worse than competitors
            tradeoffs = []
            p_price = float(p.get("price", 0))
            if min_price > 0 and p_price > min_price:
                diff = p_price - min_price
                tradeoffs.append(f"Priced ₹{diff:,.0f} higher than lowest-cost alternative ({cheapest_item['name'] if cheapest_item else 'competitor'}).")

            p_weight = feats.get("weight_kg", (None, True))[0]
            if min_weight and p_weight and p_weight > min_weight + 0.1:
                tradeoffs.append(f"Heavier chassis ({p_weight:.2f} kg) compared to lighter {min_weight:.2f} kg options.")

            p_batt = feats.get("battery_capacity", (None, True))[0]
            if max_batt and p_batt and p_batt < max_batt * 0.85:
                tradeoffs.append("Competitors in this comparison offer longer estimated battery runtime.")

            if missing_attrs_by_id[p["id"]]:
                missing_labels = [c.replace("_", " ").title() for c in missing_attrs_by_id[p["id"]]]
                tradeoffs.append(f"Missing verified specifications: {', '.join(missing_labels[:3])}.")

            if not tradeoffs:
                tradeoffs.append("Maintains competitive parity with zero significant trade-off liabilities.")

            scored_items.append({
                "product": p,
                "topsis_score": round(c_score, 4),
                "match_score": match_pct,
                "distance_to_ideal": round(float(s_pos[i]), 4),
                "distance_to_anti_ideal": round(float(s_neg[i]), 4),
                "data_completeness": comp_ratio,
                "reasons": reasons[:3],
                "tradeoffs": tradeoffs[:3],
                "missing_attributes": missing_attrs_by_id[p["id"]]
            })

        # Sort descending by TOPSIS closeness
        scored_items.sort(key=lambda x: x["topsis_score"], reverse=True)
        recommendations = self._assign_topsis_roles(scored_items, top_raw_prio)

        return {
            "status": "success",
            "algorithm": "TOPSIS_MCDA_v1",
            "message": f"Successfully evaluated {len(eligible_products)} products using multi-criteria TOPSIS decision analysis.",
            "total_eligible": len(eligible_products),
            "ranked_products": recommendations
        }

    def _compute_spec_differences(self, product: Dict[str, Any], other_products: List[Dict[str, Any]]) -> List[str]:
        """
        Calculates concrete, factual specification differences comparing this product
        against other products in the shootout. Never invents data.
        """
        diffs = []
        p_name = product.get("name") or product.get("exact_model") or "This model"
        p_specs = product.get("specs") or product.get("specifications") or {}
        p_price = float(product.get("price", 0))

        for other in other_products:
            o_name = other.get("name") or other.get("exact_model") or "competitor"
            o_specs = other.get("specs") or other.get("specifications") or {}
            o_price = float(other.get("price", 0))

            # Price difference
            if p_price > 0 and o_price > 0 and p_price != o_price:
                diff_amount = abs(p_price - o_price)
                if p_price < o_price:
                    diffs.append(f"Priced ₹{diff_amount:,.0f} lower than {o_name}.")
                else:
                    diffs.append(f"Priced ₹{diff_amount:,.0f} higher than {o_name}.")

            # Processor difference
            p_proc = p_specs.get("processor")
            o_proc = o_specs.get("processor")
            if p_proc and o_proc and p_proc.strip().lower() != o_proc.strip().lower():
                p_p_short = p_proc.split("(")[0].strip()
                o_p_short = o_proc.split("(")[0].strip()
                diffs.append(f"Powered by {p_p_short} vs {o_p_short} in {o_name}.")

            # Camera difference
            p_cam = p_specs.get("camera")
            o_cam = o_specs.get("camera")
            if p_cam and o_cam and p_cam.strip().lower() != o_cam.strip().lower():
                diffs.append(f"Camera setup: {p_cam[:45]} vs {o_cam[:45]} in {o_name}.")

            # Battery difference
            p_batt = p_specs.get("battery")
            o_batt = o_specs.get("battery")
            if p_batt and o_batt and p_batt.strip().lower() != o_batt.strip().lower():
                diffs.append(f"Battery: {p_batt} vs {o_batt} in {o_name}.")

            # RAM & Storage
            p_ram = p_specs.get("ram")
            o_ram = o_specs.get("ram")
            p_storage = p_specs.get("storage")
            o_storage = o_specs.get("storage")
            if p_ram and o_ram and p_ram.strip().lower() != o_ram.strip().lower():
                diffs.append(f"RAM: {p_ram} vs {o_ram} in {o_name}.")
            if p_storage and o_storage and p_storage.strip().lower() != o_storage.strip().lower():
                diffs.append(f"Storage: {p_storage} vs {o_storage} in {o_name}.")

            # Display difference
            p_disp = p_specs.get("display")
            o_disp = o_specs.get("display")
            if p_disp and o_disp and p_disp.strip().lower() != o_disp.strip().lower():
                diffs.append(f"Display: {p_disp[:40]} vs {o_disp[:40]} in {o_name}.")

            # Only compare against first 2 competitors to keep diffs concise and actionable
            if len(diffs) >= 4:
                break

        return diffs[:5] if diffs else ["Maintains specification parity with compared models."]

    def _assign_topsis_roles(
        self,
        ranked_items: List[Dict[str, Any]],
        primary_priority: str = "Performance"
    ) -> List[Dict[str, Any]]:
        """
        Assigns distinct decision roles:
        1. BEST OVERALL MATCH: Highest TOPSIS relative closeness C_i.
        2. BEST VALUE: Optimal TOPSIS score-to-price ratio.
        3. BEST ALTERNATIVE: Highest scoring distinct runner-up.
        Also attaches factual spec differences and category-specific merit badges.
        """
        if not ranked_items:
            return []

        # Find specific leaders for merit badges
        best_cam_item_id = None
        best_batt_item_id = None
        best_perf_item_id = None

        if len(ranked_items) > 1:
            cam_candidates = []
            for it in ranked_items:
                cam_text = it["product"].get("specs", {}).get("camera", "")
                mps = re.findall(r"(\d+)\s*MP", cam_text, re.IGNORECASE)
                if mps:
                    cam_candidates.append((it["product"]["id"], max(int(m) for m in mps)))
            if cam_candidates:
                max_mp = max(c[1] for c in cam_candidates)
                top_cams = [c[0] for c in cam_candidates if c[1] == max_mp]
                if len(top_cams) == 1:
                    best_cam_item_id = top_cams[0]

            batt_candidates = []
            for it in ranked_items:
                batt_text = it["product"].get("specs", {}).get("battery", "")
                mahs = re.findall(r"(\d{3,5})\s*mAh", batt_text, re.IGNORECASE)
                if mahs:
                    batt_candidates.append((it["product"]["id"], max(int(m) for m in mahs)))
            if batt_candidates:
                max_mah = max(b[1] for b in batt_candidates)
                top_batts = [b[0] for b in batt_candidates if b[1] == max_mah]
                if len(top_batts) == 1:
                    best_batt_item_id = top_batts[0]

            perf_candidates = []
            for it in ranked_items:
                proc = it["product"].get("specs", {}).get("processor", "").lower()
                tier = 3.0
                if any(x in proc for x in ["snapdragon 8 elite", "m3 max", "i9", "rtx 4090"]):
                    tier = 5.5
                elif any(x in proc for x in ["snapdragon 8 gen 3", "a18 pro", "m3 pro", "i7"]):
                    tier = 5.0
                elif any(x in proc for x in ["a17 pro", "m3", "i5"]):
                    tier = 4.5
                perf_candidates.append((it["product"]["id"], tier))
            if perf_candidates:
                max_tier = max(p[1] for p in perf_candidates)
                top_perfs = [p[0] for p in perf_candidates if p[1] == max_tier]
                if len(top_perfs) == 1:
                    best_perf_item_id = top_perfs[0]

        recommendations = []

        # Role 1: BEST OVERALL MATCH
        best_overall = dict(ranked_items[0])
        best_overall["role"] = "BEST OVERALL MATCH"
        best_overall["role_tagline"] = f"Highest composite score across all criteria matching '{primary_priority}'."
        best_overall["important_differences"] = self._compute_spec_differences(best_overall["product"], [it["product"] for it in ranked_items[1:]])
        if best_perf_item_id == best_overall["product"]["id"]:
            best_overall["merit_badge"] = "BEST PERFORMANCE"
        elif best_cam_item_id == best_overall["product"]["id"]:
            best_overall["merit_badge"] = "BEST CAMERA"
        else:
            best_overall["merit_badge"] = "BEST OVERALL"
        recommendations.append(best_overall)

        if len(ranked_items) == 1:
            return recommendations

        # Role 2: BEST VALUE
        remaining = [item for item in ranked_items if item["product"]["id"] != best_overall["product"]["id"]]
        if not remaining and len(ranked_items) > 1:
            remaining = [dict(ranked_items[1])]

        def value_metric(item):
            price = max(float(item["product"].get("price", 1)), 1.0)
            return item["topsis_score"] / price

        if remaining:
            best_value_item = dict(max(remaining, key=value_metric))
            best_value_item["role"] = "BEST VALUE"
            best_value_item["role_tagline"] = f"Optimal specification-per-rupee ratio, priced at ₹{best_value_item['product'].get('price', 0):,.0f}."
            best_value_item["important_differences"] = self._compute_spec_differences(
                best_value_item["product"],
                [it["product"] for it in ranked_items if it["product"]["id"] != best_value_item["product"]["id"]]
            )
            best_value_item["merit_badge"] = "BEST VALUE"
            recommendations.append(best_value_item)

        if len(remaining) <= 1:
            return recommendations

        # Role 3: BEST ALTERNATIVE
        chosen_ids = {best_overall["product"]["id"], best_value_item["product"]["id"]}
        alternatives = [item for item in ranked_items if item["product"]["id"] not in chosen_ids]
        if not alternatives and len(ranked_items) > 2:
            alternatives = [dict(ranked_items[2])]

        if alternatives:
            best_alt = dict(alternatives[0])
            best_alt["role"] = "BEST ALTERNATIVE"
            best_alt["role_tagline"] = "Compelling alternative offering a distinct hardware balance or form factor."
            best_alt["important_differences"] = self._compute_spec_differences(
                best_alt["product"],
                [it["product"] for it in ranked_items if it["product"]["id"] != best_alt["product"]["id"]]
            )
            if best_cam_item_id == best_alt["product"]["id"]:
                best_alt["merit_badge"] = "BEST CAMERA"
            elif best_batt_item_id == best_alt["product"]["id"]:
                best_alt["merit_badge"] = "BEST BATTERY"
            elif best_perf_item_id == best_alt["product"]["id"]:
                best_alt["merit_badge"] = "BEST PERFORMANCE"
            else:
                best_alt["merit_badge"] = "BEST ALTERNATIVE"
            recommendations.append(best_alt)

        return recommendations

    def rank_products_for_comparison(
        self,
        products: List[Dict[str, Any]],
        category: str,
        priorities: Optional[List[str]] = None,
        weights: Optional[Dict[str, float]] = None
    ) -> List[Dict[str, Any]]:
        """Convenience method returning ranked recommendations list directly."""
        res = self.rank_products_topsis(products, category, priorities or ["performance"])
        ranked = res.get("ranked_products", [])
        for idx, item in enumerate(ranked):
            item["rank"] = idx + 1
        return ranked

"""
WORTHLY - Aspect-Based Sentiment Analysis (ABSA) Engine
Extracts aspect-level sentiment from product reviews using sentence boundary detection,
aspect-phrase mapping, negation scope handling, and polarity scoring.
"""

from typing import List, Dict, Any, Optional, Tuple
import re
import hashlib

# Standardized Category Aspect Vocabularies
CATEGORY_ASPECT_MAP = {
    "electronics": {
        "battery": ["battery life", "battery", "charger", "charging", "endurance", "runtime", "drain", "drains"],
        "performance": ["heavy containerization", "performance", "speed", "processor", "cpu", "gpu", "compute", "docker", "ide", "rendering", "fps", "lag-free", "lag", "multitasking", "ram", "rtx", "power"],
        "display": ["display colors", "display", "screen", "colors", "brightness", "panel", "resolution", "oled", "16:10", "refresh rate", "hz", "crisp"],
        "camera": ["camera quality", "camera", "webcam", "lens", "photo", "photos", "video call"],
        "build_quality": ["build quality", "aluminum build", "chassis", "aluminum", "metal", "palm rest", "keyboard", "trackpad", "hinge", "durability", "finish", "unibody"],
        "thermals": ["spool up", "fans spool up", "fan", "fans", "heat", "hot", "thermal", "cooling", "noise", "silent", "fanless", "spool"],
        "value": ["value for money", "value", "price", "rupee", "rupees", "dollar", "worth", "expensive", "affordable", "deal"]
    },
    "footwear": {
        "comfort": ["plush comfort", "comfort", "cushioning", "cushion", "bounce", "foam", "reactx", "soft", "step-in", "shock-absorbing", "midsole", "plush", "pain"],
        "durability": ["outsole tread", "durability", "durable", "outsole", "tread", "wear", "miles", "rubber", "hardwearing", "sole"],
        "fit": ["too narrow", "snug", "fit", "sizing", "wide", "narrow", "heel", "toe box", "true to size", "slippage", "size"],
        "weight": ["lightweight mesh", "weight", "heavy", "lightweight", "featherlight", "bulk"],
        "breathability": ["breathable", "mesh", "ventilation", "sweat", "hot"],
        "value": ["value", "price", "rupee", "rupees", "worth", "cost"]
    },
    "home_kitchen": {
        "cooking_performance": ["cooking", "crispy", "fry", "fried", "espresso", "crema", "coffee", "bake", "blend", "heating", "temperature"],
        "ease_of_cleaning": ["cleaning", "clean", "dishwasher safe", "dishwasher", "wash", "maintenance", "non-stick basket", "non-stick", "basket"],
        "capacity": ["capacity", "size", "quart", "liters", "family", "portion", "footprint"],
        "noise": ["fan noise", "noise", "loud", "quiet", "silent", "sound", "hum"],
        "build_quality": ["build quality", "stainless steel", "sturdy", "finish"],
        "value": ["value", "price", "rupee", "rupees", "worth", "cost"]
    },
    "furniture": {
        "ergonomics": ["ergonomic", "ergonomics", "lumbar support", "lumbar", "posture", "back", "spine", "support", "comfort"],
        "adjustability": ["adjustability", "adjustable", "height", "armrest", "tilt", "recline", "motors"],
        "build_quality": ["build quality", "sturdy build", "sturdy", "sturdiness", "wobble", "durability", "weight limit", "frame", "steel"],
        "assembly": ["assembly", "assemble", "instructions", "tools", "setup", "parts"],
        "value": ["value", "price", "rupee", "rupees", "worth", "warranty"]
    },
    "fitness": {
        "sensor_accuracy": ["accuracy", "sensor", "gps", "heart rate", "gnss", "pacing", "tracking", "metrics"],
        "battery_life": ["battery life", "battery", "days", "charging", "endurance"],
        "durability": ["durability", "sweat", "water resistant", "waterproof", "build", "rugged"],
        "software_app": ["app", "sync", "subscription", "ecosystem", "software", "bluetooth"],
        "value": ["value", "price", "rupee", "rupees", "worth"]
    },
    "education": {
        "writing_feel": ["writing feel", "writing", "stylus", "paper feel", "latency", "pen", "handwritten", "sketching", "markup"],
        "display": ["display", "screen", "e-ink", "glare", "anti-glare", "eye strain", "reading"],
        "battery_life": ["battery life", "battery", "weeks", "charging", "endurance"],
        "portability": ["portability", "lightweight", "thin", "slim", "backpack", "weight"],
        "value": ["value", "price", "rupee", "student", "worth"]
    }
}

# Polarity Lexicons
POSITIVE_TERMS = {
    "excellent", "great", "good", "amazing", "crisp", "fast", "smooth",
    "comfortable", "plush", "bounce", "bouncy", "sturdy", "quiet", "silent",
    "reliable", "heavyweight", "lag-free", "featherlight", "superb", "durable",
    "responsive", "flawless", "impressive", "long-lasting", "loved", "best",
    "sharp", "vibrant", "solid", "seamless", "godsend", "top-tier", "plenty",
    "ergonomic", "breezy", "breathtaking", "punchy", "generous", "safe"
}

NEGATIVE_TERMS = {
    "slow", "slowdown", "slowdowns", "poor", "bad", "terrible", "drains", "draining", "drain",
    "noisy", "loud", "bulky", "hot", "overheating", "overheat", "too narrow", "narrow",
    "cramped", "stiff", "flimsy", "expensive", "blurry", "disappointing",
    "subpar", "sluggish", "rattles", "uncomfortable", "annoying", "struggles",
    "tight", "short", "drab", "fragile", "painful", "horrible", "awful",
    "waste", "failed", "broke", "glitchy", "lacks", "lacking", "sweat"
}

NEGATION_TERMS = {
    "not", "no", "never", "hardly", "barely", "scarcely", "without",
    "doesn't", "don't", "didn't", "isn't", "wasn't", "won't", "wouldn't",
    "cannot", "can't", "neither", "nor", "zero", "prevents", "prevent"
}

CONTRASTIVE_CONJUNCTIONS = {"but", "however", "although", "though", "yet", "whereas", "except"}


class ABSAEngine:
    def __init__(self):
        pass

    def split_into_clauses_and_sentences(self, text: str) -> List[str]:
        """
        Splits text into fine-grained clauses separated by periods, semicolons,
        exclamation points, question marks, and contrastive conjunctions.
        """
        if not text:
            return []

        # First split into sentences
        sentences = re.split(r"[.!?;\n]+", text)
        clauses = []

        for s in sentences:
            s_clean = s.strip()
            if not s_clean:
                continue

            # Split sentence further on contrastive conjunctions if present
            # e.g., "The camera is great, but the battery drains quickly"
            pattern = r"\b(" + "|".join(CONTRASTIVE_CONJUNCTIONS) + r")\b"
            sub_clauses = re.split(pattern, s_clean, flags=re.IGNORECASE)
            
            accum = ""
            for sub in sub_clauses:
                if sub.lower() in CONTRASTIVE_CONJUNCTIONS:
                    if accum.strip():
                        clauses.append(accum.strip())
                    accum = ""
                else:
                    accum += " " + sub
            if accum.strip():
                clauses.append(accum.strip())

        return [c for c in clauses if len(c) > 3]

    def extract_aspects_from_clause(
        self,
        clause: str,
        category: str
    ) -> List[Tuple[str, str]]:
        """
        Identifies which aspects are explicitly referenced in a clause.
        Returns list of (aspect_name, matched_token).
        """
        vocab = CATEGORY_ASPECT_MAP.get(category, CATEGORY_ASPECT_MAP["electronics"])
        clause_lower = clause.lower()
        matched = []

        for aspect_name, keywords in vocab.items():
            for kw in keywords:
                # Whole word match
                pattern = r"\b" + re.escape(kw) + r"\b"
                if re.search(pattern, clause_lower):
                    matched.append((aspect_name, kw))
                    break # one keyword match per aspect is sufficient for clause

        return matched

    def score_clause_sentiment(self, clause: str) -> Tuple[str, float, float]:
        """
        Calculates polarity and confidence for a clause considering negation.
        Returns: (polarity_label: 'positive' | 'negative' | 'neutral', polarity_score: [-1.0, 1.0], confidence: [0.0, 1.0])
        """
        tokens = re.findall(r"\b[\w'-]+\b", clause.lower())
        if not tokens:
            return "neutral", 0.0, 0.0

        pos_count = 0
        neg_count = 0
        negation_active = False
        negation_window = 0

        for tok in tokens:
            if tok in NEGATION_TERMS:
                negation_active = True
                negation_window = 3 # negate next 3 tokens
                continue

            is_pos = tok in POSITIVE_TERMS
            is_neg = tok in NEGATIVE_TERMS

            if is_pos:
                if negation_active:
                    neg_count += 1.2
                else:
                    pos_count += 1.0
            elif is_neg:
                if negation_active:
                    pos_count += 0.8
                else:
                    neg_count += 1.0

            if negation_window > 0:
                negation_window -= 1
                if negation_window == 0:
                    negation_active = False

        diff = pos_count - neg_count
        total_eval = pos_count + neg_count

        if total_eval == 0:
            return "neutral", 0.0, 0.50

        # Polarity score normalized [-1.0, 1.0]
        polarity_score = round(diff / total_eval, 3)

        if polarity_score > 0.15:
            label = "positive"
        elif polarity_score < -0.15:
            label = "negative"
        else:
            label = "neutral"

        # Confidence estimation based on evidence strength
        confidence = round(min(0.95, 0.60 + (total_eval * 0.15)), 2)

        return label, polarity_score, confidence

    def analyze_review_aspects(
        self,
        review_text: str,
        category: str,
        pros_text: Optional[str] = None,
        cons_text: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Analyzes a single review text (along with optional pros/cons fields).
        Returns a structured list of aspect detections with evidence citations.
        """
        results = []
        clauses = self.split_into_clauses_and_sentences(review_text)

        for cl in clauses:
            aspects_found = self.extract_aspects_from_clause(cl, category)
            if not aspects_found:
                continue

            label, score, conf = self.score_clause_sentiment(cl)
            for asp, kw in aspects_found:
                results.append({
                    "aspect": asp,
                    "matched_keyword": kw,
                    "polarity": label,
                    "polarity_score": score,
                    "confidence": conf,
                    "evidence_snippet": cl.strip(),
                    "source": "review_body"
                })

        # Also incorporate pros/cons structured fields if provided
        if pros_text:
            pro_aspects = self.extract_aspects_from_clause(pros_text, category)
            for asp, kw in pro_aspects:
                results.append({
                    "aspect": asp,
                    "matched_keyword": kw,
                    "polarity": "positive",
                    "polarity_score": 1.0,
                    "confidence": 0.90,
                    "evidence_snippet": pros_text.strip(),
                    "source": "explicit_pros"
                })

        if cons_text:
            con_aspects = self.extract_aspects_from_clause(cons_text, category)
            for asp, kw in con_aspects:
                results.append({
                    "aspect": asp,
                    "matched_keyword": kw,
                    "polarity": "negative",
                    "polarity_score": -1.0,
                    "confidence": 0.90,
                    "evidence_snippet": cons_text.strip(),
                    "source": "explicit_cons"
                })

        return results

    def aggregate_product_aspect_sentiments(
        self,
        reviews: List[Dict[str, Any]],
        category: str
    ) -> Dict[str, Dict[str, Any]]:
        """
        Aggregates aspect sentiment mentions across multiple reviews for a product.
        Returns:
        {
           'battery': {
               'positive_count': 5,
               'negative_count': 1,
               'neutral_count': 0,
               'net_polarity': 0.67,
               'confidence': 0.88,
               'sample_excerpts': [...]
           }, ...
        }
        """
        # Deduplicate reviews by text hash
        seen_hashes = set()
        unique_reviews = []
        for r in reviews:
            text = r.get("reviewText", "").strip()
            if not text:
                continue
            h = hashlib.sha256(text.encode("utf-8")).hexdigest()
            if h not in seen_hashes:
                seen_hashes.add(h)
                unique_reviews.append(r)

        aspect_buckets: Dict[str, List[Dict[str, Any]]] = {}

        for r in unique_reviews:
            dets = self.analyze_review_aspects(
                review_text=r.get("reviewText", ""),
                category=category,
                pros_text=r.get("pros"),
                cons_text=r.get("cons")
            )
            for d in dets:
                asp = d["aspect"]
                if asp not in aspect_buckets:
                    aspect_buckets[asp] = []
                aspect_buckets[asp].append(d)

        aggregated: Dict[str, Dict[str, Any]] = {}
        for asp, mentions in aspect_buckets.items():
            pos = sum(1 for m in mentions if m["polarity"] == "positive")
            neg = sum(1 for m in mentions if m["polarity"] == "negative")
            neu = sum(1 for m in mentions if m["polarity"] == "neutral")
            total = len(mentions)

            # Polarity score [-1.0, 1.0]
            net_polarity = round((pos - neg) / max(total, 1), 2)
            # Confidence grows with sample volume
            conf = round(min(0.98, 0.65 + (total * 0.05)), 2)

            # Collect diverse evidence excerpts
            excerpts = []
            seen_excerpts = set()
            for m in mentions:
                snip = m["evidence_snippet"]
                if snip not in seen_excerpts:
                    seen_excerpts.add(snip)
                    excerpts.append({
                        "polarity": m["polarity"],
                        "text": snip
                    })
                if len(excerpts) >= 3:
                    break

            aggregated[asp] = {
                "aspect": asp,
                "total_mentions": total,
                "positive_count": pos,
                "negative_count": neg,
                "neutral_count": neu,
                "polarity_score": net_polarity,
                "confidence": conf,
                "sample_excerpts": excerpts
            }

        return aggregated

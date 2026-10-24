"""
WORTHLY - Category Validator & URL Inspection Module
Provides deterministic URL validation, SSRF protection, retailer domain handling,
safe redirect resolution for shortened URLs, metadata extraction, exact catalog matching,
and cross-category/cross-subcategory validation.
"""

from typing import List, Dict, Any, Optional, Tuple
import re
import ipaddress
import socket
import urllib.request
import urllib.error
from urllib.parse import urlparse, parse_qs, urlencode, urlunparse

# Safe retail and tech domains known for consumer products
SUPPORTED_DOMAINS = {
    "amazon.in", "amazon.com", "flipkart.com", "dell.com", "apple.com",
    "lenovo.com", "asus.com", "acer.com", "sony.co.in", "sony.com",
    "nike.com", "brooksrunning.com", "brooksrunningindia.com", "newbalance.com",
    "newbalance.co.in", "clarks.in", "asics.com", "ninjakitchen.com", "ninjakitchen.in",
    "breville.com", "roborock.com", "roborockindia.com", "philips.co.in",
    "hermanmiller.com", "flexispot.com", "flexispot.in", "steelcase.com", "autonomous.ai",
    "garmin.com", "garmin.co.in", "bowflex.com", "bowflex.in", "fitbit.com",
    "remarkable.com", "soundcore.in", "samsung.com", "hp.com", "oneplus.in",
    "mi.com", "motorola.in", "oreilly.com", "nostarch.com", "mitpress.mit.edu",
    "wiley.com", "mheducation.co.in", "pearson.com", "madeeasypublications.org",
    "technologyreview.com", "wired.com", "scientificamerican.com", "hbr.org",
    "nationalgeographic.com", "bloomberg.com", "fastcompany.com", "digit.in",
    "bose.com", "logitech.com", "lg.com", "jbl.com", "marshallheadphones.com",
    "boldfit.in", "manduka.com", "liforme.com", "slovic.in", "korefit.in",
    "lifelongindiaonline.com", "burnlab.co", "cockatooindia.com", "faberindia.com",
    "elica.in", "hindwareappliances.com", "glenindia.com", "inalsaappliances.com",
    "optimumnutrition.com", "muscleblaze.com", "dymatize.com", "cosmix.in",
    "oziva.in", "theisopurecompany.com"
}

# Whitelist of trusted shortened retailer link domains
SHORTENED_DOMAINS = {
    "amzn.to", "amzn.eu", "a.co", "fkrt.it", "tinyurl.com", "bit.ly"
}

# Tracking parameters to strip
TRACKING_PARAMS = {
    "utm_source", "utm_medium", "utm_campaign", "utm_term", "utm_content",
    "gclid", "fbclid", "ref", "tag", "ref_", "pf_rd_r", "pf_rd_p", "pd_rd_r",
    "pd_rd_w", "pd_rd_wg", "qid", "sr", "linkCode", "camp", "creative"
}

# Product Subcategories Taxonomy
PRODUCT_SUBCATEGORIES = {
    "electronics": {
        "laptops": {
            "label": "Laptops & Notebooks",
            "keywords": ["laptop", "notebook", "xps", "macbook", "zenbook", "legion", "aspire", "thinkpad", "ideapad", "ultrabook"],
            "criteria": ["processor", "ram", "storage", "gpu", "display", "battery", "weight"]
        },
        "smartphones": {
            "label": "Smartphones & Mobile Phones",
            "keywords": ["phone", "iphone", "galaxy", "pixel", "oneplus", "smartphone", "mobile"],
            "criteria": ["processor", "ram", "storage", "camera", "display", "battery"]
        },
        "headphones": {
            "label": "Audio & Headphones",
            "keywords": ["headphone", "headphones", "earphone", "earbuds", "wh-1000xm", "anc", "audio", "airpods", "headband"],
            "criteria": ["driver", "battery", "anc", "weight", "bluetooth"]
        }
    },
    "footwear": {
        "running_shoes": {
            "label": "Running & Athletic Shoes",
            "keywords": ["running", "pegasus", "ghost", "road running", "marathon", "training shoe"],
            "criteria": ["midsole", "drop", "weight", "outsole"]
        },
        "casual_sneakers": {
            "label": "Casual & Lifestyle Sneakers",
            "keywords": ["sneaker", "sneakers", "574", "lifestyle", "campus", "court shoe"],
            "criteria": ["upper", "midsole", "weight", "closure"]
        },
        "formal_shoes": {
            "label": "Formal & Dress Shoes",
            "keywords": ["oxford", "derby", "tilden", "formal", "dress shoe", "loafers"],
            "criteria": ["upper", "insole", "outsole", "heel_height"]
        }
    },
    "home_kitchen": {
        "air_fryers": {
            "label": "Air Fryers & Cookers",
            "keywords": ["air fryer", "fryer", "af101", "pressure cooker"],
            "criteria": ["capacity", "wattage", "temp_range", "functions"]
        },
        "coffee_makers": {
            "label": "Espresso & Coffee Machines",
            "keywords": ["espresso", "coffee", "barista", "latte"],
            "criteria": ["grinder", "heating", "water_tank", "steaming"]
        },
        "robot_vacuums": {
            "label": "Robot Vacuums & Mops",
            "keywords": ["vacuum", "revo", "roborock", "mop", "robotic vacuum"],
            "criteria": ["suction", "dock", "navigation", "battery"]
        }
    },
    "furniture": {
        "office_chairs": {
            "label": "Ergonomic Office Chairs",
            "keywords": ["chair", "aeron", "mesh", "lumbar", "desk chair"],
            "criteria": ["material", "lumbar", "adjustments", "warranty"]
        },
        "standing_desks": {
            "label": "Standing Desks & Workstations",
            "keywords": ["desk", "standing desk", "e7", "height adjustable", "sit stand"],
            "criteria": ["motors", "height_range", "weight_capacity", "frame"]
        }
    },
    "fitness": {
        "smartwatches": {
            "label": "GPS Watches & Fitness Trackers",
            "keywords": ["smartwatch", "forerunner", "gps watch", "tracker", "fitbit"],
            "criteria": ["display", "battery", "sensors", "water_rating"]
        },
        "strength_equipment": {
            "label": "Dumbbells & Strength Equipment",
            "keywords": ["dumbbell", "selecttech", "weight", "barbell", "bench"],
            "criteria": ["weight_range", "mechanism", "dimensions"]
        }
    },
    "education": {
        "tablets": {
            "label": "Digital Paper & Tablets",
            "keywords": ["tablet", "remarkable", "ipad", "e-ink", "digital paper"],
            "criteria": ["display", "latency", "battery", "storage"]
        },
        "headphones": {
            "label": "Study & ANC Headphones",
            "keywords": ["headphone", "space one", "anc", "earphone"],
            "criteria": ["noise_cancellation", "battery", "weight"]
        }
    }
}

# Category Keyword Taxonomies for fallback text inference
CATEGORY_KEYWORD_RULES = {
    "electronics": {
        "strong": [
            "laptop", "macbook", "ultrabook", "notebook", "thinkpad", "ideapad",
            "xps", "legion", "zenbook", "vivobook", "predator", "swift",
            "gaming laptop", "intel core", "ryzen", "rtx 40", "rtx 30"
        ],
        "general": [
            "computer", "desktop", "gpu", "processor", "ram", "ssd",
            "headphone", "earphone", "earbuds", "audio", "oled display", "smartphone"
        ],
        "negative": ["shoe", "sneaker", "chair", "desk", "coffee", "fryer", "treadmill"]
    },
    "footwear": {
        "strong": [
            "running shoes", "sneakers", "running shoe", "road running", "marathon shoes",
            "pegasus", "ghost 16", "adizero", "air max", "cushioned shoe",
            "running-shoes", "footwear", "oxford shoe", "derby shoe"
        ],
        "general": [
            "shoe", "shoes", "sneaker", "boots", "loafers", "trainers", "outsole", "midsole"
        ],
        "negative": ["laptop", "desk", "fryer", "table", "chair", "processor"]
    },
    "home_kitchen": {
        "strong": [
            "air fryer", "espresso machine", "coffee machine", "robot vacuum",
            "blender", "food processor", "convection oven", "dishwasher"
        ],
        "general": [
            "kitchen", "cookware", "kettle", "toaster", "toaster oven", "cooktop",
            "breville", "ninja foodi", "roborock"
        ],
        "negative": ["laptop", "shoes", "sneakers", "desk", "treadmill"]
    },
    "furniture": {
        "strong": [
            "ergonomic chair", "standing desk", "office chair", "mesh chair",
            "aeron", "embody", "height adjustable desk", "electric standing desk"
        ],
        "general": [
            "desk", "chair", "workstation", "table", "lumbar support", "armrest"
        ],
        "negative": ["laptop", "running shoes", "coffee", "fryer"]
    },
    "fitness": {
        "strong": [
            "smartwatch", "fitness tracker", "gps watch", "treadmill",
            "adjustable dumbbells", "forerunner", "heart rate monitor"
        ],
        "general": [
            "fitness", "dumbbell", "barbell", "workout", "exercise", "weight bench"
        ],
        "negative": ["laptop", "desk", "fryer", "office chair"]
    },
    "education": {
        "strong": [
            "paper tablet", "digital notepad", "e-ink tablet", "remarkable",
            "paper-like display", "digital paper", "reading tablet"
        ],
        "general": [
            "e-reader", "stylus", "e-ink", "kindle", "handwritten notes", "pdf reader"
        ],
        "negative": ["running shoe", "air fryer", "gaming laptop", "espresso"]
    }
}


def is_safe_destination(hostname: str) -> Tuple[bool, Optional[str]]:
    """
    SSRF Protection: Checks if a hostname resolves to private, loopback,
    reserved, or link-local IP addresses.
    """
    if not hostname:
        return False, "Empty hostname"

    lower_host = hostname.lower().strip()

    # Block well-known unsafe names
    if lower_host in {"localhost", "loopback", "metadata.google.internal"} or lower_host.endswith(".local") or lower_host.endswith(".internal"):
        return False, f"Destination '{lower_host}' is blocked for security (local/internal host)."

    try:
        # Check if hostname itself is directly an IP literal
        ip = ipaddress.ip_address(lower_host)
        # Cloud Metadata check (169.254.169.254)
        if str(ip) == "169.254.169.254":
            return False, "Access to cloud metadata address is forbidden."
        if ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved or ip.is_multicast:
            return False, f"Direct access to private or local IP {ip} is forbidden."
        return True, None
    except ValueError:
        # It is a domain name, resolve via DNS
        pass

    try:
        try:
            addr_info = socket.getaddrinfo(lower_host, None)
        except socket.gaierror:
            if lower_host.startswith("www."):
                addr_info = socket.getaddrinfo(lower_host[4:], None)
            else:
                raise
        for family, _, _, _, sockaddr in addr_info:
            ip_str = sockaddr[0]
            ip = ipaddress.ip_address(ip_str)
            if ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved or ip.is_multicast:
                return False, f"Hostname '{lower_host}' resolves to forbidden private/local IP {ip}."
            if str(ip) == "169.254.169.254":
                return False, f"Hostname '{lower_host}' resolves to forbidden metadata IP {ip}."
    except socket.gaierror:
        return False, f"Could not resolve hostname '{lower_host}'."
    except Exception as e:
        return False, f"Network validation error for '{lower_host}': {str(e)}"

    return True, None


def normalize_and_clean_url(raw_url: str) -> Tuple[Optional[str], Optional[str]]:
    """
    Validates URL syntax, enforces HTTP/HTTPS, strips tracking parameters.
    Returns (cleaned_url, error_message).
    """
    if not raw_url or not isinstance(raw_url, str):
        return None, "Empty or invalid URL provided."

    raw_url = raw_url.strip()
    if not raw_url.startswith(("http://", "https://")):
        raw_url = "https://" + raw_url

    try:
        parsed = urlparse(raw_url)
    except Exception as e:
        return None, f"Malformed URL syntax: {str(e)}"

    if parsed.scheme.lower() not in {"http", "https"}:
        return None, f"Unsupported URL scheme '{parsed.scheme}'. Only HTTPS/HTTP are permitted."

    if not parsed.netloc:
        return None, "URL must contain a valid domain name."

    # Enforce HTTPS where possible
    scheme = "https" if parsed.scheme.lower() == "https" else "http"
    hostname = parsed.hostname or ""

    # SSRF Check
    safe, reason = is_safe_destination(hostname)
    if not safe:
        return None, reason

    # Strip tracking query params
    query_params = parse_qs(parsed.query, keep_blank_values=False)
    cleaned_params = {
        k: v for k, v in query_params.items()
        if k.lower() not in TRACKING_PARAMS
    }

    new_query = urlencode(cleaned_params, doseq=True)
    norm_path = re.sub(r"/+", "/", parsed.path)

    cleaned = urlunparse((
        scheme,
        parsed.netloc.lower(),
        norm_path,
        "",
        new_query,
        ""  # strip fragments
    ))

    return cleaned, None


def resolve_shortened_retailer_url(raw_url: str) -> Tuple[Optional[str], Optional[str]]:
    """
    Restricted and secure redirect resolution for trusted shortened retailer links (e.g. amzn.to).
    Enforces SSRF check on every hop, maximum 3 hops, 2.5s socket timeout, and 0-byte body limit.
    """
    cleaned, err = normalize_and_clean_url(raw_url)
    if err or not cleaned:
        return None, err or "Invalid shortened URL."

    parsed = urlparse(cleaned)
    host = (parsed.hostname or "").lower()

    # Domain check against shortened whitelist
    if not any(host == d or host.endswith("." + d) for d in SHORTENED_DOMAINS):
        return cleaned, None  # Not a shortened link, keep cleaned URL

    current_url = cleaned
    max_hops = 3

    for hop in range(max_hops):
        cur_parsed = urlparse(current_url)
        cur_host = cur_parsed.hostname or ""
        safe, reason = is_safe_destination(cur_host)
        if not safe:
            return None, f"Security violation at redirect hop {hop + 1}: {reason}"

        # Setup restricted HTTP HEAD / GET without body download
        class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
            def redirect_request(self, req, fp, code, msg, headers, newurl):
                return None  # Do not auto-follow redirects; handle manually

        opener = urllib.request.build_opener(NoRedirectHandler)
        req = urllib.request.Request(
            current_url,
            headers={"User-Agent": "WORTHLY-Verifier/1.0 (+https://worthly.internal)"},
            method="HEAD"
        )

        try:
            with opener.open(req, timeout=2.5) as resp:
                # If 200 OK without redirect, reached final destination
                return current_url, None
        except urllib.error.HTTPError as e:
            if e.code in (301, 302, 303, 307, 308):
                location = e.headers.get("Location")
                if not location:
                    return None, f"Shortened link returned {e.code} with no Location header."

                # Handle relative redirect locations
                if location.startswith("/"):
                    location = f"{cur_parsed.scheme}://{cur_parsed.netloc}{location}"

                loc_parsed = urlparse(location)
                loc_host = loc_parsed.hostname or ""
                loc_safe, loc_reason = is_safe_destination(loc_host)
                if not loc_safe:
                    return None, f"Shortened redirect resolves to unsafe destination '{loc_host}': {loc_reason}"

                cleaned_loc, loc_err = normalize_and_clean_url(location)
                if loc_err or not cleaned_loc:
                    return None, f"Malformed redirect destination: {loc_err}"

                current_url = cleaned_loc

                # If destination is no longer a shortened link, we reached target retailer!
                dest_host = (loc_parsed.hostname or "").lower()
                if not any(dest_host == d or dest_host.endswith("." + d) for d in SHORTENED_DOMAINS):
                    return current_url, None
            else:
                return None, f"Shortened URL returned unexpected status {e.code}."
        except socket.timeout:
            return None, "Shortened URL redirect resolution timed out (2.5s limit)."
        except Exception as ex:
            return None, f"Redirect resolution failed: {str(ex)}"

    return None, "Redirect loop or exceeded maximum 3 hops without reaching final product URL."


def infer_subcategory(product_data: Dict[str, Any], category: Optional[str] = None) -> Tuple[str, str]:
    """
    Deterministically identifies product subcategory and display label.
    """
    if product_data.get("subcategory") and product_data.get("subcategory") != "general":
        subcat_key = product_data["subcategory"]
        label = product_data.get("subcategory_label") or subcat_key.replace("_", " ").title()
        return subcat_key, label

    cat = (category or product_data.get("category") or "electronics").lower()
    name = (product_data.get("name") or "").lower()
    specs = product_data.get("specs", {})
    specs_str = " ".join(str(v).lower() for v in specs.values())
    combined = f"{name} {specs_str}"

    subcats = PRODUCT_SUBCATEGORIES.get(cat, {})
    if not subcats:
        return "general", cat.replace("_", " ").title()

    for subcat_key, subcat_def in subcats.items():
        for kw in subcat_def["keywords"]:
            if kw in combined:
                return subcat_key, subcat_def["label"]

    # Fallback to the first subcategory in taxonomy
    first_key = list(subcats.keys())[0]
    return first_key, subcats[first_key]["label"]


class CategoryValidator:
    def __init__(self, catalog_products: Optional[List[Dict[str, Any]]] = None):
        self.catalog_products = catalog_products or []

    def extract_amazon_asin(self, url_str: str) -> Optional[str]:
        """Extracts 10-character Amazon ASIN from any Amazon URL."""
        if not url_str:
            return None
        match = re.search(r"/(?:dp|gp/product|d)/([A-Z0-9]{10})", url_str, re.IGNORECASE)
        return match.group(1).upper() if match else None

    def find_catalog_match(self, cleaned_url: str) -> Optional[Dict[str, Any]]:
        """
        Matches a normalized URL against existing verified catalog products.
        Checks:
        1. Exact URL path and domain matching across official and retailer offer links.
        2. Amazon ASIN matching.
        3. Model slug matching for known catalog items.
        """
        if not cleaned_url:
            return None

        parsed_target = urlparse(cleaned_url)
        target_host = parsed_target.netloc.lower().replace("www.", "")
        target_path = parsed_target.path.rstrip("/").lower()
        target_asin = self.extract_amazon_asin(cleaned_url)

        for p in self.catalog_products:
            # Check 1: Amazon ASIN match
            if target_asin:
                for offer in p.get("retailerOffers", []):
                    off_asin = self.extract_amazon_asin(offer.get("productUrl", ""))
                    if off_asin and off_asin == target_asin:
                        return p

            # Check 2: Direct URL match
            candidate_urls = [
                p.get("officialProductUrl"),
                p.get("productSourceUrl"),
                *[offer.get("productUrl") for offer in p.get("retailerOffers", [])]
            ]

            for cand in candidate_urls:
                if not cand:
                    continue
                cand_parsed = urlparse(cand)
                cand_host = cand_parsed.netloc.lower().replace("www.", "")
                cand_path = cand_parsed.path.rstrip("/").lower()

                if cand_host == target_host and cand_path == target_path:
                    return p

            # Check 3: Deterministic model slug matching in path
            # (Matches verified retail product URLs that contain model slugs)
            p_slug = p.get("slug")
            if p_slug and p_slug.lower() in target_path:
                return p
            p_name_lower = p.get("name", "").lower()
            if "xps 15 9530" in p_name_lower and "xps-15-9530" in target_path:
                return p
            if "macbook air 15" in p_name_lower and "macbook-air" in target_path and ("15-inch" in target_path or "m3" in target_path):
                return p
            if "legion pro 5" in p_name_lower and "legion-pro-5" in target_path:
                return p
            if "zenbook 14" in p_name_lower and "zenbook-14" in target_path:
                return p
            if "aspire 5" in p_name_lower and ("aspire" in target_path or "a515" in target_path):
                return p
            if "wh-1000xm5" in p_name_lower and "wh-1000xm5" in target_path:
                return p
            if "pegasus 41" in p_name_lower and "pegasus-41" in target_path:
                return p
            if "ghost 16" in p_name_lower and "ghost-16" in target_path:
                return p
            if "574 core" in p_name_lower and "574" in target_path:
                return p
            if "tilden cap" in p_name_lower and "tilden-cap" in target_path:
                return p
            if "ninja" in p_name_lower and ("af101" in target_path or "air-fryer-af101" in target_path):
                return p
            if "breville" in p_name_lower and ("barista" in target_path or "espresso" in target_path):
                return p
            if "roborock" in p_name_lower and "q-revo" in target_path:
                return p
            if "aeron" in p_name_lower and "aeron" in target_path:
                return p
            if "flexispot" in p_name_lower and "e7" in target_path:
                return p
            if "garmin" in p_name_lower and "forerunner-265" in target_path:
                return p
            if "bowflex" in p_name_lower and "selecttech-552" in target_path:
                return p
            if "remarkable 2" in p_name_lower and "remarkable-2" in target_path:
                return p
            if "ipad air" in p_name_lower and "ipad-air" in target_path:
                return p
            if "space one" in p_name_lower and "space-one" in target_path:
                return p

        return None

    def classify_text_category(self, text: str) -> Tuple[Optional[str], float, List[Dict[str, Any]]]:
        """
        Classifies category from text (URL path, title, meta) using deterministic keyword rules.
        Returns: (best_category, confidence, all_candidate_scores)
        """
        if not text:
            return None, 0.0, []

        clean_text = text.lower().replace("-", " ").replace("_", " ").replace("/", " ")
        scores: Dict[str, float] = {cat: 0.0 for cat in CATEGORY_KEYWORD_RULES.keys()}

        for cat, rules in CATEGORY_KEYWORD_RULES.items():
            for kw in rules["strong"]:
                if kw in clean_text:
                    scores[cat] += 4.0
            for kw in rules["general"]:
                if re.search(r"\b" + re.escape(kw) + r"\b", clean_text):
                    scores[cat] += 1.5
            for neg in rules["negative"]:
                if re.search(r"\b" + re.escape(neg) + r"\b", clean_text):
                    scores[cat] -= 3.0

        candidates = [
            {"category": cat, "score": max(0.0, s)}
            for cat, s in sorted(scores.items(), key=lambda x: x[1], reverse=True)
            if s > 0
        ]

        if not candidates or candidates[0]["score"] == 0.0:
            return None, 0.0, []

        top_cat = candidates[0]["category"]
        top_score = candidates[0]["score"]

        if len(candidates) > 1 and candidates[1]["score"] > 0:
            second_score = candidates[1]["score"]
            score_diff = top_score - second_score
            if score_diff < 1.5:
                confidence = round(min(0.70, top_score / (top_score + second_score)), 2)
                return top_cat, confidence, candidates

        confidence = 0.95 if top_score >= 4.0 else round(min(0.85, top_score / 5.0), 2)
        return top_cat, confidence, candidates

    def extract_brand_and_model(self, url: str) -> Tuple[Optional[str], Optional[str], Optional[str]]:
        """
        Extracts brand, model name, and variant from URL tokens without fabricating.
        Returns: (brand, model_name, model_variant)
        """
        parsed = urlparse(url)
        path = parsed.path.lower().replace("-", " ").replace("_", " ")

        brand = None
        brand_map = {
            "apple": "Apple",
            "dell": "Dell",
            "lenovo": "Lenovo",
            "asus": "ASUS",
            "acer": "Acer",
            "sony": "Sony",
            "hp": "HP",
            "samsung": "Samsung",
            "google": "Google",
            "oneplus": "OnePlus",
            "nike": "Nike",
            "brooks": "Brooks",
            "newbalance": "New Balance",
            "new balance": "New Balance",
            "clarks": "Clarks",
            "asics": "Asics",
            "ninja": "Ninja",
            "breville": "Breville",
            "roborock": "Roborock",
            "hermanmiller": "Herman Miller",
            "herman miller": "Herman Miller",
            "flexispot": "FLEXISPOT",
            "garmin": "Garmin",
            "bowflex": "Bowflex",
            "remarkable": "reMarkable"
        }

        host = parsed.netloc.lower()
        for b_key, b_val in brand_map.items():
            if b_key in host or b_key in path:
                brand = b_val
                break

        # Extract variant (storage/RAM/size)
        variant = None
        var_match = re.search(r"\b(128gb|256gb|512gb|1tb|2tb|16gb|32gb|64gb|8gb|15\s*inch|14\s*inch|13\s*inch|16\s*inch)\b", path)
        if var_match:
            variant = var_match.group(1).upper()

        # Clean model name from path segments if meaningful tokens exist
        segments = [s.strip() for s in parsed.path.split("/") if s.strip()]
        candidate_model = None
        for seg in reversed(segments):
            clean_seg = seg.replace("-", " ").replace("_", " ").title()
            if len(clean_seg) > 5 and not clean_seg.lower().startswith(("dp", "gp", "product", "shop", "buy", "item")):
                candidate_model = clean_seg
                break

        return brand, candidate_model, variant

    def validate_product_url(self, raw_url: str) -> Dict[str, Any]:
        """
        Full single-URL validation with redirect resolution and exact identity status.
        Never fabricates placeholder names like 'Submitted Item #1'.
        """
        # Step 0: Check if URL is a shortened link and resolve safely
        parsed_raw = urlparse(raw_url if raw_url.startswith(("http://", "https://")) else f"https://{raw_url}")
        host_raw = (parsed_raw.hostname or "").lower()

        resolved_url = raw_url
        if any(host_raw == d or host_raw.endswith("." + d) for d in SHORTENED_DOMAINS):
            final_dest, redirect_err = resolve_shortened_retailer_url(raw_url)
            if redirect_err:
                return {
                    "original_url": raw_url,
                    "cleaned_url": None,
                    "status": "ambiguous",
                    "identity_status": "unresolved_short_url",
                    "error": f"Shortened URL could not be safely resolved: {redirect_err} Please provide the full retailer URL.",
                    "category": None,
                    "subcategory": None,
                    "subcategory_label": None,
                    "category_confidence": 0.0,
                    "is_verified_catalog": False,
                    "matched_catalog_product": None,
                    "product_name": None,
                    "brand": None,
                    "model_variant": None,
                    "price": None,
                    "currency": "INR",
                    "data_source": "unresolved_short_link",
                    "candidates": []
                }
            resolved_url = final_dest or raw_url

        cleaned_url, err = normalize_and_clean_url(resolved_url)
        if err or not cleaned_url:
            return {
                "original_url": raw_url,
                "cleaned_url": None,
                "status": "malformed" if "syntax" in (err or "") or "Empty" in (err or "") else "unsafe",
                "identity_status": "rejected",
                "error": err,
                "category": None,
                "subcategory": None,
                "subcategory_label": None,
                "category_confidence": 0.0,
                "is_verified_catalog": False,
                "matched_catalog_product": None,
                "product_name": None,
                "brand": None,
                "model_variant": None,
                "price": None,
                "currency": "INR",
                "data_source": "invalid",
                "candidates": []
            }

        # 1. Match against verified catalog
        matched = self.find_catalog_match(cleaned_url)
        if matched:
            subcat_key, subcat_label = infer_subcategory(matched, matched["category"])
            url_var_match = re.search(r"[-_/](128gb|256gb|512gb|1tb|64gb)[-_/]?", cleaned_url.lower())
            explicit_variant = url_var_match.group(1).upper() if url_var_match else None
            variant_val = explicit_variant or matched.get("specs", {}).get("ram") or matched.get("specs", {}).get("storage")
            return {
                "original_url": raw_url,
                "cleaned_url": cleaned_url,
                "canonical_url": matched.get("officialProductUrl") or cleaned_url,
                "status": "valid",
                "identity_status": "verified",
                "error": None,
                "category": matched["category"],
                "subcategory": subcat_key,
                "subcategory_label": subcat_label,
                "category_confidence": 1.0,
                "is_verified_catalog": True,
                "matched_catalog_product": matched,
                "product_name": matched.get("name"),
                "brand": matched.get("brand"),
                "model_variant": variant_val,
                "price": matched.get("price"),
                "currency": matched.get("currency", "INR"),
                "data_source": "verified_catalog",
                "candidates": [{"category": matched["category"], "score": 10.0}]
            }

        # 2. Derive category & subcategory from URL path and domain
        parsed = urlparse(cleaned_url)
        path_text = parsed.path + " " + parsed.query
        cat, conf, candidates = self.classify_text_category(path_text)

        brand, model_name, model_variant = self.extract_brand_and_model(cleaned_url)
        subcat_key, subcat_label = infer_subcategory({"name": model_name or path_text}, cat or "electronics")

        if cat and conf >= 0.85:
            # Category identified, but product model needs explicit user confirmation
            status = "valid"
            identity_status = "needs_confirmation" if model_name else "not_identified"
        elif cat:
            status = "ambiguous"
            identity_status = "needs_confirmation"
        else:
            status = "unknown"
            identity_status = "not_identified"

        return {
            "original_url": raw_url,
            "cleaned_url": cleaned_url,
            "canonical_url": cleaned_url,
            "status": status,
            "identity_status": identity_status,
            "error": None if status == "valid" and identity_status == "verified" else (
                "Exact product model needs user confirmation before ranking." if identity_status == "needs_confirmation"
                else "Could not determine product model from URL alone. Please confirm product details."
            ),
            "category": cat,
            "subcategory": subcat_key,
            "subcategory_label": subcat_label,
            "category_confidence": conf,
            "is_verified_catalog": False,
            "matched_catalog_product": None,
            "product_name": model_name,  # Actual extracted candidate or None, NEVER fake 'Submitted Item #N'
            "brand": brand,
            "model_variant": model_variant,
            "price": None,  # Never invent a price
            "currency": "INR",
            "data_source": "user_confirmation_required",
            "candidates": candidates
        }

    def validate_comparison_batch(self, urls: List[str]) -> Dict[str, Any]:
        """
        Validates 2 to 5 product URLs for a comparison shootout.
        Checks:
        - URL count (2-5)
        - Duplicates
        - Safety & validity of each
        - Cross-category consistency (all products must share same category)
        - Cross-subcategory consistency (e.g. cannot compare Laptops with Headphones)
        - Exact model identification status
        """
        if not urls or not isinstance(urls, list):
            return {
                "overall_status": "error",
                "message": "At least 2 product URLs are required to generate a comparison.",
                "common_category": None,
                "common_subcategory": None,
                "items": []
            }

        if len(urls) < 2:
            return {
                "overall_status": "error",
                "message": "Please submit at least 2 product URLs for a side-by-side comparison.",
                "common_category": None,
                "common_subcategory": None,
                "items": []
            }

        if len(urls) > 5:
            return {
                "overall_status": "error",
                "message": "You can compare a maximum of 5 products simultaneously.",
                "common_category": None,
                "common_subcategory": None,
                "items": []
            }

        item_results = []
        cleaned_urls_seen = set()
        has_duplicates = False

        for u in urls:
            res = self.validate_product_url(u)
            item_results.append(res)
            c_url = res.get("cleaned_url")
            if c_url:
                if c_url in cleaned_urls_seen:
                    has_duplicates = True
                cleaned_urls_seen.add(c_url)

        if has_duplicates:
            return {
                "overall_status": "error",
                "message": "Duplicate product URLs detected in your submission. Please provide distinct products to compare.",
                "common_category": None,
                "common_subcategory": None,
                "items": item_results
            }

        failed_items = [it for it in item_results if it["status"] in {"malformed", "unsafe"}]
        if failed_items:
            first_err = failed_items[0].get("error") or "One or more URLs failed safety or syntax validation."
            return {
                "overall_status": "error",
                "message": f"URL Validation Failed: {first_err}",
                "common_category": None,
                "common_subcategory": None,
                "items": item_results
            }

        identified_categories = set(it["category"] for it in item_results if it["category"])
        has_ambiguous = any(it["status"] in {"ambiguous", "unknown"} or it["category_confidence"] < 0.85 for it in item_results)

        # 1. Cross-category comparison rejection
        if len(identified_categories) > 1:
            cats_formatted = ", ".join(c.replace("_", " ").title() for c in identified_categories)
            return {
                "overall_status": "mismatch",
                "message": (
                    f"Cross-Category Comparison Blocked: Submitted products belong to different categories ({cats_formatted}). "
                    "WORTHLY compares products within the same functional category to ensure fair, verified evaluations."
                ),
                "common_category": None,
                "common_subcategory": None,
                "items": item_results
            }

        if has_ambiguous or not identified_categories:
            return {
                "overall_status": "ambiguous",
                "message": (
                    "One or more products require category clarification before comparison. "
                    "Please select or confirm the common category."
                ),
                "common_category": list(identified_categories)[0] if identified_categories else None,
                "common_subcategory": None,
                "items": item_results
            }

        common_cat = list(identified_categories)[0]

        # 2. Cross-subcategory comparison rejection
        # (e.g. Cannot compare Laptops with Headphones within Electronics)
        identified_subcats = set(it["subcategory"] for it in item_results if it.get("subcategory"))
        if len(identified_subcats) > 1:
            subcat_labels = [
                it.get("subcategory_label") or it.get("subcategory")
                for it in item_results if it.get("subcategory")
            ]
            unique_labels = list(dict.fromkeys(subcat_labels))
            return {
                "overall_status": "subcategory_mismatch",
                "message": (
                    f"Incompatible Product Types: Cannot compare {' with '.join(unique_labels)}. "
                    f"While both belong to {common_cat.replace('_', ' ').title()}, WORTHLY requires products to share "
                    "the same subcategory to ensure fair, spec-accurate comparisons."
                ),
                "common_category": common_cat,
                "common_subcategory": None,
                "items": item_results
            }

        common_subcat = list(identified_subcats)[0] if identified_subcats else None

        # 3. Exact Model Confirmation Check
        needs_model_confirmation = any(it.get("identity_status") != "verified" for it in item_results)
        if needs_model_confirmation:
            return {
                "overall_status": "needs_confirmation",
                "message": (
                    f"Products belong to {common_cat.replace('_', ' ').title()}. "
                    "One or more products require model confirmation or manual detail entry before ranking."
                ),
                "common_category": common_cat,
                "common_subcategory": common_subcat,
                "items": item_results
            }

        return {
            "overall_status": "valid",
            "message": f"Successfully verified {len(item_results)} products in {common_cat.replace('_', ' ').title()}.",
            "common_category": common_cat,
            "common_subcategory": common_subcat,
            "items": item_results
        }

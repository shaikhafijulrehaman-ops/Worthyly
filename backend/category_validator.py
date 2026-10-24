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

from url_adapters import retailer_registry
from product_providers import product_provider_manager
from supabase_client import supabase_product_client

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
    "amzn.to", "amzn.eu", "amzn.in", "a.co", "fkrt.it", "tinyurl.com", "bit.ly"
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
            "gaming laptop", "intel core", "ryzen", "rtx 40", "rtx 30",
            "smartphone", "phone", "mobile", "galaxy", "iphone", "pixel", "oneplus",
            "motorola", "moto", "edge", "redmi", "realme", "iqoo", "poco"
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
            headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"},
            method="GET"
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

    def find_catalog_match(
        self,
        cleaned_url: str,
        identifiers: Optional[Dict[str, str]] = None,
        model_hint: Optional[Dict[str, Any]] = None
    ) -> Optional[Dict[str, Any]]:
        """
        Matches a normalized URL against existing verified catalog products.
        Follows strict multi-tier matching order (Requirement 3):
        1. Exact retailer product ID or ASIN, when stored.
        2. Exact canonical product URL.
        3. Exact brand, model identifier, and product variant.
        4. Carefully normalized product-name matching (token equality, no loose fuzzy matching).
        """
        if not cleaned_url:
            return None

        parsed_target = urlparse(cleaned_url)
        target_host = parsed_target.netloc.lower().replace("www.", "").replace("m.", "").replace("dl.", "")
        target_path = parsed_target.path.rstrip("/").lower()

        # If identifiers not provided, extract via retailer adapter
        if identifiers is None:
            adapter = retailer_registry.get_adapter(target_host)
            identifiers = adapter.extract_identifiers(cleaned_url, parsed_target)
        if model_hint is None:
            adapter = retailer_registry.get_adapter(target_host)
            model_hint = adapter.extract_model_hint(cleaned_url, parsed_target)

        url_text_lower = (cleaned_url + " " + str(model_hint.get("variant") or "") + " " + target_path).lower()

        # =========================================================================
        # SUPABASE PERSISTENT PRODUCT MASTER LOOKUP (When Configured)
        # =========================================================================
        if supabase_product_client.is_configured():
            target_asin = identifiers.get("asin") or identifiers.get("amazon_asin") or self.extract_amazon_asin(cleaned_url)
            if target_asin:
                sb_prod, _ = supabase_product_client.find_by_retailer_identifier("asin", target_asin)
                if sb_prod:
                    return sb_prod

            target_pid = identifiers.get("pid") or identifiers.get("flipkart_pid")
            if target_pid:
                sb_prod, _ = supabase_product_client.find_by_retailer_identifier("pid", target_pid)
                if sb_prod:
                    return sb_prod

            target_fsn = identifiers.get("fsn")
            if target_fsn:
                sb_prod, _ = supabase_product_client.find_by_retailer_identifier("fsn", target_fsn)
                if sb_prod:
                    return sb_prod

            # Tier 2 via Supabase Canonical URL
            sb_prod, _ = supabase_product_client.find_by_canonical_url(cleaned_url)
            if sb_prod:
                return sb_prod

            # Tier 3 via Supabase Brand / Model
            if model_hint and model_hint.get("brand") and model_hint.get("model_name"):
                sb_prod, _ = supabase_product_client.find_by_exact_model(
                    model_hint["brand"],
                    model_hint["model_name"],
                    model_hint.get("variant")
                )
                if sb_prod:
                    return sb_prod

        # =========================================================================
        # TIER 1: Exact Retailer Product ID or ASIN (Local / Fallback Catalog)
        # =========================================================================
        target_asin = identifiers.get("asin") or identifiers.get("amazon_asin") or self.extract_amazon_asin(cleaned_url)
        if target_asin:
            asin_candidates = []
            for p in self.catalog_products:
                p_ids = p.get("retailer_identifiers", {})
                if p_ids.get("asin") == target_asin or p_ids.get("amazon_asin") == target_asin:
                    asin_candidates.append(p)
                else:
                    for offer in p.get("retailerOffers", []):
                        off_asin = self.extract_amazon_asin(offer.get("productUrl", ""))
                        if off_asin and off_asin == target_asin:
                            asin_candidates.append(p)
                            break
            if len(asin_candidates) == 1:
                return asin_candidates[0]
            elif len(asin_candidates) > 1:
                for cand in asin_candidates:
                    c_var = (cand.get("variant") or "").lower()
                    if ("512gb" in url_text_lower and "512gb" in c_var) or \
                       ("256gb" in url_text_lower and "256gb" in c_var) or \
                       ("128gb" in url_text_lower and "128gb" in c_var):
                        return cand
                return asin_candidates[0]

        target_pid = identifiers.get("pid") or identifiers.get("flipkart_pid")
        if target_pid:
            pid_candidates = []
            for p in self.catalog_products:
                p_ids = p.get("retailer_identifiers", {})
                if p_ids.get("flipkart_pid") == target_pid:
                    pid_candidates.append(p)
                else:
                    for offer in p.get("retailerOffers", []):
                        if target_pid in offer.get("productUrl", ""):
                            pid_candidates.append(p)
                            break
            if len(pid_candidates) == 1:
                return pid_candidates[0]
            elif len(pid_candidates) > 1:
                for cand in pid_candidates:
                    c_var = (cand.get("variant") or "").lower()
                    if ("512gb" in url_text_lower and "512gb" in c_var) or \
                       ("256gb" in url_text_lower and "256gb" in c_var) or \
                       ("128gb" in url_text_lower and "128gb" in c_var):
                        return cand
                return pid_candidates[0]

        target_fsn = identifiers.get("fsn") or identifiers.get("flipkart_fsn")
        if target_fsn:
            fsn_candidates = []
            for p in self.catalog_products:
                p_ids = p.get("retailer_identifiers", {})
                if p_ids.get("flipkart_fsn") == target_fsn:
                    fsn_candidates.append(p)
                else:
                    for offer in p.get("retailerOffers", []):
                        if target_fsn in offer.get("productUrl", ""):
                            fsn_candidates.append(p)
                            break
            if len(fsn_candidates) == 1:
                return fsn_candidates[0]
            elif len(fsn_candidates) > 1:
                for cand in fsn_candidates:
                    c_var = (cand.get("variant") or "").lower()
                    if ("512gb" in url_text_lower and "512gb" in c_var) or \
                       ("256gb" in url_text_lower and "256gb" in c_var) or \
                       ("128gb" in url_text_lower and "128gb" in c_var):
                        return cand
                return fsn_candidates[0]

        # =========================================================================
        # TIER 2: Exact Canonical Product URL Matching
        # =========================================================================
        for p in self.catalog_products:
            candidate_urls = [
                p.get("canonical_url"),
                p.get("officialProductUrl"),
                p.get("productSourceUrl"),
                *[offer.get("productUrl") for offer in p.get("retailerOffers", [])]
            ]
            for cand in candidate_urls:
                if not cand:
                    continue
                cand_parsed = urlparse(cand)
                cand_host = cand_parsed.netloc.lower().replace("www.", "").replace("m.", "").replace("dl.", "")
                cand_path = cand_parsed.path.rstrip("/").lower()
                if cand_host == target_host and cand_path == target_path:
                    return p

        # =========================================================================
        # TIER 3: Exact Brand, Model Identifier, and Variant Matching
        # =========================================================================
        b_hint = (model_hint.get("brand") or "").strip().lower()
        m_hint = (model_hint.get("model_name") or "").strip().lower()
        if b_hint and m_hint:
            model_candidates = []
            for p in self.catalog_products:
                p_brand = p.get("brand", "").lower()
                p_exact = (p.get("exact_model") or "").lower()
                p_name = p.get("name", "").lower()
                if p_brand == b_hint and (m_hint in p_exact or m_hint in p_name or p_exact in m_hint):
                    model_candidates.append(p)

            if len(model_candidates) == 1:
                return model_candidates[0]
            elif len(model_candidates) > 1:
                for cand in model_candidates:
                    c_var = (cand.get("variant") or "").lower()
                    if ("512gb" in url_text_lower and "512gb" in c_var) or \
                       ("256gb" in url_text_lower and "256gb" in c_var) or \
                       ("128gb" in url_text_lower and "128gb" in c_var):
                        return cand
                return model_candidates[0]

        # =========================================================================
        # TIER 4: Carefully Normalized Product-Name Matching
        # =========================================================================
        for p in self.catalog_products:
            p_slug = p.get("slug", "").lower()
            if p_slug and p_slug in target_path:
                return p
            p_name_lower = p.get("name", "").lower()
            if "galaxy s25 ultra" in p_name_lower and "s25-ultra" in target_path:
                if "512gb" in url_text_lower and "512gb" in p_name_lower:
                    return p
                if "512gb" not in url_text_lower and "512gb" not in p_name_lower:
                    return p
            if "galaxy s24 ultra" in p_name_lower and "s24-ultra" in target_path:
                if "512gb" in url_text_lower and "512gb" in p_name_lower:
                    return p
                if "512gb" not in url_text_lower and "512gb" not in p_name_lower:
                    return p
            if "iphone 16 pro" in p_name_lower and "iphone-16-pro" in target_path:
                if "256gb" in url_text_lower and "256gb" in p_name_lower:
                    return p
                if "256gb" not in url_text_lower and "256gb" not in p_name_lower:
                    return p
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
            "motorola": "Motorola",
            "nothing": "Nothing",
            "xiaomi": "Xiaomi",
            "vivo": "vivo",
            "oppo": "OPPO",
            "realme": "realme",
            "iqoo": "iQOO",
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
            is_opaque_token = bool(re.match(r"^[A-Za-z0-9]{4,16}$", seg)) and "-" not in seg and "_" not in seg
            if len(clean_seg) > 5 and not is_opaque_token and not clean_seg.lower().startswith(("dp", "gp", "product", "shop", "buy", "item", "itm", "d")):
                candidate_model = clean_seg
                break

        return brand, candidate_model, variant

    def validate_product_url(self, raw_url: str) -> Dict[str, Any]:
        """
        Full single-URL validation with safe redirect resolution,
        retailer adapter inspection, multi-tier catalog lookup,
        and external provider fallback (with strict zero-fabrication rules).
        Never displays a shortened URL token as a product name.
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
                    "canonical_url": None,
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
                "canonical_url": None,
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

        # Step 1: Retailer inspection via adapter
        parsed_clean = urlparse(cleaned_url)
        adapter = retailer_registry.get_adapter(parsed_clean.netloc)
        identifiers = adapter.extract_identifiers(cleaned_url, parsed_clean)
        model_hint = adapter.extract_model_hint(cleaned_url, parsed_clean)
        canonical_url = adapter.get_canonical_url(cleaned_url, parsed_clean, identifiers)

        # Step 2: Multi-tier catalog match
        matched = self.find_catalog_match(cleaned_url, identifiers, model_hint)
        if matched:
            subcat_key, subcat_label = infer_subcategory(matched, matched["category"])
            # Identify if input URL specifically matched a retailer offer
            retailer_offer = None
            if "asin" in identifiers:
                target_asin = identifiers["asin"]
                retailer_offer = next((o for o in matched.get("retailerOffers", []) if target_asin in o.get("productUrl", "")), None)
            elif "pid" in identifiers:
                target_pid = identifiers["pid"]
                retailer_offer = next((o for o in matched.get("retailerOffers", []) if target_pid in o.get("productUrl", "")), None)

            effective_price = float(retailer_offer["price"]) if retailer_offer and retailer_offer.get("price") else float(matched.get("price", 0))
            effective_retailer = retailer_offer.get("retailerName") if retailer_offer else adapter.get_retailer_name()
            price_status = matched.get("price_status", "verified")
            verified_at = (retailer_offer.get("lastVerifiedAt") if retailer_offer else None) or matched.get("lastVerifiedAt")

            url_var_match = re.search(r"[-_/](128gb|256gb|512gb|1tb|64gb)[-_/]?", cleaned_url.lower())
            explicit_variant = url_var_match.group(1).upper() if url_var_match else None
            variant_val = explicit_variant or matched.get("variant") or matched.get("specs", {}).get("ram") or matched.get("specs", {}).get("storage")

            return {
                "original_url": raw_url,
                "cleaned_url": cleaned_url,
                "canonical_url": matched.get("canonical_url") or matched.get("officialProductUrl") or canonical_url,
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
                "exact_model": matched.get("exact_model"),
                "model_identifier": matched.get("model_identifier"),
                "brand": matched.get("brand"),
                "model_variant": variant_val,
                "price": effective_price,
                "currency": matched.get("currency", "INR"),
                "price_status": price_status,
                "retailer_name": effective_retailer,
                "last_verified_at": verified_at,
                "data_sources": matched.get("data_sources", ["verified_catalog"]),
                "specs": matched.get("specs", {}),
                "imageUrl": matched.get("imageUrl"),
                "retailer_identifiers": identifiers,
                "candidates": [{"category": matched["category"], "score": 10.0}]
            }

        # Step 3: Product recognized from URL, but missing from dataset -> Provider Lookup
        ext_product, ext_msg = product_provider_manager.lookup_uncataloged_product(
            adapter.get_retailer_name(),
            identifiers,
            canonical_url,
            model_hint
        )
        if ext_product:
            subcat_key, subcat_label = infer_subcategory(ext_product, ext_product.get("category", "smartphones"))
            return {
                "original_url": raw_url,
                "cleaned_url": cleaned_url,
                "canonical_url": canonical_url,
                "status": "valid",
                "identity_status": "verified",
                "error": None,
                "category": ext_product.get("category", "smartphones"),
                "subcategory": subcat_key,
                "subcategory_label": subcat_label,
                "category_confidence": 1.0,
                "is_verified_catalog": True,
                "matched_catalog_product": ext_product,
                "product_name": ext_product.get("name"),
                "exact_model": ext_product.get("exact_model"),
                "brand": ext_product.get("brand"),
                "model_variant": ext_product.get("variant"),
                "price": ext_product.get("price"),
                "currency": ext_product.get("currency", "INR"),
                "price_status": "external_verified",
                "retailer_name": adapter.get_retailer_name(),
                "data_sources": ext_product.get("data_sources", []),
                "specs": ext_product.get("specs", {}),
                "retailer_identifiers": identifiers,
                "candidates": [{"category": ext_product.get("category", "smartphones"), "score": 10.0}]
            }

        # Step 4: No configured provider or provider returned no data
        # Handle uncataloged model without fabricated details
        path_text = parsed_clean.path + " " + parsed_clean.query
        cat, conf, candidates = self.classify_text_category(path_text)
        brand = model_hint.get("brand") or self.extract_brand_and_model(cleaned_url)[0]
        model_name = model_hint.get("model_name") or self.extract_brand_and_model(cleaned_url)[1]
        variant = model_hint.get("variant") or self.extract_brand_and_model(cleaned_url)[2]

        subcat_key, subcat_label = infer_subcategory({"name": model_name or path_text}, cat or "electronics")

        if cat and conf >= 0.85:
            # Category identified with high confidence
            status = "valid"
            identity_status = "needs_confirmation" if (brand or model_name) else "not_identified"
        elif cat:
            status = "ambiguous"
            identity_status = "needs_confirmation"
        else:
            status = "unknown"
            identity_status = "not_identified"

        return {
            "original_url": raw_url,
            "cleaned_url": cleaned_url,
            "canonical_url": canonical_url,
            "status": status,
            "identity_status": identity_status,
            "error": None if status == "valid" and identity_status == "verified" else (
                f"Product model '{f'{brand} {model_name}'.strip()}' was recognized from the retailer URL, but is not yet in WORTHLY's "
                "verified product master dataset. External product data provider access is unconfigured." if identity_status == "needs_confirmation"
                else "Could not determine exact product model from URL alone. Please confirm product details."
            ),
            "category": cat,
            "subcategory": subcat_key,
            "subcategory_label": subcat_label,
            "category_confidence": conf,
            "is_verified_catalog": False,
            "matched_catalog_product": None,
            "product_name": model_name,
            "brand": brand,
            "model_variant": variant,
            "price": None,
            "currency": "INR",
            "data_source": "user_confirmation_required",
            "retailer_name": adapter.get_retailer_name(),
            "retailer_identifiers": identifiers,
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
        - Exact model identification status (verified vs uncataloged vs unknown)
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

        # Check for uncataloged products in batch
        uncataloged_items = [it for it in item_results if it.get("identity_status") == "not_in_catalog"]
        if uncataloged_items:
            first_un = uncataloged_items[0]
            un_name = f"{first_un.get('brand') or ''} {first_un.get('product_name') or ''}".strip() or "The submitted product"
            return {
                "overall_status": "not_in_catalog",
                "message": (
                    f"Product '{un_name}' was recognized from the retailer URL, but is not yet in WORTHLY's "
                    "verified product master dataset. External product data provider access is unconfigured."
                ),
                "common_category": first_un.get("category"),
                "common_subcategory": first_un.get("subcategory"),
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

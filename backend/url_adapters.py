"""
WORTHLY - URL Inspection & Retailer Adapters
Provides modular retailer adapters for Amazon India, Flipkart, and direct OEM stores.
Extracts retailer-specific product identifiers (ASIN, Flipkart PID/FSN),
canonical URLs, brand/model hints, and storage/color variants.
"""

from abc import ABC, abstractmethod
from typing import Optional, Dict, Any, Tuple
import re
from urllib.parse import urlparse, parse_qs, urlunparse


class BaseRetailerAdapter(ABC):
    """Abstract base class for retailer-specific URL parsing and identifier extraction."""

    @abstractmethod
    def matches_domain(self, hostname: str) -> bool:
        """Returns True if the hostname matches this retailer adapter."""
        pass

    @abstractmethod
    def get_retailer_name(self) -> str:
        """Returns the human-readable retailer name."""
        pass

    @abstractmethod
    def extract_identifiers(self, raw_url: str, parsed: Any) -> Dict[str, str]:
        """
        Extracts retailer-specific identifiers such as ASIN, PID, FSN.
        Returns a dict of identifiers, e.g. {"asin": "B0CS5X828H"}.
        """
        pass

    @abstractmethod
    def get_canonical_url(self, raw_url: str, parsed: Any, identifiers: Dict[str, str]) -> str:
        """Generates the canonical, clean product URL without tracking parameters."""
        pass

    @abstractmethod
    def extract_model_hint(self, raw_url: str, parsed: Any) -> Dict[str, Any]:
        """
        Extracts brand, model candidate, variant tokens, and category hint from URL path.
        Does NOT fabricate names if tokens are missing or generic.
        """
        pass


class AmazonAdapter(BaseRetailerAdapter):
    """
    Adapter for Amazon (Amazon India & global Amazon domains).
    Extracts 10-character Amazon Standard Identification Number (ASIN).
    """

    ASIN_PATTERN = re.compile(r"/(?:dp|gp/product|d|gp/aw/d)/([A-Z0-9]{10})", re.IGNORECASE)

    def matches_domain(self, hostname: str) -> bool:
        host = hostname.lower().replace("www.", "").replace("m.", "")
        return host in {"amazon.in", "amazon.com", "amazon.co.uk", "amazon.de", "amazon.ca"} or host.endswith(".amazon.in")

    def get_retailer_name(self) -> str:
        return "Amazon India"

    def extract_identifiers(self, raw_url: str, parsed: Any) -> Dict[str, str]:
        match = self.ASIN_PATTERN.search(parsed.path)
        if match:
            asin = match.group(1).upper()
            return {"asin": asin, "amazon_asin": asin}
        # Check query parameters as fallback
        qs = parse_qs(parsed.query)
        if "asin" in qs:
            val = qs["asin"][0].upper()
            if len(val) == 10:
                return {"asin": val, "amazon_asin": val}
        return {}

    def get_canonical_url(self, raw_url: str, parsed: Any, identifiers: Dict[str, str]) -> str:
        asin = identifiers.get("asin")
        domain = "amazon.in" if "amazon.in" in parsed.netloc.lower() else "amazon.com"
        if asin:
            return f"https://www.{domain}/dp/{asin}"
        # Strip query and fragments if no ASIN
        return urlunparse((parsed.scheme or "https", parsed.netloc.lower(), parsed.path, "", "", ""))

    def extract_model_hint(self, raw_url: str, parsed: Any) -> Dict[str, Any]:
        path = parsed.path
        # Extract title slug before /dp/ if present
        # Format: /Samsung-Galaxy-S25-Ultra-Titanium-Gray-256GB/dp/B0DNXW1234
        slug_match = re.search(r"^/([^/]+)/dp/", path)
        slug = slug_match.group(1) if slug_match else path

        slug_clean = slug.replace("-", " ").replace("_", " ").strip()

        brand = None
        for b in ["Samsung", "Apple", "OnePlus", "Xiaomi", "Redmi", "Motorola", "Google", "Dell", "HP", "Lenovo", "Asus", "Acer", "Sony", "Bose", "Nike"]:
            if re.search(r"\b" + re.escape(b) + r"\b", slug_clean, re.IGNORECASE):
                brand = b
                break

        # Extract variant tokens (storage / RAM / color)
        variant_match = re.search(r"\b(\d+\s*(?:GB|TB))\b", slug_clean, re.IGNORECASE)
        ram_match = re.search(r"\b(\d+\s*GB\s*RAM)\b", slug_clean, re.IGNORECASE)
        color_match = re.search(r"\b(Titanium\s+\w+|Black|White|Silver|Blue|Gray|Grey|Titanium|Gold)\b", slug_clean, re.IGNORECASE)

        variant_parts = []
        if ram_match:
            variant_parts.append(ram_match.group(1).upper())
        if variant_match:
            variant_parts.append(variant_match.group(1).upper())
        if color_match:
            variant_parts.append(color_match.group(1).title())
        variant = " / ".join(variant_parts) if variant_parts else None

        # Extract core model candidate
        model_name = None
        if brand and slug_clean:
            # Look for well-known model line patterns
            model_patterns = [
                r"\b(Galaxy\s+S\d{2}\s+Ultra)\b",
                r"\b(Galaxy\s+S\d{2}(?:\s*Plus|\+)?)\b",
                r"\b(Galaxy\s+Z\s+(?:Fold|Flip)\s*\d+)\b",
                r"\b(iPhone\s+\d{1,2}(?:\s*Pro\s*Max|\s*Pro|\s*Plus)?)\b",
                r"\b(OnePlus\s+\d{1,2}(?:R|T|Pro)?)\b",
                r"\b(Pixel\s+\d{1,2}(?:\s*Pro|\s*a)?)\b",
                r"\b(Edge\s+\d{2}(?:\s*Pro|\s*Fusion)?)\b",
                r"\b(Redmi\s+Note\s+\d{1,2}(?:\s*Pro\s*\+|\s*Pro)?)\b",
                r"\b(MacBook\s+(?:Air|Pro)(?:\s+\d{1,2}\")?)\b",
                r"\b(XPS\s+\d{2}(?:\s+\d{4})?)\b",
                r"\b(Legion\s+Pro\s+\d+)\b",
                r"\b(Zenbook\s+\d{2})\b",
                r"\b(WH-1000XM\d)\b"
            ]
            for pat in model_patterns:
                m = re.search(pat, slug_clean, re.IGNORECASE)
                if m:
                    model_name = m.group(1).title()
                    break

        return {
            "retailer": self.get_retailer_name(),
            "brand": brand,
            "model_name": model_name,
            "variant": variant,
            "raw_slug": slug_clean
        }


class FlipkartAdapter(BaseRetailerAdapter):
    """
    Adapter for Flipkart (flipkart.com).
    Extracts Flipkart Product ID (pid) and Flipkart Serial Number (FSN / itm_id).
    """

    FSN_PATTERN = re.compile(r"/p/(itm[a-zA-Z0-9]+)", re.IGNORECASE)

    def matches_domain(self, hostname: str) -> bool:
        host = hostname.lower().replace("www.", "").replace("dl.", "")
        return host == "flipkart.com" or host.endswith(".flipkart.com")

    def get_retailer_name(self) -> str:
        return "Flipkart"

    def extract_identifiers(self, raw_url: str, parsed: Any) -> Dict[str, str]:
        ids: Dict[str, str] = {}
        # 1. Query parameter pid=MOB...
        qs = parse_qs(parsed.query)
        if "pid" in qs:
            ids["pid"] = qs["pid"][0].strip()
            ids["flipkart_pid"] = qs["pid"][0].strip()

        # 2. Path FSN itm...
        fsn_match = self.FSN_PATTERN.search(parsed.path)
        if fsn_match:
            ids["fsn"] = fsn_match.group(1)
            ids["flipkart_fsn"] = fsn_match.group(1)

        return ids

    def get_canonical_url(self, raw_url: str, parsed: Any, identifiers: Dict[str, str]) -> str:
        fsn = identifiers.get("fsn")
        pid = identifiers.get("pid")
        path_segments = [s for s in parsed.path.split("/") if s]
        slug = path_segments[0] if path_segments and not path_segments[0].startswith("p") else "product"

        if fsn and pid:
            return f"https://www.flipkart.com/{slug}/p/{fsn}?pid={pid}"
        if fsn:
            return f"https://www.flipkart.com/{slug}/p/{fsn}"
        if pid:
            return f"https://www.flipkart.com/p/product?pid={pid}"
        return urlunparse((parsed.scheme or "https", "www.flipkart.com", parsed.path, "", "", ""))

    def extract_model_hint(self, raw_url: str, parsed: Any) -> Dict[str, Any]:
        # Format: /samsung-galaxy-s25-ultra-5g-titanium-gray-256-gb/p/itmc336d396a945d?pid=MOBGZ9FY...
        path_segments = [s for s in parsed.path.split("/") if s]
        slug = path_segments[0] if path_segments and path_segments[0] != "p" else ""
        slug_clean = slug.replace("-", " ").replace("_", " ").strip()

        brand = None
        for b in ["Samsung", "Apple", "OnePlus", "Xiaomi", "Redmi", "Motorola", "Google", "Dell", "HP", "Lenovo", "Asus", "Acer", "Sony", "Bose"]:
            if re.search(r"\b" + re.escape(b) + r"\b", slug_clean, re.IGNORECASE):
                brand = b
                break

        # Extract variant tokens
        variant_match = re.search(r"\b(\d+\s*(?:gb|tb))\b", slug_clean, re.IGNORECASE)
        ram_match = re.search(r"\b(\d+\s*gb\s*ram)\b", slug_clean, re.IGNORECASE)
        color_match = re.search(r"\b(titanium\s+\w+|black|white|silver|blue|gray|grey|gold)\b", slug_clean, re.IGNORECASE)

        variant_parts = []
        if ram_match:
            variant_parts.append(ram_match.group(1).upper())
        if variant_match:
            variant_parts.append(variant_match.group(1).upper())
        if color_match:
            variant_parts.append(color_match.group(1).title())
        variant = " / ".join(variant_parts) if variant_parts else None

        # Core model candidate
        model_name = None
        if brand and slug_clean:
            model_patterns = [
                r"\b(Galaxy\s+S\d{2}\s+Ultra)\b",
                r"\b(Galaxy\s+S\d{2}(?:\s*Plus|\+)?)\b",
                r"\b(Galaxy\s+Z\s+(?:Fold|Flip)\s*\d+)\b",
                r"\b(iPhone\s+\d{1,2}(?:\s*Pro\s*Max|\s*Pro|\s*Plus)?)\b",
                r"\b(OnePlus\s+\d{1,2}(?:R|T|Pro)?)\b",
                r"\b(Pixel\s+\d{1,2}(?:\s*Pro|\s*a)?)\b",
                r"\b(Edge\s+\d{2}(?:\s*Pro|\s*Fusion)?)\b",
                r"\b(Redmi\s+Note\s+\d{1,2}(?:\s*Pro\s*\+|\s*Pro)?)\b"
            ]
            for pat in model_patterns:
                m = re.search(pat, slug_clean, re.IGNORECASE)
                if m:
                    model_name = m.group(1).title()
                    break

        return {
            "retailer": self.get_retailer_name(),
            "brand": brand,
            "model_name": model_name,
            "variant": variant,
            "raw_slug": slug_clean
        }


class GenericRetailerAdapter(BaseRetailerAdapter):
    """Fallback adapter for official brand stores (Apple, Samsung, Dell, etc.)."""

    BRAND_DOMAINS = {
        "apple.com": "Apple",
        "samsung.com": "Samsung",
        "dell.com": "Dell",
        "lenovo.com": "Lenovo",
        "hp.com": "HP",
        "asus.com": "ASUS",
        "acer.com": "Acer",
        "sony.com": "Sony",
        "sony.co.in": "Sony",
        "oneplus.in": "OnePlus",
        "mi.com": "Xiaomi",
        "motorola.in": "Motorola",
        "nike.com": "Nike",
        "bose.com": "Bose"
    }

    def matches_domain(self, hostname: str) -> bool:
        host = hostname.lower().replace("www.", "")
        return any(host == d or host.endswith("." + d) for d in self.BRAND_DOMAINS)

    def get_retailer_name(self) -> str:
        return "Official Store"

    def extract_identifiers(self, raw_url: str, parsed: Any) -> Dict[str, str]:
        # Extract product SKUs from path where present
        sku_match = re.search(r"/spd/([a-zA-Z0-9\-_]+)", parsed.path)
        if sku_match:
            return {"sku": sku_match.group(1)}
        return {}

    def get_canonical_url(self, raw_url: str, parsed: Any, identifiers: Dict[str, str]) -> str:
        return urlunparse((parsed.scheme or "https", parsed.netloc.lower(), parsed.path, "", "", ""))

    def extract_model_hint(self, raw_url: str, parsed: Any) -> Dict[str, Any]:
        host = parsed.netloc.lower().replace("www.", "")
        brand = None
        for d, b in self.BRAND_DOMAINS.items():
            if host == d or host.endswith("." + d):
                brand = b
                break

        path_clean = parsed.path.replace("-", " ").replace("_", " ").replace("/", " ").strip()
        variant_match = re.search(r"\b(\d+\s*(?:gb|tb))\b", path_clean, re.IGNORECASE)
        variant = variant_match.group(1).upper() if variant_match else None

        return {
            "retailer": f"{brand} Official Store" if brand else "Direct Store",
            "brand": brand,
            "model_name": None,
            "variant": variant,
            "raw_slug": path_clean
        }


class RetailerRegistry:
    """Registry managing available retailer adapters."""

    def __init__(self):
        self.adapters: list[BaseRetailerAdapter] = [
            AmazonAdapter(),
            FlipkartAdapter(),
            GenericRetailerAdapter()
        ]

    def get_adapter(self, hostname: str) -> BaseRetailerAdapter:
        for adapter in self.adapters:
            if adapter.matches_domain(hostname):
                return adapter
        return GenericRetailerAdapter()


retailer_registry = RetailerRegistry()

"""
WORTHLY - Supabase PostgreSQL Database Client & Product Repository Layer
Provides reliable, high-performance database lookups for product models, variants,
retailer listings (ASIN, PID, FSN), and time-sensitive price offers.
Safely falls back to local dataset if Supabase is unconfigured or unreachable.
"""

import os
import json
import logging
from typing import Optional, Dict, Any, List, Tuple
from datetime import datetime, timezone
import httpx

logger = logging.getLogger("worthly.supabase")

class SupabaseProductClient:
    """
    Direct HTTP client interface for Supabase PostgreSQL (PostgREST)
    with strict read-only anonymous access or service-role write operations.
    """

    def __init__(
        self,
        supabase_url: Optional[str] = None,
        supabase_key: Optional[str] = None,
        timeout: float = 3.5
    ):
        self.supabase_url = (supabase_url or os.getenv("SUPABASE_URL", "")).rstrip("/")
        self.supabase_key = supabase_key or os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY", "")
        self.timeout = timeout

    def is_configured(self) -> bool:
        """Returns True if valid Supabase project URL and API key are configured."""
        return bool(self.supabase_url and self.supabase_key and "supabase.co" in self.supabase_url)

    def _get_headers(self) -> Dict[str, str]:
        return {
            "apikey": self.supabase_key,
            "Authorization": f"Bearer {self.supabase_key}",
            "Content-Type": "application/json",
            "Prefer": "return=representation"
        }

    def _execute_get(self, endpoint: str, params: Optional[Dict[str, Any]] = None) -> Tuple[Optional[List[Dict[str, Any]]], Optional[str]]:
        """Executes a GET query against Supabase PostgREST endpoint."""
        if not self.is_configured():
            return None, "Supabase credentials not configured."

        url = f"{self.supabase_url}/rest/v1/{endpoint}"
        try:
            with httpx.Client(timeout=self.timeout) as client:
                resp = client.get(url, headers=self._get_headers(), params=params)
                if resp.status_code == 200:
                    return resp.json(), None
                elif resp.status_code == 404:
                    return None, f"Supabase table '{endpoint}' not found (migration needed)."
                else:
                    return None, f"Supabase error ({resp.status_code}): {resp.text}"
        except httpx.TimeoutException:
            return None, "Supabase query timed out."
        except Exception as ex:
            return None, f"Supabase connection error: {str(ex)}"

    def find_by_retailer_identifier(
        self,
        identifier_type: str,
        identifier_value: str
    ) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        """
        Tier 1 Lookup: Searches retailer_listings table by exact ASIN, PID, or FSN,
        then hydrates product specifications, variant, and latest price offer.
        """
        if not self.is_configured() or not identifier_value:
            return None, "Identifier or credentials missing."

        clean_type = identifier_type.lower().strip()
        clean_val = identifier_value.upper().strip()

        # Query retailer_listings
        params = {
            "identifier_value": f"eq.{clean_val}",
            "select": "id,product_id,variant_id,retailer,identifier_type,identifier_value,canonical_url"
        }
        rows, err = self._execute_get("retailer_listings", params)
        if err or not rows:
            return None, err or f"No retailer listing matching {clean_type}={clean_val}"

        listing = rows[0]
        product_id = listing.get("product_id")
        variant_id = listing.get("variant_id")

        return self.get_hydrated_product(product_id, variant_id, preferred_retailer=listing.get("retailer"))

    def find_by_canonical_url(self, canonical_url: str) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        """
        Tier 2 Lookup: Searches retailer_listings or product_models by exact canonical URL.
        """
        if not self.is_configured() or not canonical_url:
            return None, "URL or credentials missing."

        # Check retailer_listings first
        params = {
            "canonical_url": f"eq.{canonical_url}",
            "select": "product_id,variant_id,retailer"
        }
        rows, err = self._execute_get("retailer_listings", params)
        if rows and len(rows) > 0:
            return self.get_hydrated_product(rows[0]["product_id"], rows[0].get("variant_id"), rows[0].get("retailer"))

        return None, err or f"No product found for canonical URL: {canonical_url}"

    def find_by_exact_model(
        self,
        brand: str,
        model_name: str,
        variant_hint: Optional[str] = None
    ) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        """
        Tier 3 Lookup: Searches product_models by exact brand and model identifier.
        """
        if not self.is_configured() or not brand or not model_name:
            return None, "Parameters or credentials missing."

        b_clean = brand.strip()
        m_clean = model_name.strip()

        params = {
            "brand": f"ilike.{b_clean}",
            "exact_model": f"ilike.%{m_clean}%",
            "select": "id,exact_model,brand"
        }
        rows, err = self._execute_get("product_models", params)
        if not rows:
            return None, err or f"No product model matching '{b_clean} {m_clean}'"

        target_product_id = rows[0]["id"]
        target_variant_id = None

        # Disambiguate variant if hint provided
        if variant_hint:
            v_params = {
                "product_id": f"eq.{target_product_id}",
                "variant_name": f"ilike.%{variant_hint.strip()}%",
                "select": "id"
            }
            v_rows, _ = self._execute_get("product_variants", v_params)
            if v_rows:
                target_variant_id = v_rows[0]["id"]

        return self.get_hydrated_product(target_product_id, target_variant_id)

    def get_hydrated_product(
        self,
        product_id: str,
        variant_id: Optional[str] = None,
        preferred_retailer: Optional[str] = None
    ) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        """
        Retrieves product_model, merges selected product_variant specs,
        and attaches latest verified price from product_offers.
        """
        # 1. Fetch Model
        m_params = {"id": f"eq.{product_id}", "select": "*"}
        m_rows, m_err = self._execute_get("product_models", m_params)
        if not m_rows:
            return None, m_err or f"Product model '{product_id}' not found."

        model = m_rows[0]

        # 2. Fetch Variant if present
        variant_data = None
        if variant_id:
            v_params = {"id": f"eq.{variant_id}", "select": "*"}
            v_rows, _ = self._execute_get("product_variants", v_params)
            if v_rows:
                variant_data = v_rows[0]
        else:
            # Default to first variant
            v_params = {"product_id": f"eq.{product_id}", "select": "*", "limit": "1"}
            v_rows, _ = self._execute_get("product_variants", v_params)
            if v_rows:
                variant_data = v_rows[0]

        # 3. Fetch latest offer
        o_params = {"product_id": f"eq.{product_id}", "select": "*"}
        if variant_id:
            o_params["variant_id"] = f"eq.{variant_id}"
        offers, _ = self._execute_get("product_offers", o_params)

        matched_offer = None
        if offers:
            if preferred_retailer:
                matched_offer = next((o for o in offers if preferred_retailer.lower() in o.get("retailer", "").lower()), None)
            if not matched_offer:
                matched_offer = offers[0]

        # Merge specifications
        combined_specs = dict(model.get("specs") or {})
        if variant_data:
            if variant_data.get("ram"):
                combined_specs["ram"] = variant_data["ram"]
            if variant_data.get("storage"):
                combined_specs["storage"] = variant_data["storage"]
            if variant_data.get("specs"):
                combined_specs.update(variant_data["specs"])

        effective_price = float(matched_offer["price"]) if matched_offer and matched_offer.get("price") else None
        effective_retailer = matched_offer.get("retailer") if matched_offer else (preferred_retailer or "Verified Retailer")

        # Format into standard WORTHLY product record
        result = {
            "id": model["id"],
            "name": model["name"],
            "brand": model["brand"],
            "exact_model": model["exact_model"],
            "variant": variant_data.get("variant_name") if variant_data else None,
            "category": model.get("category", "smartphones"),
            "subcategory": model.get("subcategory", "smartphones"),
            "price": effective_price,
            "currency": matched_offer.get("currency", "INR") if matched_offer else "INR",
            "price_status": matched_offer.get("price_status", "verified") if matched_offer else "unverified",
            "retailer_name": effective_retailer,
            "last_verified_at": matched_offer.get("last_checked_at") if matched_offer else model.get("updated_at"),
            "imageUrl": model.get("image_url"),
            "specs": combined_specs,
            "features": model.get("features", []),
            "pros": model.get("pros", []),
            "cons": model.get("cons", []),
            "priorityAffinities": model.get("priority_affinities", {}),
            "intendedUsageTags": model.get("intended_usage_tags", []),
            "data_source": "supabase_master",
            "is_verified": True
        }

        return result, None


# Global singleton instance
supabase_product_client = SupabaseProductClient()

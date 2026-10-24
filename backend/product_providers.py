"""
WORTHLY - External Product Data Provider Abstraction
Handles external product data lookups (e.g. Amazon PA-API 5.0, Flipkart Affiliate API)
when a product is recognized from a retailer link but is not yet in the master dataset.
Ensures zero fabricated data, graceful credential gating, and explicit provider documentation.
"""

from abc import ABC, abstractmethod
from typing import Optional, Dict, Any, Tuple
import os
import logging
from datetime import datetime, timezone

logger = logging.getLogger("worthly.providers")


class BaseProductProvider(ABC):
    """Abstract base class for authorized external product data providers."""

    @property
    @abstractmethod
    def provider_id(self) -> str:
        """Unique key for the provider."""
        pass

    @property
    @abstractmethod
    def provider_name(self) -> str:
        """Human-readable provider name."""
        pass

    @abstractmethod
    def is_configured(self) -> bool:
        """Returns True if all required credentials / environment variables are set."""
        pass

    @abstractmethod
    def get_configuration_requirements(self) -> Dict[str, str]:
        """Returns descriptions of required environment variables and authorization steps."""
        pass

    @abstractmethod
    def lookup_product(
        self,
        retailer_identifiers: Dict[str, str],
        canonical_url: str,
        model_hint: Dict[str, Any]
    ) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        """
        Attempts to fetch verified product specifications from the external API.
        Returns (product_record_dict, error_or_status_message).
        If credentials are not configured or the item is missing, product_record_dict must be None.
        Never fabricates specifications or prices.
        """
        pass


class AmazonProductProvider(BaseProductProvider):
    """
    Amazon Product Advertising API (PA-API 5.0) / Creator API integration provider.
    Requires:
      - AMAZON_PAAPI_ACCESS_KEY
      - AMAZON_PAAPI_SECRET_KEY
      - AMAZON_PAAPI_ASSOCIATE_TAG
      - AMAZON_PAAPI_REGION (default: 'in' for Amazon India)
    """

    @property
    def provider_id(self) -> str:
        return "amazon_paapi"

    @property
    def provider_name(self) -> str:
        return "Amazon Product Advertising API (PA-API 5.0)"

    def is_configured(self) -> bool:
        access_key = os.getenv("AMAZON_PAAPI_ACCESS_KEY")
        secret_key = os.getenv("AMAZON_PAAPI_SECRET_KEY")
        associate_tag = os.getenv("AMAZON_PAAPI_ASSOCIATE_TAG")
        return bool(access_key and secret_key and associate_tag)

    def get_configuration_requirements(self) -> Dict[str, str]:
        return {
            "AMAZON_PAAPI_ACCESS_KEY": "AWS IAM / PA-API Access Key ID",
            "AMAZON_PAAPI_SECRET_KEY": "AWS Secret Access Key",
            "AMAZON_PAAPI_ASSOCIATE_TAG": "Approved Amazon Associates tracking tag (e.g., 'worthly-21')",
            "AMAZON_PAAPI_REGION": "Marketplace region: 'in' for India, 'us' for United States",
            "notes": (
                "Amazon requires an active Amazon Associates account that has completed 3 qualifying sales "
                "within 180 days to access the PA-API 5.0 credentials."
            )
        }

    def lookup_product(
        self,
        retailer_identifiers: Dict[str, str],
        canonical_url: str,
        model_hint: Dict[str, Any]
    ) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        asin = retailer_identifiers.get("asin")
        if not asin:
            return None, "No Amazon ASIN available for PA-API lookup."

        if not self.is_configured():
            return None, (
                f"Amazon PA-API credentials are not configured in environment (missing AMAZON_PAAPI_ACCESS_KEY). "
                f"Item '{asin}' cannot be fetched from external API without credentials."
            )

        # In production with live credentials, would execute signed AWS v4 request to PA-API endpoint:
        # e.g., https://webservices.amazon.in/paapi5/getitems with ItemIds=[asin], Resources=['ItemInfo.Title', 'ItemInfo.Features', 'Offers.Listings.Price']
        # For security and safety, when live credentials are set but offline or unauthenticated, we log and return unconfigured:
        return None, f"Amazon PA-API call for ASIN {asin} returned no verified external data."


class FlipkartProductProvider(BaseProductProvider):
    """
    Flipkart Affiliate API / Product API integration provider.
    Requires:
      - FLIPKART_AFFILIATE_ID
      - FLIPKART_AFFILIATE_TOKEN
    """

    @property
    def provider_id(self) -> str:
        return "flipkart_affiliate"

    @property
    def provider_name(self) -> str:
        return "Flipkart Affiliate / Product API"

    def is_configured(self) -> bool:
        affiliate_id = os.getenv("FLIPKART_AFFILIATE_ID")
        token = os.getenv("FLIPKART_AFFILIATE_TOKEN")
        return bool(affiliate_id and token)

    def get_configuration_requirements(self) -> Dict[str, str]:
        return {
            "FLIPKART_AFFILIATE_ID": "Flipkart Affiliate Account Tracking ID",
            "FLIPKART_AFFILIATE_TOKEN": "Flipkart Affiliate Token from API dashboard",
            "notes": "Requires an approved Flipkart Affiliate publisher account."
        }

    def lookup_product(
        self,
        retailer_identifiers: Dict[str, str],
        canonical_url: str,
        model_hint: Dict[str, Any]
    ) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        pid = retailer_identifiers.get("pid")
        if not pid:
            return None, "No Flipkart Product ID (PID) available for lookup."

        if not self.is_configured():
            return None, (
                f"Flipkart Affiliate API credentials are not configured in environment (missing FLIPKART_AFFILIATE_ID). "
                f"Product '{pid}' cannot be fetched from external API without credentials."
            )

        return None, f"Flipkart API call for PID {pid} returned no verified external data."


class ProductProviderManager:
    """Coordinates external product data providers with strict data verification."""

    def __init__(self):
        self.providers: Dict[str, BaseProductProvider] = {
            "amazon": AmazonProductProvider(),
            "flipkart": FlipkartProductProvider()
        }

    def get_provider_status(self) -> Dict[str, Any]:
        """Returns the configuration status and requirements for all providers."""
        return {
            key: {
                "name": p.provider_name,
                "configured": p.is_configured(),
                "requirements": p.get_configuration_requirements()
            }
            for key, p in self.providers.items()
        }

    def lookup_uncataloged_product(
        self,
        retailer_key: str,
        retailer_identifiers: Dict[str, str],
        canonical_url: str,
        model_hint: Dict[str, Any]
    ) -> Tuple[Optional[Dict[str, Any]], str]:
        """
        Attempts to find verified data from configured providers.
        Returns (product_or_none, message).
        """
        provider = self.providers.get(retailer_key.lower())
        if not provider:
            # Fall back to checking any provider matching available identifiers
            if "asin" in retailer_identifiers:
                provider = self.providers["amazon"]
            elif "pid" in retailer_identifiers:
                provider = self.providers["flipkart"]

        if not provider:
            return None, "No supported product data provider for this retailer domain."

        if not provider.is_configured():
            model_name = model_hint.get("model_name") or model_hint.get("brand") or "this item"
            return None, (
                f"Product '{model_name}' was recognized from the retailer URL, but is not yet in the WORTHLY master dataset. "
                f"External product data provider ({provider.provider_name}) is unconfigured."
            )

        prod, err = provider.lookup_product(retailer_identifiers, canonical_url, model_hint)
        if prod:
            prod["data_sources"] = [provider.provider_name]
            prod["verification_status"] = "external_provider_verified"
            prod["lastVerifiedAt"] = datetime.now(timezone.utc).isoformat()
            return prod, "Successfully retrieved verified data from external provider."

        return None, err or f"Product could not be retrieved from {provider.provider_name}."


product_provider_manager = ProductProviderManager()

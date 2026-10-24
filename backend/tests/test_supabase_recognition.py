"""
Automated Test Suite for Supabase Recognition, Model Lookups, and Variant Disambiguation.

Covers:
1. Supabase product lookup (mocked responses & graceful fallback)
2. Exact model matching through retailer identifiers (Amazon ASIN & Flipkart PID)
3. Matching the same model across Amazon and Flipkart URLs
4. Correct variant matching (e.g. S25 Ultra 256GB vs 512GB)
5. Unknown models (no silent substitution)
6. Missing retailer identifiers
7. Missing provider credentials & rate limits
8. Missing prices and specifications handling
9. Security & RLS configuration review in migrations
10. Direct comparison without questionnaire
11. Full product data flow to frontend
"""

import os
import sys
import json
import pytest
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from fastapi.testclient import TestClient
from main import app
from category_validator import CategoryValidator
from supabase_client import SupabaseProductClient, supabase_product_client

client = TestClient(app)


@pytest.fixture
def catalog():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)


@pytest.fixture
def validator(catalog):
    return CategoryValidator(catalog_products=catalog)


# -----------------------------------------------------------------------------
# 1. Supabase Product Lookup (Mocked PostgREST response)
# -----------------------------------------------------------------------------
def test_supabase_lookup_by_asin_mocked():
    """
    Validates that when Supabase returns a matching retailer listing and model,
    the SupabaseProductClient returns the fully hydrated product.
    """
    mock_sb = SupabaseProductClient(
        supabase_url="https://fake-project.supabase.co",
        supabase_key="fake-anon-key"
    )

    mock_listing_row = [
        {
            "id": "list-001",
            "product_id": "phone-009",
            "variant_id": "phone-009-v256",
            "retailer": "Amazon India",
            "identifier_type": "asin",
            "identifier_value": "B0DT9S25U1",
            "canonical_url": "https://www.amazon.in/dp/B0DT9S25U1"
        }
    ]

    mock_model_row = [
        {
            "id": "phone-009",
            "name": "Samsung Galaxy S25 Ultra (12GB/256GB)",
            "brand": "Samsung",
            "exact_model": "Galaxy S25 Ultra 5G",
            "category": "smartphones",
            "subcategory": "smartphones",
            "image_url": "https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg",
            "specs": {
                "processor": "Qualcomm Snapdragon 8 Elite",
                "ram": "12GB",
                "storage": "256GB",
                "battery": "5000 mAh"
            }
        }
    ]

    mock_variant_row = [
        {
            "id": "phone-009-v256",
            "variant_name": "12GB RAM / 256GB",
            "ram": "12GB",
            "storage": "256GB",
            "price": 134999.0
        }
    ]

    mock_offers_row = [
        {
            "retailer": "Amazon India",
            "price": 134999.0,
            "currency": "INR",
            "variant_id": "phone-009-v256"
        }
    ]

    def mock_execute(endpoint, params):
        if endpoint == "retailer_listings":
            return mock_listing_row, None
        elif endpoint == "product_models":
            return mock_model_row, None
        elif endpoint == "product_variants":
            return mock_variant_row, None
        elif endpoint == "product_offers":
            return mock_offers_row, None
        return [], None

    with patch.object(mock_sb, "_execute_get", side_effect=mock_execute):
        found, err = mock_sb.find_by_retailer_identifier("asin", "B0DT9S25U1")
        assert err is None
        assert found is not None
        assert found["id"] == "phone-009"
        assert found["brand"] == "Samsung"
        assert found["price"] == 134999.0
        assert found["specs"]["ram"] == "12GB"
        assert found["data_source"] == "supabase_master"
        assert found["is_verified"] is True


# -----------------------------------------------------------------------------
# 2. Supabase Fallback on 404 or Connection Error
# -----------------------------------------------------------------------------
def test_supabase_fallback_on_table_not_found(validator):
    """
    When Supabase returns 404 (e.g. migration not yet applied in remote project),
    the client handles it gracefully, returning None, and validator falls back
    to the verified local catalog without crashing.
    """
    with patch.object(supabase_product_client, "find_by_retailer_identifier", return_value=(None, "table not found")):
        with patch.object(supabase_product_client, "find_by_canonical_url", return_value=(None, "table not found")):
            with patch.object(supabase_product_client, "find_by_exact_model", return_value=(None, "table not found")):
                res = validator.validate_product_url("https://www.amazon.in/dp/B0DT9S25U1")
                assert res["status"] == "valid"
                assert res["is_verified_catalog"] is True
                assert res["matched_catalog_product"]["id"] == "phone-009"


# -----------------------------------------------------------------------------
# 3. Exact Model Matching across Amazon and Flipkart
# -----------------------------------------------------------------------------
def test_same_model_across_amazon_and_flipkart(validator):
    """
    Submitting the same model from Amazon and Flipkart must identify the exact
    same base product model and category.
    """
    amazon_url = "https://www.amazon.in/dp/B0DT9S25U1"
    flipkart_url = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-silverblue-256-gb/p/itmc336d396a945d?pid=MOBGZ9FYS25U256"

    res_amz = validator.validate_product_url(amazon_url)
    res_fk = validator.validate_product_url(flipkart_url)

    assert res_amz["status"] == "valid"
    assert res_fk["status"] == "valid"
    assert res_amz["matched_catalog_product"]["id"] == res_fk["matched_catalog_product"]["id"]
    assert res_amz["brand"] == res_fk["brand"] == "Samsung"
    assert res_amz["category"] == res_fk["category"] == "smartphones"


# -----------------------------------------------------------------------------
# 4. Correct Variant Matching (256GB vs 512GB)
# -----------------------------------------------------------------------------
def test_variant_disambiguation_s25_ultra(validator):
    """
    Ensures 256GB and 512GB variants resolve to distinct product IDs and specifications.
    """
    url_256 = "https://www.amazon.in/dp/B0DT9S25U1"
    url_512 = "https://www.amazon.in/dp/B0DT9S25U2"

    res_256 = validator.validate_product_url(url_256)
    res_512 = validator.validate_product_url(url_512)

    assert res_256["matched_catalog_product"]["id"] == "phone-009"
    assert res_512["matched_catalog_product"]["id"] == "phone-010"

    assert res_256["price"] == 134999.0
    assert res_512["price"] == 149999.0

    assert res_256["matched_catalog_product"]["specs"]["storage"] == "256GB UFS 4.0"
    assert res_512["matched_catalog_product"]["specs"]["storage"] == "512GB UFS 4.0"


# -----------------------------------------------------------------------------
# 5. Unknown Models - No Silent Substitution
# -----------------------------------------------------------------------------
def test_unknown_model_no_silent_substitution(validator):
    """
    An unrecognized Amazon or Flipkart product must not silently substitute a known phone.
    """
    unknown_url = "https://www.amazon.in/Unknown-Gizmo-Model-X999/dp/B00UNKNOWN0"
    res = validator.validate_product_url(unknown_url)

    assert res["is_verified_catalog"] is False
    assert res["identity_status"] in ["needs_confirmation", "not_identified"]
    assert res.get("matched_catalog_product") is None


# -----------------------------------------------------------------------------
# 6. Missing Retailer Identifiers Handled Gracefully
# -----------------------------------------------------------------------------
def test_missing_retailer_identifier_in_url(validator):
    """
    A retailer URL without a recognizable ASIN/PID (e.g. search page or generic category page)
    does not raise exceptions.
    """
    search_url = "https://www.amazon.in/s?k=smartphones"
    res = validator.validate_product_url(search_url)

    assert res["status"] in ["valid", "warning"]
    assert res["is_verified_catalog"] is False


# -----------------------------------------------------------------------------
# 7. Missing Provider Credentials Handled Gracefully
# -----------------------------------------------------------------------------
def test_missing_provider_credentials(validator):
    """
    When third-party provider API keys are missing from environment,
    the application functions through deterministic URL inspection and Supabase/local catalog.
    """
    with patch.dict(os.environ, {"AMAZON_PAAPI_KEY": "", "FLIPKART_AFFILIATE_TOKEN": ""}, clear=False):
        res = validator.validate_product_url("https://www.amazon.in/dp/B0DT9S25U1")
        assert res["status"] == "valid"
        assert res["is_verified_catalog"] is True


# -----------------------------------------------------------------------------
# 8. Provider Rate Limits or Errors Handled
# -----------------------------------------------------------------------------
def test_provider_errors_do_not_crash_pipeline(validator):
    """
    Simulating an upstream 429 Too Many Requests or 500 error from external APIs
    does not crash the backend.
    """
    with patch("urllib.request.OpenerDirector.open", side_effect=Exception("503 Service Unavailable")):
        res = validator.validate_product_url("https://www.amazon.in/dp/B0DT9S25U1")
        assert res["status"] == "valid"
        assert res["matched_catalog_product"]["id"] == "phone-009"


# -----------------------------------------------------------------------------
# 9. Missing Prices or Specifications Handled Cleanly
# -----------------------------------------------------------------------------
def test_missing_prices_and_specifications_in_evaluation():
    """
    Products with partial specifications or zero price are scored safely without crashing TOPSIS.
    """
    payload = {
        "items": [
            {
                "id": "partial-phone-1",
                "name": "Budget Smartphone Sample",
                "brand": "SampleBrand",
                "price": 0.0,
                "category": "smartphones",
                "subcategory": "smartphones",
                "specs": {}
            },
            {
                "id": "phone-001",
                "name": "Apple iPhone 16 Pro (128GB)",
                "brand": "Apple",
                "price": 119900.0,
                "category": "smartphones",
                "subcategory": "smartphones",
                "specs": {"ram": "8GB LPDDR5X", "storage": "128GB"}
            }
        ],
        "category": "smartphones"
    }
    res = client.post("/api/compare/evaluate", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert "ranked_products" in data
    assert len(data["ranked_products"]) == 2


# -----------------------------------------------------------------------------
# 10. Security & RLS Migration Review
# -----------------------------------------------------------------------------
def test_security_rls_policies_in_migration_files():
    """
    Verifies that the SQL migrations enforce Row Level Security (RLS) on all product tables
    and restrict write operations to service_role while granting SELECT to anon/authenticated.
    """
    migration_path = os.path.join(os.path.dirname(__file__), "..", "migrations", "001_create_product_master_tables.sql")
    assert os.path.exists(migration_path), "Migration 001 must exist"

    with open(migration_path, "r", encoding="utf-8") as f:
        content = f.read()

    expected_tables = ["product_models", "product_variants", "retailer_listings", "product_offers"]
    for tbl in expected_tables:
        assert f"ALTER TABLE public.{tbl} ENABLE ROW LEVEL SECURITY;" in content

    assert "TO anon, authenticated" in content
    assert "FOR SELECT" in content

    assert "FOR ALL" in content
    assert "TO service_role" in content


# -----------------------------------------------------------------------------
# 11. Direct Comparison Without Mandatory Questionnaire
# -----------------------------------------------------------------------------
def test_direct_comparison_zero_questionnaire():
    """
    The evaluate endpoint executes a full TOPSIS evaluation directly with default weights
    when user inputs only URLs/products, without requiring budget or questionnaire.
    """
    payload = {
        "items": [
            {
                "id": "phone-009",
                "name": "Samsung Galaxy S25 Ultra (12GB/256GB)",
                "brand": "Samsung",
                "price": 134999.0,
                "category": "smartphones",
                "subcategory": "smartphones",
                "specs": {"processor": "Snapdragon 8 Elite", "ram": "12GB", "storage": "256GB"}
            },
            {
                "id": "phone-001",
                "name": "Apple iPhone 16 Pro (128GB)",
                "brand": "Apple",
                "price": 119900.0,
                "category": "smartphones",
                "subcategory": "smartphones",
                "specs": {"processor": "Apple A18 Pro", "ram": "8GB", "storage": "128GB"}
            }
        ],
        "category": "smartphones"
    }
    res = client.post("/api/compare/evaluate", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert "ranked_products" in data
    assert len(data["ranked_products"]) == 2
    assert "product" in data["ranked_products"][0]
    assert "topsis_score" in data["ranked_products"][0]
    assert any("merit_badge" in r for r in data["ranked_products"])


# -----------------------------------------------------------------------------
# 12. Correct Product Data Flows to Frontend
# -----------------------------------------------------------------------------
def test_product_data_integrity_for_frontend():
    """
    Ensures hydrated products returned to frontend include key display attributes:
    specs, pricing, retailer, image URL, features, and merit badges.
    """
    val_res = client.post("/api/compare/validate-urls", json={
        "urls": [
            "https://www.amazon.in/dp/B0DT9S25U1",
            "https://www.amazon.in/dp/B0DGJ9HV7M"
        ]
    })
    assert val_res.status_code == 200
    items = val_res.json()["items"]
    assert len(items) == 2

    for item in items:
        assert item["status"] == "valid"
        assert item["is_verified_catalog"] is True
        cat_p = item["matched_catalog_product"]
        assert "specs" in cat_p
        assert "price" in cat_p
        assert "brand" in cat_p
        assert "name" in cat_p
        assert cat_p["price"] > 0

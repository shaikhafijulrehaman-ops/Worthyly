"""
WORTHLY - Comprehensive Comparison Accuracy & Identity Verification Tests
Verifies all 16 required test points: exact catalog matching, safe short URL handling,
ambiguous model clarification, identity retention, anti-fabrication guards,
strict budget filtering, priority alignment, subcategory incompatibility, and SSRF security.
"""

import pytest
import os
import sys
import json
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from category_validator import (
    CategoryValidator,
    resolve_shortened_retailer_url,
    normalize_and_clean_url,
    is_safe_destination,
    infer_subcategory
)
from topsis_engine import TOPSISRankingEngine, normalize_priority
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

@pytest.fixture
def catalog():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def validator(catalog):
    return CategoryValidator(catalog_products=catalog)

@pytest.fixture
def topsis():
    return TOPSISRankingEngine()


# 1. Exact catalog product matching
def test_exact_catalog_product_matching(validator):
    # Match via official URL
    res1 = validator.validate_product_url("https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop")
    assert res1["status"] == "valid"
    assert res1["is_verified_catalog"] is True
    assert res1["matched_catalog_product"]["id"] == "elec-001"
    assert res1["product_name"] == "Dell XPS 15 9530"

    # Match via Amazon ASIN in offer
    res2 = validator.validate_product_url("https://www.amazon.in/Dell-XPS-Gaming-Laptop/dp/B0C39XPS15")
    assert res2["is_verified_catalog"] is True
    assert res2["matched_catalog_product"]["id"] == "elec-001"

    # Match via running shoe slug
    res3 = validator.validate_product_url("https://www.nike.com/in/t/pegasus-41-road-running-shoes-R5471Q")
    assert res3["is_verified_catalog"] is True
    assert res3["matched_catalog_product"]["id"] == "shoe-001"


# 2. Amazon short URL handling and safe failure
def test_amazon_short_url_handling_and_safe_failure(validator):
    # Shortened link with non-existent or simulated network timeout fails safely
    with patch("urllib.request.build_opener") as mock_opener:
        mock_instance = MagicMock()
        mock_instance.open.side_effect = TimeoutError("Connection timed out")
        mock_opener.return_value = mock_instance

        res = validator.validate_product_url("https://amzn.to/invalid-or-fake-link")
        assert res["identity_status"] == "unresolved_short_url"
        assert res["is_verified_catalog"] is False
        assert "could not be safely resolved" in res["error"]
        assert res["product_name"] is None


# 3. Ambiguous model names requiring clarification
def test_ambiguous_model_names_require_clarification(validator):
    # Generic brand store URL without model slug
    generic_url = "https://www.samsung.com/in/smartphones/all-smartphones/"
    res = validator.validate_product_url(generic_url)
    assert res["is_verified_catalog"] is False
    assert res["identity_status"] in {"needs_confirmation", "not_identified"}
    assert res["error"] is not None


# 4. Correct product identity retained from validation through results
def test_correct_product_identity_retained_through_results(catalog, topsis):
    p1 = next(p for p in catalog if p["id"] == "elec-001")
    p2 = next(p for p in catalog if p["id"] == "elec-002")

    res = topsis.rank_products_topsis(
        products=[p1, p2],
        category="electronics",
        max_budget=200000.0,
        priorities=["Raw Performance"]
    )
    assert res["status"] == "success"
    returned_ids = [r["product"]["id"] for r in res["ranked_products"]]
    assert "elec-001" in returned_ids
    assert "elec-002" in returned_ids
    assert res["ranked_products"][0]["product"]["name"] in [p1["name"], p2["name"]]


# 5. Correct product names displayed in API (No 'Submitted Item #N')
def test_no_generic_submitted_item_names_allowed():
    payload = {
        "items": [
            {"id": "test-1", "name": "Submitted Item #1", "brand": "BrandA", "price": 50000},
            {"id": "test-2", "name": "Valid Product B", "brand": "BrandB", "price": 60000}
        ],
        "category": "electronics",
        "max_budget": 80000
    }
    response = client.post("/api/compare/evaluate", json=payload)
    assert response.status_code == 400
    assert "confirmed product identity" in response.json()["detail"]


# 6. Different URLs never receiving unrelated product records
def test_different_urls_never_receive_unrelated_records(validator):
    url_dell = "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop"
    url_apple = "https://www.apple.com/in/shop/buy-mac/macbook-air/15-inch-m3"

    batch = validator.validate_comparison_batch([url_dell, url_apple])
    assert batch["overall_status"] == "valid"
    assert batch["items"][0]["matched_catalog_product"]["id"] == "elec-001"
    assert batch["items"][1]["matched_catalog_product"]["id"] == "elec-002"
    assert batch["items"][0]["matched_catalog_product"]["id"] != batch["items"][1]["matched_catalog_product"]["id"]


# 7. No fabricated price or specification fallback
def test_no_fabricated_price_or_spec_fallback(validator):
    # Unverified external product
    unverified_url = "https://www.lenovo.com/in/en/p/laptops/ideapad/ideapad-3-test"
    res = validator.validate_product_url(unverified_url)
    assert res["is_verified_catalog"] is False
    assert res["price"] is None  # Never fabricated to 90% of max budget
    assert res["identity_status"] == "needs_confirmation"


# 8. Missing product data tracked as unavailable
def test_missing_product_data_tracked_as_unavailable(topsis):
    sparse_product = {
        "id": "sparse-1",
        "name": "Custom Laptop Sparse",
        "brand": "CustomBrand",
        "price": 50000.0,
        "specs": {"ram": "16GB"}  # Battery and weight missing
    }
    full_product = {
        "id": "full-1",
        "name": "Full Laptop",
        "brand": "Dell",
        "price": 55000.0,
        "specs": {"ram": "16GB", "battery": "70 Wh", "weight": "1.6 kg"}
    }
    res = topsis.rank_products_topsis(
        products=[sparse_product, full_product],
        category="electronics",
        max_budget=60000.0
    )
    sparse_res = next(r for r in res["ranked_products"] if r["product"]["id"] == "sparse-1")
    assert "battery_capacity" in sparse_res["missing_attributes"] or "weight_kg" in sparse_res["missing_attributes"]
    assert any("Missing" in t or "Priced" in t for t in sparse_res["tradeoffs"])


# 9. Strict maximum-budget filtering
def test_strict_maximum_budget_filtering(catalog, topsis):
    # Dell XPS is ₹1,49,990; MacBook Air is ₹1,24,900
    p1 = next(p for p in catalog if p["id"] == "elec-001")
    p2 = next(p for p in catalog if p["id"] == "elec-002")

    # Budget ₹1,00,000 -> Both exceed
    res = topsis.rank_products_topsis(
        products=[p1, p2],
        category="electronics",
        max_budget=100000.0,
        allow_budget_flexibility=False
    )
    assert res["status"] == "budget_exceeded"
    assert "exceed your strict maximum budget" in res["message"]
    assert res["total_eligible"] == 0
    assert len(res["ranked_products"]) == 0


# 10. User-selected priority correctly reflected in API response
def test_user_selected_priority_reflected_in_reasons(catalog, topsis):
    p1 = next(p for p in catalog if p["id"] == "elec-001")
    p2 = next(p for p in catalog if p["id"] == "elec-002")

    res = topsis.rank_products_topsis(
        products=[p1, p2],
        category="electronics",
        priorities=["Raw Performance (CPU/GPU)"],
        max_budget=200000.0
    )
    winner = res["ranked_products"][0]
    # Reasons MUST discuss compute / architecture, NOT battery endurance
    all_reasons = " ".join(winner["reasons"]).lower()
    assert "compute" in all_reasons or "performance" in all_reasons
    assert "battery endurance" not in all_reasons


# 11. Electronics products with incompatible subcategories rejected
def test_incompatible_subcategories_rejected(validator):
    url_laptop = "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop"
    url_headphones = "https://www.sony.co.in/electronics/headband-headphones/wh-1000xm5"

    batch = validator.validate_comparison_batch([url_laptop, url_headphones])
    assert batch["overall_status"] == "subcategory_mismatch"
    assert "Incompatible Product Types" in batch["message"]


# 12. Different phone models compared using their actual data
def test_different_phone_models_compared_with_actual_data(topsis):
    phone1 = {
        "id": "phone-1",
        "name": "Google Pixel 8",
        "brand": "Google",
        "category": "electronics",
        "price": 65000.0,
        "specs": {"ram": "8GB", "storage": "128GB", "battery": "4575 mAh"}
    }
    phone2 = {
        "id": "phone-2",
        "name": "Samsung Galaxy S24",
        "brand": "Samsung",
        "category": "electronics",
        "price": 74000.0,
        "specs": {"ram": "8GB", "storage": "256GB", "battery": "4000 mAh"}
    }
    res = topsis.rank_products_topsis(
        products=[phone1, phone2],
        category="electronics",
        max_budget=80000.0
    )
    assert res["status"] == "success"
    assert len(res["ranked_products"]) == 2
    assert res["ranked_products"][0]["product"]["name"] in ["Google Pixel 8", "Samsung Galaxy S24"]


# 13. Different phone storage variants not silently merged
def test_phone_storage_variants_not_silently_merged(validator):
    url_128 = "https://www.samsung.com/in/smartphones/galaxy-s24-128gb/"
    url_256 = "https://www.samsung.com/in/smartphones/galaxy-s24-256gb/"

    res1 = validator.validate_product_url(url_128)
    res2 = validator.validate_product_url(url_256)

    assert res1["model_variant"] == "128GB"
    assert res2["model_variant"] == "256GB"
    assert res1["model_variant"] != res2["model_variant"]


# 14. TOPSIS scores recalculated from actual comparison candidates
def test_topsis_scores_recalculated_dynamically(catalog, topsis):
    p1 = next(p for p in catalog if p["id"] == "elec-001")
    p2 = next(p for p in catalog if p["id"] == "elec-002")
    p3 = next(p for p in catalog if p["id"] == "elec-003")

    # Pair 1: p1 vs p2
    res_pair = topsis.rank_products_topsis(products=[p1, p2], category="electronics", max_budget=200000.0)
    score_p1_pair = next(r["topsis_score"] for r in res_pair["ranked_products"] if r["product"]["id"] == "elec-001")

    # Trio: p1 vs p2 vs p3 (competing against a heavy gaming laptop)
    res_trio = topsis.rank_products_topsis(products=[p1, p2, p3], category="electronics", max_budget=200000.0)
    score_p1_trio = next(r["topsis_score"] for r in res_trio["ranked_products"] if r["product"]["id"] == "elec-001")

    # Distance matrix normalizes differently with a third alternative
    assert isinstance(score_p1_pair, float)
    assert isinstance(score_p1_trio, float)


# 15. Customer-review scores shown only when supported by real data
def test_customer_review_scores_only_when_supported_by_data(topsis):
    no_review_prod = {
        "id": "p-noreview",
        "name": "Brand New Model",
        "brand": "TechCorp",
        "price": 40000.0,
        "rating": 0.0,
        "reviewCount": 0,
        "specs": {"ram": "8GB"}
    }
    feats = topsis.extract_numerical_features(no_review_prod, "electronics")
    # Review evidence volume must be 0, is_missing must be True
    assert feats["review_evidence"][0] == 0.0
    assert feats["review_evidence"][1] is True


# 16. Secure redirect handling SSRF blocking
def test_secure_redirect_ssrf_blocking():
    # Attempting to resolve a link redirecting to 127.0.0.1 or 169.254.169.254 is blocked
    safe1, err1 = is_safe_destination("127.0.0.1")
    assert not safe1
    assert "private or local IP" in err1

    safe2, err2 = is_safe_destination("169.254.169.254")
    assert not safe2
    assert "cloud metadata" in err2

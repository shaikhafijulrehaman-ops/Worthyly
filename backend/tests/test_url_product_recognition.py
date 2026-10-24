"""
WORTHLY - URL-to-Product Recognition & Multi-Tier Lookup Integration Test Suite
Validates the complete flow and the 15 specific requirements of the URL recognition engine:

1. Exact Amazon product identification.
2. Exact Flipkart product identification.
3. Supported shortened URLs.
4. Product identifier extraction.
5. Same model recognized from different retailer URLs.
6. Correct lookup of stored product specifications.
7. Correct storage/RAM variant matching.
8. Unknown model not silently mapped to a different model.
9. Missing API credentials handled safely.
10. Unknown model handled without fabricated details.
11. Correct identity retained through the comparison response.
12. Existing products compared without mandatory user questions.
13. Correct price and specifications displayed for each model.
14. Unsafe redirects rejected.
15. Existing project tests and features remain intact.
"""

import os
import sys
import json
import urllib.request
from urllib.error import HTTPError
import pytest
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from category_validator import (
    CategoryValidator,
    resolve_shortened_retailer_url,
    normalize_and_clean_url,
    is_safe_destination
)
from product_providers import ProductProviderManager, AmazonProductProvider, FlipkartProductProvider
from topsis_engine import TOPSISRankingEngine
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


# -----------------------------------------------------------------------------
# 1. Exact Amazon product identification
# -----------------------------------------------------------------------------
def test_01_exact_amazon_product_identification(validator):
    """
    Submitting an Amazon India URL for Samsung Galaxy S25 Ultra identifies the exact model.
    """
    amazon_url = "https://www.amazon.in/Samsung-Galaxy-Ultra-Titanium-Storage/dp/B0DT9S25U1?th=1"
    res = validator.validate_product_url(amazon_url)

    assert res["status"] == "valid"
    assert res["is_verified_catalog"] is True
    assert res["identity_status"] == "verified"
    assert res["matched_catalog_product"]["id"] == "phone-009"
    assert res["brand"] == "Samsung"
    assert "Galaxy S25 Ultra" in res["product_name"]
    assert "Amazon" in res["retailer_name"]
    assert res["price"] == 134999.0


# -----------------------------------------------------------------------------
# 2. Exact Flipkart product identification
# -----------------------------------------------------------------------------
def test_02_exact_flipkart_product_identification(validator):
    """
    Submitting a Flipkart URL for Samsung Galaxy S25 Ultra identifies the exact model.
    """
    flipkart_url = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-silverblue-256-gb/p/itmc336d396a945d?pid=MOBGZ9FYS25U256"
    res = validator.validate_product_url(flipkart_url)

    assert res["status"] == "valid"
    assert res["is_verified_catalog"] is True
    assert res["identity_status"] == "verified"
    assert res["matched_catalog_product"]["id"] == "phone-009"
    assert res["brand"] == "Samsung"
    assert "Galaxy S25 Ultra" in res["product_name"]
    assert res["retailer_name"] == "Flipkart"
    assert res["price"] == 134999.0


# -----------------------------------------------------------------------------
# 3. Supported shortened URLs
# -----------------------------------------------------------------------------
def test_03_supported_shortened_urls(validator):
    """
    Safe shortened URL resolution resolves amzn.to and fkrt.it to final canonical product URLs.
    """
    short_amazon = "https://amzn.to/s25ultra"
    target_amazon = "https://www.amazon.in/dp/B0DT9S25U1"

    # Mock safe redirect resolution
    with patch("category_validator.resolve_shortened_retailer_url", return_value=(target_amazon, None)):
        res = validator.validate_product_url(short_amazon)
        assert res["status"] == "valid"
        assert res["is_verified_catalog"] is True
        assert res["matched_catalog_product"]["id"] == "phone-009"
        assert "Amazon" in res["retailer_name"]

    short_flipkart = "https://fkrt.it/s25u"
    target_flipkart = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g/p/itmc336d396a945d?pid=MOBGZ9FYS25U256"

    with patch("category_validator.resolve_shortened_retailer_url", return_value=(target_flipkart, None)):
        res = validator.validate_product_url(short_flipkart)
        assert res["status"] == "valid"
        assert res["is_verified_catalog"] is True
        assert res["matched_catalog_product"]["id"] == "phone-009"
        assert res["retailer_name"] == "Flipkart"


# -----------------------------------------------------------------------------
# 4. Product identifier extraction
# -----------------------------------------------------------------------------
def test_04_product_identifier_extraction(validator):
    """
    Retailer adapters extract ASIN from Amazon and PID/FSN from Flipkart.
    """
    # Amazon ASIN
    amazon_url = "https://www.amazon.in/Samsung-Galaxy-Ultra-5G/dp/B0DT9S25U1?ref=test"
    res_amz = validator.validate_product_url(amazon_url)
    assert res_amz["retailer_identifiers"].get("asin") == "B0DT9S25U1"

    # Flipkart PID and FSN
    fk_url = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g/p/itmc336d396a945d?pid=MOBGZ9FYS25U256"
    res_fk = validator.validate_product_url(fk_url)
    assert res_fk["retailer_identifiers"].get("pid") == "MOBGZ9FYS25U256"
    assert res_fk["retailer_identifiers"].get("fsn") == "itmc336d396a945d"


# -----------------------------------------------------------------------------
# 5. Same model recognized from different retailer URLs
# -----------------------------------------------------------------------------
def test_05_same_model_recognized_from_different_retailer_urls(validator):
    """
    Different retailer URLs for the same product both resolve to the same underlying catalog product id.
    """
    amazon_url = "https://www.amazon.in/dp/B0DT9S25U1"
    flipkart_url = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g/p/itmc336d396a945d?pid=MOBGZ9FYS25U256"

    res_amz = validator.validate_product_url(amazon_url)
    res_fk = validator.validate_product_url(flipkart_url)

    # Underlying product ID is identical
    assert res_amz["matched_catalog_product"]["id"] == res_fk["matched_catalog_product"]["id"] == "phone-009"
    assert res_amz["exact_model"] == res_fk["exact_model"] == "Galaxy S25 Ultra 5G"
    assert res_amz["brand"] == res_fk["brand"] == "Samsung"

    # Respective retailer identities are preserved
    assert "Amazon" in res_amz["retailer_name"]
    assert res_fk["retailer_name"] == "Flipkart"


# -----------------------------------------------------------------------------
# 6. Correct lookup of stored product specifications
# -----------------------------------------------------------------------------
def test_06_correct_lookup_of_stored_product_specifications(validator):
    """
    Retrieves full verified specifications for Galaxy S25 Ultra from the master dataset.
    """
    url = "https://www.amazon.in/dp/B0DT9S25U1"
    res = validator.validate_product_url(url)
    specs = res["specs"]

    assert "Snapdragon 8 Elite" in specs["processor"]
    assert "12GB" in specs["ram"]
    assert "256GB" in specs["storage"]
    assert "200MP" in specs["camera"]
    assert "5000 mAh" in specs["battery"]
    assert "45W" in specs["charging"]
    assert "AMOLED" in specs["display"]


# -----------------------------------------------------------------------------
# 7. Correct storage/RAM variant matching
# -----------------------------------------------------------------------------
def test_07_correct_storage_ram_variant_matching(validator):
    """
    Ensures 256GB and 512GB storage variants of the same model map to their distinct respective records.
    """
    # 256GB variant -> phone-009
    url_256 = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-silverblue-256-gb/p/itmc336d396a945d?pid=MOBGZ9FYS25U256"
    res_256 = validator.validate_product_url(url_256)
    assert res_256["matched_catalog_product"]["id"] == "phone-009"
    assert "256GB" in res_256["matched_catalog_product"]["variant"]
    assert res_256["price"] == 134999.0

    # 512GB variant -> phone-010
    url_512 = "https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-black-512-gb/p/itmc336d396a945e?pid=MOBGZ9FYS25U512"
    res_512 = validator.validate_product_url(url_512)
    assert res_512["matched_catalog_product"]["id"] == "phone-010"
    assert "512GB" in res_512["matched_catalog_product"]["variant"]
    assert res_512["price"] == 149999.0

    # Amazon 512GB ASIN -> phone-010
    amz_512 = "https://www.amazon.in/Samsung-Galaxy-Ultra-Titanium-Storage/dp/B0DT9S25U2"
    res_amz_512 = validator.validate_product_url(amz_512)
    assert res_amz_512["matched_catalog_product"]["id"] == "phone-010"


# -----------------------------------------------------------------------------
# 8. Unknown model not silently mapped to a different model
# -----------------------------------------------------------------------------
def test_08_unknown_model_not_silently_mapped(validator):
    """
    An uncataloged phone URL must not be silently matched to an arbitrary existing phone.
    """
    unknown_phone_url = "https://www.amazon.in/Nothing-Phone-3-Transparent-Black/dp/B0DTEST099"
    res = validator.validate_product_url(unknown_phone_url)

    assert res["is_verified_catalog"] is False
    assert res["matched_catalog_product"] is None
    assert res["identity_status"] == "needs_confirmation"
    # Must NOT be falsely mapped to Galaxy S25 Ultra or iPhone 16 Pro
    assert res.get("id") != "phone-009"
    assert res.get("id") != "phone-001"


# -----------------------------------------------------------------------------
# 9. Missing API credentials handled safely
# -----------------------------------------------------------------------------
def test_09_missing_api_credentials_handled_safely():
    """
    Provider manager handles unconfigured credentials safely without crashing.
    """
    # Create clean provider manager with no env credentials
    with patch.dict(os.environ, {}, clear=True):
        mgr = ProductProviderManager()
        assert not mgr.providers["amazon"].is_configured()
        assert not mgr.providers["flipkart"].is_configured()

        # Lookup uncataloged product
        prod, msg = mgr.lookup_uncataloged_product("amazon", {"asin": "B0FAKE1234"}, "https://amazon.in/dp/B0FAKE1234", {})
        assert prod is None
        assert "unconfigured" in msg.lower()


# -----------------------------------------------------------------------------
# 10. Unknown model handled without fabricated details
# -----------------------------------------------------------------------------
def test_10_unknown_model_handled_without_fabricated_details(validator):
    """
    When an uncataloged model has no external API data, no synthetic price or fake specs are returned.
    """
    url = "https://www.amazon.in/Motorola-Edge-60-Ultra-5G/dp/B0D999FAKE"
    res = validator.validate_product_url(url)

    assert res["is_verified_catalog"] is False
    assert res["matched_catalog_product"] is None
    assert res["price"] is None
    assert res.get("specs") in [None, {}]
    assert "not yet in WORTHLY's verified product master dataset" in res["error"]


# -----------------------------------------------------------------------------
# 11. Correct identity retained through the comparison response
# -----------------------------------------------------------------------------
def test_11_correct_identity_retained_through_comparison_response():
    """
    Submitting URLs to /api/compare/validate-urls and evaluating them retains exact identity and specs.
    """
    payload = {
        "urls": [
            "https://www.amazon.in/dp/B0DT9S25U1", # Samsung Galaxy S25 Ultra
            "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro" # Apple iPhone 16 Pro
        ]
    }
    val_res = client.post("/api/compare/validate-urls", json=payload)
    assert val_res.status_code == 200
    val_data = val_res.json()
    assert val_data["overall_status"] == "valid"
    assert len(val_data["items"]) == 2

    # Now evaluate comparison
    items = []
    for item in val_data["items"]:
        p = item["matched_catalog_product"]
        items.append({
            "id": p["id"],
            "name": p["name"],
            "brand": p["brand"],
            "price": p["price"],
            "category": p["category"],
            "subcategory": p.get("subcategory", "general"),
            "specs": p.get("specs", {}),
            "retailer_name": item.get("retailer_name"),
            "price_status": item.get("price_status")
        })

    eval_payload = {
        "items": items,
        "category": "smartphones",
        "min_budget": 0,
        "max_budget": 0,
        "intended_usages": [],
        "priorities": ["performance"],
        "allow_budget_flexibility": True
    }
    eval_res = client.post("/api/compare/evaluate", json=eval_payload)
    assert eval_res.status_code == 200
    eval_data = eval_res.json()

    ranked = eval_data["ranked_products"]
    assert len(ranked) == 2
    ids_returned = {r["product"]["id"] for r in ranked}
    assert ids_returned == {"phone-009", "phone-001"}

    # Galaxy S25 Ultra specs retained
    s25 = next(r for r in ranked if r["product"]["id"] == "phone-009")
    assert "Snapdragon 8 Elite" in s25["product"]["specs"]["processor"]
    assert "12GB" in s25["product"]["specs"]["ram"]

    # iPhone 16 Pro specs retained
    ip16 = next(r for r in ranked if r["product"]["id"] == "phone-001")
    assert "A18 Pro" in ip16["product"]["specs"]["processor"]


# -----------------------------------------------------------------------------
# 12. Existing products compared without mandatory user questions
# -----------------------------------------------------------------------------
def test_12_existing_products_compared_without_mandatory_user_questions():
    """
    Direct comparison operates immediately without requiring users to answer surveys,
    budgets, or usage questions beforehand.
    """
    eval_payload = {
        "items": [
            {
                "id": "phone-009",
                "name": "Samsung Galaxy S25 Ultra (12GB/256GB)",
                "brand": "Samsung",
                "price": 129999.0,
                "category": "smartphones",
                "specs": {"ram": "12GB", "processor": "Snapdragon 8 Elite"}
            },
            {
                "id": "phone-001",
                "name": "Apple iPhone 16 Pro (128GB)",
                "brand": "Apple",
                "price": 119900.0,
                "category": "smartphones",
                "specs": {"ram": "8GB", "processor": "Apple A18 Pro"}
            }
        ],
        "category": "smartphones",
        "min_budget": 0,
        "max_budget": 0,
        "intended_usages": [],
        "priorities": ["performance"],
        "allow_budget_flexibility": True
    }
    res = client.post("/api/compare/evaluate", json=eval_payload)
    assert res.status_code == 200
    data = res.json()
    assert "ranked_products" in data
    assert len(data["ranked_products"]) == 2
    # Verify dynamic distinction badges exist
    assert any("merit_badge" in r for r in data["ranked_products"])


# -----------------------------------------------------------------------------
# 13. Correct price and specifications displayed for each model
# -----------------------------------------------------------------------------
def test_13_correct_price_and_specifications_displayed_for_each_model():
    """
    Each model in comparison card maintains distinct pricing and non-duplicated specs.
    """
    eval_payload = {
        "items": [
            {
                "id": "phone-009",
                "name": "Samsung Galaxy S25 Ultra (12GB/256GB)",
                "brand": "Samsung",
                "price": 129999.0,
                "category": "smartphones",
                "specs": {"ram": "12GB", "storage": "256GB", "battery": "5000 mAh"}
            },
            {
                "id": "phone-010",
                "name": "Samsung Galaxy S25 Ultra (16GB/512GB)",
                "brand": "Samsung",
                "price": 141999.0,
                "category": "smartphones",
                "specs": {"ram": "16GB", "storage": "512GB", "battery": "5000 mAh"}
            }
        ],
        "category": "smartphones"
    }
    res = client.post("/api/compare/evaluate", json=eval_payload)
    assert res.status_code == 200
    ranked = res.json()["ranked_products"]

    prod_256 = next(r["product"] for r in ranked if r["product"]["id"] == "phone-009")
    prod_512 = next(r["product"] for r in ranked if r["product"]["id"] == "phone-010")

    assert prod_256["price"] == 129999.0
    assert prod_512["price"] == 141999.0
    assert "12GB" in prod_256["specs"]["ram"]
    assert "16GB" in prod_512["specs"]["ram"]
    assert "256GB" in prod_256["specs"]["storage"]
    assert "512GB" in prod_512["specs"]["storage"]


# -----------------------------------------------------------------------------
# 14. Unsafe redirects rejected (SSRF Protection)
# -----------------------------------------------------------------------------
def test_14_unsafe_redirects_rejected():
    """
    Validates that localhost, internal IPs, cloud metadata endpoints, and redirect loops
    are strictly rejected.
    """
    unsafe_cases = [
        "http://localhost:8080/exploit",
        "http://127.0.0.1/admin",
        "http://169.254.169.254/latest/meta-data/",
        "http://192.168.1.100/router",
        "http://10.0.0.1/private"
    ]
    for target in unsafe_cases:
        res = client.post("/api/compare/validate-urls", json={"urls": [target, "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro"]})
        assert res.status_code == 200
        data = res.json()
        assert data["overall_status"] == "error"

    # Shortened link redirecting to localhost / metadata
    with patch.object(urllib.request.OpenerDirector, "open") as mock_open:
        mock_open.side_effect = HTTPError(
            url="https://amzn.to/evil",
            code=301,
            msg="Moved",
            hdrs={"Location": "http://169.254.169.254/latest/meta-data/"},
            fp=None
        )
        resolved, err = resolve_shortened_retailer_url("https://amzn.to/evil")
        assert resolved is None
        assert "unsafe destination" in err


# -----------------------------------------------------------------------------
# 15. Existing project tests and features remain intact
# -----------------------------------------------------------------------------
def test_15_existing_project_tests_and_features_remain_intact(validator):
    """
    Ensures non-smartphone categories (laptops, running shoes, kitchen appliances, etc.)
    continue to match, validate, and compare with full fidelity.
    """
    # Laptop
    res_laptop = validator.validate_product_url("https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop")
    assert res_laptop["status"] == "valid"
    assert res_laptop["matched_catalog_product"]["id"] == "elec-001"

    # Footwear
    res_shoe = validator.validate_product_url("https://www.nike.com/in/t/pegasus-41-road-running-shoes-4589")
    assert res_shoe["status"] == "valid"
    assert res_shoe["matched_catalog_product"]["id"] == "shoe-001"

    # Kitchen appliance
    res_fryer = validator.validate_product_url("https://www.amazon.in/Ninja-Air-Fryer-Stainless-Steel/dp/B08N5K")
    assert res_fryer["status"] == "valid"
    assert res_fryer["category"] == "home_kitchen"

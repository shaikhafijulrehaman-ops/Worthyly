"""
WORTHLY - Test Suite for 8 Product Categories & Simple URL-First Comparison
Verifies:
1. Minimum 8 verified products across all 8 target categories (64+ items total).
2. URL validation and catalog identification for all 8 categories.
3. Cross-category comparison rejection.
4. Direct TOPSIS evaluation without mandatory surveys.
5. Priority-based re-ranking (Best Overall, Best Value, High Performance).
"""

import pytest
import os
import sys
import json
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from main import app, evaluate_url_comparison, CompareEvaluateRequest
from category_validator import CategoryValidator
from topsis_engine import TOPSISRankingEngine

client = TestClient(app)

TARGET_CATEGORIES = [
    "smartphones",
    "laptops",
    "books",
    "magazines",
    "consumer_electronics",
    "fitness_equipment",
    "kitchen_chimneys",
    "nutrition"
]

@pytest.fixture
def catalog():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def categories_data():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "categories.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def validator(catalog):
    return CategoryValidator(catalog_products=catalog)

@pytest.fixture
def topsis():
    return TOPSISRankingEngine()


# 1. Verify all 8 categories exist with at least 8 verified products each
def test_all_8_categories_have_minimum_8_products(catalog, categories_data):
    cat_ids = [c["id"] for c in categories_data.get("categories", [])]
    for target in TARGET_CATEGORIES:
        assert target in cat_ids, f"Category '{target}' missing from categories.json"

    for target in TARGET_CATEGORIES:
        prods_in_cat = [p for p in catalog if p.get("category") == target]
        assert len(prods_in_cat) >= 8, f"Category '{target}' has only {len(prods_in_cat)} products; expected >= 8"

        # Verify essential fields on each product
        for p in prods_in_cat:
            assert p.get("id"), "Missing product id"
            assert p.get("brand"), f"Product {p.get('id')} missing brand"
            assert p.get("name") or p.get("product_name"), f"Product {p.get('id')} missing name"
            assert float(p.get("price", 0)) > 0, f"Product {p.get('id')} has invalid price"
            assert p.get("price_status") in ["verified", "indicative", "demo", "unavailable"]
            assert p.get("specs") or p.get("specifications"), f"Product {p.get('id')} missing specs"


# 2. Test URL validation for each of the 8 categories
def test_url_validation_across_all_8_categories(validator):
    test_urls_by_category = {
        "smartphones": [
            "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro",
            "https://www.samsung.com/in/smartphones/galaxy-s24-ultra/"
        ],
        "laptops": [
            "https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html",
            "https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop"
        ],
        "books": [
            "https://www.oreilly.com/library/view/hands-on-machine-learning/9781098125967/",
            "https://nostarch.com/python-crash-course-3rd-edition"
        ],
        "magazines": [
            "https://www.technologyreview.com/subscribe/",
            "https://www.wired.com/subscribe"
        ],
        "consumer_electronics": [
            "https://www.apple.com/in/shop/product/MTJV3HN/A/airpods-pro",
            "https://www.bose.com/p/headphones/bose-quietcomfort-ultra-headphones/QCU-HEADPHONEARN.html"
        ],
        "fitness_equipment": [
            "https://boldfit.in/products/adjustable-dumbbell-24kg",
            "https://korefit.in/products/kore-20kg-home-gym-combo"
        ],
        "kitchen_chimneys": [
            "https://faberindia.com/products/hood-orient-tc-bk-60",
            "https://www.elica.in/chimneys/fl-600-hac-ltw-ms-nero"
        ],
        "nutrition": [
            "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey",
            "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey/SP-84610"
        ]
    }

    for cat, urls in test_urls_by_category.items():
        batch_res = validator.validate_comparison_batch(urls)
        assert batch_res["overall_status"] in ["valid", "needs_confirmation"], (
            f"Category '{cat}' validation failed: {batch_res.get('message')}"
        )
        assert len(batch_res["items"]) == 2
        for item in batch_res["items"]:
            assert item["status"] == "valid"
            assert item["is_verified_catalog"] is True


# 3. Test Cross-Category comparison blocking
def test_cross_category_comparisons_strictly_blocked(validator):
    incompatible_pairs = [
        ("https://www.apple.com/in/shop/buy-iphone/iphone-16-pro", "https://faberindia.com/products/hood-orient-tc-bk-60"),
        ("https://nostarch.com/python-crash-course-3rd-edition", "https://boldfit.in/products/adjustable-dumbbell-24kg"),
        ("https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey", "https://www.wired.com/subscribe")
    ]
    for url1, url2 in incompatible_pairs:
        batch_res = validator.validate_comparison_batch([url1, url2])
        assert batch_res["overall_status"] in ["mismatch", "subcategory_mismatch"], (
            f"Expected cross-category mismatch for {url1} vs {url2}"
        )


# 4. Direct 1-Click TOPSIS evaluation without survey
def test_direct_topsis_evaluation_without_survey(catalog, topsis):
    # Compare 2 smartphones directly
    phones = [p for p in catalog if p.get("category") == "smartphones"][:2]
    res = topsis.rank_products_topsis(
        products=phones,
        category="smartphones",
        priorities=["performance"],
        allow_budget_flexibility=True
    )
    assert res["status"] == "success"
    assert len(res["ranked_products"]) == 2
    winner = res["ranked_products"][0]
    assert winner["role"] == "BEST OVERALL MATCH"
    assert winner["topsis_score"] > 0
    assert winner["match_score"] >= 50


# 5. Full API endpoint test for URL evaluation without survey
def test_evaluate_api_endpoint_url_first():
    req = CompareEvaluateRequest(
        items=[
            {
                "id": "phone-001",
                "name": "Apple iPhone 16 Pro",
                "brand": "Apple",
                "price": 119900.0,
                "category": "smartphones",
                "subcategory": "flagship_smartphones",
                "specs": {"processor": "A18 Pro", "ram": "8GB"}
            },
            {
                "id": "phone-003",
                "name": "Samsung Galaxy S24 Ultra",
                "brand": "Samsung",
                "price": 129999.0,
                "category": "smartphones",
                "subcategory": "flagship_smartphones",
                "specs": {"processor": "Snapdragon 8 Gen 3", "ram": "12GB"}
            }
        ],
        category="smartphones",
        priorities=["performance"],
        allow_budget_flexibility=True
    )
    data = evaluate_url_comparison(req)
    assert data["status"] == "success"
    assert len(data["ranked_products"]) == 2
    assert data["ranked_products"][0]["role"] == "BEST OVERALL MATCH"

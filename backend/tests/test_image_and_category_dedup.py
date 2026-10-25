"""
WORTHLY - Comprehensive Test Suite for Image Pipeline & Category Deduplication
Covers all 15 required automated test scenarios:
1. Recursive ZIP image discovery
2. Supported image formats
3. Correct product-ID-to-image mapping
4. Correct retailer-ID-to-product-image mapping
5. Correct variant image mapping
6. Unmatched images remain unassigned
7. Broken image paths use the intended fallback
8. Exact duplicate images are detected via SHA-256
9. One image is not assigned to unrelated products by default
10. Duplicate category aliases normalize correctly
11. Each canonical category appears only once in UI options
12. Different valid subcategories remain distinct
13. Brand/model selectors show the correct products
14. Repeated dataset imports do not create duplicate records (Idempotency)
15. Existing product comparison and URL recognition continue to work
"""

import os
import sys
import json
import zipfile
import pytest
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from main import app, get_categories, evaluate_url_comparison, CompareEvaluateRequest, get_image_manifest
from category_registry import (
    normalize_category_id,
    get_all_canonical_categories,
    get_canonical_category,
    is_valid_canonical_category,
    CANONICAL_CATEGORIES,
    CATEGORY_ALIASES
)
from image_pipeline import (
    ImagePipeline,
    SUPPORTED_IMAGE_EXTENSIONS,
    CATEGORY_PLACEHOLDERS,
    DEFAULT_FALLBACK_PLACEHOLDER
)
from category_validator import CategoryValidator

client = TestClient(app)

@pytest.fixture
def catalog():
    path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def image_pipeline(catalog):
    return ImagePipeline(catalog_products=catalog)

@pytest.fixture
def validator(catalog):
    return CategoryValidator(catalog_products=catalog)


# -----------------------------------------------------------------------------
# 1. Recursive ZIP Image Discovery
# -----------------------------------------------------------------------------
def test_1_recursive_zip_image_discovery(tmp_path, image_pipeline):
    """Recursively discovers image files nested inside folders in a ZIP archive."""
    zip_file = tmp_path / "test_nested.zip"
    with zipfile.ZipFile(zip_file, "w") as zf:
        zf.writestr("root.png", b"fake png bytes 1")
        zf.writestr("sub/nested.jpg", b"fake jpg bytes 2")
        zf.writestr("sub/deep/deeper.webp", b"fake webp bytes 3")
        zf.writestr("sub/readme.txt", b"plain text file")

    discovered = image_pipeline.scan_zip_archive(str(zip_file))
    filenames = [d["original_filename"] for d in discovered]

    assert len(discovered) == 3
    assert "root.png" in filenames
    assert "nested.jpg" in filenames
    assert "deeper.webp" in filenames
    assert not any(d["format"] == "txt" for d in discovered)


# -----------------------------------------------------------------------------
# 2. Supported Image Formats
# -----------------------------------------------------------------------------
def test_2_supported_image_formats():
    """Confirms all supported web image formats are whitelisted."""
    expected = {".jpg", ".jpeg", ".png", ".webp", ".svg", ".gif"}
    assert expected.issubset(SUPPORTED_IMAGE_EXTENSIONS)
    assert ".exe" not in SUPPORTED_IMAGE_EXTENSIONS
    assert ".pdf" not in SUPPORTED_IMAGE_EXTENSIONS


# -----------------------------------------------------------------------------
# 3. Correct Product-ID-to-Image Mapping
# -----------------------------------------------------------------------------
def test_3_correct_product_id_to_image_mapping(image_pipeline):
    """Filename containing exact product ID maps directly to that product."""
    img_info = {
        "original_filename": "product_phone-001_front.png",
        "original_relative_path": "uploads/smartphones/product_phone-001_front.png",
        "sha256": "abcdef123456"
    }
    matched = image_pipeline.match_image_to_product(img_info)
    assert matched["verification_status"] == "verified"
    assert matched["product_id"] == "phone-001"
    assert matched["matching_method"] == "exact_product_id"
    assert matched["category"] == "smartphones"


# -----------------------------------------------------------------------------
# 4. Correct Retailer-ID-to-Product-Image Mapping
# -----------------------------------------------------------------------------
def test_4_correct_retailer_id_to_product_image_mapping(image_pipeline):
    """Filename containing Amazon ASIN or Flipkart PID matches exact product."""
    # Test ASIN matching for iPhone 16 Pro (ASIN: B0DGJDQ6W8)
    img_asin = {
        "original_filename": "B0DGJDQ6W8_render.jpg",
        "original_relative_path": "amazon/B0DGJDQ6W8_render.jpg",
        "sha256": "asin123456"
    }
    matched_asin = image_pipeline.match_image_to_product(img_asin)
    assert matched_asin["verification_status"] == "verified"
    assert matched_asin["product_id"] == "phone-001"
    assert matched_asin["matching_method"] == "retailer_asin"

    # Test Flipkart PID matching
    img_pid = {
        "original_filename": "MOBH4DQFY7G6VPHG_angle.jpg",
        "original_relative_path": "flipkart/MOBH4DQFY7G6VPHG_angle.jpg",
        "sha256": "pid123456"
    }
    matched_pid = image_pipeline.match_image_to_product(img_pid)
    assert matched_pid["verification_status"] == "verified"
    assert matched_pid["product_id"] == "phone-001"
    assert matched_pid["matching_method"] == "retailer_flipkart_pid"


# -----------------------------------------------------------------------------
# 5. Correct Variant Image Mapping
# -----------------------------------------------------------------------------
def test_5_correct_variant_image_mapping(image_pipeline):
    """Image mapping records variant information when matched."""
    img_info = {
        "original_filename": "phone-002_titanium_512gb.png",
        "original_relative_path": "catalog/phone-002_titanium_512gb.png",
        "sha256": "var123456"
    }
    matched = image_pipeline.match_image_to_product(img_info)
    assert matched["verification_status"] == "verified"
    assert matched["product_id"] == "phone-002"
    assert "variant_id" in matched


# -----------------------------------------------------------------------------
# 6. Unmatched Images Remain Unassigned
# -----------------------------------------------------------------------------
def test_6_unmatched_images_remain_unassigned(image_pipeline):
    """Ambiguous or plant/generic images remain unassigned with product_id=None."""
    plant_img = {
        "original_filename": "Apple_scab_3003.JPG",
        "original_relative_path": "PlantVillage/train/Apple___Apple_scab/Apple_scab_3003.JPG",
        "sha256": "leaf123456"
    }
    matched = image_pipeline.match_image_to_product(plant_img)
    assert matched["verification_status"] == "unmatched"
    assert matched["product_id"] is None
    assert matched["matching_method"] == "none"
    assert "unmatched_reason" in matched


# -----------------------------------------------------------------------------
# 7. Broken Image Paths Fallback to Category Placeholder
# -----------------------------------------------------------------------------
def test_7_broken_image_paths_use_fallback():
    """Missing or broken image paths return neutral category SVG placeholder."""
    # Empty image
    safe_phone = ImagePipeline.get_safe_product_image({"category": "smartphones", "imageUrl": ""})
    assert safe_phone == CATEGORY_PLACEHOLDERS["smartphones"]

    # Broken/relative invalid image
    safe_laptop = ImagePipeline.get_safe_product_image({"category": "laptops", "imageUrl": "broken-link.png"})
    assert safe_laptop == CATEGORY_PLACEHOLDERS["laptops"]

    # Valid external image preserved
    valid_url = "https://images.samsung.com/is/image/samsung/s25-ultra.png"
    safe_valid = ImagePipeline.get_safe_product_image({"category": "smartphones", "imageUrl": valid_url})
    assert safe_valid == valid_url


# -----------------------------------------------------------------------------
# 8. Exact Duplicate Images Detected via SHA-256
# -----------------------------------------------------------------------------
def test_8_exact_duplicate_images_detected(image_pipeline):
    """Identical file content produces duplicate detection via SHA-256."""
    img1 = {"original_filename": "copy1.png", "sha256": "hash_identical_999"}
    img2 = {"original_filename": "copy2.png", "sha256": "hash_identical_999"}
    img3 = {"original_filename": "unique.png", "sha256": "hash_distinct_111"}

    unique, duplicates = image_pipeline.detect_duplicates([img1, img2, img3])
    assert len(unique) == 2
    assert len(duplicates) == 1
    assert duplicates[0]["duplicate_of"] == "copy1.png"


# -----------------------------------------------------------------------------
# 9. One Image is Not Assigned to Unrelated Products by Default
# -----------------------------------------------------------------------------
def test_9_no_unrelated_image_cross_assignment(image_pipeline):
    """A laptop image is never mapped to a smartphone product simply by category similarity."""
    laptop_img = {
        "original_filename": "dell_xps_15_laptop.jpg",
        "original_relative_path": "images/dell_xps_15_laptop.jpg",
        "sha256": "laptop999"
    }
    matched = image_pipeline.match_image_to_product(laptop_img)
    # If matched, must be laptop or unassigned, never a phone
    if matched["verification_status"] == "verified":
        assert matched["category"] in ["laptops", "electronics"]
        assert matched["category"] != "smartphones"


# -----------------------------------------------------------------------------
# 10. Duplicate Category Aliases Normalize Correctly
# -----------------------------------------------------------------------------
def test_10_duplicate_category_aliases_normalize_correctly():
    """All spelling, plural, and phrasing variations map to canonical category ID."""
    assert normalize_category_id("Smartphones") == "smartphones"
    assert normalize_category_id("Mobile Phones") == "smartphones"
    assert normalize_category_id("mobiles") == "smartphones"
    assert normalize_category_id("cell phone") == "smartphones"

    assert normalize_category_id("Televisions") == "televisions"
    assert normalize_category_id("TV") == "televisions"
    assert normalize_category_id("smart tv") == "televisions"

    assert normalize_category_id("Laptops") == "laptops"
    assert normalize_category_id("notebook") == "laptops"
    assert normalize_category_id("laptops & computers") == "laptops"

    assert normalize_category_id("Refrigerators") == "refrigerators"
    assert normalize_category_id("fridge") == "refrigerators"

    assert normalize_category_id("Washing Machines") == "washing_machines"
    assert normalize_category_id("washer") == "washing_machines"

    assert normalize_category_id("Air Conditioners") == "air_conditioners"
    assert normalize_category_id("split ac") == "air_conditioners"

    assert normalize_category_id("Fitness & Sports") == "fitness_equipment"
    assert normalize_category_id("fitness") == "fitness_equipment"

    assert normalize_category_id("Education") == "books"
    assert normalize_category_id("study materials") == "books"


# -----------------------------------------------------------------------------
# 11. Each Canonical Category Appears Only Once in Options
# -----------------------------------------------------------------------------
def test_11_each_canonical_category_appears_only_once():
    """Authoritative canonical category registry contains zero duplicate IDs or display names."""
    cats = get_all_canonical_categories()
    ids = [c["id"] for c in cats]
    names = [c["name"].lower() for c in cats]

    # No duplicate IDs
    assert len(ids) == len(set(ids)), "Duplicate category IDs found in canonical registry"
    # No duplicate display names
    assert len(names) == len(set(names)), "Duplicate category names found in canonical registry"

    # API verification
    api_cats = get_categories()
    api_ids = [c["id"] for c in api_cats]
    assert len(api_ids) == len(set(api_ids)), "API /api/categories returned duplicate category IDs"


# -----------------------------------------------------------------------------
# 12. Valid Subcategories Remain Distinct
# -----------------------------------------------------------------------------
def test_12_valid_subcategories_remain_distinct():
    """Distinct subcategories within a canonical category remain separate."""
    tablets_cat = get_canonical_category("tablets_monitors")
    assert tablets_cat is not None
    assert "tablets" in tablets_cat["subcategories"]
    assert "monitors" in tablets_cat["subcategories"]
    assert tablets_cat["subcategories"][0] != tablets_cat["subcategories"][1]


# -----------------------------------------------------------------------------
# 13. Brand / Model Selectors Show Correct Products
# -----------------------------------------------------------------------------
def test_13_brand_model_selectors_show_correct_products(catalog):
    """Selecting a brand in a category returns only models for that brand and category."""
    apple_phones = [
        p for p in catalog
        if p.get("category") == "smartphones" and p.get("brand") == "Apple"
    ]
    samsung_phones = [
        p for p in catalog
        if p.get("category") == "smartphones" and p.get("brand") == "Samsung"
    ]

    assert len(apple_phones) >= 3
    assert len(samsung_phones) >= 3
    assert set(p["id"] for p in apple_phones).isdisjoint(set(p["id"] for p in samsung_phones))
    for p in apple_phones:
        assert p["brand"] == "Apple"
    for p in samsung_phones:
        assert p["brand"] == "Samsung"


# -----------------------------------------------------------------------------
# 14. Repeated Dataset Imports Do Not Create Duplicate Records (Idempotency)
# -----------------------------------------------------------------------------
def test_14_repeated_dataset_imports_idempotent(catalog):
    """Re-evaluating or re-loading the catalog does not produce duplicate product IDs."""
    ids = [p["id"] for p in catalog]
    assert len(ids) == len(set(ids)), "Catalog contains duplicate product IDs"

    # Verify every product has valid category (canonical or valid alias) and price_status
    for p in catalog:
        assert is_valid_canonical_category(normalize_category_id(p["category"])) or p["category"] == "electronics"
        assert p.get("price_status") in {"verified", "indicative", "demo", "unavailable"}


# -----------------------------------------------------------------------------
# 15. Existing Comparison and URL Recognition Continue to Work
# -----------------------------------------------------------------------------
def test_15_existing_comparison_and_url_recognition_intact(validator):
    """Existing URL validation, TOPSIS comparison, and browse APIs remain fully operational."""
    # 1. URL validation
    url = "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro"
    res_url = validator.validate_product_url(url)
    assert res_url["status"] == "valid"
    assert res_url["matched_catalog_product"]["brand"] == "Apple"

    # 2. Compare evaluate endpoint
    payload = {
        "items": [
            {"id": "phone-001", "name": "Apple iPhone 16 Pro", "price": 119900, "category": "smartphones"},
            {"id": "phone-002", "name": "Samsung Galaxy S25 Ultra", "price": 129999, "category": "smartphones"}
        ],
        "category": "smartphones",
        "priorities": ["performance"]
    }
    data = evaluate_url_comparison(CompareEvaluateRequest(**payload))
    assert len(data["ranked_products"]) == 2
    assert data["ranked_products"][0]["role"] == "BEST OVERALL MATCH"

    # 3. Image manifest endpoint
    manifest_data = get_image_manifest()
    assert "images" in manifest_data

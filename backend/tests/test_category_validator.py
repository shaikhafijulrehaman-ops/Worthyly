"""
Unit tests for WORTHLY Category Validator & URL Inspection Module
"""

import pytest
import os
import sys
import json

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from category_validator import CategoryValidator, normalize_and_clean_url, is_safe_destination

@pytest.fixture
def sample_catalog():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def validator(sample_catalog):
    return CategoryValidator(catalog_products=sample_catalog)

def test_ssrf_blocking_local_and_private():
    """Ensure localhost, private IPs, and cloud metadata IPs are strictly blocked."""
    unsafe_destinations = [
        "localhost",
        "127.0.0.1",
        "10.0.0.1",
        "192.168.1.1",
        "172.16.0.5",
        "169.254.169.254", # AWS/GCP metadata
        "loopback"
    ]
    for dest in unsafe_destinations:
        safe, reason = is_safe_destination(dest)
        assert not safe, f"Expected {dest} to be blocked, but was deemed safe"
        assert reason is not None

def test_tracking_parameter_cleanup():
    """Ensure tracking tokens like utm_source, gclid, ref are stripped."""
    dirty_url = "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop?utm_source=google&utm_campaign=diwali&ref=affiliate_123&keep_this=1"
    cleaned, err = normalize_and_clean_url(dirty_url)
    assert err is None
    assert "utm_source" not in cleaned
    assert "utm_campaign" not in cleaned
    assert "ref=" not in cleaned
    assert "keep_this=1" in cleaned

def test_malformed_url():
    """Ensure malformed or non-http URLs fail cleanly."""
    malformed_urls = [
        "",
        "javascript:alert(1)",
        "ftp://example.com/item",
        "://invalid-url",
        "http://",
    ]
    for raw in malformed_urls:
        cleaned, err = normalize_and_clean_url(raw)
        assert cleaned is None
        assert err is not None

def test_catalog_matching(validator):
    """Ensure known URLs match verified products directly."""
    # Match Dell XPS from catalog
    known_url = "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop"
    res = validator.validate_product_url(known_url)
    assert res["status"] == "valid"
    assert res["is_verified_catalog"] is True
    assert res["category"] == "electronics"
    assert res["category_confidence"] == 1.0
    assert res["matched_catalog_product"]["id"] == "elec-001"

def test_category_rule_inference(validator):
    """Ensure category is inferred from uncataloged retail URL paths."""
    shoe_url = "https://www.nike.com/in/t/pegasus-41-road-running-shoes-4589"
    res = validator.validate_product_url(shoe_url)
    assert res["status"] == "valid"
    assert res["category"] == "footwear"
    assert res["category_confidence"] >= 0.85

    fryer_url = "https://www.amazon.in/Ninja-Air-Fryer-Stainless-Steel/dp/B08N5K"
    res = validator.validate_product_url(fryer_url)
    assert res["status"] == "valid"
    assert res["category"] == "home_kitchen"

def test_category_mismatch_rejection(validator):
    """Ensure comparison between products of different categories is rejected."""
    urls = [
        "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop", # Electronics
        "https://www.nike.com/in/t/pegasus-41-road-running-shoes-4589" # Footwear
    ]
    batch_res = validator.validate_comparison_batch(urls)
    assert batch_res["overall_status"] == "mismatch"
    assert "Cross-Category Comparison Blocked" in batch_res["message"]
    assert batch_res["common_category"] is None

def test_category_ambiguous_prompt(validator):
    """Ensure ambiguous URLs trigger clarification status."""
    ambiguous_url = "https://www.example-store.com/item/premium-bundle-pack-v2"
    res = validator.validate_product_url(ambiguous_url)
    assert res["status"] in {"ambiguous", "unknown"}

def test_duplicate_url_detection(validator):
    """Ensure duplicate URLs in comparison set are rejected."""
    urls = [
        "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop",
        "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop?utm_source=twitter"
    ]
    batch_res = validator.validate_comparison_batch(urls)
    assert batch_res["overall_status"] == "error"
    assert "Duplicate product URLs detected" in batch_res["message"]

def test_comparison_batch_success(validator):
    """Ensure valid homogeneous comparison batch succeeds."""
    urls = [
        "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop",
        "https://www.apple.com/in/shop/buy-mac/macbook-air/15-inch-m3"
    ]
    batch_res = validator.validate_comparison_batch(urls)
    assert batch_res["overall_status"] == "valid"
    assert batch_res["common_category"] == "electronics"
    assert len(batch_res["items"]) == 2

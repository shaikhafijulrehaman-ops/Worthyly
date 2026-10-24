"""
Unit tests for SmartBuy AI Recommendation Engine (INR Currency)
"""

import pytest
import json
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from recommendation_engine import RecommendationEngine

@pytest.fixture
def sample_products():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def engine(sample_products):
    return RecommendationEngine(sample_products)

def test_strict_budget_filtering(engine):
    """Ensure products above max_budget are strictly excluded unless flexibility is enabled."""
    max_budget = 90000.0
    res = engine.filter_and_score(
        category="electronics",
        min_budget=None,
        max_budget=max_budget,
        intended_usages=["programming"],
        priorities=["performance"],
        allow_budget_flexibility=False
    )
    assert res["status"] == "success"
    for rec in res["recommendations"]:
        assert rec["product"]["price"] <= max_budget, f"Product {rec['product']['name']} price {rec['product']['price']} exceeds {max_budget}"

def test_distinct_three_roles(engine):
    """Ensure exactly 3 distinct roles are assigned when at least 3 products exist."""
    res = engine.filter_and_score(
        category="electronics",
        min_budget=25000.0,
        max_budget=160000.0,
        intended_usages=["programming", "college"],
        priorities=["performance", "battery", "value"],
        allow_budget_flexibility=False
    )
    assert res["status"] == "success"
    recs = res["recommendations"]
    assert len(recs) == 3
    roles = [r["role"] for r in recs]
    assert "BEST OVERALL MATCH" in roles
    assert "BEST VALUE" in roles
    assert "BEST ALTERNATIVE" in roles

    # Ensure all 3 recommended products have unique IDs
    product_ids = [r["product"]["id"] for r in recs]
    assert len(set(product_ids)) == 3

def test_category_specific_rules_footwear(engine):
    """Ensure footwear scoring considers running/walking and comfort without crashing on non-existent RAM."""
    res = engine.filter_and_score(
        category="footwear",
        min_budget=5000.0,
        max_budget=15000.0,
        intended_usages=["running", "walking"],
        priorities=["comfort", "durability"],
        allow_budget_flexibility=False
    )
    assert res["status"] == "success"
    assert len(res["recommendations"]) >= 2
    # Verify why bullets mention cushioning or running
    reasons_combined = " ".join(" ".join(r["reasons"]) for r in res["recommendations"])
    assert "comfort" in reasons_combined.lower() or "midsole" in reasons_combined.lower() or "running" in reasons_combined.lower()

def test_insufficient_products_handling(engine):
    """Ensure clear explanation when budget is too low for any item."""
    res = engine.filter_and_score(
        category="electronics",
        min_budget=1000.0,
        max_budget=5000.0,  # No laptop/gadget exists in this range
        intended_usages=["gaming"],
        priorities=["performance"],
        allow_budget_flexibility=False
    )
    assert res["status"] == "insufficient_products"
    assert res["total_eligible"] == 0
    assert "No products in this category match your exact budget range" in res["message"]

def test_budget_finder_tiers(engine):
    """Test that Budget Finder returns distinct non-interchangeable tiers."""
    res = engine.find_budget_breakdown(
        category="electronics",
        budget=135000.0
    )
    assert res["status"] == "success"
    tiers = res["tiers"]
    assert "lowest_price" in tiers
    assert "budget_friendly" in tiers
    assert "best_value" in tiers
    assert "best_performance" in tiers
    # Lowest price product must be <= best performance price
    assert tiers["lowest_price"]["product"]["price"] <= tiers["best_performance"]["product"]["price"]

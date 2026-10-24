"""
Unit tests for WORTHLY TOPSIS Ranking Engine
"""

import pytest
import os
import sys
import json

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from topsis_engine import TOPSISRankingEngine

@pytest.fixture
def sample_products():
    data_path = os.path.join(os.path.dirname(__file__), "..", "data", "products.json")
    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

@pytest.fixture
def engine():
    return TOPSISRankingEngine()

def test_topsis_strict_budget_filtering(engine, sample_products):
    """Ensure products above max_budget are strictly excluded unless flexibility is enabled."""
    max_budget = 90000.0
    res = engine.rank_products_topsis(
        products=sample_products,
        category="electronics",
        min_budget=None,
        max_budget=max_budget,
        priorities=["performance"],
        allow_budget_flexibility=False
    )
    assert res["status"] == "success"
    for item in res["ranked_products"]:
        assert item["product"]["price"] <= max_budget, f"Product price {item['product']['price']} exceeded {max_budget}"

def test_topsis_distinct_three_roles(engine, sample_products):
    """Ensure exactly 3 distinct roles are assigned when at least 3 products exist."""
    res = engine.rank_products_topsis(
        products=sample_products,
        category="electronics",
        min_budget=25000.0,
        max_budget=160000.0,
        priorities=["performance", "battery", "value"],
        allow_budget_flexibility=False
    )
    assert res["status"] == "success"
    ranked = res["ranked_products"]
    assert len(ranked) == 3
    roles = [r["role"] for r in ranked]
    assert "BEST OVERALL MATCH" in roles
    assert "BEST VALUE" in roles
    assert "BEST ALTERNATIVE" in roles

    # Ensure unique IDs
    ids = [r["product"]["id"] for r in ranked]
    assert len(set(ids)) == 3

def test_topsis_benefit_vs_cost(engine):
    """Test that a cheaper product with equal specs receives a superior TOPSIS closeness score."""
    prods = [
        {
            "id": "p1", "name": "Budget Champ", "category": "electronics", "brand": "BrandA",
            "price": 50000.0, "rating": 4.5, "reviewCount": 100,
            "specs": {"ram": "16GB", "battery": "70 Wh", "weight": "1.5 kg"}
        },
        {
            "id": "p2", "name": "Overpriced Champ", "category": "electronics", "brand": "BrandB",
            "price": 95000.0, "rating": 4.5, "reviewCount": 100,
            "specs": {"ram": "16GB", "battery": "70 Wh", "weight": "1.5 kg"}
        }
    ]
    res = engine.rank_products_topsis(
        products=prods,
        category="electronics",
        priorities=["value"],
        max_budget=100000.0
    )
    assert res["status"] == "success"
    # p1 should have higher topsis score than p2 because price is a cost criterion (lower is better)
    ranked = res["ranked_products"]
    assert ranked[0]["product"]["id"] == "p1"
    assert ranked[0]["topsis_score"] > ranked[1]["topsis_score"]

def test_topsis_identical_alternatives_safe(engine):
    """Ensure identical products do not crash on zero division and receive 0.5 closeness."""
    identical = [
        {
            "id": "c1", "name": "Twin A", "category": "electronics", "brand": "Clone",
            "price": 60000.0, "rating": 4.5, "reviewCount": 50,
            "specs": {"ram": "16GB", "battery": "60 Wh", "weight": "1.6 kg"}
        },
        {
            "id": "c2", "name": "Twin B", "category": "electronics", "brand": "Clone",
            "price": 60000.0, "rating": 4.5, "reviewCount": 50,
            "specs": {"ram": "16GB", "battery": "60 Wh", "weight": "1.6 kg"}
        }
    ]
    res = engine.rank_products_topsis(
        products=identical,
        category="electronics",
        max_budget=80000.0
    )
    assert res["status"] == "success"
    assert len(res["ranked_products"]) == 2
    for r in res["ranked_products"]:
        assert 0.0 <= r["topsis_score"] <= 1.0

def test_topsis_data_completeness_tracking(engine):
    """Ensure data completeness score tracks missing fields."""
    incomplete = [
        {
            "id": "inc1", "name": "No Specs Device", "category": "electronics", "brand": "Generic",
            "price": 40000.0, "rating": 4.0, "reviewCount": 10,
            "specs": {} # all specs missing
        },
        {
            "id": "inc2", "name": "Full Specs Device", "category": "electronics", "brand": "Dell",
            "price": 45000.0, "rating": 4.5, "reviewCount": 100,
            "specs": {"ram": "16GB", "battery": "65 Wh", "weight": "1.7 kg"}
        }
    ]
    res = engine.rank_products_topsis(
        products=incomplete,
        category="electronics",
        max_budget=50000.0
    )
    assert res["status"] == "success"
    for r in res["ranked_products"]:
        if r["product"]["id"] == "inc1":
            assert r["data_completeness"] < 1.0
        elif r["product"]["id"] == "inc2":
            assert r["data_completeness"] == 1.0

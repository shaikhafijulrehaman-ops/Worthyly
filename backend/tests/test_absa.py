"""
Unit tests and evaluation suite for WORTHLY ABSA Engine
"""

import pytest
import os
import sys
import json

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from absa_engine import ABSAEngine

@pytest.fixture
def engine():
    return ABSAEngine()

@pytest.fixture
def gold_standard():
    path = os.path.join(os.path.dirname(__file__), "data", "absa_gold_standard.json")
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def test_contrastive_sentiment_extraction(engine):
    """Test standard contrastive review: excellent camera, quickly draining battery."""
    text = "The camera is excellent, but the battery drains quickly."
    res = engine.analyze_review_aspects(text, category="electronics")
    aspect_map = {r["aspect"]: r["polarity"] for r in res}
    
    assert "camera" in aspect_map, "Expected 'camera' aspect to be extracted"
    assert aspect_map["camera"] == "positive"
    
    assert "battery" in aspect_map, "Expected 'battery' aspect to be extracted"
    assert aspect_map["battery"] == "negative"

def test_negation_handling(engine):
    """Test that negation flips polarity properly."""
    positive_raw = "The screen is sharp and bright."
    negated_raw = "The screen is not sharp or bright."

    pos_res = engine.analyze_review_aspects(positive_raw, category="electronics")
    neg_res = engine.analyze_review_aspects(negated_raw, category="electronics")

    assert pos_res[0]["polarity"] == "positive"
    assert neg_res[0]["polarity"] == "negative"

def test_aggregation_and_deduplication(engine):
    """Test product-level aggregation across multiple reviews with duplicate removal."""
    reviews = [
        {
            "id": "r1",
            "reviewText": "Battery life easily lasts two full working days with zero issues.",
            "pros": "Long battery life",
            "cons": ""
        },
        {
            "id": "r2",
            "reviewText": "Battery life easily lasts two full working days with zero issues.", # duplicate
            "pros": "Long battery life",
            "cons": ""
        },
        {
            "id": "r3",
            "reviewText": "The laptop gets uncomfortably hot during long video rendering tasks.",
            "pros": "",
            "cons": "Runs hot"
        }
    ]
    agg = engine.aggregate_product_aspect_sentiments(reviews, category="electronics")
    assert "battery" in agg
    assert agg["battery"]["positive_count"] >= 1
    assert agg["battery"]["polarity_score"] > 0.0

    assert "thermals" in agg
    assert agg["thermals"]["negative_count"] >= 1
    assert agg["thermals"]["polarity_score"] < 0.0

def test_gold_standard_benchmark(engine, gold_standard):
    """
    Evaluates Precision, Recall, and F1 on the gold-standard dataset.
    """
    total_expected = 0
    total_predicted = 0
    correct_aspect_and_polarity = 0

    for item in gold_standard:
        expected = item["expected_aspects"]
        total_expected += len(expected)
        
        preds = engine.analyze_review_aspects(item["text"], category=item["category"])
        pred_map = {p["aspect"]: p["polarity"] for p in preds}
        total_predicted += len(preds)

        for exp in expected:
            exp_asp = exp["aspect"]
            exp_pol = exp["polarity"]
            if exp_asp in pred_map and pred_map[exp_asp] == exp_pol:
                correct_aspect_and_polarity += 1

    precision = correct_aspect_and_polarity / max(total_predicted, 1)
    recall = correct_aspect_and_polarity / max(total_expected, 1)
    f1 = (2 * precision * recall) / max(precision + recall, 1e-6)

    print(f"\nABSA Gold-Standard Benchmark: Precision={precision:.2f}, Recall={recall:.2f}, F1={f1:.2f}")

    assert precision >= 0.75, f"Precision {precision:.2f} below target 0.75"
    assert recall >= 0.75, f"Recall {recall:.2f} below target 0.75"
    assert f1 >= 0.75, f"F1 {f1:.2f} below target 0.75"

"""
Integration tests for WORTHLY FastAPI endpoints:
- URL validation
- Comparison evaluation (TOPSIS)
- Product aspect sentiment retrieval
- Recommendation feedback
"""

import pytest
import os
import sys
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from main import app

client = TestClient(app)

def test_health_check_endpoint():
    res = client.get("/api/health")
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "healthy"
    assert data["total_products"] > 0

def test_validate_urls_endpoint_success():
    payload = {
        "urls": [
            "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop",
            "https://www.apple.com/in/shop/buy-mac/macbook-air/15-inch-m3"
        ]
    }
    res = client.post("/api/compare/validate-urls", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["overall_status"] == "valid"
    assert data["common_category"] == "electronics"
    assert len(data["items"]) == 2

def test_validate_urls_endpoint_mismatch():
    payload = {
        "urls": [
            "https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop",
            "https://www.nike.com/in/t/pegasus-41-road-running-shoes-4589"
        ]
    }
    res = client.post("/api/compare/validate-urls", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["overall_status"] == "mismatch"
    assert "Cross-Category Comparison Blocked" in data["message"]

def test_evaluate_comparison_endpoint():
    payload = {
        "items": [
            {
                "id": "elec-001",
                "name": "Dell XPS 15 9530",
                "category": "electronics",
                "brand": "Dell",
                "price": 149990.0,
                "specs": {"ram": "32GB", "battery": "86 Wh", "weight": "1.86 kg"}
            },
            {
                "id": "elec-002",
                "name": "Apple MacBook Air 15 (M3)",
                "category": "electronics",
                "brand": "Apple",
                "price": 124900.0,
                "specs": {"ram": "16GB", "battery": "66.5 Wh", "weight": "1.51 kg"}
            }
        ],
        "category": "electronics",
        "min_budget": 50000.0,
        "max_budget": 160000.0,
        "intended_usages": ["programming", "office"],
        "priorities": ["performance", "battery"],
        "allow_budget_flexibility": False
    }
    res = client.post("/api/compare/evaluate", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "success"
    assert len(data["ranked_products"]) == 2
    assert "topsis_score" in data["ranked_products"][0]
    assert "role" in data["ranked_products"][0]
    assert data["category"] == "electronics"

def test_product_aspects_endpoint():
    res = client.get("/api/products/elec-001/aspects")
    assert res.status_code == 200
    data = res.json()
    assert data["productId"] == "elec-001"
    assert "aspects" in data

def test_recommendation_feedback_crud():
    payload = {
        "sessionId": "test-sess-001",
        "productId": "elec-001",
        "productName": "Dell XPS 15 9530",
        "userId": "test-user-99",
        "metRequirements": True,
        "satisfactionScore": 5,
        "wouldRecommend": True,
        "aspectsBetter": ["performance", "display"],
        "aspectsWorse": ["thermals"],
        "feedbackNotes": "Exceeded my expectations for local container runs.",
        "isVerifiedBuyer": True,
        "algorithmVersion": "topsis_v1"
    }
    create_res = client.post("/api/feedback/recommendation", json=payload)
    assert create_res.status_code == 201
    created_data = create_res.json()
    assert created_data["status"] == "success"
    assert "feedbackId" in created_data

    # Query feedback
    list_res = client.get("/api/feedback/recommendation?user_id=test-user-99")
    assert list_res.status_code == 200
    list_data = list_res.json()
    assert list_data["total"] >= 1
    assert any(f["productId"] == "elec-001" for f in list_data["feedback"])

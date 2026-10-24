"""
SmartBuy AI - FastAPI Backend API Server
Provides high-performance endpoints for recommendation generation, product catalog exploration,
comparisons, verified community reviews, and budget discovery.
"""

from fastapi import FastAPI, HTTPException, Query, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
import json
import sys
import os
import uuid
from datetime import datetime, timezone

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from recommendation_engine import RecommendationEngine
from category_validator import CategoryValidator, infer_subcategory, PRODUCT_SUBCATEGORIES
from topsis_engine import TOPSISRankingEngine
from absa_engine import ABSAEngine

app = FastAPI(
    title="WORTHLY API",
    description="WORTHLY - Know What It's Worth. Intelligent product purchase decision platform API",
    version="1.0.0"
)

# CORS Middleware to allow frontend Vite development and production
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Data paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BASE_DIR, "data")
PRODUCTS_FILE = os.path.join(DATA_DIR, "products.json")
CATEGORIES_FILE = os.path.join(DATA_DIR, "categories.json")
REVIEWS_FILE = os.path.join(DATA_DIR, "reviews.json")
SAVED_FILE = os.path.join(DATA_DIR, "saved_items.json")
COMPARISONS_FILE = os.path.join(DATA_DIR, "saved_comparisons.json")
FEEDBACK_FILE = os.path.join(DATA_DIR, "recommendation_feedback.json")

def load_json(filepath: str, default: Any):
    if os.path.exists(filepath):
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            return default
    return default

def save_json(filepath: str, data: Any):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

# Load data into memory
PRODUCTS = load_json(PRODUCTS_FILE, [])
CATEGORIES_DATA = load_json(CATEGORIES_FILE, {"categories": []})
CATEGORIES = CATEGORIES_DATA.get("categories", [])
REVIEWS = load_json(REVIEWS_FILE, [])
SAVED_ITEMS = load_json(SAVED_FILE, [])
SAVED_COMPARISONS = load_json(COMPARISONS_FILE, [])
FEEDBACK = load_json(FEEDBACK_FILE, [])

engine = RecommendationEngine(PRODUCTS)
category_validator = CategoryValidator(PRODUCTS)
topsis_engine = TOPSISRankingEngine()
absa_engine = ABSAEngine()

# Models
class RecommendationRequest(BaseModel):
    category: str
    min_budget: Optional[float] = None
    max_budget: Optional[float] = None
    intended_usages: List[str] = []
    priorities: List[str] = []
    optional_specs: Optional[Dict[str, Any]] = None
    allow_budget_flexibility: bool = False
    ranking_algorithm: Optional[str] = None

class BudgetFinderRequest(BaseModel):
    category: str
    budget: float

class ValidateUrlsRequest(BaseModel):
    urls: List[str]

class CompareEvaluateRequest(BaseModel):
    items: List[Dict[str, Any]]
    category: str
    min_budget: Optional[float] = None
    max_budget: Optional[float] = None
    intended_usages: List[str] = []
    priorities: List[str] = []
    optional_specs: Optional[Dict[str, Any]] = None
    allow_budget_flexibility: bool = False

class FeedbackCreateRequest(BaseModel):
    sessionId: Optional[str] = None
    productId: str
    productName: Optional[str] = None
    userId: Optional[str] = "demo-user"
    metRequirements: bool
    satisfactionScore: int = Field(..., ge=1, le=5)
    wouldRecommend: bool
    aspectsBetter: List[str] = []
    aspectsWorse: List[str] = []
    feedbackNotes: Optional[str] = ""
    isVerifiedBuyer: bool = False
    algorithmVersion: Optional[str] = "topsis_v1"

class ReviewCreateRequest(BaseModel):
    productId: str
    productName: str
    author: str = "Anonymous Shopper"
    rating: int = Field(..., ge=1, le=5)
    title: str
    reviewText: str
    intendedUsage: str
    pros: str
    cons: str
    purchasePrice: Optional[float] = None
    purchaseDate: Optional[str] = None
    isVerifiedPurchase: bool = False

class SaveProductRequest(BaseModel):
    productId: str
    userId: Optional[str] = "demo-user"

class SaveComparisonRequest(BaseModel):
    title: str
    productIds: List[str]
    userId: Optional[str] = "demo-user"
    notes: Optional[str] = ""

# Routes
@app.get("/api/health")
def health_check():
    return {
        "status": "healthy",
        "service": "WORTHLY Backend",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "total_products": len(PRODUCTS),
        "total_categories": len(CATEGORIES)
    }

@app.get("/api/categories")
def get_categories():
    return CATEGORIES

@app.get("/api/products")
def list_products(
    category: Optional[str] = None,
    brand: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    search: Optional[str] = None,
    sort_by: Optional[str] = "rating"
):
    results = list(PRODUCTS)

    if category and category != "all":
        results = [p for p in results if p.get("category") == category]

    if brand and brand != "all":
        results = [p for p in results if p.get("brand", "").lower() == brand.lower()]

    if min_price is not None:
        results = [p for p in results if float(p.get("price", 0)) >= min_price]

    if max_price is not None:
        results = [p for p in results if float(p.get("price", 0)) <= max_price]

    if search:
        s = search.lower().strip()
        results = [
            p for p in results
            if s in p.get("name", "").lower()
            or s in p.get("brand", "").lower()
            or any(s in str(v).lower() for v in p.get("specs", {}).values())
            or any(s in feat.lower() for feat in p.get("features", []))
        ]

    # Sorting
    if sort_by == "price_asc":
        results.sort(key=lambda x: float(x.get("price", 0)))
    elif sort_by == "price_desc":
        results.sort(key=lambda x: float(x.get("price", 0)), reverse=True)
    elif sort_by == "rating":
        results.sort(key=lambda x: float(x.get("rating", 0)), reverse=True)
    elif sort_by == "review_count":
        results.sort(key=lambda x: int(x.get("reviewCount", 0)), reverse=True)
    elif sort_by == "name":
        results.sort(key=lambda x: x.get("name", "").lower())

    return {
        "count": len(results),
        "products": results
    }

@app.get("/api/products/{product_id}")
def get_product(product_id: str):
    for p in PRODUCTS:
        if p["id"] == product_id:
            # Attach related reviews
            prod_reviews = [r for r in REVIEWS if r.get("productId") == product_id]
            return {
                **p,
                "reviews": prod_reviews
            }
    raise HTTPException(status_code=404, detail="Product not found")

@app.post("/api/recommendations")
def get_recommendations(req: RecommendationRequest):
    result = engine.filter_and_score(
        category=req.category,
        min_budget=req.min_budget,
        max_budget=req.max_budget,
        intended_usages=req.intended_usages,
        priorities=req.priorities,
        optional_specs=req.optional_specs,
        allow_budget_flexibility=req.allow_budget_flexibility,
        ranking_algorithm=req.ranking_algorithm
    )
    return result

@app.post("/api/budget-finder")
def get_budget_finder(req: BudgetFinderRequest):
    return engine.find_budget_breakdown(
        category=req.category,
        budget=req.budget
    )

# URL Comparison Shootout Endpoints
@app.get("/api/catalog/browse")
def browse_catalog():
    """
    Returns categories, matching subcategories, and verified products
    organized for Mode B comparison browsing.
    """
    browse_data = []
    for cat in CATEGORIES:
        cat_id = cat["id"]
        subcats = PRODUCT_SUBCATEGORIES.get(cat_id, {})
        cat_products = [p for p in PRODUCTS if p.get("category") == cat_id]

        subcat_list = []
        for sc_id, sc_def in subcats.items():
            matching_prods = []
            for p in cat_products:
                inferred_sc, _ = infer_subcategory(p, cat_id)
                if inferred_sc == sc_id:
                    matching_prods.append({
                        "id": p["id"],
                        "name": p["name"],
                        "brand": p["brand"],
                        "price": p["price"],
                        "rating": p.get("rating"),
                        "reviewCount": p.get("reviewCount", 0),
                        "imageUrl": p.get("imageUrl"),
                        "specs": p.get("specs", {}),
                        "officialProductUrl": p.get("officialProductUrl"),
                        "subcategory": sc_id,
                        "subcategory_label": sc_def["label"]
                    })

            subcat_list.append({
                "id": sc_id,
                "label": sc_def["label"],
                "criteria": sc_def.get("criteria", []),
                "products": matching_prods
            })

        browse_data.append({
            "id": cat_id,
            "name": cat["name"],
            "description": cat.get("description"),
            "subcategories": subcat_list
        })

    return {"categories": browse_data}

@app.post("/api/compare/validate-urls")
def validate_compare_urls(req: ValidateUrlsRequest):
    """
    Validates 2 to 5 product URLs for safety, catalog matching, and cross-category consistency.
    """
    return category_validator.validate_comparison_batch(req.urls)

@app.post("/api/compare/evaluate")
def evaluate_url_comparison(req: CompareEvaluateRequest):
    """
    Executes TOPSIS multi-criteria shootout evaluation on the comparison set,
    incorporating verified specs, user survey priorities, and aspect-level review sentiment.
    """
    if not req.items or len(req.items) < 2:
        raise HTTPException(status_code=400, detail="At least 2 products are required for comparison.")

    # Guard against generic unconfirmed items
    for idx, item in enumerate(req.items):
        item_name = (item.get("name") or "").strip()
        if not item_name or "submitted item" in item_name.lower():
            raise HTTPException(
                status_code=400,
                detail=f"Product #{idx+1} does not have a confirmed product identity. Please confirm exact brand and model before ranking."
            )

    # Hydrate products
    hydrated_products = []
    aspect_sentiments_by_id = {}

    for idx, item in enumerate(req.items):
        prod_id = item.get("id") or f"custom-{idx+1}"
        cat_match = next((p for p in PRODUCTS if p["id"] == prod_id), None)
        if not cat_match:
            cat_match = next((p for p in PRODUCTS if p.get("name", "").lower() == item.get("name", "").lower()), None)

        effective_prod = dict(cat_match) if cat_match else dict(item)
        effective_prod["id"] = prod_id
        effective_prod["category"] = req.category
        effective_prod["is_verified"] = bool(cat_match)
        effective_prod["data_source"] = "verified_catalog" if cat_match else "user_provided"

        if "price" not in effective_prod or effective_prod["price"] is None:
            effective_prod["price"] = float(item.get("price", 0))

        # Infer subcategory
        subcat_key, subcat_label = infer_subcategory(effective_prod, req.category)
        effective_prod["subcategory"] = subcat_key
        effective_prod["subcategory_label"] = subcat_label

        hydrated_products.append(effective_prod)

        # Extract reviews and compute aspect sentiments
        prod_reviews = [r for r in REVIEWS if r.get("productId") == effective_prod.get("id")]
        if prod_reviews:
            agg_aspects = absa_engine.aggregate_product_aspect_sentiments(prod_reviews, req.category)
            aspect_sentiments_by_id[prod_id] = {asp: data["polarity_score"] for asp, data in agg_aspects.items()}
            effective_prod["aspect_breakdown"] = agg_aspects
        else:
            aspect_sentiments_by_id[prod_id] = {}
            effective_prod["aspect_breakdown"] = {}

    # Check for cross-subcategory mismatch (e.g. Laptops vs Headphones)
    subcats_in_batch = set(p.get("subcategory") for p in hydrated_products if p.get("subcategory"))
    if len(subcats_in_batch) > 1:
        labels = list(dict.fromkeys(p.get("subcategory_label", p.get("subcategory")) for p in hydrated_products))
        raise HTTPException(
            status_code=400,
            detail=f"Incompatible subcategories in comparison set ({' vs '.join(labels)}). Products must belong to the same subcategory for a valid side-by-side comparison."
        )

    # Run TOPSIS Multi-Criteria Ranking
    topsis_res = topsis_engine.rank_products_topsis(
        products=hydrated_products,
        category=req.category,
        priorities=req.priorities,
        intended_usages=req.intended_usages,
        min_budget=req.min_budget,
        max_budget=req.max_budget,
        optional_specs=req.optional_specs,
        allow_budget_flexibility=req.allow_budget_flexibility,
        aspect_sentiments=aspect_sentiments_by_id
    )

    return {
        **topsis_res,
        "category": req.category,
        "aspect_sentiments": aspect_sentiments_by_id
    }

@app.get("/api/products/{product_id}/aspects")
def get_product_aspects(product_id: str):
    """
    Returns granular aspect-based sentiment breakdown for a product from community reviews.
    """
    prod = next((p for p in PRODUCTS if p["id"] == product_id), None)
    if not prod:
        raise HTTPException(status_code=404, detail="Product not found")

    prod_reviews = [r for r in REVIEWS if r.get("productId") == product_id]
    agg = absa_engine.aggregate_product_aspect_sentiments(prod_reviews, prod.get("category", "electronics"))
    return {
        "productId": product_id,
        "productName": prod.get("name"),
        "category": prod.get("category"),
        "totalReviewsAnalyzed": len(prod_reviews),
        "aspects": agg
    }

# Recommendation Feedback Endpoints
@app.post("/api/feedback/recommendation", status_code=status.HTTP_201_CREATED)
def submit_recommendation_feedback(req: FeedbackCreateRequest):
    """
    Ingests post-use feedback to evaluate recommendation quality over time.
    """
    new_entry = {
        "id": f"fb-{uuid.uuid4().hex[:8]}",
        "sessionId": req.sessionId or f"sess-{uuid.uuid4().hex[:6]}",
        "productId": req.productId,
        "productName": req.productName or "Recommended Product",
        "userId": req.userId,
        "metRequirements": req.metRequirements,
        "satisfactionScore": req.satisfactionScore,
        "wouldRecommend": req.wouldRecommend,
        "aspectsBetter": req.aspectsBetter,
        "aspectsWorse": req.aspectsWorse,
        "feedbackNotes": req.feedbackNotes,
        "isVerifiedBuyer": req.isVerifiedBuyer,
        "algorithmVersion": req.algorithmVersion,
        "createdAt": datetime.now(timezone.utc).isoformat()
    }
    FEEDBACK.insert(0, new_entry)
    save_json(FEEDBACK_FILE, FEEDBACK)
    return {
        "status": "success",
        "message": "Thank you for helping WORTHLY improve. Your feedback was recorded.",
        "feedbackId": new_entry["id"]
    }

@app.get("/api/feedback/recommendation")
def list_recommendation_feedback(user_id: Optional[str] = "demo-user"):
    user_fb = [f for f in FEEDBACK if f.get("userId") == user_id]
    return {
        "total": len(user_fb),
        "feedback": user_fb
    }

# Reviews endpoints
@app.get("/api/reviews")
def get_reviews(
    product_id: Optional[str] = None,
    min_rating: Optional[int] = None,
    verified_only: Optional[bool] = False
):
    results = list(REVIEWS)
    if product_id:
        results = [r for r in results if r.get("productId") == product_id]
    if min_rating:
        results = [r for r in results if int(r.get("rating", 0)) >= min_rating]
    if verified_only:
        results = [r for r in results if r.get("isVerifiedPurchase")]

    # Calculate review stats
    total = len(results)
    avg_rating = round(sum(r.get("rating", 5) for r in results) / max(total, 1), 2) if total else 0
    rating_distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0}
    for r in results:
        star = int(r.get("rating", 5))
        if star in rating_distribution:
            rating_distribution[star] += 1

    return {
        "total": total,
        "average_rating": avg_rating,
        "distribution": rating_distribution,
        "reviews": results
    }

@app.post("/api/reviews", status_code=status.HTTP_201_CREATED)
def create_review(req: ReviewCreateRequest):
    new_review = {
        "id": f"rev-{uuid.uuid4().hex[:8]}",
        "productId": req.productId,
        "productName": req.productName,
        "author": req.author,
        "rating": req.rating,
        "title": req.title,
        "reviewText": req.reviewText,
        "intendedUsage": req.intendedUsage,
        "pros": req.pros,
        "cons": req.cons,
        "purchasePrice": req.purchasePrice,
        "purchaseDate": req.purchaseDate or datetime.now(timezone.utc).strftime("%Y-%m-%d"),
        "isVerifiedPurchase": req.isVerifiedPurchase,
        "helpfulCount": 0,
        "createdAt": datetime.now(timezone.utc).isoformat()
    }
    REVIEWS.insert(0, new_review)
    save_json(REVIEWS_FILE, REVIEWS)
    return new_review

@app.delete("/api/reviews/{review_id}")
def delete_review(review_id: str):
    global REVIEWS
    original_len = len(REVIEWS)
    REVIEWS = [r for r in REVIEWS if r.get("id") != review_id]
    if len(REVIEWS) == original_len:
        raise HTTPException(status_code=404, detail="Review not found")
    save_json(REVIEWS_FILE, REVIEWS)
    return {"status": "success", "message": "Review deleted successfully"}

@app.post("/api/reviews/{review_id}/report")
def report_review(review_id: str):
    for r in REVIEWS:
        if r.get("id") == review_id:
            r["isReported"] = True
            save_json(REVIEWS_FILE, REVIEWS)
            return {"status": "success", "message": "Review reported for moderation"}
    raise HTTPException(status_code=404, detail="Review not found")

# Saved products
@app.get("/api/saved")
def get_saved_products(user_id: Optional[str] = "demo-user"):
    user_saved = [s for s in SAVED_ITEMS if s.get("userId") == user_id]
    # Populate with product details
    saved_products = []
    for s in user_saved:
        for p in PRODUCTS:
            if p["id"] == s.get("productId"):
                saved_products.append({
                    "savedId": s.get("id"),
                    "savedAt": s.get("savedAt"),
                    "product": p
                })
                break
    return {"saved": saved_products}

@app.post("/api/saved")
def save_product(req: SaveProductRequest):
    # Check if already saved
    for s in SAVED_ITEMS:
        if s.get("productId") == req.productId and s.get("userId") == req.userId:
            return {"status": "already_saved", "savedId": s.get("id")}
    
    new_entry = {
        "id": f"save-{uuid.uuid4().hex[:8]}",
        "productId": req.productId,
        "userId": req.userId,
        "savedAt": datetime.now(timezone.utc).isoformat()
    }
    SAVED_ITEMS.insert(0, new_entry)
    save_json(SAVED_FILE, SAVED_ITEMS)
    return {"status": "success", "savedId": new_entry["id"]}

@app.delete("/api/saved/{product_id}")
def remove_saved_product(product_id: str, user_id: Optional[str] = "demo-user"):
    global SAVED_ITEMS
    original_len = len(SAVED_ITEMS)
    SAVED_ITEMS = [s for s in SAVED_ITEMS if not (s.get("productId") == product_id and s.get("userId") == user_id)]
    save_json(SAVED_FILE, SAVED_ITEMS)
    return {"status": "success", "removed": original_len != len(SAVED_ITEMS)}

# Saved comparisons
@app.get("/api/comparisons")
def get_comparisons(user_id: Optional[str] = "demo-user"):
    user_comps = [c for c in SAVED_COMPARISONS if c.get("userId") == user_id]
    # Hydrate products
    hydrated = []
    for c in user_comps:
        comp_prods = [p for p in PRODUCTS if p["id"] in c.get("productIds", [])]
        hydrated.append({
            **c,
            "products": comp_prods
        })
    return {"comparisons": hydrated}

@app.post("/api/comparisons")
def save_comparison(req: SaveComparisonRequest):
    new_comp = {
        "id": f"comp-{uuid.uuid4().hex[:8]}",
        "title": req.title,
        "productIds": req.productIds,
        "userId": req.userId,
        "notes": req.notes,
        "createdAt": datetime.now(timezone.utc).isoformat()
    }
    SAVED_COMPARISONS.insert(0, new_comp)
    save_json(COMPARISONS_FILE, SAVED_COMPARISONS)
    return new_comp

@app.delete("/api/comparisons/{comparison_id}")
def delete_comparison(comparison_id: str):
    global SAVED_COMPARISONS
    SAVED_COMPARISONS = [c for c in SAVED_COMPARISONS if c.get("id") != comparison_id]
    save_json(COMPARISONS_FILE, SAVED_COMPARISONS)
    return {"status": "success", "message": "Comparison deleted"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)

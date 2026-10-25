"""
WORTHLY - Canonical Category Registry & Normalization Module
Single Source of Truth for product taxonomy throughout WORTHLY.
Ensures each canonical category appears exactly once in all UI selectors,
filters, navigation, and API endpoints, eliminating duplicate category entries.
"""

from typing import List, Dict, Any, Optional
import re

# Comprehensive Alias-to-Canonical ID Mapping
CATEGORY_ALIASES: Dict[str, str] = {
    # Smartphones
    "smartphone": "smartphones",
    "smartphones": "smartphones",
    "mobile": "smartphones",
    "mobiles": "smartphones",
    "mobile phone": "smartphones",
    "mobile phones": "smartphones",
    "cell phone": "smartphones",
    "cell phones": "smartphones",
    "cellphone": "smartphones",
    "cellphones": "smartphones",
    "phone": "smartphones",
    "phones": "smartphones",

    # Laptops
    "laptop": "laptops",
    "laptops": "laptops",
    "notebook": "laptops",
    "notebooks": "laptops",
    "ultrabook": "laptops",
    "ultrabooks": "laptops",
    "laptop computer": "laptops",
    "laptop computers": "laptops",
    "laptops & computers": "laptops",
    "pc": "laptops",

    # Televisions
    "tv": "televisions",
    "tvs": "televisions",
    "television": "televisions",
    "televisions": "televisions",
    "smart tv": "televisions",
    "smart tvs": "televisions",
    "televisions & smart tvs": "televisions",
    "oled tv": "televisions",
    "4k tv": "televisions",

    # Refrigerators
    "refrigerator": "refrigerators",
    "refrigerators": "refrigerators",
    "fridge": "refrigerators",
    "fridges": "refrigerators",
    "freezer": "refrigerators",
    "freezers": "refrigerators",
    "refrigerators & freezers": "refrigerators",

    # Washing Machines
    "washing machine": "washing_machines",
    "washing machines": "washing_machines",
    "washing_machine": "washing_machines",
    "washing_machines": "washing_machines",
    "washer": "washing_machines",
    "washers": "washing_machines",
    "washer dryer": "washing_machines",
    "laundry": "washing_machines",

    # Air Conditioners
    "air conditioner": "air_conditioners",
    "air conditioners": "air_conditioners",
    "air_conditioner": "air_conditioners",
    "air_conditioners": "air_conditioners",
    "ac": "air_conditioners",
    "acs": "air_conditioners",
    "split ac": "air_conditioners",
    "inverter ac": "air_conditioners",

    # Tablets & Monitors
    "tablet": "tablets_monitors",
    "tablets": "tablets_monitors",
    "monitor": "tablets_monitors",
    "monitors": "tablets_monitors",
    "display": "tablets_monitors",
    "displays": "tablets_monitors",
    "tablets & displays": "tablets_monitors",
    "tablets and monitors": "tablets_monitors",
    "tablets_monitors": "tablets_monitors",
    "ipad": "tablets_monitors",

    # Audio & Wearables / Consumer Electronics
    "consumer_electronics": "consumer_electronics",
    "consumer electronics": "consumer_electronics",
    "audio & wearables": "consumer_electronics",
    "audio": "consumer_electronics",
    "headphones": "consumer_electronics",
    "earbuds": "consumer_electronics",
    "earphones": "consumer_electronics",
    "headset": "consumer_electronics",
    "soundbar": "consumer_electronics",
    "smartwatch": "consumer_electronics",
    "smartwatches": "consumer_electronics",
    "wearable": "consumer_electronics",
    "wearables": "consumer_electronics",

    # Fitness Equipment
    "fitness": "fitness_equipment",
    "fitness & sports": "fitness_equipment",
    "fitness_equipment": "fitness_equipment",
    "fitness equipment": "fitness_equipment",
    "sports": "fitness_equipment",
    "gym": "fitness_equipment",
    "gym equipment": "fitness_equipment",
    "treadmill": "fitness_equipment",
    "exercise bike": "fitness_equipment",

    # Kitchen Chimneys
    "kitchen_chimneys": "kitchen_chimneys",
    "kitchen chimney": "kitchen_chimneys",
    "kitchen chimneys": "kitchen_chimneys",
    "chimney": "kitchen_chimneys",
    "chimneys": "kitchen_chimneys",
    "range hood": "kitchen_chimneys",

    # Books & Study Materials
    "book": "books",
    "books": "books",
    "books & study materials": "books",
    "study materials": "books",
    "education": "books",
    "education & student essentials": "books",
    "student essentials": "books",
    "textbook": "books",
    "textbooks": "books",

    # Magazines & Periodicals
    "magazine": "magazines",
    "magazines": "magazines",
    "magazines & periodicals": "magazines",
    "periodical": "magazines",
    "periodicals": "magazines",

    # Protein & Nutrition
    "nutrition": "nutrition",
    "protein & nutrition": "nutrition",
    "protein": "nutrition",
    "supplements": "nutrition",
    "whey protein": "nutrition",

    # Home & Kitchen
    "home_kitchen": "home_kitchen",
    "home & kitchen": "home_kitchen",
    "home kitchen": "home_kitchen",
    "home appliances": "home_kitchen",
    "kitchen appliances": "home_kitchen",

    # Furniture
    "furniture": "furniture",
    "furniture & home office": "furniture",
    "home office": "furniture",
    "ergonomic chair": "furniture",

    # Footwear
    "footwear": "footwear",
    "fashion & footwear": "footwear",
    "shoes": "footwear",
    "running shoes": "footwear",

    # General Electronics (Legacy compatibility)
    "electronics": "electronics",
    "electronics & gadgets": "electronics"
}

# Canonical Taxonomy Definition: exactly 16 distinct product categories
CANONICAL_CATEGORIES: List[Dict[str, Any]] = [
    {
        "id": "smartphones",
        "name": "Smartphones",
        "description": "Flagship, premium, and value 5G mobile smartphones",
        "icon": "Smartphone",
        "parent_category": "electronics",
        "subcategories": ["flagship", "mid_range", "budget", "foldable", "gaming"],
        "budgetPresets": [25000, 45000, 75000, 130000],
        "defaultMax": 80000,
        "budgetRange": "₹10,000 - ₹1,60,000",
        "primary_specs": ["processor", "ram", "storage", "camera", "battery", "display"]
    },
    {
        "id": "laptops",
        "name": "Laptops & Computers",
        "description": "Productivity, ultrabook, creator, and high-performance gaming laptops",
        "icon": "Laptop",
        "parent_category": "electronics",
        "subcategories": ["ultrabook", "gaming", "business", "creator", "budget"],
        "budgetPresets": [40000, 65000, 100000, 180000],
        "defaultMax": 85000,
        "budgetRange": "₹35,000 - ₹2,50,000",
        "primary_specs": ["processor", "ram", "storage", "gpu", "display", "battery", "weight"]
    },
    {
        "id": "televisions",
        "name": "Televisions & Smart TVs",
        "description": "4K OLED, QLED, Mini-LED, and Smart 4K UHD TVs",
        "icon": "Tv",
        "parent_category": "appliances",
        "subcategories": ["oled", "qled", "mini_led", "led_4k"],
        "budgetPresets": [30000, 55000, 100000, 180000],
        "defaultMax": 90000,
        "budgetRange": "₹25,000 - ₹2,00,000",
        "primary_specs": ["display_type", "resolution", "refresh_rate", "audio_wattage", "smart_os"]
    },
    {
        "id": "refrigerators",
        "name": "Refrigerators & Freezers",
        "description": "Frost-free double door, French door, and side-by-side smart refrigerators",
        "icon": "Box",
        "parent_category": "appliances",
        "subcategories": ["double_door", "french_door", "side_by_side", "single_door"],
        "budgetPresets": [25000, 45000, 75000, 130000],
        "defaultMax": 65000,
        "budgetRange": "₹20,000 - ₹1,60,000",
        "primary_specs": ["capacity_litres", "energy_rating", "compressor_type", "defrost_type"]
    },
    {
        "id": "washing_machines",
        "name": "Washing Machines",
        "description": "Front load, top load, inverter, and smart washer-dryers",
        "icon": "Disc",
        "parent_category": "appliances",
        "subcategories": ["front_load", "top_load", "washer_dryer"],
        "budgetPresets": [18000, 30000, 45000, 70000],
        "defaultMax": 40000,
        "budgetRange": "₹15,000 - ₹75,000",
        "primary_specs": ["capacity_kg", "spin_speed_rpm", "motor_type", "energy_rating"]
    },
    {
        "id": "air_conditioners",
        "name": "Air Conditioners",
        "description": "Smart inverter split ACs, dual inverter, and high-ambient cooling",
        "icon": "Wind",
        "parent_category": "appliances",
        "subcategories": ["split_inverter", "window_ac", "hot_and_cold"],
        "budgetPresets": [30000, 42000, 55000, 75000],
        "defaultMax": 48000,
        "budgetRange": "₹28,000 - ₹80,000",
        "primary_specs": ["tonnage", "energy_rating", "iseer_value", "cooling_capacity_watts", "condenser_coil"]
    },
    {
        "id": "tablets_monitors",
        "name": "Tablets & Displays",
        "description": "Productivity tablets, iPads, graphic tablets, and 4K professional monitors",
        "icon": "Tablet",
        "parent_category": "electronics",
        "subcategories": ["tablets", "monitors"],
        "budgetPresets": [20000, 40000, 70000, 110000],
        "defaultMax": 65000,
        "budgetRange": "₹18,000 - ₹1,30,000",
        "primary_specs": ["screen_size", "resolution", "refresh_rate", "stylus_support", "processor", "battery"]
    },
    {
        "id": "consumer_electronics",
        "name": "Audio & Wearables",
        "description": "Noise-cancelling headphones, wireless earbuds, smartwatches, and fitness trackers",
        "icon": "Headphones",
        "parent_category": "electronics",
        "subcategories": ["headphones", "earbuds", "smartwatches", "speakers"],
        "budgetPresets": [5000, 15000, 25000, 45000],
        "defaultMax": 25000,
        "budgetRange": "₹3,000 - ₹60,000",
        "primary_specs": ["anc", "battery_runtime_hours", "driver_size_mm", "water_resistance", "connectivity"]
    },
    {
        "id": "fitness_equipment",
        "name": "Fitness Equipment",
        "description": "Home gym gear, treadmills, smart exercise bikes, and recovery equipment",
        "icon": "Dumbbell",
        "parent_category": "lifestyle",
        "subcategories": ["cardio", "strength", "recovery", "accessories"],
        "budgetPresets": [15000, 30000, 50000, 90000],
        "defaultMax": 45000,
        "budgetRange": "₹5,000 - ₹1,00,000",
        "primary_specs": ["max_user_weight_kg", "motor_power_hp", "resistance_levels", "display_console"]
    },
    {
        "id": "kitchen_chimneys",
        "name": "Kitchen Chimneys",
        "description": "Filterless, auto-clean, curved glass, and high-suction kitchen chimneys",
        "icon": "Flame",
        "parent_category": "appliances",
        "subcategories": ["filterless_autoclean", "baffle_filter", "island_chimney"],
        "budgetPresets": [10000, 16000, 24000, 38000],
        "defaultMax": 20000,
        "budgetRange": "₹8,000 - ₹45,000",
        "primary_specs": ["suction_capacity_m3hr", "filter_type", "clean_technology", "noise_level_db"]
    },
    {
        "id": "books",
        "name": "Books & Study Materials",
        "description": "Academic textbooks, reference manuals, competitive exam prep, and professional literature",
        "icon": "BookOpen",
        "parent_category": "education",
        "subcategories": ["engineering_tech", "business_management", "competitive_exams", "science_math"],
        "budgetPresets": [500, 1500, 3000, 6000],
        "defaultMax": 2000,
        "budgetRange": "₹300 - ₹8,000",
        "primary_specs": ["format", "edition", "page_count", "publisher", "author"]
    },
    {
        "id": "magazines",
        "name": "Magazines & Periodicals",
        "description": "Technology reviews, business intelligence, scientific journals, and global periodicals",
        "icon": "Newspaper",
        "parent_category": "education",
        "subcategories": ["technology_ai", "business_finance", "science_nature"],
        "budgetPresets": [1000, 2500, 4500, 8000],
        "defaultMax": 3500,
        "budgetRange": "₹800 - ₹12,000",
        "primary_specs": ["frequency", "subscription_tier", "format", "publisher"]
    },
    {
        "id": "nutrition",
        "name": "Protein & Nutrition",
        "description": "Lab-certified whey isolate, plant protein, creatine, and sports performance nutrition",
        "icon": "ShieldCheck",
        "parent_category": "health",
        "subcategories": ["whey_isolate", "whey_concentrate", "plant_protein", "creatine"],
        "budgetPresets": [2000, 3800, 6000, 9500],
        "defaultMax": 4500,
        "budgetRange": "₹1,500 - ₹12,000",
        "primary_specs": ["protein_per_serving_g", "servings_per_tub", "net_weight_kg", "certifications"]
    },
    {
        "id": "home_kitchen",
        "name": "Home & Kitchen Appliances",
        "description": "Smart air fryers, multi-cookers, espresso machines, and high-performance blenders",
        "icon": "Home",
        "parent_category": "appliances",
        "subcategories": ["cooking", "beverage", "cleaning"],
        "budgetPresets": [5000, 12000, 25000, 45000],
        "defaultMax": 18000,
        "budgetRange": "₹3,000 - ₹60,000",
        "primary_specs": ["wattage", "capacity_litres", "preset_modes", "warranty_years"]
    },
    {
        "id": "furniture",
        "name": "Furniture & Home Office",
        "description": "Ergonomic executive chairs, dual-motor standing desks, and lumbar workstations",
        "icon": "Armchair",
        "parent_category": "furniture",
        "subcategories": ["ergonomic_chairs", "standing_desks"],
        "budgetPresets": [12000, 25000, 50000, 90000],
        "defaultMax": 35000,
        "budgetRange": "₹8,000 - ₹1,20,000",
        "primary_specs": ["lumbar_support_type", "armrest_adjustability", "weight_capacity_kg", "warranty_years"]
    },
    {
        "id": "footwear",
        "name": "Fashion & Footwear",
        "description": "Marathon distance running shoes, carbon-plated racers, and cross-training shoes",
        "icon": "Footprints",
        "parent_category": "lifestyle",
        "subcategories": ["running_shoes", "training_shoes"],
        "budgetPresets": [4000, 8000, 14000, 24000],
        "defaultMax": 12000,
        "budgetRange": "₹2,500 - ₹30,000",
        "primary_specs": ["shoe_weight_g", "cushioning_foam", "heel_toe_drop_mm", "closure_type"]
    }
]

CANONICAL_CATEGORY_IDS = set(c["id"] for c in CANONICAL_CATEGORIES)
CANONICAL_BY_ID = {c["id"]: c for c in CANONICAL_CATEGORIES}


def normalize_category_id(raw_value: Optional[str]) -> str:
    """
    Normalizes any category identifier, alias, or display name to its canonical category ID.
    Always returns a single valid canonical ID.
    """
    if not raw_value:
        return "smartphones"

    cleaned = raw_value.strip().lower()
    # Normalize punctuation, hyphens, and whitespace
    cleaned_key = re.sub(r'[\s\-_]+', ' ', cleaned).strip()

    # Exact alias match
    if cleaned in CATEGORY_ALIASES:
        return CATEGORY_ALIASES[cleaned]
    if cleaned_key in CATEGORY_ALIASES:
        return CATEGORY_ALIASES[cleaned_key]

    # Substring search for common patterns
    if any(k in cleaned for k in ["phone", "mobile", "samsung s", "iphone"]):
        return "smartphones"
    if any(k in cleaned for k in ["laptop", "notebook", "macbook", "xps"]):
        return "laptops"
    if any(k in cleaned for k in ["tv", "television", "oled", "qled"]):
        return "televisions"
    if any(k in cleaned for k in ["fridge", "refrigerator"]):
        return "refrigerators"
    if any(k in cleaned for k in ["washer", "washing machine", "laundry"]):
        return "washing_machines"
    if any(k in cleaned for k in ["ac", "air condition"]):
        return "air_conditioners"
    if any(k in cleaned for k in ["tablet", "ipad", "monitor", "display"]):
        return "tablets_monitors"
    if any(k in cleaned for k in ["headphone", "earbud", "smartwatch", "audio", "wearable"]):
        return "consumer_electronics"
    if any(k in cleaned for k in ["fitness", "gym", "treadmill", "workout"]):
        return "fitness_equipment"
    if any(k in cleaned for k in ["chimney"]):
        return "kitchen_chimneys"
    if any(k in cleaned for k in ["book", "study", "textbook"]):
        return "books"
    if any(k in cleaned for k in ["magazine", "periodical"]):
        return "magazines"
    if any(k in cleaned for k in ["protein", "creatine", "nutrition"]):
        return "nutrition"

    # Direct canonical check
    if cleaned in CANONICAL_CATEGORY_IDS:
        return cleaned

    # Fallback to electronics for unknown hardware, or smartphones default
    return "smartphones"


def get_all_canonical_categories() -> List[Dict[str, Any]]:
    """
    Returns the deduplicated, authoritative list of canonical categories.
    Each category appears exactly once.
    """
    return list(CANONICAL_CATEGORIES)


def get_canonical_category(cat_id: str) -> Optional[Dict[str, Any]]:
    """Returns metadata for a specific canonical category."""
    norm_id = normalize_category_id(cat_id)
    return CANONICAL_BY_ID.get(norm_id)


def is_valid_canonical_category(cat_id: str) -> bool:
    """Checks if a category ID is a valid canonical category."""
    return cat_id in CANONICAL_CATEGORY_IDS

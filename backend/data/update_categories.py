import json
import os

DATA_DIR = r"c:\Users\shaik\Desktop\Michack\backend\data"

# 1. Update categories.json
existing_cats = []
cats_file = os.path.join(DATA_DIR, "categories.json")
if os.path.exists(cats_file):
    with open(cats_file, "r", encoding="utf-8") as f:
        existing_cats = json.load(f).get("categories", [])

CATEGORIES_8 = [
    {
        "id": "smartphones",
        "name": "Smartphones",
        "description": "Flagship, premium, and value 5G mobile smartphones",
        "icon": "Smartphone",
        "budgetPresets": [25000, 45000, 75000, 130000],
        "defaultMax": 80000,
        "budgetRange": "₹31,999 - ₹1,29,999",
        "usages": [
            {"id": "daily", "label": "Daily Multitasking"},
            {"id": "photography", "label": "Pro Photography & 4K Video"},
            {"id": "gaming", "label": "High-FPS Mobile Gaming"},
            {"id": "battery_life", "label": "All-Day Heavy Battery Endurance"}
        ],
        "priorities": [
            {"id": "camera", "label": "Pro Camera & Zoom Quality"},
            {"id": "performance", "label": "Flagship Processor & Gaming"},
            {"id": "battery", "label": "Long Battery & Fast Charging"},
            {"id": "display", "label": "Bright 120Hz OLED Display"},
            {"id": "value", "label": "Value for Money"}
        ],
        "optionalSpecs": [
            {"id": "preferred_brand", "label": "Brand", "type": "select", "options": ["Any", "Apple", "Samsung", "OnePlus", "Xiaomi", "Motorola"]},
            {"id": "min_ram", "label": "Minimum RAM", "type": "select", "options": ["Any", "8GB", "12GB", "16GB"]}
        ]
    },
    {
        "id": "laptops",
        "name": "Laptops & Computers",
        "description": "Ultrabooks, workstation, business, and creator laptops",
        "icon": "Laptop",
        "budgetPresets": [50000, 85000, 130000, 180000],
        "defaultMax": 150000,
        "budgetRange": "₹54,990 - ₹1,99,900",
        "usages": [
            {"id": "programming", "label": "Software Engineering & Dev"},
            {"id": "ai_ml", "label": "AI / ML & Local Model Inference"},
            {"id": "college", "label": "College & Daily Assignments"},
            {"id": "gaming", "label": "AAA Gaming & 3D Rendering"}
        ],
        "priorities": [
            {"id": "performance", "label": "Raw CPU / GPU Compute"},
            {"id": "battery", "label": "All-Day Battery Life"},
            {"id": "portability", "label": "Thin, Lightweight Portability"},
            {"id": "ram", "label": "High RAM / Heavy Multitasking"},
            {"id": "build_quality", "label": "Premium Display & Build"},
            {"id": "value", "label": "Value for Money"}
        ],
        "optionalSpecs": [
            {"id": "preferred_brand", "label": "Brand", "type": "select", "options": ["Any", "Dell", "Apple", "Lenovo", "ASUS", "HP", "Acer"]},
            {"id": "min_ram", "label": "Minimum RAM", "type": "select", "options": ["Any", "16GB", "18GB", "32GB"]}
        ]
    },
    {
        "id": "books",
        "name": "Books & Study Materials",
        "description": "Standard computer science textbooks, programming guides, and competitive exam preparation",
        "icon": "BookOpen",
        "budgetPresets": [800, 1500, 2500, 4500],
        "defaultMax": 3000,
        "budgetRange": "₹890 - ₹4,450",
        "usages": [
            {"id": "self_study", "label": "Self-Paced Hands-On Learning"},
            {"id": "college_curriculum", "label": "University Semester Coursework"},
            {"id": "exam_prep", "label": "GATE & Competitive Exam Prep"}
        ],
        "priorities": [
            {"id": "depth", "label": "Comprehensive Theory & Depth"},
            {"id": "practical", "label": "Practical Exercises & Code Examples"},
            {"id": "reputation", "label": "Standard Author & Academic Rigour"},
            {"id": "value", "label": "Value for Price"}
        ],
        "optionalSpecs": []
    },
    {
        "id": "magazines",
        "name": "Magazines & Periodicals",
        "description": "Annual subscriptions to premier tech, science, business, and policy periodicals",
        "icon": "Newspaper",
        "budgetPresets": [2500, 3500, 4500, 6000],
        "defaultMax": 4500,
        "budgetRange": "₹2,400 - ₹5,999",
        "usages": [
            {"id": "tech_insights", "label": "Deep Technology & AI Trends"},
            {"id": "business_strategy", "label": "Global Markets & Executive Strategy"},
            {"id": "scientific_research", "label": "Scientific Discoveries & Nature"}
        ],
        "priorities": [
            {"id": "depth", "label": "In-Depth Investigative Journalism"},
            {"id": "frequency", "label": "Issue Frequency & Timeliness"},
            {"id": "prestige", "label": "Global Editorial Reputation"},
            {"id": "value", "label": "Annual Cost per Issue"}
        ],
        "optionalSpecs": []
    },
    {
        "id": "consumer_electronics",
        "name": "Consumer Electronics",
        "description": "ANC earbuds, premium over-ear headphones, ergonomic keyboards, mice, and gaming monitors",
        "icon": "Headphones",
        "budgetPresets": [8000, 15000, 25000, 35000],
        "defaultMax": 25000,
        "budgetRange": "₹9,495 - ₹35,900",
        "usages": [
            {"id": "remote_office", "label": "Remote Office & Productivity"},
            {"id": "gaming_highfps", "label": "High-FPS Gaming & Visuals"},
            {"id": "audiophile", "label": "Critical Listening & Travel ANC"}
        ],
        "priorities": [
            {"id": "audio_quality", "label": "Acoustic Fidelity & Noise Isolation"},
            {"id": "ergonomics", "label": "Ergonomics & Typing / Mouse Feel"},
            {"id": "battery_life", "label": "Multi-Day Wireless Endurance"},
            {"id": "value", "label": "Value for Money"}
        ],
        "optionalSpecs": []
    },
    {
        "id": "fitness_equipment",
        "name": "Fitness Equipment",
        "description": "Adjustable dumbbells, commercial-grade mats, stackable bands, and multi-position benches",
        "icon": "Dumbbell",
        "budgetPresets": [1500, 5000, 12000, 25000],
        "defaultMax": 15000,
        "budgetRange": "₹799 - ₹38,500",
        "usages": [
            {"id": "strength_hypertrophy", "label": "Strength & Muscle Building"},
            {"id": "yoga_mobility", "label": "Yoga, Stretching & Mobility"},
            {"id": "compact_homegym", "label": "Compact Home Gym Setup"}
        ],
        "priorities": [
            {"id": "durability", "label": "Steel / Material Durability"},
            {"id": "adjustability", "label": "Weight & Angle Adjustability"},
            {"id": "safety_grip", "label": "Non-Slip Grip & Joint Cushioning"},
            {"id": "value", "label": "Value for Money"}
        ],
        "optionalSpecs": []
    },
    {
        "id": "kitchen_chimneys",
        "name": "Kitchen Chimneys",
        "description": "Wall-mounted, autoclean, and filterless curved glass kitchen chimneys",
        "icon": "Flame",
        "budgetPresets": [8000, 12000, 16000, 20000],
        "defaultMax": 15000,
        "budgetRange": "₹6,290 - ₹17,490",
        "usages": [
            {"id": "heavy_frying", "label": "Heavy Indian Frying & Grilling"},
            {"id": "medium_cooking", "label": "Daily 2-3 Burner Cooking"},
            {"id": "quiet_operation", "label": "Low Acoustic Noise Operation"}
        ],
        "priorities": [
            {"id": "suction", "label": "High Suction Capacity (m³/hr)"},
            {"id": "cleaning", "label": "Filterless & Heat Auto-Clean"},
            {"id": "controls", "label": "Touch & Motion Gesture Sensor"},
            {"id": "value", "label": "Value for Money"}
        ],
        "optionalSpecs": []
    },
    {
        "id": "nutrition",
        "name": "Protein & Nutrition",
        "description": "Whey protein isolate, concentrate, and 100% plant-based protein powders",
        "icon": "CupSoda",
        "budgetPresets": [2000, 3500, 5000, 7500],
        "defaultMax": 4500,
        "budgetRange": "₹1,650 - ₹7,299",
        "usages": [
            {"id": "muscle_recovery", "label": "Post-Workout Muscle Recovery"},
            {"id": "daily_intake", "label": "Daily Protein Gap Supplementation"},
            {"id": "vegan_clean", "label": "100% Vegan Clean Plant Nutrition"}
        ],
        "priorities": [
            {"id": "protein_yield", "label": "High Protein per Serving (24g-30g)"},
            {"id": "absorption", "label": "High Digestibility & Low Bloat"},
            {"id": "certification", "label": "Third-Party Purity Testing (Labdoor/Informed)"},
            {"id": "value", "label": "Cost per Gram of Pure Protein"}
        ],
        "optionalSpecs": []
    }
]

# Merge: 8 categories first, followed by any legacy ones not in the 8
merged_cats = list(CATEGORIES_8)
existing_ids = {c["id"] for c in CATEGORIES_8}
for c in existing_cats:
    if c["id"] not in existing_ids:
        merged_cats.append(c)

with open(cats_file, "w", encoding="utf-8") as f:
    json.dump({"categories": merged_cats}, f, indent=2)

print(f"Updated categories.json with {len(merged_cats)} categories.")

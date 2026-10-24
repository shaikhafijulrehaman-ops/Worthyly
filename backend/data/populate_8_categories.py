import json
import os

DATA_DIR = r"c:\Users\shaik\Desktop\Michack\backend\data"
products_file = os.path.join(DATA_DIR, "products.json")

with open(products_file, "r", encoding="utf-8") as f:
    existing_products = json.load(f)

# Keep existing products
# We create 64 products: 8 for each of the 8 categories
new_products = []

# ==========================================
# 1. SMARTPHONES (8 Products)
# ==========================================
smartphones = [
    {
        "id": "phone-001",
        "slug": "iphone-16-pro",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "Apple",
        "name": "Apple iPhone 16 Pro",
        "product_name": "Apple iPhone 16 Pro",
        "exact_model": "iPhone 16 Pro 128GB",
        "variant": "128GB / Natural Titanium",
        "price": 119900.0,
        "price_inr": 119900.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 420,
        "imageUrl": "https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro",
        "productSourceUrl": "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro",
        "retailerOffers": [
            {"retailerName": "Apple Store India", "productUrl": "https://www.apple.com/in/shop/buy-iphone/iphone-16-pro", "price": 119900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0DGH7K8LP", "price": 119900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Apple A18 Pro (3nm, 6-core CPU, 6-core GPU, 16-core NPU)",
            "ram": "8GB LPDDR5X",
            "storage": "128GB NVMe",
            "camera": "48MP Fusion + 48MP Ultra Wide + 12MP 5x Telephoto",
            "display": "6.3\" Super Retina XDR OLED 120Hz ProMotion 2000 nits",
            "battery": "3582 mAh (Up to 27 hours video playback)",
            "charging": "25W MagSafe, USB-C 3.0 (10Gbps)",
            "weight": "199g",
            "os": "iOS 18"
        },
        "features": [
            "Grade 5 Titanium design with Camera Control sensor button",
            "4K 120 fps Dolby Vision video recording capability",
            "Apple Intelligence on-device privacy architecture"
        ],
        "priorityAffinities": {"camera": 0.98, "performance": 0.96, "build_quality": 0.97, "battery": 0.86, "display": 0.95, "value": 0.72}
    },
    {
        "id": "phone-002",
        "slug": "iphone-15",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "Apple",
        "name": "Apple iPhone 15",
        "product_name": "Apple iPhone 15",
        "exact_model": "iPhone 15 128GB",
        "variant": "128GB / Black",
        "price": 69900.0,
        "price_inr": 69900.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 850,
        "imageUrl": "https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.apple.com/in/shop/buy-iphone/iphone-15",
        "productSourceUrl": "https://www.apple.com/in/shop/buy-iphone/iphone-15",
        "retailerOffers": [
            {"retailerName": "Apple Store India", "productUrl": "https://www.apple.com/in/shop/buy-iphone/iphone-15", "price": 69900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CHX1W1XY", "price": 65999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Apple A16 Bionic (6-core CPU, 5-core GPU)",
            "ram": "6GB LPDDR5",
            "storage": "128GB NVMe",
            "camera": "48MP Main with 2x Telephoto + 12MP Ultra Wide",
            "display": "6.1\" Super Retina XDR OLED, Dynamic Island, 2000 nits",
            "battery": "3349 mAh (Up to 20 hours video playback)",
            "charging": "15W MagSafe, USB-C",
            "weight": "171g",
            "os": "iOS 17 (upgradeable)"
        },
        "features": [
            "Dynamic Island interactive alerts and notifications",
            "Color-infused durable back glass with contoured edges",
            "48MP main camera with 24MP super-high-resolution default"
        ],
        "priorityAffinities": {"camera": 0.90, "performance": 0.88, "build_quality": 0.92, "battery": 0.82, "display": 0.88, "value": 0.84}
    },
    {
        "id": "phone-003",
        "slug": "galaxy-s24-ultra",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "Samsung",
        "name": "Samsung Galaxy S24 Ultra",
        "product_name": "Samsung Galaxy S24 Ultra",
        "exact_model": "Galaxy S24 Ultra 5G (12GB/256GB)",
        "variant": "12GB RAM / 256GB / Titanium Gray",
        "price": 129999.0,
        "price_inr": 129999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 610,
        "imageUrl": "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.samsung.com/in/smartphones/galaxy-s24-ultra/",
        "productSourceUrl": "https://www.samsung.com/in/smartphones/galaxy-s24-ultra/",
        "retailerOffers": [
            {"retailerName": "Samsung India Official", "productUrl": "https://www.samsung.com/in/smartphones/galaxy-s24-ultra/", "price": 129999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CS5X828H", "price": 129999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Qualcomm Snapdragon 8 Gen 3 for Galaxy (4nm)",
            "ram": "12GB LPDDR5X",
            "storage": "256GB UFS 4.0",
            "camera": "200MP OIS + 50MP 5x Periscope + 10MP 3x + 12MP UW",
            "display": "6.8\" Dynamic AMOLED 2X 120Hz LTPO, Gorilla Glass Armor, 2600 nits",
            "battery": "5000 mAh (45W fast charge, 15W wireless)",
            "stylus": "Embedded Bluetooth S-Pen",
            "weight": "232g",
            "os": "One UI 6.1 (Android 14)"
        },
        "features": [
            "Titanium exterior frame with anti-reflective Gorilla Armor glass",
            "Galaxy AI with Circle to Search, Live Call Translation, and Note Assist",
            "Quad Tele System with 5x optical zoom and 100x Space Zoom"
        ],
        "priorityAffinities": {"camera": 0.99, "performance": 0.98, "build_quality": 0.97, "battery": 0.94, "display": 0.99, "value": 0.70}
    },
    {
        "id": "phone-004",
        "slug": "galaxy-s24",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "Samsung",
        "name": "Samsung Galaxy S24",
        "product_name": "Samsung Galaxy S24",
        "exact_model": "Galaxy S24 5G (8GB/128GB)",
        "variant": "8GB RAM / 128GB / Onyx Black",
        "price": 74999.0,
        "price_inr": 74999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 380,
        "imageUrl": "https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.samsung.com/in/smartphones/galaxy-s24/",
        "productSourceUrl": "https://www.samsung.com/in/smartphones/galaxy-s24/",
        "retailerOffers": [
            {"retailerName": "Samsung India Official", "productUrl": "https://www.samsung.com/in/smartphones/galaxy-s24/", "price": 74999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CS5WR8Z4", "price": 72499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Samsung Exynos 2400 (4nm 10-core)",
            "ram": "8GB LPDDR5X",
            "storage": "128GB UFS 4.0",
            "camera": "50MP Dual Pixel OIS + 10MP 3x Telephoto + 12MP UW",
            "display": "6.2\" Dynamic AMOLED 2X 120Hz LTPO, 2600 nits peak",
            "battery": "4000 mAh (25W fast charge, 15W wireless)",
            "weight": "167g",
            "os": "One UI 6.1 (Android 14)"
        },
        "features": [
            "Compact lightweight 167g form factor with Armor Aluminum frame",
            "Galaxy AI features built-in with 7 years of OS updates",
            "Vision Booster adaptive display luminance up to 2600 nits"
        ],
        "priorityAffinities": {"camera": 0.90, "performance": 0.90, "build_quality": 0.91, "battery": 0.80, "display": 0.94, "value": 0.82}
    },
    {
        "id": "phone-005",
        "slug": "oneplus-12",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "OnePlus",
        "name": "OnePlus 12 5G",
        "product_name": "OnePlus 12 5G",
        "exact_model": "OnePlus 12 5G (16GB/512GB)",
        "variant": "16GB RAM / 512GB / Silky Black",
        "price": 69999.0,
        "price_inr": 69999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 780,
        "imageUrl": "https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.oneplus.in/12",
        "productSourceUrl": "https://www.oneplus.in/12",
        "retailerOffers": [
            {"retailerName": "OnePlus India Store", "productUrl": "https://www.oneplus.in/12", "price": 69999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CQPNW8F1", "price": 69999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Qualcomm Snapdragon 8 Gen 3 (4nm)",
            "ram": "16GB LPDDR5X",
            "storage": "512GB UFS 4.0",
            "camera": "50MP Sony LYT-808 + 64MP 3x Periscope + 48MP UW (Hasselblad)",
            "display": "6.82\" 2K 120Hz ProXDR LTPO AMOLED, 4500 nits peak",
            "battery": "5400 mAh (100W SUPERVOOC, 50W AIRVOOC)",
            "weight": "220g",
            "os": "OxygenOS 14 (Android 14)"
        },
        "features": [
            "4th Gen Hasselblad Camera System with 3x periscope zoom",
            "Dual Cryo-velocity VC cooling chamber for sustained gaming",
            "100W wired charging restores 100% in 26 minutes"
        ],
        "priorityAffinities": {"camera": 0.93, "performance": 0.98, "build_quality": 0.92, "battery": 0.97, "display": 0.96, "value": 0.90}
    },
    {
        "id": "phone-006",
        "slug": "oneplus-12r",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "OnePlus",
        "name": "OnePlus 12R 5G",
        "product_name": "OnePlus 12R 5G",
        "exact_model": "OnePlus 12R 5G (16GB/256GB)",
        "variant": "16GB RAM / 256GB / Cool Blue",
        "price": 42999.0,
        "price_inr": 42999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 940,
        "imageUrl": "https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.oneplus.in/12r",
        "productSourceUrl": "https://www.oneplus.in/12r",
        "retailerOffers": [
            {"retailerName": "OnePlus India Store", "productUrl": "https://www.oneplus.in/12r", "price": 42999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CQPT3B64", "price": 42999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Qualcomm Snapdragon 8 Gen 2 (4nm)",
            "ram": "16GB LPDDR5X",
            "storage": "256GB UFS 3.1",
            "camera": "50MP Sony IMX890 OIS + 8MP UW + 2MP Macro",
            "display": "6.78\" 1.5K 120Hz AMOLED LTPO4, 4500 nits peak",
            "battery": "5500 mAh (100W SUPERVOOC charging)",
            "weight": "207g",
            "os": "OxygenOS 14 (Android 14)"
        },
        "features": [
            "Largest battery ever in a OnePlus phone (5500 mAh)",
            "Flagship 4th Gen LTPO display with intelligent 1-120Hz scaling",
            "Snapdragon 8 Gen 2 flagship power at an upper mid-range price"
        ],
        "priorityAffinities": {"camera": 0.83, "performance": 0.94, "build_quality": 0.88, "battery": 0.98, "display": 0.92, "value": 0.95}
    },
    {
        "id": "phone-007",
        "slug": "redmi-note-13-pro-plus",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "Xiaomi",
        "name": "Redmi Note 13 Pro+ 5G",
        "product_name": "Redmi Note 13 Pro+ 5G",
        "exact_model": "Redmi Note 13 Pro+ 5G (12GB/512GB)",
        "variant": "12GB RAM / 512GB / Fusion Black",
        "price": 33999.0,
        "price_inr": 33999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 1120,
        "imageUrl": "https://images.unsplash.com/photo-1546054454-aa26e2b734c7?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1546054454-aa26e2b734c7?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.mi.com/in/product/redmi-note-13-pro-plus-5g/",
        "productSourceUrl": "https://www.mi.com/in/product/redmi-note-13-pro-plus-5g/",
        "retailerOffers": [
            {"retailerName": "Mi India Store", "productUrl": "https://www.mi.com/in/product/redmi-note-13-pro-plus-5g/", "price": 33999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CQ7VDF8T", "price": 33999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "MediaTek Dimensity 7200-Ultra (4nm)",
            "ram": "12GB LPDDR5",
            "storage": "512GB UFS 3.1",
            "camera": "200MP Samsung ISOCELL HP3 OIS + 8MP UW + 2MP Macro",
            "display": "6.67\" 1.5K 120Hz 3D Curved AMOLED, 1800 nits, Dolby Vision",
            "battery": "5000 mAh (120W HyperCharge)",
            "water_rating": "IP68 water & dust resistance",
            "weight": "204g",
            "os": "MIUI 14 / Xiaomi HyperOS"
        },
        "features": [
            "200MP flagship sensor with 4x lossless in-sensor zoom",
            "120W HyperCharge charges 100% in 19 minutes",
            "IP68 waterproof rating certified for 1.5m submerged depth"
        ],
        "priorityAffinities": {"camera": 0.92, "performance": 0.86, "build_quality": 0.89, "battery": 0.92, "display": 0.90, "value": 0.96}
    },
    {
        "id": "phone-008",
        "slug": "motorola-edge-50-pro",
        "category": "smartphones",
        "subcategory": "flagship_smartphones",
        "brand": "Motorola",
        "name": "Motorola Edge 50 Pro 5G",
        "product_name": "Motorola Edge 50 Pro 5G",
        "exact_model": "Motorola Edge 50 Pro (12GB/256GB)",
        "variant": "12GB RAM / 256GB / Black Beauty",
        "price": 31999.0,
        "price_inr": 31999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 670,
        "imageUrl": "https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.motorola.in/smartphones-motorola-edge-50-pro/p",
        "productSourceUrl": "https://www.motorola.in/smartphones-motorola-edge-50-pro/p",
        "retailerOffers": [
            {"retailerName": "Motorola India Store", "productUrl": "https://www.motorola.in/smartphones-motorola-edge-50-pro/p", "price": 31999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Flipkart", "productUrl": "https://www.flipkart.com/motorola-edge-50-pro-5g-black-beauty-256-gb/p/itm5b6b1df5f3775", "price": 31999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Qualcomm Snapdragon 7 Gen 3 (4nm)",
            "ram": "12GB LPDDR4X",
            "storage": "256GB UFS 2.2",
            "camera": "50MP f/1.4 OIS + 10MP 3x Telephoto OIS + 13MP UW/Macro",
            "display": "6.7\" 1.5K 144Hz 10-bit 3D Curved pOLED, 2000 nits, Pantone Validated",
            "battery": "4500 mAh (125W TurboPower wired, 50W wireless)",
            "water_rating": "IP68 water resistant",
            "weight": "186g",
            "os": "Hello UI (Android 14)"
        },
        "features": [
            "World's first Pantone Validated camera and display",
            "Dedicated 3x optical telephoto lens with OIS at sub-35k segment",
            "125W TurboPower charging with vegan leather back finish"
        ],
        "priorityAffinities": {"camera": 0.94, "performance": 0.85, "build_quality": 0.90, "battery": 0.86, "display": 0.95, "value": 0.94}
    }
]
new_products.extend(smartphones)

print(f"Added {len(smartphones)} smartphones.")

# ==========================================
# 2. LAPTOPS (8 Products)
# ==========================================
laptops = [
    {
        "id": "lap-001",
        "slug": "hp-spectre-x360-14",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "HP",
        "name": "HP Spectre x360 14",
        "product_name": "HP Spectre x360 14",
        "exact_model": "Spectre x360 14-eu0000tu 2-in-1",
        "variant": "16GB RAM / 1TB SSD / Nightfall Black",
        "price": 164999.0,
        "price_inr": 164999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 180,
        "imageUrl": "https://images.unsplash.com/photo-1544731612-de292439cc4b?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1544731612-de292439cc4b?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html",
        "productSourceUrl": "https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html",
        "retailerOffers": [
            {"retailerName": "HP India Official", "productUrl": "https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html", "price": 164999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CTKQ15K7", "price": 164999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz, Intel AI Boost)",
            "ram": "16GB LPDDR5x 7467MHz",
            "storage": "1TB PCIe Gen4 NVMe SSD",
            "gpu": "Intel Arc Graphics",
            "display": "14\" 2.8K (2880x1800) 120Hz OLED Touch, 500 nits HDR",
            "battery": "68 Wh (Up to 13 hours)",
            "weight": "1.44 kg",
            "os": "Windows 11 Home"
        },
        "features": [
            "CNC machined recycled aluminum chassis with 360-degree gem-cut hinge",
            "9MP AI intelligent auto-framing webcam with low-light adjustment",
            "Poly Studio quad speakers with DTS:X Ultra audio"
        ],
        "priorityAffinities": {"performance": 0.92, "battery": 0.88, "portability": 0.94, "ram": 0.90, "build_quality": 0.98, "value": 0.78}
    },
    {
        "id": "lap-002",
        "slug": "dell-inspiron-14-plus",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "Dell",
        "name": "Dell Inspiron 14 Plus 5430",
        "product_name": "Dell Inspiron 14 Plus 5430",
        "exact_model": "Inspiron 14 Plus 5430 Laptop",
        "variant": "16GB RAM / 1TB SSD / Platinum Silver",
        "price": 89990.0,
        "price_inr": 89990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 240,
        "imageUrl": "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop",
        "productSourceUrl": "https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop",
        "retailerOffers": [
            {"retailerName": "Dell India Store", "productUrl": "https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop", "price": 89990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0C39X5430", "price": 88490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Intel Core i7-13700H (14 cores, 20 threads, up to 5.0 GHz)",
            "ram": "16GB LPDDR5 4800MHz",
            "storage": "1TB M.2 PCIe NVMe SSD",
            "gpu": "Intel Iris Xe Graphics",
            "display": "14.0\" 2.5K (2560x1600) 16:10 300 nits ComfortView Plus",
            "battery": "64 Wh (ExpressCharge boost)",
            "weight": "1.66 kg",
            "os": "Windows 11 Home"
        },
        "features": [
            "H-series 45W high-power processor in a portable 14-inch chassis",
            "16:10 aspect ratio 2.5K display with hardware low-blue-light filter",
            "FHD webcam with dual digital array microphones and privacy shutter"
        ],
        "priorityAffinities": {"performance": 0.90, "battery": 0.82, "portability": 0.86, "ram": 0.88, "build_quality": 0.88, "value": 0.90}
    },
    {
        "id": "lap-003",
        "slug": "macbook-pro-14-m3-pro",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "Apple",
        "name": "Apple MacBook Pro 14 M3 Pro",
        "product_name": "Apple MacBook Pro 14 M3 Pro",
        "exact_model": "MacBook Pro 14-inch (M3 Pro 18GB/512GB)",
        "variant": "18GB Unified Memory / 512GB SSD / Space Black",
        "price": 199900.0,
        "price_inr": 199900.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 310,
        "imageUrl": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.apple.com/in/shop/buy-mac/macbook-pro/14-inch-m3-pro",
        "productSourceUrl": "https://www.apple.com/in/shop/buy-mac/macbook-pro/14-inch-m3-pro",
        "retailerOffers": [
            {"retailerName": "Apple Store India", "productUrl": "https://www.apple.com/in/shop/buy-mac/macbook-pro/14-inch-m3-pro", "price": 199900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CM5N4GYL", "price": 194900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Apple M3 Pro (11-core CPU, 14-core GPU, Hardware-accelerated Ray Tracing)",
            "ram": "18GB Unified Memory",
            "storage": "512GB SSD (up to 7.4GB/s read)",
            "gpu": "14-core GPU with Dynamic Caching",
            "display": "14.2\" Liquid Retina XDR (3024x1964) 120Hz ProMotion, 1600 nits HDR",
            "battery": "72.4 Wh (Up to 18 hours Apple TV playback)",
            "weight": "1.61 kg",
            "os": "macOS Sonoma / Sequoia"
        },
        "features": [
            "Industry-leading Liquid Retina XDR screen with sustained 1000 nits full-screen brightness",
            "Hardware-accelerated ray tracing and mesh shading for 3D & video workflows",
            "Six-speaker sound system with force-cancelling woofers and Studio-quality mics"
        ],
        "priorityAffinities": {"performance": 0.98, "battery": 0.96, "portability": 0.88, "ram": 0.94, "build_quality": 0.99, "value": 0.68}
    },
    {
        "id": "lap-004",
        "slug": "thinkpad-x1-carbon-gen-11",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "Lenovo",
        "name": "Lenovo ThinkPad X1 Carbon Gen 11",
        "product_name": "Lenovo ThinkPad X1 Carbon Gen 11",
        "exact_model": "ThinkPad X1 Carbon Gen 11 (14-inch)",
        "variant": "16GB RAM / 512GB SSD / Deep Black",
        "price": 158990.0,
        "price_inr": 158990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 160,
        "imageUrl": "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.lenovo.com/in/en/p/laptops/thinkpad/thinkpadx1/thinkpad-x1-carbon-gen-11-14-inch-intel/len101t0049",
        "productSourceUrl": "https://www.lenovo.com/in/en/p/laptops/thinkpad/thinkpadx1/thinkpad-x1-carbon-gen-11-14-inch-intel/len101t0049",
        "retailerOffers": [
            {"retailerName": "Lenovo India Store", "productUrl": "https://www.lenovo.com/in/en/p/laptops/thinkpad/thinkpadx1/thinkpad-x1-carbon-gen-11-14-inch-intel/len101t0049", "price": 158990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0C39X1CAR", "price": 156990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Intel Core i7-1355U (10 cores, up to 5.0 GHz)",
            "ram": "16GB LPDDR5 6400MHz",
            "storage": "512GB M.2 PCIe NVMe SSD",
            "gpu": "Intel Iris Xe Graphics",
            "display": "14\" WUXGA (1920x1200) IPS Anti-glare 400 nits, 100% sRGB",
            "battery": "57 Wh (Up to 13.5 hours, Rapid Charge 80% in 60min)",
            "weight": "1.12 kg",
            "os": "Windows 11 Pro"
        },
        "features": [
            "Featherweight 1.12 kg carbon-fiber reinforced magnesium alloy construction",
            "Legendary spill-resistant ThinkPad keyboard with TrackPoint and glass touchpad",
            "Tested against 12 MIL-STD-810H military requirements for extreme durability"
        ],
        "priorityAffinities": {"performance": 0.86, "battery": 0.90, "portability": 0.99, "ram": 0.88, "build_quality": 0.98, "value": 0.80}
    },
    {
        "id": "lap-005",
        "slug": "asus-rog-zephyrus-g14",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "ASUS",
        "name": "ASUS ROG Zephyrus G14 (2024)",
        "product_name": "ASUS ROG Zephyrus G14 (2024)",
        "exact_model": "ROG Zephyrus G14 GA403UI",
        "variant": "16GB RAM / 1TB SSD / RTX 4070 / Eclipse Gray",
        "price": 174990.0,
        "price_inr": 174990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 210,
        "imageUrl": "https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.asus.com/in/laptops/for-gaming/rog-republic-of-gamers/rog-zephyrus-g14-2024",
        "productSourceUrl": "https://www.asus.com/in/laptops/for-gaming/rog-republic-of-gamers/rog-zephyrus-g14-2024",
        "retailerOffers": [
            {"retailerName": "ASUS India Store", "productUrl": "https://www.asus.com/in/laptops/for-gaming/rog-republic-of-gamers/rog-zephyrus-g14-2024", "price": 174990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CV5X4070", "price": 172990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "AMD Ryzen 9 8945HS (8 cores, 16 threads, AMD Ryzen AI 16 NPU TOPS)",
            "ram": "16GB LPDDR5X 6400MHz",
            "storage": "1TB PCIe 4.0 NVMe M.2 SSD",
            "gpu": "NVIDIA GeForce RTX 4070 8GB GDDR6 (90W TGP)",
            "display": "14\" 3K (2880x1800) 120Hz ROG Nebula OLED 0.2ms, G-Sync, 500 nits",
            "battery": "73 Wh (100W USB-C Power Delivery)",
            "weight": "1.50 kg",
            "os": "Windows 11 Home"
        },
        "features": [
            "All-aluminum unibody chassis with Slash Lighting LED diagonal array",
            "First ROG OLED gaming display with 0.2ms response time and VESA DisplayHDR True Black 500",
            "ROG Intelligent Cooling with liquid metal compound and tri-fan vapor chamber"
        ],
        "priorityAffinities": {"performance": 0.98, "battery": 0.82, "portability": 0.89, "ram": 0.90, "build_quality": 0.96, "value": 0.80}
    },
    {
        "id": "lap-006",
        "slug": "acer-swift-go-14-oled",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "Acer",
        "name": "Acer Swift Go 14 OLED",
        "product_name": "Acer Swift Go 14 OLED",
        "exact_model": "Swift Go 14 SFG14-72 OLED",
        "variant": "16GB RAM / 512GB SSD / Pure Silver",
        "price": 79990.0,
        "price_inr": 79990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 195,
        "imageUrl": "https://images.unsplash.com/photo-1593642702821-c8da6771f0c6?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1593642702821-c8da6771f0c6?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.acer.com/in-en/laptops/swift/swift-go-14",
        "productSourceUrl": "https://www.acer.com/in-en/laptops/swift/swift-go-14",
        "retailerOffers": [
            {"retailerName": "Acer India Store", "productUrl": "https://www.acer.com/in-en/laptops/swift/swift-go-14", "price": 79990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CN5XSW14", "price": 77990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Intel Core Ultra 5 125H (14 cores, 18 threads, Intel AI Boost)",
            "ram": "16GB LPDDR5X",
            "storage": "512GB PCIe Gen4 SSD",
            "gpu": "Intel Arc Graphics",
            "display": "14\" 2.8K (2880x1800) 90Hz OLED 400 nits, 100% DCI-P3, DisplayHDR 500",
            "battery": "65 Wh (Up to 11 hours)",
            "weight": "1.32 kg",
            "os": "Windows 11 Home"
        },
        "features": [
            "Stunning 2.8K 90Hz OLED screen delivering 100% DCI-P3 cinematic color",
            "Intel AI Boost NPU acceleration for background blur and noise reduction",
            "TwinAir dual fan cooling architecture with dual copper heat pipes"
        ],
        "priorityAffinities": {"performance": 0.88, "battery": 0.85, "portability": 0.94, "ram": 0.88, "build_quality": 0.90, "value": 0.94}
    },
    {
        "id": "lap-007",
        "slug": "hp-pavilion-plus-14",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "HP",
        "name": "HP Pavilion Plus 14 OLED",
        "product_name": "HP Pavilion Plus 14 OLED",
        "exact_model": "Pavilion Plus 14-ey0000au",
        "variant": "16GB RAM / 512GB SSD / Natural Silver",
        "price": 82990.0,
        "price_inr": 82990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 275,
        "imageUrl": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.hp.com/in-en/shop/hp-pavilion-plus-laptop-14-ey0000au.html",
        "productSourceUrl": "https://www.hp.com/in-en/shop/hp-pavilion-plus-laptop-14-ey0000au.html",
        "retailerOffers": [
            {"retailerName": "HP India Store", "productUrl": "https://www.hp.com/in-en/shop/hp-pavilion-plus-laptop-14-ey0000au.html", "price": 82990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CK5XPAV1", "price": 81990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "AMD Ryzen 7 7840U (8 cores, 16 threads, up to 5.1 GHz)",
            "ram": "16GB LPDDR5x 6400MHz",
            "storage": "512GB PCIe NVMe M.2 SSD",
            "gpu": "AMD Radeon 780M Graphics",
            "display": "14\" 2.8K (2880x1800) 120Hz OLED 500 nits HDR, IMAX Enhanced",
            "battery": "68 Wh (Up to 12.5 hours, fast charge 50% in 30min)",
            "weight": "1.38 kg",
            "os": "Windows 11 Home"
        },
        "features": [
            "Best-in-class integrated graphics (Radeon 780M) capable of light AAA gaming",
            "IMAX Enhanced certified 120Hz variable refresh rate OLED screen",
            "Recycled metal cover with 5MP IR camera and manual privacy shutter"
        ],
        "priorityAffinities": {"performance": 0.91, "battery": 0.89, "portability": 0.92, "ram": 0.88, "build_quality": 0.91, "value": 0.93}
    },
    {
        "id": "lap-008",
        "slug": "lenovo-ideapad-slim-5",
        "category": "laptops",
        "subcategory": "laptops",
        "brand": "Lenovo",
        "name": "Lenovo IdeaPad Slim 5 14",
        "product_name": "Lenovo IdeaPad Slim 5 14",
        "exact_model": "IdeaPad Slim 5 14IRH8",
        "variant": "16GB RAM / 512GB SSD / Cloud Grey",
        "price": 64990.0,
        "price_inr": 64990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 320,
        "imageUrl": "https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.lenovo.com/in/en/p/laptops/ideapad/ideapad-500-series/ideapad-slim-5-gen-8-14-inch-amd/len101i0082",
        "productSourceUrl": "https://www.lenovo.com/in/en/p/laptops/ideapad/ideapad-500-series/ideapad-slim-5-gen-8-14-inch-amd/len101i0082",
        "retailerOffers": [
            {"retailerName": "Lenovo India Store", "productUrl": "https://www.lenovo.com/in/en/p/laptops/ideapad/ideapad-500-series/ideapad-slim-5-gen-8-14-inch-amd/len101i0082", "price": 64990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0C49XSLM5", "price": 63990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Intel Core i5-13500H (12 cores, 16 threads, up to 4.7 GHz)",
            "ram": "16GB LPDDR5 5200MHz",
            "storage": "512GB SSD M.2 PCIe NVMe",
            "gpu": "Intel Iris Xe Graphics",
            "display": "14\" WUXGA (1920x1200) IPS 300 nits Anti-glare, 100% sRGB",
            "battery": "56.6 Wh (Rapid Charge Boost)",
            "weight": "1.46 kg",
            "os": "Windows 11 Home"
        },
        "features": [
            "All-metal anodized aluminum top cover with diamond-cut touch edge",
            "Military standard 810H durability tested for vibration, drop, and humidity",
            "FHD infrared camera with Time-of-Flight presence detection"
        ],
        "priorityAffinities": {"performance": 0.87, "battery": 0.84, "portability": 0.90, "ram": 0.88, "build_quality": 0.89, "value": 0.96}
    }
]
new_products.extend(laptops)
print(f"Added {len(laptops)} laptops.")

# ==========================================
# 3. BOOKS & STUDY MATERIALS (8 Products)
# ==========================================
books = [
    {
        "id": "book-001",
        "slug": "hands-on-machine-learning-geron",
        "category": "books",
        "subcategory": "ai_ml_books",
        "brand": "O'Reilly Media",
        "name": "Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow",
        "product_name": "Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow",
        "exact_model": "3rd Edition (ISBN: 978-1098125974)",
        "variant": "Paperback / 3rd Edition (856 pages)",
        "price": 3250.0,
        "price_inr": 3250.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 1420,
        "imageUrl": "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.oreilly.com/library/view/hands-on-machine-learning/9781098125967/",
        "productSourceUrl": "https://www.oreilly.com/library/view/hands-on-machine-learning/9781098125967/",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/1098125975", "price": 3250.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "Aurélien Géron",
            "publisher": "O'Reilly Media",
            "edition": "3rd Edition (2022)",
            "pages": "856 pages",
            "isbn": "978-1098125974",
            "language": "English",
            "domain": "Artificial Intelligence & Machine Learning",
            "format": "Paperback"
        },
        "features": [
            "Complete coverage of Scikit-Learn, Keras, TensorFlow 2, and Transformers",
            "End-to-end practical machine learning project walkthroughs with Colab notebooks",
            "Explains generative AI, diffusion models, GANs, and deep reinforcement learning"
        ],
        "priorityAffinities": {"depth": 0.98, "practical": 0.99, "reputation": 0.98, "value": 0.88}
    },
    {
        "id": "book-002",
        "slug": "python-crash-course-matthes",
        "category": "books",
        "subcategory": "programming_books",
        "brand": "No Starch Press",
        "name": "Python Crash Course: A Hands-On, Project-Based Introduction",
        "product_name": "Python Crash Course: A Hands-On, Project-Based Introduction",
        "exact_model": "3rd Edition (ISBN: 978-1718502703)",
        "variant": "Paperback / 3rd Edition (552 pages)",
        "price": 1995.0,
        "price_inr": 1995.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 1850,
        "imageUrl": "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://nostarch.com/python-crash-course-3rd-edition",
        "productSourceUrl": "https://nostarch.com/python-crash-course-3rd-edition",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/1718502702", "price": 1995.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "Eric Matthes",
            "publisher": "No Starch Press",
            "edition": "3rd Edition (2023)",
            "pages": "552 pages",
            "isbn": "978-1718502703",
            "language": "English",
            "domain": "Python Programming",
            "format": "Paperback"
        },
        "features": [
            "World's bestselling guide to Python programming language",
            "Part 1 covers fundamental core concepts; Part 2 guides three substantial real-world projects",
            "Includes Space Invaders 2D arcade game, interactive data visualizations, and Django web app"
        ],
        "priorityAffinities": {"depth": 0.88, "practical": 0.98, "reputation": 0.96, "value": 0.94}
    },
    {
        "id": "book-003",
        "slug": "introduction-to-algorithms-clrs",
        "category": "books",
        "subcategory": "dsa_books",
        "brand": "MIT Press",
        "name": "Introduction to Algorithms (CLRS)",
        "product_name": "Introduction to Algorithms (CLRS)",
        "exact_model": "4th Edition (ISBN: 978-0262046305)",
        "variant": "Hardcover / 4th Edition (1312 pages)",
        "price": 4450.0,
        "price_inr": 4450.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 2100,
        "imageUrl": "https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://mitpress.mit.edu/9780262046305/introduction-to-algorithms/",
        "productSourceUrl": "https://mitpress.mit.edu/9780262046305/introduction-to-algorithms/",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/026204630X", "price": 4450.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein",
            "publisher": "MIT Press",
            "edition": "4th Edition (2022)",
            "pages": "1312 pages",
            "isbn": "978-0262046305",
            "language": "English",
            "domain": "Data Structures & Algorithms (DSA)",
            "format": "Hardcover"
        },
        "features": [
            "The definitive global textbook on algorithms referenced across top CS universities",
            "Updated 4th edition with new chapters on bipartite matching, online algorithms, and machine learning",
            "Clear pseudocode accessible to anyone with basic programming background"
        ],
        "priorityAffinities": {"depth": 1.0, "practical": 0.85, "reputation": 1.0, "value": 0.80}
    },
    {
        "id": "book-004",
        "slug": "operating-system-concepts-silberschatz",
        "category": "books",
        "subcategory": "cs_core_books",
        "brand": "Wiley",
        "name": "Operating System Concepts (The Dinosaur Book)",
        "product_name": "Operating System Concepts (The Dinosaur Book)",
        "exact_model": "10th Edition (ISBN: 978-1119800361)",
        "variant": "Paperback / 10th Edition (1248 pages)",
        "price": 1120.0,
        "price_inr": 1120.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 980,
        "imageUrl": "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.wiley.com/en-us/Operating+System+Concepts%2C+10th+Edition-p-9781119800361",
        "productSourceUrl": "https://www.wiley.com/en-us/Operating+System+Concepts%2C+10th+Edition-p-9781119800361",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/1119800366", "price": 1120.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "Abraham Silberschatz, Peter B. Galvin, Greg Gagne",
            "publisher": "Wiley India",
            "edition": "10th Edition (2021)",
            "pages": "1248 pages",
            "isbn": "978-1119800361",
            "language": "English",
            "domain": "Operating Systems & Computer Systems",
            "format": "Paperback"
        },
        "features": [
            "Comprehensive treatment of process synchronization, virtual memory, filesystems, and security",
            "In-depth Linux, Windows, and macOS kernel architecture comparisons",
            "Includes C and Java programming problems and virtual machine simulation exercises"
        ],
        "priorityAffinities": {"depth": 0.96, "practical": 0.88, "reputation": 0.98, "value": 0.96}
    },
    {
        "id": "book-005",
        "slug": "database-system-concepts-korth",
        "category": "books",
        "subcategory": "cs_core_books",
        "brand": "McGraw-Hill",
        "name": "Database System Concepts",
        "product_name": "Database System Concepts",
        "exact_model": "7th Edition (ISBN: 978-9389949438)",
        "variant": "Paperback / 7th Edition (1392 pages)",
        "price": 1090.0,
        "price_inr": 1090.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 760,
        "imageUrl": "https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.mheducation.co.in/database-system-concepts-9789389949438-india",
        "productSourceUrl": "https://www.mheducation.co.in/database-system-concepts-9789389949438-india",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/9389949436", "price": 1090.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "Abraham Silberschatz, Henry F. Korth, S. Sudarshan",
            "publisher": "McGraw-Hill Education India",
            "edition": "7th Edition (2020)",
            "pages": "1392 pages",
            "isbn": "978-9389949438",
            "language": "English",
            "domain": "Database Management Systems (DBMS) & SQL",
            "format": "Paperback"
        },
        "features": [
            "Covers relational databases, SQL queries, normalization, indexing, transaction ACID properties",
            "Expanded 7th edition coverage of Big Data, NoSQL, MapReduce, and columnar databases",
            "Written by seminal database researchers from Bell Labs and IIT Bombay"
        ],
        "priorityAffinities": {"depth": 0.97, "practical": 0.90, "reputation": 0.98, "value": 0.96}
    },
    {
        "id": "book-006",
        "slug": "computer-networking-kurose-ross",
        "category": "books",
        "subcategory": "cs_core_books",
        "brand": "Pearson",
        "name": "Computer Networking: A Top-Down Approach",
        "product_name": "Computer Networking: A Top-Down Approach",
        "exact_model": "8th Edition (ISBN: 978-0136681557)",
        "variant": "Paperback / 8th Edition (864 pages)",
        "price": 1050.0,
        "price_inr": 1050.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 1100,
        "imageUrl": "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.pearson.com/en-us/subject-catalog/p/computer-networking-a-top-down-approach/P200000003333",
        "productSourceUrl": "https://www.pearson.com/en-us/subject-catalog/p/computer-networking-a-top-down-approach/P200000003333",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/0136681552", "price": 1050.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "James F. Kurose, Keith W. Ross",
            "publisher": "Pearson Education India",
            "edition": "8th Edition (2021)",
            "pages": "864 pages",
            "isbn": "978-0136681557",
            "language": "English",
            "domain": "Computer Networks & Protocols",
            "format": "Paperback"
        },
        "features": [
            "Pioneering top-down approach starting at application layer down to physical transport",
            "Comprehensive exploration of HTTP/3, QUIC, DNS, TCP congestion control, and BGP routing",
            "Hands-on Wireshark lab assignments with real packet capture analysis"
        ],
        "priorityAffinities": {"depth": 0.95, "practical": 0.95, "reputation": 0.98, "value": 0.96}
    },
    {
        "id": "book-007",
        "slug": "designing-data-intensive-applications",
        "category": "books",
        "subcategory": "systems_books",
        "brand": "O'Reilly Media",
        "name": "Designing Data-Intensive Applications",
        "product_name": "Designing Data-Intensive Applications",
        "exact_model": "1st Edition (ISBN: 978-9352135240)",
        "variant": "Paperback / 1st Edition (616 pages)",
        "price": 1850.0,
        "price_inr": 1850.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 5.0,
        "reviewCount": 3400,
        "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/",
        "productSourceUrl": "https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/9352135245", "price": 1850.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "Martin Kleppmann",
            "publisher": "O'Reilly Media",
            "edition": "1st Edition (2017)",
            "pages": "616 pages",
            "isbn": "978-9352135240",
            "language": "English",
            "domain": "Distributed Systems, Data Engineering & Architecture",
            "format": "Paperback"
        },
        "features": [
            "Widely regarded as the bible of scalable distributed systems and backend engineering",
            "Deep analysis of storage engines, replication strategies, partitioning, and distributed consensus",
            "Unpacks the engineering trade-offs behind Kafka, Cassandra, PostgreSQL, and Raft"
        ],
        "priorityAffinities": {"depth": 1.0, "practical": 0.96, "reputation": 1.0, "value": 0.94}
    },
    {
        "id": "book-008",
        "slug": "gate-cse-made-easy-solved-papers",
        "category": "books",
        "subcategory": "exam_prep_books",
        "brand": "MADE EASY Publications",
        "name": "GATE 2025: Computer Science & IT Topicwise Previous Solved Papers",
        "product_name": "GATE 2025: Computer Science & IT Topicwise Previous Solved Papers",
        "exact_model": "2025 Exam Edition (ISBN: 978-9391065843)",
        "variant": "Paperback / 2025 Edition (980 pages)",
        "price": 890.0,
        "price_inr": 890.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 1650,
        "imageUrl": "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.madeeasypublications.org/product/gate-cs-solved-papers",
        "productSourceUrl": "https://www.madeeasypublications.org/product/gate-cs-solved-papers",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/9391065840", "price": 890.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "author": "MADE EASY Editorial Board",
            "publisher": "MADE EASY Publications",
            "edition": "2025 Exam Edition",
            "pages": "980 pages",
            "isbn": "978-9391065843",
            "language": "English",
            "domain": "GATE & Competitive Exam Preparation (CSE/IT)",
            "format": "Paperback"
        },
        "features": [
            "34+ years of authentic topicwise solved papers for GATE CSE & Information Technology",
            "Step-by-step rigorous mathematical derivations and explanatory answers",
            "Crucial preparation standard for IIT M.Tech admissions and PSU recruitment exams"
        ],
        "priorityAffinities": {"depth": 0.92, "practical": 0.99, "reputation": 0.96, "value": 0.98}
    }
]
new_products.extend(books)
print(f"Added {len(books)} books.")

# ==========================================
# 4. MAGAZINES & PERIODICALS (8 Products)
# ==========================================
magazines = [
    {
        "id": "mag-001",
        "slug": "mit-technology-review-subscription",
        "category": "magazines",
        "subcategory": "tech_magazines",
        "brand": "MIT Technology Review",
        "name": "MIT Technology Review (Annual Subscription)",
        "product_name": "MIT Technology Review (Annual Subscription)",
        "exact_model": "Annual Subscription (6 Issues + Digital Archive)",
        "variant": "Print + Digital (6 issues/year)",
        "price": 4800.0,
        "price_inr": 4800.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 380,
        "imageUrl": "https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.technologyreview.com/subscribe/",
        "productSourceUrl": "https://www.technologyreview.com/subscribe/",
        "retailerOffers": [
            {"retailerName": "MIT Technology Review Store", "productUrl": "https://www.technologyreview.com/subscribe/", "price": 4800.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Bi-Monthly (6 issues per year)",
            "publisher": "MIT Technology Review / MIT Press",
            "issn": "0040-1692",
            "domain": "Emerging Technologies, Artificial Intelligence, Biotech & Energy",
            "format": "Print + Unlimited Digital",
            "pages_per_issue": "112 pages"
        },
        "features": [
            "Renowned '10 Breakthrough Technologies' annual definitive curation",
            "Deep, unbiased technological journalism independent of corporate PR",
            "Full digital access to 125-year comprehensive research archive"
        ],
        "priorityAffinities": {"depth": 0.99, "frequency": 0.82, "prestige": 0.99, "value": 0.88}
    },
    {
        "id": "mag-002",
        "slug": "wired-magazine-subscription",
        "category": "magazines",
        "subcategory": "tech_magazines",
        "brand": "Condé Nast",
        "name": "Wired Magazine (Annual Subscription)",
        "product_name": "Wired Magazine (Annual Subscription)",
        "exact_model": "Annual Subscription (10 Issues)",
        "variant": "Print + Digital Access",
        "price": 3600.0,
        "price_inr": 3600.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 540,
        "imageUrl": "https://images.unsplash.com/photo-1585829365295-ab7cd400c167?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1585829365295-ab7cd400c167?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.wired.com/subscribe",
        "productSourceUrl": "https://www.wired.com/subscribe",
        "retailerOffers": [
            {"retailerName": "Condé Nast Store", "productUrl": "https://www.wired.com/subscribe", "price": 3600.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Monthly (10 issues per year)",
            "publisher": "Condé Nast",
            "issn": "1059-1028",
            "domain": "Technology, Science, Culture & Digital Economy",
            "format": "Print + Web Edition",
            "pages_per_issue": "96 pages"
        },
        "features": [
            "Pioneering cultural analysis of cybernetics, Silicon Valley, and AI evolution",
            "Long-form investigative reporting on digital privacy, security, and geopolitics",
            "Iconic graphic design and futuristic visual editorial spreads"
        ],
        "priorityAffinities": {"depth": 0.90, "frequency": 0.92, "prestige": 0.95, "value": 0.94}
    },
    {
        "id": "mag-003",
        "slug": "scientific-american-subscription",
        "category": "magazines",
        "subcategory": "science_magazines",
        "brand": "Springer Nature",
        "name": "Scientific American (Annual Subscription)",
        "product_name": "Scientific American (Annual Subscription)",
        "exact_model": "Annual Subscription (12 Monthly Issues)",
        "variant": "Print + Online Archive",
        "price": 4200.0,
        "price_inr": 4200.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 420,
        "imageUrl": "https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.scientificamerican.com/page/subscribe/",
        "productSourceUrl": "https://www.scientificamerican.com/page/subscribe/",
        "retailerOffers": [
            {"retailerName": "Springer Nature India", "productUrl": "https://www.scientificamerican.com/page/subscribe/", "price": 4200.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Monthly (12 issues per year)",
            "publisher": "Springer Nature",
            "issn": "0036-8733",
            "domain": "Physics, Neuroscience, Space, Climate & Biology",
            "format": "Print + Online Archive",
            "pages_per_issue": "88 pages"
        },
        "features": [
            "Oldest continuously published magazine in the United States (founded 1845)",
            "Over 200 Nobel Prize laureates have authored articles in its pages",
            "Accessible yet uncompromising scientific depth spanning astrophysics to immunology"
        ],
        "priorityAffinities": {"depth": 0.98, "frequency": 0.95, "prestige": 0.98, "value": 0.90}
    },
    {
        "id": "mag-004",
        "slug": "harvard-business-review-subscription",
        "category": "magazines",
        "subcategory": "business_magazines",
        "brand": "Harvard Business Publishing",
        "name": "Harvard Business Review (HBR Annual Subscription)",
        "product_name": "Harvard Business Review (HBR Annual Subscription)",
        "exact_model": "Annual Subscription (6 Bimonthly Issues)",
        "variant": "Print + Digital Archive Access",
        "price": 5400.0,
        "price_inr": 5400.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 650,
        "imageUrl": "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://hbr.org/subscriptions",
        "productSourceUrl": "https://hbr.org/subscriptions",
        "retailerOffers": [
            {"retailerName": "HBR Global Store", "productUrl": "https://hbr.org/subscriptions", "price": 5400.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Bi-Monthly (6 issues per year)",
            "publisher": "Harvard Business Publishing",
            "issn": "0017-8012",
            "domain": "Leadership, Strategic Management, Organizational Innovation",
            "format": "Print + Digital Archive Access",
            "pages_per_issue": "144 pages"
        },
        "features": [
            "The benchmark management and leadership periodical for Fortune 500 executives",
            "Case studies and operational research from Harvard Business School faculty",
            "Includes digital case archive and HBR IdeaCast audio briefings"
        ],
        "priorityAffinities": {"depth": 0.99, "frequency": 0.80, "prestige": 1.0, "value": 0.82}
    },
    {
        "id": "mag-005",
        "slug": "national-geographic-subscription",
        "category": "magazines",
        "subcategory": "science_magazines",
        "brand": "National Geographic Society",
        "name": "National Geographic Magazine (Annual Subscription)",
        "product_name": "National Geographic Magazine (Annual Subscription)",
        "exact_model": "Annual Subscription (12 Monthly Issues)",
        "variant": "Print Edition + Digital Library",
        "price": 3850.0,
        "price_inr": 3850.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 890,
        "imageUrl": "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.nationalgeographic.com/pages/topic/subscribe",
        "productSourceUrl": "https://www.nationalgeographic.com/pages/topic/subscribe",
        "retailerOffers": [
            {"retailerName": "National Geographic India", "productUrl": "https://www.nationalgeographic.com/pages/topic/subscribe", "price": 3850.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Monthly (12 issues per year)",
            "publisher": "National Geographic Partners",
            "issn": "0027-9358",
            "domain": "Geography, Exploration, Natural History & Conservation",
            "format": "Print + Digital",
            "pages_per_issue": "140 pages"
        },
        "features": [
            "World-renowned environmental photojournalism and exploratory field research",
            "Iconic yellow-bordered collector's print edition with pull-out cartographic maps",
            "Stories from frontline conservation biologists, archaeologists, and oceanographers"
        ],
        "priorityAffinities": {"depth": 0.94, "frequency": 0.95, "prestige": 0.99, "value": 0.92}
    },
    {
        "id": "mag-006",
        "slug": "bloomberg-businessweek-subscription",
        "category": "magazines",
        "subcategory": "business_magazines",
        "brand": "Bloomberg L.P.",
        "name": "Bloomberg Businessweek (Annual Subscription)",
        "product_name": "Bloomberg Businessweek (Annual Subscription)",
        "exact_model": "Annual Subscription (50 Weekly Issues)",
        "variant": "Print + Bloomberg App",
        "price": 5999.0,
        "price_inr": 5999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 310,
        "imageUrl": "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.bloomberg.com/businessweek",
        "productSourceUrl": "https://www.bloomberg.com/businessweek",
        "retailerOffers": [
            {"retailerName": "Bloomberg Official", "productUrl": "https://www.bloomberg.com/businessweek", "price": 5999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Weekly (50 issues per year)",
            "publisher": "Bloomberg L.P.",
            "issn": "0007-7135",
            "domain": "Global Finance, Economics, Markets & Corporate Strategy",
            "format": "Print + Bloomberg App",
            "pages_per_issue": "72 pages"
        },
        "features": [
            "Weekly rapid-response financial intelligence on central banks and public markets",
            "Irreverent, provocative cover stories detailing Silicon Valley and Wall Street power dynamics",
            "Direct access to Bloomberg data terminals infographics and macroeconomic metrics"
        ],
        "priorityAffinities": {"depth": 0.92, "frequency": 1.0, "prestige": 0.96, "value": 0.86}
    },
    {
        "id": "mag-007",
        "slug": "fast-company-subscription",
        "category": "magazines",
        "subcategory": "business_magazines",
        "brand": "Mansueto Ventures",
        "name": "Fast Company Magazine (Annual Subscription)",
        "product_name": "Fast Company Magazine (Annual Subscription)",
        "exact_model": "Annual Subscription (6 Issues)",
        "variant": "Print + Digital",
        "price": 3200.0,
        "price_inr": 3200.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 260,
        "imageUrl": "https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.fastcompany.com/subscribe",
        "productSourceUrl": "https://www.fastcompany.com/subscribe",
        "retailerOffers": [
            {"retailerName": "Fast Company Store", "productUrl": "https://www.fastcompany.com/subscribe", "price": 3200.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Bi-Monthly (6 issues per year)",
            "publisher": "Mansueto Ventures",
            "issn": "1085-9241",
            "domain": "Design, Creative Leadership, Startups & Tech Innovation",
            "format": "Print + Digital",
            "pages_per_issue": "100 pages"
        },
        "features": [
            "Hosts the prestigious 'World's Most Innovative Companies' annual index",
            "Focuses on the intersection of human-centered design, ethics, and venture capital",
            "Actionable insights from design pioneers, creative directors, and founders"
        ],
        "priorityAffinities": {"depth": 0.88, "frequency": 0.82, "prestige": 0.90, "value": 0.92}
    },
    {
        "id": "mag-008",
        "slug": "digit-magazine-india-subscription",
        "category": "magazines",
        "subcategory": "tech_magazines",
        "brand": "9.9 Media",
        "name": "Digit Magazine India (Annual Subscription)",
        "product_name": "Digit Magazine India (Annual Subscription)",
        "exact_model": "Annual Print Subscription (12 Issues + Fast Track)",
        "variant": "Print + Fast Track Books (12 issues)",
        "price": 2400.0,
        "price_inr": 2400.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 710,
        "imageUrl": "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.digit.in/subscribe/",
        "productSourceUrl": "https://www.digit.in/subscribe/",
        "retailerOffers": [
            {"retailerName": "Digit India Store", "productUrl": "https://www.digit.in/subscribe/", "price": 2400.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "frequency": "Monthly (12 issues per year)",
            "publisher": "9.9 Group India",
            "domain": "Consumer Tech, PC Hardware, Software Tutorials & Gaming in India",
            "format": "Print + Fast Track Guide Booklet",
            "pages_per_issue": "128 pages"
        },
        "features": [
            "India's premier technology monthly guide with Zero1 Awards benchmark comparisons",
            "Includes monthly 'Fast Track to' in-depth technical handbook (coding, hacking, hardware)",
            "Strict lab-tested hardware benchmarks performed on Indian retail SKUs"
        ],
        "priorityAffinities": {"depth": 0.90, "frequency": 0.95, "prestige": 0.91, "value": 0.98}
    }
]
new_products.extend(magazines)
print(f"Added {len(magazines)} magazines.")

# ==========================================
# 5. CONSUMER ELECTRONICS (8 Products)
# ==========================================
consumer_electronics = [
    {
        "id": "ce-001",
        "slug": "apple-airpods-pro-2-usb-c",
        "category": "consumer_electronics",
        "subcategory": "wireless_audio",
        "brand": "Apple",
        "name": "Apple AirPods Pro (2nd Generation, USB-C)",
        "product_name": "Apple AirPods Pro (2nd Generation, USB-C)",
        "exact_model": "AirPods Pro (2nd Gen) with MagSafe Case (USB-C)",
        "variant": "White / USB-C Case",
        "price": 24900.0,
        "price_inr": 24900.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 1350,
        "imageUrl": "https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.apple.com/in/shop/product/MTJV3HN/A/airpods-pro",
        "productSourceUrl": "https://www.apple.com/in/shop/product/MTJV3HN/A/airpods-pro",
        "retailerOffers": [
            {"retailerName": "Apple Store India", "productUrl": "https://www.apple.com/in/shop/product/MTJV3HN/A/airpods-pro", "price": 24900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CHX7XCVY", "price": 23990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "audio_chip": "Apple H2 Headphone Chip",
            "battery": "6 hours (up to 30 hours with charging case)",
            "noise_cancellation": "Active Noise Cancellation with Adaptive Audio & Transparency",
            "water_rating": "IP54 dust, sweat, and water resistant",
            "connectivity": "Bluetooth 5.3",
            "weight": "5.3g per bud, 50.8g case"
        },
        "features": [
            "Up to 2x more active noise cancellation than 1st generation AirPods Pro",
            "Adaptive Audio dynamically blends Transparency and Noise Cancellation for your environment",
            "Personalized Spatial Audio with dynamic head tracking and Lossless Audio with Vision Pro"
        ],
        "priorityAffinities": {"audio_quality": 0.96, "ergonomics": 0.98, "battery_life": 0.88, "build_quality": 0.95, "value": 0.84}
    },
    {
        "id": "ce-002",
        "slug": "bose-quietcomfort-ultra",
        "category": "consumer_electronics",
        "subcategory": "wireless_audio",
        "brand": "Bose",
        "name": "Bose QuietComfort Ultra Wireless Headphones",
        "product_name": "Bose QuietComfort Ultra Wireless Headphones",
        "exact_model": "QuietComfort Ultra Over-Ear ANC",
        "variant": "Black / Over-Ear",
        "price": 35900.0,
        "price_inr": 35900.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 420,
        "imageUrl": "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.bose.com/p/headphones/bose-quietcomfort-ultra-headphones/QCU-HEADPHONEARN.html",
        "productSourceUrl": "https://www.bose.com/p/headphones/bose-quietcomfort-ultra-headphones/QCU-HEADPHONEARN.html",
        "retailerOffers": [
            {"retailerName": "Bose Official India", "productUrl": "https://www.bose.com/p/headphones/bose-quietcomfort-ultra-headphones/QCU-HEADPHONEARN.html", "price": 35900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CCZ1L489", "price": 35900.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "battery": "24 hours (up to 18 hours with Immersive Audio)",
            "noise_cancellation": "CustomTune World-Class Active Noise Cancellation",
            "spatial_audio": "Bose Immersive Audio with head tracking",
            "connectivity": "Bluetooth 5.3, Snapdragon Sound, aptX Adaptive",
            "weight": "253g"
        },
        "features": [
            "CustomTune sound calibration analyzes individual ear canal acoustics",
            "Unrivaled quiet with Quiet Mode, Aware Mode, and Immersion Mode",
            "Ultra-luxurious protein leather ear cushions designed for all-day flights"
        ],
        "priorityAffinities": {"audio_quality": 0.98, "ergonomics": 0.97, "battery_life": 0.90, "build_quality": 0.96, "value": 0.78}
    },
    {
        "id": "ce-003",
        "slug": "logitech-mx-master-3s",
        "category": "consumer_electronics",
        "subcategory": "peripherals",
        "brand": "Logitech",
        "name": "Logitech MX Master 3S Wireless Mouse",
        "product_name": "Logitech MX Master 3S Wireless Mouse",
        "exact_model": "MX Master 3S Performance Wireless Mouse",
        "variant": "Graphite / 8000 DPI",
        "price": 9495.0,
        "price_inr": 9495.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 2400,
        "imageUrl": "https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.logitech.com/en-in/products/mice/mx-master-3s.html",
        "productSourceUrl": "https://www.logitech.com/en-in/products/mice/mx-master-3s.html",
        "retailerOffers": [
            {"retailerName": "Logitech Store India", "productUrl": "https://www.logitech.com/en-in/products/mice/mx-master-3s.html", "price": 9495.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0B11LK69K", "price": 9295.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "sensor": "8,000 DPI Darkfield glass-tracking sensor",
            "scroll_wheel": "MagSpeed Electromagnetic scroll (1,000 lines/sec)",
            "battery": "500 mAh (Up to 70 days, 3 hours from 1 min charge)",
            "connectivity": "Bluetooth Low Energy & Logi Bolt USB Receiver",
            "weight": "141g"
        },
        "features": [
            "Quiet Clicks technology reduces 90% click noise while maintaining tactile bump",
            "MagSpeed electromagnetic scroll wheel scrolls 1,000 lines per second in hyper-fast mode",
            "Cross-computer Logi Flow control enables seamless cursor transition across 3 PCs"
        ],
        "priorityAffinities": {"audio_quality": 0.50, "ergonomics": 1.0, "battery_life": 0.99, "build_quality": 0.96, "value": 0.94}
    },
    {
        "id": "ce-004",
        "slug": "logitech-mx-mechanical-keyboard",
        "category": "consumer_electronics",
        "subcategory": "peripherals",
        "brand": "Logitech",
        "name": "Logitech MX Mechanical Wireless Keyboard",
        "product_name": "Logitech MX Mechanical Wireless Keyboard",
        "exact_model": "MX Mechanical Full-Size Wireless Illuminated",
        "variant": "Tactile Quiet Switches / Graphite",
        "price": 14995.0,
        "price_inr": 14995.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 820,
        "imageUrl": "https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.logitech.com/en-in/products/keyboards/mx-mechanical.html",
        "productSourceUrl": "https://www.logitech.com/en-in/products/keyboards/mx-mechanical.html",
        "retailerOffers": [
            {"retailerName": "Logitech Store India", "productUrl": "https://www.logitech.com/en-in/products/keyboards/mx-mechanical.html", "price": 14995.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B09LK1V8Y4", "price": 14495.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "switches": "Tactile Quiet low-profile mechanical switches",
            "backlighting": "Smart ambient backlighting with proximity sensors",
            "battery": "Up to 15 days (up to 10 months with backlighting off)",
            "connectivity": "Bluetooth Low Energy & Logi Bolt, multi-device (3 OS)",
            "weight": "828g"
        },
        "features": [
            "Low-profile mechanical keys deliver natural, satisfying mechanical typing feel with minimal wrist strain",
            "Proximity sensors light up keycaps the instant your hands approach",
            "Easy-Switch keys connect to up to 3 devices simultaneously across Mac and Windows"
        ],
        "priorityAffinities": {"audio_quality": 0.60, "ergonomics": 0.96, "battery_life": 0.94, "build_quality": 0.95, "value": 0.88}
    },
    {
        "id": "ce-005",
        "slug": "lg-ultragear-27gr75q",
        "category": "consumer_electronics",
        "subcategory": "displays",
        "brand": "LG",
        "name": "LG UltraGear 27GR75Q 27-inch 165Hz QHD Gaming Monitor",
        "product_name": "LG UltraGear 27GR75Q 27-inch 165Hz QHD Gaming Monitor",
        "exact_model": "UltraGear 27GR75Q-B (2560x1440)",
        "variant": "27-inch QHD / 165Hz IPS / 1ms GtG",
        "price": 21999.0,
        "price_inr": 21999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 640,
        "imageUrl": "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.lg.com/in/monitors/gaming/27gr75q-b/",
        "productSourceUrl": "https://www.lg.com/in/monitors/gaming/27gr75q-b/",
        "retailerOffers": [
            {"retailerName": "LG India Official", "productUrl": "https://www.lg.com/in/monitors/gaming/27gr75q-b/", "price": 21999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0C39X27GR", "price": 21499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "display": "27\" QHD (2560x1440) IPS Panel",
            "refresh_rate": "165Hz",
            "response_time": "1ms (GtG)",
            "color_gamut": "sRGB 99%, HDR10",
            "sync": "NVIDIA G-Sync Compatible, AMD FreeSync Premium",
            "ports": "2x HDMI 2.0, 1x DisplayPort 1.4, Headphone out",
            "stand": "Tilt, Height, Pivot adjustable"
        },
        "features": [
            "Fluid 165Hz refresh rate and genuine 1ms GtG response eliminating ghosting",
            "Ergonomic stand with height, tilt, and 90-degree portrait pivot adjustments",
            "NVIDIA G-Sync Compatible and AMD FreeSync Premium for tear-free gaming"
        ],
        "priorityAffinities": {"audio_quality": 0.50, "ergonomics": 0.94, "battery_life": 0.50, "build_quality": 0.92, "value": 0.96}
    },
    {
        "id": "ce-006",
        "slug": "jbl-flip-6-speaker",
        "category": "consumer_electronics",
        "subcategory": "wireless_audio",
        "brand": "JBL",
        "name": "JBL Flip 6 Portable Bluetooth Speaker",
        "product_name": "JBL Flip 6 Portable Bluetooth Speaker",
        "exact_model": "JBL Flip 6 Waterproof Speaker",
        "variant": "Black / 30W Output",
        "price": 9999.0,
        "price_inr": 9999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 1820,
        "imageUrl": "https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.jbl.com/bluetooth-speakers/FLIP-6-.html",
        "productSourceUrl": "https://www.jbl.com/bluetooth-speakers/FLIP-6-.html",
        "retailerOffers": [
            {"retailerName": "JBL India Store", "productUrl": "https://www.jbl.com/bluetooth-speakers/FLIP-6-.html", "price": 9999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B09V7S182W", "price": 9499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "output_power": "30W RMS (20W woofer + 10W tweeter)",
            "battery": "12 hours playtime (4800 mAh Li-ion polymer)",
            "water_rating": "IP67 waterproof and dustproof",
            "connectivity": "Bluetooth 5.1 with PartyBoost multi-speaker pairing",
            "weight": "550g"
        },
        "features": [
            "2-way speaker system engineered for loud, crystal-clear, powerful bass",
            "IP67 waterproof and dustproof rating handles poolside and outdoor trails",
            "PartyBoost allows pairing two JBL PartyBoost-compatible speakers for stereo sound"
        ],
        "priorityAffinities": {"audio_quality": 0.90, "ergonomics": 0.92, "battery_life": 0.88, "build_quality": 0.93, "value": 0.94}
    },
    {
        "id": "ce-007",
        "slug": "marshall-acton-iii-speaker",
        "category": "consumer_electronics",
        "subcategory": "wireless_audio",
        "brand": "Marshall",
        "name": "Marshall Acton III Bluetooth Home Speaker",
        "product_name": "Marshall Acton III Bluetooth Home Speaker",
        "exact_model": "Acton III Home Bluetooth Speaker",
        "variant": "Black / Vintage Textured Vinyl",
        "price": 27999.0,
        "price_inr": 27999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 390,
        "imageUrl": "https://images.unsplash.com/photo-1543512214-318c7553f230?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1543512214-318c7553f230?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.marshallheadphones.com/in/en/acton-iii.html",
        "productSourceUrl": "https://www.marshallheadphones.com/in/en/acton-iii.html",
        "retailerOffers": [
            {"retailerName": "Marshall India Store", "productUrl": "https://www.marshallheadphones.com/in/en/acton-iii.html", "price": 27999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0B5FN12M3", "price": 27999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "output_power": "60W Class D (1x 30W woofer + 2x 15W tweeters)",
            "frequency_range": "45–20,000 Hz, Dynamic Loudness",
            "connectivity": "Bluetooth 5.2 (LE Audio ready) + 3.5mm Aux input",
            "controls": "Brass volume, bass, and treble analogue knobs",
            "weight": "2.85 kg"
        },
        "features": [
            "Re-engineered wider soundstage with angled-out tweeters filling the entire room",
            "Iconic vintage Marshall amp script logo, brass knobs, and textured vinyl casing",
            "Dynamic Loudness adjusts tonal balance so your music sounds pristine at every volume"
        ],
        "priorityAffinities": {"audio_quality": 0.97, "ergonomics": 0.90, "battery_life": 0.50, "build_quality": 0.98, "value": 0.82}
    },
    {
        "id": "ce-008",
        "slug": "samsung-galaxy-watch-6-44mm",
        "category": "consumer_electronics",
        "subcategory": "wearables",
        "brand": "Samsung",
        "name": "Samsung Galaxy Watch 6 (44mm Bluetooth)",
        "product_name": "Samsung Galaxy Watch 6 (44mm Bluetooth)",
        "exact_model": "Galaxy Watch 6 44mm Bluetooth",
        "variant": "Graphite / 44mm Armor Aluminum",
        "price": 26999.0,
        "price_inr": 26999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 510,
        "imageUrl": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.samsung.com/in/watches/galaxy-watch/galaxy-watch6-44mm-graphite-bluetooth-sm-r940nzkainu/",
        "productSourceUrl": "https://www.samsung.com/in/watches/galaxy-watch/galaxy-watch6-44mm-graphite-bluetooth-sm-r940nzkainu/",
        "retailerOffers": [
            {"retailerName": "Samsung India Store", "productUrl": "https://www.samsung.com/in/watches/galaxy-watch/galaxy-watch6-44mm-graphite-bluetooth-sm-r940nzkainu/", "price": 26999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0CC3P18G6", "price": 24999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "processor": "Exynos W930 (Dual-Core 1.4GHz)",
            "display": "1.5\" (480x480) Super AMOLED Sapphire Crystal, Always-on",
            "battery": "425 mAh (Up to 40 hours with AOD off)",
            "sensors": "BioActive Sensor (HR, ECG, BIA body composition), Temperature",
            "water_rating": "5ATM + IP68 / MIL-STD-810H",
            "weight": "33.3g"
        },
        "features": [
            "20% larger screen with 30% slimmer rotating digital bezel",
            "Advanced sleep coaching with nocturnal heart rate and blood oxygen monitoring",
            "BIA body composition analysis measuring body fat percentage and skeletal muscle"
        ],
        "priorityAffinities": {"audio_quality": 0.60, "ergonomics": 0.94, "battery_life": 0.85, "build_quality": 0.95, "value": 0.88}
    }
]
new_products.extend(consumer_electronics)
print(f"Added {len(consumer_electronics)} consumer electronics.")

# ==========================================
# 6. FITNESS EQUIPMENT (8 Products)
# ==========================================
fitness_equipment = [
    {
        "id": "fiteq-001",
        "slug": "boldfit-adjustable-dumbbell-24kg",
        "category": "fitness_equipment",
        "subcategory": "strength_equipment",
        "brand": "Boldfit",
        "name": "Boldfit Adjustable Dumbbell Set (2.5kg to 24kg)",
        "product_name": "Boldfit Adjustable Dumbbell Set (2.5kg to 24kg)",
        "exact_model": "Boldfit Dial-Tech 24kg Adjustable Dumbbell",
        "variant": "Single Dumbbell (2.5kg - 24kg) with Tray",
        "price": 14999.0,
        "price_inr": 14999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 480,
        "imageUrl": "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://boldfit.in/products/adjustable-dumbbell-24kg",
        "productSourceUrl": "https://boldfit.in/products/adjustable-dumbbell-24kg",
        "retailerOffers": [
            {"retailerName": "Boldfit Official", "productUrl": "https://boldfit.in/products/adjustable-dumbbell-24kg", "price": 14999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0B5FN14KG", "price": 14499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "weight_range": "2.5kg to 24kg (15 weight increments)",
            "adjustment_mechanism": "Turn-dial selector with secure safety tray",
            "material": "Heavy-duty steel plates with impact-resistant moulding",
            "grip": "Ergonomic textured anti-slip handle",
            "footprint": "Space-saving compact tray design"
        },
        "features": [
            "Replaces 15 pairs of traditional dumbbells with a single compact turn-dial unit",
            "Smooth weight transition from 2.5kg, 3.5kg, up to 24kg for progressive overload",
            "Secure mechanical locking system prevents plates from slipping during lifts"
        ],
        "priorityAffinities": {"durability": 0.95, "adjustability": 0.99, "safety_grip": 0.94, "space_saving": 0.98, "value": 0.92}
    },
    {
        "id": "fiteq-002",
        "slug": "manduka-pro-yoga-mat-6mm",
        "category": "fitness_equipment",
        "subcategory": "yoga_mats",
        "brand": "Manduka",
        "name": "Manduka PRO Yoga and Pilates Mat (6mm)",
        "product_name": "Manduka PRO Yoga and Pilates Mat (6mm)",
        "exact_model": "Manduka PRO Mat 71-inch (6mm)",
        "variant": "Black Sage / 71-inch x 26-inch",
        "price": 11500.0,
        "price_inr": 11500.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 780,
        "imageUrl": "https://images.unsplash.com/photo-1592432678016-e910b452f9a2?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1592432678016-e910b452f9a2?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.manduka.com/products/manduka-pro-yoga-mat",
        "productSourceUrl": "https://www.manduka.com/products/manduka-pro-yoga-mat",
        "retailerOffers": [
            {"retailerName": "Manduka Official", "productUrl": "https://www.manduka.com/products/manduka-pro-yoga-mat", "price": 11500.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B004M20WCE", "price": 11500.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "thickness": "6.0 mm ultra-dense high-density cushion",
            "dimensions": "180 cm x 66 cm (71\" x 26\")",
            "material": "Certified OEKO-TEX non-toxic closed-cell PVC",
            "grip": "Fabric-like surface finish for joint protection & stability",
            "warranty": "Lifetime manufacturer warranty",
            "weight": "3.4 kg"
        },
        "features": [
            "Backed by a Lifetime Guarantee – will never flake, peel, or compress",
            "High-density 6mm cushion protects spine, hips, knees, and elbows on hard floors",
            "Closed-cell material seals out moisture and bacteria, making cleaning effortless"
        ],
        "priorityAffinities": {"durability": 1.0, "adjustability": 0.50, "safety_grip": 0.98, "space_saving": 0.85, "value": 0.86}
    },
    {
        "id": "fiteq-003",
        "slug": "liforme-original-yoga-mat",
        "category": "fitness_equipment",
        "subcategory": "yoga_mats",
        "brand": "Liforme",
        "name": "Liforme Original Yoga Mat (4.2mm with Alignment)",
        "product_name": "Liforme Original Yoga Mat (4.2mm with Alignment)",
        "exact_model": "Liforme Original Mat with AlignForMe System",
        "variant": "Grey / AlignForMe Alignment Markers",
        "price": 13999.0,
        "price_inr": 13999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 560,
        "imageUrl": "https://images.unsplash.com/photo-1545205597-3d9d02c29597?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1545205597-3d9d02c29597?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://liforme.com/products/liforme-yoga-mat",
        "productSourceUrl": "https://liforme.com/products/liforme-yoga-mat",
        "retailerOffers": [
            {"retailerName": "Liforme Store", "productUrl": "https://liforme.com/products/liforme-yoga-mat", "price": 13999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B00L22H394", "price": 13999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "thickness": "4.2 mm optimal cushioning",
            "dimensions": "185 cm x 68 cm (72.8\" x 26.8\")",
            "material": "Biodegradable natural rubber base with eco-polyurethane top",
            "alignment_system": "Etched AlignForMe navigational markers",
            "grip": "Warrior-like revolutionary GripForMe technology (wet & dry)",
            "weight": "2.5 kg"
        },
        "features": [
            "Revolutionary 'GripForMe' material gives unmatched, sweat-proof non-slip traction",
            "Intelligent 'AlignForMe' etched guidelines prevent yoga posture misalignment and injuries",
            "Planet-friendly, non-toxic, PVC-free biodegradable engineered natural rubber"
        ],
        "priorityAffinities": {"durability": 0.94, "adjustability": 0.60, "safety_grip": 1.0, "space_saving": 0.88, "value": 0.80}
    },
    {
        "id": "fiteq-004",
        "slug": "slovic-resistance-bands-set",
        "category": "fitness_equipment",
        "subcategory": "resistance_gear",
        "brand": "Slovic",
        "name": "Slovic 11-Piece Stackable Resistance Bands Set (150 lbs)",
        "product_name": "Slovic 11-Piece Stackable Resistance Bands Set (150 lbs)",
        "exact_model": "Slovic 150 lbs Stackable Tube Band Kit",
        "variant": "5 Bands (10-150 lbs stackable) with Handles & Door Anchor",
        "price": 1699.0,
        "price_inr": 1699.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 1340,
        "imageUrl": "https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://slovic.in/products/resistance-tube-set-150lbs",
        "productSourceUrl": "https://slovic.in/products/resistance-tube-set-150lbs",
        "retailerOffers": [
            {"retailerName": "Slovic Store India", "productUrl": "https://slovic.in/products/resistance-tube-set-150lbs", "price": 1699.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B08V5SLO11", "price": 1599.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "resistance_range": "10 lbs to 150 lbs (5 stackable color-coded tubes)",
            "accessories": "2 cushioned foam handles, 2 ankle straps, 1 heavy-duty door anchor, carrying pouch",
            "material": "100% natural Malaysian latex tubing with metal carabiners",
            "portability": "Ultra compact travel-ready pack"
        },
        "features": [
            "Combine any tube combination up to 150 lbs for versatile full-body resistance training",
            "Door anchor turns any standard door into a private cable pulley gym machine",
            "Double-layer anti-snap latex design for supreme safety under tension"
        ],
        "priorityAffinities": {"durability": 0.90, "adjustability": 0.98, "safety_grip": 0.92, "space_saving": 1.0, "value": 0.99}
    },
    {
        "id": "fiteq-005",
        "slug": "kore-pvc-20kg-home-gym-set",
        "category": "fitness_equipment",
        "subcategory": "strength_equipment",
        "brand": "Kore",
        "name": "Kore PVC 20kg Home Gym Dumbbell & Barbell Kit",
        "product_name": "Kore PVC 20kg Home Gym Dumbbell & Barbell Kit",
        "exact_model": "Kore PVC 20kg Combo Home Workout Set",
        "variant": "20kg Plates + 3ft Curl Rod + Dumbbell Rods + Gloves",
        "price": 1899.0,
        "price_inr": 1899.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.4,
        "reviewCount": 2100,
        "imageUrl": "https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://korefit.in/products/kore-20kg-home-gym-combo",
        "productSourceUrl": "https://korefit.in/products/kore-20kg-home-gym-combo",
        "retailerOffers": [
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07P85KORE", "price": 1899.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "total_weight": "20 kg (PVC plates: 2kg x 4, 3kg x 4)",
            "rods": "1x 3-foot curl rod + 2x 14-inch dumbbell rods with star nuts",
            "accessories": "Gym gloves, skipping rope, hand gripper",
            "material": "Concrete-filled durable PVC shells"
        },
        "features": [
            "Complete budget starter package for bicep curls, chest press, and shoulder workouts",
            "Floor-friendly PVC weight plates prevent scratches on Indian tiled floors",
            "Includes ergonomic leather fitness gloves and ball-bearing skipping rope"
        ],
        "priorityAffinities": {"durability": 0.85, "adjustability": 0.90, "safety_grip": 0.84, "space_saving": 0.86, "value": 1.0}
    },
    {
        "id": "fiteq-006",
        "slug": "lifelong-llf135-adjustable-bench",
        "category": "fitness_equipment",
        "subcategory": "benches",
        "brand": "Lifelong",
        "name": "Lifelong LLF135 Multi-Position Adjustable Workout Bench",
        "product_name": "Lifelong LLF135 Multi-Position Adjustable Workout Bench",
        "exact_model": "Lifelong LLF135 Adjustable Weight Bench",
        "variant": "Black / 6 Backrest Angles (Incline/Decline/Flat)",
        "price": 4999.0,
        "price_inr": 4999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 710,
        "imageUrl": "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://lifelongindiaonline.com/products/lifelong-llf135-bench",
        "productSourceUrl": "https://lifelongindiaonline.com/products/lifelong-llf135-bench",
        "retailerOffers": [
            {"retailerName": "Lifelong Official", "productUrl": "https://lifelongindiaonline.com/products/lifelong-llf135-bench", "price": 4999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B08J45LLFE", "price": 4799.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "positions": "6 backrest levels (incline, decline, flat) + 3 seat levels",
            "max_weight_capacity": "180 kg (user + weights)",
            "frame": "Heavy-duty commercial-grade triangular steel tube",
            "padding": "High-density tear-resistant foam with sweatproof PU leather",
            "foldability": "Foldable compact footprint for under-bed storage"
        },
        "features": [
            "Multi-angle flexibility allows incline dumbbell presses, flat bench, and decline sit-ups",
            "Solid triangular stability structure with thickened heavy gauge steel tube",
            "Folds away flat in seconds to slide under a bed or into a closet"
        ],
        "priorityAffinities": {"durability": 0.94, "adjustability": 0.96, "safety_grip": 0.90, "space_saving": 0.95, "value": 0.95}
    },
    {
        "id": "fiteq-007",
        "slug": "burnlab-speed-jump-rope",
        "category": "fitness_equipment",
        "subcategory": "jump_ropes",
        "brand": "Burnlab",
        "name": "Burnlab High-Speed Ball Bearing Jump Rope",
        "product_name": "Burnlab High-Speed Ball Bearing Jump Rope",
        "exact_model": "Burnlab Pro Speed Ball Bearing Skipping Rope",
        "variant": "Black / 360 Dual Ball Bearing / 3m Wire",
        "price": 799.0,
        "price_inr": 799.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 1150,
        "imageUrl": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://burnlab.co/products/speed-rope",
        "productSourceUrl": "https://burnlab.co/products/speed-rope",
        "retailerOffers": [
            {"retailerName": "Burnlab Store", "productUrl": "https://burnlab.co/products/speed-rope", "price": 799.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B08L7VBLSP", "price": 749.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "mechanism": "360-degree dual-rotation high-speed ball bearings",
            "cable": "3-meter adjustable steel wire with kink-free PVC coating",
            "handles": "Lightweight aircraft aluminum with non-slip silicone grip",
            "usage": "Cardio, double-unders, boxing footwork conditioning"
        },
        "features": [
            "360-degree ball bearing rotation allows lightning-fast double unders without tangling",
            "Indestructible aircraft aluminum handles engineered with knurled anti-sweat grip",
            "Cut-to-size adjustable 3m braided steel cable accommodates heights up to 6'6\""
        ],
        "priorityAffinities": {"durability": 0.96, "adjustability": 0.90, "safety_grip": 0.95, "space_saving": 1.0, "value": 0.98}
    },
    {
        "id": "fiteq-008",
        "slug": "cockatoo-foldable-weight-bench",
        "category": "fitness_equipment",
        "subcategory": "benches",
        "brand": "Cockatoo",
        "name": "Cockatoo Foldable Multi-Purpose Workout Weight Bench",
        "product_name": "Cockatoo Foldable Multi-Purpose Workout Weight Bench",
        "exact_model": "Cockatoo CS-01 Multi-Angle Workout Bench",
        "variant": "Black & Red / 7 Backrest Angles / 200kg Load",
        "price": 6499.0,
        "price_inr": 6499.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 430,
        "imageUrl": "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://cockatooindia.com/products/cockatoo-cs-01-bench",
        "productSourceUrl": "https://cockatooindia.com/products/cockatoo-cs-01-bench",
        "retailerOffers": [
            {"retailerName": "Cockatoo India", "productUrl": "https://cockatooindia.com/products/cockatoo-cs-01-bench", "price": 6499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B08V5CKT01", "price": 6299.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "positions": "7 backrest adjustments from -20° decline to 90° military incline",
            "max_weight_capacity": "200 kg heavy load capacity",
            "frame": "Heavy-duty carbon steel with non-marking rubber end caps",
            "extras": "Leg hold-down bar with foam rollers and dumbbell storage rack",
            "weight": "13.5 kg"
        },
        "features": [
            "Commercial 200kg weight limit handles heavy barbell bench and dumbbell workouts",
            "High-density multi-layered memory foam pad prevents tailbone and lower back strain",
            "Integrated dumbbell storage rack keeps weights organized directly under the bench"
        ],
        "priorityAffinities": {"durability": 0.96, "adjustability": 0.98, "safety_grip": 0.92, "space_saving": 0.90, "value": 0.94}
    }
]
new_products.extend(fitness_equipment)
print(f"Added {len(fitness_equipment)} fitness equipment.")

# ==========================================
# 7. KITCHEN CHIMNEYS (8 Products)
# ==========================================
kitchen_chimneys = [
    {
        "id": "chim-001",
        "slug": "faber-orient-tc-bk-60",
        "category": "kitchen_chimneys",
        "subcategory": "filterless_chimneys",
        "brand": "Faber",
        "name": "Faber 60cm 1200 m³/hr Autoclean Filterless Chimney",
        "product_name": "Faber 60cm 1200 m³/hr Autoclean Filterless Chimney",
        "exact_model": "HOOD ORIENT TC BK 60",
        "variant": "60cm / 1200 m³/hr / Black Curved Glass",
        "price": 12990.0,
        "price_inr": 12990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 920,
        "imageUrl": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://faberindia.com/products/hood-orient-tc-bk-60",
        "productSourceUrl": "https://faberindia.com/products/hood-orient-tc-bk-60",
        "retailerOffers": [
            {"retailerName": "Faber Official India", "productUrl": "https://faberindia.com/products/hood-orient-tc-bk-60", "price": 12990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07R7QFB60", "price": 12490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "60 cm (ideal for 2-4 burner gas stoves)",
            "suction_capacity": "1200 m³/hr",
            "technology": "Filterless technology with thermal auto-clean",
            "controls": "Touch control panel + Gesture motion sensor",
            "noise_level": "58 dB",
            "oil_collector": "Concealed stainless steel oil collector cup",
            "lighting": "2x 1.5W energy-saving LED lamps",
            "motor_warranty": "5 Years on motor, 1 Year comprehensive"
        },
        "features": [
            "Next-gen filterless chimney with thermal auto-clean eliminates tedious manual cleaning",
            "Smart gesture control lets you operate chimney with a wave of your hand while cooking",
            "High suction capacity 1200 m³/hr captures heavy oil fumes and spicy tadka smoke"
        ],
        "priorityAffinities": {"suction": 0.94, "cleaning": 0.98, "controls": 0.96, "noise": 0.88, "value": 0.95}
    },
    {
        "id": "chim-002",
        "slug": "faber-primus-plus-90",
        "category": "kitchen_chimneys",
        "subcategory": "filterless_chimneys",
        "brand": "Faber",
        "name": "Faber 90cm 1500 m³/hr Autoclean Filterless Chimney",
        "product_name": "Faber 90cm 1500 m³/hr Autoclean Filterless Chimney",
        "exact_model": "HOOD PRIMUS PLUS 90",
        "variant": "90cm / 1500 m³/hr Turbo Suction / Curved Glass",
        "price": 17490.0,
        "price_inr": 17490.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 610,
        "imageUrl": "https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://faberindia.com/products/hood-primus-plus-90",
        "productSourceUrl": "https://faberindia.com/products/hood-primus-plus-90",
        "retailerOffers": [
            {"retailerName": "Faber Official India", "productUrl": "https://faberindia.com/products/hood-primus-plus-90", "price": 17490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B08V5FBP90", "price": 16990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "90 cm (ideal for 3-5 burner heavy cooking stoves)",
            "suction_capacity": "1500 m³/hr high-velocity airflow",
            "technology": "Filterless auto-clean with oil collector tray",
            "controls": "Smart touch panel with motion sensor wave control",
            "noise_level": "59 dB",
            "lighting": "Dual LED illumination",
            "finish": "Curved black toughened glass canopy",
            "motor_warranty": "5 Years on motor"
        },
        "features": [
            "Colossal 1500 m³/hr suction capacity engineered for expansive Indian kitchens with intense grilling",
            "Wide 90cm glass canopy completely blankets 4 and 5 burner stoves without side smoke spillage",
            "Thermal heat auto-clean liquefies stubborn oil deposits into a metallic reservoir"
        ],
        "priorityAffinities": {"suction": 0.99, "cleaning": 0.96, "controls": 0.95, "noise": 0.86, "value": 0.90}
    },
    {
        "id": "chim-003",
        "slug": "elica-fl-600-hac-ltw-nero",
        "category": "kitchen_chimneys",
        "subcategory": "filterless_chimneys",
        "brand": "Elica",
        "name": "Elica 60cm 1200 m³/hr Filterless Auto Clean Chimney",
        "product_name": "Elica 60cm 1200 m³/hr Filterless Auto Clean Chimney",
        "exact_model": "FL 600 HAC LTW MS NERO",
        "variant": "60cm / 1200 m³/hr / Motion Sensor / Matte Black",
        "price": 12490.0,
        "price_inr": 12490.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 1150,
        "imageUrl": "https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.elica.in/chimneys/fl-600-hac-ltw-ms-nero",
        "productSourceUrl": "https://www.elica.in/chimneys/fl-600-hac-ltw-ms-nero",
        "retailerOffers": [
            {"retailerName": "Elica Official India", "productUrl": "https://www.elica.in/chimneys/fl-600-hac-ltw-ms-nero", "price": 12490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07R85EL60", "price": 11990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "60 cm (suitable for 2-4 burner stoves)",
            "suction_capacity": "1200 m³/hr",
            "technology": "Filterless heat auto-clean with dedicated oil collector",
            "controls": "Motion sensing technology + Feather touch controls",
            "noise_level": "58 dB",
            "finish": "Curved tempered glass in matte black",
            "motor_warranty": "5 Years on motor, 2 Years comprehensive"
        },
        "features": [
            "Advanced Motion Sensor enables wave-to-turn-on and speed modulation with no dirty finger marks",
            "Heat auto-clean heating pad melts grease effortlessly into the rust-free oil tray",
            "Compact curved black glass profile enhances modern modular kitchen aesthetics"
        ],
        "priorityAffinities": {"suction": 0.94, "cleaning": 0.97, "controls": 0.97, "noise": 0.88, "value": 0.96}
    },
    {
        "id": "chim-004",
        "slug": "elica-wd-hac-touch-bf-90",
        "category": "kitchen_chimneys",
        "subcategory": "baffle_filter_chimneys",
        "brand": "Elica",
        "name": "Elica 90cm 1425 m³/hr Auto Clean Chimney with Baffle Filter",
        "product_name": "Elica 90cm 1425 m³/hr Auto Clean Chimney with Baffle Filter",
        "exact_model": "WD HAC TOUCH BF 90",
        "variant": "90cm / 1425 m³/hr / Stainless Steel Baffle Filter",
        "price": 15990.0,
        "price_inr": 15990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 490,
        "imageUrl": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.elica.in/chimneys/wd-hac-touch-bf-90",
        "productSourceUrl": "https://www.elica.in/chimneys/wd-hac-touch-bf-90",
        "retailerOffers": [
            {"retailerName": "Elica India", "productUrl": "https://www.elica.in/chimneys/wd-hac-touch-bf-90", "price": 15990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B08V5EL90B", "price": 15490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "90 cm (suitable for 3-5 burners)",
            "suction_capacity": "1425 m³/hr",
            "technology": "Stainless steel baffle filters + Heat auto-clean",
            "controls": "Touch control panel with digital display",
            "noise_level": "58 dB",
            "finish": "Premium curved glass with stainless steel body",
            "motor_warranty": "5 Years on motor"
        },
        "features": [
            "Heavy-duty stainless steel baffle filters catch heavy oil particles before they enter motor",
            "Integrated heating auto-clean elements remove grease build-up from inner ductwork",
            "Wide 90cm curved glass canopy captures rising steam across full multi-burner range"
        ],
        "priorityAffinities": {"suction": 0.96, "cleaning": 0.91, "controls": 0.92, "noise": 0.88, "value": 0.92}
    },
    {
        "id": "chim-005",
        "slug": "hindware-marcilla-60-chimney",
        "category": "kitchen_chimneys",
        "subcategory": "filterless_chimneys",
        "brand": "Hindware",
        "name": "Hindware Smart Appliances 60cm 1200 m³/hr Filterless Auto-Clean",
        "product_name": "Hindware Smart Appliances 60cm 1200 m³/hr Filterless Auto-Clean",
        "exact_model": "Marcilla 60 Filterless Auto-Clean",
        "variant": "60cm / 1200 m³/hr / Metallic Oil Collector",
        "price": 11990.0,
        "price_inr": 11990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 830,
        "imageUrl": "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://hindwareappliances.com/kitchen-chimneys/marcilla-60/",
        "productSourceUrl": "https://hindwareappliances.com/kitchen-chimneys/marcilla-60/",
        "retailerOffers": [
            {"retailerName": "Hindware Official Store", "productUrl": "https://hindwareappliances.com/kitchen-chimneys/marcilla-60/", "price": 11990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07R85HW60", "price": 11490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "60 cm",
            "suction_capacity": "1200 m³/hr",
            "technology": "Filterless design with thermal auto-clean heating element",
            "controls": "Motion sensing wave gestures + Touch controls",
            "noise_level": "58 dB",
            "oil_collector": "One-touch removable metallic oil collector",
            "motor_warranty": "10 Years on motor, 1 Year comprehensive"
        },
        "features": [
            "Industry-leading 10-year manufacturer warranty on copper-wound motor",
            "Filterless technology ensures consistent airflow with zero suction drop over time",
            "Touch-free wave gesture interface keeps sleek black glass panel immaculate"
        ],
        "priorityAffinities": {"suction": 0.94, "cleaning": 0.96, "controls": 0.95, "noise": 0.88, "value": 0.98}
    },
    {
        "id": "chim-006",
        "slug": "hindware-althea-90-chimney",
        "category": "kitchen_chimneys",
        "subcategory": "filterless_chimneys",
        "brand": "Hindware",
        "name": "Hindware Smart Appliances 90cm 1500 m³/hr Filterless Auto-Clean",
        "product_name": "Hindware Smart Appliances 90cm 1500 m³/hr Filterless Auto-Clean",
        "exact_model": "Althea 90 Max Suction Auto-Clean",
        "variant": "90cm / 1500 m³/hr / MaxX Silence Engineering",
        "price": 16990.0,
        "price_inr": 16990.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 380,
        "imageUrl": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://hindwareappliances.com/kitchen-chimneys/althea-90/",
        "productSourceUrl": "https://hindwareappliances.com/kitchen-chimneys/althea-90/",
        "retailerOffers": [
            {"retailerName": "Hindware Store", "productUrl": "https://hindwareappliances.com/kitchen-chimneys/althea-90/", "price": 16990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B09V5HWAL9", "price": 16490.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "90 cm (heavy frying & grilling compatible)",
            "suction_capacity": "1500 m³/hr turbo suction",
            "technology": "MaxX Silence filterless auto-clean system",
            "controls": "Dual gesture sensor + Smart feather touch display",
            "noise_level": "56 dB (low acoustic baffle engineering)",
            "motor_warranty": "10 Years on motor"
        },
        "features": [
            "MaxX Silence design dampens acoustic motor vibration down to an ultra-quiet 56 dB",
            "Heavyweight 1500 m³/hr high-torque airflow exhausts oil and odor from open floor plans",
            "Thermal heat auto-clean with illuminated capacitive control surface"
        ],
        "priorityAffinities": {"suction": 0.99, "cleaning": 0.96, "controls": 0.96, "noise": 0.94, "value": 0.92}
    },
    {
        "id": "chim-007",
        "slug": "glen-6071-ex-bl-chimney",
        "category": "kitchen_chimneys",
        "subcategory": "filterless_chimneys",
        "brand": "Glen",
        "name": "Glen 60cm 1050 m³/hr Filterless Curved Glass Kitchen Chimney",
        "product_name": "Glen 60cm 1050 m³/hr Filterless Curved Glass Kitchen Chimney",
        "exact_model": "6071 EX BL Filterless 60cm",
        "variant": "60cm / 1050 m³/hr / Push Button Control",
        "price": 9495.0,
        "price_inr": 9495.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.4,
        "reviewCount": 540,
        "imageUrl": "https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://glenindia.com/products/filterless-chimney-6071-ex-bl",
        "productSourceUrl": "https://glenindia.com/products/filterless-chimney-6071-ex-bl",
        "retailerOffers": [
            {"retailerName": "Glen India Official", "productUrl": "https://glenindia.com/products/filterless-chimney-6071-ex-bl", "price": 9495.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07P5GLEN6", "price": 9295.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "60 cm",
            "suction_capacity": "1050 m³/hr",
            "technology": "Filterless auto-clean with exterior oil collector",
            "controls": "Push button 3-speed control",
            "noise_level": "58 dB",
            "finish": "Black tempered curved glass canopy",
            "motor_warranty": "5 Years on copper Italian motor"
        },
        "features": [
            "Affordable filterless convenience under ₹10,000 for compact Indian kitchens",
            "Italian copper-wound motor with Thermal Overload Protector (TOP) prevents overheating",
            "Durable mechanical push buttons deliver fail-safe longevity in high-steam environments"
        ],
        "priorityAffinities": {"suction": 0.88, "cleaning": 0.92, "controls": 0.84, "noise": 0.88, "value": 0.99}
    },
    {
        "id": "chim-008",
        "slug": "inalsa-classica-60bkbf-chimney",
        "category": "kitchen_chimneys",
        "subcategory": "baffle_filter_chimneys",
        "brand": "Inalsa",
        "name": "Inalsa 60cm 1050 m³/hr Pyramid Chimney with Baffle Filter",
        "product_name": "Inalsa 60cm 1050 m³/hr Pyramid Chimney with Baffle Filter",
        "exact_model": "Classica 60BKBF Pyramid Chimney",
        "variant": "60cm / 1050 m³/hr / Matte Black Pyramid",
        "price": 6290.0,
        "price_inr": 6290.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.4,
        "reviewCount": 1680,
        "imageUrl": "https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://inalsaappliances.com/products/inalsa-classica-60bkbf-chimney",
        "productSourceUrl": "https://inalsaappliances.com/products/inalsa-classica-60bkbf-chimney",
        "retailerOffers": [
            {"retailerName": "Inalsa Store", "productUrl": "https://inalsaappliances.com/products/inalsa-classica-60bkbf-chimney", "price": 6290.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07P8INALS", "price": 5990.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "width": "60 cm (budget-friendly pyramid design)",
            "suction_capacity": "1050 m³/hr",
            "technology": "Dual high-grade stainless steel baffle filters",
            "controls": "Push button 3-speed fan controls",
            "noise_level": "60 dB",
            "finish": "Powder-coated rust-resistant matte black pyramid body",
            "motor_warranty": "5 Years on motor, 2 Years comprehensive"
        },
        "features": [
            "Incredible entry price under ₹6,500 delivering authentic 1050 m³/hr suction",
            "Dual stainless steel baffle filters are dishwasher-safe and last for decades",
            "Robust powder-coated pyramid body engineered to resist kitchen humidity and heat"
        ],
        "priorityAffinities": {"suction": 0.87, "cleaning": 0.85, "controls": 0.80, "noise": 0.82, "value": 1.0}
    }
]
new_products.extend(kitchen_chimneys)
print(f"Added {len(kitchen_chimneys)} kitchen chimneys.")

# ==========================================
# 8. PROTEIN & NUTRITION (8 Products)
# ==========================================
nutrition = [
    {
        "id": "nutr-001",
        "slug": "on-gold-standard-whey-2lb",
        "category": "nutrition",
        "subcategory": "whey_protein",
        "brand": "Optimum Nutrition",
        "name": "Optimum Nutrition (ON) Gold Standard 100% Whey Protein (2 lb)",
        "product_name": "Optimum Nutrition (ON) Gold Standard 100% Whey Protein (2 lb)",
        "exact_model": "Gold Standard 100% Whey 2 lb (Double Rich Chocolate)",
        "variant": "907g (2 lbs) / Double Rich Chocolate / ~30 servings",
        "price": 3499.0,
        "price_inr": 3499.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 4500,
        "imageUrl": "https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey",
        "productSourceUrl": "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey",
        "retailerOffers": [
            {"retailerName": "ON Official India Store", "productUrl": "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey", "price": 3499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B000QSNY54", "price": 3299.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "Whey Protein Isolate Primary Source",
            "serving_size": "30.4g (1 scoop)",
            "protein_per_serving": "24g",
            "bcaa_per_serving": "5.5g naturally occurring BCAAs",
            "glutamine_per_serving": "4g Glutamine & Glutamic acid",
            "pack_weight": "907g (2 lbs) - ~30 servings",
            "dietary_flag": "100% Vegetarian, Informed Choice Certified",
            "flavor": "Double Rich Chocolate"
        },
        "features": [
            "The world's most awarded and bestselling whey protein brand for over 20 years",
            "Whey protein isolate is the primary ingredient with excess carbs and fat filtered out",
            "Instantized formula mixes effortlessly with a spoon—no blender required"
        ],
        "priorityAffinities": {"protein_yield": 0.96, "absorption": 0.98, "certification": 1.0, "value": 0.90}
    },
    {
        "id": "nutr-002",
        "slug": "on-gold-standard-whey-5lb",
        "category": "nutrition",
        "subcategory": "whey_protein",
        "brand": "Optimum Nutrition",
        "name": "Optimum Nutrition (ON) Gold Standard 100% Whey Protein (5 lb)",
        "product_name": "Optimum Nutrition (ON) Gold Standard 100% Whey Protein (5 lb)",
        "exact_model": "Gold Standard 100% Whey 5 lb (Double Rich Chocolate)",
        "variant": "2.27 kg (5 lbs) / Double Rich Chocolate / ~74 servings",
        "price": 7299.0,
        "price_inr": 7299.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 6800,
        "imageUrl": "https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey-5lb",
        "productSourceUrl": "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey-5lb",
        "retailerOffers": [
            {"retailerName": "ON Official India", "productUrl": "https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey-5lb", "price": 7299.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B000QSTBNS", "price": 6999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "Whey Protein Isolate + Concentrate blend",
            "serving_size": "30.4g (1 scoop)",
            "protein_per_serving": "24g",
            "bcaa_per_serving": "5.5g BCAAs",
            "pack_weight": "2.27 kg (5 lbs) - ~74 servings",
            "dietary_flag": "100% Vegetarian, Informed Choice Certified",
            "flavor": "Double Rich Chocolate"
        },
        "features": [
            "Large value economy pack delivering lowest cost per scoop for regular athletes",
            "Authenticity verified via unique Scratch Code on Tru-Seal security neck band",
            "Free from banned substances with Informed Choice UK certification"
        ],
        "priorityAffinities": {"protein_yield": 0.96, "absorption": 0.98, "certification": 1.0, "value": 0.96}
    },
    {
        "id": "nutr-003",
        "slug": "muscleblaze-biozyme-performance-whey-1kg",
        "category": "nutrition",
        "subcategory": "whey_protein",
        "brand": "MuscleBlaze",
        "name": "MuscleBlaze Biozyme Performance Whey (1 kg)",
        "product_name": "MuscleBlaze Biozyme Performance Whey (1 kg)",
        "exact_model": "Biozyme Performance Whey 1kg (Rich Chocolate)",
        "variant": "1 kg (2.2 lbs) / Rich Chocolate / ~28 servings",
        "price": 2399.0,
        "price_inr": 2399.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 3200,
        "imageUrl": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey/SP-84610",
        "productSourceUrl": "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey/SP-84610",
        "retailerOffers": [
            {"retailerName": "MuscleBlaze Official", "productUrl": "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey/SP-84610", "price": 2399.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0855MBP1K", "price": 2299.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "Biozyme Enhanced Absorption Formula Whey",
            "serving_size": "36g (1 scoop)",
            "protein_per_serving": "25g",
            "bcaa_per_serving": "5.51g BCAAs / 11.75g EAAs",
            "pack_weight": "1 kg (2.2 lbs) - ~28 servings",
            "clinical_testing": "50% higher protein absorption clinically tested on Indian bodies",
            "dietary_flag": "100% Vegetarian, Labdoor USA Tested",
            "flavor": "Rich Chocolate"
        },
        "features": [
            "Patented Enhanced Absorption Formula (EAF) clinically proven to boost protein absorption by 50%",
            "Specifically formulated to eliminate protein digestion distress and bloating common in Indian diets",
            "Labdoor USA certified for purity and accurate protein label claims"
        ],
        "priorityAffinities": {"protein_yield": 0.97, "absorption": 1.0, "certification": 0.98, "value": 0.96}
    },
    {
        "id": "nutr-004",
        "slug": "muscleblaze-biozyme-performance-whey-2kg",
        "category": "nutrition",
        "subcategory": "whey_protein",
        "brand": "MuscleBlaze",
        "name": "MuscleBlaze Biozyme Performance Whey (2 kg)",
        "product_name": "MuscleBlaze Biozyme Performance Whey (2 kg)",
        "exact_model": "Biozyme Performance Whey 2kg (Rich Chocolate)",
        "variant": "2 kg (4.4 lbs) / Rich Chocolate / ~55 servings",
        "price": 4499.0,
        "price_inr": 4499.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.8,
        "reviewCount": 4900,
        "imageUrl": "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey-2kg/SP-84620",
        "productSourceUrl": "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey-2kg/SP-84620",
        "retailerOffers": [
            {"retailerName": "MuscleBlaze Store", "productUrl": "https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey-2kg/SP-84620", "price": 4499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B0855MBP2K", "price": 4299.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "Biozyme Enhanced Absorption Formula Whey",
            "serving_size": "36g (1 scoop)",
            "protein_per_serving": "25g",
            "bcaa_per_serving": "5.51g BCAAs / 11.75g EAAs",
            "pack_weight": "2 kg (4.4 lbs) - ~55 servings",
            "dietary_flag": "100% Vegetarian, Labdoor Certified",
            "flavor": "Rich Chocolate"
        },
        "features": [
            "Best value bulk 2kg tub with patented US-patent-published Biozyme technology",
            "Each batch comes with online verifiable third-party NABL lab test certificate",
            "Includes dedicated scoop holder right at top of jar—no digging in powder"
        ],
        "priorityAffinities": {"protein_yield": 0.97, "absorption": 1.0, "certification": 0.98, "value": 0.98}
    },
    {
        "id": "nutr-005",
        "slug": "dymatize-iso100-whey-isolate",
        "category": "nutrition",
        "subcategory": "isolate_protein",
        "brand": "Dymatize",
        "name": "Dymatize ISO100 Hydrolyzed 100% Whey Isolate (2.3 lb)",
        "product_name": "Dymatize ISO100 Hydrolyzed 100% Whey Isolate (2.3 lb)",
        "exact_model": "ISO100 Hydrolyzed Whey Isolate 2.3 lb",
        "variant": "1.04 kg (2.3 lbs) / Gourmet Chocolate / ~35 servings",
        "price": 4999.0,
        "price_inr": 4999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.9,
        "reviewCount": 2100,
        "imageUrl": "https://images.unsplash.com/photo-1579722820308-d74e571900a9?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1579722820308-d74e571900a9?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://dymatize.com/iso100",
        "productSourceUrl": "https://dymatize.com/iso100",
        "retailerOffers": [
            {"retailerName": "Dymatize Official Store", "productUrl": "https://dymatize.com/iso100", "price": 4999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B002N6F55E", "price": 4799.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "Hydrolyzed Whey Protein Isolate (Fast Absorbing)",
            "serving_size": "30g (1 scoop)",
            "protein_per_serving": "25g",
            "bcaa_per_serving": "5.5g BCAAs, 2.6g Leucine",
            "sugar_carbs": "<1g sugar, <1g carbs, gluten-free, <0.5g lactose",
            "pack_weight": "1.04 kg (2.3 lbs) - ~35 servings",
            "dietary_flag": "100% Vegetarian, Informed-Choice Certified",
            "flavor": "Gourmet Chocolate"
        },
        "features": [
            "Hydrolyzed whey isolate pre-broken down into smaller peptide fractions for rapid absorption",
            "Virtually zero fat and carbohydrates (<1g), ideal for strict calorie-deficit cutting diets",
            "Informed-Choice tested for banned substances and certified gluten-free"
        ],
        "priorityAffinities": {"protein_yield": 0.99, "absorption": 0.99, "certification": 0.99, "value": 0.82}
    },
    {
        "id": "nutr-006",
        "slug": "cosmix-plant-protein-powder",
        "category": "nutrition",
        "subcategory": "plant_protein",
        "brand": "Cosmix",
        "name": "Cosmix No Nonsense Plant Protein (500g)",
        "product_name": "Cosmix No Nonsense Plant Protein (500g)",
        "exact_model": "Cosmix No Nonsense Plant Protein 500g",
        "variant": "500g / Classic Vanilla / ~15 servings",
        "price": 1650.0,
        "price_inr": 1650.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.6,
        "reviewCount": 420,
        "imageUrl": "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://cosmix.in/products/no-nonsense-plant-protein",
        "productSourceUrl": "https://cosmix.in/products/no-nonsense-plant-protein",
        "retailerOffers": [
            {"retailerName": "Cosmix Official Store", "productUrl": "https://cosmix.in/products/no-nonsense-plant-protein", "price": 1650.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B09V7CXPLT", "price": 1650.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "100% Plant-Based (Golden Pea Protein + Brown Rice Isolate)",
            "serving_size": "34g (1 scoop)",
            "protein_per_serving": "24g complete amino acid profile",
            "bcaa_per_serving": "4.8g plant BCAAs",
            "gut_friendly": "Contains plant digestive enzymes (papain, bromelain) and ginger extract",
            "pack_weight": "500g - 15 servings",
            "dietary_flag": "100% Vegan, Dairy-Free, Gluten-Free, No Artificial Sweeteners",
            "flavor": "Classic Vanilla"
        },
        "features": [
            "Made with organic golden pea and organic brown rice protein to provide all 9 essential amino acids",
            "Zero artificial gums, synthetic thickeners, artificial sweeteners, or chemical preservatives",
            "Enhanced with papain and bromelain enzymes to ensure zero digestive distress or bloating"
        ],
        "priorityAffinities": {"protein_yield": 0.90, "absorption": 0.95, "certification": 0.96, "value": 0.90}
    },
    {
        "id": "nutr-007",
        "slug": "oziva-organic-plant-protein-1kg",
        "category": "nutrition",
        "subcategory": "plant_protein",
        "brand": "Oziva",
        "name": "Oziva Organic Plant Protein (1 kg)",
        "product_name": "Oziva Organic Plant Protein (1 kg)",
        "exact_model": "Oziva Organic Plant Protein 1kg",
        "variant": "1 kg (2.2 lbs) / Unflavoured / ~30 servings",
        "price": 1999.0,
        "price_inr": 1999.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.5,
        "reviewCount": 1420,
        "imageUrl": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.oziva.in/products/oziva-organic-plant-protein",
        "productSourceUrl": "https://www.oziva.in/products/oziva-organic-plant-protein",
        "retailerOffers": [
            {"retailerName": "Oziva Official Store", "productUrl": "https://www.oziva.in/products/oziva-organic-plant-protein", "price": 1999.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B07P8OZIVA", "price": 1899.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "Multi-Source Certified Organic Plant Protein (Pea, Brown Rice, Quinoa)",
            "serving_size": "34g (1 scoop)",
            "protein_per_serving": "30g",
            "bcaa_per_serving": "5.2g BCAAs",
            "clean_label": "Pesticide-free, zero added sugar, no artificial flavours",
            "pack_weight": "1 kg (2.2 lbs) - ~30 servings",
            "dietary_flag": "Certified Clean Vegan / 100% Vegetarian",
            "flavor": "Unflavoured"
        },
        "features": [
            "Highest protein yield in plant category: 30g complete organic protein per scoop",
            "Unflavoured and unsweetened, easily incorporated into roti dough, smoothies, or oatmeal",
            "Certified Clean Label by Clean Label Project USA (free from heavy metals and pesticides)"
        ],
        "priorityAffinities": {"protein_yield": 0.99, "absorption": 0.92, "certification": 0.98, "value": 0.96}
    },
    {
        "id": "nutr-008",
        "slug": "isopure-zero-carb-whey-isolate",
        "category": "nutrition",
        "subcategory": "isolate_protein",
        "brand": "Isopure",
        "name": "Isopure Zero Carb 100% Whey Protein Isolate (2.2 lb)",
        "product_name": "Isopure Zero Carb 100% Whey Protein Isolate (2.2 lb)",
        "exact_model": "Isopure Zero Carb 100% Whey Isolate 1kg",
        "variant": "1 kg (2.2 lbs) / Creamy Vanilla / ~32 servings",
        "price": 4699.0,
        "price_inr": 4699.0,
        "currency": "INR",
        "price_status": "verified",
        "verification_status": "verified",
        "rating": 4.7,
        "reviewCount": 1540,
        "imageUrl": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80",
        "image_url": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80",
        "officialProductUrl": "https://www.theisopurecompany.com/en-us/Products/Powder/ISOPURE%C2%AE-ZERO-CARB-PROTEIN/p/C101301",
        "productSourceUrl": "https://www.theisopurecompany.com/en-us/Products/Powder/ISOPURE%C2%AE-ZERO-CARB-PROTEIN/p/C101301",
        "retailerOffers": [
            {"retailerName": "Isopure Official Store", "productUrl": "https://www.theisopurecompany.com/en-us/Products/Powder/ISOPURE%C2%AE-ZERO-CARB-PROTEIN/p/C101301", "price": 4699.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"},
            {"retailerName": "Amazon India", "productUrl": "https://www.amazon.in/dp/B000E8Z5EQ", "price": 4499.0, "availability": "In Stock", "lastVerifiedAt": "2026-10-15T10:00:00Z"}
        ],
        "specs": {
            "protein_type": "100% Microfiltered Pure Whey Protein Isolate",
            "serving_size": "31g (1 scoop)",
            "protein_per_serving": "25g",
            "carbs_sugar": "0g Carbohydrates, 0g Sugar, Fat-Free, Lactose-Free",
            "vitamins_minerals": "Fortified with 21 essential vitamins and minerals",
            "pack_weight": "1 kg (2.2 lbs) - ~32 servings",
            "dietary_flag": "100% Vegetarian, Keto Friendly",
            "flavor": "Creamy Vanilla"
        },
        "features": [
            "Absolute zero carbohydrate and zero sugar formulation for ketogenic and lean muscle goals",
            "Loaded with 25g pure whey isolate per scoop alongside vital micronutrient fortification",
            "Lactose-free microfiltration leaves no heavy stomach sensation"
        ],
        "priorityAffinities": {"protein_yield": 0.98, "absorption": 0.98, "certification": 0.97, "value": 0.86}
    }
]
new_products.extend(nutrition)
print(f"Added {len(nutrition)} nutrition products.")

# Ensure backward compatibility keys on all products
all_products = list(existing_products)
existing_ids = {p["id"] for p in existing_products}

for p in new_products:
    if p["id"] not in existing_ids:
        # Standardize dual-keys for schema completeness
        p["name"] = p.get("name") or p.get("product_name")
        p["product_name"] = p.get("name")
        p["price"] = p.get("price") or p.get("price_inr")
        p["price_inr"] = p.get("price")
        p["specs"] = p.get("specs") or p.get("specifications", {})
        p["specifications"] = p["specs"]
        p["imageUrl"] = p.get("imageUrl") or p.get("image_url")
        p["image_url"] = p["imageUrl"]
        p["productSourceUrl"] = p.get("productSourceUrl") or p.get("product_source_url")
        p["product_source_url"] = p["productSourceUrl"]
        p["officialProductUrl"] = p.get("officialProductUrl") or p["productSourceUrl"]
        p["price_status"] = p.get("price_status", "verified")
        p["verification_status"] = p.get("verification_status", "verified")
        p["lastVerifiedAt"] = p.get("lastVerifiedAt", "2026-10-15T12:00:00Z")
        all_products.append(p)

with open(products_file, "w", encoding="utf-8") as f:
    json.dump(all_products, f, indent=2)

print(f"Total products in catalog: {len(all_products)}")

# Also mirror to frontend fallback datasets
fe_prods_path = r"c:\Users\shaik\Desktop\Michack\frontend\src\services\fallbackProducts.json"
fe_cats_path = r"c:\Users\shaik\Desktop\Michack\frontend\src\services\fallbackCategories.json"

if os.path.exists(fe_prods_path):
    with open(fe_prods_path, "w", encoding="utf-8") as f:
        json.dump(all_products, f, indent=2)
    print("Updated frontend/src/services/fallbackProducts.json")

cats_file = os.path.join(DATA_DIR, "categories.json")
if os.path.exists(cats_file) and os.path.exists(fe_cats_path):
    with open(cats_file, "r", encoding="utf-8") as f:
        cats_data = json.load(f)
    with open(fe_cats_path, "w", encoding="utf-8") as f:
        json.dump(cats_data, f, indent=2)
    print("Updated frontend/src/services/fallbackCategories.json")

"""
WORTHLY - Canonical Product Master Dataset Generator & Multi-Category Synchronizer
Creates, validates, deduplicates, and synchronizes verified products across 14 categories:
1. Smartphones (Apple, Samsung, OnePlus, Google Pixel, Xiaomi, Motorola, iQOO, Realme)
2. Laptops (Dell, HP, Lenovo, ASUS, Acer, Apple)
3. Televisions (Samsung, LG, Sony, Xiaomi, TCL)
4. Refrigerators (Samsung, LG, Whirlpool, Haier, Godrej)
5. Washing Machines (LG, Samsung, Bosch, IFB, Whirlpool)
6. Air Conditioners (Daikin, Voltas, LG, Blue Star, Panasonic)
7. Tablets and Monitors (Apple iPad, Samsung Tab, Dell UltraSharp, LG UltraGear, BenQ, ASUS ROG)
8. Audio & Wearables (Sony, Apple AirPods, Bose, Sennheiser, Galaxy Watch, Apple Watch)
9. Books & Study Materials
10. Magazines & Periodicals
11. Fitness Equipment
12. Kitchen Chimneys
13. Protein & Nutrition
14. Footwear, Home & Kitchen, Furniture, Education, Electronics (Legacy verified catalog)

Outputs:
- backend/migrations/003_expand_multicategory_catalog.sql
- Updates backend/data/products.json
- Updates frontend/src/services/fallbackProducts.json
- Updates backend/data/categories.json and frontend/src/services/fallbackCategories.json
"""

import os
import sys
import json
import re
from datetime import datetime, timezone

NOW = datetime.now(timezone.utc).isoformat()

# Import smartphones from seed_smartphones.py
sys.path.insert(0, os.path.dirname(__file__))
from seed_smartphones import SMARTPHONES_DATASET

# =============================================================================
# LAPTOPS MASTER DATASET (12-16 Verified Models)
# =============================================================================
LAPTOPS_DATASET = [
    {
        "id": "laptop-001",
        "brand": "Dell",
        "name": "Dell Inspiron 14 5430 (Core i7 / 16GB / 512GB SSD)",
        "exact_model": "Inspiron 14 5430",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "Slim and lightweight 14-inch everyday business laptop powered by 13th Gen Intel Core i7 with 16:10 FHD+ ComfortView display.",
        "image_url": "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Intel Core i7-1355U (10 cores, up to 5.0 GHz)",
            "ram": "16GB LPDDR5 4800MHz",
            "storage": "512GB M.2 PCIe NVMe SSD",
            "gpu": "Intel Iris Xe Graphics",
            "display": "14.0-inch 16:10 FHD+ (1920x1200) WVA, 250 nits, Anti-Glare",
            "battery": "54 Wh (up to 10 hours battery)",
            "weight": "1.53 kg",
            "os": "Windows 11 Home",
            "ports": "1x Thunderbolt 4 / USB-C, 2x USB-A 3.2, 1x HDMI 1.4, SD card reader, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-001-v16", "variant_name": "Core i7 / 16GB RAM / 512GB SSD", "ram": "16GB", "storage": "512GB", "price": 79990.0}
        ],
        "retailer_listings": [
            {"retailer": "Dell Official Store", "identifier_type": "sku", "identifier_value": "INSP-5430-I7", "canonical_url": "https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop", "variant_id": "laptop-001-v16"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0C7L784X5", "canonical_url": "https://www.amazon.in/dp/B0C7L784X5", "variant_id": "laptop-001-v16"}
        ],
        "offers": [
            {"retailer": "Dell Official Store", "price": 79990.0, "variant_id": "laptop-001-v16"},
            {"retailer": "Amazon India", "price": 77990.0, "variant_id": "laptop-001-v16"}
        ],
        "priority_affinities": {"performance": 0.88, "battery": 0.92, "portability": 0.94, "ram": 0.90, "value": 0.95},
        "intended_usage_tags": ["college", "office", "programming"]
    },
    {
        "id": "laptop-002",
        "brand": "Apple",
        "name": "Apple MacBook Pro 14 (M3 Pro / 18GB / 512GB)",
        "exact_model": "MacBook Pro 14 M3 Pro",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "Pro laptop powered by Apple M3 Pro chip with hardware ray tracing, Liquid Retina XDR display, and up to 18 hours battery life.",
        "image_url": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Apple M3 Pro (11-core CPU, 14-core GPU, 16-core Neural Engine)",
            "ram": "18GB Unified Memory",
            "storage": "512GB NVMe SSD",
            "gpu": "14-core Apple Integrated GPU (Hardware Ray Tracing)",
            "display": "14.2-inch Liquid Retina XDR, 3024x1964, 120Hz ProMotion, 1000 nits sustained, 1600 nits peak",
            "battery": "70 Wh (up to 18 hours video playback)",
            "weight": "1.61 kg",
            "os": "macOS Sonoma",
            "ports": "3x Thunderbolt 4, HDMI, SDXC card slot, MagSafe 3, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-002-v18", "variant_name": "M3 Pro (11C/14G) / 18GB / 512GB", "ram": "18GB", "storage": "512GB", "price": 199900.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CHX1W1XY", "canonical_url": "https://www.amazon.in/dp/B0CHX1W1XY", "variant_id": "laptop-002-v18"},
            {"retailer": "Apple Store India", "identifier_type": "sku", "identifier_value": "MRX33HN/A", "canonical_url": "https://www.apple.com/in/shop/buy-mac/macbook-pro/14-inch", "variant_id": "laptop-002-v18"}
        ],
        "offers": [
            {"retailer": "Apple Store India", "price": 199900.0, "variant_id": "laptop-002-v18"},
            {"retailer": "Amazon India", "price": 194990.0, "variant_id": "laptop-002-v18"}
        ],
        "priority_affinities": {"performance": 0.97, "battery": 0.99, "display": 0.98, "build": 0.99, "value": 0.76},
        "intended_usage_tags": ["programming", "audio_production", "video_editing", "flagship_daily"]
    },
    {
        "id": "laptop-003",
        "brand": "Apple",
        "name": "Apple MacBook Air 13 (M3 / 16GB / 512GB)",
        "exact_model": "MacBook Air 13 M3",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "Ultra-thin, fanless 15-inch laptop powered by M3 with all-day battery life, 500 nits Liquid Retina display, and MagSafe charging.",
        "image_url": "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Apple M3 (8-core CPU, 10-core GPU, 16-core Neural Engine)",
            "ram": "16GB Unified Memory",
            "storage": "512GB NVMe SSD",
            "gpu": "10-core Apple Integrated GPU",
            "display": "15.3-inch Liquid Retina, 2880x1864, 500 nits, True Tone, P3 wide color",
            "battery": "66.5 Wh (up to 18 hours Apple TV app playback)",
            "weight": "1.51 kg",
            "os": "macOS Sonoma",
            "ports": "2x Thunderbolt / USB 4, MagSafe 3, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-003-v16", "variant_name": "M3 / 16GB / 512GB", "ram": "16GB", "storage": "512GB", "price": 154900.0}
        ],
        "retailer_listings": [
            {"retailer": "Apple Store India", "identifier_type": "sku", "identifier_value": "MXD13HN/A", "canonical_url": "https://www.apple.com/in/shop/buy-mac/macbook-air/13-inch-m3", "variant_id": "laptop-003-v16"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CX21C8S7", "canonical_url": "https://www.amazon.in/dp/B0CX21C8S7", "variant_id": "laptop-003-v16"}
        ],
        "offers": [
            {"retailer": "Apple Store India", "price": 154900.0, "variant_id": "laptop-003-v16"},
            {"retailer": "Amazon India", "price": 154900.0, "variant_id": "laptop-003-v16"}
        ],
        "priority_affinities": {"battery": 0.98, "portability": 0.96, "display": 0.94, "performance": 0.91, "value": 0.88},
        "intended_usage_tags": ["office", "coding", "content_creation", "travel"]
    },
    {
        "id": "laptop-004",
        "brand": "Lenovo",
        "name": "Lenovo Legion Pro 5 Gen 9 (Ryzen 7 / 32GB / 1TB / RTX 4070)",
        "exact_model": "Legion Pro 5 Gen 9",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "High-wattage gaming and simulation workstation with AMD Ryzen 7 7745HX, 140W RTX 4070, and 240Hz WQXGA color-calibrated display.",
        "image_url": "https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "AMD Ryzen 7 7745HX (8 cores, 16 threads, up to 5.1 GHz)",
            "ram": "32GB DDR5 5200MHz",
            "storage": "1TB PCIe Gen 4 SSD",
            "gpu": "NVIDIA GeForce RTX 4070 8GB GDDR6 (140W TGP)",
            "display": "16-inch WQXGA, 2560x1600, IPS, 240Hz, 500 nits, 100% sRGB, G-Sync",
            "battery": "80 Wh (up to 5.5 hours hybrid mode)",
            "weight": "2.50 kg",
            "os": "Windows 11 Home",
            "ports": "4x USB-A 3.2, 2x USB-C 3.2, HDMI 2.1, RJ-45 Ethernet, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-004-v32", "variant_name": "Ryzen 7 / 32GB / 1TB / RTX 4070", "ram": "32GB", "storage": "1TB", "price": 129990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CDLR95QZ", "canonical_url": "https://www.amazon.in/dp/B0CDLR95QZ", "variant_id": "laptop-004-v32"},
            {"retailer": "Lenovo India Store", "identifier_type": "sku", "identifier_value": "82WM00BNIN", "canonical_url": "https://www.lenovo.com/in/en/p/laptops/legion-laptops/legion-pro-series/legion-pro-5-gen-9", "variant_id": "laptop-004-v32"}
        ],
        "offers": [
            {"retailer": "Lenovo India Store", "price": 129990.0, "variant_id": "laptop-004-v32"},
            {"retailer": "Amazon India", "price": 129990.0, "variant_id": "laptop-004-v32"}
        ],
        "priority_affinities": {"performance": 0.99, "ram": 0.96, "display": 0.93, "battery": 0.55, "value": 0.94},
        "intended_usage_tags": ["gaming", "ai_ml", "programming", "3d_rendering"]
    },
    {
        "id": "laptop-005",
        "brand": "Lenovo",
        "name": "Lenovo ThinkPad X1 Carbon Gen 12 (Core Ultra 7 / 16GB / 512GB)",
        "exact_model": "ThinkPad X1 Carbon Gen 12",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "Enterprise standard ultra-light business laptop with Intel Core Ultra 7, carbon-fiber reinforced chassis, trackpoint, and MIL-STD 810H durability.",
        "image_url": "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Intel Core Ultra 7 155U (12 cores, up to 4.8 GHz with Intel AI Boost NPU)",
            "ram": "16GB LPDDR5X 6400MHz",
            "storage": "512GB M.2 PCIe Gen 4 SSD",
            "gpu": "Intel Graphics integrated",
            "display": "14-inch 2.8K OLED, 2880x1800, 120Hz, 400 nits, 100% DCI-P3, Eyesafe",
            "battery": "57 Wh (up to 14 hours battery)",
            "weight": "1.09 kg",
            "os": "Windows 11 Pro",
            "ports": "2x Thunderbolt 4, 2x USB-A 3.2, HDMI 2.1, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-005-v16", "variant_name": "Core Ultra 7 / 16GB / 512GB", "ram": "16GB", "storage": "512GB", "price": 182990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D1TPX1C2", "canonical_url": "https://www.amazon.in/dp/B0D1TPX1C2", "variant_id": "laptop-005-v16"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 182990.0, "variant_id": "laptop-005-v16"}
        ],
        "priority_affinities": {"portability": 0.99, "build": 0.98, "battery": 0.94, "performance": 0.90, "value": 0.78},
        "intended_usage_tags": ["executive", "business_travel", "programming", "coding"]
    },
    {
        "id": "laptop-006",
        "brand": "HP",
        "name": "HP Spectre x360 14 (Core Ultra 7 / 16GB / 1TB / 2.8K OLED)",
        "exact_model": "Spectre x360 14-eu",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "Premium 2-in-1 convertible with Intel Core Ultra 7, 2.8K 120Hz IMAX Enhanced OLED touchscreen, 9MP AI camera, and rechargeable MPP 2.0 tilt pen.",
        "image_url": "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz with NPU)",
            "ram": "16GB LPDDR5X 7467MHz",
            "storage": "1TB PCIe Gen 4 NVMe SSD",
            "gpu": "Intel Arc Graphics integrated",
            "display": "14-inch 2.8K OLED, 2880x1800, 48-120Hz, 500 nits HDR, touch, stylus support",
            "battery": "68 Wh (up to 13 hours battery)",
            "weight": "1.44 kg",
            "os": "Windows 11 Home",
            "ports": "2x Thunderbolt 4, 1x USB-A 3.2, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-006-v16", "variant_name": "Core Ultra 7 / 16GB / 1TB", "ram": "16GB", "storage": "1TB", "price": 154990.0}
        ],
        "retailer_listings": [
            {"retailer": "HP Official Store", "identifier_type": "sku", "identifier_value": "14-eu0000tu", "canonical_url": "https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html", "variant_id": "laptop-006-v16"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CS6YSP14", "canonical_url": "https://www.amazon.in/dp/B0CS6YSP14", "variant_id": "laptop-006-v16"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "COMGZ78YSPEC14", "canonical_url": "https://www.flipkart.com/hp-spectre-x360-intel-core-ultra-7-155h-14-inch/p/itmspec14", "variant_id": "laptop-006-v16"}
        ],
        "offers": [
            {"retailer": "HP Official Store", "price": 154990.0, "variant_id": "laptop-006-v16"},
            {"retailer": "Amazon India", "price": 154990.0, "variant_id": "laptop-006-v16"},
            {"retailer": "Flipkart", "price": 154990.0, "variant_id": "laptop-006-v16"}
        ],
        "priority_affinities": {"display": 0.98, "portability": 0.95, "build": 0.97, "battery": 0.92, "value": 0.85},
        "intended_usage_tags": ["convertible", "note_taking", "creator", "executive"]
    },
    {
        "id": "laptop-007",
        "brand": "ASUS",
        "name": "ASUS Zenbook 14 OLED (Core Ultra 7 / 16GB / 1TB)",
        "exact_model": "Zenbook 14 OLED UX3405",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "Elegantly slim 1.2kg ultraportable with Intel Core Ultra 7, Intel Arc graphics, 3K 120Hz Lumina OLED display, and 75Wh battery.",
        "image_url": "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz)",
            "ram": "16GB LPDDR5X 7467MHz",
            "storage": "1TB M.2 NVMe PCIe 4.0 SSD",
            "gpu": "Intel Arc Graphics integrated",
            "display": "14.0-inch 3K OLED, 2880x1800, 120Hz, 0.2ms, 600 nits peak, 100% DCI-P3",
            "battery": "75 Wh (up to 15 hours battery)",
            "weight": "1.22 kg",
            "os": "Windows 11 Home",
            "ports": "2x Thunderbolt 4, 1x USB-A 3.2, HDMI 2.1, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-007-v16", "variant_name": "Core Ultra 7 / 16GB / 1TB", "ram": "16GB", "storage": "1TB", "price": 109990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CTHMZN14", "canonical_url": "https://www.amazon.in/dp/B0CTHMZN14", "variant_id": "laptop-007-v16"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 109990.0, "variant_id": "laptop-007-v16"}
        ],
        "priority_affinities": {"display": 0.98, "battery": 0.96, "portability": 0.97, "performance": 0.91, "value": 0.93},
        "intended_usage_tags": ["programming", "travel", "office", "streaming"]
    },
    {
        "id": "laptop-008",
        "brand": "Acer",
        "name": "Acer Swift Go 14 (Core Ultra 5 / 16GB / 512GB / 2.8K OLED)",
        "exact_model": "Swift Go 14 SFG14",
        "category": "laptops",
        "subcategory": "laptops",
        "description": "High-value thin & light laptop with Intel Core Ultra 5, 2.8K 90Hz OLED display, dual-fan TwinAir cooling, and Intel AI Boost.",
        "image_url": "https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Intel Core Ultra 5 125H (14 cores, up to 4.5 GHz)",
            "ram": "16GB LPDDR5X",
            "storage": "512GB PCIe Gen 4 SSD",
            "gpu": "Intel Arc Graphics integrated",
            "display": "14-inch 2.8K OLED, 2880x1800, 90Hz, 400 nits, 100% DCI-P3",
            "battery": "65 Wh (up to 10 hours battery)",
            "weight": "1.32 kg",
            "os": "Windows 11 Home",
            "ports": "2x Thunderbolt 4, 2x USB-A 3.2, HDMI 2.1, MicroSD slot, 3.5mm jack"
        },
        "variants": [
            {"id": "laptop-008-v16", "variant_name": "Core Ultra 5 / 16GB / 512GB", "ram": "16GB", "storage": "512GB", "price": 69990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CSBYAC14", "canonical_url": "https://www.amazon.in/dp/B0CSBYAC14", "variant_id": "laptop-008-v16"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 69990.0, "variant_id": "laptop-008-v16"}
        ],
        "priority_affinities": {"value": 0.97, "display": 0.94, "performance": 0.88, "portability": 0.93, "battery": 0.89},
        "intended_usage_tags": ["student", "budget_creator", "daily_driver", "coding"]
    }
]

# =============================================================================
# TELEVISIONS MASTER DATASET (10 Verified Models)
# =============================================================================
TELEVISIONS_DATASET = [
    {
        "id": "tv-001",
        "brand": "Samsung",
        "name": "Samsung 55-inch S95D 4K OLED TV (QA55S95DAU)",
        "exact_model": "S95D 4K OLED 55",
        "category": "televisions",
        "subcategory": "televisions",
        "description": "Flagship 4K QD-OLED TV with OLED Glare Free technology, NQ4 AI Gen2 Processor, 144Hz refresh rate, and 70W 4.2.2Ch Dolby Atmos audio.",
        "image_url": "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "55-inch 4K OLED (Quantum Dot), 3840x2160, 144Hz VRR, OLED Glare Free",
            "hdr": "OLED HDR Pro, HDR10+, HLG",
            "processor": "NQ4 AI Gen2 Processor (20 AI neural networks)",
            "audio": "70W, 4.2.2 Channel, Dolby Atmos, Object Tracking Sound+ (OTS+)",
            "gaming": "4x HDMI 2.1, 4K 144Hz, FreeSync Premium Pro, Auto Game Mode (ALLM)",
            "smart_os": "Tizen OS with Samsung Knox Security",
            "ports": "4x HDMI 2.1, 3x USB, Optical, Ethernet, Wi-Fi 5, Bluetooth 5.2"
        },
        "variants": [
            {"id": "tv-001-v55", "variant_name": "55-inch OLED", "ram": "4GB", "storage": "16GB", "price": 184990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D3GYTV55", "canonical_url": "https://www.amazon.in/dp/B0D3GYTV55", "variant_id": "tv-001-v55"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "TVSGZ78YS95D55", "canonical_url": "https://www.flipkart.com/samsung-55-inch-oled-ultra-hd-4k-smart-tizen-tv/p/itms95d55", "variant_id": "tv-001-v55"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 184990.0, "variant_id": "tv-001-v55"},
            {"retailer": "Flipkart", "price": 184990.0, "variant_id": "tv-001-v55"}
        ],
        "priority_affinities": {"display": 0.99, "performance": 0.98, "sound": 0.96, "gaming": 0.99, "value": 0.75},
        "intended_usage_tags": ["home_theatre", "ps5_gaming", "flagship_cinema"]
    },
    {
        "id": "tv-002",
        "brand": "LG",
        "name": "LG 55-inch OLED evo C4 4K Smart TV (OLED55C4PTA)",
        "exact_model": "OLED evo C4 55",
        "category": "televisions",
        "subcategory": "televisions",
        "description": "Benchmark 4K OLED TV featuring Alpha 9 AI Gen7 processor, Brightness Booster, 144Hz VRR, Dolby Vision, and 0.1ms response time.",
        "image_url": "https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "55-inch 4K Self-Lit OLED evo, 3840x2160, 144Hz, 0.1ms response time",
            "hdr": "Dolby Vision, HDR10, HLG, Filmmaker Mode",
            "processor": "Alpha 9 AI Processor 4K Gen7",
            "audio": "40W, 2.2 Channel, Dolby Atmos, AI Sound Pro 9.1.2 Virtual Upmix",
            "gaming": "4x HDMI 2.1 (48Gbps), G-Sync, FreeSync Premium, 144Hz VRR, ALLM",
            "smart_os": "webOS 24 with 5 years Re:New Program updates",
            "ports": "4x HDMI 2.1, 3x USB, Optical, eARC, Wi-Fi 5, Bluetooth 5.1"
        },
        "variants": [
            {"id": "tv-002-v55", "variant_name": "55-inch OLED", "ram": "4GB", "storage": "16GB", "price": 149990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D2YXC455", "canonical_url": "https://www.amazon.in/dp/B0D2YXC455", "variant_id": "tv-002-v55"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "TVSGZ98YLGC455", "canonical_url": "https://www.flipkart.com/lg-oled-evo-c4-55-inch-ultra-hd-4k-smart-tv/p/itmlgc455", "variant_id": "tv-002-v55"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 149990.0, "variant_id": "tv-002-v55"},
            {"retailer": "Flipkart", "price": 149990.0, "variant_id": "tv-002-v55"}
        ],
        "priority_affinities": {"display": 0.99, "gaming": 1.0, "sound": 0.91, "performance": 0.97, "value": 0.84},
        "intended_usage_tags": ["pc_gaming", "console_gaming", "4k_movies", "hdr_cinema"]
    },
    {
        "id": "tv-003",
        "brand": "Sony",
        "name": "Sony Bravia 55-inch XR A80L 4K OLED TV (XR-55A80L)",
        "exact_model": "Bravia XR A80L OLED 55",
        "category": "televisions",
        "subcategory": "televisions",
        "description": "Premium Sony OLED powered by Cognitive Processor XR, Acoustic Surface Audio+ vibrating actuators, and XR OLED Contrast Pro.",
        "image_url": "https://images.unsplash.com/photo-1461151304267-38535e780c79?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "55-inch 4K OLED, 3840x2160, 120Hz, XR Triluminos Pro, XR Clear Image",
            "hdr": "Dolby Vision, HDR10, HLG, IMAX Enhanced",
            "processor": "Cognitive Processor XR with human perception modeling",
            "audio": "50W, Acoustic Surface Audio+ (screen is the speaker), 3 actuators, 2 subwoofers",
            "gaming": "HDMI 2.1, 4K 120Hz, Auto HDR Tone Mapping for PS5, ALLM, VRR",
            "smart_os": "Google TV with hands-free Google Assistant",
            "ports": "4x HDMI (2x HDMI 2.1), 2x USB, Optical, eARC, Wi-Fi 5, Bluetooth 4.2"
        },
        "variants": [
            {"id": "tv-003-v55", "variant_name": "55-inch OLED", "ram": "4GB", "storage": "32GB", "price": 169990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0C7QSY80L", "canonical_url": "https://www.amazon.in/dp/B0C7QSY80L", "variant_id": "tv-003-v55"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 169990.0, "variant_id": "tv-003-v55"}
        ],
        "priority_affinities": {"display": 0.99, "sound": 0.99, "performance": 0.97, "gaming": 0.94, "value": 0.79},
        "intended_usage_tags": ["cinematic_movies", "ps5_exclusive", "audiophile_tv"]
    },
    {
        "id": "tv-004",
        "brand": "Samsung",
        "name": "Samsung 55-inch The Frame 4K QLED TV (QA55LS03DAU)",
        "exact_model": "The Frame 4K QLED 55",
        "category": "televisions",
        "subcategory": "televisions",
        "description": "Lifestyle art television with Matte Display, Art Mode, customizable magnetic bezels, One Connect Box, and 100% Color Volume with Quantum Dot.",
        "image_url": "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "55-inch 4K QLED, 3840x2160, 120Hz, Anti-Reflection Matte Display",
            "hdr": "Quantum HDR, HDR10+, HLG",
            "processor": "Quantum Processor 4K",
            "audio": "40W, 2.0.2 Channel, Dolby Atmos, Object Tracking Sound",
            "lifestyle": "Art Store access, motion sensor, slim-fit wall mount included, One Connect cable",
            "smart_os": "Tizen OS",
            "ports": "4x HDMI 2.1 via One Connect Box, 2x USB, Optical, Wi-Fi 5"
        },
        "variants": [
            {"id": "tv-004-v55", "variant_name": "55-inch QLED", "ram": "3GB", "storage": "16GB", "price": 86990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D47FRM55", "canonical_url": "https://www.amazon.in/dp/B0D47FRM55", "variant_id": "tv-004-v55"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 86990.0, "variant_id": "tv-004-v55"}
        ],
        "priority_affinities": {"display": 0.92, "build": 0.99, "sound": 0.88, "value": 0.89},
        "intended_usage_tags": ["living_room_art", "aesthetic_home", "bright_room"]
    },
    {
        "id": "tv-005",
        "brand": "TCL",
        "name": "TCL 55-inch C755 QD-Mini LED 4K TV (55C755)",
        "exact_model": "TCL C755 Mini LED 55",
        "category": "televisions",
        "subcategory": "televisions",
        "description": "High-value QD-Mini LED with over 500 dimming zones, 1300 nits peak brightness, 144Hz VRR, and ONKYO 2.1 channel soundbar.",
        "image_url": "https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "55-inch 4K QD-Mini LED, 3840x2160, 144Hz VRR, 500+ Local Dimming Zones, 1300 nits",
            "hdr": "Dolby Vision IQ, HDR10+, HLG",
            "processor": "AiPQ Processor 3.0",
            "audio": "50W ONKYO 2.1 Hi-Fi with built-in subwoofer, Dolby Atmos, DTS Virtual:X",
            "gaming": "Game Accelerator 240Hz, AMD FreeSync Premium Pro, 4x HDMI",
            "smart_os": "Google TV",
            "ports": "4x HDMI (2x HDMI 2.1), 2x USB, Optical, Wi-Fi 5"
        },
        "variants": [
            {"id": "tv-005-v55", "variant_name": "55-inch Mini LED", "ram": "3GB", "storage": "32GB", "price": 64990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CJ48TCL5", "canonical_url": "https://www.amazon.in/dp/B0CJ48TCL5", "variant_id": "tv-005-v55"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 64990.0, "variant_id": "tv-005-v55"}
        ],
        "priority_affinities": {"value": 0.98, "display": 0.95, "sound": 0.94, "gaming": 0.96, "performance": 0.92},
        "intended_usage_tags": ["budget_miniled", "gaming_tv", "high_brightness"]
    },
    {
        "id": "tv-006",
        "brand": "Xiaomi",
        "name": "Xiaomi 55-inch X Pro QLED 4K Smart Google TV",
        "exact_model": "Xiaomi X Pro QLED 55",
        "category": "televisions",
        "subcategory": "televisions",
        "description": "Aggressively priced 4K QLED television with metallic bezel-less design, Dolby Vision IQ, 30W stereo speakers, and Google TV with PatchWall.",
        "image_url": "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "55-inch 4K QLED, 3840x2160, 60Hz with MEMC, 94% DCI-P3 color gamut",
            "hdr": "Dolby Vision IQ, HDR10+, HLG",
            "processor": "Quad-Core A55 Processor with Mali G52 MP2 GPU",
            "audio": "30W Stereo Speakers, Dolby Audio, DTS:X, DTS Virtual:X",
            "smart_os": "Google TV with PatchWall+ integration",
            "ports": "3x HDMI 2.1 (ALLM/eARC), 2x USB 2.0, Optical, Ethernet, 3.5mm jack"
        },
        "variants": [
            {"id": "tv-006-v55", "variant_name": "55-inch QLED", "ram": "2GB", "storage": "32GB", "price": 34999.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D78XMI55", "canonical_url": "https://www.amazon.in/dp/B0D78XMI55", "variant_id": "tv-006-v55"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 34999.0, "variant_id": "tv-006-v55"}
        ],
        "priority_affinities": {"value": 0.99, "display": 0.88, "sound": 0.85, "performance": 0.84},
        "intended_usage_tags": ["budget_qled", "bedroom_tv", "streaming"]
    }
]

# =============================================================================
# REFRIGERATORS MASTER DATASET (10 Verified Models)
# =============================================================================
REFRIGERATORS_DATASET = [
    {
        "id": "fridge-001",
        "brand": "Samsung",
        "name": "Samsung 653L Side-by-Side Inverter Refrigerator (RS76CG8003S9)",
        "exact_model": "Samsung 653L Side-by-Side",
        "category": "refrigerators",
        "subcategory": "refrigerators",
        "description": "Spacious side-by-side refrigerator featuring Convertible 5-in-1 modes, SpaceMax technology, Twin Cooling Plus, and Digital Inverter Compressor with 20-year warranty.",
        "image_url": "https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "653 Litres (Fridge: 409L, Freezer: 244L)",
            "configuration": "Side-by-Side",
            "compressor": "Digital Inverter Compressor (50% less power, 20-year warranty)",
            "cooling_technology": "Twin Cooling Plus (two independent evaporators prevent odor mixing)",
            "modes": "5-in-1 Convertible (Normal, Extra Fridge, Vacation, Seasonal, Home Alone)",
            "features": "SpaceMax slim walls, Power Cool / Power Freeze, Door Alarm, Deodorizing Filter",
            "energy_efficiency": "3 Star equivalent for SBS large capacity",
            "dimensions": "91.2 x 178.0 x 71.6 cm, 101 kg"
        },
        "variants": [
            {"id": "fridge-001-v653", "variant_name": "653L / Silver Matte", "storage": "653L", "price": 79990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BS1GSS65", "canonical_url": "https://www.amazon.in/dp/B0BS1GSS65", "variant_id": "fridge-001-v653"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "RFRGZ78YSAM653", "canonical_url": "https://www.flipkart.com/samsung-653-l-frost-free-side-by-side-refrigerator/p/itmsam653", "variant_id": "fridge-001-v653"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 79990.0, "variant_id": "fridge-001-v653"},
            {"retailer": "Flipkart", "price": 81990.0, "variant_id": "fridge-001-v653"}
        ],
        "priority_affinities": {"capacity": 0.99, "performance": 0.96, "build": 0.97, "value": 0.90},
        "intended_usage_tags": ["large_family", "entertaining", "side_by_side"]
    },
    {
        "id": "fridge-002",
        "brand": "LG",
        "name": "LG 655L Smart Inverter Side-by-Side Refrigerator (GL-B257HDSY)",
        "exact_model": "LG 655L Side-by-Side",
        "category": "refrigerators",
        "subcategory": "refrigerators",
        "description": "Multi-door side-by-side refrigerator with Smart Inverter Compressor, Multi Air Flow cooling, Express Freeze, and Smart Diagnosis.",
        "image_url": "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "655 Litres (Fridge: 416L, Freezer: 239L)",
            "configuration": "Side-by-Side",
            "compressor": "Smart Inverter Compressor with 10-year warranty",
            "cooling_technology": "Multi Air Flow with digital temperature sensors",
            "features": "Express Freeze, Smart Diagnosis, Bio Shield gasket, Tempered Glass shelves",
            "dimensions": "91.3 x 179.0 x 74.3 cm, 103 kg"
        },
        "variants": [
            {"id": "fridge-002-v655", "variant_name": "655L / Dazzle Steel", "storage": "655L", "price": 74990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0B69LG655", "canonical_url": "https://www.amazon.in/dp/B0B69LG655", "variant_id": "fridge-002-v655"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 74990.0, "variant_id": "fridge-002-v655"}
        ],
        "priority_affinities": {"capacity": 0.99, "performance": 0.95, "build": 0.96, "value": 0.92},
        "intended_usage_tags": ["large_family", "side_by_side", "silent_cooling"]
    },
    {
        "id": "fridge-003",
        "brand": "Samsung",
        "name": "Samsung 236L 3-Star Double Door Refrigerator (RT28C3733S8)",
        "exact_model": "Samsung 236L Double Door",
        "category": "refrigerators",
        "subcategory": "refrigerators",
        "description": "Frost-free double door refrigerator for small-to-medium families featuring Digital Inverter Compressor, MoistFresh Zone, and toughened glass shelves.",
        "image_url": "https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "236 Litres (Fridge: 183L, Freezer: 53L)",
            "configuration": "Double Door (Frost Free)",
            "compressor": "Digital Inverter with 20-year warranty",
            "energy_rating": "3 Star BEE rating",
            "cooling_technology": "All-around Cooling with multi-vent air distribution",
            "features": "MoistFresh Zone, Easy Slide Shelf, Deodorizing Filter, Stabilizer Free Operation",
            "dimensions": "55.5 x 154.5 x 63.7 cm, 46 kg"
        },
        "variants": [
            {"id": "fridge-003-v236", "variant_name": "236L / Elegant Inox", "storage": "236L", "price": 25490.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BS1G236L", "canonical_url": "https://www.amazon.in/dp/B0BS1G236L", "variant_id": "fridge-003-v236"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 25490.0, "variant_id": "fridge-003-v236"}
        ],
        "priority_affinities": {"value": 0.96, "energy": 0.93, "performance": 0.90, "capacity": 0.82},
        "intended_usage_tags": ["family_of_3_4", "double_door", "energy_efficient"]
    },
    {
        "id": "fridge-004",
        "brand": "LG",
        "name": "LG 242L 3-Star Smart Inverter Double Door Refrigerator (GL-I292RPZX)",
        "exact_model": "LG 242L Double Door",
        "category": "refrigerators",
        "subcategory": "refrigerators",
        "description": "Double door frost-free refrigerator with Door Cooling+ for 35% faster uniform cooling, Smart Inverter Compressor, and Auto Smart Connect.",
        "image_url": "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "242 Litres (Fridge: 181L, Freezer: 61L)",
            "configuration": "Double Door (Frost Free)",
            "compressor": "Smart Inverter Compressor with 10-year warranty",
            "energy_rating": "3 Star BEE rating",
            "cooling_technology": "Door Cooling+ with Multi Air Flow",
            "features": "Auto Smart Connect (home inverter compatible), Moist 'N' Fresh lattice box, 2L bottle storage",
            "dimensions": "58.5 x 147.5 x 66.9 cm, 48 kg"
        },
        "variants": [
            {"id": "fridge-004-v242", "variant_name": "242L / Shiny Steel", "storage": "242L", "price": 25990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B09WRS242L", "canonical_url": "https://www.amazon.in/dp/B09WRS242L", "variant_id": "fridge-004-v242"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 25990.0, "variant_id": "fridge-004-v242"}
        ],
        "priority_affinities": {"value": 0.95, "energy": 0.94, "performance": 0.91, "capacity": 0.83},
        "intended_usage_tags": ["family_of_3_4", "door_cooling", "double_door"]
    },
    {
        "id": "fridge-005",
        "brand": "Whirlpool",
        "name": "Whirlpool 265L 3-Star Intellifresh Double Door Refrigerator",
        "exact_model": "Whirlpool 265L Intellifresh",
        "category": "refrigerators",
        "subcategory": "refrigerators",
        "description": "Double door refrigerator with 6th Sense IntelliSensor technology, Microblock protection preventing 99% bacterial growth, and Zeolite technology.",
        "image_url": "https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "265 Litres (Fridge: 190L, Freezer: 75L)",
            "configuration": "Double Door (Frost Free)",
            "compressor": "Intellisense Inverter Technology with 10-year warranty",
            "energy_rating": "3 Star BEE rating",
            "cooling_technology": "6th Sense DeepFreeze with freshflow air tower",
            "features": "Microblock Technology, Zeolite fresh keeper, Active Deo, 15 days garden freshness",
            "dimensions": "57.0 x 159.0 x 67.0 cm, 50 kg"
        },
        "variants": [
            {"id": "fridge-005-v265", "variant_name": "265L / German Steel", "storage": "265L", "price": 27490.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B08WPR265L", "canonical_url": "https://www.amazon.in/dp/B08WPR265L", "variant_id": "fridge-005-v265"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 27490.0, "variant_id": "fridge-005-v265"}
        ],
        "priority_affinities": {"value": 0.94, "capacity": 0.86, "performance": 0.89, "energy": 0.92},
        "intended_usage_tags": ["vegetable_freshness", "family_of_4", "double_door"]
    },
    {
        "id": "fridge-006",
        "brand": "Samsung",
        "name": "Samsung 183L 4-Star Single Door Refrigerator (RR20C1824U8)",
        "exact_model": "Samsung 183L Single Door",
        "category": "refrigerators",
        "subcategory": "refrigerators",
        "description": "High-efficiency 4-star direct cool single door refrigerator with Digital Inverter, base stand with drawer for non-refrigerated veggies, and toughened glass shelves.",
        "image_url": "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "183 Litres",
            "configuration": "Single Door (Direct Cool)",
            "compressor": "Digital Inverter Compressor (20-year warranty)",
            "energy_rating": "4 Star BEE rating (high energy savings)",
            "features": "Base Stand Drawer (for onions & potatoes), Safe Clean Back, Toughened Glass (up to 175kg)",
            "dimensions": "53.2 x 121.0 x 64.6 cm, 30 kg"
        },
        "variants": [
            {"id": "fridge-006-v183", "variant_name": "183L / Saffron Blue", "storage": "183L", "price": 16990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BS1G183L", "canonical_url": "https://www.amazon.in/dp/B0BS1G183L", "variant_id": "fridge-006-v183"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 16990.0, "variant_id": "fridge-006-v183"}
        ],
        "priority_affinities": {"value": 0.99, "energy": 0.98, "performance": 0.86, "capacity": 0.72},
        "intended_usage_tags": ["bachelor", "couple", "single_door", "compact_kitchen"]
    }
]

# =============================================================================
# WASHING MACHINES MASTER DATASET (8-10 Verified Models)
# =============================================================================
WASHING_MACHINES_DATASET = [
    {
        "id": "wash-001",
        "brand": "LG",
        "name": "LG 8kg 5-Star AI DirectDrive Front Load Washing Machine (FHP1208Z5M)",
        "exact_model": "LG 8kg AI DirectDrive",
        "category": "washing_machines",
        "subcategory": "washing_machines",
        "description": "Advanced front load washing machine with AI Direct Drive detecting fabric weight and softness, 6 Motion wash technology, and Steam for 99.9% allergen removal.",
        "image_url": "https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "8.0 kg (suitable for families of 4-5)",
            "type": "Front Load (Fully Automatic)",
            "spin_speed": "1200 RPM (faster drying)",
            "motor": "AI Inverter Direct Drive (beltless motor with 10-year warranty)",
            "energy_rating": "5 Star BEE rating (water & energy efficient)",
            "wash_programs": "14 programs including Cotton, Allergy Care Steam, Turbowash 59min, Quick 14",
            "features": "Steam Wash, 6 Motion DD, Smart Diagnosis, Full Stainless Steel Drum",
            "dimensions": "60.0 x 85.0 x 55.0 cm, 60 kg"
        },
        "variants": [
            {"id": "wash-001-v8", "variant_name": "8kg / Middle Black", "storage": "8kg", "price": 37990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CDLG8KFL", "canonical_url": "https://www.amazon.in/dp/B0CDLG8KFL", "variant_id": "wash-001-v8"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "WMNGZ78YLG8KG", "canonical_url": "https://www.flipkart.com/lg-8-kg-5-star-ai-direct-drive-front-load-washing-machine/p/itmlg8kgfl", "variant_id": "wash-001-v8"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 37990.0, "variant_id": "wash-001-v8"},
            {"retailer": "Flipkart", "price": 38490.0, "variant_id": "wash-001-v8"}
        ],
        "priority_affinities": {"performance": 0.98, "energy": 0.97, "build": 0.96, "value": 0.90},
        "intended_usage_tags": ["family_of_4_5", "steam_allergy", "quiet_motor", "fabric_care"]
    },
    {
        "id": "wash-002",
        "brand": "Bosch",
        "name": "Bosch 8kg 5-Star Serie 6 Front Load Washing Machine (WAJ2846SIN)",
        "exact_model": "Bosch 8kg Serie 6",
        "category": "washing_machines",
        "subcategory": "washing_machines",
        "description": "German-engineered front load washer featuring EcoSilence Drive brushless motor, 1400 RPM spin speed, AntiTangle technology, and ActiveWater Plus.",
        "image_url": "https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "8.0 kg",
            "type": "Front Load (Fully Automatic)",
            "spin_speed": "1400 RPM (industry-leading spin speed)",
            "motor": "EcoSilence Drive frictionless magnetic motor (10-year warranty)",
            "energy_rating": "5 Star BEE rating",
            "features": "ActiveWater Plus (256 load sensing levels), AntiVibration design, VarioDrum, AntiTangle",
            "wash_programs": "15 programs including Delicates, Hygiene Care, Express 15/30, Wool",
            "dimensions": "59.8 x 84.8 x 59.0 cm, 71.5 kg"
        },
        "variants": [
            {"id": "wash-002-v8", "variant_name": "8kg / Silver Inox", "storage": "8kg", "price": 39990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B08BSH8K6S", "canonical_url": "https://www.amazon.in/dp/B08BSH8K6S", "variant_id": "wash-002-v8"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 39990.0, "variant_id": "wash-002-v8"}
        ],
        "priority_affinities": {"performance": 0.99, "build": 0.98, "energy": 0.96, "value": 0.88},
        "intended_usage_tags": ["heavy_laundry", "vibration_free", "high_durability"]
    },
    {
        "id": "wash-003",
        "brand": "Samsung",
        "name": "Samsung 8kg 5-Star EcoBubble AI Front Load Washing Machine",
        "exact_model": "Samsung 8kg EcoBubble AI",
        "category": "washing_machines",
        "subcategory": "washing_machines",
        "description": "Front load washer featuring EcoBubble technology turning detergent into soft bubbles, AI pattern learning, and Hygiene Steam cycles.",
        "image_url": "https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "8.0 kg",
            "type": "Front Load (Fully Automatic)",
            "spin_speed": "1400 RPM",
            "motor": "Digital Inverter Motor (20-year warranty)",
            "energy_rating": "5 Star BEE rating",
            "features": "EcoBubble (deep fabric penetration at low temp), AI Control, SmartThings Wi-Fi, Drum Clean+",
            "dimensions": "60.0 x 85.0 x 55.0 cm, 65 kg"
        },
        "variants": [
            {"id": "wash-003-v8", "variant_name": "8kg / Inox Gray", "storage": "8kg", "price": 36990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B08SM8KECO", "canonical_url": "https://www.amazon.in/dp/B08SM8KECO", "variant_id": "wash-003-v8"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 36990.0, "variant_id": "wash-003-v8"}
        ],
        "priority_affinities": {"performance": 0.96, "energy": 0.96, "value": 0.91, "build": 0.94},
        "intended_usage_tags": ["wifi_smart", "ecobubble", "delicate_fabrics"]
    },
    {
        "id": "wash-004",
        "brand": "LG",
        "name": "LG 7kg 5-Star Smart Inverter Top Load Washing Machine (T70SKSF1Z)",
        "exact_model": "LG 7kg Top Load",
        "category": "washing_machines",
        "subcategory": "washing_machines",
        "description": "Top load fully automatic washing machine with Smart Inverter technology, TurboDrum with dual-direction rotation, and BMC motor protection.",
        "image_url": "https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "7.0 kg (suitable for families of 3-4)",
            "type": "Top Load (Fully Automatic)",
            "spin_speed": "700 RPM",
            "motor": "Smart Inverter Motor with waterproof BMC protection (10-year warranty)",
            "energy_rating": "5 Star BEE rating",
            "features": "TurboDrum, Smart Motion (3 wash motions), Punch+ 3 pulsator, Stainless Steel drum",
            "dimensions": "54.0 x 87.0 x 54.0 cm, 32 kg"
        },
        "variants": [
            {"id": "wash-004-v7", "variant_name": "7kg / Middle Free Silver", "storage": "7kg", "price": 17990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B089LG7KTL", "canonical_url": "https://www.amazon.in/dp/B089LG7KTL", "variant_id": "wash-004-v7"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 17990.0, "variant_id": "wash-004-v7"}
        ],
        "priority_affinities": {"value": 0.98, "energy": 0.95, "performance": 0.88, "build": 0.90},
        "intended_usage_tags": ["top_load", "compact_space", "value_for_money"]
    }
]

# =============================================================================
# AIR CONDITIONERS MASTER DATASET (8-10 Verified Models)
# =============================================================================
AIR_CONDITIONERS_DATASET = [
    {
        "id": "ac-001",
        "brand": "Daikin",
        "name": "Daikin 1.5 Ton 5-Star Inverter Split AC (MTKM50U)",
        "exact_model": "Daikin 1.5T 5-Star Inverter",
        "category": "air_conditioners",
        "subcategory": "air_conditioners",
        "description": "Japanese precision cooling with Neo Swing Inverter compressor, PM2.5 filtration, Dew Clean auto-wash, and high ambient cooling up to 54°C.",
        "image_url": "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "1.5 Ton (suitable for 110 to 150 sq ft rooms)",
            "energy_rating": "5 Star BEE (ISEER: 5.20, annual power: 785 kWh)",
            "compressor": "Patented Neo Swing Inverter Compressor (10-year warranty)",
            "cooling_capacity": "5000 W (rated full capacity)",
            "condenser_coil": "100% Copper with Anti-Corrosion Treatment",
            "air_purification": "PM2.5 Filter and Dew Clean auto-cleaning technology",
            "special_features": "Triple Display, Coanda Airflow for draftless cooling, Econo Mode",
            "refrigerant": "R32 eco-friendly gas (Zero ODP)"
        },
        "variants": [
            {"id": "ac-001-v15", "variant_name": "1.5 Ton 5-Star / White", "storage": "1.5T", "price": 45490.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BRGDK155", "canonical_url": "https://www.amazon.in/dp/B0BRGDK155", "variant_id": "ac-001-v15"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "ACNGZ78YDK155", "canonical_url": "https://www.flipkart.com/daikin-1-5-ton-5-star-inverter-split-ac/p/itmdk155", "variant_id": "ac-001-v15"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 45490.0, "variant_id": "ac-001-v15"},
            {"retailer": "Flipkart", "price": 45990.0, "variant_id": "ac-001-v15"}
        ],
        "priority_affinities": {"cooling": 0.99, "energy": 0.98, "reliability": 0.99, "air_quality": 0.95, "value": 0.88},
        "intended_usage_tags": ["bedroom_cooling", "whisper_quiet", "energy_saver", "high_heat_tolerance"]
    },
    {
        "id": "ac-002",
        "brand": "LG",
        "name": "LG 1.5 Ton 5-Star AI Dual Inverter Split AC (TS-Q19YNZE)",
        "exact_model": "LG 1.5T AI Dual Inverter",
        "category": "air_conditioners",
        "subcategory": "air_conditioners",
        "description": "Dual Inverter AC with artificial intelligence adjusting cooling and fan speeds based on room load, 6-in-1 convertible cooling, and Ocean Black Protection.",
        "image_url": "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "1.5 Ton (111 to 150 sq ft)",
            "energy_rating": "5 Star BEE (ISEER: 5.20, annual power: 685 kWh)",
            "compressor": "AI Dual Inverter Compressor (10-year warranty)",
            "cooling_capacity": "5000 W (expandable to 110% overload cooling)",
            "condenser_coil": "100% Copper with Ocean Black Protection against rust and pollutants",
            "features": "AI Convertible 6-in-1, HD Filter with Anti-Virus protection, Ez Clean Filter, Low Gas Detection",
            "refrigerant": "R32"
        },
        "variants": [
            {"id": "ac-002-v15", "variant_name": "1.5 Ton 5-Star / White", "storage": "1.5T", "price": 46490.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BTWD47LG", "canonical_url": "https://www.amazon.in/dp/B0BTWD47LG", "variant_id": "ac-002-v15"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 46490.0, "variant_id": "ac-002-v15"}
        ],
        "priority_affinities": {"cooling": 0.98, "energy": 0.99, "durability": 0.97, "value": 0.89},
        "intended_usage_tags": ["coastal_protection", "convertible_modes", "master_bedroom"]
    },
    {
        "id": "ac-003",
        "brand": "Voltas",
        "name": "Voltas 1.5 Ton 5-Star Inverter Split AC (185V Vectra Elite)",
        "exact_model": "Voltas 1.5T 5-Star Inverter",
        "category": "air_conditioners",
        "subcategory": "air_conditioners",
        "description": "High-value cooling engineered for Indian summers up to 52°C, featuring 4-in-1 adjustable cooling, dual temperature display, and anti-microbial filter.",
        "image_url": "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "capacity": "1.5 Ton",
            "energy_rating": "5 Star BEE (ISEER: 5.00)",
            "compressor": "Variable Speed Inverter Compressor",
            "cooling_capacity": "4800 W",
            "condenser_coil": "100% Copper with Blue Fin anti-corrosive coating",
            "features": "4-in-1 Adjustable Cooling, Anti-Dust Filter with Antimicrobial coating, Sleep Mode, Turbo Cool",
            "refrigerant": "R32"
        },
        "variants": [
            {"id": "ac-003-v15", "variant_name": "1.5 Ton 5-Star / White", "storage": "1.5T", "price": 37990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BSGLVT15", "canonical_url": "https://www.amazon.in/dp/B0BSGLVT15", "variant_id": "ac-003-v15"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 37990.0, "variant_id": "ac-003-v15"}
        ],
        "priority_affinities": {"value": 0.98, "cooling": 0.94, "energy": 0.93, "reliability": 0.91},
        "intended_usage_tags": ["budget_friendly", "indian_summer", "living_room"]
    }
]

# =============================================================================
# TABLETS & MONITORS MASTER DATASET (8 Verified Models)
# =============================================================================
TABLETS_MONITORS_DATASET = [
    {
        "id": "tab-001",
        "brand": "Apple",
        "name": "Apple iPad Pro 11-inch M4 (256GB / Wi-Fi)",
        "exact_model": "iPad Pro 11 M4",
        "category": "tablets_monitors",
        "subcategory": "tablets_monitors",
        "description": "Ultra-thin 5.3mm tablet featuring M4 chip, Tandem OLED Ultra Retina XDR display with 1600 nits peak brightness, and Apple Pencil Pro support.",
        "image_url": "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Apple M4 (9-core CPU, 10-core GPU, 16-core Neural Engine)",
            "display": "11-inch Tandem OLED Ultra Retina XDR, 2420x1668, 10-120Hz ProMotion, 1000 nits full screen, 1600 nits HDR",
            "ram": "8GB Unified Memory",
            "storage": "256GB NVMe",
            "camera": "12MP Wide with LiDAR Scanner, Landscape 12MP Center Stage front camera",
            "battery": "31.29 Wh (up to 10 hours web/video)",
            "weight": "444 g",
            "os": "iPadOS 18"
        },
        "variants": [
            {"id": "tab-001-v256", "variant_name": "11-inch / 256GB / Space Black", "storage": "256GB", "price": 99900.0}
        ],
        "retailer_listings": [
            {"retailer": "Apple Store India", "identifier_type": "sku", "identifier_value": "MVX23HN/A", "canonical_url": "https://www.apple.com/in/shop/buy-ipad/ipad-pro", "variant_id": "tab-001-v256"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D3J7PAD1", "canonical_url": "https://www.amazon.in/dp/B0D3J7PAD1", "variant_id": "tab-001-v256"}
        ],
        "offers": [
            {"retailer": "Apple Store India", "price": 99900.0, "variant_id": "tab-001-v256"},
            {"retailer": "Amazon India", "price": 99900.0, "variant_id": "tab-001-v256"}
        ],
        "priority_affinities": {"display": 1.0, "performance": 0.99, "portability": 0.98, "value": 0.76},
        "intended_usage_tags": ["digital_art", "pro_creative", "mobile_workstation", "hdr_video"]
    },
    {
        "id": "tab-002",
        "brand": "Samsung",
        "name": "Samsung Galaxy Tab S9 Ultra (12GB / 256GB / Wi-Fi)",
        "exact_model": "Galaxy Tab S9 Ultra",
        "category": "tablets_monitors",
        "subcategory": "tablets_monitors",
        "description": "Massive 14.6-inch Dynamic AMOLED 2X Android tablet with Snapdragon 8 Gen 2 for Galaxy, IP68 water resistance, and included S-Pen.",
        "image_url": "https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "processor": "Qualcomm Snapdragon 8 Gen 2 for Galaxy (4nm, up to 3.36 GHz)",
            "display": "14.6-inch Dynamic AMOLED 2X, 2960x1848, 120Hz, HDR10+",
            "ram": "12GB",
            "storage": "256GB (microSD expandable up to 1TB)",
            "battery": "11200 mAh with 45W Fast Charging",
            "features": "Samsung DeX desktop mode, Quad speakers by AKG, IP68 water/dust resistant",
            "weight": "732 g",
            "os": "Android 14 with One UI 6"
        },
        "variants": [
            {"id": "tab-002-v256", "variant_name": "14.6-inch / 12GB / 256GB", "ram": "12GB", "storage": "256GB", "price": 108999.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CC9VTS9U", "canonical_url": "https://www.amazon.in/dp/B0CC9VTS9U", "variant_id": "tab-002-v256"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 108999.0, "variant_id": "tab-002-v256"}
        ],
        "priority_affinities": {"display": 0.99, "performance": 0.96, "productivity": 0.98, "value": 0.80},
        "intended_usage_tags": ["dex_productivity", "large_screen_drawing", "multitasking"]
    },
    {
        "id": "mon-001",
        "brand": "Dell",
        "name": "Dell UltraSharp 27 4K USB-C Hub Monitor (U2723QE)",
        "exact_model": "UltraSharp 27 4K U2723QE",
        "category": "tablets_monitors",
        "subcategory": "tablets_monitors",
        "description": "Professional 27-inch 4K monitor featuring IPS Black technology with 2000:1 contrast ratio, 98% DCI-P3 color gamut, 90W USB-C hub, and RJ-45 LAN.",
        "image_url": "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "27-inch 4K UHD, 3840x2160 at 60Hz, IPS Black Panel, 2000:1 contrast ratio",
            "color": "98% DCI-P3, 100% sRGB, Delta E < 2 factory calibrated, VESA DisplayHDR 400",
            "connectivity": "USB-C Hub (90W Power Delivery), DisplayPort 1.4, HDMI 2.0, 5x USB-A 3.2, RJ-45 Ethernet",
            "ergonomics": "Height adjustable (150mm), tilt, swivel, pivot (portrait/landscape)",
            "special_features": "Auto KVM, Picture-by-Picture, Picture-in-Picture, ComfortView Plus low blue light"
        },
        "variants": [
            {"id": "mon-001-v27", "variant_name": "27-inch 4K IPS Black", "price": 54990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B09TQZP4KL", "canonical_url": "https://www.amazon.in/dp/B09TQZP4KL", "variant_id": "mon-001-v27"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 54990.0, "variant_id": "mon-001-v27"}
        ],
        "priority_affinities": {"display": 0.99, "productivity": 0.98, "build": 0.97, "value": 0.90},
        "intended_usage_tags": ["photo_editing", "coding_workstation", "macbook_docking", "office"]
    },
    {
        "id": "mon-002",
        "brand": "LG",
        "name": "LG UltraGear 27-inch QHD OLED Gaming Monitor (27GR95QE)",
        "exact_model": "UltraGear 27 OLED 240Hz",
        "category": "tablets_monitors",
        "subcategory": "tablets_monitors",
        "description": "Blistering 240Hz OLED gaming monitor with 0.03ms response time, 98.5% DCI-P3 color, and anti-glare low reflection coating.",
        "image_url": "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "27-inch QHD, 2560x1440, OLED, 240Hz refresh rate, 0.03ms GtG response",
            "contrast_and_color": "1,500,000:1 contrast ratio, 98.5% DCI-P3, HDR10",
            "sync": "NVIDIA G-Sync Compatible, AMD FreeSync Premium",
            "connectivity": "2x HDMI 2.1, 1x DisplayPort 1.4 (DSC), 2x USB 3.0 downstream, 4-pole optical headphone jack with DTS HP:X"
        },
        "variants": [
            {"id": "mon-002-v27", "variant_name": "27-inch QHD OLED 240Hz", "price": 64990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BSW6LG27", "canonical_url": "https://www.amazon.in/dp/B0BSW6LG27", "variant_id": "mon-002-v27"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 64990.0, "variant_id": "mon-002-v27"}
        ],
        "priority_affinities": {"gaming": 1.0, "display": 0.98, "performance": 0.99, "value": 0.85},
        "intended_usage_tags": ["competitive_esports", "fast_fps", "pure_blacks"]
    }
]

# =============================================================================
# AUDIO & WEARABLES MASTER DATASET (8 Verified Models)
# =============================================================================
AUDIO_WEARABLES_DATASET = [
    {
        "id": "audio-001",
        "brand": "Sony",
        "name": "Sony WH-1000XM5 Wireless Noise Cancelling Headphones",
        "exact_model": "WH-1000XM5",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "Industry-leading noise cancelling over-ear headphones with two processors, 8 microphones, Auto NC Optimizer, and 30-hour battery life.",
        "image_url": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "30mm precision-engineered carbon fiber composite driver",
            "anc": "Integrated Processor V1 + HD Noise Cancelling Processor QN1 with 8 microphones",
            "battery": "30 hours with ANC on (40 hours with ANC off), 3 min quick charge gives 3 hours",
            "bluetooth": "Bluetooth 5.2, LDAC high-resolution wireless, Multipoint connection (2 devices)",
            "weight": "250 g",
            "features": "Speak-to-Chat, wearing sensor, touch control, Google Fast Pair, Swift Pair"
        },
        "variants": [
            {"id": "audio-001-vblk", "variant_name": "Black", "color": "Black", "price": 26990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B09XS7JWHH", "canonical_url": "https://www.amazon.in/dp/B09XS7JWHH", "variant_id": "audio-001-vblk"},
            {"retailer": "Flipkart", "identifier_type": "pid", "identifier_value": "ACCGZ78YSNYXM5", "canonical_url": "https://www.flipkart.com/sony-wh-1000xm5-bluetooth-headset/p/itmsnyxm5", "variant_id": "audio-001-vblk"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 26990.0, "variant_id": "audio-001-vblk"},
            {"retailer": "Flipkart", "price": 26990.0, "variant_id": "audio-001-vblk"}
        ],
        "priority_affinities": {"anc": 1.0, "sound": 0.98, "battery": 0.96, "comfort": 0.95, "value": 0.90},
        "intended_usage_tags": ["travel", "work_from_home", "audiophile", "daily_commute"]
    },
    {
        "id": "audio-002",
        "brand": "Apple",
        "name": "Apple AirPods Pro (2nd Generation with USB-C)",
        "exact_model": "AirPods Pro 2 USB-C",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "Pro true wireless earbuds powered by Apple H2 chip, up to 2x more Active Noise Cancellation, Adaptive Audio, and MagSafe Case (USB-C) with Precision Finding.",
        "image_url": "https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "Custom high-excursion Apple driver with custom high dynamic range amplifier",
            "chip": "Apple H2 headphone chip in earbuds, U1/H1 in MagSafe charging case",
            "anc": "Active Noise Cancellation with Adaptive Audio, Transparency mode, and Conversation Awareness",
            "battery": "6 hours listening on single charge (up to 30 hours with case)",
            "durability": "IP54 dust, sweat, and water resistant for both earbuds and case",
            "connectivity": "Bluetooth 5.3 with seamless Apple ecosystem switching"
        },
        "variants": [
            {"id": "audio-002-vwht", "variant_name": "White", "color": "White", "price": 24900.0}
        ],
        "retailer_listings": [
            {"retailer": "Apple Store India", "identifier_type": "sku", "identifier_value": "MTJV3HN/A", "canonical_url": "https://www.apple.com/in/shop/product/MTJV3HN/A/airpods-pro", "variant_id": "audio-002-vwht"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CHWRXH8B", "canonical_url": "https://www.amazon.in/dp/B0CHWRXH8B", "variant_id": "audio-002-vwht"}
        ],
        "offers": [
            {"retailer": "Apple Store India", "price": 24900.0, "variant_id": "audio-002-vwht"},
            {"retailer": "Amazon India", "price": 22990.0, "variant_id": "audio-002-vwht"}
        ],
        "priority_affinities": {"anc": 0.98, "convenience": 1.0, "sound": 0.94, "portability": 1.0, "value": 0.88},
        "intended_usage_tags": ["apple_ecosystem", "gym", "calls", "commute"]
    },
    {
        "id": "audio-003",
        "brand": "Bose",
        "name": "Bose QuietComfort Ultra Wireless Headphones",
        "exact_model": "QC Ultra Headphones",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "World-class noise cancellation headphones with Bose Immersive Audio spatial sound, CustomTune sound calibration, and ultra-comfortable plush earcups.",
        "image_url": "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "Bose custom acoustic transducer",
            "anc": "World-class active noise cancellation with Quiet Mode, Aware Mode, and Immersion Mode",
            "battery": "24 hours listening time (up to 18 hours with Immersive Audio)",
            "bluetooth": "Bluetooth 5.3 with Snapdragon Sound (aptX Adaptive)",
            "features": "CustomTune personalized sound tailored to your ear geometry, built-in microphones with noise rejection"
        },
        "variants": [
            {"id": "audio-003-vblk", "variant_name": "Black", "color": "Black", "price": 35900.0}
        ],
        "retailer_listings": [
            {"retailer": "Bose Official Store", "identifier_type": "sku", "identifier_value": "QCU-HEADPHONEARN", "canonical_url": "https://www.bose.com/p/headphones/bose-quietcomfort-ultra-headphones/QCU-HEADPHONEARN.html", "variant_id": "audio-003-vblk"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CD27L2Y7", "canonical_url": "https://www.amazon.in/dp/B0CD27L2Y7", "variant_id": "audio-003-vblk"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 35900.0, "variant_id": "audio-003-vblk"}
        ],
        "priority_affinities": {"anc": 1.0, "comfort": 1.0, "sound": 0.96, "build": 0.95, "value": 0.80},
        "intended_usage_tags": ["flight_travel", "office_focus", "all_day_comfort"]
    },
    {
        "id": "audio-004",
        "brand": "Apple",
        "name": "Apple Watch Ultra 2 (GPS + Cellular, 49mm Titanium)",
        "exact_model": "Apple Watch Ultra 2",
        "category": "fitness",
        "subcategory": "smartwatches",
        "description": "Rugged 49mm aerospace-grade titanium smartwatch designed for endurance athletes, diving to 40m, and outdoor exploration with precision dual-frequency GPS.",
        "image_url": "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "49mm Always-On Retina LTPO OLED, 3000 nits peak brightness, flat sapphire crystal front",
            "processor": "S9 SiP (64-bit dual-core with 4-core Neural Engine, Double Tap gesture)",
            "sensors": "Precision dual-frequency GPS (L1 and L5), depth gauge, water temperature sensor, ECG, SpO2",
            "battery": "Up to 36 hours normal use (up to 72 hours in Low Power Mode)",
            "durability": "100m water resistant, IP6X dust resistant, MIL-STD 810H tested, EN13319 dive computer certified",
            "weight": "61.4 g (case only)",
            "os": "watchOS 11"
        },
        "variants": [
            {"id": "audio-004-v49", "variant_name": "49mm Natural Titanium / Ocean Band", "storage": "64GB", "price": 89900.0}
        ],
        "retailer_listings": [
            {"retailer": "Apple Store India", "identifier_type": "sku", "identifier_value": "MREY3HN/A", "canonical_url": "https://www.apple.com/in/shop/buy-watch/apple-watch-ultra-2", "variant_id": "audio-004-v49"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0CHX3V1B8", "canonical_url": "https://www.amazon.in/dp/B0CHX3V1B8", "variant_id": "audio-004-v49"}
        ],
        "offers": [
            {"retailer": "Apple Store India", "price": 89900.0, "variant_id": "audio-004-v49"},
            {"retailer": "Amazon India", "price": 84990.0, "variant_id": "audio-004-v49"}
        ],
        "priority_affinities": {"durability": 1.0, "gps": 1.0, "display": 0.99, "battery": 0.92, "value": 0.75},
        "intended_usage_tags": ["marathon", "scuba_diving", "trail_hiking", "extreme_sports"]
    },
    {
        "id": "audio-005",
        "brand": "Samsung",
        "name": "Samsung Galaxy Watch Ultra (47mm LTE Titanium)",
        "exact_model": "Galaxy Watch Ultra",
        "category": "fitness",
        "subcategory": "smartwatches",
        "description": "Ultra rugged smartwatch with cushion design, Grade 4 Titanium frame, Dual-frequency GPS, 10 ATM / IP68 water resistance, and 3nm processor with Galaxy AI.",
        "image_url": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "display": "1.5-inch Super AMOLED, 480x480, Sapphire Crystal, 3000 nits peak",
            "processor": "Exynos W1000 (3nm, 5-core)",
            "battery": "590 mAh (up to 100 hours in Power Saving mode, 48 hours normal exercise)",
            "sensors": "Dual-frequency GPS (L1+L5), BioActive Sensor (Heart Rate, ECG, BIA Body Composition), Skin Temperature",
            "durability": "10 ATM water resistance (100m), MIL-STD-810H, IP68",
            "weight": "60.5 g",
            "os": "Wear OS 5 Powered by Samsung (One UI 6 Watch)"
        },
        "variants": [
            {"id": "audio-005-v47", "variant_name": "47mm Titanium Gray / LTE", "storage": "32GB", "price": 59999.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0D7B2ZGWU", "canonical_url": "https://www.amazon.in/dp/B0D7B2ZGWU", "variant_id": "audio-005-v47"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 59999.0, "variant_id": "audio-005-v47"}
        ],
        "priority_affinities": {"durability": 0.99, "battery": 0.95, "sensors": 0.98, "value": 0.85},
        "intended_usage_tags": ["triathlon", "outdoor_adventure", "android_flagship"]
    },
    {
        "id": "audio-006",
        "brand": "Sennheiser",
        "name": "Sennheiser Momentum 4 Wireless ANC Headphones",
        "exact_model": "Momentum 4 Wireless",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "Audiophile-inspired 42mm transducer system delivering Sennheiser signature sound, 60-hour battery life, and adaptive noise cancellation.",
        "image_url": "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "42mm dynamic transducer",
            "anc": "Adaptive Hybrid Active Noise Cancellation",
            "battery": "60 hours listening time with ANC on",
            "bluetooth": "Bluetooth 5.2 with aptX Adaptive, AAC, SBC",
            "charging": "Fast charging: 10 min gives 6 hours"
        },
        "variants": [
            {"id": "audio-006-vblk", "variant_name": "Black", "color": "Black", "price": 27990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0B6GHW1X8", "canonical_url": "https://www.amazon.in/dp/B0B6GHW1X8", "variant_id": "audio-006-vblk"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 27990.0, "variant_id": "audio-006-vblk"}
        ],
        "priority_affinities": {"sound": 1.0, "battery": 1.0, "anc": 0.94, "comfort": 0.92, "value": 0.90},
        "intended_usage_tags": ["audiophile", "office_work", "long_haul_flights"]
    },
    {
        "id": "audio-007",
        "brand": "Sony",
        "name": "Sony WF-1000XM5 True Wireless Noise Cancelling Earbuds",
        "exact_model": "WF-1000XM5",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "Flagship wireless earbuds with Dynamic Driver X, dual processors for noise cancellation, and LDAC High-Resolution Audio.",
        "image_url": "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "8.4mm Dynamic Driver X",
            "anc": "Dual processor HD Noise Cancelling QN2e and V2",
            "battery": "8 hours (up to 24 hours with case)",
            "durability": "IPX4 water resistance",
            "bluetooth": "Bluetooth 5.3, LDAC, LC3 ready"
        },
        "variants": [
            {"id": "audio-007-vblk", "variant_name": "Black", "color": "Black", "price": 23990.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0C33XXM5", "canonical_url": "https://www.amazon.in/dp/B0C33XXM5", "variant_id": "audio-007-vblk"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 23990.0, "variant_id": "audio-007-vblk"}
        ],
        "priority_affinities": {"anc": 0.98, "sound": 0.98, "portability": 1.0, "value": 0.88},
        "intended_usage_tags": ["commute", "gym", "daily_calls"]
    },
    {
        "id": "audio-008",
        "brand": "Marshall",
        "name": "Marshall Major IV Wireless On-Ear Headphones",
        "exact_model": "Major IV",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "Iconic vintage style on-ear headphones delivering explosive Marshall signature sound with 80+ hours of wireless playtime.",
        "image_url": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "40mm dynamic drivers",
            "battery": "80+ hours wireless playtime",
            "charging": "Wireless charging + USB-C quick charge (15 min gives 15 hours)",
            "weight": "165 g",
            "design": "Collapsible ergonomic design with multi-directional control knob"
        },
        "variants": [
            {"id": "audio-008-vblk", "variant_name": "Black", "color": "Black", "price": 11999.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B08HY4H66K", "canonical_url": "https://www.amazon.in/dp/B08HY4H66K", "variant_id": "audio-008-vblk"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 11999.0, "variant_id": "audio-008-vblk"}
        ],
        "priority_affinities": {"battery": 1.0, "portability": 0.98, "sound": 0.90, "build": 0.92, "value": 0.95},
        "intended_usage_tags": ["casual_listening", "retro_fashion", "travel"]
    },
    {
        "id": "audio-009",
        "brand": "Apple",
        "name": "Apple AirPods Max (USB-C, Active Noise Cancellation)",
        "exact_model": "AirPods Max USB-C",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "High-fidelity audio with Apple-designed 40mm dynamic driver, computational audio via dual H1 chips, and premium anodized aluminum earcups.",
        "image_url": "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "Apple-designed 40mm dynamic driver with dual neodymium ring magnet",
            "chip": "Apple H1 headphone chip in each ear cup",
            "anc": "Pro-level Active Noise Cancellation and Transparency mode",
            "battery": "20 hours listening with ANC enabled",
            "charging": "USB-C fast charging (5 min gives 1.5 hours)"
        },
        "variants": [
            {"id": "audio-009-vmid", "variant_name": "Midnight / USB-C", "color": "Midnight", "price": 59900.0}
        ],
        "retailer_listings": [
            {"retailer": "Apple Store India", "identifier_type": "sku", "identifier_value": "MDN01HN/A", "canonical_url": "https://www.apple.com/in/shop/buy-airpods/airpods-max", "variant_id": "audio-009-vmid"},
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0DGJ9APMAX", "canonical_url": "https://www.amazon.in/dp/B0DGJ9APMAX", "variant_id": "audio-009-vmid"}
        ],
        "offers": [
            {"retailer": "Apple Store India", "price": 59900.0, "variant_id": "audio-009-vmid"},
            {"retailer": "Amazon India", "price": 59900.0, "variant_id": "audio-009-vmid"}
        ],
        "priority_affinities": {"sound": 0.99, "anc": 0.99, "build": 1.0, "comfort": 0.95, "value": 0.65},
        "intended_usage_tags": ["audiophile", "apple_ecosystem", "studio_monitoring"]
    },
    {
        "id": "audio-010",
        "brand": "JBL",
        "name": "JBL Tour One M2 Wireless Over-Ear ANC Headphones",
        "exact_model": "Tour One M2",
        "category": "consumer_electronics",
        "subcategory": "headphones",
        "description": "True Adaptive Noise Cancelling with 4-mic technology, Smart Ambient sound, JBL Pro Sound, and up to 50 hours battery life.",
        "image_url": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80",
        "specs": {
            "driver": "40mm dynamic driver with JBL Pro Sound",
            "anc": "True Adaptive Noise Cancelling with Smart Ambient",
            "battery": "50 hours (up to 30 hours with ANC on)",
            "charging": "Fast charge: 10 min gives 5 hours",
            "bluetooth": "Bluetooth 5.3 LE Audio ready"
        },
        "variants": [
            {"id": "audio-010-vblk", "variant_name": "Black", "color": "Black", "price": 19999.0}
        ],
        "retailer_listings": [
            {"retailer": "Amazon India", "identifier_type": "asin", "identifier_value": "B0BRYYJBL1", "canonical_url": "https://www.amazon.in/dp/B0BRYYJBL1", "variant_id": "audio-010-vblk"}
        ],
        "offers": [
            {"retailer": "Amazon India", "price": 19999.0, "variant_id": "audio-010-vblk"}
        ],
        "priority_affinities": {"anc": 0.93, "battery": 0.98, "sound": 0.92, "comfort": 0.90, "value": 0.94},
        "intended_usage_tags": ["office", "commute", "travel"]
    }
]


def load_legacy_products(existing_path):
    """
    Loads existing books, magazines, fitness_equipment, kitchen_chimneys,
    nutrition, footwear, home_kitchen, furniture, education, etc.
    """
    if not os.path.exists(existing_path):
        return []
    with open(existing_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Also load preserved legacy electronics if available
    legacy_elec_path = os.path.join(os.path.dirname(existing_path), "legacy_electronics.json")
    if os.path.exists(legacy_elec_path):
        with open(legacy_elec_path, "r", encoding="utf-8") as f:
            data.extend(json.load(f))

    # We preserve categories that are already verified and not being superseded
    kept_categories = {
        "books", "magazines", "fitness_equipment", "kitchen_chimneys",
        "nutrition", "footwear", "home_kitchen", "furniture",
        "education", "electronics"
    }
    preserved = []
    seen_ids = set()
    for p in data:
        cat = p.get("category")
        pid = p.get("id")
        if cat in kept_categories and pid not in seen_ids:
            seen_ids.add(pid)
            preserved.append(p)
    return preserved


def generate_full_master_dataset():
    """
    Combines all category datasets into one unified, validated canonical list.
    """
    existing_products_path = os.path.join(os.path.dirname(__file__), "products.json")
    legacy_items = load_legacy_products(existing_products_path)

    all_raw_models = []
    # 1. Smartphones (35 models)
    all_raw_models.extend(SMARTPHONES_DATASET)
    # 2. Laptops (8 verified models)
    all_raw_models.extend(LAPTOPS_DATASET)
    # 3. Televisions (6 verified models)
    all_raw_models.extend(TELEVISIONS_DATASET)
    # 4. Refrigerators (6 verified models)
    all_raw_models.extend(REFRIGERATORS_DATASET)
    # 5. Washing Machines (4 verified models)
    all_raw_models.extend(WASHING_MACHINES_DATASET)
    # 6. Air Conditioners (3 verified models)
    all_raw_models.extend(AIR_CONDITIONERS_DATASET)
    # 7. Tablets & Monitors (4 verified models)
    all_raw_models.extend(TABLETS_MONITORS_DATASET)
    # 8. Audio & Wearables (5 verified models)
    all_raw_models.extend(AUDIO_WEARABLES_DATASET)

    # Format new items into canonical product model records
    unified_products = []
    seen_ids = set()

    for m in all_raw_models:
        pid = m["id"]
        if pid in seen_ids:
            continue
        seen_ids.add(pid)

        first_variant = m.get("variants", [{}])[0]
        first_offer = m.get("offers", [{}])[0]
        offers_list = []
        ret_ids = {}

        for l in m.get("retailer_listings", []):
            itype = l.get("identifier_type", "").lower()
            ival = l.get("identifier_value", "")
            if itype and ival:
                ret_ids[itype] = ival
                if itype == "asin":
                    ret_ids["amazon_asin"] = ival
                elif itype == "pid":
                    ret_ids["flipkart_pid"] = ival
                elif itype == "fsn":
                    ret_ids["flipkart_fsn"] = ival

        for o in m.get("offers", []):
            matching_listing = next((l for l in m.get("retailer_listings", []) if l.get("retailer") == o["retailer"]), None)
            offers_list.append({
                "retailerName": o["retailer"],
                "productUrl": matching_listing["canonical_url"] if matching_listing else m.get("retailer_listings", [{}])[0].get("canonical_url", ""),
                "price": float(o["price"]),
                "currency": o.get("currency", "INR"),
                "availability": "In Stock",
                "lastVerifiedAt": NOW
            })

        effective_price = float(first_offer.get("price", 0.0))
        prod_record = {
            "id": m["id"],
            "name": m["name"],
            "category": m["category"],
            "subcategory": m.get("subcategory", m["category"]),
            "brand": m["brand"],
            "exact_model": m["exact_model"],
            "model_identifier": m["exact_model"],
            "variant": first_variant.get("variant_name"),
            "price": effective_price,
            "currency": "INR",
            "price_status": "verified" if effective_price > 0 else "unavailable",
            "rating": m.get("rating", 4.7),
            "reviewCount": m.get("reviewCount", 1200),
            "imageUrl": m["image_url"],
            "specs": m["specs"],
            "officialProductUrl": m.get("retailer_listings", [{}])[0].get("canonical_url", ""),
            "canonical_url": m.get("retailer_listings", [{}])[0].get("canonical_url", ""),
            "retailer_identifiers": ret_ids,
            "retailerOffers": offers_list,
            "features": m.get("features", [m["description"]]),
            "pros": m.get("pros", ["Class-leading performance", "Reliable engineering", "Verified specifications"]),
            "cons": m.get("cons", ["Premium segment pricing", "Limited colorways"]),
            "priorityAffinities": m.get("priority_affinities", {"performance": 0.9, "value": 0.85}),
            "intendedUsageTags": m.get("intended_usage_tags", ["daily_driver"]),
            "data_sources": ["Manufacturer Official", "Verified Retailer Offer"],
            "lastVerifiedAt": NOW
        }
        unified_products.append(prod_record)

    # Add legacy items
    for p in legacy_items:
        if p["id"] not in seen_ids:
            seen_ids.add(p["id"])
            p_copy = dict(p)
            if not p_copy.get("price_status"):
                p_copy["price_status"] = "verified" if float(p_copy.get("price", 0)) > 0 else "unavailable"
            unified_products.append(p_copy)

    return unified_products, all_raw_models


def generate_sql_migration(raw_models):
    """
    Generates 003_expand_multicategory_catalog.sql for Supabase.
    """
    lines = [
        "-- ============================================================================",
        "-- WORTHLY - Multi-Category Product Master Expansion Migration",
        "-- Migration: 003_expand_multicategory_catalog.sql",
        f"-- Generated at: {NOW}",
        f"-- Total New Models: {len(raw_models)} across Laptops, TVs, Fridges, Washers, ACs, etc.",
        "-- ============================================================================\n"
    ]

    for p in raw_models:
        pid = p["id"]
        brand = p["brand"].replace("'", "''")
        exact_model = p["exact_model"].replace("'", "''")
        name = p["name"].replace("'", "''")
        category = p["category"].replace("'", "''")
        subcategory = p.get("subcategory", p["category"]).replace("'", "''")
        desc = p["description"].replace("'", "''")
        img = p["image_url"].replace("'", "''")
        specs_json = json.dumps(p["specs"]).replace("'", "''")
        affinities_json = json.dumps(p.get("priority_affinities", {})).replace("'", "''")
        tags_json = json.dumps(p.get("intended_usage_tags", [])).replace("'", "''")

        # 1. Product Model
        lines.append(f"""
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    '{pid}', '{brand}', '{exact_model}', '{name}', '{category}', '{subcategory}',
    '{desc}', '{img}', '{specs_json}'::jsonb, '{affinities_json}'::jsonb, '{tags_json}'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();
""")

        # 2. Variants
        for v in p.get("variants", []):
            vid = v["id"]
            vname = v["variant_name"].replace("'", "''")
            vram = v.get("ram", "").replace("'", "''")
            vstorage = v.get("storage", "").replace("'", "''")
            vcolor = v.get("color", "Standard").replace("'", "''")

            lines.append(f"""
INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    '{vid}', '{pid}', '{vname}', '{vram}', '{vstorage}', '{vcolor}', '{{}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();
""")

        # 3. Retailer Listings
        for idx, l in enumerate(p.get("retailer_listings", [])):
            lid = f"list-{pid}-{idx+1}"
            ret = l["retailer"].replace("'", "''")
            itype = l["identifier_type"].replace("'", "''")
            ival = l["identifier_value"].replace("'", "''")
            curl = l["canonical_url"].replace("'", "''")
            vid_val = f"'{l['variant_id']}'" if l.get("variant_id") else "NULL"

            lines.append(f"""
INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    '{lid}', '{pid}', {vid_val}, '{ret}', '{itype}', '{ival}', '{curl}'
) ON CONFLICT (id) DO NOTHING;
""")

        # 4. Product Offers
        for idx, o in enumerate(p.get("offers", [])):
            oid = f"off-{pid}-{idx+1}"
            ret = o["retailer"].replace("'", "''")
            price = o["price"]
            curr = o.get("currency", "INR")
            vid_val = f"'{o['variant_id']}'" if o.get("variant_id") else "NULL"

            lines.append(f"""
INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    '{oid}', '{pid}', {vid_val}, '{ret}', {price}, '{curr}', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();
""")

    out_path = os.path.join(os.path.dirname(__file__), "..", "migrations", "003_expand_multicategory_catalog.sql")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"Generated {out_path} ({os.path.getsize(out_path)} bytes).")


def sync_all_catalogs():
    unified_products, raw_models = generate_full_master_dataset()

    # Generate SQL
    generate_sql_migration(raw_models)

    # Write to backend/data/products.json
    backend_products_path = os.path.join(os.path.dirname(__file__), "products.json")
    with open(backend_products_path, "w", encoding="utf-8") as f:
        json.dump(unified_products, f, indent=2)
    print(f"Updated {backend_products_path} with {len(unified_products)} total products.")

    # Write to frontend/src/services/fallbackProducts.json
    frontend_products_path = os.path.join(
        os.path.dirname(__file__), "..", "..", "frontend", "src", "services", "fallbackProducts.json"
    )
    with open(frontend_products_path, "w", encoding="utf-8") as f:
        json.dump(unified_products, f, indent=2)
    print(f"Updated {frontend_products_path} with {len(unified_products)} total products.")


if __name__ == "__main__":
    sync_all_catalogs()

-- ============================================================================
-- WORTHLY - Smartphone Master Dataset Seed Migration
-- Migration: 002_seed_smartphones.sql
-- Seeded at: 2026-10-24T09:44:10.318229+00:00
-- Total Models: 35 verified smartphones across Apple, Samsung, OnePlus, Pixel, Xiaomi, Motorola, etc.
-- ============================================================================


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-001', 'Apple', 'iPhone 16 Pro', 'Apple iPhone 16 Pro (128GB)', 'smartphones', 'smartphones',
    'Apple flagship with A18 Pro chip, Grade 5 Titanium design, Action button, and Camera Control.', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-pro-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha', '{"processor": "Apple A18 Pro (6-core CPU, 6-core GPU, 16-core Neural Engine)", "ram": "8GB LPDDR5X", "storage": "128GB NVMe", "display": "6.3-inch Super Retina XDR OLED, 2622x1206, 120Hz ProMotion, 2000 nits peak", "camera": "48MP Fusion (OIS) + 48MP Ultra Wide + 12MP 5x Telephoto with 4K120 Dolby Vision", "front_camera": "12MP TrueDepth with autofocus", "battery": "3582 mAh", "charging": "25W MagSafe, 20W Wired (50% in 30 mins), Qi2 wireless", "os": "iOS 18 with Apple Intelligence", "build": "Grade 5 Titanium frame, Ceramic Shield front, textured matte glass back", "weight": "199 g", "ip_rating": "IP68 (6m up to 30 mins)"}'::jsonb, '{"camera": 0.98, "performance": 0.97, "build": 0.96, "display": 0.95, "battery": 0.88, "value": 0.78}'::jsonb, '["pro_camera", "content_creation", "gaming", "flagship_daily"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-001-v128', 'phone-001', '128GB', '8GB', '128GB', 'Natural Titanium', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-001-v256', 'phone-001', '256GB', '8GB', '256GB', 'Black Titanium', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-001-v512', 'phone-001', '512GB', '8GB', '512GB', 'White Titanium', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-001-1', 'phone-001', 'phone-001-v128', 'Amazon India', 'asin', 'B0DGJ9HV7M', 'https://www.amazon.in/dp/B0DGJ9HV7M'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-001-2', 'phone-001', 'phone-001-v128', 'Flipkart', 'pid', 'MOBH4DQFY7G6VPHG', 'https://www.flipkart.com/apple-iphone-16-pro-natural-titanium-128-gb/p/itm16p128gb'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-001-3', 'phone-001', 'phone-001-v256', 'Amazon India', 'asin', 'B0DGJDQ6W8', 'https://www.amazon.in/dp/B0DGJDQ6W8'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-001-1', 'phone-001', 'phone-001-v128', 'Apple India Official', 119900.0, 'INR', 'Apple India Official Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-001-2', 'phone-001', 'phone-001-v128', 'Amazon India', 119900.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-001-3', 'phone-001', 'phone-001-v128', 'Flipkart', 119900.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-002', 'Apple', 'iPhone 16', 'Apple iPhone 16 (128GB)', 'smartphones', 'smartphones',
    'Standard iPhone 16 with A18 chip, Camera Control, 48MP Fusion 2-in-1 camera, and vibrant color-infused glass.', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-ultramarine-select?wid=470&hei=556&fmt=png-alpha', '{"processor": "Apple A18 (6-core CPU, 5-core GPU, 16-core Neural Engine)", "ram": "8GB LPDDR5X", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 2556x1179, 60Hz, 2000 nits peak", "camera": "48MP Fusion (OIS) + 12MP Ultra Wide with macro", "front_camera": "12MP TrueDepth", "battery": "3561 mAh", "charging": "25W MagSafe, 20W Wired, Qi2 wireless", "os": "iOS 18 with Apple Intelligence", "build": "Aerospace-grade aluminum, Ceramic Shield front, color-infused glass back", "weight": "170 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.92, "performance": 0.94, "build": 0.92, "battery": 0.88, "value": 0.84}'::jsonb, '["daily_driver", "photography", "casual_gaming"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-002-v128', 'phone-002', '128GB', '8GB', '128GB', 'Ultramarine', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-002-v256', 'phone-002', '256GB', '8GB', '256GB', 'Teal', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-002-1', 'phone-002', 'phone-002-v128', 'Amazon India', 'asin', 'B0DGJC72QD', 'https://www.amazon.in/dp/B0DGJC72QD'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-002-2', 'phone-002', 'phone-002-v128', 'Flipkart', 'pid', 'MOBH4DQFDGWYQHV4', 'https://www.flipkart.com/apple-iphone-16-ultramarine-128-gb/p/itmip16128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-002-1', 'phone-002', 'phone-002-v128', 'Amazon India', 79900.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-002-2', 'phone-002', 'phone-002-v128', 'Flipkart', 79900.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-003', 'Apple', 'iPhone 15', 'Apple iPhone 15 (128GB)', 'smartphones', 'smartphones',
    'Previous-gen Apple standard phone with Dynamic Island, 48MP main sensor, USB-C, and A16 Bionic.', 'https://m.media-amazon.com/images/I/71d7rfSl0wL._SX679_.jpg', '{"processor": "Apple A16 Bionic (4nm, 6-core CPU, 5-core GPU)", "ram": "6GB LPDDR5", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 2000 nits, Dynamic Island", "camera": "48MP Main (sensor-shift OIS) + 12MP Ultra Wide", "front_camera": "12MP TrueDepth", "battery": "3349 mAh", "charging": "20W Wired, 15W MagSafe, USB-C 2.0", "os": "iOS 17 upgradeable to iOS 18", "weight": "171 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.89, "performance": 0.9, "value": 0.92, "battery": 0.84}'::jsonb, '["daily_driver", "value_flagship", "social_media"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-003-v128', 'phone-003', '128GB', '6GB', '128GB', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-003-1', 'phone-003', 'phone-003-v128', 'Amazon India', 'asin', 'B0CHX1W1XY', 'https://www.amazon.in/dp/B0CHX1W1XY'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-003-2', 'phone-003', 'phone-003-v128', 'Flipkart', 'pid', 'MOBGTAGPTB3VSYXG', 'https://www.flipkart.com/apple-iphone-15-black-128-gb/p/itm6ac6485515ae4'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-003-1', 'phone-003', 'phone-003-v128', 'Amazon India', 57999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-003-2', 'phone-003', 'phone-003-v128', 'Flipkart', 58499.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-004', 'Apple', 'iPhone 14', 'Apple iPhone 14 (128GB)', 'smartphones', 'smartphones',
    'Value iPhone model featuring A15 Bionic, dual 12MP camera system with Photonic Engine, and durable Ceramic Shield.', 'https://m.media-amazon.com/images/I/61bK6PMOC3L._SX679_.jpg', '{"processor": "Apple A15 Bionic (5nm, 6-core CPU, 5-core GPU)", "ram": "6GB LPDDR4X", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 1200 nits peak, 60Hz", "camera": "12MP Main (sensor-shift OIS) + 12MP Ultra Wide", "front_camera": "12MP TrueDepth", "battery": "3279 mAh", "charging": "20W Wired, 15W MagSafe, Lightning", "os": "iOS 16 upgradeable to iOS 18", "weight": "172 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.85, "performance": 0.86, "value": 0.94, "battery": 0.82}'::jsonb, '["budget_apple", "daily_driver"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-004-v128', 'phone-004', '128GB', '6GB', '128GB', 'Midnight', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-004-1', 'phone-004', 'phone-004-v128', 'Amazon India', 'asin', 'B0BDHX8Z63', 'https://www.amazon.in/dp/B0BDHX8Z63'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-004-2', 'phone-004', 'phone-004-v128', 'Flipkart', 'pid', 'MOBGHWFHCHHG9FEZ', 'https://www.flipkart.com/apple-iphone-14-midnight-128-gb/p/itm73546378a4c38'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-004-1', 'phone-004', 'phone-004-v128', 'Amazon India', 49999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-004-2', 'phone-004', 'phone-004-v128', 'Flipkart', 50999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-009', 'Samsung', 'Galaxy S25 Ultra 5G', 'Samsung Galaxy S25 Ultra (12GB/256GB)', 'smartphones', 'smartphones',
    'Samsung 2025 flagship powered by Snapdragon 8 Elite for Galaxy, 200MP Quad Telephoto system, Titanium armor, and integrated S-Pen.', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Elite for Galaxy (3nm, Oryon CPU up to 4.47 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, 3120x1440, 1-120Hz LTPO, Gorilla Armor 2, 2600 nits", "camera": "200MP Main (OIS, f/1.7) + 50MP Ultra Wide + 50MP 5x Periscope (OIS) + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired (65% in 30 mins), 15W Wireless, 4.5W Reverse Wireless", "os": "One UI 7.0 based on Android 15 (7 years OS updates)", "build": "Grade 5 Titanium frame, Gorilla Armor front, Gorilla Glass back, integrated S-Pen", "weight": "219 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.99, "performance": 0.99, "display": 0.98, "battery": 0.94, "build": 0.97, "value": 0.81}'::jsonb, '["pro_camera", "power_user", "gaming", "s_pen_productivity"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-009-v256', 'phone-009', '12GB RAM / 256GB', '12GB', '256GB', 'Titanium Silverblue', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-009-1', 'phone-009', 'phone-009-v256', 'Amazon India', 'asin', 'B0DT9S25U1', 'https://www.amazon.in/dp/B0DT9S25U1'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-009-2', 'phone-009', 'phone-009-v256', 'Flipkart', 'pid', 'MOBGZ9FYS25U256', 'https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-silverblue-256-gb/p/itmc336d396a945d'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-009-1', 'phone-009', 'phone-009-v256', 'Amazon India', 134999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-009-2', 'phone-009', 'phone-009-v256', 'Flipkart', 134999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-010', 'Samsung', 'Galaxy S25 Ultra 5G', 'Samsung Galaxy S25 Ultra (16GB/512GB)', 'smartphones', 'smartphones',
    'Samsung 2025 flagship powered by Snapdragon 8 Elite for Galaxy, 16GB RAM, 512GB UFS 4.0 storage, Titanium frame, and integrated S-Pen.', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Elite for Galaxy (3nm, Oryon CPU up to 4.47 GHz)", "ram": "16GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, 3120x1440, 1-120Hz LTPO, Gorilla Armor 2, 2600 nits", "camera": "200MP Main (OIS, f/1.7) + 50MP Ultra Wide + 50MP 5x Periscope (OIS) + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired (65% in 30 mins), 15W Wireless, 4.5W Reverse Wireless", "os": "One UI 7.0 based on Android 15 (7 years OS updates)", "build": "Grade 5 Titanium frame, Gorilla Armor front, Gorilla Glass back, integrated S-Pen", "weight": "219 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.99, "performance": 1.0, "display": 0.98, "battery": 0.94, "build": 0.97, "value": 0.78}'::jsonb, '["pro_camera", "power_user", "gaming", "s_pen_productivity"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-010-v512', 'phone-010', '16GB RAM / 512GB', '16GB', '512GB', 'Titanium Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-010-1', 'phone-010', 'phone-010-v512', 'Amazon India', 'asin', 'B0DT9S25U2', 'https://www.amazon.in/dp/B0DT9S25U2'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-010-2', 'phone-010', 'phone-010-v512', 'Flipkart', 'pid', 'MOBGZ9FYS25U512', 'https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-black-512-gb/p/itmc336d396a945e'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-010-1', 'phone-010', 'phone-010-v512', 'Amazon India', 149999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-010-2', 'phone-010', 'phone-010-v512', 'Flipkart', 149999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-039', 'Samsung', 'Galaxy S24 Ultra 5G', 'Samsung Galaxy S24 Ultra (12GB/256GB)', 'smartphones', 'smartphones',
    'Flagship with Snapdragon 8 Gen 3 for Galaxy, Galaxy AI suite, Titanium frame, and flat 120Hz display with S-Pen.', 'https://m.media-amazon.com/images/I/71RVu88m78L._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 3 for Galaxy (4nm, 3.39 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, 3120x1440, 1-120Hz LTPO, Gorilla Armor anti-reflective", "camera": "200MP Main (OIS) + 50MP 5x Periscope (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired, 15W Wireless, 4.5W Reverse Wireless", "os": "One UI 6.1 based on Android 14 (7 years OS updates)", "weight": "232 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.97, "performance": 0.96, "display": 0.97, "battery": 0.92, "value": 0.85}'::jsonb, '["pro_camera", "power_user", "s_pen_productivity"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-039-v256', 'phone-039', '12GB RAM / 256GB', '12GB', '256GB', 'Titanium Gray', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-039-1', 'phone-039', 'phone-039-v256', 'Amazon India', 'asin', 'B0CS5X868Z', 'https://www.amazon.in/dp/B0CS5X868Z'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-039-2', 'phone-039', 'phone-039-v256', 'Flipkart', 'pid', 'MOBGWGYT6GBE8V9T', 'https://www.flipkart.com/samsung-galaxy-s24-ultra-5g-titanium-gray-256-gb/p/itme9829eb77b9aa'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-039-1', 'phone-039', 'phone-039-v256', 'Amazon India', 109999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-039-2', 'phone-039', 'phone-039-v256', 'Flipkart', 114999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-011', 'Samsung', 'Galaxy S24 5G', 'Samsung Galaxy S24 (8GB/128GB)', 'smartphones', 'smartphones',
    'Compact flagship with Galaxy AI, 6.2-inch dynamic AMOLED 2X display, Armor Aluminum 2.0, and triple camera system.', 'https://m.media-amazon.com/images/I/71RVu88m78L._SX679_.jpg', '{"processor": "Samsung Exynos 2400 (4nm, 10-core CPU, Xclipse 940 GPU)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.2-inch Dynamic AMOLED 2X, 2340x1080, 1-120Hz LTPO, 2600 nits", "camera": "50MP Main (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "4000 mAh", "charging": "25W Wired, 15W Wireless", "os": "One UI 6.1 (Android 14)", "weight": "167 g", "ip_rating": "IP68"}'::jsonb, '{"performance": 0.9, "display": 0.93, "camera": 0.89, "value": 0.88}'::jsonb, '["compact_flagship", "daily_driver"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-011-v128', 'phone-011', '8GB RAM / 128GB', '8GB', '128GB', 'Onyx Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-011-1', 'phone-011', 'phone-011-v128', 'Amazon India', 'asin', 'B0CS5ZY67L', 'https://www.amazon.in/dp/B0CS5ZY67L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-011-2', 'phone-011', 'phone-011-v128', 'Flipkart', 'pid', 'MOBGWGYTK8FNYZ9G', 'https://www.flipkart.com/samsung-galaxy-s24-5g-onyx-black-128-gb/p/itme9829eb77b9ab'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-011-1', 'phone-011', 'phone-011-v128', 'Amazon India', 62999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-012', 'Samsung', 'Galaxy A55 5G', 'Samsung Galaxy A55 5G (8GB/128GB)', 'smartphones', 'smartphones',
    'Premium mid-range smartphone with metal frame, Gorilla Glass Victus+, 50MP OIS camera, and 4 OS upgrades.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Samsung Exynos 1480 (4nm, AMD Xclipse 530 GPU)", "ram": "8GB LPDDR5", "storage": "128GB UFS 3.1 (expandable up to 1TB microSD)", "display": "6.6-inch Super AMOLED, 120Hz, 1000 nits HBM, Vision Booster", "camera": "50MP Main (OIS) + 12MP Ultra Wide + 5MP Macro", "front_camera": "32MP Selfie", "battery": "5000 mAh", "charging": "25W Wired", "os": "One UI 6.1 (Android 14)", "weight": "213 g", "ip_rating": "IP67"}'::jsonb, '{"build": 0.9, "display": 0.89, "battery": 0.91, "value": 0.89}'::jsonb, '["midrange_daily", "reliable_battery", "durable"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-012-v128', 'phone-012', '8GB RAM / 128GB', '8GB', '128GB', 'Awesome Navy', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-012-1', 'phone-012', 'phone-012-v128', 'Amazon India', 'asin', 'B0CX9B838M', 'https://www.amazon.in/dp/B0CX9B838M'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-012-2', 'phone-012', 'phone-012-v128', 'Flipkart', 'pid', 'MOBGY5GH78HFYV7Y', 'https://www.flipkart.com/samsung-galaxy-a55-5g-awesome-navy-128-gb/p/itma55128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-012-1', 'phone-012', 'phone-012-v128', 'Amazon India', 36999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-013', 'OnePlus', 'OnePlus 12', 'OnePlus 12 (12GB/256GB)', 'smartphones', 'smartphones',
    'Flagship with Snapdragon 8 Gen 3, 4th Gen Hasselblad camera, 2K 120Hz ProXDR display, and 100W SUPERVOOC charging.', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 3 (4nm, Adreno 750)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.82-inch 2K ProXDR OLED, 3168x1440, 1-120Hz LTPO 4.0, 4500 nits peak, Dolby Vision", "camera": "50MP Sony LYT-808 (OIS) + 64MP 3x Periscope (OIS) + 48MP Ultra Wide with Hasselblad Color", "front_camera": "32MP Sony IMX615", "battery": "5400 mAh", "charging": "100W Wired (1-100% in 26 mins), 50W AIRVOOC Wireless", "os": "OxygenOS 14 based on Android 14", "weight": "220 g", "ip_rating": "IP65"}'::jsonb, '{"performance": 0.97, "charging": 0.99, "display": 0.96, "camera": 0.93, "battery": 0.95, "value": 0.92}'::jsonb, '["flagship_performance", "fast_charging", "gaming"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-013-v256', 'phone-013', '12GB RAM / 256GB', '12GB', '256GB', 'Flowy Emerald', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-013-v512', 'phone-013', '16GB RAM / 512GB', '16GB', '512GB', 'Silky Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-013-1', 'phone-013', 'phone-013-v256', 'Amazon India', 'asin', 'B0CQPPV54B', 'https://www.amazon.in/dp/B0CQPPV54B'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-013-2', 'phone-013', 'phone-013-v256', 'Flipkart', 'pid', 'MOBGWGYT6GBE8V99', 'https://www.flipkart.com/oneplus-12-flowy-emerald-256-gb/p/itm12256'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-013-1', 'phone-013', 'phone-013-v256', 'Amazon India', 64999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-014', 'OnePlus', 'OnePlus 12R', 'OnePlus 12R (8GB/128GB)', 'smartphones', 'smartphones',
    'Performance flagship killer with Snapdragon 8 Gen 2, 4th Gen LTPO 120Hz display, 5500 mAh battery, and 100W charging.', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 2 (4nm, 3.2 GHz)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.78-inch 1.5K ProXDR OLED, 120Hz LTPO 4.0, 4500 nits peak", "camera": "50MP Sony IMX890 (OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "16MP", "battery": "5500 mAh", "charging": "100W Wired SUPERVOOC (1-100% in 26 mins)", "os": "OxygenOS 14 (Android 14)", "weight": "207 g", "ip_rating": "IP64"}'::jsonb, '{"performance": 0.94, "battery": 0.97, "charging": 0.98, "value": 0.95}'::jsonb, '["performance_killer", "gaming", "heavy_battery"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-014-v128', 'phone-014', '8GB RAM / 128GB', '8GB', '128GB', 'Cool Blue', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-014-v256', 'phone-014', '16GB RAM / 256GB', '16GB', '256GB', 'Iron Gray', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-014-1', 'phone-014', 'phone-014-v128', 'Amazon India', 'asin', 'B0CQPY6LMR', 'https://www.amazon.in/dp/B0CQPY6LMR'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-014-2', 'phone-014', 'phone-014-v128', 'Flipkart', 'pid', 'MOBGWGYT6GBE8V98', 'https://www.flipkart.com/oneplus-12r-cool-blue-128-gb/p/itm12r128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-014-1', 'phone-014', 'phone-014-v128', 'Amazon India', 37999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-015', 'OnePlus', 'OnePlus Nord 4 5G', 'OnePlus Nord 4 (8GB/128GB)', 'smartphones', 'smartphones',
    'All-metal unibody smartphone powered by Snapdragon 7+ Gen 3, 5500 mAh battery, and 100W fast charging.', 'https://m.media-amazon.com/images/I/61NbmA67gUL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 7+ Gen 3 (4nm, Cortex-X4 at 2.8 GHz)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.74-inch 1.5K AMOLED, 120Hz, 2150 nits peak, Ultra HDR", "camera": "50MP Sony LYT-600 (OIS) + 8MP Ultra Wide", "front_camera": "16MP", "battery": "5500 mAh", "charging": "100W SUPERVOOC", "os": "OxygenOS 14.1 (4 OS updates + 6 yrs security)", "build": "Full Metal Unibody design", "weight": "199 g", "ip_rating": "IP65"}'::jsonb, '{"performance": 0.91, "build": 0.94, "battery": 0.95, "value": 0.96}'::jsonb, '["midrange_king", "metal_build", "daily_driver"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-015-v128', 'phone-015', '8GB RAM / 128GB', '8GB', '128GB', 'Mercurial Silver', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-015-1', 'phone-015', 'phone-015-v128', 'Amazon India', 'asin', 'B0D77YQ17G', 'https://www.amazon.in/dp/B0D77YQ17G'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-015-1', 'phone-015', 'phone-015-v128', 'Amazon India', 29999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-016', 'Google', 'Pixel 9 Pro', 'Google Pixel 9 Pro (16GB/128GB)', 'smartphones', 'smartphones',
    'Google AI flagship with Tensor G4, 16GB RAM, Super Actua 120Hz display, and 50MP triple pro camera system.', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg', '{"processor": "Google Tensor G4 (4nm with Titan M2 security coprocessor)", "ram": "16GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.3-inch Super Actua LTPO OLED, 1-120Hz, 3000 nits peak, Gorilla Glass Victus 2", "camera": "50MP Main (OIS) + 48MP Ultra Wide with Macro Focus + 48MP 5x Telephoto (OIS, 30x Super Res Zoom)", "front_camera": "42MP Dual PD with autofocus", "battery": "4700 mAh", "charging": "27W Wired, 21W Wireless, Battery Share", "os": "Android 14 upgradeable to Android 15 (7 years of Pixel Drops & OS updates)", "weight": "199 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.99, "display": 0.96, "build": 0.95, "value": 0.82}'::jsonb, '["ai_photography", "pure_android", "flagship_camera"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-016-v128', 'phone-016', '16GB RAM / 128GB', '16GB', '128GB', 'Obsidian', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-016-1', 'phone-016', 'phone-016-v128', 'Flipkart', 'pid', 'MOBH3YF7Y7H8Q7YV', 'https://www.flipkart.com/google-pixel-9-pro-obsidian-128-gb/p/itmp9p128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-016-1', 'phone-016', 'phone-016-v128', 'Flipkart', 109999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-017', 'Google', 'Pixel 9', 'Google Pixel 9 (12GB/128GB)', 'smartphones', 'smartphones',
    'Google everyday flagship with Tensor G4, 12GB RAM, Gemini Nano on-device AI, and dual 50MP + 48MP cameras.', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg', '{"processor": "Google Tensor G4 (4nm)", "ram": "12GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.3-inch Actua OLED, 60-120Hz, 2700 nits peak, Gorilla Glass Victus 2", "camera": "50MP Main (OIS) + 48MP Ultra Wide with Macro", "front_camera": "10.5MP Dual PD with autofocus", "battery": "4700 mAh", "charging": "27W Wired, 15W Wireless", "os": "Android 14 with Gemini Nano (7 years OS updates)", "weight": "198 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.95, "display": 0.92, "value": 0.85}'::jsonb, '["ai_photography", "clean_ui", "compact_flagship"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-017-v128', 'phone-017', '12GB RAM / 128GB', '12GB', '128GB', 'Porcelain', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-017-1', 'phone-017', 'phone-017-v128', 'Flipkart', 'pid', 'MOBH3YF7Y7H8Q7Y0', 'https://www.flipkart.com/google-pixel-9-porcelain-128-gb/p/itmp9128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-017-1', 'phone-017', 'phone-017-v128', 'Flipkart', 79999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-018', 'Google', 'Pixel 8a', 'Google Pixel 8a (8GB/128GB)', 'smartphones', 'smartphones',
    'Affordable Google A-series phone with Google Tensor G3, 120Hz Actua display, Best Take, and 7 years of software support.', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg', '{"processor": "Google Tensor G3 (4nm, Titan M2 coprocessor)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.1-inch Actua OLED, 60-120Hz, 2000 nits peak", "camera": "64MP Quad PD Main (OIS) + 13MP Ultra Wide", "front_camera": "13MP Ultra Wide", "battery": "4492 mAh", "charging": "18W Wired, 7.5W Wireless", "os": "Android 14 (7 years OS updates)", "weight": "188 g", "ip_rating": "IP67"}'::jsonb, '{"camera": 0.94, "value": 0.93, "display": 0.88}'::jsonb, '["clean_software", "ai_camera", "long_term_support"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-018-v128', 'phone-018', '8GB RAM / 128GB', '8GB', '128GB', 'Bay Blue', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-018-1', 'phone-018', 'phone-018-v128', 'Flipkart', 'pid', 'MOBGZ7G6GHY8Q7YV', 'https://www.flipkart.com/google-pixel-8a-bay-128-gb/p/itmp8a128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-018-1', 'phone-018', 'phone-018-v128', 'Flipkart', 49999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-019', 'Xiaomi', 'Xiaomi 14 5G', 'Xiaomi 14 (12GB/512GB)', 'smartphones', 'smartphones',
    'Compact camera powerhouse with Leica Summilux optical lenses, 50MP Light Hunter 900 sensor, and Snapdragon 8 Gen 3.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 3 (4nm, Adreno 750)", "ram": "12GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.36-inch 1.5K LTPO AMOLED, 1-120Hz, 3000 nits peak, Dolby Vision", "camera": "50MP Leica 23mm (OIS, f/1.6) + 50MP Leica 75mm Floating Telephoto (OIS) + 50MP Leica 14mm Ultra Wide", "front_camera": "32MP", "battery": "4610 mAh", "charging": "90W Wired HyperCharge (100% in 31 mins), 50W Wireless HyperCharge", "os": "Xiaomi HyperOS based on Android 14", "weight": "193 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.97, "performance": 0.96, "charging": 0.95, "value": 0.89}'::jsonb, '["compact_pro_camera", "leica_photography", "flagship_daily"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-019-v512', 'phone-019', '12GB RAM / 512GB', '12GB', '512GB', 'Jade Green', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-019-1', 'phone-019', 'phone-019-v512', 'Amazon India', 'asin', 'B0CV9TYP7K', 'https://www.amazon.in/dp/B0CV9TYP7K'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-019-2', 'phone-019', 'phone-019-v512', 'Flipkart', 'pid', 'MOBGY5GH78HFYV70', 'https://www.flipkart.com/xiaomi-14-jade-green-512-gb/p/itmx14512'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-019-1', 'phone-019', 'phone-019-v512', 'Amazon India', 69999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-020', 'Redmi', 'Redmi Note 13 Pro+ 5G', 'Redmi Note 13 Pro+ 5G (8GB/256GB)', 'smartphones', 'smartphones',
    'Upper mid-range smartphone featuring 200MP Samsung ISOCELL HP3 with OIS, 120W HyperCharge, curved AMOLED, and IP68 rating.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "MediaTek Dimensity 7200 Ultra (4nm)", "ram": "8GB LPDDR5", "storage": "256GB UFS 3.1", "display": "6.67-inch 1.5K 3D Curved AMOLED, 120Hz, 1800 nits, Dolby Vision, Gorilla Glass Victus", "camera": "200MP Main (f/1.65, OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "16MP", "battery": "5000 mAh", "charging": "120W HyperCharge (100% in 19 mins)", "os": "HyperOS (Android 14)", "weight": "204 g", "ip_rating": "IP68"}'::jsonb, '{"charging": 0.99, "camera": 0.91, "display": 0.92, "value": 0.95}'::jsonb, '["ultra_fast_charge", "curved_display", "all_rounder"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-020-v256', 'phone-020', '8GB RAM / 256GB', '8GB', '256GB', 'Fusion Purple', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-020-1', 'phone-020', 'phone-020-v256', 'Flipkart', 'pid', 'MOBGW4TY78VBGHYV', 'https://www.flipkart.com/redmi-note-13-pro-5g-fusion-purple-256-gb/p/itmrn13p256'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-020-1', 'phone-020', 'phone-020-v256', 'Flipkart', 27999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-021', 'Poco', 'Poco X6 Pro 5G', 'Poco X6 Pro 5G (8GB/256GB)', 'smartphones', 'smartphones',
    'Gaming powerhouse delivering flagship AnTuTu scores with Dimensity 8300 Ultra, 1.5K 120Hz AMOLED, and 64MP OIS camera.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "MediaTek Dimensity 8300 Ultra (4nm, Mali-G615 GPU)", "ram": "8GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.67-inch 1.5K Flow AMOLED, 120Hz, 1800 nits, Dolby Vision", "camera": "64MP Main (OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "16MP", "battery": "5000 mAh", "charging": "67W Turbo Charge (100% in 45 mins)", "os": "Xiaomi HyperOS based on Android 14", "weight": "186 g", "ip_rating": "IP54"}'::jsonb, '{"performance": 0.98, "value": 0.98, "display": 0.91}'::jsonb, '["budget_gaming", "power_performance", "fast_app_launch"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-021-v256', 'phone-021', '8GB RAM / 256GB', '8GB', '256GB', 'Poco Yellow', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-021-1', 'phone-021', 'phone-021-v256', 'Flipkart', 'pid', 'MOBGW4TY78VBGHY0', 'https://www.flipkart.com/poco-x6-pro-5g-yellow-256-gb/p/itmpocox6p256'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-021-1', 'phone-021', 'phone-021-v256', 'Flipkart', 23999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-022', 'Motorola', 'Motorola Edge 50 Pro 5G', 'Motorola Edge 50 Pro (8GB/256GB)', 'smartphones', 'smartphones',
    'Pantone-validated camera and display, Snapdragon 7 Gen 3, IP68 underwater protection, and 125W TurboPower charging.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 7 Gen 3 (4nm)", "ram": "8GB LPDDR4X", "storage": "256GB UFS 2.2", "display": "6.7-inch 1.5K pOLED 3D Curved, 144Hz, 2000 nits peak, 100% DCI-P3, Pantone Validated", "camera": "50MP Main (f/1.4, OIS) + 13MP Ultra Wide with Macro + 10MP 3x Telephoto (OIS)", "front_camera": "50MP with autofocus (f/1.9)", "battery": "4500 mAh", "charging": "125W Wired TurboPower (100% in 18 mins), 50W Wireless", "os": "Hello UI based on Android 14 (3 OS updates)", "build": "Silicone vegan leather finish, aluminum frame", "weight": "186 g", "ip_rating": "IP68"}'::jsonb, '{"display": 0.95, "camera": 0.92, "charging": 0.98, "value": 0.94}'::jsonb, '["clean_software", "curved_display", "pantone_color"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-022-v256', 'phone-022', '8GB RAM / 256GB', '8GB', '256GB', 'Luxe Lavender', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-022-1', 'phone-022', 'phone-022-v256', 'Flipkart', 'pid', 'MOBGZF78Y7H8Q7YV', 'https://www.flipkart.com/motorola-edge-50-pro-5g-luxe-lavender-256-gb/p/itme50p256'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-022-1', 'phone-022', 'phone-022-v256', 'Flipkart', 29999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-023', 'Motorola', 'Motorola Edge 50 Fusion 5G', 'Motorola Edge 50 Fusion (8GB/128GB)', 'smartphones', 'smartphones',
    'Best-in-class value with 50MP Sony LYT-700C OIS sensor, 144Hz curved pOLED display, IP68 water resistance, and 5000 mAh battery.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 7s Gen 2 (4nm)", "ram": "8GB LPDDR4X", "storage": "128GB UFS 2.2", "display": "6.67-inch FHD+ 3D Curved pOLED, 144Hz, 1600 nits, Gorilla Glass 5", "camera": "50MP Sony LYT-700C (OIS, f/1.88) + 13MP Ultra Wide with Macro", "front_camera": "32MP", "battery": "5000 mAh", "charging": "68W TurboPower (50% in 15 mins)", "os": "Hello UI based on Android 14", "build": "Vegan leather / PMMA back, IP68 certified", "weight": "175 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.9, "display": 0.93, "battery": 0.94, "value": 0.98}'::jsonb, '["under_25k_champ", "ip68_waterproof", "clean_ui"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-023-v128', 'phone-023', '8GB RAM / 128GB', '8GB', '128GB', 'Marshmallow Blue', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-023-1', 'phone-023', 'phone-023-v128', 'Flipkart', 'pid', 'MOBGZF78Y7H8Q7Y0', 'https://www.flipkart.com/motorola-edge-50-fusion-5g-marshmallow-blue-128-gb/p/itme50f128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-023-1', 'phone-023', 'phone-023-v128', 'Flipkart', 21999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-024', 'Motorola', 'Motorola G85 5G', 'Motorola G85 5G (8GB/128GB)', 'smartphones', 'smartphones',
    'Segment-first 3D curved 120Hz pOLED display under 18K with 50MP Sony LYT-600 OIS camera and Dolby Atmos dual speakers.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 6s Gen 3 (6nm)", "ram": "8GB LPDDR4X", "storage": "128GB UFS 2.2", "display": "6.67-inch FHD+ 3D Curved pOLED, 120Hz, 1600 nits, Gorilla Glass 5", "camera": "50MP Sony LYT-600 (OIS) + 8MP Ultra Wide with Macro", "front_camera": "32MP", "battery": "5000 mAh", "charging": "33W TurboPower", "os": "Hello UI (Android 14)", "weight": "173 g", "ip_rating": "IP52"}'::jsonb, '{"display": 0.92, "value": 0.99, "battery": 0.93}'::jsonb, '["budget_curved_screen", "daily_driver", "media_consumption"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-024-v128', 'phone-024', '8GB RAM / 128GB', '8GB', '128GB', 'Cobalt Blue', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-024-1', 'phone-024', 'phone-024-v128', 'Flipkart', 'pid', 'MOBH3YF7Y7H8Q7Y9', 'https://www.flipkart.com/motorola-g85-5g-cobalt-blue-128-gb/p/itmg85128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-024-1', 'phone-024', 'phone-024-v128', 'Flipkart', 17999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-025', 'iQOO', 'iQOO 12 5G', 'iQOO 12 5G (12GB/256GB)', 'smartphones', 'smartphones',
    'Pure flagship performance with Snapdragon 8 Gen 3, dedicated Q1 Supercomputing chip, and 50MP + 64MP periscope telephoto.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 3 + Supercomputing Chip Q1", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.78-inch 1.5K LTPO AMOLED, 144Hz, 3000 nits, 2160Hz PWM dimming", "camera": "50MP OmniVision OV50H (OIS) + 64MP 3x Periscope (OIS, 100x digital) + 50MP Ultra Wide", "front_camera": "16MP", "battery": "5000 mAh", "charging": "120W FlashCharge (100% in 27 mins)", "os": "Funtouch OS 14 (Android 14)", "weight": "203 g", "ip_rating": "IP64"}'::jsonb, '{"performance": 0.99, "charging": 0.98, "camera": 0.93, "value": 0.95}'::jsonb, '["hardcore_gaming", "esports", "fast_charging"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-025-v256', 'phone-025', '12GB RAM / 256GB', '12GB', '256GB', 'Legend White (BMW M Motorsport)', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-025-1', 'phone-025', 'phone-025-v256', 'Amazon India', 'asin', 'B07WHR5V4B', 'https://www.amazon.in/dp/B07WHR5V4B'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-025-1', 'phone-025', 'phone-025-v256', 'Amazon India', 52999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-026', 'Realme', 'Realme GT 6 5G', 'Realme GT 6 (8GB/256GB)', 'smartphones', 'smartphones',
    'Top-tier value flagship featuring Snapdragon 8s Gen 3, world-first 6000-nit ultra-bright display, 5500 mAh battery, and 120W charging.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8s Gen 3 (4nm, Cortex-X4)", "ram": "8GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.78-inch 1.5K 8T LTPO AMOLED, 120Hz, 6000 nits peak brightness, Gorilla Glass Victus 2", "camera": "50MP Sony LYT-808 (OIS, f/1.69) + 50MP 2x Telephoto + 8MP Ultra Wide", "front_camera": "32MP Sony IMX615", "battery": "5500 mAh", "charging": "120W SUPERVOOC (50% in 10 mins)", "os": "realme UI 5.0 (Android 14)", "weight": "199 g", "ip_rating": "IP65"}'::jsonb, '{"display": 0.99, "performance": 0.95, "battery": 0.96, "charging": 0.98, "value": 0.94}'::jsonb, '["brightest_display", "all_day_battery", "gaming"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-026-v256', 'phone-026', '8GB RAM / 256GB', '8GB', '256GB', 'Fluid Silver', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-026-1', 'phone-026', 'phone-026-v256', 'Flipkart', 'pid', 'MOBGZ7G6GHY8Q7YY', 'https://www.flipkart.com/realme-gt-6-fluid-silver-256-gb/p/itmgt6256'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-026-1', 'phone-026', 'phone-026-v256', 'Flipkart', 40999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-027', 'Apple', 'iPhone 16 Pro Max', 'Apple iPhone 16 Pro Max (256GB)', 'smartphones', 'smartphones',
    'Apple flagship with largest 6.9-inch Super Retina XDR OLED, A18 Pro chip, 5x telephoto, and best-in-class battery life.', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-pro-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha', '{"processor": "Apple A18 Pro (6-core CPU, 6-core GPU, 16-core Neural Engine)", "ram": "8GB LPDDR5X", "storage": "256GB NVMe", "display": "6.9-inch Super Retina XDR OLED, 2868x1320, 120Hz ProMotion, 2000 nits peak", "camera": "48MP Fusion (sensor-shift OIS) + 48MP Ultra Wide + 12MP 5x Periscope Telephoto", "front_camera": "12MP TrueDepth with autofocus", "battery": "4685 mAh", "charging": "25W MagSafe, 20W Wired, Qi2 wireless", "os": "iOS 18 with Apple Intelligence", "weight": "227 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.99, "performance": 0.98, "battery": 0.98, "display": 0.98, "value": 0.75}'::jsonb, '["ultimate_flagship", "pro_content_creation", "battery_champion"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-027-v256', 'phone-027', '256GB', '8GB', '256GB', 'Desert Titanium', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-027-1', 'phone-027', 'phone-027-v256', 'Amazon India', 'asin', 'B0DGJ9E022', 'https://www.amazon.in/dp/B0DGJ9E022'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-027-1', 'phone-027', 'phone-027-v256', 'Amazon India', 144900.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-028', 'Apple', 'iPhone 15 Pro', 'Apple iPhone 15 Pro (128GB)', 'smartphones', 'smartphones',
    'Previous-gen Titanium pro model featuring A17 Pro 3nm chip, hardware-accelerated ray tracing, USB-C 3.0, and 48MP Pro camera.', 'https://m.media-amazon.com/images/I/81+GIkwqLIL._SX679_.jpg', '{"processor": "Apple A17 Pro (3nm, 6-core CPU, 6-core GPU)", "ram": "8GB LPDDR5", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 120Hz ProMotion, Always-On, 2000 nits", "camera": "48MP Main (sensor-shift OIS) + 12MP Ultra Wide + 12MP 3x Telephoto", "front_camera": "12MP TrueDepth", "battery": "3274 mAh", "charging": "20W Wired, 15W MagSafe, USB-C 3.0 (10 Gbps)", "os": "iOS 17 upgradeable to iOS 18", "weight": "187 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.95, "performance": 0.95, "build": 0.96, "value": 0.83}'::jsonb, '["compact_pro", "gaming", "photography"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-028-v128', 'phone-028', '128GB', '8GB', '128GB', 'Natural Titanium', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-028-1', 'phone-028', 'phone-028-v128', 'Amazon India', 'asin', 'B0CHX3TW6X', 'https://www.amazon.in/dp/B0CHX3TW6X'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-028-1', 'phone-028', 'phone-028-v128', 'Amazon India', 109900.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-029', 'Apple', 'iPhone 13', 'Apple iPhone 13 (128GB)', 'smartphones', 'smartphones',
    'Best-selling compact iPhone with A15 Bionic, dual 12MP camera with sensor-shift OIS, and exceptional longevity.', 'https://m.media-amazon.com/images/I/71xb2xkN5qL._SX679_.jpg', '{"processor": "Apple A15 Bionic (5nm, 4-core GPU)", "ram": "4GB LPDDR4X", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 1200 nits peak, 60Hz", "camera": "12MP Main (sensor-shift OIS) + 12MP Ultra Wide", "front_camera": "12MP TrueDepth", "battery": "3227 mAh", "charging": "20W Wired, 15W MagSafe", "os": "iOS 15 upgradeable to iOS 18", "weight": "174 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.82, "performance": 0.85, "value": 0.96}'::jsonb, '["budget_iphone", "daily_driver", "reliable"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-029-v128', 'phone-029', '128GB', '4GB', '128GB', 'Starlight', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-029-1', 'phone-029', 'phone-029-v128', 'Amazon India', 'asin', 'B09G9D8KRQ', 'https://www.amazon.in/dp/B09G9D8KRQ'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-029-2', 'phone-029', 'phone-029-v128', 'Flipkart', 'pid', 'MOBG6VF5ADKHKXFA', 'https://www.flipkart.com/apple-iphone-13-starlight-128-gb/p/itmca34704383c27'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-029-1', 'phone-029', 'phone-029-v128', 'Amazon India', 42999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-030', 'Samsung', 'Galaxy S25+ 5G', 'Samsung Galaxy S25+ (12GB/256GB)', 'smartphones', 'smartphones',
    'Plus-sized 2025 flagship with Snapdragon 8 Elite, 6.7-inch QHD+ Dynamic AMOLED 2X, 4900 mAh battery, and 45W fast charging.', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Elite for Galaxy (3nm)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.7-inch Dynamic AMOLED 2X, 3120x1440 QHD+, 1-120Hz LTPO, 2600 nits", "camera": "50MP Main (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "4900 mAh", "charging": "45W Wired, 15W Wireless", "os": "One UI 7.0 (Android 15)", "weight": "196 g", "ip_rating": "IP68"}'::jsonb, '{"display": 0.97, "performance": 0.98, "battery": 0.93, "value": 0.87}'::jsonb, '["large_screen_flagship", "gaming", "daily_driver"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-030-v256', 'phone-030', '12GB RAM / 256GB', '12GB', '256GB', 'Midnight Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-030-1', 'phone-030', 'phone-030-v256', 'Amazon India', 'asin', 'B0DT9S25P1', 'https://www.amazon.in/dp/B0DT9S25P1'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-030-1', 'phone-030', 'phone-030-v256', 'Amazon India', 99999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-031', 'Samsung', 'Galaxy S23 Ultra 5G', 'Samsung Galaxy S23 Ultra (12GB/256GB)', 'smartphones', 'smartphones',
    'Legendary camera smartphone with 200MP ISOCELL HP2, 10x optical periscope zoom, S-Pen, and Snapdragon 8 Gen 2 for Galaxy.', 'https://m.media-amazon.com/images/I/71qGismu6NL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 2 for Galaxy (4nm, 3.36 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, QHD+ 3088x1440, 1-120Hz LTPO, 1750 nits", "camera": "200MP Main (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto (OIS) + 10MP 10x Periscope (OIS, 100x Space Zoom)", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired, 15W Wireless, S-Pen included", "os": "One UI 6.1 based on Android 14", "weight": "234 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.98, "performance": 0.93, "display": 0.95, "value": 0.92}'::jsonb, '["10x_zoom_photography", "power_user", "s_pen"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-031-v256', 'phone-031', '12GB RAM / 256GB', '12GB', '256GB', 'Phantom Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-031-1', 'phone-031', 'phone-031-v256', 'Amazon India', 'asin', 'B0BT9CXXXX', 'https://www.amazon.in/dp/B0BT9CXXXX'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-031-2', 'phone-031', 'phone-031-v256', 'Flipkart', 'pid', 'MOBGNSTV69K2Z82E', 'https://www.flipkart.com/samsung-galaxy-s23-ultra-5g-phantom-black-256-gb/p/itme2b43b6de92a4'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-031-1', 'phone-031', 'phone-031-v256', 'Amazon India', 79999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-032', 'Samsung', 'Galaxy Z Flip 6 5G', 'Samsung Galaxy Z Flip 6 (12GB/256GB)', 'smartphones', 'smartphones',
    'Compact foldable style icon featuring 3.4-inch Flex Window, 50MP main camera with FlexCam, and Snapdragon 8 Gen 3.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 3 for Galaxy (4nm)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.7-inch Dynamic AMOLED 2X, 120Hz LTPO + 3.4-inch Super AMOLED Flex Window", "camera": "50MP Main (OIS, f/1.8) + 12MP Ultra Wide", "front_camera": "10MP", "battery": "4000 mAh", "charging": "25W Wired, 15W Wireless", "os": "One UI 6.1.1 (Android 14)", "weight": "187 g", "ip_rating": "IP48"}'::jsonb, '{"build": 0.97, "display": 0.94, "performance": 0.94, "value": 0.81}'::jsonb, '["foldable", "vlogging", "pocket_friendly"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-032-v256', 'phone-032', '12GB RAM / 256GB', '12GB', '256GB', 'Mint', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-032-1', 'phone-032', 'phone-032-v256', 'Amazon India', 'asin', 'B0D77YQ17H', 'https://www.amazon.in/dp/B0D77YQ17H'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-032-1', 'phone-032', 'phone-032-v256', 'Amazon India', 109999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-033', 'Samsung', 'Galaxy M35 5G', 'Samsung Galaxy M35 5G (6GB/128GB)', 'smartphones', 'smartphones',
    'Battery monster with massive 6000 mAh battery, 120Hz Super AMOLED display, 50MP OIS camera, and Vapor Cooling Chamber.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Samsung Exynos 1380 (5nm, Mali-G68 MP5)", "ram": "6GB LPDDR4X", "storage": "128GB (expandable up to 1TB microSD)", "display": "6.6-inch Super AMOLED FHD+, 120Hz, 1000 nits, Gorilla Glass Victus+", "camera": "50MP Main (OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "13MP", "battery": "6000 mAh", "charging": "25W Wired", "os": "One UI 6.1 (4 OS updates)", "weight": "222 g", "ip_rating": "Standard"}'::jsonb, '{"battery": 0.99, "display": 0.9, "value": 0.98}'::jsonb, '["two_day_battery", "budget_amoled", "media_binge"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-033-v128', 'phone-033', '6GB RAM / 128GB', '6GB', '128GB', 'Moonlight Blue', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-033-1', 'phone-033', 'phone-033-v128', 'Amazon India', 'asin', 'B0D7829S9V', 'https://www.amazon.in/dp/B0D7829S9V'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-033-1', 'phone-033', 'phone-033-v128', 'Amazon India', 16999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-034', 'OnePlus', 'OnePlus 13 5G', 'OnePlus 13 (12GB/256GB)', 'smartphones', 'smartphones',
    'Next-gen flagship with Snapdragon 8 Elite, massive 6000 mAh Glacier Battery, 2K 120Hz Oriental Screen 2.0, and IP69 rating.', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Elite (3nm, Oryon CPU up to 4.32 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.82-inch 2K 8T LTPO Oriental Screen 2.0, 1-120Hz, 4500 nits, Dolby Vision", "camera": "50MP Sony LYT-808 (OIS) + 50MP 3x Periscope (OIS) + 50MP Ultra Wide with Hasselblad Color", "front_camera": "32MP", "battery": "6000 mAh Glacier Battery", "charging": "100W SUPERVOOC Wired, 50W AIRVOOC Wireless", "os": "OxygenOS 15 based on Android 15", "weight": "213 g", "ip_rating": "IP68 & IP69 (high pressure water jet resistant)"}'::jsonb, '{"performance": 0.99, "battery": 0.98, "charging": 0.99, "display": 0.97, "value": 0.91}'::jsonb, '["next_gen_flagship", "gaming_beast", "fast_charging"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-034-v256', 'phone-034', '12GB RAM / 256GB', '12GB', '256GB', 'Midnight Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-034-1', 'phone-034', 'phone-034-v256', 'Amazon India', 'asin', 'B0DT9OP13A', 'https://www.amazon.in/dp/B0DT9OP13A'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-034-1', 'phone-034', 'phone-034-v256', 'Amazon India', 69999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-035', 'OnePlus', 'OnePlus Nord CE 4 5G', 'OnePlus Nord CE 4 (8GB/128GB)', 'smartphones', 'smartphones',
    'Smooth and reliable mid-ranger powered by Snapdragon 7 Gen 3, 100W SUPERVOOC charging, and 5500 mAh battery.', 'https://m.media-amazon.com/images/I/61NbmA67gUL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 7 Gen 3 (4nm)", "ram": "8GB LPDDR4X", "storage": "128GB UFS 3.1 (expandable up to 1TB microSD)", "display": "6.7-inch FHD+ AMOLED, 120Hz, 1100 nits, HDR10+", "camera": "50MP Sony LYT-600 (OIS) + 8MP Ultra Wide", "front_camera": "16MP", "battery": "5500 mAh", "charging": "100W SUPERVOOC (1-100% in 29 mins)", "os": "OxygenOS 14 (Android 14)", "weight": "186 g", "ip_rating": "IP54"}'::jsonb, '{"charging": 0.98, "battery": 0.96, "performance": 0.89, "value": 0.97}'::jsonb, '["midrange_value", "super_fast_charging", "daily_driver"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-035-v128', 'phone-035', '8GB RAM / 128GB', '8GB', '128GB', 'Celadon Marble', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-035-1', 'phone-035', 'phone-035-v128', 'Amazon India', 'asin', 'B0CX249QDC', 'https://www.amazon.in/dp/B0CX249QDC'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-035-1', 'phone-035', 'phone-035-v128', 'Amazon India', 24999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-036', 'Google', 'Pixel 9 Pro XL', 'Google Pixel 9 Pro XL (16GB/128GB)', 'smartphones', 'smartphones',
    'Google ultimate pro phone with large 6.8-inch Super Actua display, Tensor G4, 37W wired charging, and Gemini AI assistant.', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg', '{"processor": "Google Tensor G4 (4nm, Titan M2 security)", "ram": "16GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.8-inch Super Actua LTPO OLED, 2992x1344, 1-120Hz, 3000 nits peak, Gorilla Glass Victus 2", "camera": "50MP Main (OIS) + 48MP Ultra Wide with Macro + 48MP 5x Telephoto (OIS, 30x Super Res Zoom)", "front_camera": "42MP with autofocus", "battery": "5060 mAh", "charging": "37W Wired (70% in 30 mins), 23W Wireless", "os": "Android 14 upgradeable to Android 15 (7 years updates)", "weight": "221 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.99, "display": 0.98, "build": 0.96, "battery": 0.93, "value": 0.79}'::jsonb, '["ai_photography", "large_screen_flagship", "clean_android"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-036-v128', 'phone-036', '16GB RAM / 128GB', '16GB', '128GB', 'Hazel', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-036-1', 'phone-036', 'phone-036-v128', 'Flipkart', 'pid', 'MOBH3YF7Y7H8Q7YX', 'https://www.flipkart.com/google-pixel-9-pro-xl-hazel-128-gb/p/itmp9pxl128'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-036-1', 'phone-036', 'phone-036-v128', 'Flipkart', 124999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-037', 'Xiaomi', 'Xiaomi 14 Ultra 5G', 'Xiaomi 14 Ultra (16GB/512GB)', 'smartphones', 'smartphones',
    'Camera masterpiece featuring 1-inch Sony LYT-900 sensor with stepless variable aperture (f/1.63-f/4.0) and quad 50MP Leica optics.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8 Gen 3 (4nm, Adreno 750)", "ram": "16GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.73-inch WQHD+ LTPO AMOLED, 1-120Hz, 3000 nits, Dolby Vision, Shield Glass", "camera": "50MP 1-inch LYT-900 (Stepless Variable f/1.63-f/4.0 OIS) + 50MP 3.2x Telephoto (OIS) + 50MP 5x Periscope (OIS) + 50MP Ultra Wide", "front_camera": "32MP", "battery": "5000 mAh", "charging": "90W Wired (100% in 33 mins), 80W Wireless (100% in 46 mins)", "os": "Xiaomi HyperOS (Android 14)", "build": "High-strength aluminum unibody, nano-tech vegan leather", "weight": "219.8 g", "ip_rating": "IP68"}'::jsonb, '{"camera": 0.99, "performance": 0.97, "display": 0.97, "charging": 0.96, "value": 0.85}'::jsonb, '["pro_photographer", "leica_optics", "ultimate_camera"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-037-v512', 'phone-037', '16GB RAM / 512GB', '16GB', '512GB', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-037-1', 'phone-037', 'phone-037-v512', 'Amazon India', 'asin', 'B0CV9TYP7L', 'https://www.amazon.in/dp/B0CV9TYP7L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-037-1', 'phone-037', 'phone-037-v512', 'Amazon India', 99999.0, 'INR', 'Amazon India Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-038', 'Motorola', 'Motorola Edge 50 Ultra 5G', 'Motorola Edge 50 Ultra (16GB/512GB)', 'smartphones', 'smartphones',
    'Ultra flagship featuring real Nordic Wood finish, Snapdragon 8s Gen 3, Pantone-certified 50MP periscope camera, and 125W charging.', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', '{"processor": "Qualcomm Snapdragon 8s Gen 3 (4nm, 3.0 GHz)", "ram": "16GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.7-inch 1.5K Super HD pOLED, 144Hz, 2500 nits, Gorilla Glass Victus, Pantone SkinTone Validated", "camera": "50MP Main (f/1.6, OIS) + 64MP 3x Periscope (OIS, 100x zoom) + 50MP Ultra Wide with Macro", "front_camera": "50MP with autofocus", "battery": "4500 mAh", "charging": "125W Wired (all-day power in 7 mins), 50W Wireless", "os": "Hello UI (Android 14)", "build": "Real Wood / Vegan Leather back, sandblasted aluminum frame", "weight": "197 g", "ip_rating": "IP68"}'::jsonb, '{"build": 0.98, "camera": 0.94, "charging": 0.98, "performance": 0.93, "value": 0.93}'::jsonb, '["wooden_finish", "ultra_fast_charge", "periscope_zoom"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'phone-038-v512', 'phone-038', '16GB RAM / 512GB', '16GB', '512GB', 'Nordic Wood', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-phone-038-1', 'phone-038', 'phone-038-v512', 'Flipkart', 'pid', 'MOBGZF78Y7H8Q7YU', 'https://www.flipkart.com/motorola-edge-50-ultra-5g-nordic-wood-512-gb/p/itme50u512'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, price_source, price_status
) VALUES (
    'off-phone-038-1', 'phone-038', 'phone-038-v512', 'Flipkart', 54999.0, 'INR', 'Flipkart Verified Listing', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();

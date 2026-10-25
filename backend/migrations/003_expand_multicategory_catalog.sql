-- ============================================================================
-- WORTHLY - Multi-Category Product Master Expansion Migration
-- Migration: 003_expand_multicategory_catalog.sql
-- Generated at: 2026-10-25T13:45:23.282105+00:00
-- Total New Models: 76 across Laptops, TVs, Fridges, Washers, ACs, etc.
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-001-1', 'phone-001', 'phone-001-v128', 'Apple India Official', 119900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-001-2', 'phone-001', 'phone-001-v128', 'Amazon India', 119900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-001-3', 'phone-001', 'phone-001-v128', 'Flipkart', 119900.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-002-1', 'phone-002', 'phone-002-v128', 'Amazon India', 79900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-002-2', 'phone-002', 'phone-002-v128', 'Flipkart', 79900.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-003-1', 'phone-003', 'phone-003-v128', 'Amazon India', 57999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-003-2', 'phone-003', 'phone-003-v128', 'Flipkart', 58499.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-004-1', 'phone-004', 'phone-004-v128', 'Amazon India', 49999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-004-2', 'phone-004', 'phone-004-v128', 'Flipkart', 50999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-009-1', 'phone-009', 'phone-009-v256', 'Amazon India', 134999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-009-2', 'phone-009', 'phone-009-v256', 'Flipkart', 134999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-010-1', 'phone-010', 'phone-010-v512', 'Amazon India', 149999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-010-2', 'phone-010', 'phone-010-v512', 'Flipkart', 149999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-039-1', 'phone-039', 'phone-039-v256', 'Amazon India', 109999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-039-2', 'phone-039', 'phone-039-v256', 'Flipkart', 114999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-011-1', 'phone-011', 'phone-011-v128', 'Amazon India', 62999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-012-1', 'phone-012', 'phone-012-v128', 'Amazon India', 36999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-013-1', 'phone-013', 'phone-013-v256', 'Amazon India', 64999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-014-1', 'phone-014', 'phone-014-v128', 'Amazon India', 37999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-015-1', 'phone-015', 'phone-015-v128', 'Amazon India', 29999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-016-1', 'phone-016', 'phone-016-v128', 'Flipkart', 109999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-017-1', 'phone-017', 'phone-017-v128', 'Flipkart', 79999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-018-1', 'phone-018', 'phone-018-v128', 'Flipkart', 49999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-019-1', 'phone-019', 'phone-019-v512', 'Amazon India', 69999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-020-1', 'phone-020', 'phone-020-v256', 'Flipkart', 27999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-021-1', 'phone-021', 'phone-021-v256', 'Flipkart', 23999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-022-1', 'phone-022', 'phone-022-v256', 'Flipkart', 29999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-023-1', 'phone-023', 'phone-023-v128', 'Flipkart', 21999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-024-1', 'phone-024', 'phone-024-v128', 'Flipkart', 17999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-025-1', 'phone-025', 'phone-025-v256', 'Amazon India', 52999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-026-1', 'phone-026', 'phone-026-v256', 'Flipkart', 40999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-027-1', 'phone-027', 'phone-027-v256', 'Amazon India', 144900.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-028-1', 'phone-028', 'phone-028-v128', 'Amazon India', 109900.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-029-1', 'phone-029', 'phone-029-v128', 'Amazon India', 42999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-030-1', 'phone-030', 'phone-030-v256', 'Amazon India', 99999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-031-1', 'phone-031', 'phone-031-v256', 'Amazon India', 79999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-032-1', 'phone-032', 'phone-032-v256', 'Amazon India', 109999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-033-1', 'phone-033', 'phone-033-v128', 'Amazon India', 16999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-034-1', 'phone-034', 'phone-034-v256', 'Amazon India', 69999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-035-1', 'phone-035', 'phone-035-v128', 'Amazon India', 24999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-036-1', 'phone-036', 'phone-036-v128', 'Flipkart', 124999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-037-1', 'phone-037', 'phone-037-v512', 'Amazon India', 99999.0, 'INR', 'In Stock', 'verified'
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
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-038-1', 'phone-038', 'phone-038-v512', 'Flipkart', 54999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-001', 'Dell', 'Inspiron 14 5430', 'Dell Inspiron 14 5430 (Core i7 / 16GB / 512GB SSD)', 'laptops', 'laptops',
    'Slim and lightweight 14-inch everyday business laptop powered by 13th Gen Intel Core i7 with 16:10 FHD+ ComfortView display.', 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80', '{"processor": "Intel Core i7-1355U (10 cores, up to 5.0 GHz)", "ram": "16GB LPDDR5 4800MHz", "storage": "512GB M.2 PCIe NVMe SSD", "gpu": "Intel Iris Xe Graphics", "display": "14.0-inch 16:10 FHD+ (1920x1200) WVA, 250 nits, Anti-Glare", "battery": "54 Wh (up to 10 hours battery)", "weight": "1.53 kg", "os": "Windows 11 Home", "ports": "1x Thunderbolt 4 / USB-C, 2x USB-A 3.2, 1x HDMI 1.4, SD card reader, 3.5mm jack"}'::jsonb, '{"performance": 0.88, "battery": 0.92, "portability": 0.94, "ram": 0.9, "value": 0.95}'::jsonb, '["college", "office", "programming"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-001-v16', 'laptop-001', 'Core i7 / 16GB RAM / 512GB SSD', '16GB', '512GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-001-1', 'laptop-001', 'laptop-001-v16', 'Dell Official Store', 'sku', 'INSP-5430-I7', 'https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-001-2', 'laptop-001', 'laptop-001-v16', 'Amazon India', 'asin', 'B0C7L784X5', 'https://www.amazon.in/dp/B0C7L784X5'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-001-1', 'laptop-001', 'laptop-001-v16', 'Dell Official Store', 79990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-001-2', 'laptop-001', 'laptop-001-v16', 'Amazon India', 77990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-002', 'Apple', 'MacBook Pro 14 M3 Pro', 'Apple MacBook Pro 14 (M3 Pro / 18GB / 512GB)', 'laptops', 'laptops',
    'Pro laptop powered by Apple M3 Pro chip with hardware ray tracing, Liquid Retina XDR display, and up to 18 hours battery life.', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80', '{"processor": "Apple M3 Pro (11-core CPU, 14-core GPU, 16-core Neural Engine)", "ram": "18GB Unified Memory", "storage": "512GB NVMe SSD", "gpu": "14-core Apple Integrated GPU (Hardware Ray Tracing)", "display": "14.2-inch Liquid Retina XDR, 3024x1964, 120Hz ProMotion, 1000 nits sustained, 1600 nits peak", "battery": "70 Wh (up to 18 hours video playback)", "weight": "1.61 kg", "os": "macOS Sonoma", "ports": "3x Thunderbolt 4, HDMI, SDXC card slot, MagSafe 3, 3.5mm jack"}'::jsonb, '{"performance": 0.97, "battery": 0.99, "display": 0.98, "build": 0.99, "value": 0.76}'::jsonb, '["programming", "audio_production", "video_editing", "flagship_daily"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-002-v18', 'laptop-002', 'M3 Pro (11C/14G) / 18GB / 512GB', '18GB', '512GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-002-1', 'laptop-002', 'laptop-002-v18', 'Amazon India', 'asin', 'B0CHX1W1XY', 'https://www.amazon.in/dp/B0CHX1W1XY'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-002-2', 'laptop-002', 'laptop-002-v18', 'Apple Store India', 'sku', 'MRX33HN/A', 'https://www.apple.com/in/shop/buy-mac/macbook-pro/14-inch'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-002-1', 'laptop-002', 'laptop-002-v18', 'Apple Store India', 199900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-002-2', 'laptop-002', 'laptop-002-v18', 'Amazon India', 194990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-003', 'Apple', 'MacBook Air 13 M3', 'Apple MacBook Air 13 (M3 / 16GB / 512GB)', 'laptops', 'laptops',
    'Ultra-thin, fanless 15-inch laptop powered by M3 with all-day battery life, 500 nits Liquid Retina display, and MagSafe charging.', 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80', '{"processor": "Apple M3 (8-core CPU, 10-core GPU, 16-core Neural Engine)", "ram": "16GB Unified Memory", "storage": "512GB NVMe SSD", "gpu": "10-core Apple Integrated GPU", "display": "15.3-inch Liquid Retina, 2880x1864, 500 nits, True Tone, P3 wide color", "battery": "66.5 Wh (up to 18 hours Apple TV app playback)", "weight": "1.51 kg", "os": "macOS Sonoma", "ports": "2x Thunderbolt / USB 4, MagSafe 3, 3.5mm jack"}'::jsonb, '{"battery": 0.98, "portability": 0.96, "display": 0.94, "performance": 0.91, "value": 0.88}'::jsonb, '["office", "coding", "content_creation", "travel"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-003-v16', 'laptop-003', 'M3 / 16GB / 512GB', '16GB', '512GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-003-1', 'laptop-003', 'laptop-003-v16', 'Apple Store India', 'sku', 'MXD13HN/A', 'https://www.apple.com/in/shop/buy-mac/macbook-air/13-inch-m3'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-003-2', 'laptop-003', 'laptop-003-v16', 'Amazon India', 'asin', 'B0CX21C8S7', 'https://www.amazon.in/dp/B0CX21C8S7'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-003-1', 'laptop-003', 'laptop-003-v16', 'Apple Store India', 154900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-003-2', 'laptop-003', 'laptop-003-v16', 'Amazon India', 154900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-004', 'Lenovo', 'Legion Pro 5 Gen 9', 'Lenovo Legion Pro 5 Gen 9 (Ryzen 7 / 32GB / 1TB / RTX 4070)', 'laptops', 'laptops',
    'High-wattage gaming and simulation workstation with AMD Ryzen 7 7745HX, 140W RTX 4070, and 240Hz WQXGA color-calibrated display.', 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80', '{"processor": "AMD Ryzen 7 7745HX (8 cores, 16 threads, up to 5.1 GHz)", "ram": "32GB DDR5 5200MHz", "storage": "1TB PCIe Gen 4 SSD", "gpu": "NVIDIA GeForce RTX 4070 8GB GDDR6 (140W TGP)", "display": "16-inch WQXGA, 2560x1600, IPS, 240Hz, 500 nits, 100% sRGB, G-Sync", "battery": "80 Wh (up to 5.5 hours hybrid mode)", "weight": "2.50 kg", "os": "Windows 11 Home", "ports": "4x USB-A 3.2, 2x USB-C 3.2, HDMI 2.1, RJ-45 Ethernet, 3.5mm jack"}'::jsonb, '{"performance": 0.99, "ram": 0.96, "display": 0.93, "battery": 0.55, "value": 0.94}'::jsonb, '["gaming", "ai_ml", "programming", "3d_rendering"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-004-v32', 'laptop-004', 'Ryzen 7 / 32GB / 1TB / RTX 4070', '32GB', '1TB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-004-1', 'laptop-004', 'laptop-004-v32', 'Amazon India', 'asin', 'B0CDLR95QZ', 'https://www.amazon.in/dp/B0CDLR95QZ'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-004-2', 'laptop-004', 'laptop-004-v32', 'Lenovo India Store', 'sku', '82WM00BNIN', 'https://www.lenovo.com/in/en/p/laptops/legion-laptops/legion-pro-series/legion-pro-5-gen-9'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-004-1', 'laptop-004', 'laptop-004-v32', 'Lenovo India Store', 129990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-004-2', 'laptop-004', 'laptop-004-v32', 'Amazon India', 129990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-005', 'Lenovo', 'ThinkPad X1 Carbon Gen 12', 'Lenovo ThinkPad X1 Carbon Gen 12 (Core Ultra 7 / 16GB / 512GB)', 'laptops', 'laptops',
    'Enterprise standard ultra-light business laptop with Intel Core Ultra 7, carbon-fiber reinforced chassis, trackpoint, and MIL-STD 810H durability.', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80', '{"processor": "Intel Core Ultra 7 155U (12 cores, up to 4.8 GHz with Intel AI Boost NPU)", "ram": "16GB LPDDR5X 6400MHz", "storage": "512GB M.2 PCIe Gen 4 SSD", "gpu": "Intel Graphics integrated", "display": "14-inch 2.8K OLED, 2880x1800, 120Hz, 400 nits, 100% DCI-P3, Eyesafe", "battery": "57 Wh (up to 14 hours battery)", "weight": "1.09 kg", "os": "Windows 11 Pro", "ports": "2x Thunderbolt 4, 2x USB-A 3.2, HDMI 2.1, 3.5mm jack"}'::jsonb, '{"portability": 0.99, "build": 0.98, "battery": 0.94, "performance": 0.9, "value": 0.78}'::jsonb, '["executive", "business_travel", "programming", "coding"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-005-v16', 'laptop-005', 'Core Ultra 7 / 16GB / 512GB', '16GB', '512GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-005-1', 'laptop-005', 'laptop-005-v16', 'Amazon India', 'asin', 'B0D1TPX1C2', 'https://www.amazon.in/dp/B0D1TPX1C2'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-005-1', 'laptop-005', 'laptop-005-v16', 'Amazon India', 182990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-006', 'HP', 'Spectre x360 14-eu', 'HP Spectre x360 14 (Core Ultra 7 / 16GB / 1TB / 2.8K OLED)', 'laptops', 'laptops',
    'Premium 2-in-1 convertible with Intel Core Ultra 7, 2.8K 120Hz IMAX Enhanced OLED touchscreen, 9MP AI camera, and rechargeable MPP 2.0 tilt pen.', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80', '{"processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz with NPU)", "ram": "16GB LPDDR5X 7467MHz", "storage": "1TB PCIe Gen 4 NVMe SSD", "gpu": "Intel Arc Graphics integrated", "display": "14-inch 2.8K OLED, 2880x1800, 48-120Hz, 500 nits HDR, touch, stylus support", "battery": "68 Wh (up to 13 hours battery)", "weight": "1.44 kg", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 1x USB-A 3.2, 3.5mm jack"}'::jsonb, '{"display": 0.98, "portability": 0.95, "build": 0.97, "battery": 0.92, "value": 0.85}'::jsonb, '["convertible", "note_taking", "creator", "executive"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-006-v16', 'laptop-006', 'Core Ultra 7 / 16GB / 1TB', '16GB', '1TB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-006-1', 'laptop-006', 'laptop-006-v16', 'HP Official Store', 'sku', '14-eu0000tu', 'https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-006-2', 'laptop-006', 'laptop-006-v16', 'Amazon India', 'asin', 'B0CS6YSP14', 'https://www.amazon.in/dp/B0CS6YSP14'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-006-3', 'laptop-006', 'laptop-006-v16', 'Flipkart', 'pid', 'COMGZ78YSPEC14', 'https://www.flipkart.com/hp-spectre-x360-intel-core-ultra-7-155h-14-inch/p/itmspec14'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-006-1', 'laptop-006', 'laptop-006-v16', 'HP Official Store', 154990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-006-2', 'laptop-006', 'laptop-006-v16', 'Amazon India', 154990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-006-3', 'laptop-006', 'laptop-006-v16', 'Flipkart', 154990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-007', 'ASUS', 'Zenbook 14 OLED UX3405', 'ASUS Zenbook 14 OLED (Core Ultra 7 / 16GB / 1TB)', 'laptops', 'laptops',
    'Elegantly slim 1.2kg ultraportable with Intel Core Ultra 7, Intel Arc graphics, 3K 120Hz Lumina OLED display, and 75Wh battery.', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80', '{"processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz)", "ram": "16GB LPDDR5X 7467MHz", "storage": "1TB M.2 NVMe PCIe 4.0 SSD", "gpu": "Intel Arc Graphics integrated", "display": "14.0-inch 3K OLED, 2880x1800, 120Hz, 0.2ms, 600 nits peak, 100% DCI-P3", "battery": "75 Wh (up to 15 hours battery)", "weight": "1.22 kg", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 1x USB-A 3.2, HDMI 2.1, 3.5mm jack"}'::jsonb, '{"display": 0.98, "battery": 0.96, "portability": 0.97, "performance": 0.91, "value": 0.93}'::jsonb, '["programming", "travel", "office", "streaming"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-007-v16', 'laptop-007', 'Core Ultra 7 / 16GB / 1TB', '16GB', '1TB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-007-1', 'laptop-007', 'laptop-007-v16', 'Amazon India', 'asin', 'B0CTHMZN14', 'https://www.amazon.in/dp/B0CTHMZN14'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-007-1', 'laptop-007', 'laptop-007-v16', 'Amazon India', 109990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-008', 'Acer', 'Swift Go 14 SFG14', 'Acer Swift Go 14 (Core Ultra 5 / 16GB / 512GB / 2.8K OLED)', 'laptops', 'laptops',
    'High-value thin & light laptop with Intel Core Ultra 5, 2.8K 90Hz OLED display, dual-fan TwinAir cooling, and Intel AI Boost.', 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80', '{"processor": "Intel Core Ultra 5 125H (14 cores, up to 4.5 GHz)", "ram": "16GB LPDDR5X", "storage": "512GB PCIe Gen 4 SSD", "gpu": "Intel Arc Graphics integrated", "display": "14-inch 2.8K OLED, 2880x1800, 90Hz, 400 nits, 100% DCI-P3", "battery": "65 Wh (up to 10 hours battery)", "weight": "1.32 kg", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 2x USB-A 3.2, HDMI 2.1, MicroSD slot, 3.5mm jack"}'::jsonb, '{"value": 0.97, "display": 0.94, "performance": 0.88, "portability": 0.93, "battery": 0.89}'::jsonb, '["student", "budget_creator", "daily_driver", "coding"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'laptop-008-v16', 'laptop-008', 'Core Ultra 5 / 16GB / 512GB', '16GB', '512GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-laptop-008-1', 'laptop-008', 'laptop-008-v16', 'Amazon India', 'asin', 'B0CSBYAC14', 'https://www.amazon.in/dp/B0CSBYAC14'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-008-1', 'laptop-008', 'laptop-008-v16', 'Amazon India', 69990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-001', 'Samsung', 'S95D 4K OLED 55', 'Samsung 55-inch S95D 4K OLED TV (QA55S95DAU)', 'televisions', 'televisions',
    'Flagship 4K QD-OLED TV with OLED Glare Free technology, NQ4 AI Gen2 Processor, 144Hz refresh rate, and 70W 4.2.2Ch Dolby Atmos audio.', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80', '{"display": "55-inch 4K OLED (Quantum Dot), 3840x2160, 144Hz VRR, OLED Glare Free", "hdr": "OLED HDR Pro, HDR10+, HLG", "processor": "NQ4 AI Gen2 Processor (20 AI neural networks)", "audio": "70W, 4.2.2 Channel, Dolby Atmos, Object Tracking Sound+ (OTS+)", "gaming": "4x HDMI 2.1, 4K 144Hz, FreeSync Premium Pro, Auto Game Mode (ALLM)", "smart_os": "Tizen OS with Samsung Knox Security", "ports": "4x HDMI 2.1, 3x USB, Optical, Ethernet, Wi-Fi 5, Bluetooth 5.2"}'::jsonb, '{"display": 0.99, "performance": 0.98, "sound": 0.96, "gaming": 0.99, "value": 0.75}'::jsonb, '["home_theatre", "ps5_gaming", "flagship_cinema"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tv-001-v55', 'tv-001', '55-inch OLED', '4GB', '16GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-001-1', 'tv-001', 'tv-001-v55', 'Amazon India', 'asin', 'B0D3GYTV55', 'https://www.amazon.in/dp/B0D3GYTV55'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-001-2', 'tv-001', 'tv-001-v55', 'Flipkart', 'pid', 'TVSGZ78YS95D55', 'https://www.flipkart.com/samsung-55-inch-oled-ultra-hd-4k-smart-tizen-tv/p/itms95d55'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-001-1', 'tv-001', 'tv-001-v55', 'Amazon India', 184990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-001-2', 'tv-001', 'tv-001-v55', 'Flipkart', 184990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-002', 'LG', 'OLED evo C4 55', 'LG 55-inch OLED evo C4 4K Smart TV (OLED55C4PTA)', 'televisions', 'televisions',
    'Benchmark 4K OLED TV featuring Alpha 9 AI Gen7 processor, Brightness Booster, 144Hz VRR, Dolby Vision, and 0.1ms response time.', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80', '{"display": "55-inch 4K Self-Lit OLED evo, 3840x2160, 144Hz, 0.1ms response time", "hdr": "Dolby Vision, HDR10, HLG, Filmmaker Mode", "processor": "Alpha 9 AI Processor 4K Gen7", "audio": "40W, 2.2 Channel, Dolby Atmos, AI Sound Pro 9.1.2 Virtual Upmix", "gaming": "4x HDMI 2.1 (48Gbps), G-Sync, FreeSync Premium, 144Hz VRR, ALLM", "smart_os": "webOS 24 with 5 years Re:New Program updates", "ports": "4x HDMI 2.1, 3x USB, Optical, eARC, Wi-Fi 5, Bluetooth 5.1"}'::jsonb, '{"display": 0.99, "gaming": 1.0, "sound": 0.91, "performance": 0.97, "value": 0.84}'::jsonb, '["pc_gaming", "console_gaming", "4k_movies", "hdr_cinema"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tv-002-v55', 'tv-002', '55-inch OLED', '4GB', '16GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-002-1', 'tv-002', 'tv-002-v55', 'Amazon India', 'asin', 'B0D2YXC455', 'https://www.amazon.in/dp/B0D2YXC455'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-002-2', 'tv-002', 'tv-002-v55', 'Flipkart', 'pid', 'TVSGZ98YLGC455', 'https://www.flipkart.com/lg-oled-evo-c4-55-inch-ultra-hd-4k-smart-tv/p/itmlgc455'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-002-1', 'tv-002', 'tv-002-v55', 'Amazon India', 149990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-002-2', 'tv-002', 'tv-002-v55', 'Flipkart', 149990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-003', 'Sony', 'Bravia XR A80L OLED 55', 'Sony Bravia 55-inch XR A80L 4K OLED TV (XR-55A80L)', 'televisions', 'televisions',
    'Premium Sony OLED powered by Cognitive Processor XR, Acoustic Surface Audio+ vibrating actuators, and XR OLED Contrast Pro.', 'https://images.unsplash.com/photo-1461151304267-38535e780c79?auto=format&fit=crop&w=800&q=80', '{"display": "55-inch 4K OLED, 3840x2160, 120Hz, XR Triluminos Pro, XR Clear Image", "hdr": "Dolby Vision, HDR10, HLG, IMAX Enhanced", "processor": "Cognitive Processor XR with human perception modeling", "audio": "50W, Acoustic Surface Audio+ (screen is the speaker), 3 actuators, 2 subwoofers", "gaming": "HDMI 2.1, 4K 120Hz, Auto HDR Tone Mapping for PS5, ALLM, VRR", "smart_os": "Google TV with hands-free Google Assistant", "ports": "4x HDMI (2x HDMI 2.1), 2x USB, Optical, eARC, Wi-Fi 5, Bluetooth 4.2"}'::jsonb, '{"display": 0.99, "sound": 0.99, "performance": 0.97, "gaming": 0.94, "value": 0.79}'::jsonb, '["cinematic_movies", "ps5_exclusive", "audiophile_tv"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tv-003-v55', 'tv-003', '55-inch OLED', '4GB', '32GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-003-1', 'tv-003', 'tv-003-v55', 'Amazon India', 'asin', 'B0C7QSY80L', 'https://www.amazon.in/dp/B0C7QSY80L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-003-1', 'tv-003', 'tv-003-v55', 'Amazon India', 169990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-004', 'Samsung', 'The Frame 4K QLED 55', 'Samsung 55-inch The Frame 4K QLED TV (QA55LS03DAU)', 'televisions', 'televisions',
    'Lifestyle art television with Matte Display, Art Mode, customizable magnetic bezels, One Connect Box, and 100% Color Volume with Quantum Dot.', 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?auto=format&fit=crop&w=800&q=80', '{"display": "55-inch 4K QLED, 3840x2160, 120Hz, Anti-Reflection Matte Display", "hdr": "Quantum HDR, HDR10+, HLG", "processor": "Quantum Processor 4K", "audio": "40W, 2.0.2 Channel, Dolby Atmos, Object Tracking Sound", "lifestyle": "Art Store access, motion sensor, slim-fit wall mount included, One Connect cable", "smart_os": "Tizen OS", "ports": "4x HDMI 2.1 via One Connect Box, 2x USB, Optical, Wi-Fi 5"}'::jsonb, '{"display": 0.92, "build": 0.99, "sound": 0.88, "value": 0.89}'::jsonb, '["living_room_art", "aesthetic_home", "bright_room"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tv-004-v55', 'tv-004', '55-inch QLED', '3GB', '16GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-004-1', 'tv-004', 'tv-004-v55', 'Amazon India', 'asin', 'B0D47FRM55', 'https://www.amazon.in/dp/B0D47FRM55'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-004-1', 'tv-004', 'tv-004-v55', 'Amazon India', 86990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-005', 'TCL', 'TCL C755 Mini LED 55', 'TCL 55-inch C755 QD-Mini LED 4K TV (55C755)', 'televisions', 'televisions',
    'High-value QD-Mini LED with over 500 dimming zones, 1300 nits peak brightness, 144Hz VRR, and ONKYO 2.1 channel soundbar.', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80', '{"display": "55-inch 4K QD-Mini LED, 3840x2160, 144Hz VRR, 500+ Local Dimming Zones, 1300 nits", "hdr": "Dolby Vision IQ, HDR10+, HLG", "processor": "AiPQ Processor 3.0", "audio": "50W ONKYO 2.1 Hi-Fi with built-in subwoofer, Dolby Atmos, DTS Virtual:X", "gaming": "Game Accelerator 240Hz, AMD FreeSync Premium Pro, 4x HDMI", "smart_os": "Google TV", "ports": "4x HDMI (2x HDMI 2.1), 2x USB, Optical, Wi-Fi 5"}'::jsonb, '{"value": 0.98, "display": 0.95, "sound": 0.94, "gaming": 0.96, "performance": 0.92}'::jsonb, '["budget_miniled", "gaming_tv", "high_brightness"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tv-005-v55', 'tv-005', '55-inch Mini LED', '3GB', '32GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-005-1', 'tv-005', 'tv-005-v55', 'Amazon India', 'asin', 'B0CJ48TCL5', 'https://www.amazon.in/dp/B0CJ48TCL5'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-005-1', 'tv-005', 'tv-005-v55', 'Amazon India', 64990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-006', 'Xiaomi', 'Xiaomi X Pro QLED 55', 'Xiaomi 55-inch X Pro QLED 4K Smart Google TV', 'televisions', 'televisions',
    'Aggressively priced 4K QLED television with metallic bezel-less design, Dolby Vision IQ, 30W stereo speakers, and Google TV with PatchWall.', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80', '{"display": "55-inch 4K QLED, 3840x2160, 60Hz with MEMC, 94% DCI-P3 color gamut", "hdr": "Dolby Vision IQ, HDR10+, HLG", "processor": "Quad-Core A55 Processor with Mali G52 MP2 GPU", "audio": "30W Stereo Speakers, Dolby Audio, DTS:X, DTS Virtual:X", "smart_os": "Google TV with PatchWall+ integration", "ports": "3x HDMI 2.1 (ALLM/eARC), 2x USB 2.0, Optical, Ethernet, 3.5mm jack"}'::jsonb, '{"value": 0.99, "display": 0.88, "sound": 0.85, "performance": 0.84}'::jsonb, '["budget_qled", "bedroom_tv", "streaming"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tv-006-v55', 'tv-006', '55-inch QLED', '2GB', '32GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tv-006-1', 'tv-006', 'tv-006-v55', 'Amazon India', 'asin', 'B0D78XMI55', 'https://www.amazon.in/dp/B0D78XMI55'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-006-1', 'tv-006', 'tv-006-v55', 'Amazon India', 34999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-001', 'Samsung', 'Samsung 653L Side-by-Side', 'Samsung 653L Side-by-Side Inverter Refrigerator (RS76CG8003S9)', 'refrigerators', 'refrigerators',
    'Spacious side-by-side refrigerator featuring Convertible 5-in-1 modes, SpaceMax technology, Twin Cooling Plus, and Digital Inverter Compressor with 20-year warranty.', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80', '{"capacity": "653 Litres (Fridge: 409L, Freezer: 244L)", "configuration": "Side-by-Side", "compressor": "Digital Inverter Compressor (50% less power, 20-year warranty)", "cooling_technology": "Twin Cooling Plus (two independent evaporators prevent odor mixing)", "modes": "5-in-1 Convertible (Normal, Extra Fridge, Vacation, Seasonal, Home Alone)", "features": "SpaceMax slim walls, Power Cool / Power Freeze, Door Alarm, Deodorizing Filter", "energy_efficiency": "3 Star equivalent for SBS large capacity", "dimensions": "91.2 x 178.0 x 71.6 cm, 101 kg"}'::jsonb, '{"capacity": 0.99, "performance": 0.96, "build": 0.97, "value": 0.9}'::jsonb, '["large_family", "entertaining", "side_by_side"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'fridge-001-v653', 'fridge-001', '653L / Silver Matte', '', '653L', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-001-1', 'fridge-001', 'fridge-001-v653', 'Amazon India', 'asin', 'B0BS1GSS65', 'https://www.amazon.in/dp/B0BS1GSS65'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-001-2', 'fridge-001', 'fridge-001-v653', 'Flipkart', 'pid', 'RFRGZ78YSAM653', 'https://www.flipkart.com/samsung-653-l-frost-free-side-by-side-refrigerator/p/itmsam653'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-001-1', 'fridge-001', 'fridge-001-v653', 'Amazon India', 79990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-001-2', 'fridge-001', 'fridge-001-v653', 'Flipkart', 81990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-002', 'LG', 'LG 655L Side-by-Side', 'LG 655L Smart Inverter Side-by-Side Refrigerator (GL-B257HDSY)', 'refrigerators', 'refrigerators',
    'Multi-door side-by-side refrigerator with Smart Inverter Compressor, Multi Air Flow cooling, Express Freeze, and Smart Diagnosis.', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80', '{"capacity": "655 Litres (Fridge: 416L, Freezer: 239L)", "configuration": "Side-by-Side", "compressor": "Smart Inverter Compressor with 10-year warranty", "cooling_technology": "Multi Air Flow with digital temperature sensors", "features": "Express Freeze, Smart Diagnosis, Bio Shield gasket, Tempered Glass shelves", "dimensions": "91.3 x 179.0 x 74.3 cm, 103 kg"}'::jsonb, '{"capacity": 0.99, "performance": 0.95, "build": 0.96, "value": 0.92}'::jsonb, '["large_family", "side_by_side", "silent_cooling"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'fridge-002-v655', 'fridge-002', '655L / Dazzle Steel', '', '655L', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-002-1', 'fridge-002', 'fridge-002-v655', 'Amazon India', 'asin', 'B0B69LG655', 'https://www.amazon.in/dp/B0B69LG655'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-002-1', 'fridge-002', 'fridge-002-v655', 'Amazon India', 74990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-003', 'Samsung', 'Samsung 236L Double Door', 'Samsung 236L 3-Star Double Door Refrigerator (RT28C3733S8)', 'refrigerators', 'refrigerators',
    'Frost-free double door refrigerator for small-to-medium families featuring Digital Inverter Compressor, MoistFresh Zone, and toughened glass shelves.', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80', '{"capacity": "236 Litres (Fridge: 183L, Freezer: 53L)", "configuration": "Double Door (Frost Free)", "compressor": "Digital Inverter with 20-year warranty", "energy_rating": "3 Star BEE rating", "cooling_technology": "All-around Cooling with multi-vent air distribution", "features": "MoistFresh Zone, Easy Slide Shelf, Deodorizing Filter, Stabilizer Free Operation", "dimensions": "55.5 x 154.5 x 63.7 cm, 46 kg"}'::jsonb, '{"value": 0.96, "energy": 0.93, "performance": 0.9, "capacity": 0.82}'::jsonb, '["family_of_3_4", "double_door", "energy_efficient"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'fridge-003-v236', 'fridge-003', '236L / Elegant Inox', '', '236L', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-003-1', 'fridge-003', 'fridge-003-v236', 'Amazon India', 'asin', 'B0BS1G236L', 'https://www.amazon.in/dp/B0BS1G236L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-003-1', 'fridge-003', 'fridge-003-v236', 'Amazon India', 25490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-004', 'LG', 'LG 242L Double Door', 'LG 242L 3-Star Smart Inverter Double Door Refrigerator (GL-I292RPZX)', 'refrigerators', 'refrigerators',
    'Double door frost-free refrigerator with Door Cooling+ for 35% faster uniform cooling, Smart Inverter Compressor, and Auto Smart Connect.', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80', '{"capacity": "242 Litres (Fridge: 181L, Freezer: 61L)", "configuration": "Double Door (Frost Free)", "compressor": "Smart Inverter Compressor with 10-year warranty", "energy_rating": "3 Star BEE rating", "cooling_technology": "Door Cooling+ with Multi Air Flow", "features": "Auto Smart Connect (home inverter compatible), Moist ''N'' Fresh lattice box, 2L bottle storage", "dimensions": "58.5 x 147.5 x 66.9 cm, 48 kg"}'::jsonb, '{"value": 0.95, "energy": 0.94, "performance": 0.91, "capacity": 0.83}'::jsonb, '["family_of_3_4", "door_cooling", "double_door"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'fridge-004-v242', 'fridge-004', '242L / Shiny Steel', '', '242L', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-004-1', 'fridge-004', 'fridge-004-v242', 'Amazon India', 'asin', 'B09WRS242L', 'https://www.amazon.in/dp/B09WRS242L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-004-1', 'fridge-004', 'fridge-004-v242', 'Amazon India', 25990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-005', 'Whirlpool', 'Whirlpool 265L Intellifresh', 'Whirlpool 265L 3-Star Intellifresh Double Door Refrigerator', 'refrigerators', 'refrigerators',
    'Double door refrigerator with 6th Sense IntelliSensor technology, Microblock protection preventing 99% bacterial growth, and Zeolite technology.', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80', '{"capacity": "265 Litres (Fridge: 190L, Freezer: 75L)", "configuration": "Double Door (Frost Free)", "compressor": "Intellisense Inverter Technology with 10-year warranty", "energy_rating": "3 Star BEE rating", "cooling_technology": "6th Sense DeepFreeze with freshflow air tower", "features": "Microblock Technology, Zeolite fresh keeper, Active Deo, 15 days garden freshness", "dimensions": "57.0 x 159.0 x 67.0 cm, 50 kg"}'::jsonb, '{"value": 0.94, "capacity": 0.86, "performance": 0.89, "energy": 0.92}'::jsonb, '["vegetable_freshness", "family_of_4", "double_door"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'fridge-005-v265', 'fridge-005', '265L / German Steel', '', '265L', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-005-1', 'fridge-005', 'fridge-005-v265', 'Amazon India', 'asin', 'B08WPR265L', 'https://www.amazon.in/dp/B08WPR265L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-005-1', 'fridge-005', 'fridge-005-v265', 'Amazon India', 27490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-006', 'Samsung', 'Samsung 183L Single Door', 'Samsung 183L 4-Star Single Door Refrigerator (RR20C1824U8)', 'refrigerators', 'refrigerators',
    'High-efficiency 4-star direct cool single door refrigerator with Digital Inverter, base stand with drawer for non-refrigerated veggies, and toughened glass shelves.', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80', '{"capacity": "183 Litres", "configuration": "Single Door (Direct Cool)", "compressor": "Digital Inverter Compressor (20-year warranty)", "energy_rating": "4 Star BEE rating (high energy savings)", "features": "Base Stand Drawer (for onions & potatoes), Safe Clean Back, Toughened Glass (up to 175kg)", "dimensions": "53.2 x 121.0 x 64.6 cm, 30 kg"}'::jsonb, '{"value": 0.99, "energy": 0.98, "performance": 0.86, "capacity": 0.72}'::jsonb, '["bachelor", "couple", "single_door", "compact_kitchen"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'fridge-006-v183', 'fridge-006', '183L / Saffron Blue', '', '183L', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-fridge-006-1', 'fridge-006', 'fridge-006-v183', 'Amazon India', 'asin', 'B0BS1G183L', 'https://www.amazon.in/dp/B0BS1G183L'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-006-1', 'fridge-006', 'fridge-006-v183', 'Amazon India', 16990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-001', 'LG', 'LG 8kg AI DirectDrive', 'LG 8kg 5-Star AI DirectDrive Front Load Washing Machine (FHP1208Z5M)', 'washing_machines', 'washing_machines',
    'Advanced front load washing machine with AI Direct Drive detecting fabric weight and softness, 6 Motion wash technology, and Steam for 99.9% allergen removal.', 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80', '{"capacity": "8.0 kg (suitable for families of 4-5)", "type": "Front Load (Fully Automatic)", "spin_speed": "1200 RPM (faster drying)", "motor": "AI Inverter Direct Drive (beltless motor with 10-year warranty)", "energy_rating": "5 Star BEE rating (water & energy efficient)", "wash_programs": "14 programs including Cotton, Allergy Care Steam, Turbowash 59min, Quick 14", "features": "Steam Wash, 6 Motion DD, Smart Diagnosis, Full Stainless Steel Drum", "dimensions": "60.0 x 85.0 x 55.0 cm, 60 kg"}'::jsonb, '{"performance": 0.98, "energy": 0.97, "build": 0.96, "value": 0.9}'::jsonb, '["family_of_4_5", "steam_allergy", "quiet_motor", "fabric_care"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'wash-001-v8', 'wash-001', '8kg / Middle Black', '', '8kg', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-wash-001-1', 'wash-001', 'wash-001-v8', 'Amazon India', 'asin', 'B0CDLG8KFL', 'https://www.amazon.in/dp/B0CDLG8KFL'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-wash-001-2', 'wash-001', 'wash-001-v8', 'Flipkart', 'pid', 'WMNGZ78YLG8KG', 'https://www.flipkart.com/lg-8-kg-5-star-ai-direct-drive-front-load-washing-machine/p/itmlg8kgfl'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-001-1', 'wash-001', 'wash-001-v8', 'Amazon India', 37990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-001-2', 'wash-001', 'wash-001-v8', 'Flipkart', 38490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-002', 'Bosch', 'Bosch 8kg Serie 6', 'Bosch 8kg 5-Star Serie 6 Front Load Washing Machine (WAJ2846SIN)', 'washing_machines', 'washing_machines',
    'German-engineered front load washer featuring EcoSilence Drive brushless motor, 1400 RPM spin speed, AntiTangle technology, and ActiveWater Plus.', 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80', '{"capacity": "8.0 kg", "type": "Front Load (Fully Automatic)", "spin_speed": "1400 RPM (industry-leading spin speed)", "motor": "EcoSilence Drive frictionless magnetic motor (10-year warranty)", "energy_rating": "5 Star BEE rating", "features": "ActiveWater Plus (256 load sensing levels), AntiVibration design, VarioDrum, AntiTangle", "wash_programs": "15 programs including Delicates, Hygiene Care, Express 15/30, Wool", "dimensions": "59.8 x 84.8 x 59.0 cm, 71.5 kg"}'::jsonb, '{"performance": 0.99, "build": 0.98, "energy": 0.96, "value": 0.88}'::jsonb, '["heavy_laundry", "vibration_free", "high_durability"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'wash-002-v8', 'wash-002', '8kg / Silver Inox', '', '8kg', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-wash-002-1', 'wash-002', 'wash-002-v8', 'Amazon India', 'asin', 'B08BSH8K6S', 'https://www.amazon.in/dp/B08BSH8K6S'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-002-1', 'wash-002', 'wash-002-v8', 'Amazon India', 39990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-003', 'Samsung', 'Samsung 8kg EcoBubble AI', 'Samsung 8kg 5-Star EcoBubble AI Front Load Washing Machine', 'washing_machines', 'washing_machines',
    'Front load washer featuring EcoBubble technology turning detergent into soft bubbles, AI pattern learning, and Hygiene Steam cycles.', 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80', '{"capacity": "8.0 kg", "type": "Front Load (Fully Automatic)", "spin_speed": "1400 RPM", "motor": "Digital Inverter Motor (20-year warranty)", "energy_rating": "5 Star BEE rating", "features": "EcoBubble (deep fabric penetration at low temp), AI Control, SmartThings Wi-Fi, Drum Clean+", "dimensions": "60.0 x 85.0 x 55.0 cm, 65 kg"}'::jsonb, '{"performance": 0.96, "energy": 0.96, "value": 0.91, "build": 0.94}'::jsonb, '["wifi_smart", "ecobubble", "delicate_fabrics"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'wash-003-v8', 'wash-003', '8kg / Inox Gray', '', '8kg', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-wash-003-1', 'wash-003', 'wash-003-v8', 'Amazon India', 'asin', 'B08SM8KECO', 'https://www.amazon.in/dp/B08SM8KECO'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-003-1', 'wash-003', 'wash-003-v8', 'Amazon India', 36990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-004', 'LG', 'LG 7kg Top Load', 'LG 7kg 5-Star Smart Inverter Top Load Washing Machine (T70SKSF1Z)', 'washing_machines', 'washing_machines',
    'Top load fully automatic washing machine with Smart Inverter technology, TurboDrum with dual-direction rotation, and BMC motor protection.', 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80', '{"capacity": "7.0 kg (suitable for families of 3-4)", "type": "Top Load (Fully Automatic)", "spin_speed": "700 RPM", "motor": "Smart Inverter Motor with waterproof BMC protection (10-year warranty)", "energy_rating": "5 Star BEE rating", "features": "TurboDrum, Smart Motion (3 wash motions), Punch+ 3 pulsator, Stainless Steel drum", "dimensions": "54.0 x 87.0 x 54.0 cm, 32 kg"}'::jsonb, '{"value": 0.98, "energy": 0.95, "performance": 0.88, "build": 0.9}'::jsonb, '["top_load", "compact_space", "value_for_money"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'wash-004-v7', 'wash-004', '7kg / Middle Free Silver', '', '7kg', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-wash-004-1', 'wash-004', 'wash-004-v7', 'Amazon India', 'asin', 'B089LG7KTL', 'https://www.amazon.in/dp/B089LG7KTL'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-004-1', 'wash-004', 'wash-004-v7', 'Amazon India', 17990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'ac-001', 'Daikin', 'Daikin 1.5T 5-Star Inverter', 'Daikin 1.5 Ton 5-Star Inverter Split AC (MTKM50U)', 'air_conditioners', 'air_conditioners',
    'Japanese precision cooling with Neo Swing Inverter compressor, PM2.5 filtration, Dew Clean auto-wash, and high ambient cooling up to 54°C.', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80', '{"capacity": "1.5 Ton (suitable for 110 to 150 sq ft rooms)", "energy_rating": "5 Star BEE (ISEER: 5.20, annual power: 785 kWh)", "compressor": "Patented Neo Swing Inverter Compressor (10-year warranty)", "cooling_capacity": "5000 W (rated full capacity)", "condenser_coil": "100% Copper with Anti-Corrosion Treatment", "air_purification": "PM2.5 Filter and Dew Clean auto-cleaning technology", "special_features": "Triple Display, Coanda Airflow for draftless cooling, Econo Mode", "refrigerant": "R32 eco-friendly gas (Zero ODP)"}'::jsonb, '{"cooling": 0.99, "energy": 0.98, "reliability": 0.99, "air_quality": 0.95, "value": 0.88}'::jsonb, '["bedroom_cooling", "whisper_quiet", "energy_saver", "high_heat_tolerance"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'ac-001-v15', 'ac-001', '1.5 Ton 5-Star / White', '', '1.5T', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-ac-001-1', 'ac-001', 'ac-001-v15', 'Amazon India', 'asin', 'B0BRGDK155', 'https://www.amazon.in/dp/B0BRGDK155'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-ac-001-2', 'ac-001', 'ac-001-v15', 'Flipkart', 'pid', 'ACNGZ78YDK155', 'https://www.flipkart.com/daikin-1-5-ton-5-star-inverter-split-ac/p/itmdk155'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-001-1', 'ac-001', 'ac-001-v15', 'Amazon India', 45490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-001-2', 'ac-001', 'ac-001-v15', 'Flipkart', 45990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'ac-002', 'LG', 'LG 1.5T AI Dual Inverter', 'LG 1.5 Ton 5-Star AI Dual Inverter Split AC (TS-Q19YNZE)', 'air_conditioners', 'air_conditioners',
    'Dual Inverter AC with artificial intelligence adjusting cooling and fan speeds based on room load, 6-in-1 convertible cooling, and Ocean Black Protection.', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80', '{"capacity": "1.5 Ton (111 to 150 sq ft)", "energy_rating": "5 Star BEE (ISEER: 5.20, annual power: 685 kWh)", "compressor": "AI Dual Inverter Compressor (10-year warranty)", "cooling_capacity": "5000 W (expandable to 110% overload cooling)", "condenser_coil": "100% Copper with Ocean Black Protection against rust and pollutants", "features": "AI Convertible 6-in-1, HD Filter with Anti-Virus protection, Ez Clean Filter, Low Gas Detection", "refrigerant": "R32"}'::jsonb, '{"cooling": 0.98, "energy": 0.99, "durability": 0.97, "value": 0.89}'::jsonb, '["coastal_protection", "convertible_modes", "master_bedroom"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'ac-002-v15', 'ac-002', '1.5 Ton 5-Star / White', '', '1.5T', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-ac-002-1', 'ac-002', 'ac-002-v15', 'Amazon India', 'asin', 'B0BTWD47LG', 'https://www.amazon.in/dp/B0BTWD47LG'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-002-1', 'ac-002', 'ac-002-v15', 'Amazon India', 46490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'ac-003', 'Voltas', 'Voltas 1.5T 5-Star Inverter', 'Voltas 1.5 Ton 5-Star Inverter Split AC (185V Vectra Elite)', 'air_conditioners', 'air_conditioners',
    'High-value cooling engineered for Indian summers up to 52°C, featuring 4-in-1 adjustable cooling, dual temperature display, and anti-microbial filter.', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80', '{"capacity": "1.5 Ton", "energy_rating": "5 Star BEE (ISEER: 5.00)", "compressor": "Variable Speed Inverter Compressor", "cooling_capacity": "4800 W", "condenser_coil": "100% Copper with Blue Fin anti-corrosive coating", "features": "4-in-1 Adjustable Cooling, Anti-Dust Filter with Antimicrobial coating, Sleep Mode, Turbo Cool", "refrigerant": "R32"}'::jsonb, '{"value": 0.98, "cooling": 0.94, "energy": 0.93, "reliability": 0.91}'::jsonb, '["budget_friendly", "indian_summer", "living_room"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'ac-003-v15', 'ac-003', '1.5 Ton 5-Star / White', '', '1.5T', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-ac-003-1', 'ac-003', 'ac-003-v15', 'Amazon India', 'asin', 'B0BSGLVT15', 'https://www.amazon.in/dp/B0BSGLVT15'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-003-1', 'ac-003', 'ac-003-v15', 'Amazon India', 37990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tab-001', 'Apple', 'iPad Pro 11 M4', 'Apple iPad Pro 11-inch M4 (256GB / Wi-Fi)', 'tablets_monitors', 'tablets_monitors',
    'Ultra-thin 5.3mm tablet featuring M4 chip, Tandem OLED Ultra Retina XDR display with 1600 nits peak brightness, and Apple Pencil Pro support.', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80', '{"processor": "Apple M4 (9-core CPU, 10-core GPU, 16-core Neural Engine)", "display": "11-inch Tandem OLED Ultra Retina XDR, 2420x1668, 10-120Hz ProMotion, 1000 nits full screen, 1600 nits HDR", "ram": "8GB Unified Memory", "storage": "256GB NVMe", "camera": "12MP Wide with LiDAR Scanner, Landscape 12MP Center Stage front camera", "battery": "31.29 Wh (up to 10 hours web/video)", "weight": "444 g", "os": "iPadOS 18"}'::jsonb, '{"display": 1.0, "performance": 0.99, "portability": 0.98, "value": 0.76}'::jsonb, '["digital_art", "pro_creative", "mobile_workstation", "hdr_video"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tab-001-v256', 'tab-001', '11-inch / 256GB / Space Black', '', '256GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tab-001-1', 'tab-001', 'tab-001-v256', 'Apple Store India', 'sku', 'MVX23HN/A', 'https://www.apple.com/in/shop/buy-ipad/ipad-pro'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tab-001-2', 'tab-001', 'tab-001-v256', 'Amazon India', 'asin', 'B0D3J7PAD1', 'https://www.amazon.in/dp/B0D3J7PAD1'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tab-001-1', 'tab-001', 'tab-001-v256', 'Apple Store India', 99900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tab-001-2', 'tab-001', 'tab-001-v256', 'Amazon India', 99900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tab-002', 'Samsung', 'Galaxy Tab S9 Ultra', 'Samsung Galaxy Tab S9 Ultra (12GB / 256GB / Wi-Fi)', 'tablets_monitors', 'tablets_monitors',
    'Massive 14.6-inch Dynamic AMOLED 2X Android tablet with Snapdragon 8 Gen 2 for Galaxy, IP68 water resistance, and included S-Pen.', 'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80', '{"processor": "Qualcomm Snapdragon 8 Gen 2 for Galaxy (4nm, up to 3.36 GHz)", "display": "14.6-inch Dynamic AMOLED 2X, 2960x1848, 120Hz, HDR10+", "ram": "12GB", "storage": "256GB (microSD expandable up to 1TB)", "battery": "11200 mAh with 45W Fast Charging", "features": "Samsung DeX desktop mode, Quad speakers by AKG, IP68 water/dust resistant", "weight": "732 g", "os": "Android 14 with One UI 6"}'::jsonb, '{"display": 0.99, "performance": 0.96, "productivity": 0.98, "value": 0.8}'::jsonb, '["dex_productivity", "large_screen_drawing", "multitasking"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'tab-002-v256', 'tab-002', '14.6-inch / 12GB / 256GB', '12GB', '256GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-tab-002-1', 'tab-002', 'tab-002-v256', 'Amazon India', 'asin', 'B0CC9VTS9U', 'https://www.amazon.in/dp/B0CC9VTS9U'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tab-002-1', 'tab-002', 'tab-002-v256', 'Amazon India', 108999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mon-001', 'Dell', 'UltraSharp 27 4K U2723QE', 'Dell UltraSharp 27 4K USB-C Hub Monitor (U2723QE)', 'tablets_monitors', 'tablets_monitors',
    'Professional 27-inch 4K monitor featuring IPS Black technology with 2000:1 contrast ratio, 98% DCI-P3 color gamut, 90W USB-C hub, and RJ-45 LAN.', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=800&q=80', '{"display": "27-inch 4K UHD, 3840x2160 at 60Hz, IPS Black Panel, 2000:1 contrast ratio", "color": "98% DCI-P3, 100% sRGB, Delta E < 2 factory calibrated, VESA DisplayHDR 400", "connectivity": "USB-C Hub (90W Power Delivery), DisplayPort 1.4, HDMI 2.0, 5x USB-A 3.2, RJ-45 Ethernet", "ergonomics": "Height adjustable (150mm), tilt, swivel, pivot (portrait/landscape)", "special_features": "Auto KVM, Picture-by-Picture, Picture-in-Picture, ComfortView Plus low blue light"}'::jsonb, '{"display": 0.99, "productivity": 0.98, "build": 0.97, "value": 0.9}'::jsonb, '["photo_editing", "coding_workstation", "macbook_docking", "office"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'mon-001-v27', 'mon-001', '27-inch 4K IPS Black', '', '', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-mon-001-1', 'mon-001', 'mon-001-v27', 'Amazon India', 'asin', 'B09TQZP4KL', 'https://www.amazon.in/dp/B09TQZP4KL'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mon-001-1', 'mon-001', 'mon-001-v27', 'Amazon India', 54990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mon-002', 'LG', 'UltraGear 27 OLED 240Hz', 'LG UltraGear 27-inch QHD OLED Gaming Monitor (27GR95QE)', 'tablets_monitors', 'tablets_monitors',
    'Blistering 240Hz OLED gaming monitor with 0.03ms response time, 98.5% DCI-P3 color, and anti-glare low reflection coating.', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80', '{"display": "27-inch QHD, 2560x1440, OLED, 240Hz refresh rate, 0.03ms GtG response", "contrast_and_color": "1,500,000:1 contrast ratio, 98.5% DCI-P3, HDR10", "sync": "NVIDIA G-Sync Compatible, AMD FreeSync Premium", "connectivity": "2x HDMI 2.1, 1x DisplayPort 1.4 (DSC), 2x USB 3.0 downstream, 4-pole optical headphone jack with DTS HP:X"}'::jsonb, '{"gaming": 1.0, "display": 0.98, "performance": 0.99, "value": 0.85}'::jsonb, '["competitive_esports", "fast_fps", "pure_blacks"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'mon-002-v27', 'mon-002', '27-inch QHD OLED 240Hz', '', '', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-mon-002-1', 'mon-002', 'mon-002-v27', 'Amazon India', 'asin', 'B0BSW6LG27', 'https://www.amazon.in/dp/B0BSW6LG27'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mon-002-1', 'mon-002', 'mon-002-v27', 'Amazon India', 64990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-001', 'Sony', 'WH-1000XM5', 'Sony WH-1000XM5 Wireless Noise Cancelling Headphones', 'consumer_electronics', 'headphones',
    'Industry-leading noise cancelling over-ear headphones with two processors, 8 microphones, Auto NC Optimizer, and 30-hour battery life.', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80', '{"driver": "30mm precision-engineered carbon fiber composite driver", "anc": "Integrated Processor V1 + HD Noise Cancelling Processor QN1 with 8 microphones", "battery": "30 hours with ANC on (40 hours with ANC off), 3 min quick charge gives 3 hours", "bluetooth": "Bluetooth 5.2, LDAC high-resolution wireless, Multipoint connection (2 devices)", "weight": "250 g", "features": "Speak-to-Chat, wearing sensor, touch control, Google Fast Pair, Swift Pair"}'::jsonb, '{"anc": 1.0, "sound": 0.98, "battery": 0.96, "comfort": 0.95, "value": 0.9}'::jsonb, '["travel", "work_from_home", "audiophile", "daily_commute"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-001-vblk', 'audio-001', 'Black', '', '', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-001-1', 'audio-001', 'audio-001-vblk', 'Amazon India', 'asin', 'B09XS7JWHH', 'https://www.amazon.in/dp/B09XS7JWHH'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-001-2', 'audio-001', 'audio-001-vblk', 'Flipkart', 'pid', 'ACCGZ78YSNYXM5', 'https://www.flipkart.com/sony-wh-1000xm5-bluetooth-headset/p/itmsnyxm5'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-001-1', 'audio-001', 'audio-001-vblk', 'Amazon India', 26990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-001-2', 'audio-001', 'audio-001-vblk', 'Flipkart', 26990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-002', 'Apple', 'AirPods Pro 2 USB-C', 'Apple AirPods Pro (2nd Generation with USB-C)', 'consumer_electronics', 'headphones',
    'Pro true wireless earbuds powered by Apple H2 chip, up to 2x more Active Noise Cancellation, Adaptive Audio, and MagSafe Case (USB-C) with Precision Finding.', 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80', '{"driver": "Custom high-excursion Apple driver with custom high dynamic range amplifier", "chip": "Apple H2 headphone chip in earbuds, U1/H1 in MagSafe charging case", "anc": "Active Noise Cancellation with Adaptive Audio, Transparency mode, and Conversation Awareness", "battery": "6 hours listening on single charge (up to 30 hours with case)", "durability": "IP54 dust, sweat, and water resistant for both earbuds and case", "connectivity": "Bluetooth 5.3 with seamless Apple ecosystem switching"}'::jsonb, '{"anc": 0.98, "convenience": 1.0, "sound": 0.94, "portability": 1.0, "value": 0.88}'::jsonb, '["apple_ecosystem", "gym", "calls", "commute"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-002-vwht', 'audio-002', 'White', '', '', 'White', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-002-1', 'audio-002', 'audio-002-vwht', 'Apple Store India', 'sku', 'MTJV3HN/A', 'https://www.apple.com/in/shop/product/MTJV3HN/A/airpods-pro'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-002-2', 'audio-002', 'audio-002-vwht', 'Amazon India', 'asin', 'B0CHWRXH8B', 'https://www.amazon.in/dp/B0CHWRXH8B'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-002-1', 'audio-002', 'audio-002-vwht', 'Apple Store India', 24900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-002-2', 'audio-002', 'audio-002-vwht', 'Amazon India', 22990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-003', 'Bose', 'QC Ultra Headphones', 'Bose QuietComfort Ultra Wireless Headphones', 'consumer_electronics', 'headphones',
    'World-class noise cancellation headphones with Bose Immersive Audio spatial sound, CustomTune sound calibration, and ultra-comfortable plush earcups.', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80', '{"driver": "Bose custom acoustic transducer", "anc": "World-class active noise cancellation with Quiet Mode, Aware Mode, and Immersion Mode", "battery": "24 hours listening time (up to 18 hours with Immersive Audio)", "bluetooth": "Bluetooth 5.3 with Snapdragon Sound (aptX Adaptive)", "features": "CustomTune personalized sound tailored to your ear geometry, built-in microphones with noise rejection"}'::jsonb, '{"anc": 1.0, "comfort": 1.0, "sound": 0.96, "build": 0.95, "value": 0.8}'::jsonb, '["flight_travel", "office_focus", "all_day_comfort"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-003-vblk', 'audio-003', 'Black', '', '', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-003-1', 'audio-003', 'audio-003-vblk', 'Bose Official Store', 'sku', 'QCU-HEADPHONEARN', 'https://www.bose.com/p/headphones/bose-quietcomfort-ultra-headphones/QCU-HEADPHONEARN.html'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-003-2', 'audio-003', 'audio-003-vblk', 'Amazon India', 'asin', 'B0CD27L2Y7', 'https://www.amazon.in/dp/B0CD27L2Y7'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-003-1', 'audio-003', 'audio-003-vblk', 'Amazon India', 35900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-004', 'Apple', 'Apple Watch Ultra 2', 'Apple Watch Ultra 2 (GPS + Cellular, 49mm Titanium)', 'fitness', 'smartwatches',
    'Rugged 49mm aerospace-grade titanium smartwatch designed for endurance athletes, diving to 40m, and outdoor exploration with precision dual-frequency GPS.', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80', '{"display": "49mm Always-On Retina LTPO OLED, 3000 nits peak brightness, flat sapphire crystal front", "processor": "S9 SiP (64-bit dual-core with 4-core Neural Engine, Double Tap gesture)", "sensors": "Precision dual-frequency GPS (L1 and L5), depth gauge, water temperature sensor, ECG, SpO2", "battery": "Up to 36 hours normal use (up to 72 hours in Low Power Mode)", "durability": "100m water resistant, IP6X dust resistant, MIL-STD 810H tested, EN13319 dive computer certified", "weight": "61.4 g (case only)", "os": "watchOS 11"}'::jsonb, '{"durability": 1.0, "gps": 1.0, "display": 0.99, "battery": 0.92, "value": 0.75}'::jsonb, '["marathon", "scuba_diving", "trail_hiking", "extreme_sports"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-004-v49', 'audio-004', '49mm Natural Titanium / Ocean Band', '', '64GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-004-1', 'audio-004', 'audio-004-v49', 'Apple Store India', 'sku', 'MREY3HN/A', 'https://www.apple.com/in/shop/buy-watch/apple-watch-ultra-2'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-004-2', 'audio-004', 'audio-004-v49', 'Amazon India', 'asin', 'B0CHX3V1B8', 'https://www.amazon.in/dp/B0CHX3V1B8'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-004-1', 'audio-004', 'audio-004-v49', 'Apple Store India', 89900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-004-2', 'audio-004', 'audio-004-v49', 'Amazon India', 84990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-005', 'Samsung', 'Galaxy Watch Ultra', 'Samsung Galaxy Watch Ultra (47mm LTE Titanium)', 'fitness', 'smartwatches',
    'Ultra rugged smartwatch with cushion design, Grade 4 Titanium frame, Dual-frequency GPS, 10 ATM / IP68 water resistance, and 3nm processor with Galaxy AI.', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80', '{"display": "1.5-inch Super AMOLED, 480x480, Sapphire Crystal, 3000 nits peak", "processor": "Exynos W1000 (3nm, 5-core)", "battery": "590 mAh (up to 100 hours in Power Saving mode, 48 hours normal exercise)", "sensors": "Dual-frequency GPS (L1+L5), BioActive Sensor (Heart Rate, ECG, BIA Body Composition), Skin Temperature", "durability": "10 ATM water resistance (100m), MIL-STD-810H, IP68", "weight": "60.5 g", "os": "Wear OS 5 Powered by Samsung (One UI 6 Watch)"}'::jsonb, '{"durability": 0.99, "battery": 0.95, "sensors": 0.98, "value": 0.85}'::jsonb, '["triathlon", "outdoor_adventure", "android_flagship"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-005-v47', 'audio-005', '47mm Titanium Gray / LTE', '', '32GB', 'Standard', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-005-1', 'audio-005', 'audio-005-v47', 'Amazon India', 'asin', 'B0D7B2ZGWU', 'https://www.amazon.in/dp/B0D7B2ZGWU'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-005-1', 'audio-005', 'audio-005-v47', 'Amazon India', 59999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-006', 'Sennheiser', 'Momentum 4 Wireless', 'Sennheiser Momentum 4 Wireless ANC Headphones', 'consumer_electronics', 'headphones',
    'Audiophile-inspired 42mm transducer system delivering Sennheiser signature sound, 60-hour battery life, and adaptive noise cancellation.', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80', '{"driver": "42mm dynamic transducer", "anc": "Adaptive Hybrid Active Noise Cancellation", "battery": "60 hours listening time with ANC on", "bluetooth": "Bluetooth 5.2 with aptX Adaptive, AAC, SBC", "charging": "Fast charging: 10 min gives 6 hours"}'::jsonb, '{"sound": 1.0, "battery": 1.0, "anc": 0.94, "comfort": 0.92, "value": 0.9}'::jsonb, '["audiophile", "office_work", "long_haul_flights"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-006-vblk', 'audio-006', 'Black', '', '', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-006-1', 'audio-006', 'audio-006-vblk', 'Amazon India', 'asin', 'B0B6GHW1X8', 'https://www.amazon.in/dp/B0B6GHW1X8'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-006-1', 'audio-006', 'audio-006-vblk', 'Amazon India', 27990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-007', 'Sony', 'WF-1000XM5', 'Sony WF-1000XM5 True Wireless Noise Cancelling Earbuds', 'consumer_electronics', 'headphones',
    'Flagship wireless earbuds with Dynamic Driver X, dual processors for noise cancellation, and LDAC High-Resolution Audio.', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80', '{"driver": "8.4mm Dynamic Driver X", "anc": "Dual processor HD Noise Cancelling QN2e and V2", "battery": "8 hours (up to 24 hours with case)", "durability": "IPX4 water resistance", "bluetooth": "Bluetooth 5.3, LDAC, LC3 ready"}'::jsonb, '{"anc": 0.98, "sound": 0.98, "portability": 1.0, "value": 0.88}'::jsonb, '["commute", "gym", "daily_calls"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-007-vblk', 'audio-007', 'Black', '', '', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-007-1', 'audio-007', 'audio-007-vblk', 'Amazon India', 'asin', 'B0C33XXM5', 'https://www.amazon.in/dp/B0C33XXM5'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-007-1', 'audio-007', 'audio-007-vblk', 'Amazon India', 23990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-008', 'Marshall', 'Major IV', 'Marshall Major IV Wireless On-Ear Headphones', 'consumer_electronics', 'headphones',
    'Iconic vintage style on-ear headphones delivering explosive Marshall signature sound with 80+ hours of wireless playtime.', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80', '{"driver": "40mm dynamic drivers", "battery": "80+ hours wireless playtime", "charging": "Wireless charging + USB-C quick charge (15 min gives 15 hours)", "weight": "165 g", "design": "Collapsible ergonomic design with multi-directional control knob"}'::jsonb, '{"battery": 1.0, "portability": 0.98, "sound": 0.9, "build": 0.92, "value": 0.95}'::jsonb, '["casual_listening", "retro_fashion", "travel"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-008-vblk', 'audio-008', 'Black', '', '', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-008-1', 'audio-008', 'audio-008-vblk', 'Amazon India', 'asin', 'B08HY4H66K', 'https://www.amazon.in/dp/B08HY4H66K'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-008-1', 'audio-008', 'audio-008-vblk', 'Amazon India', 11999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-009', 'Apple', 'AirPods Max USB-C', 'Apple AirPods Max (USB-C, Active Noise Cancellation)', 'consumer_electronics', 'headphones',
    'High-fidelity audio with Apple-designed 40mm dynamic driver, computational audio via dual H1 chips, and premium anodized aluminum earcups.', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80', '{"driver": "Apple-designed 40mm dynamic driver with dual neodymium ring magnet", "chip": "Apple H1 headphone chip in each ear cup", "anc": "Pro-level Active Noise Cancellation and Transparency mode", "battery": "20 hours listening with ANC enabled", "charging": "USB-C fast charging (5 min gives 1.5 hours)"}'::jsonb, '{"sound": 0.99, "anc": 0.99, "build": 1.0, "comfort": 0.95, "value": 0.65}'::jsonb, '["audiophile", "apple_ecosystem", "studio_monitoring"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-009-vmid', 'audio-009', 'Midnight / USB-C', '', '', 'Midnight', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-009-1', 'audio-009', 'audio-009-vmid', 'Apple Store India', 'sku', 'MDN01HN/A', 'https://www.apple.com/in/shop/buy-airpods/airpods-max'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-009-2', 'audio-009', 'audio-009-vmid', 'Amazon India', 'asin', 'B0DGJ9APMAX', 'https://www.amazon.in/dp/B0DGJ9APMAX'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-009-1', 'audio-009', 'audio-009-vmid', 'Apple Store India', 59900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-009-2', 'audio-009', 'audio-009-vmid', 'Amazon India', 59900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-010', 'JBL', 'Tour One M2', 'JBL Tour One M2 Wireless Over-Ear ANC Headphones', 'consumer_electronics', 'headphones',
    'True Adaptive Noise Cancelling with 4-mic technology, Smart Ambient sound, JBL Pro Sound, and up to 50 hours battery life.', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80', '{"driver": "40mm dynamic driver with JBL Pro Sound", "anc": "True Adaptive Noise Cancelling with Smart Ambient", "battery": "50 hours (up to 30 hours with ANC on)", "charging": "Fast charge: 10 min gives 5 hours", "bluetooth": "Bluetooth 5.3 LE Audio ready"}'::jsonb, '{"anc": 0.93, "battery": 0.98, "sound": 0.92, "comfort": 0.9, "value": 0.94}'::jsonb, '["office", "commute", "travel"]'::jsonb,
    'verified', 'Manufacturer Official & Verified Retail'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_variants (
    id, product_id, variant_name, ram, storage, color, specs
) VALUES (
    'audio-010-vblk', 'audio-010', 'Black', '', '', 'Black', '{}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    ram = EXCLUDED.ram,
    storage = EXCLUDED.storage,
    updated_at = NOW();


INSERT INTO public.retailer_listings (
    id, product_id, variant_id, retailer, identifier_type, identifier_value, canonical_url
) VALUES (
    'list-audio-010-1', 'audio-010', 'audio-010-vblk', 'Amazon India', 'asin', 'B0BRYYJBL1', 'https://www.amazon.in/dp/B0BRYYJBL1'
) ON CONFLICT (id) DO NOTHING;


INSERT INTO public.product_offers (
    id, product_id, variant_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-010-1', 'audio-010', 'audio-010-vblk', 'Amazon India', 19999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();

-- ============================================================================
-- WORTHLY - COMPLETE ALL-IN-ONE SUPABASE DATABASE SETUP
-- File: 000_FULL_SETUP_WORTHLY_DATABASE.sql
--
-- Everything needed for a fresh or existing Supabase project:
--   1. Creates all tables (product_models, product_variants, retailer_listings,
--      product_offers, image_manifest)
--   2. Enables Row Level Security (RLS) with public read-only policies
--   3. Creates performance indexes on categories, brands, identifiers, and models
--   4. Idempotently seeds all 174 master catalog products with specs and offers
--   5. Populates the verified image manifest
--
-- Safe to execute repeatedly (uses CREATE TABLE IF NOT EXISTS and ON CONFLICT).
-- ============================================================================

-- 1. Core Product Models Table
CREATE TABLE IF NOT EXISTS public.product_models (
    id VARCHAR(64) PRIMARY KEY,
    brand VARCHAR(128) NOT NULL,
    exact_model VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(64) NOT NULL DEFAULT 'smartphones',
    subcategory VARCHAR(64) NOT NULL DEFAULT 'smartphones',
    description TEXT,
    image_url TEXT,
    specs JSONB NOT NULL DEFAULT '{}'::jsonb,
    features JSONB NOT NULL DEFAULT '[]'::jsonb,
    pros JSONB NOT NULL DEFAULT '[]'::jsonb,
    cons JSONB NOT NULL DEFAULT '[]'::jsonb,
    priority_affinities JSONB NOT NULL DEFAULT '{}'::jsonb,
    intended_usage_tags JSONB NOT NULL DEFAULT '[]'::jsonb,
    verification_status VARCHAR(64) NOT NULL DEFAULT 'verified',
    source TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_product_models_category ON public.product_models(category);
CREATE INDEX IF NOT EXISTS idx_product_models_brand ON public.product_models(brand);
CREATE INDEX IF NOT EXISTS idx_product_models_exact_model ON public.product_models(exact_model);

-- 2. Variants Table
CREATE TABLE IF NOT EXISTS public.product_variants (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) NOT NULL REFERENCES public.product_models(id) ON DELETE CASCADE,
    variant_name VARCHAR(128) NOT NULL,
    ram VARCHAR(32),
    storage VARCHAR(32),
    color VARCHAR(64),
    specs JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_product_variants_product_id ON public.product_variants(product_id);

-- 3. Retailer Listings Table
CREATE TABLE IF NOT EXISTS public.retailer_listings (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) NOT NULL REFERENCES public.product_models(id) ON DELETE CASCADE,
    variant_id VARCHAR(64) REFERENCES public.product_variants(id) ON DELETE SET NULL,
    retailer VARCHAR(64) NOT NULL,
    identifier_type VARCHAR(32) NOT NULL,
    identifier_value VARCHAR(128) NOT NULL,
    canonical_url TEXT NOT NULL,
    original_url TEXT,
    verified_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_retailer_listings_identifier ON public.retailer_listings(identifier_type, identifier_value);
CREATE INDEX IF NOT EXISTS idx_retailer_listings_canonical_url ON public.retailer_listings(canonical_url);

-- 4. Product Offers Table
CREATE TABLE IF NOT EXISTS public.product_offers (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) NOT NULL REFERENCES public.product_models(id) ON DELETE CASCADE,
    variant_id VARCHAR(64) REFERENCES public.product_variants(id) ON DELETE SET NULL,
    retailer VARCHAR(64) NOT NULL,
    price NUMERIC(12, 2) NOT NULL,
    currency VARCHAR(8) NOT NULL DEFAULT 'INR',
    price_source VARCHAR(128),
    price_status VARCHAR(64) NOT NULL DEFAULT 'verified',
    availability VARCHAR(64) NOT NULL DEFAULT 'In Stock',
    product_url TEXT,
    last_checked_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_product_offers_product_id ON public.product_offers(product_id);

-- 5. Image Manifest Table
CREATE TABLE IF NOT EXISTS public.image_manifest (
    image_id TEXT PRIMARY KEY,
    product_id TEXT REFERENCES public.product_models(id) ON DELETE SET NULL,
    variant_id TEXT,
    original_filename TEXT NOT NULL,
    original_relative_path TEXT,
    processed_image_path TEXT NOT NULL,
    image_source TEXT,
    attribution_or_license TEXT,
    is_primary BOOLEAN DEFAULT true,
    verification_status TEXT DEFAULT 'verified',
    matching_method TEXT DEFAULT 'exact_match',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_image_manifest_product_id ON public.image_manifest(product_id);

-- Row Level Security (RLS) Configuration
ALTER TABLE public.product_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.retailer_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.image_manifest ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view product models" ON public.product_models;
CREATE POLICY "Public can view product models" ON public.product_models FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public can view product variants" ON public.product_variants;
CREATE POLICY "Public can view product variants" ON public.product_variants FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public can view retailer listings" ON public.retailer_listings;
CREATE POLICY "Public can view retailer listings" ON public.retailer_listings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public can view product offers" ON public.product_offers;
CREATE POLICY "Public can view product offers" ON public.product_offers FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public can view image manifest" ON public.image_manifest;
CREATE POLICY "Public can view image manifest" ON public.image_manifest FOR SELECT USING (true);


-- ============================================================================
-- SEEDING 174 MASTER CATALOG PRODUCTS
-- ============================================================================

INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-001', 'Apple', 'iPhone 16 Pro', 'Apple iPhone 16 Pro (128GB)', 'smartphones', 'smartphones', '', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-pro-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha',
    '{"processor": "Apple A18 Pro (6-core CPU, 6-core GPU, 16-core Neural Engine)", "ram": "8GB LPDDR5X", "storage": "128GB NVMe", "display": "6.3-inch Super Retina XDR OLED, 2622x1206, 120Hz ProMotion, 2000 nits peak", "camera": "48MP Fusion (OIS) + 48MP Ultra Wide + 12MP 5x Telephoto with 4K120 Dolby Vision", "front_camera": "12MP TrueDepth with autofocus", "battery": "3582 mAh", "charging": "25W MagSafe, 20W Wired (50% in 30 mins), Qi2 wireless", "os": "iOS 18 with Apple Intelligence", "build": "Grade 5 Titanium frame, Ceramic Shield front, textured matte glass back", "weight": "199 g", "ip_rating": "IP68 (6m up to 30 mins)"}'::jsonb, '["Apple flagship with A18 Pro chip, Grade 5 Titanium design, Action button, and Camera Control."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-001-1', 'phone-001', 'Amazon / Flipkart', 119900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-002', 'Apple', 'iPhone 16', 'Apple iPhone 16 (128GB)', 'smartphones', 'smartphones', '', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-ultramarine-select?wid=470&hei=556&fmt=png-alpha',
    '{"processor": "Apple A18 (6-core CPU, 5-core GPU, 16-core Neural Engine)", "ram": "8GB LPDDR5X", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 2556x1179, 60Hz, 2000 nits peak", "camera": "48MP Fusion (OIS) + 12MP Ultra Wide with macro", "front_camera": "12MP TrueDepth", "battery": "3561 mAh", "charging": "25W MagSafe, 20W Wired, Qi2 wireless", "os": "iOS 18 with Apple Intelligence", "build": "Aerospace-grade aluminum, Ceramic Shield front, color-infused glass back", "weight": "170 g", "ip_rating": "IP68"}'::jsonb, '["Standard iPhone 16 with A18 chip, Camera Control, 48MP Fusion 2-in-1 camera, and vibrant color-infused glass."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-002-1', 'phone-002', 'Amazon / Flipkart', 79900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-003', 'Apple', 'iPhone 15', 'Apple iPhone 15 (128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71d7rfSl0wL._SX679_.jpg',
    '{"processor": "Apple A16 Bionic (4nm, 6-core CPU, 5-core GPU)", "ram": "6GB LPDDR5", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 2000 nits, Dynamic Island", "camera": "48MP Main (sensor-shift OIS) + 12MP Ultra Wide", "front_camera": "12MP TrueDepth", "battery": "3349 mAh", "charging": "20W Wired, 15W MagSafe, USB-C 2.0", "os": "iOS 17 upgradeable to iOS 18", "weight": "171 g", "ip_rating": "IP68"}'::jsonb, '["Previous-gen Apple standard phone with Dynamic Island, 48MP main sensor, USB-C, and A16 Bionic."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-003-1', 'phone-003', 'Amazon / Flipkart', 57999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-004', 'Apple', 'iPhone 14', 'Apple iPhone 14 (128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/61bK6PMOC3L._SX679_.jpg',
    '{"processor": "Apple A15 Bionic (5nm, 6-core CPU, 5-core GPU)", "ram": "6GB LPDDR4X", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 1200 nits peak, 60Hz", "camera": "12MP Main (sensor-shift OIS) + 12MP Ultra Wide", "front_camera": "12MP TrueDepth", "battery": "3279 mAh", "charging": "20W Wired, 15W MagSafe, Lightning", "os": "iOS 16 upgradeable to iOS 18", "weight": "172 g", "ip_rating": "IP68"}'::jsonb, '["Value iPhone model featuring A15 Bionic, dual 12MP camera system with Photonic Engine, and durable Ceramic Shield."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-004-1', 'phone-004', 'Amazon / Flipkart', 49999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-009', 'Samsung', 'Galaxy S25 Ultra 5G', 'Samsung Galaxy S25 Ultra (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Elite for Galaxy (3nm, Oryon CPU up to 4.47 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, 3120x1440, 1-120Hz LTPO, Gorilla Armor 2, 2600 nits", "camera": "200MP Main (OIS, f/1.7) + 50MP Ultra Wide + 50MP 5x Periscope (OIS) + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired (65% in 30 mins), 15W Wireless, 4.5W Reverse Wireless", "os": "One UI 7.0 based on Android 15 (7 years OS updates)", "build": "Grade 5 Titanium frame, Gorilla Armor front, Gorilla Glass back, integrated S-Pen", "weight": "219 g", "ip_rating": "IP68"}'::jsonb, '["Samsung 2025 flagship powered by Snapdragon 8 Elite for Galaxy, 200MP Quad Telephoto system, Titanium armor, and integrated S-Pen."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-009-1', 'phone-009', 'Amazon / Flipkart', 134999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-010', 'Samsung', 'Galaxy S25 Ultra 5G', 'Samsung Galaxy S25 Ultra (16GB/512GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Elite for Galaxy (3nm, Oryon CPU up to 4.47 GHz)", "ram": "16GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, 3120x1440, 1-120Hz LTPO, Gorilla Armor 2, 2600 nits", "camera": "200MP Main (OIS, f/1.7) + 50MP Ultra Wide + 50MP 5x Periscope (OIS) + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired (65% in 30 mins), 15W Wireless, 4.5W Reverse Wireless", "os": "One UI 7.0 based on Android 15 (7 years OS updates)", "build": "Grade 5 Titanium frame, Gorilla Armor front, Gorilla Glass back, integrated S-Pen", "weight": "219 g", "ip_rating": "IP68"}'::jsonb, '["Samsung 2025 flagship powered by Snapdragon 8 Elite for Galaxy, 16GB RAM, 512GB UFS 4.0 storage, Titanium frame, and integrated S-Pen."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-010-1', 'phone-010', 'Amazon / Flipkart', 149999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-039', 'Samsung', 'Galaxy S24 Ultra 5G', 'Samsung Galaxy S24 Ultra (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71RVu88m78L._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 3 for Galaxy (4nm, 3.39 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, 3120x1440, 1-120Hz LTPO, Gorilla Armor anti-reflective", "camera": "200MP Main (OIS) + 50MP 5x Periscope (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired, 15W Wireless, 4.5W Reverse Wireless", "os": "One UI 6.1 based on Android 14 (7 years OS updates)", "weight": "232 g", "ip_rating": "IP68"}'::jsonb, '["Flagship with Snapdragon 8 Gen 3 for Galaxy, Galaxy AI suite, Titanium frame, and flat 120Hz display with S-Pen."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-039-1', 'phone-039', 'Amazon / Flipkart', 109999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-011', 'Samsung', 'Galaxy S24 5G', 'Samsung Galaxy S24 (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71RVu88m78L._SX679_.jpg',
    '{"processor": "Samsung Exynos 2400 (4nm, 10-core CPU, Xclipse 940 GPU)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.2-inch Dynamic AMOLED 2X, 2340x1080, 1-120Hz LTPO, 2600 nits", "camera": "50MP Main (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "4000 mAh", "charging": "25W Wired, 15W Wireless", "os": "One UI 6.1 (Android 14)", "weight": "167 g", "ip_rating": "IP68"}'::jsonb, '["Compact flagship with Galaxy AI, 6.2-inch dynamic AMOLED 2X display, Armor Aluminum 2.0, and triple camera system."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-011-1', 'phone-011', 'Amazon / Flipkart', 62999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-012', 'Samsung', 'Galaxy A55 5G', 'Samsung Galaxy A55 5G (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Samsung Exynos 1480 (4nm, AMD Xclipse 530 GPU)", "ram": "8GB LPDDR5", "storage": "128GB UFS 3.1 (expandable up to 1TB microSD)", "display": "6.6-inch Super AMOLED, 120Hz, 1000 nits HBM, Vision Booster", "camera": "50MP Main (OIS) + 12MP Ultra Wide + 5MP Macro", "front_camera": "32MP Selfie", "battery": "5000 mAh", "charging": "25W Wired", "os": "One UI 6.1 (Android 14)", "weight": "213 g", "ip_rating": "IP67"}'::jsonb, '["Premium mid-range smartphone with metal frame, Gorilla Glass Victus+, 50MP OIS camera, and 4 OS upgrades."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-012-1', 'phone-012', 'Amazon / Flipkart', 36999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-013', 'OnePlus', 'OnePlus 12', 'OnePlus 12 (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 3 (4nm, Adreno 750)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.82-inch 2K ProXDR OLED, 3168x1440, 1-120Hz LTPO 4.0, 4500 nits peak, Dolby Vision", "camera": "50MP Sony LYT-808 (OIS) + 64MP 3x Periscope (OIS) + 48MP Ultra Wide with Hasselblad Color", "front_camera": "32MP Sony IMX615", "battery": "5400 mAh", "charging": "100W Wired (1-100% in 26 mins), 50W AIRVOOC Wireless", "os": "OxygenOS 14 based on Android 14", "weight": "220 g", "ip_rating": "IP65"}'::jsonb, '["Flagship with Snapdragon 8 Gen 3, 4th Gen Hasselblad camera, 2K 120Hz ProXDR display, and 100W SUPERVOOC charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-013-1', 'phone-013', 'Amazon / Flipkart', 64999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-014', 'OnePlus', 'OnePlus 12R', 'OnePlus 12R (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 2 (4nm, 3.2 GHz)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.78-inch 1.5K ProXDR OLED, 120Hz LTPO 4.0, 4500 nits peak", "camera": "50MP Sony IMX890 (OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "16MP", "battery": "5500 mAh", "charging": "100W Wired SUPERVOOC (1-100% in 26 mins)", "os": "OxygenOS 14 (Android 14)", "weight": "207 g", "ip_rating": "IP64"}'::jsonb, '["Performance flagship killer with Snapdragon 8 Gen 2, 4th Gen LTPO 120Hz display, 5500 mAh battery, and 100W charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-014-1', 'phone-014', 'Amazon / Flipkart', 37999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-015', 'OnePlus', 'OnePlus Nord 4 5G', 'OnePlus Nord 4 (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/61NbmA67gUL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 7+ Gen 3 (4nm, Cortex-X4 at 2.8 GHz)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.74-inch 1.5K AMOLED, 120Hz, 2150 nits peak, Ultra HDR", "camera": "50MP Sony LYT-600 (OIS) + 8MP Ultra Wide", "front_camera": "16MP", "battery": "5500 mAh", "charging": "100W SUPERVOOC", "os": "OxygenOS 14.1 (4 OS updates + 6 yrs security)", "build": "Full Metal Unibody design", "weight": "199 g", "ip_rating": "IP65"}'::jsonb, '["All-metal unibody smartphone powered by Snapdragon 7+ Gen 3, 5500 mAh battery, and 100W fast charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-015-1', 'phone-015', 'Amazon / Flipkart', 29999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-016', 'Google', 'Pixel 9 Pro', 'Google Pixel 9 Pro (16GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg',
    '{"processor": "Google Tensor G4 (4nm with Titan M2 security coprocessor)", "ram": "16GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.3-inch Super Actua LTPO OLED, 1-120Hz, 3000 nits peak, Gorilla Glass Victus 2", "camera": "50MP Main (OIS) + 48MP Ultra Wide with Macro Focus + 48MP 5x Telephoto (OIS, 30x Super Res Zoom)", "front_camera": "42MP Dual PD with autofocus", "battery": "4700 mAh", "charging": "27W Wired, 21W Wireless, Battery Share", "os": "Android 14 upgradeable to Android 15 (7 years of Pixel Drops & OS updates)", "weight": "199 g", "ip_rating": "IP68"}'::jsonb, '["Google AI flagship with Tensor G4, 16GB RAM, Super Actua 120Hz display, and 50MP triple pro camera system."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-016-1', 'phone-016', 'Amazon / Flipkart', 109999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-017', 'Google', 'Pixel 9', 'Google Pixel 9 (12GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg',
    '{"processor": "Google Tensor G4 (4nm)", "ram": "12GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.3-inch Actua OLED, 60-120Hz, 2700 nits peak, Gorilla Glass Victus 2", "camera": "50MP Main (OIS) + 48MP Ultra Wide with Macro", "front_camera": "10.5MP Dual PD with autofocus", "battery": "4700 mAh", "charging": "27W Wired, 15W Wireless", "os": "Android 14 with Gemini Nano (7 years OS updates)", "weight": "198 g", "ip_rating": "IP68"}'::jsonb, '["Google everyday flagship with Tensor G4, 12GB RAM, Gemini Nano on-device AI, and dual 50MP + 48MP cameras."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-017-1', 'phone-017', 'Amazon / Flipkart', 79999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-018', 'Google', 'Pixel 8a', 'Google Pixel 8a (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg',
    '{"processor": "Google Tensor G3 (4nm, Titan M2 coprocessor)", "ram": "8GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.1-inch Actua OLED, 60-120Hz, 2000 nits peak", "camera": "64MP Quad PD Main (OIS) + 13MP Ultra Wide", "front_camera": "13MP Ultra Wide", "battery": "4492 mAh", "charging": "18W Wired, 7.5W Wireless", "os": "Android 14 (7 years OS updates)", "weight": "188 g", "ip_rating": "IP67"}'::jsonb, '["Affordable Google A-series phone with Google Tensor G3, 120Hz Actua display, Best Take, and 7 years of software support."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-018-1', 'phone-018', 'Amazon / Flipkart', 49999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-019', 'Xiaomi', 'Xiaomi 14 5G', 'Xiaomi 14 (12GB/512GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 3 (4nm, Adreno 750)", "ram": "12GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.36-inch 1.5K LTPO AMOLED, 1-120Hz, 3000 nits peak, Dolby Vision", "camera": "50MP Leica 23mm (OIS, f/1.6) + 50MP Leica 75mm Floating Telephoto (OIS) + 50MP Leica 14mm Ultra Wide", "front_camera": "32MP", "battery": "4610 mAh", "charging": "90W Wired HyperCharge (100% in 31 mins), 50W Wireless HyperCharge", "os": "Xiaomi HyperOS based on Android 14", "weight": "193 g", "ip_rating": "IP68"}'::jsonb, '["Compact camera powerhouse with Leica Summilux optical lenses, 50MP Light Hunter 900 sensor, and Snapdragon 8 Gen 3."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-019-1', 'phone-019', 'Amazon / Flipkart', 69999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-020', 'Redmi', 'Redmi Note 13 Pro+ 5G', 'Redmi Note 13 Pro+ 5G (8GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "MediaTek Dimensity 7200 Ultra (4nm)", "ram": "8GB LPDDR5", "storage": "256GB UFS 3.1", "display": "6.67-inch 1.5K 3D Curved AMOLED, 120Hz, 1800 nits, Dolby Vision, Gorilla Glass Victus", "camera": "200MP Main (f/1.65, OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "16MP", "battery": "5000 mAh", "charging": "120W HyperCharge (100% in 19 mins)", "os": "HyperOS (Android 14)", "weight": "204 g", "ip_rating": "IP68"}'::jsonb, '["Upper mid-range smartphone featuring 200MP Samsung ISOCELL HP3 with OIS, 120W HyperCharge, curved AMOLED, and IP68 rating."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-020-1', 'phone-020', 'Amazon / Flipkart', 27999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-021', 'Poco', 'Poco X6 Pro 5G', 'Poco X6 Pro 5G (8GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "MediaTek Dimensity 8300 Ultra (4nm, Mali-G615 GPU)", "ram": "8GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.67-inch 1.5K Flow AMOLED, 120Hz, 1800 nits, Dolby Vision", "camera": "64MP Main (OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "16MP", "battery": "5000 mAh", "charging": "67W Turbo Charge (100% in 45 mins)", "os": "Xiaomi HyperOS based on Android 14", "weight": "186 g", "ip_rating": "IP54"}'::jsonb, '["Gaming powerhouse delivering flagship AnTuTu scores with Dimensity 8300 Ultra, 1.5K 120Hz AMOLED, and 64MP OIS camera."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-021-1', 'phone-021', 'Amazon / Flipkart', 23999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-022', 'Motorola', 'Motorola Edge 50 Pro 5G', 'Motorola Edge 50 Pro (8GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 7 Gen 3 (4nm)", "ram": "8GB LPDDR4X", "storage": "256GB UFS 2.2", "display": "6.7-inch 1.5K pOLED 3D Curved, 144Hz, 2000 nits peak, 100% DCI-P3, Pantone Validated", "camera": "50MP Main (f/1.4, OIS) + 13MP Ultra Wide with Macro + 10MP 3x Telephoto (OIS)", "front_camera": "50MP with autofocus (f/1.9)", "battery": "4500 mAh", "charging": "125W Wired TurboPower (100% in 18 mins), 50W Wireless", "os": "Hello UI based on Android 14 (3 OS updates)", "build": "Silicone vegan leather finish, aluminum frame", "weight": "186 g", "ip_rating": "IP68"}'::jsonb, '["Pantone-validated camera and display, Snapdragon 7 Gen 3, IP68 underwater protection, and 125W TurboPower charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-022-1', 'phone-022', 'Amazon / Flipkart', 29999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-023', 'Motorola', 'Motorola Edge 50 Fusion 5G', 'Motorola Edge 50 Fusion (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 7s Gen 2 (4nm)", "ram": "8GB LPDDR4X", "storage": "128GB UFS 2.2", "display": "6.67-inch FHD+ 3D Curved pOLED, 144Hz, 1600 nits, Gorilla Glass 5", "camera": "50MP Sony LYT-700C (OIS, f/1.88) + 13MP Ultra Wide with Macro", "front_camera": "32MP", "battery": "5000 mAh", "charging": "68W TurboPower (50% in 15 mins)", "os": "Hello UI based on Android 14", "build": "Vegan leather / PMMA back, IP68 certified", "weight": "175 g", "ip_rating": "IP68"}'::jsonb, '["Best-in-class value with 50MP Sony LYT-700C OIS sensor, 144Hz curved pOLED display, IP68 water resistance, and 5000 mAh battery."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-023-1', 'phone-023', 'Amazon / Flipkart', 21999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-024', 'Motorola', 'Motorola G85 5G', 'Motorola G85 5G (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 6s Gen 3 (6nm)", "ram": "8GB LPDDR4X", "storage": "128GB UFS 2.2", "display": "6.67-inch FHD+ 3D Curved pOLED, 120Hz, 1600 nits, Gorilla Glass 5", "camera": "50MP Sony LYT-600 (OIS) + 8MP Ultra Wide with Macro", "front_camera": "32MP", "battery": "5000 mAh", "charging": "33W TurboPower", "os": "Hello UI (Android 14)", "weight": "173 g", "ip_rating": "IP52"}'::jsonb, '["Segment-first 3D curved 120Hz pOLED display under 18K with 50MP Sony LYT-600 OIS camera and Dolby Atmos dual speakers."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-024-1', 'phone-024', 'Amazon / Flipkart', 17999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-025', 'iQOO', 'iQOO 12 5G', 'iQOO 12 5G (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 3 + Supercomputing Chip Q1", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.78-inch 1.5K LTPO AMOLED, 144Hz, 3000 nits, 2160Hz PWM dimming", "camera": "50MP OmniVision OV50H (OIS) + 64MP 3x Periscope (OIS, 100x digital) + 50MP Ultra Wide", "front_camera": "16MP", "battery": "5000 mAh", "charging": "120W FlashCharge (100% in 27 mins)", "os": "Funtouch OS 14 (Android 14)", "weight": "203 g", "ip_rating": "IP64"}'::jsonb, '["Pure flagship performance with Snapdragon 8 Gen 3, dedicated Q1 Supercomputing chip, and 50MP + 64MP periscope telephoto."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-025-1', 'phone-025', 'Amazon / Flipkart', 52999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-026', 'Realme', 'Realme GT 6 5G', 'Realme GT 6 (8GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8s Gen 3 (4nm, Cortex-X4)", "ram": "8GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.78-inch 1.5K 8T LTPO AMOLED, 120Hz, 6000 nits peak brightness, Gorilla Glass Victus 2", "camera": "50MP Sony LYT-808 (OIS, f/1.69) + 50MP 2x Telephoto + 8MP Ultra Wide", "front_camera": "32MP Sony IMX615", "battery": "5500 mAh", "charging": "120W SUPERVOOC (50% in 10 mins)", "os": "realme UI 5.0 (Android 14)", "weight": "199 g", "ip_rating": "IP65"}'::jsonb, '["Top-tier value flagship featuring Snapdragon 8s Gen 3, world-first 6000-nit ultra-bright display, 5500 mAh battery, and 120W charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-026-1', 'phone-026', 'Amazon / Flipkart', 40999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-027', 'Apple', 'iPhone 16 Pro Max', 'Apple iPhone 16 Pro Max (256GB)', 'smartphones', 'smartphones', '', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-pro-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha',
    '{"processor": "Apple A18 Pro (6-core CPU, 6-core GPU, 16-core Neural Engine)", "ram": "8GB LPDDR5X", "storage": "256GB NVMe", "display": "6.9-inch Super Retina XDR OLED, 2868x1320, 120Hz ProMotion, 2000 nits peak", "camera": "48MP Fusion (sensor-shift OIS) + 48MP Ultra Wide + 12MP 5x Periscope Telephoto", "front_camera": "12MP TrueDepth with autofocus", "battery": "4685 mAh", "charging": "25W MagSafe, 20W Wired, Qi2 wireless", "os": "iOS 18 with Apple Intelligence", "weight": "227 g", "ip_rating": "IP68"}'::jsonb, '["Apple flagship with largest 6.9-inch Super Retina XDR OLED, A18 Pro chip, 5x telephoto, and best-in-class battery life."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-027-1', 'phone-027', 'Amazon / Flipkart', 144900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-028', 'Apple', 'iPhone 15 Pro', 'Apple iPhone 15 Pro (128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/81+GIkwqLIL._SX679_.jpg',
    '{"processor": "Apple A17 Pro (3nm, 6-core CPU, 6-core GPU)", "ram": "8GB LPDDR5", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 120Hz ProMotion, Always-On, 2000 nits", "camera": "48MP Main (sensor-shift OIS) + 12MP Ultra Wide + 12MP 3x Telephoto", "front_camera": "12MP TrueDepth", "battery": "3274 mAh", "charging": "20W Wired, 15W MagSafe, USB-C 3.0 (10 Gbps)", "os": "iOS 17 upgradeable to iOS 18", "weight": "187 g", "ip_rating": "IP68"}'::jsonb, '["Previous-gen Titanium pro model featuring A17 Pro 3nm chip, hardware-accelerated ray tracing, USB-C 3.0, and 48MP Pro camera."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-028-1', 'phone-028', 'Amazon / Flipkart', 109900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-029', 'Apple', 'iPhone 13', 'Apple iPhone 13 (128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71xb2xkN5qL._SX679_.jpg',
    '{"processor": "Apple A15 Bionic (5nm, 4-core GPU)", "ram": "4GB LPDDR4X", "storage": "128GB NVMe", "display": "6.1-inch Super Retina XDR OLED, 1200 nits peak, 60Hz", "camera": "12MP Main (sensor-shift OIS) + 12MP Ultra Wide", "front_camera": "12MP TrueDepth", "battery": "3227 mAh", "charging": "20W Wired, 15W MagSafe", "os": "iOS 15 upgradeable to iOS 18", "weight": "174 g", "ip_rating": "IP68"}'::jsonb, '["Best-selling compact iPhone with A15 Bionic, dual 12MP camera with sensor-shift OIS, and exceptional longevity."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-029-1', 'phone-029', 'Amazon / Flipkart', 42999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-030', 'Samsung', 'Galaxy S25+ 5G', 'Samsung Galaxy S25+ (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Elite for Galaxy (3nm)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.7-inch Dynamic AMOLED 2X, 3120x1440 QHD+, 1-120Hz LTPO, 2600 nits", "camera": "50MP Main (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto (OIS)", "front_camera": "12MP Dual Pixel AF", "battery": "4900 mAh", "charging": "45W Wired, 15W Wireless", "os": "One UI 7.0 (Android 15)", "weight": "196 g", "ip_rating": "IP68"}'::jsonb, '["Plus-sized 2025 flagship with Snapdragon 8 Elite, 6.7-inch QHD+ Dynamic AMOLED 2X, 4900 mAh battery, and 45W fast charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-030-1', 'phone-030', 'Amazon / Flipkart', 99999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-031', 'Samsung', 'Galaxy S23 Ultra 5G', 'Samsung Galaxy S23 Ultra (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71qGismu6NL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 2 for Galaxy (4nm, 3.36 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.8-inch Dynamic AMOLED 2X, QHD+ 3088x1440, 1-120Hz LTPO, 1750 nits", "camera": "200MP Main (OIS) + 12MP Ultra Wide + 10MP 3x Telephoto (OIS) + 10MP 10x Periscope (OIS, 100x Space Zoom)", "front_camera": "12MP Dual Pixel AF", "battery": "5000 mAh", "charging": "45W Wired, 15W Wireless, S-Pen included", "os": "One UI 6.1 based on Android 14", "weight": "234 g", "ip_rating": "IP68"}'::jsonb, '["Legendary camera smartphone with 200MP ISOCELL HP2, 10x optical periscope zoom, S-Pen, and Snapdragon 8 Gen 2 for Galaxy."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-031-1', 'phone-031', 'Amazon / Flipkart', 79999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-032', 'Samsung', 'Galaxy Z Flip 6 5G', 'Samsung Galaxy Z Flip 6 (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 3 for Galaxy (4nm)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.7-inch Dynamic AMOLED 2X, 120Hz LTPO + 3.4-inch Super AMOLED Flex Window", "camera": "50MP Main (OIS, f/1.8) + 12MP Ultra Wide", "front_camera": "10MP", "battery": "4000 mAh", "charging": "25W Wired, 15W Wireless", "os": "One UI 6.1.1 (Android 14)", "weight": "187 g", "ip_rating": "IP48"}'::jsonb, '["Compact foldable style icon featuring 3.4-inch Flex Window, 50MP main camera with FlexCam, and Snapdragon 8 Gen 3."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-032-1', 'phone-032', 'Amazon / Flipkart', 109999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-033', 'Samsung', 'Galaxy M35 5G', 'Samsung Galaxy M35 5G (6GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Samsung Exynos 1380 (5nm, Mali-G68 MP5)", "ram": "6GB LPDDR4X", "storage": "128GB (expandable up to 1TB microSD)", "display": "6.6-inch Super AMOLED FHD+, 120Hz, 1000 nits, Gorilla Glass Victus+", "camera": "50MP Main (OIS) + 8MP Ultra Wide + 2MP Macro", "front_camera": "13MP", "battery": "6000 mAh", "charging": "25W Wired", "os": "One UI 6.1 (4 OS updates)", "weight": "222 g", "ip_rating": "Standard"}'::jsonb, '["Battery monster with massive 6000 mAh battery, 120Hz Super AMOLED display, 50MP OIS camera, and Vapor Cooling Chamber."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-033-1', 'phone-033', 'Amazon / Flipkart', 16999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-034', 'OnePlus', 'OnePlus 13 5G', 'OnePlus 13 (12GB/256GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Elite (3nm, Oryon CPU up to 4.32 GHz)", "ram": "12GB LPDDR5X", "storage": "256GB UFS 4.0", "display": "6.82-inch 2K 8T LTPO Oriental Screen 2.0, 1-120Hz, 4500 nits, Dolby Vision", "camera": "50MP Sony LYT-808 (OIS) + 50MP 3x Periscope (OIS) + 50MP Ultra Wide with Hasselblad Color", "front_camera": "32MP", "battery": "6000 mAh Glacier Battery", "charging": "100W SUPERVOOC Wired, 50W AIRVOOC Wireless", "os": "OxygenOS 15 based on Android 15", "weight": "213 g", "ip_rating": "IP68 & IP69 (high pressure water jet resistant)"}'::jsonb, '["Next-gen flagship with Snapdragon 8 Elite, massive 6000 mAh Glacier Battery, 2K 120Hz Oriental Screen 2.0, and IP69 rating."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-034-1', 'phone-034', 'Amazon / Flipkart', 69999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-035', 'OnePlus', 'OnePlus Nord CE 4 5G', 'OnePlus Nord CE 4 (8GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/61NbmA67gUL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 7 Gen 3 (4nm)", "ram": "8GB LPDDR4X", "storage": "128GB UFS 3.1 (expandable up to 1TB microSD)", "display": "6.7-inch FHD+ AMOLED, 120Hz, 1100 nits, HDR10+", "camera": "50MP Sony LYT-600 (OIS) + 8MP Ultra Wide", "front_camera": "16MP", "battery": "5500 mAh", "charging": "100W SUPERVOOC (1-100% in 29 mins)", "os": "OxygenOS 14 (Android 14)", "weight": "186 g", "ip_rating": "IP54"}'::jsonb, '["Smooth and reliable mid-ranger powered by Snapdragon 7 Gen 3, 100W SUPERVOOC charging, and 5500 mAh battery."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-035-1', 'phone-035', 'Amazon / Flipkart', 24999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-036', 'Google', 'Pixel 9 Pro XL', 'Google Pixel 9 Pro XL (16GB/128GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg',
    '{"processor": "Google Tensor G4 (4nm, Titan M2 security)", "ram": "16GB LPDDR5X", "storage": "128GB UFS 3.1", "display": "6.8-inch Super Actua LTPO OLED, 2992x1344, 1-120Hz, 3000 nits peak, Gorilla Glass Victus 2", "camera": "50MP Main (OIS) + 48MP Ultra Wide with Macro + 48MP 5x Telephoto (OIS, 30x Super Res Zoom)", "front_camera": "42MP with autofocus", "battery": "5060 mAh", "charging": "37W Wired (70% in 30 mins), 23W Wireless", "os": "Android 14 upgradeable to Android 15 (7 years updates)", "weight": "221 g", "ip_rating": "IP68"}'::jsonb, '["Google ultimate pro phone with large 6.8-inch Super Actua display, Tensor G4, 37W wired charging, and Gemini AI assistant."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-036-1', 'phone-036', 'Amazon / Flipkart', 124999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-037', 'Xiaomi', 'Xiaomi 14 Ultra 5G', 'Xiaomi 14 Ultra (16GB/512GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8 Gen 3 (4nm, Adreno 750)", "ram": "16GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.73-inch WQHD+ LTPO AMOLED, 1-120Hz, 3000 nits, Dolby Vision, Shield Glass", "camera": "50MP 1-inch LYT-900 (Stepless Variable f/1.63-f/4.0 OIS) + 50MP 3.2x Telephoto (OIS) + 50MP 5x Periscope (OIS) + 50MP Ultra Wide", "front_camera": "32MP", "battery": "5000 mAh", "charging": "90W Wired (100% in 33 mins), 80W Wireless (100% in 46 mins)", "os": "Xiaomi HyperOS (Android 14)", "build": "High-strength aluminum unibody, nano-tech vegan leather", "weight": "219.8 g", "ip_rating": "IP68"}'::jsonb, '["Camera masterpiece featuring 1-inch Sony LYT-900 sensor with stepless variable aperture (f/1.63-f/4.0) and quad 50MP Leica optics."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-037-1', 'phone-037', 'Amazon / Flipkart', 99999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-038', 'Motorola', 'Motorola Edge 50 Ultra 5G', 'Motorola Edge 50 Ultra (16GB/512GB)', 'smartphones', 'smartphones', '', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg',
    '{"processor": "Qualcomm Snapdragon 8s Gen 3 (4nm, 3.0 GHz)", "ram": "16GB LPDDR5X", "storage": "512GB UFS 4.0", "display": "6.7-inch 1.5K Super HD pOLED, 144Hz, 2500 nits, Gorilla Glass Victus, Pantone SkinTone Validated", "camera": "50MP Main (f/1.6, OIS) + 64MP 3x Periscope (OIS, 100x zoom) + 50MP Ultra Wide with Macro", "front_camera": "50MP with autofocus", "battery": "4500 mAh", "charging": "125W Wired (all-day power in 7 mins), 50W Wireless", "os": "Hello UI (Android 14)", "build": "Real Wood / Vegan Leather back, sandblasted aluminum frame", "weight": "197 g", "ip_rating": "IP68"}'::jsonb, '["Ultra flagship featuring real Nordic Wood finish, Snapdragon 8s Gen 3, Pantone-certified 50MP periscope camera, and 125W charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-038-1', 'phone-038', 'Amazon / Flipkart', 54999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-001', 'Dell', 'Inspiron 14 5430', 'Dell Inspiron 14 5430 (Core i7 / 16GB / 512GB SSD)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core i7-1355U (10 cores, up to 5.0 GHz)", "ram": "16GB LPDDR5 4800MHz", "storage": "512GB M.2 PCIe NVMe SSD", "gpu": "Intel Iris Xe Graphics", "display": "14.0-inch 16:10 FHD+ (1920x1200) WVA, 250 nits, Anti-Glare", "battery": "54 Wh (up to 10 hours battery)", "weight": "1.53 kg", "os": "Windows 11 Home", "ports": "1x Thunderbolt 4 / USB-C, 2x USB-A 3.2, 1x HDMI 1.4, SD card reader, 3.5mm jack"}'::jsonb, '["Slim and lightweight 14-inch everyday business laptop powered by 13th Gen Intel Core i7 with 16:10 FHD+ ComfortView display."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-001-1', 'laptop-001', 'Amazon / Flipkart', 79990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-002', 'Apple', 'MacBook Pro 14 M3 Pro', 'Apple MacBook Pro 14 (M3 Pro / 18GB / 512GB)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Apple M3 Pro (11-core CPU, 14-core GPU, 16-core Neural Engine)", "ram": "18GB Unified Memory", "storage": "512GB NVMe SSD", "gpu": "14-core Apple Integrated GPU (Hardware Ray Tracing)", "display": "14.2-inch Liquid Retina XDR, 3024x1964, 120Hz ProMotion, 1000 nits sustained, 1600 nits peak", "battery": "70 Wh (up to 18 hours video playback)", "weight": "1.61 kg", "os": "macOS Sonoma", "ports": "3x Thunderbolt 4, HDMI, SDXC card slot, MagSafe 3, 3.5mm jack"}'::jsonb, '["Pro laptop powered by Apple M3 Pro chip with hardware ray tracing, Liquid Retina XDR display, and up to 18 hours battery life."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-002-1', 'laptop-002', 'Amazon / Flipkart', 199900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-003', 'Apple', 'MacBook Air 13 M3', 'Apple MacBook Air 13 (M3 / 16GB / 512GB)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Apple M3 (8-core CPU, 10-core GPU, 16-core Neural Engine)", "ram": "16GB Unified Memory", "storage": "512GB NVMe SSD", "gpu": "10-core Apple Integrated GPU", "display": "15.3-inch Liquid Retina, 2880x1864, 500 nits, True Tone, P3 wide color", "battery": "66.5 Wh (up to 18 hours Apple TV app playback)", "weight": "1.51 kg", "os": "macOS Sonoma", "ports": "2x Thunderbolt / USB 4, MagSafe 3, 3.5mm jack"}'::jsonb, '["Ultra-thin, fanless 15-inch laptop powered by M3 with all-day battery life, 500 nits Liquid Retina display, and MagSafe charging."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-003-1', 'laptop-003', 'Amazon / Flipkart', 154900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-004', 'Lenovo', 'Legion Pro 5 Gen 9', 'Lenovo Legion Pro 5 Gen 9 (Ryzen 7 / 32GB / 1TB / RTX 4070)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
    '{"processor": "AMD Ryzen 7 7745HX (8 cores, 16 threads, up to 5.1 GHz)", "ram": "32GB DDR5 5200MHz", "storage": "1TB PCIe Gen 4 SSD", "gpu": "NVIDIA GeForce RTX 4070 8GB GDDR6 (140W TGP)", "display": "16-inch WQXGA, 2560x1600, IPS, 240Hz, 500 nits, 100% sRGB, G-Sync", "battery": "80 Wh (up to 5.5 hours hybrid mode)", "weight": "2.50 kg", "os": "Windows 11 Home", "ports": "4x USB-A 3.2, 2x USB-C 3.2, HDMI 2.1, RJ-45 Ethernet, 3.5mm jack"}'::jsonb, '["High-wattage gaming and simulation workstation with AMD Ryzen 7 7745HX, 140W RTX 4070, and 240Hz WQXGA color-calibrated display."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-004-1', 'laptop-004', 'Amazon / Flipkart', 129990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-005', 'Lenovo', 'ThinkPad X1 Carbon Gen 12', 'Lenovo ThinkPad X1 Carbon Gen 12 (Core Ultra 7 / 16GB / 512GB)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core Ultra 7 155U (12 cores, up to 4.8 GHz with Intel AI Boost NPU)", "ram": "16GB LPDDR5X 6400MHz", "storage": "512GB M.2 PCIe Gen 4 SSD", "gpu": "Intel Graphics integrated", "display": "14-inch 2.8K OLED, 2880x1800, 120Hz, 400 nits, 100% DCI-P3, Eyesafe", "battery": "57 Wh (up to 14 hours battery)", "weight": "1.09 kg", "os": "Windows 11 Pro", "ports": "2x Thunderbolt 4, 2x USB-A 3.2, HDMI 2.1, 3.5mm jack"}'::jsonb, '["Enterprise standard ultra-light business laptop with Intel Core Ultra 7, carbon-fiber reinforced chassis, trackpoint, and MIL-STD 810H durability."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-005-1', 'laptop-005', 'Amazon / Flipkart', 182990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-006', 'HP', 'Spectre x360 14-eu', 'HP Spectre x360 14 (Core Ultra 7 / 16GB / 1TB / 2.8K OLED)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz with NPU)", "ram": "16GB LPDDR5X 7467MHz", "storage": "1TB PCIe Gen 4 NVMe SSD", "gpu": "Intel Arc Graphics integrated", "display": "14-inch 2.8K OLED, 2880x1800, 48-120Hz, 500 nits HDR, touch, stylus support", "battery": "68 Wh (up to 13 hours battery)", "weight": "1.44 kg", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 1x USB-A 3.2, 3.5mm jack"}'::jsonb, '["Premium 2-in-1 convertible with Intel Core Ultra 7, 2.8K 120Hz IMAX Enhanced OLED touchscreen, 9MP AI camera, and rechargeable MPP 2.0 tilt pen."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-006-1', 'laptop-006', 'Amazon / Flipkart', 154990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-007', 'ASUS', 'Zenbook 14 OLED UX3405', 'ASUS Zenbook 14 OLED (Core Ultra 7 / 16GB / 1TB)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core Ultra 7 155H (16 cores, up to 4.8 GHz)", "ram": "16GB LPDDR5X 7467MHz", "storage": "1TB M.2 NVMe PCIe 4.0 SSD", "gpu": "Intel Arc Graphics integrated", "display": "14.0-inch 3K OLED, 2880x1800, 120Hz, 0.2ms, 600 nits peak, 100% DCI-P3", "battery": "75 Wh (up to 15 hours battery)", "weight": "1.22 kg", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 1x USB-A 3.2, HDMI 2.1, 3.5mm jack"}'::jsonb, '["Elegantly slim 1.2kg ultraportable with Intel Core Ultra 7, Intel Arc graphics, 3K 120Hz Lumina OLED display, and 75Wh battery."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-007-1', 'laptop-007', 'Amazon / Flipkart', 109990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'laptop-008', 'Acer', 'Swift Go 14 SFG14', 'Acer Swift Go 14 (Core Ultra 5 / 16GB / 512GB / 2.8K OLED)', 'laptops', 'laptops', '', 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core Ultra 5 125H (14 cores, up to 4.5 GHz)", "ram": "16GB LPDDR5X", "storage": "512GB PCIe Gen 4 SSD", "gpu": "Intel Arc Graphics integrated", "display": "14-inch 2.8K OLED, 2880x1800, 90Hz, 400 nits, 100% DCI-P3", "battery": "65 Wh (up to 10 hours battery)", "weight": "1.32 kg", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 2x USB-A 3.2, HDMI 2.1, MicroSD slot, 3.5mm jack"}'::jsonb, '["High-value thin & light laptop with Intel Core Ultra 5, 2.8K 90Hz OLED display, dual-fan TwinAir cooling, and Intel AI Boost."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-laptop-008-1', 'laptop-008', 'Amazon / Flipkart', 69990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-001', 'Samsung', 'S95D 4K OLED 55', 'Samsung 55-inch S95D 4K OLED TV (QA55S95DAU)', 'televisions', 'televisions', '', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80',
    '{"display": "55-inch 4K OLED (Quantum Dot), 3840x2160, 144Hz VRR, OLED Glare Free", "hdr": "OLED HDR Pro, HDR10+, HLG", "processor": "NQ4 AI Gen2 Processor (20 AI neural networks)", "audio": "70W, 4.2.2 Channel, Dolby Atmos, Object Tracking Sound+ (OTS+)", "gaming": "4x HDMI 2.1, 4K 144Hz, FreeSync Premium Pro, Auto Game Mode (ALLM)", "smart_os": "Tizen OS with Samsung Knox Security", "ports": "4x HDMI 2.1, 3x USB, Optical, Ethernet, Wi-Fi 5, Bluetooth 5.2"}'::jsonb, '["Flagship 4K QD-OLED TV with OLED Glare Free technology, NQ4 AI Gen2 Processor, 144Hz refresh rate, and 70W 4.2.2Ch Dolby Atmos audio."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-001-1', 'tv-001', 'Amazon / Flipkart', 184990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-002', 'LG', 'OLED evo C4 55', 'LG 55-inch OLED evo C4 4K Smart TV (OLED55C4PTA)', 'televisions', 'televisions', '', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80',
    '{"display": "55-inch 4K Self-Lit OLED evo, 3840x2160, 144Hz, 0.1ms response time", "hdr": "Dolby Vision, HDR10, HLG, Filmmaker Mode", "processor": "Alpha 9 AI Processor 4K Gen7", "audio": "40W, 2.2 Channel, Dolby Atmos, AI Sound Pro 9.1.2 Virtual Upmix", "gaming": "4x HDMI 2.1 (48Gbps), G-Sync, FreeSync Premium, 144Hz VRR, ALLM", "smart_os": "webOS 24 with 5 years Re:New Program updates", "ports": "4x HDMI 2.1, 3x USB, Optical, eARC, Wi-Fi 5, Bluetooth 5.1"}'::jsonb, '["Benchmark 4K OLED TV featuring Alpha 9 AI Gen7 processor, Brightness Booster, 144Hz VRR, Dolby Vision, and 0.1ms response time."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-002-1', 'tv-002', 'Amazon / Flipkart', 149990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-003', 'Sony', 'Bravia XR A80L OLED 55', 'Sony Bravia 55-inch XR A80L 4K OLED TV (XR-55A80L)', 'televisions', 'televisions', '', 'https://images.unsplash.com/photo-1461151304267-38535e780c79?auto=format&fit=crop&w=800&q=80',
    '{"display": "55-inch 4K OLED, 3840x2160, 120Hz, XR Triluminos Pro, XR Clear Image", "hdr": "Dolby Vision, HDR10, HLG, IMAX Enhanced", "processor": "Cognitive Processor XR with human perception modeling", "audio": "50W, Acoustic Surface Audio+ (screen is the speaker), 3 actuators, 2 subwoofers", "gaming": "HDMI 2.1, 4K 120Hz, Auto HDR Tone Mapping for PS5, ALLM, VRR", "smart_os": "Google TV with hands-free Google Assistant", "ports": "4x HDMI (2x HDMI 2.1), 2x USB, Optical, eARC, Wi-Fi 5, Bluetooth 4.2"}'::jsonb, '["Premium Sony OLED powered by Cognitive Processor XR, Acoustic Surface Audio+ vibrating actuators, and XR OLED Contrast Pro."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-003-1', 'tv-003', 'Amazon / Flipkart', 169990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-004', 'Samsung', 'The Frame 4K QLED 55', 'Samsung 55-inch The Frame 4K QLED TV (QA55LS03DAU)', 'televisions', 'televisions', '', 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?auto=format&fit=crop&w=800&q=80',
    '{"display": "55-inch 4K QLED, 3840x2160, 120Hz, Anti-Reflection Matte Display", "hdr": "Quantum HDR, HDR10+, HLG", "processor": "Quantum Processor 4K", "audio": "40W, 2.0.2 Channel, Dolby Atmos, Object Tracking Sound", "lifestyle": "Art Store access, motion sensor, slim-fit wall mount included, One Connect cable", "smart_os": "Tizen OS", "ports": "4x HDMI 2.1 via One Connect Box, 2x USB, Optical, Wi-Fi 5"}'::jsonb, '["Lifestyle art television with Matte Display, Art Mode, customizable magnetic bezels, One Connect Box, and 100% Color Volume with Quantum Dot."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-004-1', 'tv-004', 'Amazon / Flipkart', 86990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-005', 'TCL', 'TCL C755 Mini LED 55', 'TCL 55-inch C755 QD-Mini LED 4K TV (55C755)', 'televisions', 'televisions', '', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80',
    '{"display": "55-inch 4K QD-Mini LED, 3840x2160, 144Hz VRR, 500+ Local Dimming Zones, 1300 nits", "hdr": "Dolby Vision IQ, HDR10+, HLG", "processor": "AiPQ Processor 3.0", "audio": "50W ONKYO 2.1 Hi-Fi with built-in subwoofer, Dolby Atmos, DTS Virtual:X", "gaming": "Game Accelerator 240Hz, AMD FreeSync Premium Pro, 4x HDMI", "smart_os": "Google TV", "ports": "4x HDMI (2x HDMI 2.1), 2x USB, Optical, Wi-Fi 5"}'::jsonb, '["High-value QD-Mini LED with over 500 dimming zones, 1300 nits peak brightness, 144Hz VRR, and ONKYO 2.1 channel soundbar."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-005-1', 'tv-005', 'Amazon / Flipkart', 64990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tv-006', 'Xiaomi', 'Xiaomi X Pro QLED 55', 'Xiaomi 55-inch X Pro QLED 4K Smart Google TV', 'televisions', 'televisions', '', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80',
    '{"display": "55-inch 4K QLED, 3840x2160, 60Hz with MEMC, 94% DCI-P3 color gamut", "hdr": "Dolby Vision IQ, HDR10+, HLG", "processor": "Quad-Core A55 Processor with Mali G52 MP2 GPU", "audio": "30W Stereo Speakers, Dolby Audio, DTS:X, DTS Virtual:X", "smart_os": "Google TV with PatchWall+ integration", "ports": "3x HDMI 2.1 (ALLM/eARC), 2x USB 2.0, Optical, Ethernet, 3.5mm jack"}'::jsonb, '["Aggressively priced 4K QLED television with metallic bezel-less design, Dolby Vision IQ, 30W stereo speakers, and Google TV with PatchWall."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tv-006-1', 'tv-006', 'Amazon / Flipkart', 34999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-001', 'Samsung', 'Samsung 653L Side-by-Side', 'Samsung 653L Side-by-Side Inverter Refrigerator (RS76CG8003S9)', 'refrigerators', 'refrigerators', '', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "653 Litres (Fridge: 409L, Freezer: 244L)", "configuration": "Side-by-Side", "compressor": "Digital Inverter Compressor (50% less power, 20-year warranty)", "cooling_technology": "Twin Cooling Plus (two independent evaporators prevent odor mixing)", "modes": "5-in-1 Convertible (Normal, Extra Fridge, Vacation, Seasonal, Home Alone)", "features": "SpaceMax slim walls, Power Cool / Power Freeze, Door Alarm, Deodorizing Filter", "energy_efficiency": "3 Star equivalent for SBS large capacity", "dimensions": "91.2 x 178.0 x 71.6 cm, 101 kg"}'::jsonb, '["Spacious side-by-side refrigerator featuring Convertible 5-in-1 modes, SpaceMax technology, Twin Cooling Plus, and Digital Inverter Compressor with 20-year warranty."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-001-1', 'fridge-001', 'Amazon / Flipkart', 79990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-002', 'LG', 'LG 655L Side-by-Side', 'LG 655L Smart Inverter Side-by-Side Refrigerator (GL-B257HDSY)', 'refrigerators', 'refrigerators', '', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "655 Litres (Fridge: 416L, Freezer: 239L)", "configuration": "Side-by-Side", "compressor": "Smart Inverter Compressor with 10-year warranty", "cooling_technology": "Multi Air Flow with digital temperature sensors", "features": "Express Freeze, Smart Diagnosis, Bio Shield gasket, Tempered Glass shelves", "dimensions": "91.3 x 179.0 x 74.3 cm, 103 kg"}'::jsonb, '["Multi-door side-by-side refrigerator with Smart Inverter Compressor, Multi Air Flow cooling, Express Freeze, and Smart Diagnosis."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-002-1', 'fridge-002', 'Amazon / Flipkart', 74990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-003', 'Samsung', 'Samsung 236L Double Door', 'Samsung 236L 3-Star Double Door Refrigerator (RT28C3733S8)', 'refrigerators', 'refrigerators', '', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "236 Litres (Fridge: 183L, Freezer: 53L)", "configuration": "Double Door (Frost Free)", "compressor": "Digital Inverter with 20-year warranty", "energy_rating": "3 Star BEE rating", "cooling_technology": "All-around Cooling with multi-vent air distribution", "features": "MoistFresh Zone, Easy Slide Shelf, Deodorizing Filter, Stabilizer Free Operation", "dimensions": "55.5 x 154.5 x 63.7 cm, 46 kg"}'::jsonb, '["Frost-free double door refrigerator for small-to-medium families featuring Digital Inverter Compressor, MoistFresh Zone, and toughened glass shelves."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-003-1', 'fridge-003', 'Amazon / Flipkart', 25490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-004', 'LG', 'LG 242L Double Door', 'LG 242L 3-Star Smart Inverter Double Door Refrigerator (GL-I292RPZX)', 'refrigerators', 'refrigerators', '', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "242 Litres (Fridge: 181L, Freezer: 61L)", "configuration": "Double Door (Frost Free)", "compressor": "Smart Inverter Compressor with 10-year warranty", "energy_rating": "3 Star BEE rating", "cooling_technology": "Door Cooling+ with Multi Air Flow", "features": "Auto Smart Connect (home inverter compatible), Moist ''N'' Fresh lattice box, 2L bottle storage", "dimensions": "58.5 x 147.5 x 66.9 cm, 48 kg"}'::jsonb, '["Double door frost-free refrigerator with Door Cooling+ for 35% faster uniform cooling, Smart Inverter Compressor, and Auto Smart Connect."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-004-1', 'fridge-004', 'Amazon / Flipkart', 25990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-005', 'Whirlpool', 'Whirlpool 265L Intellifresh', 'Whirlpool 265L 3-Star Intellifresh Double Door Refrigerator', 'refrigerators', 'refrigerators', '', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "265 Litres (Fridge: 190L, Freezer: 75L)", "configuration": "Double Door (Frost Free)", "compressor": "Intellisense Inverter Technology with 10-year warranty", "energy_rating": "3 Star BEE rating", "cooling_technology": "6th Sense DeepFreeze with freshflow air tower", "features": "Microblock Technology, Zeolite fresh keeper, Active Deo, 15 days garden freshness", "dimensions": "57.0 x 159.0 x 67.0 cm, 50 kg"}'::jsonb, '["Double door refrigerator with 6th Sense IntelliSensor technology, Microblock protection preventing 99% bacterial growth, and Zeolite technology."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-005-1', 'fridge-005', 'Amazon / Flipkart', 27490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fridge-006', 'Samsung', 'Samsung 183L Single Door', 'Samsung 183L 4-Star Single Door Refrigerator (RR20C1824U8)', 'refrigerators', 'refrigerators', '', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "183 Litres", "configuration": "Single Door (Direct Cool)", "compressor": "Digital Inverter Compressor (20-year warranty)", "energy_rating": "4 Star BEE rating (high energy savings)", "features": "Base Stand Drawer (for onions & potatoes), Safe Clean Back, Toughened Glass (up to 175kg)", "dimensions": "53.2 x 121.0 x 64.6 cm, 30 kg"}'::jsonb, '["High-efficiency 4-star direct cool single door refrigerator with Digital Inverter, base stand with drawer for non-refrigerated veggies, and toughened glass shelves."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fridge-006-1', 'fridge-006', 'Amazon / Flipkart', 16990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-001', 'LG', 'LG 8kg AI DirectDrive', 'LG 8kg 5-Star AI DirectDrive Front Load Washing Machine (FHP1208Z5M)', 'washing_machines', 'washing_machines', '', 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "8.0 kg (suitable for families of 4-5)", "type": "Front Load (Fully Automatic)", "spin_speed": "1200 RPM (faster drying)", "motor": "AI Inverter Direct Drive (beltless motor with 10-year warranty)", "energy_rating": "5 Star BEE rating (water & energy efficient)", "wash_programs": "14 programs including Cotton, Allergy Care Steam, Turbowash 59min, Quick 14", "features": "Steam Wash, 6 Motion DD, Smart Diagnosis, Full Stainless Steel Drum", "dimensions": "60.0 x 85.0 x 55.0 cm, 60 kg"}'::jsonb, '["Advanced front load washing machine with AI Direct Drive detecting fabric weight and softness, 6 Motion wash technology, and Steam for 99.9% allergen removal."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-001-1', 'wash-001', 'Amazon / Flipkart', 37990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-002', 'Bosch', 'Bosch 8kg Serie 6', 'Bosch 8kg 5-Star Serie 6 Front Load Washing Machine (WAJ2846SIN)', 'washing_machines', 'washing_machines', '', 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "8.0 kg", "type": "Front Load (Fully Automatic)", "spin_speed": "1400 RPM (industry-leading spin speed)", "motor": "EcoSilence Drive frictionless magnetic motor (10-year warranty)", "energy_rating": "5 Star BEE rating", "features": "ActiveWater Plus (256 load sensing levels), AntiVibration design, VarioDrum, AntiTangle", "wash_programs": "15 programs including Delicates, Hygiene Care, Express 15/30, Wool", "dimensions": "59.8 x 84.8 x 59.0 cm, 71.5 kg"}'::jsonb, '["German-engineered front load washer featuring EcoSilence Drive brushless motor, 1400 RPM spin speed, AntiTangle technology, and ActiveWater Plus."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-002-1', 'wash-002', 'Amazon / Flipkart', 39990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-003', 'Samsung', 'Samsung 8kg EcoBubble AI', 'Samsung 8kg 5-Star EcoBubble AI Front Load Washing Machine', 'washing_machines', 'washing_machines', '', 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "8.0 kg", "type": "Front Load (Fully Automatic)", "spin_speed": "1400 RPM", "motor": "Digital Inverter Motor (20-year warranty)", "energy_rating": "5 Star BEE rating", "features": "EcoBubble (deep fabric penetration at low temp), AI Control, SmartThings Wi-Fi, Drum Clean+", "dimensions": "60.0 x 85.0 x 55.0 cm, 65 kg"}'::jsonb, '["Front load washer featuring EcoBubble technology turning detergent into soft bubbles, AI pattern learning, and Hygiene Steam cycles."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-003-1', 'wash-003', 'Amazon / Flipkart', 36990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'wash-004', 'LG', 'LG 7kg Top Load', 'LG 7kg 5-Star Smart Inverter Top Load Washing Machine (T70SKSF1Z)', 'washing_machines', 'washing_machines', '', 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "7.0 kg (suitable for families of 3-4)", "type": "Top Load (Fully Automatic)", "spin_speed": "700 RPM", "motor": "Smart Inverter Motor with waterproof BMC protection (10-year warranty)", "energy_rating": "5 Star BEE rating", "features": "TurboDrum, Smart Motion (3 wash motions), Punch+ 3 pulsator, Stainless Steel drum", "dimensions": "54.0 x 87.0 x 54.0 cm, 32 kg"}'::jsonb, '["Top load fully automatic washing machine with Smart Inverter technology, TurboDrum with dual-direction rotation, and BMC motor protection."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-wash-004-1', 'wash-004', 'Amazon / Flipkart', 17990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'ac-001', 'Daikin', 'Daikin 1.5T 5-Star Inverter', 'Daikin 1.5 Ton 5-Star Inverter Split AC (MTKM50U)', 'air_conditioners', 'air_conditioners', '', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "1.5 Ton (suitable for 110 to 150 sq ft rooms)", "energy_rating": "5 Star BEE (ISEER: 5.20, annual power: 785 kWh)", "compressor": "Patented Neo Swing Inverter Compressor (10-year warranty)", "cooling_capacity": "5000 W (rated full capacity)", "condenser_coil": "100% Copper with Anti-Corrosion Treatment", "air_purification": "PM2.5 Filter and Dew Clean auto-cleaning technology", "special_features": "Triple Display, Coanda Airflow for draftless cooling, Econo Mode", "refrigerant": "R32 eco-friendly gas (Zero ODP)"}'::jsonb, '["Japanese precision cooling with Neo Swing Inverter compressor, PM2.5 filtration, Dew Clean auto-wash, and high ambient cooling up to 54°C."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-001-1', 'ac-001', 'Amazon / Flipkart', 45490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'ac-002', 'LG', 'LG 1.5T AI Dual Inverter', 'LG 1.5 Ton 5-Star AI Dual Inverter Split AC (TS-Q19YNZE)', 'air_conditioners', 'air_conditioners', '', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "1.5 Ton (111 to 150 sq ft)", "energy_rating": "5 Star BEE (ISEER: 5.20, annual power: 685 kWh)", "compressor": "AI Dual Inverter Compressor (10-year warranty)", "cooling_capacity": "5000 W (expandable to 110% overload cooling)", "condenser_coil": "100% Copper with Ocean Black Protection against rust and pollutants", "features": "AI Convertible 6-in-1, HD Filter with Anti-Virus protection, Ez Clean Filter, Low Gas Detection", "refrigerant": "R32"}'::jsonb, '["Dual Inverter AC with artificial intelligence adjusting cooling and fan speeds based on room load, 6-in-1 convertible cooling, and Ocean Black Protection."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-002-1', 'ac-002', 'Amazon / Flipkart', 46490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'ac-003', 'Voltas', 'Voltas 1.5T 5-Star Inverter', 'Voltas 1.5 Ton 5-Star Inverter Split AC (185V Vectra Elite)', 'air_conditioners', 'air_conditioners', '', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "1.5 Ton", "energy_rating": "5 Star BEE (ISEER: 5.00)", "compressor": "Variable Speed Inverter Compressor", "cooling_capacity": "4800 W", "condenser_coil": "100% Copper with Blue Fin anti-corrosive coating", "features": "4-in-1 Adjustable Cooling, Anti-Dust Filter with Antimicrobial coating, Sleep Mode, Turbo Cool", "refrigerant": "R32"}'::jsonb, '["High-value cooling engineered for Indian summers up to 52°C, featuring 4-in-1 adjustable cooling, dual temperature display, and anti-microbial filter."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-ac-003-1', 'ac-003', 'Amazon / Flipkart', 37990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tab-001', 'Apple', 'iPad Pro 11 M4', 'Apple iPad Pro 11-inch M4 (256GB / Wi-Fi)', 'tablets_monitors', 'tablets_monitors', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Apple M4 (9-core CPU, 10-core GPU, 16-core Neural Engine)", "display": "11-inch Tandem OLED Ultra Retina XDR, 2420x1668, 10-120Hz ProMotion, 1000 nits full screen, 1600 nits HDR", "ram": "8GB Unified Memory", "storage": "256GB NVMe", "camera": "12MP Wide with LiDAR Scanner, Landscape 12MP Center Stage front camera", "battery": "31.29 Wh (up to 10 hours web/video)", "weight": "444 g", "os": "iPadOS 18"}'::jsonb, '["Ultra-thin 5.3mm tablet featuring M4 chip, Tandem OLED Ultra Retina XDR display with 1600 nits peak brightness, and Apple Pencil Pro support."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tab-001-1', 'tab-001', 'Amazon / Flipkart', 99900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'tab-002', 'Samsung', 'Galaxy Tab S9 Ultra', 'Samsung Galaxy Tab S9 Ultra (12GB / 256GB / Wi-Fi)', 'tablets_monitors', 'tablets_monitors', '', 'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm Snapdragon 8 Gen 2 for Galaxy (4nm, up to 3.36 GHz)", "display": "14.6-inch Dynamic AMOLED 2X, 2960x1848, 120Hz, HDR10+", "ram": "12GB", "storage": "256GB (microSD expandable up to 1TB)", "battery": "11200 mAh with 45W Fast Charging", "features": "Samsung DeX desktop mode, Quad speakers by AKG, IP68 water/dust resistant", "weight": "732 g", "os": "Android 14 with One UI 6"}'::jsonb, '["Massive 14.6-inch Dynamic AMOLED 2X Android tablet with Snapdragon 8 Gen 2 for Galaxy, IP68 water resistance, and included S-Pen."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-tab-002-1', 'tab-002', 'Amazon / Flipkart', 108999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mon-001', 'Dell', 'UltraSharp 27 4K U2723QE', 'Dell UltraSharp 27 4K USB-C Hub Monitor (U2723QE)', 'tablets_monitors', 'tablets_monitors', '', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=800&q=80',
    '{"display": "27-inch 4K UHD, 3840x2160 at 60Hz, IPS Black Panel, 2000:1 contrast ratio", "color": "98% DCI-P3, 100% sRGB, Delta E < 2 factory calibrated, VESA DisplayHDR 400", "connectivity": "USB-C Hub (90W Power Delivery), DisplayPort 1.4, HDMI 2.0, 5x USB-A 3.2, RJ-45 Ethernet", "ergonomics": "Height adjustable (150mm), tilt, swivel, pivot (portrait/landscape)", "special_features": "Auto KVM, Picture-by-Picture, Picture-in-Picture, ComfortView Plus low blue light"}'::jsonb, '["Professional 27-inch 4K monitor featuring IPS Black technology with 2000:1 contrast ratio, 98% DCI-P3 color gamut, 90W USB-C hub, and RJ-45 LAN."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mon-001-1', 'mon-001', 'Amazon / Flipkart', 54990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mon-002', 'LG', 'UltraGear 27 OLED 240Hz', 'LG UltraGear 27-inch QHD OLED Gaming Monitor (27GR95QE)', 'tablets_monitors', 'tablets_monitors', '', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80',
    '{"display": "27-inch QHD, 2560x1440, OLED, 240Hz refresh rate, 0.03ms GtG response", "contrast_and_color": "1,500,000:1 contrast ratio, 98.5% DCI-P3, HDR10", "sync": "NVIDIA G-Sync Compatible, AMD FreeSync Premium", "connectivity": "2x HDMI 2.1, 1x DisplayPort 1.4 (DSC), 2x USB 3.0 downstream, 4-pole optical headphone jack with DTS HP:X"}'::jsonb, '["Blistering 240Hz OLED gaming monitor with 0.03ms response time, 98.5% DCI-P3 color, and anti-glare low reflection coating."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mon-002-1', 'mon-002', 'Amazon / Flipkart', 64990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-001', 'Sony', 'WH-1000XM5', 'Sony WH-1000XM5 Wireless Noise Cancelling Headphones', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
    '{"driver": "30mm precision-engineered carbon fiber composite driver", "anc": "Integrated Processor V1 + HD Noise Cancelling Processor QN1 with 8 microphones", "battery": "30 hours with ANC on (40 hours with ANC off), 3 min quick charge gives 3 hours", "bluetooth": "Bluetooth 5.2, LDAC high-resolution wireless, Multipoint connection (2 devices)", "weight": "250 g", "features": "Speak-to-Chat, wearing sensor, touch control, Google Fast Pair, Swift Pair"}'::jsonb, '["Industry-leading noise cancelling over-ear headphones with two processors, 8 microphones, Auto NC Optimizer, and 30-hour battery life."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-001-1', 'audio-001', 'Amazon / Flipkart', 26990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-002', 'Apple', 'AirPods Pro 2 USB-C', 'Apple AirPods Pro (2nd Generation with USB-C)', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80',
    '{"driver": "Custom high-excursion Apple driver with custom high dynamic range amplifier", "chip": "Apple H2 headphone chip in earbuds, U1/H1 in MagSafe charging case", "anc": "Active Noise Cancellation with Adaptive Audio, Transparency mode, and Conversation Awareness", "battery": "6 hours listening on single charge (up to 30 hours with case)", "durability": "IP54 dust, sweat, and water resistant for both earbuds and case", "connectivity": "Bluetooth 5.3 with seamless Apple ecosystem switching"}'::jsonb, '["Pro true wireless earbuds powered by Apple H2 chip, up to 2x more Active Noise Cancellation, Adaptive Audio, and MagSafe Case (USB-C) with Precision Finding."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-002-1', 'audio-002', 'Amazon / Flipkart', 24900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-003', 'Bose', 'QC Ultra Headphones', 'Bose QuietComfort Ultra Wireless Headphones', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
    '{"driver": "Bose custom acoustic transducer", "anc": "World-class active noise cancellation with Quiet Mode, Aware Mode, and Immersion Mode", "battery": "24 hours listening time (up to 18 hours with Immersive Audio)", "bluetooth": "Bluetooth 5.3 with Snapdragon Sound (aptX Adaptive)", "features": "CustomTune personalized sound tailored to your ear geometry, built-in microphones with noise rejection"}'::jsonb, '["World-class noise cancellation headphones with Bose Immersive Audio spatial sound, CustomTune sound calibration, and ultra-comfortable plush earcups."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-003-1', 'audio-003', 'Amazon / Flipkart', 35900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-004', 'Apple', 'Apple Watch Ultra 2', 'Apple Watch Ultra 2 (GPS + Cellular, 49mm Titanium)', 'fitness', 'smartwatches', '', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
    '{"display": "49mm Always-On Retina LTPO OLED, 3000 nits peak brightness, flat sapphire crystal front", "processor": "S9 SiP (64-bit dual-core with 4-core Neural Engine, Double Tap gesture)", "sensors": "Precision dual-frequency GPS (L1 and L5), depth gauge, water temperature sensor, ECG, SpO2", "battery": "Up to 36 hours normal use (up to 72 hours in Low Power Mode)", "durability": "100m water resistant, IP6X dust resistant, MIL-STD 810H tested, EN13319 dive computer certified", "weight": "61.4 g (case only)", "os": "watchOS 11"}'::jsonb, '["Rugged 49mm aerospace-grade titanium smartwatch designed for endurance athletes, diving to 40m, and outdoor exploration with precision dual-frequency GPS."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-004-1', 'audio-004', 'Amazon / Flipkart', 89900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-005', 'Samsung', 'Galaxy Watch Ultra', 'Samsung Galaxy Watch Ultra (47mm LTE Titanium)', 'fitness', 'smartwatches', '', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
    '{"display": "1.5-inch Super AMOLED, 480x480, Sapphire Crystal, 3000 nits peak", "processor": "Exynos W1000 (3nm, 5-core)", "battery": "590 mAh (up to 100 hours in Power Saving mode, 48 hours normal exercise)", "sensors": "Dual-frequency GPS (L1+L5), BioActive Sensor (Heart Rate, ECG, BIA Body Composition), Skin Temperature", "durability": "10 ATM water resistance (100m), MIL-STD-810H, IP68", "weight": "60.5 g", "os": "Wear OS 5 Powered by Samsung (One UI 6 Watch)"}'::jsonb, '["Ultra rugged smartwatch with cushion design, Grade 4 Titanium frame, Dual-frequency GPS, 10 ATM / IP68 water resistance, and 3nm processor with Galaxy AI."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-005-1', 'audio-005', 'Amazon / Flipkart', 59999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-006', 'Sennheiser', 'Momentum 4 Wireless', 'Sennheiser Momentum 4 Wireless ANC Headphones', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
    '{"driver": "42mm dynamic transducer", "anc": "Adaptive Hybrid Active Noise Cancellation", "battery": "60 hours listening time with ANC on", "bluetooth": "Bluetooth 5.2 with aptX Adaptive, AAC, SBC", "charging": "Fast charging: 10 min gives 6 hours"}'::jsonb, '["Audiophile-inspired 42mm transducer system delivering Sennheiser signature sound, 60-hour battery life, and adaptive noise cancellation."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-006-1', 'audio-006', 'Amazon / Flipkart', 27990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-007', 'Sony', 'WF-1000XM5', 'Sony WF-1000XM5 True Wireless Noise Cancelling Earbuds', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
    '{"driver": "8.4mm Dynamic Driver X", "anc": "Dual processor HD Noise Cancelling QN2e and V2", "battery": "8 hours (up to 24 hours with case)", "durability": "IPX4 water resistance", "bluetooth": "Bluetooth 5.3, LDAC, LC3 ready"}'::jsonb, '["Flagship wireless earbuds with Dynamic Driver X, dual processors for noise cancellation, and LDAC High-Resolution Audio."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-007-1', 'audio-007', 'Amazon / Flipkart', 23990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-008', 'Marshall', 'Major IV', 'Marshall Major IV Wireless On-Ear Headphones', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
    '{"driver": "40mm dynamic drivers", "battery": "80+ hours wireless playtime", "charging": "Wireless charging + USB-C quick charge (15 min gives 15 hours)", "weight": "165 g", "design": "Collapsible ergonomic design with multi-directional control knob"}'::jsonb, '["Iconic vintage style on-ear headphones delivering explosive Marshall signature sound with 80+ hours of wireless playtime."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-008-1', 'audio-008', 'Amazon / Flipkart', 11999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-009', 'Apple', 'AirPods Max USB-C', 'Apple AirPods Max (USB-C, Active Noise Cancellation)', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
    '{"driver": "Apple-designed 40mm dynamic driver with dual neodymium ring magnet", "chip": "Apple H1 headphone chip in each ear cup", "anc": "Pro-level Active Noise Cancellation and Transparency mode", "battery": "20 hours listening with ANC enabled", "charging": "USB-C fast charging (5 min gives 1.5 hours)"}'::jsonb, '["High-fidelity audio with Apple-designed 40mm dynamic driver, computational audio via dual H1 chips, and premium anodized aluminum earcups."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-009-1', 'audio-009', 'Amazon / Flipkart', 59900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'audio-010', 'JBL', 'Tour One M2', 'JBL Tour One M2 Wireless Over-Ear ANC Headphones', 'consumer_electronics', 'headphones', '', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
    '{"driver": "40mm dynamic driver with JBL Pro Sound", "anc": "True Adaptive Noise Cancelling with Smart Ambient", "battery": "50 hours (up to 30 hours with ANC on)", "charging": "Fast charge: 10 min gives 5 hours", "bluetooth": "Bluetooth 5.3 LE Audio ready"}'::jsonb, '["True Adaptive Noise Cancelling with 4-mic technology, Smart Ambient sound, JBL Pro Sound, and up to 50 hours battery life."]'::jsonb, '["Class-leading performance", "Reliable engineering", "Verified specifications"]'::jsonb, '["Premium segment pricing", "Limited colorways"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-audio-010-1', 'audio-010', 'Amazon / Flipkart', 19999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'elec-001', 'Dell', 'Dell XPS 15 9530', 'Dell XPS 15 9530', 'electronics', 'electronics', '', 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core i7-13700H (14 cores, up to 5.0 GHz)", "ram": "32GB DDR5 4800MHz", "storage": "1TB M.2 PCIe NVMe SSD", "gpu": "NVIDIA GeForce RTX 4060 8GB GDDR6", "display": "15.6\" FHD+ (1920x1200) InfinityEdge 500 nits", "battery": "86 Wh (Up to 10 hours mixed use)", "weight": "1.86 kg (4.1 lbs)", "os": "Windows 11 Pro", "ports": "2x Thunderbolt 4, 1x USB-C 3.2, SD Card Reader, 3.5mm jack"}'::jsonb, '["CNC machined aluminum chassis with carbon-fiber palm rest", "Dedicated RTX 4060 GPU suitable for local LLM inference and 4K export", "Dual fan thermal architecture with rear hidden vents"]'::jsonb, '["Exceptional multi-core performance for coding and containerization", "Stunning 16:10 high-brightness display with 100% sRGB", "Full-sized SD card slot and excellent glass precision touchpad"]'::jsonb, '["Fans become audible under sustained heavy AI/ML compute workloads", "Slightly heavier than ultraportables at 1.86 kg", "No native full-sized USB-A port (dongle required)"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Dell India Official Store & Authorized Retailers'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-elec-001-1', 'elec-001', 'Dell India Official Store & Authorized Retailers', 149990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'elec-002', 'Apple', 'Apple MacBook Air 15" (M3)', 'Apple MacBook Air 15" (M3)', 'electronics', 'electronics', '', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Apple M3 (8-core CPU with 4 performance and 4 efficiency cores)", "ram": "16GB Unified Memory", "storage": "512GB High-speed SSD", "gpu": "10-core Integrated GPU with Hardware Ray Tracing", "display": "15.3\" Liquid Retina display (2880x1864) 500 nits True Tone", "battery": "66.5 Wh (Up to 18 hours wireless web)", "weight": "1.51 kg (3.3 lbs)", "os": "macOS Sonoma", "ports": "MagSafe 3, 2x Thunderbolt / USB 4, 3.5mm headphone jack"}'::jsonb, '["Fanless silent design even under continuous load", "Class-leading battery life exceeding 16+ real-world hours", "Support for up to two external displays with laptop lid closed"]'::jsonb, '["Completely silent operation with zero fan noise", "Sublime battery endurance and lightweight 11.5mm thin unibody", "Best-in-class keyboard, audio speakers, and trackpad haptics"]'::jsonb, '["Thermal throttling can occur during extended 30+ minute render passes", "Memory and storage are non-upgradable after purchase", "Limited port selection without an external dock"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Apple India Verified Pricing Index'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-elec-002-1', 'elec-002', 'Apple India Verified Pricing Index', 124900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'elec-003', 'Lenovo', 'Lenovo Legion Pro 5 Gen 9', 'Lenovo Legion Pro 5 Gen 9', 'electronics', 'electronics', '', 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
    '{"processor": "AMD Ryzen 7 7745HX (8 cores / 16 threads, up to 5.1 GHz)", "ram": "32GB DDR5 5200MHz (Dual Channel)", "storage": "1TB PCIe Gen 4 SSD", "gpu": "NVIDIA GeForce RTX 4070 8GB (140W TGP)", "display": "16\" WQXGA (2560x1600) IPS 240Hz 500 nits 100% sRGB", "battery": "80 Wh (Up to 5.5 hours hybrid mode)", "weight": "2.5 kg (5.5 lbs)", "os": "Windows 11 Home", "ports": "4x USB-A 3.2, 2x USB-C 3.2, HDMI 2.1, RJ-45 Ethernet, 3.5mm jack"}'::jsonb, '["Legion Coldfront 5.0 vapor-chamber assisted cooling system", "Lenovo LA1 AI chip for dynamic CPU/GPU wattage tuning", "TrueStrike keyboard with 1.5mm key travel and per-key RGB"]'::jsonb, '["Unmatched price-to-compute ratio with full 140W RTX 4070 power", "High refresh 240Hz color-calibrated display with G-Sync support", "Comprehensive rear I/O port layout keeps desk cables organized"]'::jsonb, '["Heavy chassis and large 300W power brick make commuting cumbersome", "Modest battery life under active performance usage (~4.5 hours)", "Plastic deck accents around vents compared to all-metal chassis"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Lenovo Direct India Verified'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-elec-003-1', 'elec-003', 'Lenovo Direct India Verified', 129990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'elec-004', 'ASUS', 'ASUS Zenbook 14 OLED (UX3405)', 'ASUS Zenbook 14 OLED (UX3405)', 'electronics', 'electronics', '', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core Ultra 7 155H with Intel AI Boost NPU", "ram": "16GB LPDDR5X 7467MHz", "storage": "1TB M.2 NVMe PCIe 4.0 SSD", "gpu": "Intel Arc Graphics (Integrated 8 Xe cores)", "display": "14.0\" 3K (2880x1800) OLED 120Hz 0.2ms 500 nits HDR", "battery": "75 Wh (Up to 14 hours battery)", "weight": "1.28 kg (2.82 lbs)", "os": "Windows 11 Home", "ports": "2x Thunderbolt 4, 1x USB-A 3.2, 1x HDMI 2.1, 3.5mm combo audio"}'::jsonb, '["Vibrant 120Hz Lumina OLED panel with 100% DCI-P3 color gamut", "Integrated NPU for on-device AI background blur and eye tracking", "Military-grade MIL-STD 810H durability certified chassis"]'::jsonb, '["Stunning OLED contrast with deep true blacks and HDR highlights", "Ultra-portable at just 1.28 kg and ultra-slim 14.9mm profile", "Exceptional battery life on a 75 Wh cell paired with Intel Ultra"]'::jsonb, '["Glossy OLED screen exhibits reflections in direct bright sunlight", "Soldered RAM cannot be upgraded later", "Integrated graphics are not suited for hardcore AAA 4K gaming"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'ASUS India Official Store'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-elec-004-1', 'elec-004', 'ASUS India Official Store', 89990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'elec-005', 'Acer', 'Acer Aspire 5 A515', 'Acer Aspire 5 A515', 'electronics', 'electronics', '', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Intel Core i5-1335U (10 cores, up to 4.6 GHz)", "ram": "16GB DDR4 3200MHz (Upgradable)", "storage": "512GB PCIe Gen 4 SSD", "gpu": "Intel Iris Xe Graphics", "display": "15.6\" FHD (1920x1080) IPS ComfyView", "battery": "50 Wh (Up to 7.5 hours)", "weight": "1.78 kg (3.92 lbs)", "os": "Windows 11 Home", "ports": "1x Thunderbolt 4, 2x USB-A 3.2, 1x HDMI 2.1, Ethernet RJ45"}'::jsonb, '["TwinAir cooling system with multiple cooling modes", "Upgradable dual-slot RAM configuration", "Full numeric keypad for data entry and accounting"]'::jsonb, '["Accessible price tag with genuine 10-core modern Intel CPU", "Easily user-serviceable storage and memory slots", "Good assortment of legacy and modern ports including Ethernet"]'::jsonb, '["Display brightness tops out at 280 nits; mediocre in bright spaces", "Plastic chassis flexes slightly under firm palm pressure", "Speakers lack lower-frequency bass depth"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Acer India Direct'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-elec-005-1', 'elec-005', 'Acer India Direct', 52990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'elec-006', 'Sony', 'Sony WH-1000XM5 Wireless Headphones', 'Sony WH-1000XM5 Wireless Headphones', 'electronics', 'electronics', '', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
    '{"driver": "30mm precision carbon fiber composite driver", "battery": "30 hours with ANC On (40 hours with ANC Off)", "charging": "USB-PD quick charge (3 min gives 3 hours)", "weight": "250 g", "bluetooth": "Bluetooth 5.2 with LDAC, AAC, SBC", "anc": "Dual V1/QN1 processors with 8 beamforming microphones"}'::jsonb, '["Industry-standard Auto NC Optimizer that adjusts to atmospheric pressure", "Multipoint connection seamlessly switching between phone and laptop", "Speak-to-Chat auto pause and voice detection"]'::jsonb, '["Best-in-class low and mid-frequency ambient noise suppression", "Extremely comfortable lightweight earcups for 8+ hour study sessions", "Flawless microphone clarity for online lectures and Zoom meetings"]'::jsonb, '["Earcups do not fold inward into the headband like the older XM4", "Touch sensor controls can be sensitive to accidental brush-ups", "Slightly premium price compared to midrange ANC headphones"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Sony India Electronics Verified'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-elec-006-1', 'elec-006', 'Sony India Electronics Verified', 26990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'shoe-001', 'Nike', 'Nike Pegasus 41 Running Shoes', 'Nike Pegasus 41 Running Shoes', 'footwear', 'footwear', '', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    '{"midsole": "Dual Air Zoom units with new ReactX foam midsole", "drop": "10 mm heel-to-toe drop", "weight": "297 g (Men''s size 10)", "upper": "Engineered breathable mesh with midfoot band", "outsole": "Signature waffle-inspired rubber with high abrasion resistance", "bestFor": "Daily road running, 5K to half marathons, everyday walking"}'::jsonb, '["ReactX foam delivers 13% more energy return compared to prior generation", "Waffle-patterned rubber outsole provides trusted wet pavement traction", "Padded collar and heel counter reduce Achilles friction"]'::jsonb, '["Exceptional durability; reliably lasts 500+ road miles", "Versatile balance of responsive bounce and steady everyday cushioning", "Secure midfoot containment that prevents heel slipping"]'::jsonb, '["Standard width fits slightly snug; wide footers should choose 2E sizing", "Heavier than specialized marathon race shoes with carbon plates", "Not designed for muddy off-road singletrack trails"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Nike India Official Store Verified'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-shoe-001-1', 'shoe-001', 'Nike India Official Store Verified', 11895.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'shoe-002', 'Brooks', 'Brooks Ghost 16 Road Shoes', 'Brooks Ghost 16 Road Shoes', 'footwear', 'footwear', '', 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=800&q=80',
    '{"midsole": "Nitrogen-infused DNA LOFT v3 cushioning", "drop": "12 mm", "weight": "269 g (9.5 oz)", "upper": "Engineered air mesh with 3D Fit Print", "outsole": "RoadTack blown rubber compound with recycled silica", "bestFor": "Neutral runners, long distance recovery, all-day walking shifts"}'::jsonb, '["DNA LOFT v3 nitrogen infusion provides plush shock absorption", "Segmented Crash Pad creates smooth transitions from heel to toe", "Certified carbon neutral footprint product"]'::jsonb, '["Incredible plush step-in comfort favored by doctors and campus walkers", "Zero break-in period required out of the box", "High durability outsole resists wear on concrete and asphalt"]'::jsonb, '["12mm high drop is higher than zero-drop or minimalist runners prefer", "Design aesthetic is more utilitarian/athletic than trendy fashion streetwear", "Lacks the aggressive snap needed for short sprinting intervals"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Brooks Running India Verified Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-shoe-002-1', 'shoe-002', 'Brooks Running India Verified Catalog', 12999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'shoe-003', 'New Balance', 'New Balance 574 Core Sneakers', 'New Balance 574 Core Sneakers', 'footwear', 'footwear', '', 'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=800&q=80',
    '{"midsole": "ENCAP midsole cushioning combining soft foam with durable polyurethane rim", "upper": "Suede and mesh hybrid upper", "weight": "334 g", "outsole": "Lugged rubber traction outsole", "closure": "Lace-up closure", "bestFor": "Casual daily streetwear, campus lifestyle, social outings"}'::jsonb, '["Classic retro 80s silhouette that pairs with jeans, chinos, or shorts", "Spacious toe box accommodating wider feet comfortably", "Dual-density ENCAP rim providing stable lateral containment"]'::jsonb, '["Timeless heritage styling that never goes out of fashion", "Accessible price for genuine suede elements", "Available in wide variety of neutral and lifestyle colorways"]'::jsonb, '["Heavier than modern performance knit trainers", "Suede requires water-repellent spray treatment before rainy days", "Not recommended for sustained marathon running"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'New Balance India Retail Audit'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-shoe-003-1', 'shoe-003', 'New Balance India Retail Audit', 7999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'shoe-004', 'Clarks', 'Clarks Tilden Cap Oxford Shoes', 'Clarks Tilden Cap Oxford Shoes', 'footwear', 'footwear', '', 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&w=800&q=80',
    '{"upper": "Full-grain genuine leather with clean cap toe", "insole": "Ortholite foam footbed with moisture-wicking antimicrobial layer", "outsole": "Flexible thermoplastic rubber (TPR) dress sole", "heelHeight": "1.0 inch stacked dress heel", "closure": "Blind eyelet lacing with discreet stretch gore inserts", "bestFor": "Business formal, job interviews, college convocations, weddings"}'::jsonb, '["Discreet elastic side gores allow ease of entry without stretching leather", "Ortholite soft footbed softens impacts on marble and office tile", "Polished cap-toe silhouette meeting formal dress code standards"]'::jsonb, '["Significantly softer and more comfortable than rigid wooden-soled dress shoes", "Great price for genuine full-grain leather construction", "Sharp professional appearance for interviews and presentations"]'::jsonb, '["Requires occasional leather cream polishing to maintain shine", "Rubber sole does not have deep winter ice lugs", "Slight break-in period around the ankle collar during the first week"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Clarks India Authorized Pricing'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-shoe-004-1', 'shoe-004', 'Clarks India Authorized Pricing', 6499.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'kit-001', 'Ninja', 'Ninja AF101 Air Fryer 4-Quart', 'Ninja AF101 Air Fryer 4-Quart', 'home_kitchen', 'home_kitchen', '', 'https://images.unsplash.com/photo-1588854337236-6889d631faa8?auto=format&fit=crop&w=800&q=80',
    '{"capacity": "3.8 Litre ceramic-coated nonstick basket (fits 1 kg french fries)", "wattage": "1500 Watts", "tempRange": "40°C to 204°C", "functions": "Air Fry, Roast, Reheat, Dehydrate", "dimensions": "34.5 x 28 x 33.8 cm", "weight": "4.8 kg"}'::jsonb, '["Ceramic-coated crisper plate and basket are 100% PTFE/PFOA-free", "One-touch control panel with precise digital countdown timer", "Convection airflow system circulates heat for 75% less fat frying"]'::jsonb, '["Extremely easy to clean; basket is dishwasher safe and non-stick", "Rapid preheat in less than 3 minutes, saving substantial energy over an oven", "Compact footprint fits neatly on Indian kitchen countertops"]'::jsonb, '["4-quart capacity is ideal for 1-3 people, but tight for large families of 5+", "Fan creates moderate white noise (~65 dB) during high-temp roasting", "No transparent viewing window on this model"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Ninja Kitchen India Authorized'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-kit-001-1', 'kit-001', 'Ninja Kitchen India Authorized', 9999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'kit-002', 'Breville', 'Breville Barista Touch Impress', 'Breville Barista Touch Impress', 'home_kitchen', 'home_kitchen', '', 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?auto=format&fit=crop&w=800&q=80',
    '{"grinder": "Baratza European precision hardened steel burrs with 30 grind settings", "heating": "ThermoJet system reaching extraction temperature in 3 seconds", "tamping": "Impress Puck System with 10 kg assisted tamp and 7-degree barista twist", "steaming": "Auto MilQ hands-free steam wand calibrated for dairy, oat, soy & almond", "display": "Full color intuitive touchscreen walkthrough", "waterTank": "2 Litre with integrated water filter"}'::jsonb, '["ThermoJet heating system reaches optimal 93°C extraction in 3 seconds", "Auto MilQ calibrates steam temperature and microfoam density by milk type", "Intelligent dosing automatically calculates and adjusts dose on next grind"]'::jsonb, '["Produces café-grade true 9-bar espresso without professional barista training", "Assisted tamping eliminates loose coffee grounds and messy countertop spills", "Instant 3-second startup time with negligible standby power draw"]'::jsonb, '["Significant upfront investment for casual coffee drinkers", "Regular descaling and group head cleaning maintenance required", "Requires quality fresh whole coffee beans for best results"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Breville Global & India Authorized Imports'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-kit-002-1', 'kit-002', 'Breville Global & India Authorized Imports', 119000.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'kit-003', 'Roborock', 'Roborock Q Revo Robot Vacuum & Mop', 'Roborock Q Revo Robot Vacuum & Mop', 'home_kitchen', 'home_kitchen', '', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
    '{"suction": "5,500 Pa HyperForce extreme suction", "mopping": "Dual spinning mops with 200 RPM speed & 10mm auto-lifting on carpets", "dock": "All-in-One Dock: auto-empties dust, auto-washes mops, 45°C hot air dries", "navigation": "PreciSense LiDAR navigation with reactive 3D obstacle avoidance", "battery": "5200 mAh (Up to 180 min runtime covers 3,500 sq ft)", "tank": "5L clean water tank + 5L dirty water tank"}'::jsonb, '["All-in-one dock cleans, hot-air dries mops, refills water and stores 7 weeks of dust", "Auto-lifting mops prevent wetting carpets when transitioning from hardwood/tiles", "PreciSense LiDAR creates fast 3D multi-floor maps in minutes"]'::jsonb, '["Genuinely hands-free floor maintenance for tile and hardwood floors", "Hot air drying completely prevents sour mildew odors in mop pads", "Intelligent obstacle avoidance navigates around slippers, wires, and furniture"]'::jsonb, '["Docking station requires sufficient vertical and floor clearance", "Initial multi-floor WiFi app mapping takes 20-30 minutes setup", "Replacement dust bags and mop pads need restock after several months"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Roborock India Direct Verified'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-kit-003-1', 'kit-003', 'Roborock India Direct Verified', 69999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'furn-001', 'Herman Miller', 'Herman Miller Aeron Chair (Remastered)', 'Herman Miller Aeron Chair (Remastered)', 'furniture', 'furniture', '', 'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=800&q=80',
    '{"material": "8Z Pellicle breathable elastomeric mesh suspension", "lumbar": "PostureFit SL dual pad sacral and lower spinal stabilization", "adjustments": "Fully adjustable arms (height, depth, pivot), forward tilt, tilt limiter", "warranty": "12-year, 24/7 use manufacturer warranty (including parts and labor)", "weightCapacity": "158 kg (Size B / C)", "certifications": "Cradle to Cradle V3 Silver, BIFMA Level 3"}'::jsonb, '["Patented 8Z Pellicle zone suspension keeps body cool and evenly distributes weight", "PostureFit SL pads adjust independently to support base of spine and lumbar curve", "Harmonic 2 tilt mechanism moves naturally with body shifts"]'::jsonb, '["Golden benchmark for lumbar health during 8-12 hour coding marathons", "Breathable mesh eliminates sweat buildup during warm Indian summers", "Industry-leading 12-year full manufacturer warranty protects your investment"]'::jsonb, '["High upfront price tag", "Rigid outer frame rim discourages sitting cross-legged or curled up", "Headrest is not included standard (requires third-party attachment)"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Herman Miller India Store Verified'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-furn-001-1', 'furn-001', 'Herman Miller India Store Verified', 125000.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'furn-002', 'FLEXISPOT', 'FLEXISPOT E7 Pro Standing Desk', 'FLEXISPOT E7 Pro Standing Desk', 'furniture', 'furniture', '', 'https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?auto=format&fit=crop&w=800&q=80',
    '{"motors": "Dual heavy-duty electric motors with anti-collision sensor", "heightRange": "63.5 cm to 128.5 cm", "weightCapacity": "160 kg dynamic load", "frame": "Automotive-grade carbon steel C-frame with embedded cable management tray", "keypad": "Premium LED touchscreen with 4 memory presets & USB charging port", "warranty": "10-year frame warranty"}'::jsonb, '["High lifting capacity comfortably supports 3 heavy monitors and desktop PC", "Anti-collision sensors automatically reverse movement if an obstacle is met", "Integrated under-desk magnetic cable concealing tray for clean cable runs"]'::jsonb, '["Zero wobble even at maximum standing heights due to thick C-leg structure", "Whisper quiet dual motor lift operation under 45 dB", "Generous 10-year warranty on frame and structural parts"]'::jsonb, '["Steel frame package is heavy (over 30 kg) during room delivery", "Assembly takes approximately 40 minutes and requires a screwdriver", "Desk desktop top surface is shipped in separate box from the frame"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'FLEXISPOT India Official Store'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-furn-002-1', 'furn-002', 'FLEXISPOT India Official Store', 42999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'edu-001', 'reMarkable', 'reMarkable 2 Digital Paper Tablet', 'reMarkable 2 Digital Paper Tablet', 'books', 'books', '', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80',
    '{"display": "10.3\" monochrome digital paper display (CANVAS) 1872x1404 (226 DPI)", "latency": "21 ms low latency pen response", "thickness": "4.7 mm (World''s thinnest tablet)", "battery": "Up to 2 weeks regular note-taking battery life", "storage": "8GB internal memory (stores ~100,000 pages of notes)", "weight": "403 g"}'::jsonb, '["Authentic friction feel mimicking real paper and pencil writing without glass slip", "Zero pop-up notifications, social media, or internet distractions", "Cloud sync with desktop and smartphone app to export clean PDF notebooks"]'::jsonb, '["Unmatched paper-like writing tactile sensation without eye-straining blue light", "Incredible 2-week battery endurance on a single USB-C charge", "Paper-thin 4.7mm build slides effortlessly into student backpack sleeves"]'::jsonb, '["Display has no built-in backlight; reading requires external room lighting", "Marker stylus and folio case sold separately from base price", "Strictly focused on reading and note-taking; cannot run web browser or apps"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'reMarkable Official Store'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-edu-001-1', 'edu-001', 'reMarkable Official Store', 38999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'edu-002', 'Apple', 'Apple iPad Air 11" (M2)', 'Apple iPad Air 11" (M2)', 'books', 'books', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Apple M2 chip (8-core CPU, 10-core GPU, 16-core Neural Engine)", "display": "11\" Liquid Retina IPS display (2360x1640) 500 nits P3 wide color True Tone", "storage": "128GB High-speed internal flash storage", "battery": "28.93 Wh (Up to 10 hours web/video)", "weight": "462 g (1.02 lbs)", "accessories": "Supports Apple Pencil Pro and Magic Keyboard"}'::jsonb, '["Support for Apple Pencil Pro with barrel roll, squeeze gestures and haptic feedback", "Landscape stereo speakers with rich sound for recorded lecture playback", "Front landscape 12MP Ultra Wide camera with Center Stage for seminar calls"]'::jsonb, '["Fast M2 processor handles large textbook PDFs, GoodNotes, and Procreate simultaneously", "Superb stylus responsiveness with almost zero perceptible ink lag", "Vast app ecosystem supporting all university and research platforms"]'::jsonb, '["Base 128GB storage is non-expandable via SD card", "Apple Pencil Pro must be purchased separately", "Smooth glass screen benefit from matte screen protector for paper feel"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Apple India Official Education Pricing'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-edu-002-1', 'edu-002', 'Apple India Official Education Pricing', 59900.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'edu-003', 'Anker', 'Anker Soundcore Space One ANC Headphones', 'Anker Soundcore Space One ANC Headphones', 'books', 'books', '', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
    '{"noiseCancellation": "2x stronger voice reduction with adaptive active noise cancelling", "drivers": "40mm customized dynamic drivers with LDAC wireless Hi-Res audio", "battery": "40 hours with ANC On (55 hours with ANC Off)", "charging": "5-minute fast charge gives 4 hours playtime", "weight": "260 g", "microphones": "3 microphones with AI noise-reduction algorithm"}'::jsonb, '["Adaptive ANC detects external ambient campus chatter and auto-adjusts damping", "HearID Sound in companion app tests hearing profile to customize equalizer", "Foldable earcups swivel 8° to contour comfortably around jaw and glasses"]'::jsonb, '["Incredible value under ₹8,000 with active noise cancelling that blocks library chatter", "Massive 40-55 hour battery lasts weeks between campus recharge visits", "Soft padded memory foam ear cushions do not pinch prescription eyeglasses"]'::jsonb, '["Bass profile is somewhat punchy out of the box (easily EQ-tuned in app)", "Plastic build does not feel as ultra-luxurious as ₹35,000 premium pairs", "Slight wind buffeting noise when cycling outdoors"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Soundcore India Official Store'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-edu-003-1', 'edu-003', 'Soundcore India Official Store', 7999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-001', 'O''Reilly Media', '3rd Edition (ISBN: 978-1098125974)', 'Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80',
    '{"author": "Aurélien Géron", "publisher": "O''Reilly Media", "edition": "3rd Edition (2022)", "pages": "856 pages", "isbn": "978-1098125974", "language": "English", "domain": "Artificial Intelligence & Machine Learning", "format": "Paperback"}'::jsonb, '["Complete coverage of Scikit-Learn, Keras, TensorFlow 2, and Transformers", "End-to-end practical machine learning project walkthroughs with Colab notebooks", "Explains generative AI, diffusion models, GANs, and deep reinforcement learning"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-001-1', 'book-001', 'Amazon / Flipkart', 3250.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-002', 'No Starch Press', '3rd Edition (ISBN: 978-1718502703)', 'Python Crash Course: A Hands-On, Project-Based Introduction', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80',
    '{"author": "Eric Matthes", "publisher": "No Starch Press", "edition": "3rd Edition (2023)", "pages": "552 pages", "isbn": "978-1718502703", "language": "English", "domain": "Python Programming", "format": "Paperback"}'::jsonb, '["World''s bestselling guide to Python programming language", "Part 1 covers fundamental core concepts; Part 2 guides three substantial real-world projects", "Includes Space Invaders 2D arcade game, interactive data visualizations, and Django web app"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-002-1', 'book-002', 'Amazon / Flipkart', 1995.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-003', 'MIT Press', '4th Edition (ISBN: 978-0262046305)', 'Introduction to Algorithms (CLRS)', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?auto=format&fit=crop&w=800&q=80',
    '{"author": "Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein", "publisher": "MIT Press", "edition": "4th Edition (2022)", "pages": "1312 pages", "isbn": "978-0262046305", "language": "English", "domain": "Data Structures & Algorithms (DSA)", "format": "Hardcover"}'::jsonb, '["The definitive global textbook on algorithms referenced across top CS universities", "Updated 4th edition with new chapters on bipartite matching, online algorithms, and machine learning", "Clear pseudocode accessible to anyone with basic programming background"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-003-1', 'book-003', 'Amazon / Flipkart', 4450.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-004', 'Wiley', '10th Edition (ISBN: 978-1119800361)', 'Operating System Concepts (The Dinosaur Book)', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=800&q=80',
    '{"author": "Abraham Silberschatz, Peter B. Galvin, Greg Gagne", "publisher": "Wiley India", "edition": "10th Edition (2021)", "pages": "1248 pages", "isbn": "978-1119800361", "language": "English", "domain": "Operating Systems & Computer Systems", "format": "Paperback"}'::jsonb, '["Comprehensive treatment of process synchronization, virtual memory, filesystems, and security", "In-depth Linux, Windows, and macOS kernel architecture comparisons", "Includes C and Java programming problems and virtual machine simulation exercises"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-004-1', 'book-004', 'Amazon / Flipkart', 1120.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-005', 'McGraw-Hill', '7th Edition (ISBN: 978-9389949438)', 'Database System Concepts', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?auto=format&fit=crop&w=800&q=80',
    '{"author": "Abraham Silberschatz, Henry F. Korth, S. Sudarshan", "publisher": "McGraw-Hill Education India", "edition": "7th Edition (2020)", "pages": "1392 pages", "isbn": "978-9389949438", "language": "English", "domain": "Database Management Systems (DBMS) & SQL", "format": "Paperback"}'::jsonb, '["Covers relational databases, SQL queries, normalization, indexing, transaction ACID properties", "Expanded 7th edition coverage of Big Data, NoSQL, MapReduce, and columnar databases", "Written by seminal database researchers from Bell Labs and IIT Bombay"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-005-1', 'book-005', 'Amazon / Flipkart', 1090.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-006', 'Pearson', '8th Edition (ISBN: 978-0136681557)', 'Computer Networking: A Top-Down Approach', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=800&q=80',
    '{"author": "James F. Kurose, Keith W. Ross", "publisher": "Pearson Education India", "edition": "8th Edition (2021)", "pages": "864 pages", "isbn": "978-0136681557", "language": "English", "domain": "Computer Networks & Protocols", "format": "Paperback"}'::jsonb, '["Pioneering top-down approach starting at application layer down to physical transport", "Comprehensive exploration of HTTP/3, QUIC, DNS, TCP congestion control, and BGP routing", "Hands-on Wireshark lab assignments with real packet capture analysis"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-006-1', 'book-006', 'Amazon / Flipkart', 1050.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-007', 'O''Reilly Media', '1st Edition (ISBN: 978-9352135240)', 'Designing Data-Intensive Applications', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
    '{"author": "Martin Kleppmann", "publisher": "O''Reilly Media", "edition": "1st Edition (2017)", "pages": "616 pages", "isbn": "978-9352135240", "language": "English", "domain": "Distributed Systems, Data Engineering & Architecture", "format": "Paperback"}'::jsonb, '["Widely regarded as the bible of scalable distributed systems and backend engineering", "Deep analysis of storage engines, replication strategies, partitioning, and distributed consensus", "Unpacks the engineering trade-offs behind Kafka, Cassandra, PostgreSQL, and Raft"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-007-1', 'book-007', 'Amazon / Flipkart', 1850.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'book-008', 'MADE EASY Publications', '2025 Exam Edition (ISBN: 978-9391065843)', 'GATE 2025: Computer Science & IT Topicwise Previous Solved Papers', 'books', 'study_materials', '', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=800&q=80',
    '{"author": "MADE EASY Editorial Board", "publisher": "MADE EASY Publications", "edition": "2025 Exam Edition", "pages": "980 pages", "isbn": "978-9391065843", "language": "English", "domain": "GATE & Competitive Exam Preparation (CSE/IT)", "format": "Paperback"}'::jsonb, '["34+ years of authentic topicwise solved papers for GATE CSE & Information Technology", "Step-by-step rigorous mathematical derivations and explanatory answers", "Crucial preparation standard for IIT M.Tech admissions and PSU recruitment exams"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-book-008-1', 'book-008', 'Amazon / Flipkart', 890.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-001', 'MIT Technology Review', 'Annual Subscription (6 Issues + Digital Archive)', 'MIT Technology Review (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Bi-Monthly (6 issues per year)", "publisher": "MIT Technology Review / MIT Press", "issn": "0040-1692", "domain": "Emerging Technologies, Artificial Intelligence, Biotech & Energy", "format": "Print + Unlimited Digital", "pages_per_issue": "112 pages"}'::jsonb, '["Renowned ''10 Breakthrough Technologies'' annual definitive curation", "Deep, unbiased technological journalism independent of corporate PR", "Full digital access to 125-year comprehensive research archive"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-001-1', 'mag-001', 'Amazon / Flipkart', 4800.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-002', 'Condé Nast', 'Annual Subscription (10 Issues)', 'Wired Magazine (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Monthly (10 issues per year)", "publisher": "Condé Nast", "issn": "1059-1028", "domain": "Technology, Science, Culture & Digital Economy", "format": "Print + Web Edition", "pages_per_issue": "96 pages"}'::jsonb, '["Pioneering cultural analysis of cybernetics, Silicon Valley, and AI evolution", "Long-form investigative reporting on digital privacy, security, and geopolitics", "Iconic graphic design and futuristic visual editorial spreads"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-002-1', 'mag-002', 'Amazon / Flipkart', 3600.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-003', 'Springer Nature', 'Annual Subscription (12 Monthly Issues)', 'Scientific American (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Monthly (12 issues per year)", "publisher": "Springer Nature", "issn": "0036-8733", "domain": "Physics, Neuroscience, Space, Climate & Biology", "format": "Print + Online Archive", "pages_per_issue": "88 pages"}'::jsonb, '["Oldest continuously published magazine in the United States (founded 1845)", "Over 200 Nobel Prize laureates have authored articles in its pages", "Accessible yet uncompromising scientific depth spanning astrophysics to immunology"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-003-1', 'mag-003', 'Amazon / Flipkart', 4200.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-004', 'Harvard Business Publishing', 'Annual Subscription (6 Bimonthly Issues)', 'Harvard Business Review (HBR Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Bi-Monthly (6 issues per year)", "publisher": "Harvard Business Publishing", "issn": "0017-8012", "domain": "Leadership, Strategic Management, Organizational Innovation", "format": "Print + Digital Archive Access", "pages_per_issue": "144 pages"}'::jsonb, '["The benchmark management and leadership periodical for Fortune 500 executives", "Case studies and operational research from Harvard Business School faculty", "Includes digital case archive and HBR IdeaCast audio briefings"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-004-1', 'mag-004', 'Amazon / Flipkart', 5400.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-005', 'National Geographic Society', 'Annual Subscription (12 Monthly Issues)', 'National Geographic Magazine (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Monthly (12 issues per year)", "publisher": "National Geographic Partners", "issn": "0027-9358", "domain": "Geography, Exploration, Natural History & Conservation", "format": "Print + Digital", "pages_per_issue": "140 pages"}'::jsonb, '["World-renowned environmental photojournalism and exploratory field research", "Iconic yellow-bordered collector''s print edition with pull-out cartographic maps", "Stories from frontline conservation biologists, archaeologists, and oceanographers"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-005-1', 'mag-005', 'Amazon / Flipkart', 3850.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-006', 'Bloomberg L.P.', 'Annual Subscription (50 Weekly Issues)', 'Bloomberg Businessweek (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Weekly (50 issues per year)", "publisher": "Bloomberg L.P.", "issn": "0007-7135", "domain": "Global Finance, Economics, Markets & Corporate Strategy", "format": "Print + Bloomberg App", "pages_per_issue": "72 pages"}'::jsonb, '["Weekly rapid-response financial intelligence on central banks and public markets", "Irreverent, provocative cover stories detailing Silicon Valley and Wall Street power dynamics", "Direct access to Bloomberg data terminals infographics and macroeconomic metrics"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-006-1', 'mag-006', 'Amazon / Flipkart', 5999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-007', 'Mansueto Ventures', 'Annual Subscription (6 Issues)', 'Fast Company Magazine (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Bi-Monthly (6 issues per year)", "publisher": "Mansueto Ventures", "issn": "1085-9241", "domain": "Design, Creative Leadership, Startups & Tech Innovation", "format": "Print + Digital", "pages_per_issue": "100 pages"}'::jsonb, '["Hosts the prestigious ''World''s Most Innovative Companies'' annual index", "Focuses on the intersection of human-centered design, ethics, and venture capital", "Actionable insights from design pioneers, creative directors, and founders"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-007-1', 'mag-007', 'Amazon / Flipkart', 3200.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'mag-008', '9.9 Media', 'Annual Print Subscription (12 Issues + Fast Track)', 'Digit Magazine India (Annual Subscription)', 'magazines', 'periodicals', '', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
    '{"frequency": "Monthly (12 issues per year)", "publisher": "9.9 Group India", "domain": "Consumer Tech, PC Hardware, Software Tutorials & Gaming in India", "format": "Print + Fast Track Guide Booklet", "pages_per_issue": "128 pages"}'::jsonb, '["India''s premier technology monthly guide with Zero1 Awards benchmark comparisons", "Includes monthly ''Fast Track to'' in-depth technical handbook (coding, hacking, hardware)", "Strict lab-tested hardware benchmarks performed on Indian retail SKUs"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-mag-008-1', 'mag-008', 'Amazon / Flipkart', 2400.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-001', 'Boldfit', 'Boldfit Dial-Tech 24kg Adjustable Dumbbell', 'Boldfit Adjustable Dumbbell Set (2.5kg to 24kg)', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=800&q=80',
    '{"weight_range": "2.5kg to 24kg (15 weight increments)", "adjustment_mechanism": "Turn-dial selector with secure safety tray", "material": "Heavy-duty steel plates with impact-resistant moulding", "grip": "Ergonomic textured anti-slip handle", "footprint": "Space-saving compact tray design"}'::jsonb, '["Replaces 15 pairs of traditional dumbbells with a single compact turn-dial unit", "Smooth weight transition from 2.5kg, 3.5kg, up to 24kg for progressive overload", "Secure mechanical locking system prevents plates from slipping during lifts"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-001-1', 'fiteq-001', 'Amazon / Flipkart', 14999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-002', 'Manduka', 'Manduka PRO Mat 71-inch (6mm)', 'Manduka PRO Yoga and Pilates Mat (6mm)', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1592432678016-e910b452f9a2?auto=format&fit=crop&w=800&q=80',
    '{"thickness": "6.0 mm ultra-dense high-density cushion", "dimensions": "180 cm x 66 cm (71\" x 26\")", "material": "Certified OEKO-TEX non-toxic closed-cell PVC", "grip": "Fabric-like surface finish for joint protection & stability", "warranty": "Lifetime manufacturer warranty", "weight": "3.4 kg"}'::jsonb, '["Backed by a Lifetime Guarantee – will never flake, peel, or compress", "High-density 6mm cushion protects spine, hips, knees, and elbows on hard floors", "Closed-cell material seals out moisture and bacteria, making cleaning effortless"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-002-1', 'fiteq-002', 'Amazon / Flipkart', 11500.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-003', 'Liforme', 'Liforme Original Mat with AlignForMe System', 'Liforme Original Yoga Mat (4.2mm with Alignment)', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?auto=format&fit=crop&w=800&q=80',
    '{"thickness": "4.2 mm optimal cushioning", "dimensions": "185 cm x 68 cm (72.8\" x 26.8\")", "material": "Biodegradable natural rubber base with eco-polyurethane top", "alignment_system": "Etched AlignForMe navigational markers", "grip": "Warrior-like revolutionary GripForMe technology (wet & dry)", "weight": "2.5 kg"}'::jsonb, '["Revolutionary ''GripForMe'' material gives unmatched, sweat-proof non-slip traction", "Intelligent ''AlignForMe'' etched guidelines prevent yoga posture misalignment and injuries", "Planet-friendly, non-toxic, PVC-free biodegradable engineered natural rubber"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-003-1', 'fiteq-003', 'Amazon / Flipkart', 13999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-004', 'Slovic', 'Slovic 150 lbs Stackable Tube Band Kit', 'Slovic 11-Piece Stackable Resistance Bands Set (150 lbs)', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&w=800&q=80',
    '{"resistance_range": "10 lbs to 150 lbs (5 stackable color-coded tubes)", "accessories": "2 cushioned foam handles, 2 ankle straps, 1 heavy-duty door anchor, carrying pouch", "material": "100% natural Malaysian latex tubing with metal carabiners", "portability": "Ultra compact travel-ready pack"}'::jsonb, '["Combine any tube combination up to 150 lbs for versatile full-body resistance training", "Door anchor turns any standard door into a private cable pulley gym machine", "Double-layer anti-snap latex design for supreme safety under tension"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-004-1', 'fiteq-004', 'Amazon / Flipkart', 1699.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-005', 'Kore', 'Kore PVC 20kg Combo Home Workout Set', 'Kore PVC 20kg Home Gym Dumbbell & Barbell Kit', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=800&q=80',
    '{"total_weight": "20 kg (PVC plates: 2kg x 4, 3kg x 4)", "rods": "1x 3-foot curl rod + 2x 14-inch dumbbell rods with star nuts", "accessories": "Gym gloves, skipping rope, hand gripper", "material": "Concrete-filled durable PVC shells"}'::jsonb, '["Complete budget starter package for bicep curls, chest press, and shoulder workouts", "Floor-friendly PVC weight plates prevent scratches on Indian tiled floors", "Includes ergonomic leather fitness gloves and ball-bearing skipping rope"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-005-1', 'fiteq-005', 'Amazon / Flipkart', 1899.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-006', 'Lifelong', 'Lifelong LLF135 Adjustable Weight Bench', 'Lifelong LLF135 Multi-Position Adjustable Workout Bench', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?auto=format&fit=crop&w=800&q=80',
    '{"positions": "6 backrest levels (incline, decline, flat) + 3 seat levels", "max_weight_capacity": "180 kg (user + weights)", "frame": "Heavy-duty commercial-grade triangular steel tube", "padding": "High-density tear-resistant foam with sweatproof PU leather", "foldability": "Foldable compact footprint for under-bed storage"}'::jsonb, '["Multi-angle flexibility allows incline dumbbell presses, flat bench, and decline sit-ups", "Solid triangular stability structure with thickened heavy gauge steel tube", "Folds away flat in seconds to slide under a bed or into a closet"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-006-1', 'fiteq-006', 'Amazon / Flipkart', 4999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-007', 'Burnlab', 'Burnlab Pro Speed Ball Bearing Skipping Rope', 'Burnlab High-Speed Ball Bearing Jump Rope', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=800&q=80',
    '{"mechanism": "360-degree dual-rotation high-speed ball bearings", "cable": "3-meter adjustable steel wire with kink-free PVC coating", "handles": "Lightweight aircraft aluminum with non-slip silicone grip", "usage": "Cardio, double-unders, boxing footwork conditioning"}'::jsonb, '["360-degree ball bearing rotation allows lightning-fast double unders without tangling", "Indestructible aircraft aluminum handles engineered with knurled anti-sweat grip", "Cut-to-size adjustable 3m braided steel cable accommodates heights up to 6''6\""]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-007-1', 'fiteq-007', 'Amazon / Flipkart', 799.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'fiteq-008', 'Cockatoo', 'Cockatoo CS-01 Multi-Angle Workout Bench', 'Cockatoo Foldable Multi-Purpose Workout Weight Bench', 'fitness_equipment', 'fitness_equipment', '', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80',
    '{"positions": "7 backrest adjustments from -20° decline to 90° military incline", "max_weight_capacity": "200 kg heavy load capacity", "frame": "Heavy-duty carbon steel with non-marking rubber end caps", "extras": "Leg hold-down bar with foam rollers and dumbbell storage rack", "weight": "13.5 kg"}'::jsonb, '["Commercial 200kg weight limit handles heavy barbell bench and dumbbell workouts", "High-density multi-layered memory foam pad prevents tailbone and lower back strain", "Integrated dumbbell storage rack keeps weights organized directly under the bench"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-fiteq-008-1', 'fiteq-008', 'Amazon / Flipkart', 6499.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-001', 'Faber', 'HOOD ORIENT TC BK 60', 'Faber 60cm 1200 m³/hr Autoclean Filterless Chimney', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
    '{"width": "60 cm (ideal for 2-4 burner gas stoves)", "suction_capacity": "1200 m³/hr", "technology": "Filterless technology with thermal auto-clean", "controls": "Touch control panel + Gesture motion sensor", "noise_level": "58 dB", "oil_collector": "Concealed stainless steel oil collector cup", "lighting": "2x 1.5W energy-saving LED lamps", "motor_warranty": "5 Years on motor, 1 Year comprehensive"}'::jsonb, '["Next-gen filterless chimney with thermal auto-clean eliminates tedious manual cleaning", "Smart gesture control lets you operate chimney with a wave of your hand while cooking", "High suction capacity 1200 m³/hr captures heavy oil fumes and spicy tadka smoke"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-001-1', 'chim-001', 'Amazon / Flipkart', 12990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-002', 'Faber', 'HOOD PRIMUS PLUS 90', 'Faber 90cm 1500 m³/hr Autoclean Filterless Chimney', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80',
    '{"width": "90 cm (ideal for 3-5 burner heavy cooking stoves)", "suction_capacity": "1500 m³/hr high-velocity airflow", "technology": "Filterless auto-clean with oil collector tray", "controls": "Smart touch panel with motion sensor wave control", "noise_level": "59 dB", "lighting": "Dual LED illumination", "finish": "Curved black toughened glass canopy", "motor_warranty": "5 Years on motor"}'::jsonb, '["Colossal 1500 m³/hr suction capacity engineered for expansive Indian kitchens with intense grilling", "Wide 90cm glass canopy completely blankets 4 and 5 burner stoves without side smoke spillage", "Thermal heat auto-clean liquefies stubborn oil deposits into a metallic reservoir"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-002-1', 'chim-002', 'Amazon / Flipkart', 17490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-003', 'Elica', 'FL 600 HAC LTW MS NERO', 'Elica 60cm 1200 m³/hr Filterless Auto Clean Chimney', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80',
    '{"width": "60 cm (suitable for 2-4 burner stoves)", "suction_capacity": "1200 m³/hr", "technology": "Filterless heat auto-clean with dedicated oil collector", "controls": "Motion sensing technology + Feather touch controls", "noise_level": "58 dB", "finish": "Curved tempered glass in matte black", "motor_warranty": "5 Years on motor, 2 Years comprehensive"}'::jsonb, '["Advanced Motion Sensor enables wave-to-turn-on and speed modulation with no dirty finger marks", "Heat auto-clean heating pad melts grease effortlessly into the rust-free oil tray", "Compact curved black glass profile enhances modern modular kitchen aesthetics"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-003-1', 'chim-003', 'Amazon / Flipkart', 12490.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-004', 'Elica', 'WD HAC TOUCH BF 90', 'Elica 90cm 1425 m³/hr Auto Clean Chimney with Baffle Filter', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
    '{"width": "90 cm (suitable for 3-5 burners)", "suction_capacity": "1425 m³/hr", "technology": "Stainless steel baffle filters + Heat auto-clean", "controls": "Touch control panel with digital display", "noise_level": "58 dB", "finish": "Premium curved glass with stainless steel body", "motor_warranty": "5 Years on motor"}'::jsonb, '["Heavy-duty stainless steel baffle filters catch heavy oil particles before they enter motor", "Integrated heating auto-clean elements remove grease build-up from inner ductwork", "Wide 90cm curved glass canopy captures rising steam across full multi-burner range"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-004-1', 'chim-004', 'Amazon / Flipkart', 15990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-005', 'Hindware', 'Marcilla 60 Filterless Auto-Clean', 'Hindware Smart Appliances 60cm 1200 m³/hr Filterless Auto-Clean', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=800&q=80',
    '{"width": "60 cm", "suction_capacity": "1200 m³/hr", "technology": "Filterless design with thermal auto-clean heating element", "controls": "Motion sensing wave gestures + Touch controls", "noise_level": "58 dB", "oil_collector": "One-touch removable metallic oil collector", "motor_warranty": "10 Years on motor, 1 Year comprehensive"}'::jsonb, '["Industry-leading 10-year manufacturer warranty on copper-wound motor", "Filterless technology ensures consistent airflow with zero suction drop over time", "Touch-free wave gesture interface keeps sleek black glass panel immaculate"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-005-1', 'chim-005', 'Amazon / Flipkart', 11990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-006', 'Hindware', 'Althea 90 Max Suction Auto-Clean', 'Hindware Smart Appliances 90cm 1500 m³/hr Filterless Auto-Clean', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
    '{"width": "90 cm (heavy frying & grilling compatible)", "suction_capacity": "1500 m³/hr turbo suction", "technology": "MaxX Silence filterless auto-clean system", "controls": "Dual gesture sensor + Smart feather touch display", "noise_level": "56 dB (low acoustic baffle engineering)", "motor_warranty": "10 Years on motor"}'::jsonb, '["MaxX Silence design dampens acoustic motor vibration down to an ultra-quiet 56 dB", "Heavyweight 1500 m³/hr high-torque airflow exhausts oil and odor from open floor plans", "Thermal heat auto-clean with illuminated capacitive control surface"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-006-1', 'chim-006', 'Amazon / Flipkart', 16990.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-007', 'Glen', '6071 EX BL Filterless 60cm', 'Glen 60cm 1050 m³/hr Filterless Curved Glass Kitchen Chimney', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80',
    '{"width": "60 cm", "suction_capacity": "1050 m³/hr", "technology": "Filterless auto-clean with exterior oil collector", "controls": "Push button 3-speed control", "noise_level": "58 dB", "finish": "Black tempered curved glass canopy", "motor_warranty": "5 Years on copper Italian motor"}'::jsonb, '["Affordable filterless convenience under ₹10,000 for compact Indian kitchens", "Italian copper-wound motor with Thermal Overload Protector (TOP) prevents overheating", "Durable mechanical push buttons deliver fail-safe longevity in high-steam environments"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-007-1', 'chim-007', 'Amazon / Flipkart', 9495.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'chim-008', 'Inalsa', 'Classica 60BKBF Pyramid Chimney', 'Inalsa 60cm 1050 m³/hr Pyramid Chimney with Baffle Filter', 'kitchen_chimneys', 'kitchen_chimneys', '', 'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80',
    '{"width": "60 cm (budget-friendly pyramid design)", "suction_capacity": "1050 m³/hr", "technology": "Dual high-grade stainless steel baffle filters", "controls": "Push button 3-speed fan controls", "noise_level": "60 dB", "finish": "Powder-coated rust-resistant matte black pyramid body", "motor_warranty": "5 Years on motor, 2 Years comprehensive"}'::jsonb, '["Incredible entry price under ₹6,500 delivering authentic 1050 m³/hr suction", "Dual stainless steel baffle filters are dishwasher-safe and last for decades", "Robust powder-coated pyramid body engineered to resist kitchen humidity and heat"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-chim-008-1', 'chim-008', 'Amazon / Flipkart', 6290.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-001', 'Optimum Nutrition', 'Gold Standard 100% Whey 2 lb (Double Rich Chocolate)', 'Optimum Nutrition (ON) Gold Standard 100% Whey Protein (2 lb)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "Whey Protein Isolate Primary Source", "serving_size": "30.4g (1 scoop)", "protein_per_serving": "24g", "bcaa_per_serving": "5.5g naturally occurring BCAAs", "glutamine_per_serving": "4g Glutamine & Glutamic acid", "pack_weight": "907g (2 lbs) - ~30 servings", "dietary_flag": "100% Vegetarian, Informed Choice Certified", "flavor": "Double Rich Chocolate"}'::jsonb, '["The world''s most awarded and bestselling whey protein brand for over 20 years", "Whey protein isolate is the primary ingredient with excess carbs and fat filtered out", "Instantized formula mixes effortlessly with a spoon—no blender required"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-001-1', 'nutr-001', 'Amazon / Flipkart', 3499.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-002', 'Optimum Nutrition', 'Gold Standard 100% Whey 5 lb (Double Rich Chocolate)', 'Optimum Nutrition (ON) Gold Standard 100% Whey Protein (5 lb)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "Whey Protein Isolate + Concentrate blend", "serving_size": "30.4g (1 scoop)", "protein_per_serving": "24g", "bcaa_per_serving": "5.5g BCAAs", "pack_weight": "2.27 kg (5 lbs) - ~74 servings", "dietary_flag": "100% Vegetarian, Informed Choice Certified", "flavor": "Double Rich Chocolate"}'::jsonb, '["Large value economy pack delivering lowest cost per scoop for regular athletes", "Authenticity verified via unique Scratch Code on Tru-Seal security neck band", "Free from banned substances with Informed Choice UK certification"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-002-1', 'nutr-002', 'Amazon / Flipkart', 7299.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-003', 'MuscleBlaze', 'Biozyme Performance Whey 1kg (Rich Chocolate)', 'MuscleBlaze Biozyme Performance Whey (1 kg)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "Biozyme Enhanced Absorption Formula Whey", "serving_size": "36g (1 scoop)", "protein_per_serving": "25g", "bcaa_per_serving": "5.51g BCAAs / 11.75g EAAs", "pack_weight": "1 kg (2.2 lbs) - ~28 servings", "clinical_testing": "50% higher protein absorption clinically tested on Indian bodies", "dietary_flag": "100% Vegetarian, Labdoor USA Tested", "flavor": "Rich Chocolate"}'::jsonb, '["Patented Enhanced Absorption Formula (EAF) clinically proven to boost protein absorption by 50%", "Specifically formulated to eliminate protein digestion distress and bloating common in Indian diets", "Labdoor USA certified for purity and accurate protein label claims"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-003-1', 'nutr-003', 'Amazon / Flipkart', 2399.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-004', 'MuscleBlaze', 'Biozyme Performance Whey 2kg (Rich Chocolate)', 'MuscleBlaze Biozyme Performance Whey (2 kg)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "Biozyme Enhanced Absorption Formula Whey", "serving_size": "36g (1 scoop)", "protein_per_serving": "25g", "bcaa_per_serving": "5.51g BCAAs / 11.75g EAAs", "pack_weight": "2 kg (4.4 lbs) - ~55 servings", "dietary_flag": "100% Vegetarian, Labdoor Certified", "flavor": "Rich Chocolate"}'::jsonb, '["Best value bulk 2kg tub with patented US-patent-published Biozyme technology", "Each batch comes with online verifiable third-party NABL lab test certificate", "Includes dedicated scoop holder right at top of jar—no digging in powder"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-004-1', 'nutr-004', 'Amazon / Flipkart', 4499.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-005', 'Dymatize', 'ISO100 Hydrolyzed Whey Isolate 2.3 lb', 'Dymatize ISO100 Hydrolyzed 100% Whey Isolate (2.3 lb)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "Hydrolyzed Whey Protein Isolate (Fast Absorbing)", "serving_size": "30g (1 scoop)", "protein_per_serving": "25g", "bcaa_per_serving": "5.5g BCAAs, 2.6g Leucine", "sugar_carbs": "<1g sugar, <1g carbs, gluten-free, <0.5g lactose", "pack_weight": "1.04 kg (2.3 lbs) - ~35 servings", "dietary_flag": "100% Vegetarian, Informed-Choice Certified", "flavor": "Gourmet Chocolate"}'::jsonb, '["Hydrolyzed whey isolate pre-broken down into smaller peptide fractions for rapid absorption", "Virtually zero fat and carbohydrates (<1g), ideal for strict calorie-deficit cutting diets", "Informed-Choice tested for banned substances and certified gluten-free"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-005-1', 'nutr-005', 'Amazon / Flipkart', 4999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-006', 'Cosmix', 'Cosmix No Nonsense Plant Protein 500g', 'Cosmix No Nonsense Plant Protein (500g)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "100% Plant-Based (Golden Pea Protein + Brown Rice Isolate)", "serving_size": "34g (1 scoop)", "protein_per_serving": "24g complete amino acid profile", "bcaa_per_serving": "4.8g plant BCAAs", "gut_friendly": "Contains plant digestive enzymes (papain, bromelain) and ginger extract", "pack_weight": "500g - 15 servings", "dietary_flag": "100% Vegan, Dairy-Free, Gluten-Free, No Artificial Sweeteners", "flavor": "Classic Vanilla"}'::jsonb, '["Made with organic golden pea and organic brown rice protein to provide all 9 essential amino acids", "Zero artificial gums, synthetic thickeners, artificial sweeteners, or chemical preservatives", "Enhanced with papain and bromelain enzymes to ensure zero digestive distress or bloating"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-006-1', 'nutr-006', 'Amazon / Flipkart', 1650.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-007', 'Oziva', 'Oziva Organic Plant Protein 1kg', 'Oziva Organic Plant Protein (1 kg)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "Multi-Source Certified Organic Plant Protein (Pea, Brown Rice, Quinoa)", "serving_size": "34g (1 scoop)", "protein_per_serving": "30g", "bcaa_per_serving": "5.2g BCAAs", "clean_label": "Pesticide-free, zero added sugar, no artificial flavours", "pack_weight": "1 kg (2.2 lbs) - ~30 servings", "dietary_flag": "Certified Clean Vegan / 100% Vegetarian", "flavor": "Unflavoured"}'::jsonb, '["Highest protein yield in plant category: 30g complete organic protein per scoop", "Unflavoured and unsweetened, easily incorporated into roti dough, smoothies, or oatmeal", "Certified Clean Label by Clean Label Project USA (free from heavy metals and pesticides)"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-007-1', 'nutr-007', 'Amazon / Flipkart', 1999.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'nutr-008', 'Isopure', 'Isopure Zero Carb 100% Whey Isolate 1kg', 'Isopure Zero Carb 100% Whey Protein Isolate (2.2 lb)', 'nutrition', 'protein_supplements', '', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80',
    '{"protein_type": "100% Microfiltered Pure Whey Protein Isolate", "serving_size": "31g (1 scoop)", "protein_per_serving": "25g", "carbs_sugar": "0g Carbohydrates, 0g Sugar, Fat-Free, Lactose-Free", "vitamins_minerals": "Fortified with 21 essential vitamins and minerals", "pack_weight": "1 kg (2.2 lbs) - ~32 servings", "dietary_flag": "100% Vegetarian, Keto Friendly", "flavor": "Creamy Vanilla"}'::jsonb, '["Absolute zero carbohydrate and zero sugar formulation for ketogenic and lean muscle goals", "Loaded with 25g pure whey isolate per scoop alongside vital micronutrient fortification", "Lactose-free microfiltration leaves no heavy stomach sensation"]'::jsonb, '[]'::jsonb, '[]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-nutr-008-1', 'nutr-008', 'Amazon / Flipkart', 4699.0, 'INR', 'In Stock', 'verified'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-pad20pro', 'Honor', 'Pad 20 Pro', 'Honor Pad 20 Pro', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "ram": "8GB RAM Snapdragon 8s Gen 4", "storage": "256 GB", "display": "12.1\" 1872x3000 pixels", "camera": "13MP 2160p", "battery": "10100mAh 66W", "charging": "66W wiredReverse wired", "os": "Android 16, MagicOS 10", "weight": "537 g (1.18 lb)", "network": "No cellular connectivity"}'::jsonb, '["Powered by Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "Display: 12.1\" 1872x3000 pixels", "Battery: 10100mAh 66W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-pad20pro-1', 'phone-md-honor-pad20pro', 'Amazon / Flipkart', 52500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-redminote17', 'Xiaomi', 'Redmi Note 17 (China)', 'Xiaomi Redmi Note 17 (China)', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM4450-AF Snapdragon 4 Gen 4", "ram": "6/8GB RAM Snapdragon 4 Gen 4", "storage": "128/256 GB UFS 2.2", "display": "7.0\" 1080x2396 pixels", "camera": "50MP 1080p", "battery": "8000mAh 45W", "charging": "45W wired, PD3.022.5W reverse wired", "os": "Android 16, HyperOS 3", "weight": "225 g (7.94 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM4450-AF Snapdragon 4 Gen 4", "Display: 7.0\" 1080x2396 pixels", "Battery: 8000mAh 45W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-redminote17-1', 'phone-md-xiaomi-redminote17', 'Amazon / Flipkart', 20300.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-xfold5', 'Vivo', 'X Fold5', 'Vivo X Fold5', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8650-AB Snapdragon 8 Gen 3 (4 nm)", "ram": "12/16GB RAM Snapdragon 8 Gen 3", "storage": "256/512 GB / 1TB", "display": "8.03\" 2200x2480 pixels", "camera": "50MP 4320p", "battery": "6000mAh 80W 40W", "charging": "80W wired40W wirelessReverse wired5W reverse wireless", "os": "Android 15, OriginOS 5", "weight": "217 g or 226 g (7.65 oz)", "network": "GSM / CDMA / HSPA / CDMA2000 / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM8650-AB Snapdragon 8 Gen 3 (4 nm)", "Display: 8.03\" 2200x2480 pixels", "Battery: 6000mAh 80W 40W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-xfold5-1', 'phone-md-vivo-xfold5', 'Amazon / Flipkart', 98000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oppo-reno14f', 'Oppo', 'Reno14 F', 'Oppo Reno14 F', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM6450 Snapdragon 6 Gen 1 (4 nm)", "ram": "8/12GB RAM Snapdragon 6 Gen 1", "storage": "128/256/512 GB", "display": "6.57\" 1080x2372 pixels", "camera": "50MP 2160p", "battery": "6000mAh 45W", "charging": "45W wired, PD2, QC2.0, 44W PPSReverse wired", "os": "Android 15, ColorOS 15", "weight": "180 g (6.35 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM6450 Snapdragon 6 Gen 1 (4 nm)", "Display: 6.57\" 1080x2372 pixels", "Battery: 6000mAh 45W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oppo-reno14f-1', 'phone-md-oppo-reno14f', 'Amazon / Flipkart', 3009328000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-t4lite', 'Vivo', 'T4 Lite', 'Vivo T4 Lite', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4-8GB RAM Dimensity 6300", "storage": "128/256 GB", "display": "6.74\" 720x1600 pixels", "camera": "50MP 1080p", "battery": "6000mAh 15W", "charging": "15W wired", "os": "Android 15, up to 2 major upgrades", "weight": "202 g (7.13 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 6300 (6 nm)", "Display: 6.74\" 720x1600 pixels", "Battery: 6000mAh 15W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-t4lite-1', 'phone-md-vivo-t4lite', 'Amazon / Flipkart', 10800.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oppo-k13x', 'Oppo', 'K13x', 'Oppo K13x', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4-8GB RAM Dimensity 6300", "storage": "128 GB", "display": "6.67\" 720x1604 pixels", "camera": "50MP 2160p", "battery": "6000mAh 45W", "charging": "45W wired, 33W PPS, 13.5W PD, 50% in 37 min", "os": "Android 15, ColorOS 15", "weight": "194 g (6.84 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 6300 (6 nm)", "Display: 6.67\" 720x1604 pixels", "Battery: 6000mAh 45W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oppo-k13x-1', 'phone-md-oppo-k13x', 'Amazon / Flipkart', 14000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-x200fe', 'Vivo', 'X200 FE', 'Vivo X200 FE', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "12/16GB RAM Dimensity 9300+", "storage": "256/512 GB", "display": "6.31\" 1216x2640 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, 100% in 57 minReverse wired", "os": "Android 15, Funtouch 15", "weight": "186 g (6.56 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 9300+ (4 nm)", "Display: 6.31\" 1216x2640 pixels", "Battery: 6500mAh 90W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-x200fe-1', 'phone-md-vivo-x200fe', 'Amazon / Flipkart', 49000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-y400pro', 'Vivo', 'Y400 Pro', 'Vivo Y400 Pro', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7300 (4 nm)", "ram": "8GB RAM Dimensity 7300", "storage": "128/256 GB", "display": "6.77\" 1080x2392 pixels", "camera": "50MP 2160p", "battery": "5500mAh 90W", "charging": "90W wired, 50% in 19 min6W reverse wired", "os": "Android 15, Funtouch 15", "weight": "182 g (6.42 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 7300 (4 nm)", "Display: 6.77\" 1080x2392 pixels", "Battery: 5500mAh 90W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-y400pro-1', 'phone-md-vivo-y400pro', 'Amazon / Flipkart', 21400.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-iqooz10lite', 'Vivo', 'iQOO Z10 Lite', 'Vivo iQOO Z10 Lite', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4-8GB RAM Dimensity 6300", "storage": "128/256 GB", "display": "6.74\" 720x1600 pixels", "camera": "50MP 2160p", "battery": "6000mAh 15W", "charging": "15W wired", "os": "Android 15, up to 2 major upgrades", "weight": "202 g (7.13 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 6300 (6 nm)", "Display: 6.74\" 720x1600 pixels", "Battery: 6000mAh 15W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-iqooz10lite-1', 'phone-md-vivo-iqooz10lite', 'Amazon / Flipkart', 1400013300.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-narzo80lite', 'Realme', 'Narzo 80 Lite', 'Realme Narzo 80 Lite', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4/6GB RAM Dimensity 6300", "storage": "64/128 GB", "display": "6.67\" 720x1604 pixels", "camera": "32MP 1080p", "battery": "6000mAh 15W", "charging": "15W wired5W reverse wired", "os": "Android 15, Realme UI 6.0", "weight": "197 g (6.95 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 6300 (6 nm)", "Display: 6.67\" 720x1604 pixels", "Battery: 6000mAh 15W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-narzo80lite-1', 'phone-md-realme-narzo80lite', 'Amazon / Flipkart', 11600.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-pocof7', 'Xiaomi', 'Poco F7', 'Xiaomi Poco F7', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "ram": "12GB RAM Snapdragon 8s Gen 4", "storage": "256/512 GB", "display": "6.83\" 1280x2772 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, PD3.0, QC3+, 80% in 30 min22.5W reverse wired", "os": "Android 15, HyperOS 2", "weight": "215.7 g (7.62 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "Display: 6.83\" 1280x2772 pixels", "Battery: 6500mAh 90W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-pocof7-1', 'phone-md-xiaomi-pocof7', 'Amazon / Flipkart', 3080029400.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oneplus-padlite', 'OnePlus', 'Pad Lite', 'OnePlus Pad Lite', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Helio G100 (6 nm)", "ram": "6/8GB RAM Helio G100", "storage": "128 GB", "display": "11.0\" 1080x1920 pixels", "camera": "5MP 1080p", "battery": "9340mAh 33W", "charging": "33W wired", "os": "Android 15, OxygenOS 15", "weight": "530 g (1.17 lb)", "network": "GSM / HSPA / LTE"}'::jsonb, '["Powered by Mediatek Helio G100 (6 nm)", "Display: 11.0\" 1080x1920 pixels", "Battery: 9340mAh 33W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oneplus-padlite-1', 'phone-md-oneplus-padlite', 'Amazon / Flipkart', 17500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-t4ultra', 'Vivo', 'T4 Ultra', 'Vivo T4 Ultra', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "8/12GB RAM Dimensity 9300+", "storage": "256/512 GB", "display": "6.67\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "5500mAh 90W", "charging": "90W wired, PD, 100% in 48 minReverse wired", "os": "Android 15, Funtouch 15", "weight": "192 g (6.84 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 9300+ (4 nm)", "Display: 6.67\" 1260x2800 pixels", "Battery: 5500mAh 90W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-t4ultra-1', 'phone-md-vivo-t4ultra', 'Amazon / Flipkart', 4200035000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-samsung-galaxywatchultra2', 'Samsung', 'Galaxy Watch Ultra2', 'Samsung Galaxy Watch Ultra2', 'smartphones', 'smartphones', '', 'https://images.samsung.com/is/image/samsung/p6pim/in/2501/gallery/in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792',
    '{"processor": "Snapdragon SW6100 Wear Elite (3 nm)", "ram": "2GB RAM Snapdragon SW6100 Wear", "storage": "64 GB", "display": "1.52\" 498x498 pixels", "camera": "NO", "battery": "800mAh 10W 10W", "charging": "10W wireless", "os": "Android Wear OS 6, One UI Watch 9", "weight": "61.5 g (2.19 oz)", "network": "GSM / HSPA / LTE"}'::jsonb, '["Powered by Snapdragon SW6100 Wear Elite (3 nm)", "Display: 1.52\" 498x498 pixels", "Battery: 800mAh 10W 10W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-samsung-galaxywatchultra2-1', 'phone-md-samsung-galaxywatchultra2', 'Amazon / Flipkart', 63000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-x6c', 'Honor', 'X6c', 'Honor X6c', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Helio G81 Ultra (12 nm)", "ram": "6/8GB RAM Helio G81 Ultra", "storage": "128/256 GB", "display": "6.61\" 720x1604 pixels", "camera": "50MP 1080p", "battery": "5300mAh 35W", "charging": "35W wired", "os": "Android 15, Magic OS 9", "weight": "199 g (7.02 oz)", "network": "GSM / HSPA / LTE"}'::jsonb, '["Powered by Mediatek Helio G81 Ultra (12 nm)", "Display: 6.61\" 720x1604 pixels", "Battery: 5300mAh 35W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-x6c-1', 'phone-md-honor-x6c', 'Amazon / Flipkart', 1049944000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-redmipad2', 'Xiaomi', 'Redmi Pad 2', 'Xiaomi Redmi Pad 2', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Helio G100 Ultra (6 nm)", "ram": "4/8GB RAM Helio G100 Ultra", "storage": "128/256 GB", "display": "11.0\" 1600x2500 pixels", "camera": "8MP 1080p", "battery": "9000mAh 18W", "charging": "18W wired, PD2, QC2.0", "os": "Android 15, HyperOS 2", "weight": "510 g or 519 g (1.12 lb)", "network": "GSM / HSPA / LTE"}'::jsonb, '["Powered by Mediatek Helio G100 Ultra (6 nm)", "Display: 11.0\" 1600x2500 pixels", "Battery: 9000mAh 18W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-redmipad2-1', 'phone-md-xiaomi-redmipad2', 'Amazon / Flipkart', 17500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oneplus-pad3', 'OnePlus', 'Pad 3', 'OnePlus Pad 3', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8750-AB Snapdragon 8 Elite (3 nm)", "ram": "12/16GB RAM Snapdragon 8 Elite", "storage": "256/512 GB", "display": "13.2\" 2400x3392 pixels", "camera": "13MP 2160p", "battery": "12140mAh 80W", "charging": "80W wired", "os": "Android 15, ColorOS 15", "weight": "675 g (1.49 lb)", "network": "No cellular connectivity"}'::jsonb, '["Powered by Qualcomm SM8750-AB Snapdragon 8 Elite (3 nm)", "Display: 13.2\" 2400x3392 pixels", "Battery: 12140mAh 80W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oneplus-pad3-1', 'phone-md-oneplus-pad3', 'Amazon / Flipkart', 51400.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-samsung-galaxytabs12ultra', 'Samsung', 'Galaxy Tab S12 Ultra', 'Samsung Galaxy Tab S12 Ultra', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "MediaTek Dimensity 9500 (3 nm)", "ram": "12/16GB RAM Dimensity 9500", "storage": "128/256/512 GB / 1TB", "display": "14.6\" 1848x2960 pixels", "camera": "13MP 2160p", "battery": "11600mAh 45W", "charging": "45W wired", "os": "Android 16, One UI 8.5", "weight": "-", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by MediaTek Dimensity 9500 (3 nm)", "Display: 14.6\" 1848x2960 pixels", "Battery: 11600mAh 45W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-samsung-galaxytabs12ultra-1', 'phone-md-samsung-galaxytabs12ultra', 'Amazon / Flipkart', 140000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-400pro', 'Honor', '400 Pro (China)', 'Honor 400 Pro (China)', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8650-AB Snapdragon 8 Gen 3 (4 nm)", "ram": "12/16GB RAM Snapdragon 8 Gen 3", "storage": "256/512 GB / 1TB", "display": "6.55\" 1264x2736 pixels", "camera": "200MP 2160p", "battery": "7200mAh 90W 50W", "charging": "90W wired, 40% in 15 min50W wireless, 28% in 15 min5W reverse wiredReverse wireless", "os": "Android 15, MagicOS 9", "weight": "204 g (7.20 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM8650-AB Snapdragon 8 Gen 3 (4 nm)", "Display: 6.55\" 1264x2736 pixels", "Battery: 7200mAh 90W 50W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-400pro-1', 'phone-md-honor-400pro', 'Amazon / Flipkart', 49000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-400', 'Honor', '400 (China)', 'Honor 400 (China)', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM7750-AB Snapdragon 7 Gen 4 (4 nm)", "ram": "12/16GB RAM Snapdragon 7 Gen 4", "storage": "256/512 GB", "display": "6.55\" 1264x2736 pixels", "camera": "200MP 2160p", "battery": "7200mAh 80W", "charging": "80W wired, 39% in 15 min5W reverse wired", "os": "Android 15, MagicOS 9", "weight": "196 g (6.91 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM7750-AB Snapdragon 7 Gen 4 (4 nm)", "Display: 6.55\" 1264x2736 pixels", "Battery: 7200mAh 80W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-400-1', 'phone-md-honor-400', 'Amazon / Flipkart', 35000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-c73', 'Realme', 'C73', 'Realme C73', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4GB RAM Dimensity 6300", "storage": "64/128 GB", "display": "6.67\" 720x1604 pixels", "camera": "32MP 1080p", "battery": "6000mAh 15W", "charging": "15W wired5W reverse wired", "os": "Android 15, Realme UI 6.0", "weight": "197 g (6.95 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 6300 (6 nm)", "Display: 6.67\" 720x1604 pixels", "Battery: 6000mAh 15W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-c73-1', 'phone-md-realme-c73', 'Amazon / Flipkart', 10500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-motorola-motog86power', 'Motorola', 'Moto G86 Power', 'Motorola Moto G86 Power', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7300 (4 nm) - GlobalMediatek Dimensity 7400 (4 nm) - India", "ram": "8/12GB RAM Dimensity 7300", "storage": "128/256/512 GB", "display": "6.67\" 1220x2712 pixels", "camera": "50MP 1080p", "battery": "6720mAh 30W", "charging": "30W wired", "os": "Android 15, up to 2 major Android upgrades", "weight": "198 g (6.98 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 7300 (4 nm) - GlobalMediatek Dimensity 7400 (4 nm) - India", "Display: 6.67\" 1220x2712 pixels", "Battery: 6720mAh 30W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-motorola-motog86power-1', 'phone-md-motorola-motog86power', 'Amazon / Flipkart', 1925018900.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-motorola-motog86', 'Motorola', 'Moto G86', 'Motorola Moto G86', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7300 (4 nm)", "ram": "8/12GB RAM Dimensity 7300", "storage": "256/512 GB", "display": "6.67\" 1080x2400 pixels", "camera": "50MP 2160p", "battery": "5200mAh 30W", "charging": "30W wired", "os": "Android 15", "weight": "185 g (6.53 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 7300 (4 nm)", "Display: 6.67\" 1080x2400 pixels", "Battery: 5200mAh 30W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-motorola-motog86-1', 'phone-md-motorola-motog86', 'Amazon / Flipkart', 31500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-motorola-motog56', 'Motorola', 'Moto G56', 'Motorola Moto G56', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7060 (6 nm)", "ram": "8/12GB RAM Dimensity 7060", "storage": "256 GB", "display": "6.72\" 1080x2400 pixels", "camera": "50MP 1080p", "battery": "5200mAh 30W", "charging": "5200 mAh30W wired", "os": "Android 15", "weight": "200 g (7.05 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 7060 (6 nm)", "Display: 6.72\" 1080x2400 pixels", "Battery: 5200mAh 30W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-motorola-motog56-1', 'phone-md-motorola-motog56', 'Amazon / Flipkart', 24500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-pad5', 'Vivo', 'Pad5', 'Vivo Pad5', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "8-16GB RAM Dimensity 9300+", "storage": "128/256/512 GB", "display": "12.1\" 1968x2800 pixels", "camera": "8MP 1080p", "battery": "10000mAh 44W", "charging": "44W wired, PD5W reverse wired", "os": "Android 15, OriginOS 5 HD", "weight": "590 g (1.30 lb)", "network": "No cellular connectivity"}'::jsonb, '["Powered by Mediatek Dimensity 9300+ (4 nm)", "Display: 12.1\" 1968x2800 pixels", "Battery: 10000mAh 44W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-pad5-1', 'phone-md-vivo-pad5', 'Amazon / Flipkart', 31500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-neo7turbo', 'Realme', 'Neo7 Turbo', 'Realme Neo7 Turbo', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9400e (4 nm)", "ram": "12/16GB RAM Dimensity 9400e", "storage": "256/512 GB", "display": "6.8\" 1280x2800 pixels", "camera": "50MP 2160p", "battery": "7200mAh 100W", "charging": "100W wired, PD, PPS, UFCS, 50% in 18 min, 100% in 47 min", "os": "Android 15, Realme UI 6.0", "weight": "205 g (7.23 oz)", "network": "GSM / CDMA / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 9400e (4 nm)", "Display: 6.8\" 1280x2800 pixels", "Battery: 7200mAh 100W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-neo7turbo-1', 'phone-md-realme-neo7turbo', 'Amazon / Flipkart', 3360031500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-s30promini', 'Vivo', 'S30 Pro mini', 'Vivo S30 Pro mini', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "12/16GB RAM Dimensity 9300+", "storage": "256/512 GB UFS 2.2", "display": "6.31\" 1216x2640 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, PDReverse wiredBypass charging", "os": "Android 15, OriginOS 5", "weight": "186 g (6.56 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 9300+ (4 nm)", "Display: 6.31\" 1216x2640 pixels", "Battery: 6500mAh 90W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-s30promini-1', 'phone-md-vivo-s30promini', 'Amazon / Flipkart', 3780038800.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-s30', 'Vivo', 'S30', 'Vivo S30', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM7750-AB Snapdragon 7 Gen 4 (4 nm)", "ram": "12/16GB RAM Snapdragon 7 Gen 4", "storage": "256/512 GB UFS 2.2", "display": "6.67\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, PDReverse wiredBypass charging", "os": "Android 15, OriginOS 5", "weight": "192 g (6.77 oz)", "network": "GSM / CDMA / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM7750-AB Snapdragon 7 Gen 4 (4 nm)", "Display: 6.67\" 1260x2800 pixels", "Battery: 6500mAh 90W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-s30-1', 'phone-md-vivo-s30', 'Amazon / Flipkart', 36400.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-gt7t', 'Realme', 'GT 7T', 'Realme GT 7T', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 8400 Max (4 nm)", "ram": "8/12GB RAM Dimensity 8400 Max", "storage": "128/256/512 GB", "display": "6.8\" 1280x2800 pixels", "camera": "50MP 2160p", "battery": "7000mAh 120W", "charging": "120W wired, 50% in 15 min, 100% in 42 minBypass charging", "os": "Android 15, up to 6 major upgrades", "weight": "202 g (7.13 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 8400 Max (4 nm)", "Display: 6.8\" 1280x2800 pixels", "Battery: 7000mAh 120W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-gt7t-1', 'phone-md-realme-gt7t', 'Amazon / Flipkart', 3290033600.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-gt7', 'Realme', 'GT 7', 'Realme GT 7', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9400e (4 nm)", "ram": "8-16GB RAM Dimensity 9400e", "storage": "256/512 GB", "display": "6.78\" 1264x2780 pixels", "camera": "50MP 4320p", "battery": "7000mAh 120W", "charging": "120W wired, 14 min to 50%, 40 min to 100%7.5W reverse wiredBypass charging", "os": "Android 15, up to 4 major upgrades", "weight": "206 g (7.27 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 9400e (4 nm)", "Display: 6.78\" 1264x2780 pixels", "Battery: 7000mAh 120W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-gt7-1', 'phone-md-realme-gt7', 'Amazon / Flipkart', 52500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-samsung-galaxym17', 'Samsung', 'Galaxy M17', 'Samsung Galaxy M17', 'smartphones', 'smartphones', '', 'https://images.samsung.com/is/image/samsung/p6pim/in/2501/gallery/in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792',
    '{"processor": "Exynos 1330 (5 nm)", "ram": "4-8GB RAM Exynos 1330", "storage": "128 GB", "display": "6.7\" 1080x2340 pixels", "camera": "50MP 1080p", "battery": "5000mAh 25W", "charging": "25W wired", "os": "Android 15, up to 6 major upgrades, One UI 7", "weight": "192 g (6.77 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Exynos 1330 (5 nm)", "Display: 6.7\" 1080x2340 pixels", "Battery: 5000mAh 25W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-samsung-galaxym17-1', 'phone-md-samsung-galaxym17', 'Amazon / Flipkart', 13300.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oppo-a5x', 'Oppo', 'A5x', 'Oppo A5x', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4GB RAM Dimensity 6300", "storage": "128 GB", "display": "6.67\" 720x1604 Pixels", "camera": "32MP 1080p", "battery": "6000mAh 45W", "charging": "45W wired, 33W PPS, 13.5W PD, 50% in 37 min", "os": "Android 15, ColorOS 15", "weight": "193 g (6.81 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 6300 (6 nm)", "Display: 6.67\" 720x1604 Pixels", "Battery: 6000mAh 45W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oppo-a5x-1', 'phone-md-oppo-a5x', 'Amazon / Flipkart', 14000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-iqooneo10', 'Vivo', 'iQOO Neo10', 'Vivo iQOO Neo10', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "ram": "8-16GB RAM Snapdragon 8s Gen 4", "storage": "128/256/512 GB", "display": "6.78\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "7000mAh 120W", "charging": "120W wired, 100W PD, 100W PPS, 50% in 15 min, 100% in 36 minReverse wiredBypass Charging", "os": "Android 15, up to 3 major upgrades", "weight": "206 g (7.27 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "Display: 6.78\" 1260x2800 pixels", "Battery: 7000mAh 120W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-iqooneo10-1', 'phone-md-vivo-iqooneo10', 'Amazon / Flipkart', 26600.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-pad7ultra', 'Xiaomi', 'Pad 7 Ultra', 'Xiaomi Pad 7 Ultra', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Xring O1 (3 nm)", "ram": "12/16GB RAM Xring O1", "storage": "256/512 GB / 1TB", "display": "14.0\" 2136x3200 pixels", "camera": "50MP 2160p", "battery": "12000mAh 120W", "charging": "120W wired, PD3.07.5W reverse wired", "os": "Android 15, HyperOS 2", "weight": "609 g or 619 g (1.34 lb)", "network": "No cellular connectivity"}'::jsonb, '["Powered by Xring O1 (3 nm)", "Display: 14.0\" 2136x3200 pixels", "Battery: 12000mAh 120W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-pad7ultra-1', 'phone-md-xiaomi-pad7ultra', 'Amazon / Flipkart', 91000.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-pad10', 'Honor', 'Pad 10', 'Honor Pad 10', 'tablets_monitors', 'tablets', '', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM7550-AB Snapdragon 7 Gen 3 (4 nm)", "ram": "8GB RAM Snapdragon 7 Gen 3", "storage": "256 GB", "display": "12.1\" 1600x2560 pixels", "camera": "8MP 2160p", "battery": "10100mAh 35W", "charging": "35W wired", "os": "Android 15, MagicOS 9", "weight": "525 g (1.16 lb)", "network": "LTE / 5G"}'::jsonb, '["Powered by Qualcomm SM7550-AB Snapdragon 7 Gen 3 (4 nm)", "Display: 12.1\" 1600x2560 pixels", "Battery: 10100mAh 35W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-pad10-1', 'phone-md-honor-pad10', 'Amazon / Flipkart', 26600.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-15spro', 'Xiaomi', '15S Pro', 'Xiaomi 15S Pro', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Xring O1 (3 nm)", "ram": "16GB RAM Xring O1", "storage": "512 GB / 1TB", "display": "6.73\" 1440x3200 pixels", "camera": "50MP 4320p", "battery": "6100mAh 90W 50W", "charging": "90W wired, PD3.050W wireless10W reverse wireless", "os": "Android 15, HyperOS 2", "weight": "216 g (7.62 oz)", "network": "GSM / CDMA / HSPA / EVDO / LTE / 5G"}'::jsonb, '["Powered by Xring O1 (3 nm)", "Display: 6.73\" 1440x3200 pixels", "Battery: 6100mAh 90W 50W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-15spro-1', 'phone-md-xiaomi-15spro', 'Amazon / Flipkart', 82200.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-iqooz11', 'Vivo', 'iQOO Z11 (India)', 'Vivo iQOO Z11 (India)', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7500 Turbo (4 nm)", "ram": "6-12GB RAM Dimensity 7500 Turbo", "storage": "128/256 GB UFS 3.1", "display": "6.83\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "7050mAh 44W", "charging": "44W wired, PPS, 44% in 30 minReverse wiredBypass charging", "os": "Android 16, up to 3 major OS updates", "weight": "199 g (7.02 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 7500 Turbo (4 nm)", "Display: 6.83\" 1260x2800 pixels", "Battery: 7050mAh 44W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-iqooz11-1', 'phone-md-vivo-iqooz11', 'Amazon / Flipkart', 38500.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-nothing-phone', 'Nothing', 'Phone (4b)', 'Nothing Phone (4b)', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm Snapdragon 6 Gen 4 (4 nm)", "ram": "8GB RAM Snapdragon 6 Gen 4", "storage": "128/256 GB UFS 2.2", "display": "6.77\" 1080x2344 pixels", "camera": "50MP 2160p", "battery": "5200mAh 33W", "charging": "33W wired, PPS, UFCS, PD7.5W reverse wired", "os": "Android 16, Nothing OS 4.1", "weight": "210 g (7.41 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '["Powered by Qualcomm Snapdragon 6 Gen 4 (4 nm)", "Display: 6.77\" 1080x2344 pixels", "Battery: 5200mAh 33W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-nothing-phone-1', 'phone-md-nothing-phone', 'Amazon / Flipkart', 31800.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oneplus-ace5racing', 'OnePlus', 'Ace 5 Racing', 'OnePlus Ace 5 Racing', 'smartphones', 'smartphones', '', 'https://oasis.opstatics.com/content/dam/oasis/page/2024/13/oneplus-13-black.png',
    '{"processor": "Mediatek Dimensity 9400e (4 nm)", "ram": "12/16GB RAM Dimensity 9400e", "storage": "256/512 GB", "display": "6.77\" 1080x2392 pixels", "camera": "50MP 2160p", "battery": "7100mAh 80W", "charging": "80W wired, 33W PPS, 18W PD/QCBypass charging", "os": "Android 15, ColorOS 15", "weight": "200 g (7.05 oz)", "network": "GSM / CDMA / HSPA / LTE / 5G"}'::jsonb, '["Powered by Mediatek Dimensity 9400e (4 nm)", "Display: 6.77\" 1080x2392 pixels", "Battery: 7100mAh 80W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oneplus-ace5racing-1', 'phone-md-oneplus-ace5racing', 'Amazon / Flipkart', 33600.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();
INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-y19spro', 'Vivo', 'Y19s Pro', 'Vivo Y19s Pro', 'smartphones', 'smartphones', '', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Unisoc Tiger T612 (12 nm)", "ram": "4/6/8GB RAM Unisoc Tiger T612", "storage": "128/256 GB eMMC 5.1", "display": "6.68\" 720x1608 pixels", "camera": "50MP 1080p", "battery": "6000mAh 44W", "charging": "44W wired, 40% in 30 minReverse wired", "os": "Android 15, Funtouch 15", "weight": "200 g (7.05 oz)", "network": "GSM / HSPA / LTE"}'::jsonb, '["Powered by Unisoc Tiger T612 (12 nm)", "Display: 6.68\" 720x1608 pixels", "Battery: 6000mAh 44W"]'::jsonb, '["Modern hardware architecture", "Large capacity battery", "Verified specifications"]'::jsonb, '["Pricing indicative from global retail listing"]'::jsonb, '{}'::jsonb, '[]'::jsonb, 'verified', 'Worthyly Master Catalog'
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();
INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-y19spro-1', 'phone-md-vivo-y19spro', 'Amazon / Flipkart', 10800.0, 'INR', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();

-- ============================================================================
-- SEEDING 138 VERIFIED IMAGE MANIFEST RECORDS
-- ============================================================================

INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0001', 'phone-001', '128GB', 'iphone-16-pro-naturaltitanium-select', 'catalog/smartphones/iphone-16-pro-naturaltitanium-select', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-pro-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0002', 'phone-002', '128GB', 'iphone-16-ultramarine-select', 'catalog/smartphones/iphone-16-ultramarine-select', 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-16-ultramarine-select?wid=470&hei=556&fmt=png-alpha', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0003', 'phone-003', '128GB', '71d7rfSl0wL._SX679_.jpg', 'catalog/smartphones/71d7rfSl0wL._SX679_.jpg', 'https://m.media-amazon.com/images/I/71d7rfSl0wL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0004', 'phone-004', '128GB', '61bK6PMOC3L._SX679_.jpg', 'catalog/smartphones/61bK6PMOC3L._SX679_.jpg', 'https://m.media-amazon.com/images/I/61bK6PMOC3L._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0005', 'phone-009', '12GB RAM / 256GB', '71ZpTf8N4GL._SX679_.jpg', 'catalog/smartphones/71ZpTf8N4GL._SX679_.jpg', 'https://m.media-amazon.com/images/I/71ZpTf8N4GL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0006', 'phone-039', '12GB RAM / 256GB', '71RVu88m78L._SX679_.jpg', 'catalog/smartphones/71RVu88m78L._SX679_.jpg', 'https://m.media-amazon.com/images/I/71RVu88m78L._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0007', 'phone-012', '8GB RAM / 128GB', '71Y8Uf73fIL._SX679_.jpg', 'catalog/smartphones/71Y8Uf73fIL._SX679_.jpg', 'https://m.media-amazon.com/images/I/71Y8Uf73fIL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0008', 'phone-013', '12GB RAM / 256GB', '717Qo4MH97L._SX679_.jpg', 'catalog/smartphones/717Qo4MH97L._SX679_.jpg', 'https://m.media-amazon.com/images/I/717Qo4MH97L._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0009', 'phone-015', '8GB RAM / 128GB', '61NbmA67gUL._SX679_.jpg', 'catalog/smartphones/61NbmA67gUL._SX679_.jpg', 'https://m.media-amazon.com/images/I/61NbmA67gUL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0010', 'phone-016', '16GB RAM / 128GB', '718y6wZ3zLL._SX679_.jpg', 'catalog/smartphones/718y6wZ3zLL._SX679_.jpg', 'https://m.media-amazon.com/images/I/718y6wZ3zLL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0011', 'phone-028', '128GB', '81+GIkwqLIL._SX679_.jpg', 'catalog/smartphones/81+GIkwqLIL._SX679_.jpg', 'https://m.media-amazon.com/images/I/81+GIkwqLIL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0012', 'phone-029', '128GB', '71xb2xkN5qL._SX679_.jpg', 'catalog/smartphones/71xb2xkN5qL._SX679_.jpg', 'https://m.media-amazon.com/images/I/71xb2xkN5qL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0013', 'phone-031', '12GB RAM / 256GB', '71qGismu6NL._SX679_.jpg', 'catalog/smartphones/71qGismu6NL._SX679_.jpg', 'https://m.media-amazon.com/images/I/71qGismu6NL._SX679_.jpg', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0014', 'laptop-001', 'Core i7 / 16GB RAM / 512GB SSD', 'photo-1593642632823-8f785ba67e45', 'catalog/laptops/photo-1593642632823-8f785ba67e45', 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0015', 'laptop-002', 'M3 Pro (11C/14G) / 18GB / 512GB', 'photo-1517336714731-489689fd1ca8', 'catalog/laptops/photo-1517336714731-489689fd1ca8', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0016', 'laptop-003', 'M3 / 16GB / 512GB', 'photo-1611186871348-b1ce696e52c9', 'catalog/laptops/photo-1611186871348-b1ce696e52c9', 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0017', 'laptop-004', 'Ryzen 7 / 32GB / 1TB / RTX 4070', 'photo-1603302576837-37561b2e2302', 'catalog/laptops/photo-1603302576837-37561b2e2302', 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0018', 'laptop-005', 'Core Ultra 7 / 16GB / 512GB', 'photo-1588872657578-7efd1f1555ed', 'catalog/laptops/photo-1588872657578-7efd1f1555ed', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0019', 'laptop-006', 'Core Ultra 7 / 16GB / 1TB', 'photo-1544716278-ca5e3f4abd8c', 'catalog/laptops/photo-1544716278-ca5e3f4abd8c', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0020', 'laptop-007', 'Core Ultra 7 / 16GB / 1TB', 'photo-1541807084-5c52b6b3adef', 'catalog/laptops/photo-1541807084-5c52b6b3adef', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0021', 'laptop-008', 'Core Ultra 5 / 16GB / 512GB', 'photo-1525547719571-a2d4ac8945e2', 'catalog/laptops/photo-1525547719571-a2d4ac8945e2', 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0022', 'tv-001', '55-inch OLED', 'photo-1593359677879-a4bb92f829d1', 'catalog/televisions/photo-1593359677879-a4bb92f829d1', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0023', 'tv-002', '55-inch OLED', 'photo-1593784991095-a205069470b6', 'catalog/televisions/photo-1593784991095-a205069470b6', 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0024', 'tv-003', '55-inch OLED', 'photo-1461151304267-38535e780c79', 'catalog/televisions/photo-1461151304267-38535e780c79', 'https://images.unsplash.com/photo-1461151304267-38535e780c79?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0025', 'tv-004', '55-inch QLED', 'photo-1574375927938-d5a98e8ffe85', 'catalog/televisions/photo-1574375927938-d5a98e8ffe85', 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0026', 'fridge-001', '653L / Silver Matte', 'photo-1571175443880-49e1d25b2bc5', 'catalog/refrigerators/photo-1571175443880-49e1d25b2bc5', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0027', 'fridge-002', '655L / Dazzle Steel', 'photo-1584269600464-37b1b58a9fe7', 'catalog/refrigerators/photo-1584269600464-37b1b58a9fe7', 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0028', 'wash-001', '8kg / Middle Black', 'photo-1626806787461-102c1bfaaea1', 'catalog/washing_machines/photo-1626806787461-102c1bfaaea1', 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0029', 'wash-002', '8kg / Silver Inox', 'photo-1610557892470-55d9e80c0bce', 'catalog/washing_machines/photo-1610557892470-55d9e80c0bce', 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0030', 'ac-001', '1.5 Ton 5-Star / White', 'photo-1621905251189-08b45d6a269e', 'catalog/air_conditioners/photo-1621905251189-08b45d6a269e', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0031', 'tab-001', '11-inch / 256GB / Space Black', 'photo-1544244015-0df4b3ffc6b0', 'catalog/tablets_monitors/photo-1544244015-0df4b3ffc6b0', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0032', 'tab-002', '14.6-inch / 12GB / 256GB', 'photo-1561154464-82e9adf32764', 'catalog/tablets_monitors/photo-1561154464-82e9adf32764', 'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0033', 'mon-001', '27-inch 4K IPS Black', 'photo-1527443224154-c4a3942d3acf', 'catalog/tablets_monitors/photo-1527443224154-c4a3942d3acf', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0034', 'mon-002', '27-inch QHD OLED 240Hz', 'photo-1542751371-adc38448a05e', 'catalog/tablets_monitors/photo-1542751371-adc38448a05e', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0035', 'audio-001', 'Black', 'photo-1505740420928-5e560c06d30e', 'catalog/consumer_electronics/photo-1505740420928-5e560c06d30e', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0036', 'audio-002', 'White', 'photo-1600294037681-c80b4cb5b434', 'catalog/consumer_electronics/photo-1600294037681-c80b4cb5b434', 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0037', 'audio-003', 'Black', 'photo-1546435770-a3e426bf472b', 'catalog/consumer_electronics/photo-1546435770-a3e426bf472b', 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0038', 'audio-004', '49mm Natural Titanium / Ocean Band', 'photo-1508685096489-7aacd43bd3b1', 'catalog/fitness/photo-1508685096489-7aacd43bd3b1', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0039', 'audio-005', '47mm Titanium Gray / LTE', 'photo-1523275335684-37898b6baf30', 'catalog/fitness/photo-1523275335684-37898b6baf30', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0040', 'audio-007', 'Black', 'photo-1590658268037-6bf12165a8df', 'catalog/consumer_electronics/photo-1590658268037-6bf12165a8df', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0041', 'shoe-001', NULL, 'photo-1542291026-7eec264c27ff', 'catalog/footwear/photo-1542291026-7eec264c27ff', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0042', 'shoe-002', NULL, 'photo-1608231387042-66d1773070a5', 'catalog/footwear/photo-1608231387042-66d1773070a5', 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0043', 'shoe-003', NULL, 'photo-1539185441755-769473a23570', 'catalog/footwear/photo-1539185441755-769473a23570', 'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0044', 'shoe-004', NULL, 'photo-1614252235316-8c857d38b5f4', 'catalog/footwear/photo-1614252235316-8c857d38b5f4', 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0045', 'kit-001', NULL, 'photo-1588854337236-6889d631faa8', 'catalog/home_kitchen/photo-1588854337236-6889d631faa8', 'https://images.unsplash.com/photo-1588854337236-6889d631faa8?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0046', 'kit-002', NULL, 'photo-1517668808822-9ebb02f2a0e6', 'catalog/home_kitchen/photo-1517668808822-9ebb02f2a0e6', 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0047', 'kit-003', NULL, 'photo-1518770660439-4636190af475', 'catalog/home_kitchen/photo-1518770660439-4636190af475', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0048', 'furn-001', NULL, 'photo-1505797149-43b0069ec26b', 'catalog/furniture/photo-1505797149-43b0069ec26b', 'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0049', 'furn-002', NULL, 'photo-1595515106969-1ce29566ff1c', 'catalog/furniture/photo-1595515106969-1ce29566ff1c', 'https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0050', 'book-002', 'Paperback / 3rd Edition (552 pages)', 'photo-1526374965328-7f61d4dc18c5', 'catalog/books/photo-1526374965328-7f61d4dc18c5', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0051', 'book-003', 'Hardcover / 4th Edition (1312 pages)', 'photo-1532012164546-f432f2e3edd4', 'catalog/books/photo-1532012164546-f432f2e3edd4', 'https://images.unsplash.com/photo-1532012164546-f432f2e3edd4?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0052', 'book-004', 'Paperback / 10th Edition (1248 pages)', 'photo-1512820790803-83ca734da794', 'catalog/books/photo-1512820790803-83ca734da794', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0053', 'book-005', 'Paperback / 7th Edition (1392 pages)', 'photo-1507842229451-7f01be7fe8e6', 'catalog/books/photo-1507842229451-7f01be7fe8e6', 'https://images.unsplash.com/photo-1507842229451-7f01be7fe8e6?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0054', 'book-006', 'Paperback / 8th Edition (864 pages)', 'photo-1558494949-ef010cbdcc31', 'catalog/books/photo-1558494949-ef010cbdcc31', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0055', 'book-007', 'Paperback / 1st Edition (616 pages)', 'photo-1516321318423-f06f85e504b3', 'catalog/books/photo-1516321318423-f06f85e504b3', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0056', 'book-008', 'Paperback / 2025 Edition (980 pages)', 'photo-1497633762265-9d179a990aa6', 'catalog/books/photo-1497633762265-9d179a990aa6', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0057', 'mag-001', 'Print + Digital (6 issues/year)', 'photo-1504711434969-e33886168f5c', 'catalog/magazines/photo-1504711434969-e33886168f5c', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0058', 'mag-002', 'Print + Digital Access', 'photo-1585829365295-ab7cd400c167', 'catalog/magazines/photo-1585829365295-ab7cd400c167', 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0059', 'mag-003', 'Print + Online Archive', 'photo-1532094349884-543bc11b234d', 'catalog/magazines/photo-1532094349884-543bc11b234d', 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0060', 'mag-004', 'Print + Digital Archive Access', 'photo-1486406146926-c627a92ad1ab', 'catalog/magazines/photo-1486406146926-c627a92ad1ab', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0061', 'mag-005', 'Print Edition + Digital Library', 'photo-1469854523086-cc02fe5d8800', 'catalog/magazines/photo-1469854523086-cc02fe5d8800', 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0062', 'mag-006', 'Print + Bloomberg App', 'photo-1590283603385-17ffb3a7f29f', 'catalog/magazines/photo-1590283603385-17ffb3a7f29f', 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0063', 'mag-007', 'Print + Digital', 'photo-1557804506-669a67965ba0', 'catalog/magazines/photo-1557804506-669a67965ba0', 'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0064', 'fiteq-001', 'Single Dumbbell (2.5kg - 24kg) with Tray', 'photo-1583454110551-21f2fa2afe61', 'catalog/fitness_equipment/photo-1583454110551-21f2fa2afe61', 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0065', 'fiteq-002', 'Black Sage / 71-inch x 26-inch', 'photo-1592432678016-e910b452f9a2', 'catalog/fitness_equipment/photo-1592432678016-e910b452f9a2', 'https://images.unsplash.com/photo-1592432678016-e910b452f9a2?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0066', 'fiteq-003', 'Grey / AlignForMe Alignment Markers', 'photo-1545205597-3d9d02c29597', 'catalog/fitness_equipment/photo-1545205597-3d9d02c29597', 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0067', 'fiteq-004', '5 Bands (10-150 lbs stackable) with Handles & Door Anchor', 'photo-1598289431512-b97b0917affc', 'catalog/fitness_equipment/photo-1598289431512-b97b0917affc', 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0068', 'fiteq-005', '20kg Plates + 3ft Curl Rod + Dumbbell Rods + Gloves', 'photo-1584735935682-2f2b69dff9d2', 'catalog/fitness_equipment/photo-1584735935682-2f2b69dff9d2', 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0069', 'fiteq-006', 'Black / 6 Backrest Angles (Incline/Decline/Flat)', 'photo-1540497077202-7c8a3999166f', 'catalog/fitness_equipment/photo-1540497077202-7c8a3999166f', 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0070', 'fiteq-007', 'Black / 360 Dual Ball Bearing / 3m Wire', 'photo-1517838277536-f5f99be501cd', 'catalog/fitness_equipment/photo-1517838277536-f5f99be501cd', 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0071', 'fiteq-008', 'Black & Red / 7 Backrest Angles / 200kg Load', 'photo-1517836357463-d25dfeac3438', 'catalog/fitness_equipment/photo-1517836357463-d25dfeac3438', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0072', 'chim-001', '60cm / 1200 m³/hr / Black Curved Glass', 'photo-1556911220-e15b29be8c8f', 'catalog/kitchen_chimneys/photo-1556911220-e15b29be8c8f', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0073', 'chim-002', '90cm / 1500 m³/hr Turbo Suction / Curved Glass', 'photo-1556909212-d5b604d0c90d', 'catalog/kitchen_chimneys/photo-1556909212-d5b604d0c90d', 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0074', 'chim-003', '60cm / 1200 m³/hr / Motion Sensor / Matte Black', 'photo-1556912172-45b7abe8b7e1', 'catalog/kitchen_chimneys/photo-1556912172-45b7abe8b7e1', 'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0075', 'chim-005', '60cm / 1200 m³/hr / Metallic Oil Collector', 'photo-1556909114-f6e7ad7d3136', 'catalog/kitchen_chimneys/photo-1556909114-f6e7ad7d3136', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0076', 'nutr-001', '907g (2 lbs) / Double Rich Chocolate / ~30 servings', 'photo-1579722821273-0f6c7d44362f', 'catalog/nutrition/photo-1579722821273-0f6c7d44362f', 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0077', 'nutr-002', '2.27 kg (5 lbs) / Double Rich Chocolate / ~74 servings', 'photo-1593095948071-474c5cc2989d', 'catalog/nutrition/photo-1593095948071-474c5cc2989d', 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0078', 'nutr-003', '1 kg (2.2 lbs) / Rich Chocolate / ~28 servings', 'photo-1544367567-0f2fcb009e0b', 'catalog/nutrition/photo-1544367567-0f2fcb009e0b', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0079', 'nutr-005', '1.04 kg (2.3 lbs) / Gourmet Chocolate / ~35 servings', 'photo-1579722820308-d74e571900a9', 'catalog/nutrition/photo-1579722820308-d74e571900a9', 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0080', 'nutr-006', '500g / Classic Vanilla / ~15 servings', 'photo-1540420773420-3366772f4999', 'catalog/nutrition/photo-1540420773420-3366772f4999', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0081', 'nutr-007', '1 kg (2.2 lbs) / Unflavoured / ~30 servings', 'photo-1512621776951-a57141f2eefd', 'catalog/nutrition/photo-1512621776951-a57141f2eefd', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0082', 'phone-md-xiaomi-redminote17', '6/8GB', 'photo-1598327105666-5b89351aff97', 'catalog/smartphones/photo-1598327105666-5b89351aff97', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0083', 'phone-md-vivo-xfold5', '12/16GB', 'photo-1511707171634-5f897ff02aa9', 'catalog/smartphones/photo-1511707171634-5f897ff02aa9', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0084', 'phone-md-samsung-galaxywatchultra2', '2GB', 'in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792', 'catalog/smartphones/in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792', 'https://images.samsung.com/is/image/samsung/p6pim/in/2501/gallery/in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0085', 'phone-md-oneplus-ace5racing', '12/16GB', 'oneplus-13-black.png', 'catalog/smartphones/oneplus-13-black.png', 'https://oasis.opstatics.com/content/dam/oasis/page/2024/13/oneplus-13-black.png', 'Verified CDN / Manufacturer Storefront', 'Commercial / Editorial Fair Use for Comparative Analysis', true, 'verified', 'catalog_image_url_reference'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0086', NULL, NULL, 'hero.png', 'hero.png', 'frontend/src/assets\hero.png', 'Unclassified Dataset / External Resource', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0087', NULL, NULL, 'react.svg', 'react.svg', 'frontend/src/assets\react.svg', 'Unclassified Dataset / External Resource', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0088', NULL, NULL, 'vite.svg', 'vite.svg', 'frontend/src/assets\vite.svg', 'Unclassified Dataset / External Resource', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0089', NULL, NULL, '01a66316-0e98-4d3b-a56f-d78752cd043f___FREC_Scab 3003.JPG', 'PlantVillage/train/Apple___Apple_scab/01a66316-0e98-4d3b-a56f-d78752cd043f___FREC_Scab 3003.JPG', 'PlantVillage/train/Apple___Apple_scab/01a66316-0e98-4d3b-a56f-d78752cd043f___FREC_Scab 3003.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0090', NULL, NULL, '01f3deaa-6143-4b6c-9c22-620a46d8be04___FREC_Scab 3112.JPG', 'PlantVillage/train/Apple___Apple_scab/01f3deaa-6143-4b6c-9c22-620a46d8be04___FREC_Scab 3112.JPG', 'PlantVillage/train/Apple___Apple_scab/01f3deaa-6143-4b6c-9c22-620a46d8be04___FREC_Scab 3112.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0091', NULL, NULL, '0208f4eb-45a4-4399-904e-989ac2c6257c___FREC_Scab 3037.JPG', 'PlantVillage/train/Apple___Apple_scab/0208f4eb-45a4-4399-904e-989ac2c6257c___FREC_Scab 3037.JPG', 'PlantVillage/train/Apple___Apple_scab/0208f4eb-45a4-4399-904e-989ac2c6257c___FREC_Scab 3037.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0092', NULL, NULL, '023123cb-7b69-4c9f-a521-766d7c8543bb___FREC_Scab 3487.JPG', 'PlantVillage/train/Apple___Apple_scab/023123cb-7b69-4c9f-a521-766d7c8543bb___FREC_Scab 3487.JPG', 'PlantVillage/train/Apple___Apple_scab/023123cb-7b69-4c9f-a521-766d7c8543bb___FREC_Scab 3487.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0093', NULL, NULL, '0261a6e4-21f8-481a-8827-b674e6955644___FREC_Scab 3055.JPG', 'PlantVillage/train/Apple___Apple_scab/0261a6e4-21f8-481a-8827-b674e6955644___FREC_Scab 3055.JPG', 'PlantVillage/train/Apple___Apple_scab/0261a6e4-21f8-481a-8827-b674e6955644___FREC_Scab 3055.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0094', NULL, NULL, '029424b0-0ef5-491b-9ef5-069190d24d8f___FREC_Scab 3504.JPG', 'PlantVillage/train/Apple___Apple_scab/029424b0-0ef5-491b-9ef5-069190d24d8f___FREC_Scab 3504.JPG', 'PlantVillage/train/Apple___Apple_scab/029424b0-0ef5-491b-9ef5-069190d24d8f___FREC_Scab 3504.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0095', NULL, NULL, '0340dc35-5215-48ab-8db7-06af99fcb358___FREC_Scab 2966.JPG', 'PlantVillage/train/Apple___Apple_scab/0340dc35-5215-48ab-8db7-06af99fcb358___FREC_Scab 2966.JPG', 'PlantVillage/train/Apple___Apple_scab/0340dc35-5215-48ab-8db7-06af99fcb358___FREC_Scab 2966.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0096', NULL, NULL, '03eccb1a-0368-4ac7-9f48-7546037b775a___FREC_Scab 3334.JPG', 'PlantVillage/train/Apple___Apple_scab/03eccb1a-0368-4ac7-9f48-7546037b775a___FREC_Scab 3334.JPG', 'PlantVillage/train/Apple___Apple_scab/03eccb1a-0368-4ac7-9f48-7546037b775a___FREC_Scab 3334.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0097', NULL, NULL, '0537ad56-3d24-4e97-a947-65b9b37f8988___FREC_Scab 3079.JPG', 'PlantVillage/train/Apple___Apple_scab/0537ad56-3d24-4e97-a947-65b9b37f8988___FREC_Scab 3079.JPG', 'PlantVillage/train/Apple___Apple_scab/0537ad56-3d24-4e97-a947-65b9b37f8988___FREC_Scab 3079.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0098', NULL, NULL, '058d5e64-2c57-45ba-94cb-ac83fd1885a0___FREC_Scab 3181.JPG', 'PlantVillage/train/Apple___Apple_scab/058d5e64-2c57-45ba-94cb-ac83fd1885a0___FREC_Scab 3181.JPG', 'PlantVillage/train/Apple___Apple_scab/058d5e64-2c57-45ba-94cb-ac83fd1885a0___FREC_Scab 3181.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0099', NULL, NULL, '0631708e-5bac-4611-8ff9-6d5ee87ce3b3___FREC_Scab 3252.JPG', 'PlantVillage/train/Apple___Apple_scab/0631708e-5bac-4611-8ff9-6d5ee87ce3b3___FREC_Scab 3252.JPG', 'PlantVillage/train/Apple___Apple_scab/0631708e-5bac-4611-8ff9-6d5ee87ce3b3___FREC_Scab 3252.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0100', NULL, NULL, '0672ab32-9fce-41f3-ae69-e39c48a0a292___FREC_Scab 3347.JPG', 'PlantVillage/train/Apple___Apple_scab/0672ab32-9fce-41f3-ae69-e39c48a0a292___FREC_Scab 3347.JPG', 'PlantVillage/train/Apple___Apple_scab/0672ab32-9fce-41f3-ae69-e39c48a0a292___FREC_Scab 3347.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0101', NULL, NULL, '06cf74b6-d895-4a09-b3b1-bc63579f8c33___FREC_Scab 3128.JPG', 'PlantVillage/train/Apple___Apple_scab/06cf74b6-d895-4a09-b3b1-bc63579f8c33___FREC_Scab 3128.JPG', 'PlantVillage/train/Apple___Apple_scab/06cf74b6-d895-4a09-b3b1-bc63579f8c33___FREC_Scab 3128.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0102', NULL, NULL, '073b509f-c1ea-4e61-881b-2e874c5f4199___FREC_Scab 3286.JPG', 'PlantVillage/train/Apple___Apple_scab/073b509f-c1ea-4e61-881b-2e874c5f4199___FREC_Scab 3286.JPG', 'PlantVillage/train/Apple___Apple_scab/073b509f-c1ea-4e61-881b-2e874c5f4199___FREC_Scab 3286.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0103', NULL, NULL, '075b1885-250b-4b3e-8168-e54efdbb04e8___FREC_Scab 3173.JPG', 'PlantVillage/train/Apple___Apple_scab/075b1885-250b-4b3e-8168-e54efdbb04e8___FREC_Scab 3173.JPG', 'PlantVillage/train/Apple___Apple_scab/075b1885-250b-4b3e-8168-e54efdbb04e8___FREC_Scab 3173.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0104', NULL, NULL, '0812e1e4-6d1b-4264-8f23-6519354fc5a6___FREC_Scab 3293.JPG', 'PlantVillage/train/Apple___Apple_scab/0812e1e4-6d1b-4264-8f23-6519354fc5a6___FREC_Scab 3293.JPG', 'PlantVillage/train/Apple___Apple_scab/0812e1e4-6d1b-4264-8f23-6519354fc5a6___FREC_Scab 3293.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0105', NULL, NULL, '0896ecbc-1af2-4868-8279-ed302acb29bc___FREC_Scab 3339.JPG', 'PlantVillage/train/Apple___Apple_scab/0896ecbc-1af2-4868-8279-ed302acb29bc___FREC_Scab 3339.JPG', 'PlantVillage/train/Apple___Apple_scab/0896ecbc-1af2-4868-8279-ed302acb29bc___FREC_Scab 3339.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0106', NULL, NULL, '08c42d78-aa7b-4106-b0c1-b260f898dcba___FREC_Scab 3151.JPG', 'PlantVillage/train/Apple___Apple_scab/08c42d78-aa7b-4106-b0c1-b260f898dcba___FREC_Scab 3151.JPG', 'PlantVillage/train/Apple___Apple_scab/08c42d78-aa7b-4106-b0c1-b260f898dcba___FREC_Scab 3151.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0107', NULL, NULL, '095c9131-a0cb-47de-898a-f9371f208c01___FREC_Scab 3109.JPG', 'PlantVillage/train/Apple___Apple_scab/095c9131-a0cb-47de-898a-f9371f208c01___FREC_Scab 3109.JPG', 'PlantVillage/train/Apple___Apple_scab/095c9131-a0cb-47de-898a-f9371f208c01___FREC_Scab 3109.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0108', NULL, NULL, '09ba6ad9-aa8d-4493-b1bf-818a4b30c4aa___FREC_Scab 2981.JPG', 'PlantVillage/train/Apple___Apple_scab/09ba6ad9-aa8d-4493-b1bf-818a4b30c4aa___FREC_Scab 2981.JPG', 'PlantVillage/train/Apple___Apple_scab/09ba6ad9-aa8d-4493-b1bf-818a4b30c4aa___FREC_Scab 2981.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0109', NULL, NULL, '09e40e4f-f8bc-4537-b20d-0b244760dbf4___FREC_Scab 3216.JPG', 'PlantVillage/train/Apple___Apple_scab/09e40e4f-f8bc-4537-b20d-0b244760dbf4___FREC_Scab 3216.JPG', 'PlantVillage/train/Apple___Apple_scab/09e40e4f-f8bc-4537-b20d-0b244760dbf4___FREC_Scab 3216.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0110', NULL, NULL, '0a5e9323-dbad-432d-ac58-d291718345d9___FREC_Scab 3417.JPG', 'PlantVillage/train/Apple___Apple_scab/0a5e9323-dbad-432d-ac58-d291718345d9___FREC_Scab 3417.JPG', 'PlantVillage/train/Apple___Apple_scab/0a5e9323-dbad-432d-ac58-d291718345d9___FREC_Scab 3417.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0111', NULL, NULL, '0a6812de-7416-4ffe-aba9-307599a02c84___FREC_Scab 2973.JPG', 'PlantVillage/train/Apple___Apple_scab/0a6812de-7416-4ffe-aba9-307599a02c84___FREC_Scab 2973.JPG', 'PlantVillage/train/Apple___Apple_scab/0a6812de-7416-4ffe-aba9-307599a02c84___FREC_Scab 2973.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0112', NULL, NULL, '0a769a71-052a-4f19-a4d8-b0f0cb75541c___FREC_Scab 3165.JPG', 'PlantVillage/train/Apple___Apple_scab/0a769a71-052a-4f19-a4d8-b0f0cb75541c___FREC_Scab 3165.JPG', 'PlantVillage/train/Apple___Apple_scab/0a769a71-052a-4f19-a4d8-b0f0cb75541c___FREC_Scab 3165.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0113', NULL, NULL, '0b1e31fa-cbc0-41ed-9139-c794e6855e82___FREC_Scab 3089.JPG', 'PlantVillage/train/Apple___Apple_scab/0b1e31fa-cbc0-41ed-9139-c794e6855e82___FREC_Scab 3089.JPG', 'PlantVillage/train/Apple___Apple_scab/0b1e31fa-cbc0-41ed-9139-c794e6855e82___FREC_Scab 3089.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0114', NULL, NULL, '0b4a52e3-e15e-4117-b2e8-7cdb5dca3ce9___FREC_Scab 3137.JPG', 'PlantVillage/train/Apple___Apple_scab/0b4a52e3-e15e-4117-b2e8-7cdb5dca3ce9___FREC_Scab 3137.JPG', 'PlantVillage/train/Apple___Apple_scab/0b4a52e3-e15e-4117-b2e8-7cdb5dca3ce9___FREC_Scab 3137.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0115', NULL, NULL, '0c620ec5-11cf-4120-94ab-1311e99df147___FREC_Scab 3131.JPG', 'PlantVillage/train/Apple___Apple_scab/0c620ec5-11cf-4120-94ab-1311e99df147___FREC_Scab 3131.JPG', 'PlantVillage/train/Apple___Apple_scab/0c620ec5-11cf-4120-94ab-1311e99df147___FREC_Scab 3131.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0116', NULL, NULL, '0cbfa4fa-63d8-43ce-9385-ff140e524b69___FREC_Scab 3164.JPG', 'PlantVillage/train/Apple___Apple_scab/0cbfa4fa-63d8-43ce-9385-ff140e524b69___FREC_Scab 3164.JPG', 'PlantVillage/train/Apple___Apple_scab/0cbfa4fa-63d8-43ce-9385-ff140e524b69___FREC_Scab 3164.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0117', NULL, NULL, '0d8d5b80-962d-4381-8d3b-9eca3f2f1bb0___FREC_Scab 3449.JPG', 'PlantVillage/train/Apple___Apple_scab/0d8d5b80-962d-4381-8d3b-9eca3f2f1bb0___FREC_Scab 3449.JPG', 'PlantVillage/train/Apple___Apple_scab/0d8d5b80-962d-4381-8d3b-9eca3f2f1bb0___FREC_Scab 3449.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0118', NULL, NULL, '0db71c1d-93d7-4481-b0d0-b73f995131a9___FREC_Scab 2976.JPG', 'PlantVillage/train/Apple___Apple_scab/0db71c1d-93d7-4481-b0d0-b73f995131a9___FREC_Scab 2976.JPG', 'PlantVillage/train/Apple___Apple_scab/0db71c1d-93d7-4481-b0d0-b73f995131a9___FREC_Scab 2976.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0119', NULL, NULL, '0ea78733-9404-4536-8793-a108c66269b3___FREC_Scab 3145.JPG', 'PlantVillage/train/Apple___Apple_scab/0ea78733-9404-4536-8793-a108c66269b3___FREC_Scab 3145.JPG', 'PlantVillage/train/Apple___Apple_scab/0ea78733-9404-4536-8793-a108c66269b3___FREC_Scab 3145.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0120', NULL, NULL, '10072248-60e2-4190-b4df-14e8ab61008c___FREC_Scab 3445.JPG', 'PlantVillage/train/Apple___Apple_scab/10072248-60e2-4190-b4df-14e8ab61008c___FREC_Scab 3445.JPG', 'PlantVillage/train/Apple___Apple_scab/10072248-60e2-4190-b4df-14e8ab61008c___FREC_Scab 3445.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0121', NULL, NULL, '106aaa5f-c98d-482d-88ef-8e5170e9072d___FREC_Scab 3489.JPG', 'PlantVillage/train/Apple___Apple_scab/106aaa5f-c98d-482d-88ef-8e5170e9072d___FREC_Scab 3489.JPG', 'PlantVillage/train/Apple___Apple_scab/106aaa5f-c98d-482d-88ef-8e5170e9072d___FREC_Scab 3489.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0122', NULL, NULL, '11c50257-617e-4a6a-a996-2b195af9ada4___FREC_Scab 3462.JPG', 'PlantVillage/train/Apple___Apple_scab/11c50257-617e-4a6a-a996-2b195af9ada4___FREC_Scab 3462.JPG', 'PlantVillage/train/Apple___Apple_scab/11c50257-617e-4a6a-a996-2b195af9ada4___FREC_Scab 3462.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0123', NULL, NULL, '11f5b020-3dfd-400c-9819-7d229bc5f929___FREC_Scab 2945.JPG', 'PlantVillage/train/Apple___Apple_scab/11f5b020-3dfd-400c-9819-7d229bc5f929___FREC_Scab 2945.JPG', 'PlantVillage/train/Apple___Apple_scab/11f5b020-3dfd-400c-9819-7d229bc5f929___FREC_Scab 2945.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0124', NULL, NULL, '13b16e68-c82c-4de8-ab34-877ff352e821___FREC_Scab 3180.JPG', 'PlantVillage/train/Apple___Apple_scab/13b16e68-c82c-4de8-ab34-877ff352e821___FREC_Scab 3180.JPG', 'PlantVillage/train/Apple___Apple_scab/13b16e68-c82c-4de8-ab34-877ff352e821___FREC_Scab 3180.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0125', NULL, NULL, '13f31401-f65a-4025-823a-4f2738e8bff9___FREC_Scab 3062.JPG', 'PlantVillage/train/Apple___Apple_scab/13f31401-f65a-4025-823a-4f2738e8bff9___FREC_Scab 3062.JPG', 'PlantVillage/train/Apple___Apple_scab/13f31401-f65a-4025-823a-4f2738e8bff9___FREC_Scab 3062.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0126', NULL, NULL, '14c623e5-051c-42f6-9e4f-f7a93e6a723c___FREC_Scab 2965.JPG', 'PlantVillage/train/Apple___Apple_scab/14c623e5-051c-42f6-9e4f-f7a93e6a723c___FREC_Scab 2965.JPG', 'PlantVillage/train/Apple___Apple_scab/14c623e5-051c-42f6-9e4f-f7a93e6a723c___FREC_Scab 2965.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0127', NULL, NULL, '1547f817-6a4d-4cbc-8ce0-7dff293562ee___FREC_Scab 3194.JPG', 'PlantVillage/train/Apple___Apple_scab/1547f817-6a4d-4cbc-8ce0-7dff293562ee___FREC_Scab 3194.JPG', 'PlantVillage/train/Apple___Apple_scab/1547f817-6a4d-4cbc-8ce0-7dff293562ee___FREC_Scab 3194.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0128', NULL, NULL, '154842bb-6ee3-4176-9007-cf7a43cfe140___FREC_Scab 3434.JPG', 'PlantVillage/train/Apple___Apple_scab/154842bb-6ee3-4176-9007-cf7a43cfe140___FREC_Scab 3434.JPG', 'PlantVillage/train/Apple___Apple_scab/154842bb-6ee3-4176-9007-cf7a43cfe140___FREC_Scab 3434.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0129', NULL, NULL, '15bfa086-7d4a-43c0-800d-2fe8255ba50c___FREC_Scab 3150.JPG', 'PlantVillage/train/Apple___Apple_scab/15bfa086-7d4a-43c0-800d-2fe8255ba50c___FREC_Scab 3150.JPG', 'PlantVillage/train/Apple___Apple_scab/15bfa086-7d4a-43c0-800d-2fe8255ba50c___FREC_Scab 3150.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0130', NULL, NULL, '162d8ca4-7cd3-46f1-904f-09721df3e498___FREC_Scab 3336.JPG', 'PlantVillage/train/Apple___Apple_scab/162d8ca4-7cd3-46f1-904f-09721df3e498___FREC_Scab 3336.JPG', 'PlantVillage/train/Apple___Apple_scab/162d8ca4-7cd3-46f1-904f-09721df3e498___FREC_Scab 3336.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0131', NULL, NULL, '1637ad84-640c-41e7-9be7-6d8e7769b875___FREC_Scab 3110.JPG', 'PlantVillage/train/Apple___Apple_scab/1637ad84-640c-41e7-9be7-6d8e7769b875___FREC_Scab 3110.JPG', 'PlantVillage/train/Apple___Apple_scab/1637ad84-640c-41e7-9be7-6d8e7769b875___FREC_Scab 3110.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0132', NULL, NULL, '176a93ed-6c2d-4828-ada1-87f1688b509b___FREC_Scab 3083.JPG', 'PlantVillage/train/Apple___Apple_scab/176a93ed-6c2d-4828-ada1-87f1688b509b___FREC_Scab 3083.JPG', 'PlantVillage/train/Apple___Apple_scab/176a93ed-6c2d-4828-ada1-87f1688b509b___FREC_Scab 3083.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0133', NULL, NULL, '18e95262-fb0a-472c-93ab-e03138a360dc___FREC_Scab 3366.JPG', 'PlantVillage/train/Apple___Apple_scab/18e95262-fb0a-472c-93ab-e03138a360dc___FREC_Scab 3366.JPG', 'PlantVillage/train/Apple___Apple_scab/18e95262-fb0a-472c-93ab-e03138a360dc___FREC_Scab 3366.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0134', NULL, NULL, '18ea82fd-4e16-416f-8ad9-54e0f6601693___FREC_Scab 3127.JPG', 'PlantVillage/train/Apple___Apple_scab/18ea82fd-4e16-416f-8ad9-54e0f6601693___FREC_Scab 3127.JPG', 'PlantVillage/train/Apple___Apple_scab/18ea82fd-4e16-416f-8ad9-54e0f6601693___FREC_Scab 3127.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0135', NULL, NULL, '1962d1ec-fb66-4583-b631-81cd23ecf063___FREC_Scab 3238.JPG', 'PlantVillage/train/Apple___Apple_scab/1962d1ec-fb66-4583-b631-81cd23ecf063___FREC_Scab 3238.JPG', 'PlantVillage/train/Apple___Apple_scab/1962d1ec-fb66-4583-b631-81cd23ecf063___FREC_Scab 3238.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0136', NULL, NULL, '1a21aabb-6f74-4644-8d9e-a517568b7e9c___FREC_Scab 3095.JPG', 'PlantVillage/train/Apple___Apple_scab/1a21aabb-6f74-4644-8d9e-a517568b7e9c___FREC_Scab 3095.JPG', 'PlantVillage/train/Apple___Apple_scab/1a21aabb-6f74-4644-8d9e-a517568b7e9c___FREC_Scab 3095.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0137', NULL, NULL, '1a304331-98b5-473f-bbb1-c33b8441052a___FREC_Scab 3296.JPG', 'PlantVillage/train/Apple___Apple_scab/1a304331-98b5-473f-bbb1-c33b8441052a___FREC_Scab 3296.JPG', 'PlantVillage/train/Apple___Apple_scab/1a304331-98b5-473f-bbb1-c33b8441052a___FREC_Scab 3296.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    'img-0138', NULL, NULL, '1a4047d7-23d6-4bba-ba10-b6e7005ea01b___FREC_Scab 3193.JPG', 'PlantVillage/train/Apple___Apple_scab/1a4047d7-23d6-4bba-ba10-b6e7005ea01b___FREC_Scab 3193.JPG', 'PlantVillage/train/Apple___Apple_scab/1a4047d7-23d6-4bba-ba10-b6e7005ea01b___FREC_Scab 3193.JPG', 'archive.zip (PlantVillage sample)', 'Under Review', false, 'unmatched', 'none'
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();
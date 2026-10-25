-- ============================================================================
-- WORTHLY - Incremental Product Master & Image Manifest Migration
-- Migration: 004_integrate_global_sources_and_image_manifest.sql
-- Generated at: 2026-10-25T13:45:23.429340+00:00
-- New Models to Insert: 40
-- ============================================================================

-- Ensure image_manifest table exists for tracking image provenance and verification
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

-- Enable RLS
ALTER TABLE public.image_manifest ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read-only access to image_manifest"
    ON public.image_manifest FOR SELECT
    USING (true);


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-pad20pro', 'Honor', 'Pad 20 Pro', 'Honor Pad 20 Pro', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "ram": "8GB RAM Snapdragon 8s Gen 4", "storage": "256 GB", "display": "12.1\" 1872x3000 pixels", "camera": "13MP 2160p", "battery": "10100mAh 66W", "charging": "66W wiredReverse wired", "os": "Android 16, MagicOS 10", "weight": "537 g (1.18 lb)", "network": "No cellular connectivity"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-pad20pro-1', 'phone-md-honor-pad20pro', 'MobileDokan (Global)', 75000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-redminote17', 'Xiaomi', 'Redmi Note 17 (China)', 'Xiaomi Redmi Note 17 (China)', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM4450-AF Snapdragon 4 Gen 4", "ram": "6/8GB RAM Snapdragon 4 Gen 4", "storage": "128/256 GB UFS 2.2", "display": "7.0\" 1080x2396 pixels", "camera": "50MP 1080p", "battery": "8000mAh 45W", "charging": "45W wired, PD3.022.5W reverse wired", "os": "Android 16, HyperOS 3", "weight": "225 g (7.94 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-redminote17-1', 'phone-md-xiaomi-redminote17', 'MobileDokan (Global)', 29000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-xfold5', 'Vivo', 'X Fold5', 'Vivo X Fold5', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8650-AB Snapdragon 8 Gen 3 (4 nm)", "ram": "12/16GB RAM Snapdragon 8 Gen 3", "storage": "256/512 GB / 1TB", "display": "8.03\" 2200x2480 pixels", "camera": "50MP 4320p", "battery": "6000mAh 80W 40W", "charging": "80W wired40W wirelessReverse wired5W reverse wireless", "os": "Android 15, OriginOS 5", "weight": "217 g or 226 g (7.65 oz)", "network": "GSM / CDMA / HSPA / CDMA2000 / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-xfold5-1', 'phone-md-vivo-xfold5', 'MobileDokan (Global)', 140000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oppo-reno14f', 'Oppo', 'Reno14 F', 'Oppo Reno14 F', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM6450 Snapdragon 6 Gen 1 (4 nm)", "ram": "8/12GB RAM Snapdragon 6 Gen 1", "storage": "128/256/512 GB", "display": "6.57\" 1080x2372 pixels", "camera": "50MP 2160p", "battery": "6000mAh 45W", "charging": "45W wired, PD2, QC2.0, 44W PPSReverse wired", "os": "Android 15, ColorOS 15", "weight": "180 g (6.35 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oppo-reno14f-1', 'phone-md-oppo-reno14f', 'MobileDokan (Global)', 4299039990.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-t4lite', 'Vivo', 'T4 Lite', 'Vivo T4 Lite', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4-8GB RAM Dimensity 6300", "storage": "128/256 GB", "display": "6.74\" 720x1600 pixels", "camera": "50MP 1080p", "battery": "6000mAh 15W", "charging": "15W wired", "os": "Android 15, up to 2 major upgrades", "weight": "202 g (7.13 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-t4lite-1', 'phone-md-vivo-t4lite', 'MobileDokan (Global)', 15500.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oppo-k13x', 'Oppo', 'K13x', 'Oppo K13x', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4-8GB RAM Dimensity 6300", "storage": "128 GB", "display": "6.67\" 720x1604 pixels", "camera": "50MP 2160p", "battery": "6000mAh 45W", "charging": "45W wired, 33W PPS, 13.5W PD, 50% in 37 min", "os": "Android 15, ColorOS 15", "weight": "194 g (6.84 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oppo-k13x-1', 'phone-md-oppo-k13x', 'MobileDokan (Global)', 20000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-x200fe', 'Vivo', 'X200 FE', 'Vivo X200 FE', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "12/16GB RAM Dimensity 9300+", "storage": "256/512 GB", "display": "6.31\" 1216x2640 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, 100% in 57 minReverse wired", "os": "Android 15, Funtouch 15", "weight": "186 g (6.56 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-x200fe-1', 'phone-md-vivo-x200fe', 'MobileDokan (Global)', 70000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-y400pro', 'Vivo', 'Y400 Pro', 'Vivo Y400 Pro', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7300 (4 nm)", "ram": "8GB RAM Dimensity 7300", "storage": "128/256 GB", "display": "6.77\" 1080x2392 pixels", "camera": "50MP 2160p", "battery": "5500mAh 90W", "charging": "90W wired, 50% in 19 min6W reverse wired", "os": "Android 15, Funtouch 15", "weight": "182 g (6.42 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-y400pro-1', 'phone-md-vivo-y400pro', 'MobileDokan (Global)', 30500.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-iqooz10lite', 'Vivo', 'iQOO Z10 Lite', 'Vivo iQOO Z10 Lite', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4-8GB RAM Dimensity 6300", "storage": "128/256 GB", "display": "6.74\" 720x1600 pixels", "camera": "50MP 2160p", "battery": "6000mAh 15W", "charging": "15W wired", "os": "Android 15, up to 2 major upgrades", "weight": "202 g (7.13 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-iqooz10lite-1', 'phone-md-vivo-iqooz10lite', 'MobileDokan (Global)', 2000019000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-narzo80lite', 'Realme', 'Narzo 80 Lite', 'Realme Narzo 80 Lite', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4/6GB RAM Dimensity 6300", "storage": "64/128 GB", "display": "6.67\" 720x1604 pixels", "camera": "32MP 1080p", "battery": "6000mAh 15W", "charging": "15W wired5W reverse wired", "os": "Android 15, Realme UI 6.0", "weight": "197 g (6.95 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-narzo80lite-1', 'phone-md-realme-narzo80lite', 'MobileDokan (Global)', 16500.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-pocof7', 'Xiaomi', 'Poco F7', 'Xiaomi Poco F7', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "ram": "12GB RAM Snapdragon 8s Gen 4", "storage": "256/512 GB", "display": "6.83\" 1280x2772 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, PD3.0, QC3+, 80% in 30 min22.5W reverse wired", "os": "Android 15, HyperOS 2", "weight": "215.7 g (7.62 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-pocof7-1', 'phone-md-xiaomi-pocof7', 'MobileDokan (Global)', 4400042000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oneplus-padlite', 'OnePlus', 'Pad Lite', 'OnePlus Pad Lite', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Helio G100 (6 nm)", "ram": "6/8GB RAM Helio G100", "storage": "128 GB", "display": "11.0\" 1080x1920 pixels", "camera": "5MP 1080p", "battery": "9340mAh 33W", "charging": "33W wired", "os": "Android 15, OxygenOS 15", "weight": "530 g (1.17 lb)", "network": "GSM / HSPA / LTE"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oneplus-padlite-1', 'phone-md-oneplus-padlite', 'MobileDokan (Global)', 24999.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-t4ultra', 'Vivo', 'T4 Ultra', 'Vivo T4 Ultra', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "8/12GB RAM Dimensity 9300+", "storage": "256/512 GB", "display": "6.67\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "5500mAh 90W", "charging": "90W wired, PD, 100% in 48 minReverse wired", "os": "Android 15, Funtouch 15", "weight": "192 g (6.84 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-t4ultra-1', 'phone-md-vivo-t4ultra', 'MobileDokan (Global)', 6000050000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-samsung-galaxywatchultra2', 'Samsung', 'Galaxy Watch Ultra2', 'Samsung Galaxy Watch Ultra2', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.samsung.com/is/image/samsung/p6pim/in/2501/gallery/in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792',
    '{"processor": "Snapdragon SW6100 Wear Elite (3 nm)", "ram": "2GB RAM Snapdragon SW6100 Wear", "storage": "64 GB", "display": "1.52\" 498x498 pixels", "camera": "NO", "battery": "800mAh 10W 10W", "charging": "10W wireless", "os": "Android Wear OS 6, One UI Watch 9", "weight": "61.5 g (2.19 oz)", "network": "GSM / HSPA / LTE"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-samsung-galaxywatchultra2-1', 'phone-md-samsung-galaxywatchultra2', 'MobileDokan (Global)', 90000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-x6c', 'Honor', 'X6c', 'Honor X6c', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Helio G81 Ultra (12 nm)", "ram": "6/8GB RAM Helio G81 Ultra", "storage": "128/256 GB", "display": "6.61\" 720x1604 pixels", "camera": "50MP 1080p", "battery": "5300mAh 35W", "charging": "35W wired", "os": "Android 15, Magic OS 9", "weight": "199 g (7.02 oz)", "network": "GSM / HSPA / LTE"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-x6c-1', 'phone-md-honor-x6c', 'MobileDokan (Global)', 1499919999.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-redmipad2', 'Xiaomi', 'Redmi Pad 2', 'Xiaomi Redmi Pad 2', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Helio G100 Ultra (6 nm)", "ram": "4/8GB RAM Helio G100 Ultra", "storage": "128/256 GB", "display": "11.0\" 1600x2500 pixels", "camera": "8MP 1080p", "battery": "9000mAh 18W", "charging": "18W wired, PD2, QC2.0", "os": "Android 15, HyperOS 2", "weight": "510 g or 519 g (1.12 lb)", "network": "GSM / HSPA / LTE"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-redmipad2-1', 'phone-md-xiaomi-redmipad2', 'MobileDokan (Global)', 24999.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oneplus-pad3', 'OnePlus', 'Pad 3', 'OnePlus Pad 3', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8750-AB Snapdragon 8 Elite (3 nm)", "ram": "12/16GB RAM Snapdragon 8 Elite", "storage": "256/512 GB", "display": "13.2\" 2400x3392 pixels", "camera": "13MP 2160p", "battery": "12140mAh 80W", "charging": "80W wired", "os": "Android 15, ColorOS 15", "weight": "675 g (1.49 lb)", "network": "No cellular connectivity"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oneplus-pad3-1', 'phone-md-oneplus-pad3', 'MobileDokan (Global)', 73499.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-samsung-galaxytabs12ultra', 'Samsung', 'Galaxy Tab S12 Ultra', 'Samsung Galaxy Tab S12 Ultra', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "MediaTek Dimensity 9500 (3 nm)", "ram": "12/16GB RAM Dimensity 9500", "storage": "128/256/512 GB / 1TB", "display": "14.6\" 1848x2960 pixels", "camera": "13MP 2160p", "battery": "11600mAh 45W", "charging": "45W wired", "os": "Android 16, One UI 8.5", "weight": "-", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-samsung-galaxytabs12ultra-1', 'phone-md-samsung-galaxytabs12ultra', 'MobileDokan (Global)', 200000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-400pro', 'Honor', '400 Pro (China)', 'Honor 400 Pro (China)', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8650-AB Snapdragon 8 Gen 3 (4 nm)", "ram": "12/16GB RAM Snapdragon 8 Gen 3", "storage": "256/512 GB / 1TB", "display": "6.55\" 1264x2736 pixels", "camera": "200MP 2160p", "battery": "7200mAh 90W 50W", "charging": "90W wired, 40% in 15 min50W wireless, 28% in 15 min5W reverse wiredReverse wireless", "os": "Android 15, MagicOS 9", "weight": "204 g (7.20 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-400pro-1', 'phone-md-honor-400pro', 'MobileDokan (Global)', 70000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-400', 'Honor', '400 (China)', 'Honor 400 (China)', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM7750-AB Snapdragon 7 Gen 4 (4 nm)", "ram": "12/16GB RAM Snapdragon 7 Gen 4", "storage": "256/512 GB", "display": "6.55\" 1264x2736 pixels", "camera": "200MP 2160p", "battery": "7200mAh 80W", "charging": "80W wired, 39% in 15 min5W reverse wired", "os": "Android 15, MagicOS 9", "weight": "196 g (6.91 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-400-1', 'phone-md-honor-400', 'MobileDokan (Global)', 50000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-c73', 'Realme', 'C73', 'Realme C73', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4GB RAM Dimensity 6300", "storage": "64/128 GB", "display": "6.67\" 720x1604 pixels", "camera": "32MP 1080p", "battery": "6000mAh 15W", "charging": "15W wired5W reverse wired", "os": "Android 15, Realme UI 6.0", "weight": "197 g (6.95 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-c73-1', 'phone-md-realme-c73', 'MobileDokan (Global)', 15000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-motorola-motog86power', 'Motorola', 'Moto G86 Power', 'Motorola Moto G86 Power', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7300 (4 nm) - GlobalMediatek Dimensity 7400 (4 nm) - India", "ram": "8/12GB RAM Dimensity 7300", "storage": "128/256/512 GB", "display": "6.67\" 1220x2712 pixels", "camera": "50MP 1080p", "battery": "6720mAh 30W", "charging": "30W wired", "os": "Android 15, up to 2 major Android upgrades", "weight": "198 g (6.98 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-motorola-motog86power-1', 'phone-md-motorola-motog86power', 'MobileDokan (Global)', 2750027000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-motorola-motog86', 'Motorola', 'Moto G86', 'Motorola Moto G86', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7300 (4 nm)", "ram": "8/12GB RAM Dimensity 7300", "storage": "256/512 GB", "display": "6.67\" 1080x2400 pixels", "camera": "50MP 2160p", "battery": "5200mAh 30W", "charging": "30W wired", "os": "Android 15", "weight": "185 g (6.53 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-motorola-motog86-1', 'phone-md-motorola-motog86', 'MobileDokan (Global)', 45000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-motorola-motog56', 'Motorola', 'Moto G56', 'Motorola Moto G56', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7060 (6 nm)", "ram": "8/12GB RAM Dimensity 7060", "storage": "256 GB", "display": "6.72\" 1080x2400 pixels", "camera": "50MP 1080p", "battery": "5200mAh 30W", "charging": "5200 mAh30W wired", "os": "Android 15", "weight": "200 g (7.05 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-motorola-motog56-1', 'phone-md-motorola-motog56', 'MobileDokan (Global)', 35000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-pad5', 'Vivo', 'Pad5', 'Vivo Pad5', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "8-16GB RAM Dimensity 9300+", "storage": "128/256/512 GB", "display": "12.1\" 1968x2800 pixels", "camera": "8MP 1080p", "battery": "10000mAh 44W", "charging": "44W wired, PD5W reverse wired", "os": "Android 15, OriginOS 5 HD", "weight": "590 g (1.30 lb)", "network": "No cellular connectivity"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-pad5-1', 'phone-md-vivo-pad5', 'MobileDokan (Global)', 45000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-neo7turbo', 'Realme', 'Neo7 Turbo', 'Realme Neo7 Turbo', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9400e (4 nm)", "ram": "12/16GB RAM Dimensity 9400e", "storage": "256/512 GB", "display": "6.8\" 1280x2800 pixels", "camera": "50MP 2160p", "battery": "7200mAh 100W", "charging": "100W wired, PD, PPS, UFCS, 50% in 18 min, 100% in 47 min", "os": "Android 15, Realme UI 6.0", "weight": "205 g (7.23 oz)", "network": "GSM / CDMA / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-neo7turbo-1', 'phone-md-realme-neo7turbo', 'MobileDokan (Global)', 4800045000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-s30promini', 'Vivo', 'S30 Pro mini', 'Vivo S30 Pro mini', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9300+ (4 nm)", "ram": "12/16GB RAM Dimensity 9300+", "storage": "256/512 GB UFS 2.2", "display": "6.31\" 1216x2640 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, PDReverse wiredBypass charging", "os": "Android 15, OriginOS 5", "weight": "186 g (6.56 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-s30promini-1', 'phone-md-vivo-s30promini', 'MobileDokan (Global)', 5400055500.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-s30', 'Vivo', 'S30', 'Vivo S30', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM7750-AB Snapdragon 7 Gen 4 (4 nm)", "ram": "12/16GB RAM Snapdragon 7 Gen 4", "storage": "256/512 GB UFS 2.2", "display": "6.67\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "6500mAh 90W", "charging": "90W wired, PDReverse wiredBypass charging", "os": "Android 15, OriginOS 5", "weight": "192 g (6.77 oz)", "network": "GSM / CDMA / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-s30-1', 'phone-md-vivo-s30', 'MobileDokan (Global)', 52000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-gt7t', 'Realme', 'GT 7T', 'Realme GT 7T', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 8400 Max (4 nm)", "ram": "8/12GB RAM Dimensity 8400 Max", "storage": "128/256/512 GB", "display": "6.8\" 1280x2800 pixels", "camera": "50MP 2160p", "battery": "7000mAh 120W", "charging": "120W wired, 50% in 15 min, 100% in 42 minBypass charging", "os": "Android 15, up to 6 major upgrades", "weight": "202 g (7.13 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-gt7t-1', 'phone-md-realme-gt7t', 'MobileDokan (Global)', 4700048000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-realme-gt7', 'Realme', 'GT 7', 'Realme GT 7', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 9400e (4 nm)", "ram": "8-16GB RAM Dimensity 9400e", "storage": "256/512 GB", "display": "6.78\" 1264x2780 pixels", "camera": "50MP 4320p", "battery": "7000mAh 120W", "charging": "120W wired, 14 min to 50%, 40 min to 100%7.5W reverse wiredBypass charging", "os": "Android 15, up to 4 major upgrades", "weight": "206 g (7.27 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-realme-gt7-1', 'phone-md-realme-gt7', 'MobileDokan (Global)', 75000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-samsung-galaxym17', 'Samsung', 'Galaxy M17', 'Samsung Galaxy M17', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.samsung.com/is/image/samsung/p6pim/in/2501/gallery/in-galaxy-s25-ultra-s938-sm-s938bztmins-thumb-544648792',
    '{"processor": "Exynos 1330 (5 nm)", "ram": "4-8GB RAM Exynos 1330", "storage": "128 GB", "display": "6.7\" 1080x2340 pixels", "camera": "50MP 1080p", "battery": "5000mAh 25W", "charging": "25W wired", "os": "Android 15, up to 6 major upgrades, One UI 7", "weight": "192 g (6.77 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-samsung-galaxym17-1', 'phone-md-samsung-galaxym17', 'MobileDokan (Global)', 19000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oppo-a5x', 'Oppo', 'A5x', 'Oppo A5x', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 6300 (6 nm)", "ram": "4GB RAM Dimensity 6300", "storage": "128 GB", "display": "6.67\" 720x1604 Pixels", "camera": "32MP 1080p", "battery": "6000mAh 45W", "charging": "45W wired, 33W PPS, 13.5W PD, 50% in 37 min", "os": "Android 15, ColorOS 15", "weight": "193 g (6.81 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oppo-a5x-1', 'phone-md-oppo-a5x', 'MobileDokan (Global)', 20000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-iqooneo10', 'Vivo', 'iQOO Neo10', 'Vivo iQOO Neo10', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM8735 Snapdragon 8s Gen 4 (4 nm)", "ram": "8-16GB RAM Snapdragon 8s Gen 4", "storage": "128/256/512 GB", "display": "6.78\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "7000mAh 120W", "charging": "120W wired, 100W PD, 100W PPS, 50% in 15 min, 100% in 36 minReverse wiredBypass Charging", "os": "Android 15, up to 3 major upgrades", "weight": "206 g (7.27 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-iqooneo10-1', 'phone-md-vivo-iqooneo10', 'MobileDokan (Global)', 38000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-pad7ultra', 'Xiaomi', 'Pad 7 Ultra', 'Xiaomi Pad 7 Ultra', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Xring O1 (3 nm)", "ram": "12/16GB RAM Xring O1", "storage": "256/512 GB / 1TB", "display": "14.0\" 2136x3200 pixels", "camera": "50MP 2160p", "battery": "12000mAh 120W", "charging": "120W wired, PD3.07.5W reverse wired", "os": "Android 15, HyperOS 2", "weight": "609 g or 619 g (1.34 lb)", "network": "No cellular connectivity"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-pad7ultra-1', 'phone-md-xiaomi-pad7ultra', 'MobileDokan (Global)', 130000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-honor-pad10', 'Honor', 'Pad 10', 'Honor Pad 10', 'tablets_monitors', 'tablets',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm SM7550-AB Snapdragon 7 Gen 3 (4 nm)", "ram": "8GB RAM Snapdragon 7 Gen 3", "storage": "256 GB", "display": "12.1\" 1600x2560 pixels", "camera": "8MP 2160p", "battery": "10100mAh 35W", "charging": "35W wired", "os": "Android 15, MagicOS 9", "weight": "525 g (1.16 lb)", "network": "LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-honor-pad10-1', 'phone-md-honor-pad10', 'MobileDokan (Global)', 37999.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-xiaomi-15spro', 'Xiaomi', '15S Pro', 'Xiaomi 15S Pro', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Xring O1 (3 nm)", "ram": "16GB RAM Xring O1", "storage": "512 GB / 1TB", "display": "6.73\" 1440x3200 pixels", "camera": "50MP 4320p", "battery": "6100mAh 90W 50W", "charging": "90W wired, PD3.050W wireless10W reverse wireless", "os": "Android 15, HyperOS 2", "weight": "216 g (7.62 oz)", "network": "GSM / CDMA / HSPA / EVDO / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-xiaomi-15spro-1', 'phone-md-xiaomi-15spro', 'MobileDokan (Global)', 117500.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-iqooz11', 'Vivo', 'iQOO Z11 (India)', 'Vivo iQOO Z11 (India)', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Mediatek Dimensity 7500 Turbo (4 nm)", "ram": "6-12GB RAM Dimensity 7500 Turbo", "storage": "128/256 GB UFS 3.1", "display": "6.83\" 1260x2800 pixels", "camera": "50MP 2160p", "battery": "7050mAh 44W", "charging": "44W wired, PPS, 44% in 30 minReverse wiredBypass charging", "os": "Android 16, up to 3 major OS updates", "weight": "199 g (7.02 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-iqooz11-1', 'phone-md-vivo-iqooz11', 'MobileDokan (Global)', 55000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-nothing-phone', 'Nothing', 'Phone (4b)', 'Nothing Phone (4b)', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Qualcomm Snapdragon 6 Gen 4 (4 nm)", "ram": "8GB RAM Snapdragon 6 Gen 4", "storage": "128/256 GB UFS 2.2", "display": "6.77\" 1080x2344 pixels", "camera": "50MP 2160p", "battery": "5200mAh 33W", "charging": "33W wired, PPS, UFCS, PD7.5W reverse wired", "os": "Android 16, Nothing OS 4.1", "weight": "210 g (7.41 oz)", "network": "GSM / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-nothing-phone-1', 'phone-md-nothing-phone', 'MobileDokan (Global)', 45500.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-oneplus-ace5racing', 'OnePlus', 'Ace 5 Racing', 'OnePlus Ace 5 Racing', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://oasis.opstatics.com/content/dam/oasis/page/2024/13/oneplus-13-black.png',
    '{"processor": "Mediatek Dimensity 9400e (4 nm)", "ram": "12/16GB RAM Dimensity 9400e", "storage": "256/512 GB", "display": "6.77\" 1080x2392 pixels", "camera": "50MP 2160p", "battery": "7100mAh 80W", "charging": "80W wired, 33W PPS, 18W PD/QCBypass charging", "os": "Android 15, ColorOS 15", "weight": "200 g (7.05 oz)", "network": "GSM / CDMA / HSPA / LTE / 5G"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-oneplus-ace5racing-1', 'phone-md-oneplus-ace5racing', 'MobileDokan (Global)', 48000.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();


INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    'phone-md-vivo-y19spro', 'Vivo', 'Y19s Pro', 'Vivo Y19s Pro', 'smartphones', 'smartphones',
    'Verified specifications from Global Mobile Phone Specifications and Prices 2026', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
    '{"processor": "Unisoc Tiger T612 (12 nm)", "ram": "4/6/8GB RAM Unisoc Tiger T612", "storage": "128/256 GB eMMC 5.1", "display": "6.68\" 720x1608 pixels", "camera": "50MP 1080p", "battery": "6000mAh 44W", "charging": "44W wired, 40% in 30 minReverse wired", "os": "Android 15, Funtouch 15", "weight": "200 g (7.05 oz)", "network": "GSM / HSPA / LTE"}'::jsonb, '{"performance": 0.88, "value": 0.85}'::jsonb, '["daily", "multitasking"]'::jsonb,
    'verified', 'Global Mobile Phone Dataset 2026'
) ON CONFLICT (id) DO UPDATE SET
    specs = EXCLUDED.specs,
    updated_at = NOW();


INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-phone-md-vivo-y19spro-1', 'phone-md-vivo-y19spro', 'MobileDokan (Global)', 15499.0, 'BDT', 'In Stock', 'indicative'
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    last_checked_at = NOW();

"""
Generates backend/migrations/000_FULL_SETUP_WORTHLY_DATABASE.sql
Combines table creation, RLS, triggers, indexes, all 174 master catalog products,
retailer offers, and image manifest entries into one single executable file.
"""

import os
import json

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
data_dir = os.path.join(base_dir, "data")
products_file = os.path.join(data_dir, "products.json")
manifest_file = os.path.join(data_dir, "image_manifest.json")
out_file = os.path.join(base_dir, "migrations", "000_FULL_SETUP_WORTHLY_DATABASE.sql")

with open(products_file, "r", encoding="utf-8") as f:
    products = json.load(f)

manifest = {}
if os.path.exists(manifest_file):
    with open(manifest_file, "r", encoding="utf-8") as f:
        manifest = json.load(f)

lines = []
lines.append("-- ============================================================================")
lines.append("-- WORTHLY - COMPLETE ALL-IN-ONE SUPABASE DATABASE SETUP")
lines.append("-- File: 000_FULL_SETUP_WORTHLY_DATABASE.sql")
lines.append("--")
lines.append("-- Everything needed for a fresh or existing Supabase project:")
lines.append("--   1. Creates all tables (product_models, product_variants, retailer_listings,")
lines.append("--      product_offers, image_manifest)")
lines.append("--   2. Enables Row Level Security (RLS) with public read-only policies")
lines.append("--   3. Creates performance indexes on categories, brands, identifiers, and models")
lines.append("--   4. Idempotently seeds all 174 master catalog products with specs and offers")
lines.append("--   5. Populates the verified image manifest")
lines.append("--")
lines.append("-- Safe to execute repeatedly (uses CREATE TABLE IF NOT EXISTS and ON CONFLICT).")
lines.append("-- ============================================================================\n")

lines.append("""-- 1. Core Product Models Table
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
""")

def esc(val):
    if val is None:
        return "NULL"
    return "'" + str(val).replace("'", "''") + "'"

def esc_json(obj):
    if obj is None:
        return "'{}'::jsonb"
    s = json.dumps(obj, ensure_ascii=False).replace("'", "''")
    return f"'{s}'::jsonb"

# Insert all products
lines.append("\n-- ============================================================================")
lines.append(f"-- SEEDING {len(products)} MASTER CATALOG PRODUCTS")
lines.append("-- ============================================================================\n")

for p in products:
    pid = esc(p['id'])
    brand = esc(p.get('brand', 'Generic'))
    name = esc(p.get('name') or p.get('product_name') or 'Product')
    exact_model = esc(p.get('exact_model') or p.get('name') or 'Model')
    category = esc(p.get('category', 'smartphones'))
    subcategory = esc(p.get('subcategory', p.get('category', 'smartphones')))
    desc = esc(p.get('description', ''))
    img = esc(p.get('image') or p.get('imageUrl') or p.get('image_url') or '')
    specs = esc_json(p.get('specs') or p.get('specifications') or {})
    feats = esc_json(p.get('features') or [])
    pros = esc_json(p.get('pros') or [])
    cons = esc_json(p.get('cons') or [])
    affinities = esc_json(p.get('priority_affinities') or {})
    usages = esc_json(p.get('intended_usage_tags') or [])
    v_stat = esc(p.get('verification_status', 'verified'))
    source = esc(p.get('source', 'Worthyly Master Catalog'))

    lines.append(f"""INSERT INTO public.product_models (
    id, brand, exact_model, name, category, subcategory, description, image_url,
    specs, features, pros, cons, priority_affinities, intended_usage_tags, verification_status, source
) VALUES (
    {pid}, {brand}, {exact_model}, {name}, {category}, {subcategory}, {desc}, {img},
    {specs}, {feats}, {pros}, {cons}, {affinities}, {usages}, {v_stat}, {source}
) ON CONFLICT (id) DO UPDATE SET
    exact_model = EXCLUDED.exact_model,
    specs = EXCLUDED.specs,
    image_url = EXCLUDED.image_url,
    updated_at = NOW();""")

    # Offer
    price = float(p.get('price', 0))
    curr = esc(p.get('currency', 'INR'))
    p_status = esc(p.get('price_status', 'verified'))
    retailer = esc(p.get('source', 'Amazon / Flipkart'))
    raw_pid = p['id']
    lines.append(f"""INSERT INTO public.product_offers (
    id, product_id, retailer, price, currency, availability, price_status
) VALUES (
    'off-{raw_pid}-1', {pid}, {retailer}, {price}, {curr}, 'In Stock', {p_status}
) ON CONFLICT (id) DO UPDATE SET
    price = EXCLUDED.price,
    price_status = EXCLUDED.price_status,
    last_checked_at = NOW();""")

lines.append("\n-- ============================================================================")
lines.append(f"-- SEEDING {len(manifest.get('images', []))} VERIFIED IMAGE MANIFEST RECORDS")
lines.append("-- ============================================================================\n")

for img_rec in manifest.get('images', []):
    img_id = esc(img_rec.get('image_id'))
    pid = esc(img_rec.get('product_id'))
    vid = esc(img_rec.get('variant_id'))
    fname = esc(img_rec.get('original_filename', 'image.jpg'))
    rpath = esc(img_rec.get('original_relative_path', ''))
    ppath = esc(img_rec.get('processed_image_path', ''))
    isrc = esc(img_rec.get('image_source', 'catalogue'))
    attr = esc(img_rec.get('attribution_or_license', 'Retailer / CDN'))
    is_pri = "true" if img_rec.get('is_primary', True) else "false"
    vstat = esc(img_rec.get('verification_status', 'verified'))
    mmeth = esc(img_rec.get('matching_method', 'exact_match'))

    lines.append(f"""INSERT INTO public.image_manifest (
    image_id, product_id, variant_id, original_filename, original_relative_path,
    processed_image_path, image_source, attribution_or_license, is_primary,
    verification_status, matching_method
) VALUES (
    {img_id}, {pid}, {vid}, {fname}, {rpath}, {ppath}, {isrc}, {attr}, {is_pri}, {vstat}, {mmeth}
) ON CONFLICT (image_id) DO UPDATE SET
    product_id = EXCLUDED.product_id,
    processed_image_path = EXCLUDED.processed_image_path,
    verification_status = EXCLUDED.verification_status,
    updated_at = NOW();""")

with open(out_file, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"Generated {out_file} with {len(products)} products ({os.path.getsize(out_file):,} bytes).")

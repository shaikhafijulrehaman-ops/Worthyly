-- ============================================================================
-- WORTHLY - Product Master Database Schema Migration
-- Migration: 001_create_product_master_tables.sql
-- Description: Creates relational product master tables for models, variants,
--              retailer listings, and time-sensitive price offers with RLS.
-- ============================================================================

-- 1. Table: product_models (Core stable product specifications)
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

-- Index for category, brand, and exact model searches
CREATE INDEX IF NOT EXISTS idx_product_models_category ON public.product_models(category);
CREATE INDEX IF NOT EXISTS idx_product_models_brand ON public.product_models(brand);
CREATE INDEX IF NOT EXISTS idx_product_models_exact_model ON public.product_models(exact_model);

-- 2. Table: product_variants (Specific RAM / storage / color configurations)
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
CREATE INDEX IF NOT EXISTS idx_product_variants_ram_storage ON public.product_variants(ram, storage);

-- 3. Table: retailer_listings (Mappings between URLs/retailer IDs and products)
CREATE TABLE IF NOT EXISTS public.retailer_listings (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) NOT NULL REFERENCES public.product_models(id) ON DELETE CASCADE,
    variant_id VARCHAR(64) REFERENCES public.product_variants(id) ON DELETE SET NULL,
    retailer VARCHAR(64) NOT NULL,
    identifier_type VARCHAR(32) NOT NULL, -- 'asin', 'pid', 'fsn', 'sku'
    identifier_value VARCHAR(128) NOT NULL,
    canonical_url TEXT NOT NULL,
    original_url TEXT,
    verified_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_retailer_listings_identifier ON public.retailer_listings(identifier_type, identifier_value);
CREATE INDEX IF NOT EXISTS idx_retailer_listings_canonical_url ON public.retailer_listings(canonical_url);
CREATE INDEX IF NOT EXISTS idx_retailer_listings_product_id ON public.retailer_listings(product_id);

-- 4. Table: product_offers (Time-sensitive retailer price & availability)
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
CREATE INDEX IF NOT EXISTS idx_product_offers_variant_id ON public.product_offers(variant_id);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Strict read-only public access. Writes restricted to service_role key only.
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE public.product_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.retailer_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_offers ENABLE ROW LEVEL SECURITY;

-- 1. product_models: Public read-only; writes only by service_role
DROP POLICY IF EXISTS "Public can view product models" ON public.product_models;
CREATE POLICY "Public can view product models"
    ON public.product_models
    FOR SELECT
    TO anon, authenticated
    USING (true);

DROP POLICY IF EXISTS "Service role can modify product models" ON public.product_models;
CREATE POLICY "Service role can modify product models"
    ON public.product_models
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- 2. product_variants: Public read-only; writes only by service_role
DROP POLICY IF EXISTS "Public can view product variants" ON public.product_variants;
CREATE POLICY "Public can view product variants"
    ON public.product_variants
    FOR SELECT
    TO anon, authenticated
    USING (true);

DROP POLICY IF EXISTS "Service role can modify product variants" ON public.product_variants;
CREATE POLICY "Service role can modify product variants"
    ON public.product_variants
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- 3. retailer_listings: Public read-only; writes only by service_role
DROP POLICY IF EXISTS "Public can view retailer listings" ON public.retailer_listings;
CREATE POLICY "Public can view retailer listings"
    ON public.retailer_listings
    FOR SELECT
    TO anon, authenticated
    USING (true);

DROP POLICY IF EXISTS "Service role can modify retailer listings" ON public.retailer_listings;
CREATE POLICY "Service role can modify retailer listings"
    ON public.retailer_listings
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- 4. product_offers: Public read-only; writes only by service_role
DROP POLICY IF EXISTS "Public can view product offers" ON public.product_offers;
CREATE POLICY "Public can view product offers"
    ON public.product_offers
    FOR SELECT
    TO anon, authenticated
    USING (true);

DROP POLICY IF EXISTS "Service role can modify product offers" ON public.product_offers;
CREATE POLICY "Service role can modify product offers"
    ON public.product_offers
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

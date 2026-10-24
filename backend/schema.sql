-- ==============================================================================
-- SmartBuy AI - PostgreSQL / Supabase Production Schema & Security Policies
-- ==============================================================================

-- 1. Products Table
CREATE TABLE IF NOT EXISTS public.products (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(64) NOT NULL,
    brand VARCHAR(128) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    currency VARCHAR(8) DEFAULT 'USD',
    last_verified TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    source VARCHAR(255) NOT NULL,
    product_url TEXT,
    image_url TEXT,
    rating NUMERIC(3, 2) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    review_count INTEGER DEFAULT 0,
    verified_purchase_review_count INTEGER DEFAULT 0,
    specs JSONB DEFAULT '{}'::jsonb,
    intended_usage_tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    priority_affinities JSONB DEFAULT '{}'::jsonb,
    features TEXT[] DEFAULT ARRAY[]::TEXT[],
    pros TEXT[] DEFAULT ARRAY[]::TEXT[],
    cons TEXT[] DEFAULT ARRAY[]::TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for fast category and budget queries
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);
CREATE INDEX IF NOT EXISTS idx_products_price ON public.products(price);
CREATE INDEX IF NOT EXISTS idx_products_brand ON public.products(brand);

-- 2. Community Reviews Table
CREATE TABLE IF NOT EXISTS public.reviews (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) REFERENCES public.products(id) ON DELETE CASCADE,
    product_name VARCHAR(255) NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    author VARCHAR(128) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255) NOT NULL,
    review_text TEXT NOT NULL,
    intended_usage VARCHAR(255) NOT NULL,
    pros TEXT NOT NULL,
    cons TEXT NOT NULL,
    purchase_price NUMERIC(10, 2),
    purchase_date DATE,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_count INTEGER DEFAULT 0,
    is_reported BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON public.reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON public.reviews(user_id);

-- 3. Saved Products Table
CREATE TABLE IF NOT EXISTS public.saved_products (
    id VARCHAR(64) PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    product_id VARCHAR(64) REFERENCES public.products(id) ON DELETE CASCADE,
    saved_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

-- 4. Saved Comparisons Table
CREATE TABLE IF NOT EXISTS public.saved_comparisons (
    id VARCHAR(64) PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    product_ids TEXT[] NOT NULL,
    notes TEXT DEFAULT '',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================================================
-- Row Level Security (RLS) Policies
-- ==============================================================================

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_comparisons ENABLE ROW LEVEL SECURITY;

-- Products: Everyone can read
CREATE POLICY "Allow public read access to products"
    ON public.products FOR SELECT
    TO public
    USING (true);

-- Reviews: Everyone can read; Authenticated users can insert; Authors can update/delete their own
CREATE POLICY "Allow public read access to reviews"
    ON public.reviews FOR SELECT
    TO public
    USING (true);

CREATE POLICY "Allow authenticated users to insert reviews"
    ON public.reviews FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow authors to update their reviews"
    ON public.reviews FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Allow authors to delete their reviews"
    ON public.reviews FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);

-- Saved Products: Only owners can manage their shortlist
CREATE POLICY "Allow users to manage own saved products"
    ON public.saved_products FOR ALL
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Saved Comparisons: Only owners can manage their shootouts
CREATE POLICY "Allow users to manage own saved comparisons"
    ON public.saved_comparisons FOR ALL
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

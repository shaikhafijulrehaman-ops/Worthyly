-- ==============================================================================
-- WORTHLY - Database Migration 002: Recommendation Feedback & Aspect Sentiment
-- ==============================================================================
-- Purpose:
--   1. Stores cached aspect-level sentiment summaries per product from ABSA.
--   2. Records recommendation sessions (criteria, budget, algorithm used).
--   3. Ingests post-use user satisfaction outcomes to train future ML models.
--
-- Safety:
--   - Additive only: does not drop or modify existing tables.
--   - Strictly non-destructive.
--   - Row Level Security (RLS) enabled on all new tables.
--
-- How to Apply:
--   Execute this script in your Supabase SQL Editor or via psql:
--     psql -h <host> -U <user> -d <database> -f 002_recommendation_feedback.sql
-- ==============================================================================

-- 1. Product Aspect Sentiments Table
CREATE TABLE IF NOT EXISTS public.product_aspect_sentiments (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    aspect VARCHAR(64) NOT NULL, -- e.g. 'battery', 'performance', 'display', 'build_quality'
    positive_mentions INTEGER DEFAULT 0 CHECK (positive_mentions >= 0),
    negative_mentions INTEGER DEFAULT 0 CHECK (negative_mentions >= 0),
    neutral_mentions INTEGER DEFAULT 0 CHECK (neutral_mentions >= 0),
    polarity_score NUMERIC(4, 3) DEFAULT 0.0 CHECK (polarity_score >= -1.0 AND polarity_score <= 1.0),
    confidence_score NUMERIC(4, 3) DEFAULT 0.0 CHECK (confidence_score >= 0.0 AND confidence_score <= 1.0),
    sample_excerpts JSONB DEFAULT '[]'::jsonb,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(product_id, aspect)
);

CREATE INDEX IF NOT EXISTS idx_aspect_product_id ON public.product_aspect_sentiments(product_id);

-- 2. Recommendation Sessions Table
CREATE TABLE IF NOT EXISTS public.recommendation_sessions (
    id VARCHAR(64) PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    session_type VARCHAR(32) NOT NULL DEFAULT 'url_shootout', -- 'url_shootout' | 'requirement_builder'
    category VARCHAR(64) NOT NULL,
    submitted_urls TEXT[] DEFAULT ARRAY[]::TEXT[],
    input_budget_min NUMERIC(10, 2),
    input_budget_max NUMERIC(10, 2),
    input_usages TEXT[] DEFAULT ARRAY[]::TEXT[],
    input_priorities TEXT[] DEFAULT ARRAY[]::TEXT[],
    input_optional_specs JSONB DEFAULT '{}'::jsonb,
    ranked_product_ids TEXT[] NOT NULL,
    ranking_algorithm VARCHAR(64) NOT NULL DEFAULT 'topsis_v1',
    algorithm_scores JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_rec_sessions_category ON public.recommendation_sessions(category);
CREATE INDEX IF NOT EXISTS idx_rec_sessions_user ON public.recommendation_sessions(user_id);

-- 3. Recommendation Post-Purchase Feedback Table
CREATE TABLE IF NOT EXISTS public.recommendation_feedback (
    id VARCHAR(64) PRIMARY KEY,
    session_id VARCHAR(64) REFERENCES public.recommendation_sessions(id) ON DELETE CASCADE,
    product_id VARCHAR(64) NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    product_name VARCHAR(255),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    met_requirements BOOLEAN NOT NULL,
    satisfaction_score INTEGER NOT NULL CHECK (satisfaction_score >= 1 AND satisfaction_score <= 5),
    would_recommend BOOLEAN NOT NULL,
    aspects_better TEXT[] DEFAULT ARRAY[]::TEXT[],
    aspects_worse TEXT[] DEFAULT ARRAY[]::TEXT[],
    feedback_notes TEXT DEFAULT '',
    is_verified_buyer BOOLEAN DEFAULT FALSE,
    algorithm_version VARCHAR(64) DEFAULT 'topsis_v1',
    is_spam_flagged BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_rec_feedback_product ON public.recommendation_feedback(product_id);
CREATE INDEX IF NOT EXISTS idx_rec_feedback_session ON public.recommendation_feedback(session_id);

-- ==============================================================================
-- Row Level Security (RLS) Policies
-- ==============================================================================

ALTER TABLE public.product_aspect_sentiments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendation_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendation_feedback ENABLE ROW LEVEL SECURITY;

-- Product Aspect Sentiments: Public Read-Only
CREATE POLICY "Allow public read access to product aspect sentiments"
    ON public.product_aspect_sentiments FOR SELECT
    TO public
    USING (true);

-- Recommendation Sessions: Insertable by anyone; readable by creator
CREATE POLICY "Allow public insert of recommendation sessions"
    ON public.recommendation_sessions FOR INSERT
    TO public
    WITH CHECK (true);

CREATE POLICY "Allow users to view own recommendation sessions"
    ON public.recommendation_sessions FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id OR user_id IS NULL);

-- Recommendation Feedback: Insertable by anyone; readable by creator
CREATE POLICY "Allow public insert of recommendation feedback"
    ON public.recommendation_feedback FOR INSERT
    TO public
    WITH CHECK (true);

CREATE POLICY "Allow users to view own feedback submissions"
    ON public.recommendation_feedback FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id OR user_id IS NULL);

-- ==============================================================================
-- Rollback Instructions (if needed):
--   DROP TABLE IF EXISTS public.recommendation_feedback CASCADE;
--   DROP TABLE IF EXISTS public.recommendation_sessions CASCADE;
--   DROP TABLE IF EXISTS public.product_aspect_sentiments CASCADE;
-- ==============================================================================

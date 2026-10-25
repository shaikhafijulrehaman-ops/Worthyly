import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import {
  Sparkles,
  Smartphone,
  Laptop,
  Tv,
  Box,
  Disc,
  Wind,
  Tablet,
  Headphones,
  Footprints,
  Utensils,
  Armchair,
  Dumbbell,
  Flame,
  BookOpen,
  Newspaper,
  ArrowRight,
  ShieldCheck,
  CheckCircle2,
  Sliders,
  Scale,
  Award,
  Zap,
  Star,
  ExternalLink,
  ChevronRight,
  TrendingDown,
  Lock,
  ThumbsUp,
  Activity,
  Layers,
  ChevronLeft
} from 'lucide-react';
import { getCanonicalCategories } from '../services/categoryRegistry';
import NeonBorder from '../components/NeonBorder';
import { formatINR } from '../utils/currency';
import GlitchHeroSequence, { WORTHLY_MESSAGES } from '../components/GlitchHeroSequence';
import ProductImage from '../components/ProductImage';
import LetterDrop from '../components/originkit/ui/letter-drop';
import PulseRoll from '../components/originkit/ui/pulse-roll';

const CATEGORY_ICON_MAP = {
  smartphones: Smartphone,
  laptops: Laptop,
  televisions: Tv,
  refrigerators: Box,
  washing_machines: Disc,
  air_conditioners: Wind,
  tablets_monitors: Tablet,
  consumer_electronics: Headphones,
  fitness_equipment: Dumbbell,
  kitchen_chimneys: Flame,
  books: BookOpen,
  magazines: Newspaper,
  nutrition: ShieldCheck,
  home_kitchen: Utensils,
  furniture: Armchair,
  footwear: Footprints
};

const CATEGORIES = getCanonicalCategories().map((c) => ({
  id: c.id,
  name: c.name,
  description: c.description,
  icon: CATEGORY_ICON_MAP[c.id] || Laptop,
  budgetRange: 'Spec-Verified',
  itemCount: 'Verified Models'
}));

const HOW_IT_WORKS = [
  {
    step: '01',
    title: 'Tell us what you need.',
    desc: 'Select your product category and intended use scenarios—from AI coding and Docker workloads to everyday walking comfort.',
    icon: Sliders
  },
  {
    step: '02',
    title: 'Set your budget and priorities.',
    desc: 'Specify your exact maximum budget in INR and choose whether raw performance, battery, durability, or ergonomics matters most.',
    icon: TrendingDown
  },
  {
    step: '03',
    title: 'Compare your best three matches.',
    desc: 'Our deterministic recommendation engine classifies products into Best Overall Match, Best Value, and Best Alternative.',
    icon: Scale
  },
  {
    step: '04',
    title: 'Make a confident purchase decision.',
    desc: 'Review evidence-based explanations, verified pros/cons, and direct official brand store purchase links.',
    icon: CheckCircle2
  }
];

const BENEFITS = [
  {
    title: 'Strict Budget Constraint Enforcement',
    desc: 'We never sneak over-budget products into your results. If you set ₹1,20,000 as your ceiling, every match stays within your bounds.',
    icon: Lock
  },
  {
    title: 'Zero Biased or Sponsored Placements',
    desc: 'Recommendations are calculated deterministically from verified hardware specifications and authentic ratings, not ad spend.',
    icon: ShieldCheck
  },
  {
    title: 'Verified Indian Market Prices (INR)',
    desc: 'Every item is audited against official Indian brand portals and authorized retail channels with visible timestamp verification.',
    icon: Award
  },
  {
    title: 'Priority-Weighted Role Classification',
    desc: 'Transparently discover which model is the Highest Scoring Match, which is Best Value, and which offers a unique Alternative.',
    icon: Zap
  }
];

export default function PageLanding({
  onStartFinding,
  onSelectCategory,
  onNavigate,
  featuredProducts = [],
  reviews = [],
  onViewDetails
}) {
  return (
    <div className="space-y-10 sm:space-y-12 pb-12 overflow-x-hidden">
      {/* 1. Full-Width Open Glassmorphism Hero */}
      <section className="relative pt-6 pb-10 sm:py-14 md:py-16 overflow-hidden">
        {/* Layered Subtle Ambient Background Lighting */}
        <div className="absolute top-1/3 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[720px] max-w-full h-[400px] bg-gradient-to-tr from-[#3559C7]/12 via-[#D6AD60]/10 to-transparent rounded-full blur-3xl pointer-events-none -z-10" />
        <div className="absolute top-8 left-10 w-72 h-72 bg-[#3559C7]/8 rounded-full blur-3xl pointer-events-none -z-10" />
        <div className="absolute bottom-6 right-10 w-80 h-80 bg-[#D6AD60]/8 rounded-full blur-3xl pointer-events-none -z-10" />

        {/* Centered Content Container */}
        <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center space-y-6 sm:space-y-8 relative z-10">
          {/* Top Category Kicker Pill */}
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full glass-pill text-xs font-semibold text-[#18213A] shadow-xs">
            <span className="w-2 h-2 rounded-full bg-[#3559C7] animate-pulse" />
            <span className="text-[#3559C7] font-bold">Decision Intelligence</span>
            <span className="text-[#69738A]">•</span>
            <span className="text-[#69738A]">Indian Market Edition</span>
          </div>

          {/* Main Brand Title with Originkit Letter Drop */}
          <div className="space-y-2">
            <div className="overflow-hidden py-1">
              <LetterDrop
                text="WORTHLY"
                font={{
                  fontFamily: "Inter, -apple-system, BlinkMacSystemFont, sans-serif",
                  fontSize: "clamp(2.75rem, 7vw, 5rem)",
                  fontWeight: 900,
                  letterSpacing: "-0.035em",
                  lineHeight: "1.05",
                  textAlign: "center"
                }}
                color="#101B3D"
                startY={-35}
                startOpacity={0}
                staggerFrom="center"
                transition={{
                  duration: 0.6,
                  delay: 0.05,
                  ease: "backOut",
                  staggerChildren: 0.03
                }}
              />
            </div>
          </div>

          {/* Animated Glitch Text Message with GlitchHeroSequence */}
          <div className="w-full">
            <GlitchHeroSequence color="#101B3D" />
          </div>

          {/* Supporting Description Copy */}
          <p className="text-sm sm:text-base md:text-lg text-[#69738A] leading-relaxed max-w-2xl mx-auto font-normal">
            Compare products, understand their value, and discover the best options for your budget and needs.
          </p>

          {/* Primary & Secondary Call to Actions */}
          <div className="flex flex-wrap items-center justify-center gap-4 pt-2">
            <NeonBorder
              variant="button"
              onClick={onStartFinding}
              className="text-base px-8 py-3.5 cursor-pointer shadow-lg"
            >
              <Sparkles className="w-4 h-4 text-[#D6AD60]" />
              <span className="font-bold">Find My Best 3</span>
              <ArrowRight className="w-4 h-4" />
            </NeonBorder>

            <button
              onClick={() => onNavigate('explorer')}
              className="px-7 py-3.5 rounded-xl font-bold text-sm text-[#18213A] glass-panel glass-card-hover border border-white/80 hover:border-[#3559C7]/50 transition flex items-center gap-2 cursor-pointer shadow-xs"
            >
              <span>Explore Products</span>
              <ChevronRight className="w-4 h-4 text-[#69738A]" />
            </button>
          </div>

          {/* Restrained Trust Indicator below CTAs */}
          <div className="pt-4 flex flex-wrap items-center justify-center gap-3 sm:gap-6 text-xs text-[#69738A]">
            <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl glass-panel-subtle border border-white/80">
              <ShieldCheck className="w-4 h-4 text-[#23865B]" />
              <span className="font-semibold text-[#18213A]">Strict Budget Enforcement</span>
            </div>

            <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl glass-panel-subtle border border-white/80">
              <Scale className="w-4 h-4 text-[#3559C7]" />
              <span className="font-semibold text-[#18213A]">100% Deterministic Matching</span>
            </div>

            <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl glass-panel-subtle border border-white/80">
              <Award className="w-4 h-4 text-[#D6AD60]" />
              <span className="font-semibold text-[#18213A]">Verified Indian Retail Pricing</span>
            </div>
          </div>
        </div>
      </section>

      {/* 2. Full-Width Feature Strip: Originkit Pulse Roll (Between Hero & Categories) */}
      <section className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-[#101B3D] via-[#17264F] to-[#101B3D] text-[#FFF9EF] p-5 sm:p-7 md:p-8 shadow-2xl border border-[#17264F]">
        {/* Subtle Ambient Glows */}
        <div className="absolute top-0 right-0 w-96 h-96 bg-[#3559C7]/20 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-0 w-80 h-80 bg-[#D6AD60]/15 rounded-full blur-3xl pointer-events-none" />

        <div className="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-6 lg:gap-8 items-center">
          {/* Feature Narrative & Telemetry */}
          <div className="lg:col-span-5 space-y-3.5">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 backdrop-blur-md border border-white/20 text-xs font-semibold text-[#D6AD60]">
              <Zap className="w-3.5 h-3.5 text-[#D6AD60]" />
              <span>Real-Time Algorithmic Engine</span>
            </div>

            <h3 className="text-2xl sm:text-3xl font-black text-white tracking-tight leading-tight">
              The Pulse of Intelligent Shopping
            </h3>

            <p className="text-xs sm:text-sm text-[#FFF9EF]/80 leading-relaxed">
              Every millisecond of computing matches your exact budget and intended workflows across 20+ audited flagships with verified Indian retail availability.
            </p>

            {/* Quick Metrics Cards */}
            <div className="grid grid-cols-2 gap-3 pt-1">
              <div className="p-3 rounded-2xl bg-white/5 border border-white/10 backdrop-blur-md">
                <div className="text-xl font-black text-[#D6AD60]">100%</div>
                <div className="text-[11px] text-[#FFF9EF]/70 font-medium">Deterministic Scoring</div>
              </div>
              <div className="p-3 rounded-2xl bg-white/5 border border-white/10 backdrop-blur-md">
                <div className="text-xl font-black text-white">0%</div>
                <div className="text-[11px] text-[#FFF9EF]/70 font-medium">Marketing Noise</div>
              </div>
            </div>

            <div className="pt-1 flex items-center gap-2 text-xs text-[#FFF9EF]/75">
              <ShieldCheck className="w-4 h-4 text-[#23865B]" />
              <span>Audited against official brand prices and retailer offers</span>
            </div>
          </div>

          {/* Originkit Pulse Roll WebGL Canvas Container */}
          <div className="lg:col-span-7 relative h-52 sm:h-64 w-full rounded-2xl overflow-hidden border border-white/20 bg-black/40 backdrop-blur-xl flex items-center justify-center shadow-inner">
            <PulseRoll
              background="transparent"
              baseColor="#3559C7"
              accentColor="#D6AD60"
              speed={48}
              distance={15}
              pulse={{
                count: 12,
                spacing: 95,
                minSize: 30,
                stagger: 240
              }}
              style={{
                minWidth: "100%",
                width: "100%",
                height: "100%",
                minHeight: "100%",
                position: "relative"
              }}
            />

            {/* Floating Glass Telemetry Overlays */}
            <div className="absolute top-3 left-3 px-3 py-1 rounded-full bg-[#101B3D]/85 backdrop-blur-md border border-[#D6AD60]/40 text-[11px] font-bold text-[#D6AD60] flex items-center gap-1.5 shadow-sm">
              <span className="w-2 h-2 rounded-full bg-[#D6AD60] animate-ping" />
              <span>Active Parameter Wave</span>
            </div>

            <div className="absolute bottom-3 right-3 px-3 py-1 rounded-full bg-[#101B3D]/85 backdrop-blur-md border border-white/20 text-[11px] font-medium text-white/90">
              Indian Market Flagships Synced
            </div>
          </div>
        </div>
      </section>

      {/* 3. Product Category Exploration Cards */}
      <section className="space-y-6">
        <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
          <div>
            <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
              Curated Segments
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-[#18213A]">
              Explore by Category
            </h2>
            <p className="text-xs sm:text-sm text-[#69738A]">
              Choose a segment to launch your customized 6-step requirement matching wizard.
            </p>
          </div>

          <button
            onClick={() => onNavigate('explorer')}
            className="text-xs font-bold text-[#3559C7] hover:underline flex items-center gap-1 self-start sm:self-auto cursor-pointer"
          >
            <span>View Full Verified Catalog</span>
            <ChevronRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {CATEGORIES.map((cat, i) => {
            const Icon = cat.icon;
            return (
              <motion.div
                key={cat.id}
                initial={{ opacity: 0, y: 15 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.05 }}
                onClick={() => onSelectCategory(cat.id)}
                className="glass-panel glass-card-hover rounded-3xl p-5 sm:p-6 cursor-pointer flex flex-col justify-between h-full group shadow-xs hover:shadow-md border border-white/80"
              >
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="w-12 h-12 rounded-2xl bg-[#FFF9EF] border border-[#E6E0D5] flex items-center justify-center text-[#101B3D] group-hover:bg-[#101B3D] group-hover:text-[#D6AD60] transition-colors shadow-xs">
                      <Icon className="w-6 h-6" />
                    </div>
                    <span className="text-xs font-semibold text-[#69738A] bg-[#F7F1E6] px-3 py-1 rounded-full border border-[#E6E0D5]/70">
                      {cat.itemCount}
                    </span>
                  </div>

                  <h3 className="text-lg font-bold text-[#18213A] group-hover:text-[#3559C7] transition-colors">
                    {cat.name}
                  </h3>

                  <p className="text-xs text-[#69738A] leading-relaxed">
                    {cat.description}
                  </p>
                </div>

                <div className="pt-5 mt-5 border-t border-[#E6E0D5]/70 flex items-center justify-between">
                  <span className="text-xs text-[#69738A]">
                    Range: <strong className="text-[#18213A]">{cat.budgetRange}</strong>
                  </span>
                  <div className="flex items-center gap-1 text-xs font-bold text-[#3559C7] group-hover:translate-x-1 transition-transform">
                    <span>Find Best 3</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>
      </section>

      {/* 4. How It Works Section with Originkit Letter Drop */}
      <section className="space-y-8">
        <div className="text-center max-w-xl mx-auto space-y-2">
          <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
            Deterministic 4-Step Process
          </span>
          <div className="overflow-hidden py-1">
            <LetterDrop
              text="How WORTHLY Works"
              font={{
                fontFamily: "Inter, sans-serif",
                fontSize: "clamp(1.75rem, 3.5vw, 2.5rem)",
                fontWeight: 900,
                letterSpacing: "-0.02em",
                lineHeight: "1.2",
                textAlign: "center"
              }}
              color="#18213A"
              startY={-20}
              startOpacity={0}
              staggerFrom="center"
              transition={{ duration: 0.5, staggerChildren: 0.03 }}
            />
          </div>
          <p className="text-xs sm:text-sm text-[#69738A]">
            No sponsored rankings. No fake ratings. Just honest specification evaluation tuned directly to your constraints.
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {HOW_IT_WORKS.map((step, idx) => {
            const Icon = step.icon;
            return (
              <motion.div
                key={step.step}
                initial={{ opacity: 0, y: 15 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: idx * 0.06 }}
                className="glass-panel glass-card-hover rounded-3xl p-5 sm:p-6 flex flex-col justify-between h-full relative group border border-white/80"
              >
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="w-11 h-11 rounded-2xl bg-white/70 border border-white/90 text-[#3559C7] flex items-center justify-center font-bold shadow-xs">
                      <Icon className="w-5 h-5 text-[#3559C7]" />
                    </div>
                    <span className="text-2xl font-black text-[#E6E0D5] group-hover:text-[#D6AD60] transition-colors">
                      {step.step}
                    </span>
                  </div>
                  <h3 className="font-bold text-[#18213A] text-base">
                    {step.title}
                  </h3>
                  <p className="text-xs text-[#69738A] leading-relaxed">
                    {step.desc}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>
      </section>

      {/* 5. Featured Recommendations Showcase */}
      {featuredProducts.length > 0 && (
        <section className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
                Verified Spotlight
              </span>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-[#18213A]">
                Top Verified Recommendations
              </h2>
              <p className="text-xs sm:text-sm text-[#69738A]">
                Sample the top-ranked models across our primary categories with verified Indian retail availability.
              </p>
            </div>

            <button
              onClick={() => onNavigate('explorer')}
              className="text-xs font-bold text-[#3559C7] hover:underline flex items-center gap-1 self-start sm:self-auto cursor-pointer"
            >
              <span>Explore All Products</span>
              <ChevronRight className="w-3.5 h-3.5" />
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {featuredProducts.slice(0, 3).map((prod) => (
              <div
                key={prod.id}
                className="glass-panel glass-card-hover rounded-3xl p-5 flex flex-col justify-between h-full space-y-4 border border-white/80"
              >
                <div className="space-y-3">
                  <div className="aspect-16/10 rounded-2xl overflow-hidden bg-[#F7F1E6] border border-[#E6E0D5] relative shadow-inner">
                    <ProductImage
                      src={prod.imageUrl}
                      alt={prod.name}
                      category={prod.category}
                      brand={prod.brand}
                      className="w-full h-full object-cover"
                    />
                    <span className="absolute top-2.5 left-2.5 bg-[#101B3D] text-[#FFF9EF] text-[10px] font-bold px-2 py-0.5 rounded-md">
                      {prod.brand}
                    </span>
                    <span className="absolute top-2.5 right-2.5 bg-white/95 backdrop-blur-xs text-[#18213A] text-[10px] font-bold px-2 py-0.5 rounded-md border border-[#E6E0D5] flex items-center gap-1 shadow-xs">
                      <Star className="w-3 h-3 fill-amber-400 text-amber-500" />
                      {prod.rating}
                    </span>
                  </div>

                  <div>
                    <h3 className="font-bold text-base text-[#18213A] line-clamp-1">
                      {prod.name}
                    </h3>
                    <div className="text-xl font-extrabold text-[#101B3D] mt-0.5">
                      {formatINR(prod.price)}
                    </div>
                  </div>

                  <p className="text-xs text-[#69738A] line-clamp-2">
                    {prod.pros?.[0] || 'High performance and verified durability.'}
                  </p>
                </div>

                <div className="pt-3 border-t border-[#E6E0D5]/70 flex items-center justify-between gap-2">
                  <button
                    onClick={() => onViewDetails(prod)}
                    className="flex-1 py-2 px-3 bg-[#101B3D] text-[#FFF9EF] rounded-xl text-xs font-bold hover:bg-[#17264F] transition text-center cursor-pointer shadow-xs"
                  >
                    View Details
                  </button>

                  {prod.officialProductUrl ? (
                    <a
                      href={prod.officialProductUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="py-2 px-3 bg-[#3559C7] text-white rounded-xl text-xs font-bold hover:bg-[#2e4eb2] transition flex items-center gap-1 shadow-xs"
                    >
                      <span>Official Store</span>
                      <ExternalLink className="w-3 h-3" />
                    </a>
                  ) : (
                    <span className="text-[11px] text-[#69738A] px-2 py-1 bg-[#F7F1E6] rounded-lg">
                      Link unavailable
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* 6. Authentic Community Reviews Showcase */}
      {reviews.length > 0 && (
        <section className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
                Authentic Community Feedback
              </span>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-[#18213A]">
                What Verified Buyers Say
              </h2>
              <p className="text-xs sm:text-sm text-[#69738A]">
                Every review details specific intended workflows and verified purchase dates.
              </p>
            </div>

            <button
              onClick={() => onNavigate('community-reviews')}
              className="text-xs font-bold text-[#3559C7] hover:underline flex items-center gap-1 self-start sm:self-auto cursor-pointer"
            >
              <span>See All Community Reviews ({reviews.length})</span>
              <ChevronRight className="w-3.5 h-3.5" />
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {reviews.slice(0, 3).map((r) => (
              <div
                key={r.id}
                className="glass-panel glass-card-hover rounded-3xl p-5 sm:p-6 space-y-3 flex flex-col justify-between h-full border border-white/80"
              >
                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="flex text-amber-500">
                      {[1, 2, 3, 4, 5].map((s) => (
                        <Star
                          key={s}
                          className={`w-3.5 h-3.5 ${
                            s <= r.rating ? 'fill-amber-400 text-amber-500' : 'text-gray-300'
                          }`}
                        />
                      ))}
                    </div>
                    {r.isVerifiedPurchase && (
                      <span className="text-[10px] font-bold text-[#23865B] bg-[#23865B]/10 px-2.5 py-0.5 rounded-full flex items-center gap-1 border border-[#23865B]/20">
                        <ShieldCheck className="w-3 h-3" /> Verified
                      </span>
                    )}
                  </div>

                  <h3 className="font-bold text-sm text-[#18213A] line-clamp-1">
                    {r.title}
                  </h3>

                  <p className="text-xs text-[#69738A] line-clamp-3 leading-relaxed">
                    "{r.reviewText}"
                  </p>
                </div>

                <div className="pt-3 border-t border-[#E6E0D5]/70 text-[11px] text-[#69738A]">
                  <p className="font-bold text-[#18213A] truncate">{r.productName}</p>
                  <p className="text-[#3559C7] font-medium">{r.intendedUsage}</p>
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* 7. Benefits of WORTHLY */}
      <section className="space-y-6">
        <div className="text-center max-w-xl mx-auto space-y-2">
          <span className="text-xs font-bold uppercase tracking-wider text-[#D6AD60]">
            The WORTHLY Difference
          </span>
          <h2 className="text-2xl sm:text-3xl font-extrabold text-[#18213A]">
            Why Rely on WORTHLY?
          </h2>
          <p className="text-xs sm:text-sm text-[#69738A]">
            Engineered to overcome the cluttered, advertisement-driven state of modern product shopping.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {BENEFITS.map((ben, idx) => {
            const Icon = ben.icon;
            return (
              <div
                key={idx}
                className="glass-panel glass-card-hover rounded-3xl p-5 sm:p-6 flex items-start gap-4 h-full border border-white/80"
              >
                <div className="w-12 h-12 rounded-2xl bg-[#FFF9EF] border border-[#E6E0D5] text-[#3559C7] flex items-center justify-center shrink-0 shadow-xs">
                  <Icon className="w-6 h-6" />
                </div>
                <div className="space-y-1">
                  <h3 className="font-bold text-base text-[#18213A]">
                    {ben.title}
                  </h3>
                  <p className="text-xs text-[#69738A] leading-relaxed">
                    {ben.desc}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* 8. Final Call to Action with Originkit Letter Drop */}
      <section className="relative overflow-hidden rounded-3xl glass-panel p-6 sm:p-10 text-center text-[#18213A] shadow-xs border border-white/85">
        <div className="absolute top-0 right-1/4 w-72 h-72 bg-[#3559C7]/8 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-1/4 w-72 h-72 bg-[#D6AD60]/10 rounded-full blur-3xl pointer-events-none" />

        <div className="relative z-10 max-w-2xl mx-auto space-y-4">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full glass-pill text-xs font-semibold text-[#18213A]">
            <Sparkles className="w-3.5 h-3.5 text-[#3559C7]" />
            <span className="text-[#3559C7] font-bold">Start Your Shortlist</span>
          </div>

          <div className="overflow-hidden py-1">
            <LetterDrop
              text="Ready to Find Your Best Match?"
              font={{
                fontFamily: "Inter, system-ui, sans-serif",
                fontSize: "clamp(1.85rem, 4vw, 2.75rem)",
                fontWeight: 900,
                letterSpacing: "-0.025em",
                lineHeight: "1.15",
                textAlign: "center"
              }}
              color="#101B3D"
              startY={-20}
              startOpacity={0}
              staggerFrom="center"
              transition={{ duration: 0.55, staggerChildren: 0.03 }}
            />
          </div>

          <p className="text-xs sm:text-sm text-[#69738A] max-w-lg mx-auto leading-relaxed">
            Specify your requirements in under 60 seconds and compare the 3 products that genuinely fit your life and budget.
          </p>

          <div className="flex justify-center pt-2">
            <NeonBorder
              variant="button"
              onClick={onStartFinding}
              className="text-base cursor-pointer shadow-lg"
            >
              <Sparkles className="w-4 h-4 text-[#D6AD60]" />
              <span className="font-bold">Find My Best 3</span>
              <ArrowRight className="w-4 h-4" />
            </NeonBorder>
          </div>
        </div>
      </section>
    </div>
  );
}

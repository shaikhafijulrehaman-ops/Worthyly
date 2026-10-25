import React from 'react';
import { motion } from 'framer-motion';
import {
  Sparkles,
  Laptop,
  Footprints,
  Utensils,
  Armchair,
  Dumbbell,
  GraduationCap,
  Smartphone,
  BookOpen,
  Newspaper,
  Headphones,
  Flame,
  Package,
  ArrowRight,
  ShieldCheck,
  CheckCircle,
  Sliders,
  Scale,
  Award,
  Zap,
  DollarSign,
  Tv,
  Box,
  Disc,
  Wind,
  Tablet,
  Home
} from 'lucide-react';
import NeonBorder from '../components/NeonBorder';
import { getCanonicalCategories } from '../services/categoryRegistry';

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
  nutrition: Package,
  home_kitchen: Home,
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
    desc: 'Select your category and intended usage scenarios—from AI programming to everyday commute comfort.',
    icon: Sliders
  },
  {
    step: '02',
    title: 'Set your budget and priorities.',
    desc: 'Define strict price ceilings and choose whether performance, battery, ergonomics, or durability matters most.',
    icon: DollarSign
  },
  {
    step: '03',
    title: 'Compare your best three matches.',
    desc: 'Our deterministic engine ranks products into Best Overall, Best Value, and Best Alternative with transparent scores.',
    icon: Scale
  },
  {
    step: '04',
    title: 'Make a confident purchase decision.',
    desc: 'Read evidence-backed explanations, pros, cons, and verified purchase reviews before spending a single dollar.',
    icon: CheckCircle
  }
];

export default function PageOverview({ onStartFinding, onSelectCategory, onNavigate }) {
  return (
    <div className="space-y-14 pb-12">
      {/* Hero Section */}
      <section className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-[#101B3D] via-[#17264F] to-[#101B3D] text-[#FFF9EF] p-8 md:p-14 shadow-xl border border-[#17264F]">
        {/* Subtle background ambient glows */}
        <div className="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 rounded-full bg-[#3559C7]/20 blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-1/3 -mb-20 w-80 h-80 rounded-full bg-[#D6AD60]/15 blur-3xl pointer-events-none" />

        <div className="relative z-10 max-w-3xl space-y-6">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#3559C7]/30 border border-[#3559C7]/50 text-xs font-semibold text-[#D6AD60]">
            <Sparkles className="w-3.5 h-3.5 text-[#D6AD60]" />
            <span>Intelligent Purchase Decision Platform</span>
          </div>

          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight leading-[1.1] text-white">
            Find What Fits You <span className="text-[#D6AD60]">Best.</span>
          </h1>

          <p className="text-lg md:text-xl text-[#FFF9EF]/80 font-normal leading-relaxed max-w-2xl">
            Tell us what you need, set your budget, and discover three products
            that genuinely match your requirements.
          </p>

          {/* Action CTAs */}
          <div className="flex flex-wrap items-center gap-4 pt-4">
            {/* Primary CTA with Originkit Neon Border */}
            <NeonBorder
              variant="button"
              onClick={onStartFinding}
              className="text-base"
            >
              <Sparkles className="w-5 h-5 text-[#D6AD60]" />
              <span>Find My Best Match</span>
              <ArrowRight className="w-4 h-4" />
            </NeonBorder>

            <button
              onClick={() => {
                const el = document.getElementById('categories-grid');
                if (el) el.scrollIntoView({ behavior: 'smooth' });
              }}
              className="px-6 py-3.5 rounded-xl font-semibold text-sm bg-white/10 hover:bg-white/15 text-[#FFF9EF] border border-[#FFF9EF]/20 transition flex items-center gap-2"
            >
              <span>Explore Categories</span>
            </button>
          </div>

          {/* Trust Guarantees */}
          <div className="pt-6 border-t border-white/10 grid grid-cols-1 sm:grid-cols-3 gap-4 text-xs text-[#FFF9EF]/70">
            <div className="flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-[#23865B] shrink-0" />
              <span>Strict Budget Constraint Filtering</span>
            </div>
            <div className="flex items-center gap-2">
              <Award className="w-4 h-4 text-[#D6AD60] shrink-0" />
              <span>Curated Verified Specs & Prices</span>
            </div>
            <div className="flex items-center gap-2">
              <Zap className="w-4 h-4 text-[#3559C7] shrink-0" />
              <span>Evidence-Based Recommendation Engine</span>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section className="space-y-6">
        <div className="text-center max-w-xl mx-auto space-y-2">
          <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
            Transparent 4-Step Process
          </span>
          <h2 className="text-2xl sm:text-3xl font-extrabold text-[#18213A]">
            How WORTHLY Works
          </h2>
          <p className="text-sm text-[#69738A]">
            Zero sponsored bias. Zero fabricated products. Just deterministic mathematical alignment with your lifestyle.
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
                transition={{ delay: idx * 0.1 }}
                className="bg-white rounded-2xl p-6 border border-[#E6E0D5] shadow-xs hover:shadow-md transition space-y-3 relative overflow-hidden group"
              >
                <div className="flex items-center justify-between">
                  <div className="w-10 h-10 rounded-xl bg-[#FFF9EF] border border-[#E6E0D5] text-[#3559C7] flex items-center justify-center font-bold">
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
              </motion.div>
            );
          })}
        </div>
      </section>

      {/* Category Grid Section */}
      <section id="categories-grid" className="space-y-6">
        <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
          <div>
            <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
              Verified Catalog
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-[#18213A]">
              Explore by Category
            </h2>
            <p className="text-sm text-[#69738A]">
              Select a category to launch the personalized Requirement Builder.
            </p>
          </div>

          <button
            onClick={() => onNavigate('explorer')}
            className="text-xs font-bold text-[#3559C7] hover:underline flex items-center gap-1 self-start sm:self-auto"
          >
            <span>View all products catalog</span>
            <ArrowRight className="w-3.5 h-3.5" />
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
                transition={{ delay: i * 0.08 }}
                onClick={() => onSelectCategory(cat.id)}
                className="bg-white rounded-2xl p-6 border border-[#E6E0D5] hover:border-[#3559C7] hover:shadow-lg transition-all cursor-pointer group flex flex-col justify-between"
              >
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <div className="w-12 h-12 rounded-xl bg-[#FFF9EF] border border-[#E6E0D5] flex items-center justify-center text-[#101B3D] group-hover:bg-[#101B3D] group-hover:text-[#D6AD60] transition-colors">
                      <Icon className="w-6 h-6" />
                    </div>
                    <span className="text-xs font-semibold text-[#69738A] bg-[#F7F1E6] px-2.5 py-1 rounded-full">
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

                <div className="pt-5 mt-5 border-t border-[#E6E0D5] flex items-center justify-between">
                  <span className="text-xs text-[#69738A]">
                    Range: <strong className="text-[#18213A]">{cat.budgetRange}</strong>
                  </span>
                  <div className="flex items-center gap-1 text-xs font-bold text-[#3559C7] group-hover:translate-x-1 transition-transform">
                    <span>Configure</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>
      </section>

      {/* Highlight Banner */}
      <section className="rounded-2xl bg-[#FFF9EF] border border-[#E6E0D5] p-8 flex flex-col md:flex-row items-center justify-between gap-6">
        <div className="space-y-2">
          <span className="text-xs font-bold uppercase tracking-wider text-[#D6AD60]">
            The WORTHLY Guarantee
          </span>
          <h3 className="text-xl md:text-2xl font-bold text-[#18213A]">
            No fabricated reviews. No sponsored ranking tricks.
          </h3>
          <p className="text-sm text-[#69738A] max-w-xl">
            Every product in our system includes its verified price audit timestamp, verified purchase review counts, and exact specification metrics.
          </p>
        </div>

        <button
          onClick={onStartFinding}
          className="shrink-0 px-6 py-3 rounded-xl bg-[#101B3D] hover:bg-[#17264F] text-[#FFF9EF] font-bold text-sm transition shadow-md flex items-center gap-2"
        >
          <span>Find My 3 Matches</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </section>
    </div>
  );
}

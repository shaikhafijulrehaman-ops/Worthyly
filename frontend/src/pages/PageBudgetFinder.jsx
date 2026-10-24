import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import {
  Sliders,
  Award,
  Zap,
  TrendingDown,
  Sparkles,
  ShieldCheck,
  CheckCircle2,
  AlertCircle,
  Eye,
  Scale,
  Bookmark,
  Star,
  ExternalLink,
  ShoppingBag
} from 'lucide-react';
import { api } from '../services/api';
import { formatINR } from '../utils/currency';
import ProductImage from '../components/ProductImage';

export default function PageBudgetFinder({
  categories = [],
  onViewDetails,
  onAddToCompare,
  comparedIds = [],
  onToggleSave,
  savedIds = []
}) {
  const [selectedCategory, setSelectedCategory] = useState('electronics');
  const [budget, setBudget] = useState(135000);
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  // Sync category default budget
  useEffect(() => {
    const cat = categories.find((c) => c.id === selectedCategory);
    if (cat && cat.defaultMax) {
      setBudget(cat.defaultMax);
    }
  }, [selectedCategory, categories]);

  const fetchBreakdown = async () => {
    setLoading(true);
    try {
      const data = await api.getBudgetFinder(selectedCategory, budget);
      setResult(data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBreakdown();
  }, [selectedCategory, budget]);

  const tiers = result?.tiers || {};
  const currentCat = categories.find((c) => c.id === selectedCategory);

  return (
    <div className="space-y-6 pb-12">
      {/* Header */}
      <div className="glass-panel p-5 sm:p-6 rounded-2xl space-y-1.5">
        <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
          Smart Tier Optimization (INR)
        </span>
        <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
          Budget Finder
        </h1>
        <p className="text-xs md:text-sm text-[#69738A]">
          Understand exactly how your rupees are allocated. Compare the Lowest Price, Budget Friendly, Best Value, and Best Performance options within your specific ceiling.
        </p>
      </div>

      {/* Interactive Budget Controls */}
      <div className="glass-panel p-5 sm:p-6 rounded-2xl space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-center">
          <div className="space-y-1.5">
            <label className="text-xs font-bold uppercase tracking-wider text-[#101B3D]">
              Choose Category
            </label>
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="w-full px-4 py-2.5 rounded-xl glass-input font-semibold text-xs sm:text-sm text-[#18213A]"
            >
              {categories.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-bold uppercase tracking-wider text-[#101B3D] flex items-center justify-between">
              <span>Your Budget Ceiling</span>
              <span className="text-base font-black text-[#3559C7]">
                {formatINR(budget)}
              </span>
            </label>
            <div className="relative">
              <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-500 font-bold">₹</span>
              <input
                type="number"
                min="3000"
                max="200000"
                step="1000"
                value={budget}
                onChange={(e) => setBudget(Number(e.target.value))}
                className="w-full pl-8 pr-4 py-2.5 rounded-xl glass-input font-bold text-sm text-[#18213A]"
              />
            </div>
          </div>
        </div>

        {/* Range Slider */}
        <div className="space-y-2 pt-1">
          <input
            type="range"
            min={5000}
            max={180000}
            step={2500}
            value={budget}
            onChange={(e) => setBudget(Number(e.target.value))}
            className="w-full accent-[#3559C7] cursor-pointer"
          />
          <div className="flex justify-between text-xs text-[#69738A]">
            <span>₹5,000</span>
            <span>₹90,000</span>
            <span>₹1,80,000+</span>
          </div>
        </div>
      </div>

      {/* Educational Distinction Guide: Never Interchangeable */}
      <div className="glass-panel p-5 rounded-2xl space-y-2.5">
        <h3 className="text-sm font-bold text-[#101B3D] flex items-center gap-2">
          <Award className="w-4 h-4 text-[#D6AD60]" />
          Understanding the 4 Distinct Budget Roles
        </h3>
        <p className="text-xs text-[#69738A] leading-relaxed">
          WORTHLY never treats these labels as interchangeable marketing tags:
        </p>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 text-xs">
          <div className="p-3.5 rounded-xl glass-panel-subtle border border-white/80 space-y-1">
            <span className="font-bold text-[#18213A] block mb-1">1. Lowest Price</span>
            <p className="text-[#69738A]">The bare-minimum cost to acquire a working model in this segment.</p>
          </div>
          <div className="p-3.5 rounded-xl glass-panel-subtle border border-white/80 space-y-1">
            <span className="font-bold text-[#18213A] block mb-1">2. Budget Friendly</span>
            <p className="text-[#69738A]">Comfortably below budget, avoiding extreme entry-level compromises.</p>
          </div>
          <div className="p-3.5 rounded-xl glass-panel-subtle border border-white/80 space-y-1">
            <span className="font-bold text-[#18213A] block mb-1">3. Best Value</span>
            <p className="text-[#69738A]">Highest user rating and hardware specifications per rupee spent.</p>
          </div>
          <div className="p-3.5 rounded-xl glass-panel-subtle border border-white/80 space-y-1">
            <span className="font-bold text-[#18213A] block mb-1">4. Best Performance</span>
            <p className="text-[#69738A]">Maximizes your budget ceiling to deliver top-tier processing and longevity.</p>
          </div>
        </div>
      </div>

      {/* Results Tiers Grid */}
      {result?.status === 'insufficient_budget' ? (
        <div className="glass-panel p-6 rounded-2xl text-center space-y-2 max-w-md mx-auto my-6">
          <AlertCircle className="w-7 h-7 text-amber-500 mx-auto" />
          <h3 className="text-base font-bold text-[#18213A]">
            Budget Below Lowest Available Model
          </h3>
          <p className="text-xs text-[#69738A] max-w-md mx-auto">
            {result.message}
          </p>
        </div>
      ) : (
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 items-stretch">
            {Object.entries(tiers).map(([tierKey, tierData]) => {
              const p = tierData.product;
              if (!p) return null;
              const isCompared = comparedIds.includes(p.id);
              const isSaved = savedIds.includes(p.id);

              return (
                <div
                  key={tierKey}
                  className="glass-panel glass-card-hover rounded-2xl p-4 sm:p-5 flex flex-col justify-between space-y-3.5 h-full border border-white/80 shadow-xs"
                >
                  <div className="space-y-2.5">
                    <div className="flex items-center justify-between">
                      <span className="text-[11px] font-black uppercase tracking-wider text-[#3559C7] bg-[#3559C7]/10 px-2.5 py-0.5 rounded-full">
                        {tierData.role_title}
                      </span>
                      <span className="text-xs font-bold text-amber-500 flex items-center gap-1">
                        <Star className="w-3.5 h-3.5 fill-amber-400" /> {p.rating}
                      </span>
                    </div>

                    <p className="text-[11px] text-[#69738A] leading-tight">
                      {tierData.explanation}
                    </p>

                    <div className="aspect-16/10 rounded-xl overflow-hidden bg-white/40 border border-white/70">
                      <ProductImage
                        src={p.imageUrl}
                        alt={p.name}
                        category={p.category}
                        brand={p.brand}
                        className="w-full h-full object-cover"
                      />
                    </div>

                    <div>
                      <span className="text-[10px] font-bold uppercase text-[#69738A]">{p.brand}</span>
                      <h4 className="font-bold text-sm text-[#18213A] line-clamp-1">{p.name}</h4>
                      <div className="text-xl font-extrabold text-[#101B3D] mt-0.5">
                        {formatINR(p.price)}
                      </div>
                    </div>

                    {/* Quick Specs */}
                    <div className="bg-white/60 backdrop-blur-md p-2.5 rounded-xl border border-white/80 text-[10px] space-y-1">
                      {Object.entries(p.specs || {}).slice(0, 2).map(([k, v]) => (
                        <div key={k} className="flex justify-between">
                          <span className="text-[#69738A] capitalize font-medium">{k}:</span>
                          <span className="text-[#18213A] font-semibold truncate max-w-[120px]">{String(v)}</span>
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="pt-2 border-t border-white/80 flex items-center justify-between gap-2">
                    <button
                      onClick={() => onViewDetails(p)}
                      className="flex-1 py-1.5 px-2 bg-[#101B3D] text-[#FFF9EF] rounded-xl text-xs font-bold hover:bg-[#17264F] transition flex items-center justify-center gap-1 cursor-pointer shadow-xs"
                    >
                      <Eye className="w-3 h-3" />
                      <span>Details</span>
                    </button>

                    {p.officialProductUrl && (
                      <a
                        href={p.officialProductUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="py-1.5 px-2 bg-[#3559C7] text-white rounded-xl text-xs font-bold hover:bg-[#2e4eb2] transition flex items-center gap-1 cursor-pointer shadow-xs"
                        title="Buy at Official Store"
                      >
                        <ShoppingBag className="w-3 h-3" />
                        <ExternalLink className="w-2.5 h-2.5" />
                      </a>
                    )}

                    <button
                      onClick={() => onAddToCompare(p)}
                      className={`p-1.5 rounded-xl border text-xs font-semibold transition cursor-pointer ${
                        isCompared ? 'bg-[#3559C7] border-[#3559C7] text-white' : 'glass-pill text-[#18213A] hover:bg-white'
                      }`}
                      title="Compare"
                    >
                      <Scale className="w-3.5 h-3.5" />
                    </button>
                    <button
                      onClick={() => onToggleSave(p.id)}
                      className={`p-1.5 rounded-lg border text-xs font-semibold ${
                        isSaved ? 'bg-[#D6AD60] text-[#101B3D]' : 'border-[#E6E0D5] hover:bg-[#F7F1E6]'
                      }`}
                      title="Save"
                    >
                      <Bookmark className={`w-3.5 h-3.5 ${isSaved ? 'fill-current' : ''}`} />
                    </button>
                  </div>
                </div>
              );
            })}
          </div>

          {/* Specification Compromises */}
          {result?.specification_compromises?.length > 0 && (
            <div className="glass-panel p-6 rounded-2xl space-y-3">
              <h3 className="text-sm font-bold text-[#101B3D] flex items-center gap-2">
                <TrendingDown className="w-4 h-4 text-[#C34D4D]" />
                Direct Specification Compromises
              </h3>
              <ul className="text-xs text-[#18213A] space-y-2">
                {result.specification_compromises.map((comp, idx) => (
                  <li key={idx} className="flex items-start gap-2 bg-[#F7F1E6] p-3 rounded-xl border border-[#E6E0D5]">
                    <span className="text-[#3559C7] font-bold">•</span>
                    <span>{comp}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

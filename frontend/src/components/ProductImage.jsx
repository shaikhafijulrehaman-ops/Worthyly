import React, { useState } from 'react';
import {
  Smartphone,
  Laptop,
  Tv,
  Box,
  Disc,
  Wind,
  Tablet,
  Headphones,
  Dumbbell,
  Flame,
  BookOpen,
  Newspaper,
  ShieldCheck,
  Home,
  Armchair,
  Footprints,
  Sparkles
} from 'lucide-react';
import { normalizeCategoryId, getCanonicalCategory } from '../services/categoryRegistry';

const CATEGORY_FALLBACK_ICONS = {
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
  home_kitchen: Home,
  furniture: Armchair,
  footwear: Footprints,
  electronics: Laptop
};

/**
 * Robust product image component with:
 * - Lazy loaded decoding
 * - Prevents layout shift (CLS)
 * - Shimmer loading state
 * - Automatic neutral fallback if image fails, 404s, or is missing
 * - Verified category SVG & icon mapping
 */
export default function ProductImage({
  src,
  alt = 'Product image',
  category = 'smartphones',
  brand = '',
  className = 'w-full h-full object-cover',
  containerClassName = 'w-full h-full relative overflow-hidden flex items-center justify-center'
}) {
  const [hasError, setHasError] = useState(false);
  const [isLoaded, setIsLoaded] = useState(false);

  const canonicalCat = normalizeCategoryId(category);
  const Icon = CATEGORY_FALLBACK_ICONS[canonicalCat] || Laptop;
  const catObj = getCanonicalCategory(canonicalCat);
  const categoryLabel = catObj?.name || 'Verified Product';

  if (!src || hasError) {
    return (
      <div
        className={`${containerClassName} bg-gradient-to-br from-[#0F172A] via-[#1E293B] to-[#0F172A] border border-white/10 flex flex-col items-center justify-center p-4 select-none`}
        role="img"
        aria-label={`${alt} - ${brand} ${categoryLabel}`}
      >
        <div className="w-12 h-12 rounded-2xl bg-white/10 border border-white/20 shadow-xs flex items-center justify-center text-sky-400 mb-2">
          <Icon className="w-6 h-6 stroke-[1.75]" />
        </div>
        {brand && (
          <span className="text-[11px] font-bold text-white tracking-wide uppercase px-2 py-0.5 rounded-full bg-white/10 border border-white/15 mb-1">
            {brand}
          </span>
        )}
        <span className="text-[10px] font-semibold text-slate-300 text-center max-w-[130px] truncate">
          {categoryLabel}
        </span>
        <div className="flex items-center gap-1 text-[9px] text-emerald-400 font-semibold mt-1.5 opacity-90">
          <ShieldCheck className="w-3 h-3" />
          <span>Verified Specs Pending Image</span>
        </div>
      </div>
    );
  }

  return (
    <div className={containerClassName}>
      {/* Loading Skeleton Shimmer */}
      {!isLoaded && (
        <div className="absolute inset-0 bg-slate-800/50 animate-pulse flex items-center justify-center">
          <Sparkles className="w-5 h-5 text-sky-400/30" />
        </div>
      )}

      {/* Main Image */}
      <img
        src={src}
        alt={alt}
        loading="lazy"
        decoding="async"
        onLoad={() => setIsLoaded(true)}
        onError={() => setHasError(true)}
        className={`${className} transition-opacity duration-300 ${isLoaded ? 'opacity-100' : 'opacity-0'}`}
      />
    </div>
  );
}

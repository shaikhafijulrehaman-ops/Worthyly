import React, { useState } from 'react';
import {
  Laptop,
  Footprints,
  Utensils,
  Armchair,
  Dumbbell,
  GraduationCap,
  Sparkles,
  ShieldCheck
} from 'lucide-react';

const CATEGORY_FALLBACK_ICONS = {
  electronics: Laptop,
  footwear: Footprints,
  home_kitchen: Utensils,
  furniture: Armchair,
  fitness: Dumbbell,
  education: GraduationCap,
};

const CATEGORY_NAMES = {
  electronics: 'Electronics & Computing',
  footwear: 'Footwear & Athletic',
  home_kitchen: 'Home & Kitchen Appliance',
  furniture: 'Ergonomic Furniture',
  fitness: 'Fitness & Health Tech',
  education: 'Student & Academic Essentials',
};

/**
 * Robust, production-grade product image component:
 * - Lazy loaded with async decoding
 * - Prevents layout shift (CLS) with reserved aspect ratio
 * - Handles loading state with soft skeleton shimmer
 * - On failure/404, shows deliberate, elegant fallback with category icon & brand pill
 */
export default function ProductImage({
  src,
  alt = 'Product image',
  category = 'electronics',
  brand = '',
  className = 'w-full h-full object-cover',
  containerClassName = 'w-full h-full relative overflow-hidden flex items-center justify-center'
}) {
  const [hasError, setHasError] = useState(false);
  const [isLoaded, setIsLoaded] = useState(false);

  const Icon = CATEGORY_FALLBACK_ICONS[category] || Laptop;
  const categoryLabel = CATEGORY_NAMES[category] || 'Verified Product';

  if (!src || hasError) {
    return (
      <div
        className={`${containerClassName} bg-gradient-to-br from-[#101B3D]/5 via-[#F7F1E6] to-[#3559C7]/10 border border-[#E6E0D5]/60 flex flex-col items-center justify-center p-4 select-none`}
        role="img"
        aria-label={`${alt} - ${brand} ${categoryLabel}`}
      >
        <div className="w-12 h-12 rounded-2xl bg-white/90 border border-white shadow-xs flex items-center justify-center text-[#3559C7] mb-2">
          <Icon className="w-6 h-6 stroke-[1.75]" />
        </div>
        {brand && (
          <span className="text-[11px] font-bold text-[#101B3D] tracking-wide uppercase px-2 py-0.5 rounded-full bg-white/80 border border-[#E6E0D5]/70 mb-1">
            {brand}
          </span>
        )}
        <span className="text-[10px] font-semibold text-[#69738A] text-center max-w-[130px] truncate">
          {categoryLabel}
        </span>
        <div className="flex items-center gap-1 text-[9px] text-[#23865B] font-semibold mt-1.5 opacity-80">
          <ShieldCheck className="w-3 h-3" />
          <span>Spec-Verified Listing</span>
        </div>
      </div>
    );
  }

  return (
    <div className={containerClassName}>
      {/* Loading Skeleton Shimmer */}
      {!isLoaded && (
        <div className="absolute inset-0 bg-[#F7F1E6] animate-pulse flex items-center justify-center">
          <Sparkles className="w-5 h-5 text-[#3559C7]/30" />
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

import React from 'react';
import { motion } from 'framer-motion';

/**
 * Originkit Neon Border Component
 * Implements a refined royal-blue glow (#3559C7) with a subtle warm-gold (#D6AD60) accent.
 * Follows the Originkit component specification with zero hardcoded API keys and accessible fallback.
 *
 * Used selectively for:
 * - The primary "Find My Best Match" CTA button
 * - The highlighted "Best Overall Match" card
 * - Active AI assistant states
 * - High-value selected interactive elements
 */
export default function NeonBorder({
  children,
  className = '',
  isActive = true,
  variant = 'card', // 'card' | 'button' | 'pill'
  glowColor = 'blue-gold', // 'blue-gold' | 'royal-blue' | 'gold'
  onClick,
  ...props
}) {
  if (variant === 'button') {
    return (
      <button
        onClick={onClick}
        className={`relative group inline-flex items-center justify-center p-[2px] rounded-xl font-medium overflow-hidden transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-[#3559C7] focus:ring-offset-2 ${className}`}
        {...props}
      >
        {/* Animated Neon Border Layer */}
        {isActive && (
          <span
            className="absolute inset-0 bg-gradient-to-r from-[#3559C7] via-[#D6AD60] to-[#3559C7] rounded-xl animate-[spin_4s_linear_infinite] opacity-90 group-hover:opacity-100 blur-[2px] transition-opacity"
            aria-hidden="true"
          />
        )}
        
        {/* Button Content Surface */}
        <span className="relative z-10 w-full h-full px-6 py-3.5 rounded-[10px] bg-gradient-to-br from-[#101B3D] via-[#17264F] to-[#101B3D] text-[#FFF9EF] font-semibold flex items-center justify-center gap-2.5 transition-all duration-200 group-hover:bg-opacity-90 shadow-md">
          {children}
        </span>
      </button>
    );
  }

  if (variant === 'pill') {
    return (
      <div className={`relative p-[1.5px] rounded-full inline-block ${className}`} {...props}>
        {isActive && (
          <div className="absolute inset-0 rounded-full bg-gradient-to-r from-[#3559C7] via-[#D6AD60] to-[#3559C7] animate-pulse blur-[1px]" />
        )}
        <div className="relative z-10 px-3 py-1 rounded-full bg-[#101B3D] text-[#FFF9EF] text-xs font-semibold">
          {children}
        </div>
      </div>
    );
  }

  // Default: 'card' wrapper
  return (
    <div
      className={`relative rounded-2xl transition-all duration-300 ${
        isActive ? 'neon-border-active' : ''
      } ${className}`}
      style={{
        border: isActive ? '2px solid rgba(214, 173, 96, 0.85)' : '1px solid rgba(255, 255, 255, 0.82)',
        background: 'rgba(255, 255, 255, 0.68)',
        backdropFilter: 'blur(22px)',
        WebkitBackdropFilter: 'blur(22px)',
      }}
      {...props}
    >
      {/* Ambient Neon Back-Glow */}
      {isActive && (
        <div
          className="absolute -inset-[3px] -z-10 rounded-2xl bg-gradient-to-br from-[#3559C7]/30 via-[#D6AD60]/20 to-[#3559C7]/25 blur-md pointer-events-none"
          aria-hidden="true"
        />
      )}

      {/* Card Content */}
      <div className="relative z-10 w-full h-full rounded-2xl">
        {children}
      </div>
    </div>
  );
}

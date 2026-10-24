import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Scale, X, ArrowRight } from 'lucide-react';

export default function CompareTray({
  comparedProducts,
  onRemoveFromCompare,
  onNavigateToCompare,
  onClearCompare
}) {
  if (!comparedProducts || comparedProducts.length === 0) return null;

  return (
    <AnimatePresence>
      <motion.div
        initial={{ y: 80, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        exit={{ y: 80, opacity: 0 }}
        transition={{ type: 'spring', damping: 25, stiffness: 300 }}
        className="fixed bottom-6 left-1/2 -translate-x-1/2 z-40 w-11/12 max-w-2xl glass-modal text-[#18213A] p-3 rounded-2xl shadow-2xl border border-white/95 flex items-center justify-between gap-4"
      >
        <div className="flex items-center gap-3 overflow-x-auto py-1">
          <div className="flex items-center gap-1.5 text-xs font-bold text-[#3559C7] shrink-0 pl-1">
            <Scale className="w-4 h-4 text-[#3559C7]" />
            <span>Comparing ({comparedProducts.length}/3):</span>
          </div>

          <div className="flex items-center gap-2">
            {comparedProducts.map((p) => (
              <div
                key={p.id}
                className="flex items-center gap-1.5 glass-pill border border-white/80 px-2.5 py-1 rounded-xl text-xs font-medium text-[#18213A] shrink-0 shadow-2xs"
              >
                <span className="truncate max-w-[120px] font-semibold">{p.name}</span>
                <button
                  onClick={() => onRemoveFromCompare(p.id)}
                  className="hover:text-red-500 p-0.5 rounded transition cursor-pointer"
                  title="Remove"
                >
                  <X className="w-3.5 h-3.5" />
                </button>
              </div>
            ))}
          </div>
        </div>

        <div className="flex items-center gap-2 shrink-0">
          <button
            onClick={onClearCompare}
            className="text-xs text-[#69738A] hover:text-[#18213A] px-2 py-1 transition cursor-pointer font-medium"
          >
            Clear
          </button>

          <button
            onClick={onNavigateToCompare}
            disabled={comparedProducts.length < 2}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition shadow-sm cursor-pointer ${
              comparedProducts.length >= 2
                ? 'bg-[#3559C7] hover:bg-[#2c4cb0] text-white'
                : 'bg-black/5 text-[#69738A]/50 cursor-not-allowed'
            }`}
          >
            <span>Compare Now</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>
      </motion.div>
    </AnimatePresence>
  );
}

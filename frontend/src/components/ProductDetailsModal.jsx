import React, { useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  X,
  ExternalLink,
  ShieldCheck,
  CheckCircle2,
  AlertTriangle,
  Bookmark,
  Scale,
  Star,
  Calendar,
  Tag,
  ShoppingBag,
  Zap
} from 'lucide-react';
import { formatINR } from '../utils/currency';
import ProductImage from './ProductImage';

export default function ProductDetailsModal({
  product,
  isOpen,
  onClose,
  onAddToCompare,
  isCompared,
  onToggleSave,
  isSaved
}) {
  useEffect(() => {
    if (!isOpen) return;
    const handleKeyDown = (e) => {
      if (e.key === 'Escape') {
        onClose();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose]);

  if (!isOpen || !product) return null;

  return (
    <AnimatePresence>
      <div 
        className="fixed inset-0 z-50 overflow-y-auto bg-[#101B3D]/35 backdrop-blur-md flex items-center justify-center p-4"
        onClick={onClose}
      >
        <motion.div
          initial={{ opacity: 0, scale: 0.95, y: 15 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 15 }}
          transition={{ duration: 0.2 }}
          className="relative w-full max-w-3xl glass-modal rounded-3xl overflow-hidden my-8"
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header Bar */}
          <div className="bg-white/80 backdrop-blur-md text-[#18213A] px-6 py-4 flex items-center justify-between border-b border-white/80">
            <div className="flex items-center gap-2">
              <span className="text-xs uppercase tracking-wider font-extrabold bg-[#3559C7] text-white px-3 py-1 rounded-full shadow-xs">
                {product.brand}
              </span>
              <span className="text-xs text-[#23865B] font-semibold flex items-center gap-1 bg-[#23865B]/10 px-2.5 py-0.5 rounded-full border border-[#23865B]/20">
                <ShieldCheck className="w-3.5 h-3.5" /> Verified Indian Market Data
              </span>
            </div>
            <button
              onClick={onClose}
              className="text-[#69738A] hover:text-[#18213A] p-1.5 rounded-xl hover:bg-black/5 transition cursor-pointer"
              aria-label="Close modal"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          <div className="p-6 md:p-8 max-h-[75vh] overflow-y-auto space-y-6">
            {/* Top Product Hero */}
            <div className="grid grid-cols-1 md:grid-cols-12 gap-6 items-start">
              <div className="md:col-span-5 rounded-2xl overflow-hidden glass-panel-subtle border border-white/80 aspect-4/3 flex items-center justify-center shadow-inner">
                <ProductImage
                  src={product.imageUrl}
                  alt={product.name}
                  category={product.category}
                  brand={product.brand}
                  className="w-full h-full object-cover"
                />
              </div>

              <div className="md:col-span-7 space-y-3">
                <h2 className="text-2xl font-bold text-[#18213A] tracking-tight">
                  {product.name}
                </h2>

                <div className="flex items-center gap-3">
                  <span className="text-3xl font-black text-[#101B3D]">
                    {formatINR(product.price)}
                  </span>
                  <div className="flex items-center text-amber-500 font-semibold text-xs bg-amber-50 px-2.5 py-1 rounded-lg border border-amber-200">
                    <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500 mr-1" />
                    {product.rating} ({product.reviewCount} reviews)
                  </div>
                </div>

                <div className="text-xs text-[#69738A] space-y-1 glass-panel-subtle p-3 rounded-xl border border-white/80">
                  <p className="flex items-center gap-1.5 font-medium">
                    <Calendar className="w-3.5 h-3.5 text-[#3559C7]" />
                    Price Verified: <span className="text-[#18213A]">{new Date(product.lastVerified || product.lastVerifiedAt).toLocaleDateString()}</span>
                  </p>
                  <p className="flex items-center gap-1.5 font-medium">
                    <Tag className="w-3.5 h-3.5 text-[#3559C7]" />
                    Source: <span className="text-[#18213A]">{product.source}</span>
                  </p>
                </div>

                {/* Primary Official Buying Action & Tools */}
                <div className="flex flex-wrap items-center gap-2.5 pt-2">
                  {product.officialProductUrl ? (
                    <a
                      href={product.officialProductUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex-1 py-2.5 px-4 rounded-xl text-xs font-bold bg-[#3559C7] hover:bg-[#2b4aa6] text-white transition flex items-center justify-center gap-2 shadow-xs cursor-pointer"
                    >
                      <ShoppingBag className="w-4 h-4" />
                      <span>Buy at Official {product.brand} Store</span>
                      <ExternalLink className="w-3.5 h-3.5" />
                    </a>
                  ) : (
                    <span className="text-xs text-[#69738A] italic px-3 py-2 glass-panel-subtle rounded-xl border border-white/80">
                      Official buying link currently unavailable
                    </span>
                  )}

                  <button
                    onClick={() => onAddToCompare(product)}
                    className={`flex items-center gap-1.5 px-3.5 py-2.5 rounded-xl text-xs font-semibold transition cursor-pointer ${
                      isCompared
                        ? 'bg-[#101B3D] text-[#FFF9EF]'
                        : 'glass-pill text-[#18213A] hover:bg-white/80 border border-white/80'
                    }`}
                  >
                    <Scale className="w-4 h-4" />
                    <span>{isCompared ? 'In Compare' : 'Compare'}</span>
                  </button>

                  <button
                    onClick={() => onToggleSave(product.id)}
                    className={`p-2.5 rounded-xl text-xs font-semibold transition cursor-pointer ${
                      isSaved
                        ? 'bg-[#D6AD60] border border-[#D6AD60] text-[#101B3D]'
                        : 'glass-pill border border-white/80 hover:bg-white/80 text-[#18213A]'
                    }`}
                    title={isSaved ? 'Saved' : 'Save'}
                  >
                    <Bookmark className={`w-4 h-4 ${isSaved ? 'fill-current' : ''}`} />
                  </button>
                </div>
              </div>
            </div>

            {/* Retailer Offers Matrix (if multiple offers exist) */}
            {product.retailerOffers && product.retailerOffers.length > 0 && (
              <div className="glass-panel-subtle p-4 rounded-2xl border border-white/80 space-y-2">
                <span className="text-xs font-bold uppercase tracking-wider text-[#101B3D] flex items-center gap-1.5">
                  <ShoppingBag className="w-3.5 h-3.5 text-[#3559C7]" /> Verified Retailer Availability
                </span>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1 text-xs">
                  {product.retailerOffers.map((offer, idx) => (
                    <a
                      key={idx}
                      href={offer.productUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="p-3 glass-panel rounded-xl border border-white/80 hover:border-[#3559C7] transition flex items-center justify-between group cursor-pointer"
                    >
                      <div>
                        <span className="font-bold text-[#18213A] block group-hover:text-[#3559C7]">
                          {offer.retailerName}
                        </span>
                        <span className="text-[11px] text-[#23865B] font-semibold">{offer.availability}</span>
                      </div>
                      <div className="text-right">
                        <span className="font-extrabold text-[#101B3D] block">{formatINR(offer.price)}</span>
                        <span className="text-[10px] text-[#3559C7] flex items-center gap-1 justify-end font-medium">
                          Visit Offer <ExternalLink className="w-2.5 h-2.5" />
                        </span>
                      </div>
                    </a>
                  ))}
                </div>
              </div>
            )}

            {/* Key Advantages & Disadvantages */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="bg-[#23865B]/10 backdrop-blur-xs border border-[#23865B]/20 rounded-2xl p-4">
                <h4 className="text-xs font-bold text-[#23865B] flex items-center gap-1.5 mb-2">
                  <CheckCircle2 className="w-4 h-4" /> Key Advantages
                </h4>
                <ul className="text-xs text-[#18213A] space-y-1.5 list-disc list-inside">
                  {product.pros?.map((pro, idx) => (
                    <li key={idx} className="leading-relaxed">{pro}</li>
                  ))}
                </ul>
              </div>

              <div className="bg-[#C34D4D]/10 backdrop-blur-xs border border-[#C34D4D]/20 rounded-2xl p-4">
                <h4 className="text-xs font-bold text-[#C34D4D] flex items-center gap-1.5 mb-2">
                  <AlertTriangle className="w-4 h-4" /> Important Disadvantages
                </h4>
                <ul className="text-xs text-[#18213A] space-y-1.5 list-disc list-inside">
                  {product.cons?.map((con, idx) => (
                    <li key={idx} className="leading-relaxed">{con}</li>
                  ))}
                </ul>
              </div>
            </div>

            {/* Specifications Matrix */}
            <div className="glass-panel border border-white/80 rounded-2xl overflow-hidden shadow-xs">
              <div className="glass-panel-subtle px-4 py-2.5 border-b border-white/80 text-xs font-bold text-[#101B3D] uppercase tracking-wider">
                Verified Hardware Specifications
              </div>
              <div className="divide-y divide-white/80">
                {Object.entries(product.specs || {}).map(([key, val]) => (
                  <div key={key} className="grid grid-cols-3 px-4 py-2.5 text-xs">
                    <span className="font-semibold text-[#69738A] capitalize">
                      {key.replace(/([A-Z])/g, ' $1').replace('_', ' ')}
                    </span>
                    <span className="col-span-2 text-[#18213A] font-medium">
                      {String(val)}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Footer Bar */}
          <div className="bg-white/70 backdrop-blur-md px-6 py-4 border-t border-white/80 flex items-center justify-between">
            <span className="text-[11px] text-[#69738A]">
              Prices periodically verified in Indian Rupees (INR).
            </span>
            <button
              onClick={onClose}
              className="px-6 py-2.5 bg-[#101B3D] text-[#FFF9EF] text-xs font-bold rounded-xl hover:bg-[#17264F] transition cursor-pointer shadow-sm"
            >
              Done
            </button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}

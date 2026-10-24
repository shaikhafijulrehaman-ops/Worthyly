import React, { useEffect } from 'react';
import { motion } from 'framer-motion';
import confetti from 'canvas-confetti';
import {
  Trophy,
  Star,
  CheckCircle2,
  AlertTriangle,
  Scale,
  Bookmark,
  Eye,
  Calendar,
  ExternalLink,
  RotateCcw,
  ShieldCheck,
  Zap,
  Info,
  ShoppingBag
} from 'lucide-react';
import NeonBorder from '../components/NeonBorder';
import ProductImage from '../components/ProductImage';
import { formatINR } from '../utils/currency';

export default function PageRecommendations({
  result,
  isLoading,
  onResetRequirements,
  onViewDetails,
  onAddToCompare,
  comparedIds = [],
  onToggleSave,
  savedIds = []
}) {
  useEffect(() => {
    if (result?.recommendations?.length > 0) {
      try {
        confetti({
          particleCount: 50,
          spread: 60,
          origin: { y: 0.6 }
        });
      } catch (e) {
        // ignore
      }
    }
  }, [result]);

  if (isLoading) {
    return (
      <div className="py-20 flex flex-col items-center justify-center space-y-3">
        <div className="w-10 h-10 rounded-full border-3 border-[#3559C7] border-t-transparent animate-spin" />
        <h3 className="text-base font-bold text-[#18213A]">
          Evaluating Product Specifications...
        </h3>
        <p className="text-xs text-[#69738A]">
          Filtering strict budget constraints in INR and calculating deterministic match scores.
        </p>
      </div>
    );
  }

  if (!result || result.recommendations?.length === 0) {
    return (
      <div className="max-w-md mx-auto glass-panel p-6 rounded-2xl text-center space-y-4 my-6">
        <div className="w-12 h-12 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center mx-auto">
          <Info className="w-6 h-6" />
        </div>
        <div className="space-y-1.5">
          <h2 className="text-xl font-bold text-[#18213A]">
            No Exact Matches Within Your Criteria
          </h2>
          <p className="text-xs text-[#69738A] leading-relaxed">
            {result?.message || 'WORTHLY avoids fabricating unverified items. No product in our verified dataset met all your strict criteria.'}
          </p>
        </div>
        <button
          onClick={onResetRequirements}
          className="px-5 py-2.5 rounded-xl bg-[#101B3D] text-[#FFF9EF] font-bold text-xs hover:bg-[#17264F] transition flex items-center gap-2 mx-auto"
        >
          <RotateCcw className="w-3.5 h-3.5" />
          <span>Adjust Budget & Criteria</span>
        </button>
      </div>
    );
  }

  const recommendations = result.recommendations;

  return (
    <div className="space-y-6 pb-12">
      {/* Header Banner */}
      <div className="glass-panel p-5 sm:p-6 rounded-2xl flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7] bg-[#3559C7]/10 px-2.5 py-0.5 rounded-full">
              Transparent Recommendation Analysis
            </span>
            <span className="text-xs text-[#69738A] flex items-center gap-1 font-medium">
              <ShieldCheck className="w-3.5 h-3.5 text-[#23865B]" /> Verified Indian Hardware Data
            </span>
          </div>
          <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
            Your Best 3 Matches
          </h1>
          <p className="text-xs md:text-sm text-[#69738A] max-w-2xl">
            {result.message}
          </p>
        </div>

        <button
          onClick={onResetRequirements}
          className="shrink-0 flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-white/70 hover:bg-white text-[#18213A] transition border border-white/80 shadow-xs"
        >
          <RotateCcw className="w-3.5 h-3.5" />
          <span>Edit Requirements</span>
        </button>
      </div>

      {/* 3 Recommendations Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-stretch">
        {recommendations.map((rec, index) => {
          const product = rec.product;
          const isBestOverall = rec.role === 'BEST OVERALL MATCH';
          const isCompared = comparedIds.includes(product.id);
          const isSaved = savedIds.includes(product.id);

          const CardContent = (
            <div className="h-full flex flex-col justify-between p-5 sm:p-6 glass-panel rounded-2xl space-y-4 border border-white/80">
              {/* Role Header Badge */}
              <div className="space-y-1.5">
                <div className="flex items-center justify-between">
                  <div
                    className={`text-xs font-black px-3 py-1 rounded-full uppercase tracking-wider flex items-center gap-1.5 ${
                      isBestOverall
                        ? 'bg-[#101B3D] text-[#D6AD60]'
                        : rec.role === 'BEST VALUE'
                        ? 'bg-[#23865B]/15 text-[#23865B]'
                        : 'bg-[#3559C7]/15 text-[#3559C7]'
                    }`}
                  >
                    {isBestOverall && <Trophy className="w-3.5 h-3.5 text-[#D6AD60]" />}
                    {rec.role}
                  </div>

                  {/* Match Score Gauge */}
                  <div className="flex items-center gap-1 glass-pill px-2.5 py-1 rounded-lg">
                    <span className="text-[11px] text-[#69738A] font-semibold">Match:</span>
                    <span className="text-sm font-extrabold text-[#3559C7]">
                      {rec.match_score}%
                    </span>
                  </div>
                </div>

                <p className="text-xs text-[#69738A] font-medium italic">
                  "{rec.role_tagline}"
                </p>
              </div>

              {/* Product Visual & Pricing */}
              <div className="space-y-3">
                <div className="aspect-16/10 rounded-xl overflow-hidden bg-white/40 border border-white/70 relative group">
                  <ProductImage
                    src={product.imageUrl}
                    alt={product.name}
                    category={product.category}
                    brand={product.brand}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                  <span className="absolute top-2.5 left-2.5 bg-[#101B3D]/90 text-white text-[10px] font-bold px-2 py-0.5 rounded-md">
                    {product.brand}
                  </span>
                </div>

                <div>
                  <h3 className="font-bold text-lg text-[#18213A] line-clamp-1">
                    {product.name}
                  </h3>
                  <div className="flex items-baseline justify-between pt-1">
                    <span className="text-2xl font-black text-[#101B3D]">
                      {formatINR(product.price)}
                    </span>
                    <div className="flex items-center text-xs font-bold text-amber-500">
                      <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500 mr-1" />
                      {product.rating} ({product.reviewCount})
                    </div>
                  </div>
                </div>

                <div className="text-[11px] text-[#69738A] flex items-center gap-1 glass-badge px-2.5 py-1.5 rounded-lg">
                  <Calendar className="w-3 h-3 text-[#3559C7]" />
                  <span>Verified: {new Date(product.lastVerified || product.lastVerifiedAt).toLocaleDateString()}</span>
                </div>
              </div>

              {/* Why This Product Is Recommended */}
              <div className="space-y-2 bg-white/60 backdrop-blur-md p-3.5 rounded-xl border border-white/80">
                <h4 className="text-xs font-bold uppercase tracking-wider text-[#101B3D] flex items-center gap-1">
                  <Zap className="w-3.5 h-3.5 text-[#D6AD60]" /> Why This Is Recommended
                </h4>
                <ul className="text-xs text-[#18213A] space-y-1.5">
                  {rec.reasons?.map((reason, rIdx) => (
                    <li key={rIdx} className="flex items-start gap-1.5 leading-snug">
                      <span className="text-[#3559C7] font-bold shrink-0">✓</span>
                      <span>{reason}</span>
                    </li>
                  ))}
                </ul>
              </div>

              {/* Top Pros & Cons Snippets */}
              <div className="grid grid-cols-2 gap-2 text-[11px]">
                <div className="bg-[#23865B]/10 p-2.5 rounded-lg border border-[#23865B]/20">
                  <span className="font-bold text-[#23865B] flex items-center gap-1 mb-1">
                    <CheckCircle2 className="w-3 h-3" /> Key Advantage
                  </span>
                  <p className="text-[#18213A] line-clamp-2 leading-tight">
                    {product.pros?.[0]}
                  </p>
                </div>

                <div className="bg-[#C34D4D]/10 p-2.5 rounded-lg border border-[#C34D4D]/20">
                  <span className="font-bold text-[#C34D4D] flex items-center gap-1 mb-1">
                    <AlertTriangle className="w-3 h-3" /> Trade-Off
                  </span>
                  <p className="text-[#18213A] line-clamp-2 leading-tight">
                    {product.cons?.[0]}
                  </p>
                </div>
              </div>

              {/* Action Buttons: Details, Buy Now, Compare, Save */}
              <div className="pt-2 border-t border-white/80 flex items-center justify-between gap-2">
                <button
                  onClick={() => onViewDetails(product)}
                  className="flex-1 py-2 px-3 rounded-xl text-xs font-bold bg-[#101B3D] hover:bg-[#17264F] text-[#FFF9EF] transition flex items-center justify-center gap-1"
                >
                  <Eye className="w-3.5 h-3.5" />
                  <span>Details</span>
                </button>

                {product.officialProductUrl && (
                  <a
                    href={product.officialProductUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="py-2 px-3 rounded-xl text-xs font-bold bg-[#3559C7] hover:bg-[#2b4aa6] text-white transition flex items-center gap-1"
                    title="Buy at Official Store"
                  >
                    <ShoppingBag className="w-3.5 h-3.5" />
                    <span>Buy</span>
                    <ExternalLink className="w-2.5 h-2.5" />
                  </a>
                )}

                <button
                  onClick={() => onAddToCompare(product)}
                  className={`p-2 rounded-xl border text-xs font-semibold transition ${
                    isCompared
                      ? 'bg-[#3559C7] border-[#3559C7] text-white'
                      : 'border-[#E6E0D5] hover:bg-[#F7F1E6] text-[#18213A]'
                  }`}
                  title={isCompared ? 'Remove from Comparison' : 'Add to Comparison'}
                >
                  <Scale className="w-4 h-4" />
                </button>

                <button
                  onClick={() => onToggleSave(product.id)}
                  className={`p-2 rounded-xl border text-xs font-semibold transition ${
                    isSaved
                      ? 'bg-[#D6AD60] border-[#D6AD60] text-[#101B3D]'
                      : 'border-[#E6E0D5] hover:bg-[#F7F1E6] text-[#18213A]'
                  }`}
                  title={isSaved ? 'Remove from Saved' : 'Save Product'}
                >
                  <Bookmark className={`w-4 h-4 ${isSaved ? 'fill-current' : ''}`} />
                </button>
              </div>
            </div>
          );

          if (isBestOverall) {
            return (
              <motion.div
                key={product.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="h-full"
              >
                <NeonBorder
                  variant="card"
                  isActive={true}
                  className="h-full shadow-xl"
                >
                  {CardContent}
                </NeonBorder>
              </motion.div>
            );
          }

          return (
            <motion.div
              key={product.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3, delay: index * 0.1 }}
              className="h-full glass-card-hover rounded-2xl transition"
            >
              {CardContent}
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}

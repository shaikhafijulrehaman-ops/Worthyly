import React, { useState } from 'react';
import { motion } from 'framer-motion';
import ProductImage from '../components/ProductImage';
import {
  Bookmark,
  Trash2,
  Scale,
  Eye,
  Star,
  ExternalLink,
  Calendar,
  Layers,
  ArrowRight,
  ShieldCheck,
  RotateCcw
} from 'lucide-react';

export default function PageSavedProducts({
  savedItems = [],
  savedComparisons = [],
  onRemoveSavedProduct,
  onViewDetails,
  onAddToCompare,
  comparedIds = [],
  onReopenComparison,
  onDeleteComparison,
  onNavigateToExplorer
}) {
  const [activeTab, setActiveTab] = useState('products'); // 'products' | 'comparisons'

  return (
    <div className="space-y-8 pb-16">
      {/* Header */}
      <div className="bg-white p-6 md:p-8 rounded-2xl border border-[#E6E0D5] shadow-xs flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
            Your Curated Shortlist
          </span>
          <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
            Saved Products & Comparisons
          </h1>
          <p className="text-xs md:text-sm text-[#69738A]">
            Persistently bookmarked products and stored side-by-side shootouts.
          </p>
        </div>

        {/* Tab switch */}
        <div className="flex items-center gap-2 bg-[#F7F1E6] p-1 rounded-xl self-start md:self-auto border border-[#E6E0D5]">
          <button
            onClick={() => setActiveTab('products')}
            className={`px-4 py-2 rounded-lg text-xs font-bold transition ${
              activeTab === 'products'
                ? 'bg-[#101B3D] text-[#FFF9EF] shadow-xs'
                : 'text-[#69738A] hover:text-[#18213A]'
            }`}
          >
            Saved Products ({savedItems.length})
          </button>
          <button
            onClick={() => setActiveTab('comparisons')}
            className={`px-4 py-2 rounded-lg text-xs font-bold transition ${
              activeTab === 'comparisons'
                ? 'bg-[#101B3D] text-[#FFF9EF] shadow-xs'
                : 'text-[#69738A] hover:text-[#18213A]'
            }`}
          >
            Saved Comparisons ({savedComparisons.length})
          </button>
        </div>
      </div>

      {/* Storage Note */}
      <div className="bg-[#FFF9EF] p-4 rounded-xl border border-[#E6E0D5] flex items-center gap-2 text-xs text-[#69738A]">
        <ShieldCheck className="w-4 h-4 text-[#23865B] shrink-0" />
        <span>
          Sync status: Connected to persistent storage with local fallback. Your saved items remain intact across sessions.
        </span>
      </div>

      {/* TAB 1: Saved Products */}
      {activeTab === 'products' && (
        <div className="space-y-4">
          {savedItems.length === 0 ? (
            <div className="bg-white p-12 rounded-2xl border border-[#E6E0D5] text-center space-y-4">
              <Bookmark className="w-10 h-10 text-gray-300 mx-auto" />
              <h3 className="text-base font-bold text-[#18213A]">
                No Saved Products Yet
              </h3>
              <p className="text-xs text-[#69738A]">
                Click the bookmark icon on any product in the Explorer or Recommendations to add it here.
              </p>
              <button
                onClick={onNavigateToExplorer}
                className="px-5 py-2.5 rounded-xl bg-[#101B3D] text-[#FFF9EF] text-xs font-bold hover:bg-[#17264F] transition"
              >
                Browse Catalog
              </button>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {savedItems.map((item) => {
                const p = item.product;
                if (!p) return null;
                const isCompared = comparedIds.includes(p.id);

                return (
                  <motion.div
                    key={p.id}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="bg-white rounded-2xl border border-[#E6E0D5] shadow-xs p-5 flex flex-col justify-between space-y-4"
                  >
                    <div className="space-y-3">
                      <div className="aspect-16/10 rounded-xl overflow-hidden bg-[#F7F1E6] border border-[#E6E0D5]">
                        <ProductImage
                          src={p.imageUrl}
                          alt={p.name}
                          category={p.category}
                          brand={p.brand}
                          className="w-full h-full object-cover"
                        />
                      </div>

                      <div className="flex items-center justify-between">
                        <span className="text-[10px] font-bold uppercase text-[#3559C7] bg-[#3559C7]/10 px-2 py-0.5 rounded">
                          {p.brand}
                        </span>
                        <div className="flex items-center text-xs font-bold text-amber-500">
                          <Star className="w-3.5 h-3.5 fill-amber-400 mr-1" />
                          {p.rating}
                        </div>
                      </div>

                      <h4 className="font-bold text-base text-[#18213A] line-clamp-1">{p.name}</h4>

                      <div className="text-xl font-black text-[#101B3D]">
                        ${p.price.toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </div>

                      <div className="text-[11px] text-[#69738A] flex items-center gap-1">
                        <Calendar className="w-3 h-3 text-[#3559C7]" />
                        <span>Saved on {new Date(item.savedAt).toLocaleDateString()}</span>
                      </div>
                    </div>

                    <div className="pt-3 border-t border-[#E6E0D5] flex items-center justify-between gap-2">
                      <button
                        onClick={() => onViewDetails(p)}
                        className="flex-1 py-2 px-3 bg-[#101B3D] text-[#FFF9EF] rounded-lg text-xs font-bold hover:bg-[#17264F] transition flex items-center justify-center gap-1.5"
                      >
                        <Eye className="w-3.5 h-3.5" />
                        <span>Details</span>
                      </button>

                      <button
                        onClick={() => onAddToCompare(p)}
                        className={`p-2 rounded-lg border text-xs font-semibold ${
                          isCompared ? 'bg-[#3559C7] text-white' : 'border-[#E6E0D5] hover:bg-[#F7F1E6]'
                        }`}
                        title="Compare"
                      >
                        <Scale className="w-3.5 h-3.5" />
                      </button>

                      <button
                        onClick={() => onRemoveSavedProduct(p.id)}
                        className="p-2 rounded-lg border border-red-200 text-[#C34D4D] hover:bg-red-50 transition"
                        title="Remove from saved"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </motion.div>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* TAB 2: Saved Comparisons */}
      {activeTab === 'comparisons' && (
        <div className="space-y-4">
          {savedComparisons.length === 0 ? (
            <div className="bg-white p-12 rounded-2xl border border-[#E6E0D5] text-center space-y-4">
              <Scale className="w-10 h-10 text-gray-300 mx-auto" />
              <h3 className="text-base font-bold text-[#18213A]">
                No Saved Comparisons Yet
              </h3>
              <p className="text-xs text-[#69738A]">
                When comparing 2 or 3 products, click "Save Comparison" to record your shootout.
              </p>
            </div>
          ) : (
            <div className="space-y-4">
              {savedComparisons.map((comp) => (
                <div
                  key={comp.id}
                  className="bg-white p-6 rounded-2xl border border-[#E6E0D5] shadow-xs flex flex-col md:flex-row md:items-center justify-between gap-4"
                >
                  <div className="space-y-2">
                    <div className="flex items-center gap-2">
                      <h3 className="font-bold text-base text-[#18213A]">
                        {comp.title}
                      </h3>
                      <span className="text-[10px] text-[#69738A] bg-[#F7F1E6] px-2 py-0.5 rounded">
                        {new Date(comp.createdAt).toLocaleDateString()}
                      </span>
                    </div>

                    <p className="text-xs text-[#69738A]">
                      {comp.notes || 'Custom product comparison'}
                    </p>

                    {/* Thumbnails */}
                    <div className="flex items-center gap-2 pt-1">
                      {comp.products?.map((p) => (
                        <div
                          key={p.id}
                          className="flex items-center gap-2 bg-[#FFF9EF] px-3 py-1 rounded-lg border border-[#E6E0D5] text-xs font-semibold text-[#18213A]"
                        >
                          <span>{p.name}</span>
                          <span className="text-[#3559C7]">${p.price}</span>
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="flex items-center gap-2 shrink-0">
                    <button
                      onClick={() => onReopenComparison(comp.products)}
                      className="px-4 py-2 bg-[#3559C7] hover:bg-[#2c4cb0] text-white rounded-xl text-xs font-bold transition flex items-center gap-1.5"
                    >
                      <RotateCcw className="w-3.5 h-3.5" />
                      <span>Reopen Shootout</span>
                    </button>

                    <button
                      onClick={() => onDeleteComparison(comp.id)}
                      className="p-2 border border-red-200 text-[#C34D4D] hover:bg-red-50 rounded-xl transition"
                      title="Delete saved shootout"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

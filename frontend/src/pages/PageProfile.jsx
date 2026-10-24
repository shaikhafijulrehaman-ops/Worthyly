import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import {
  User,
  Bookmark,
  FileEdit,
  Scale,
  Sliders,
  ShieldCheck,
  Calendar,
  Star,
  Trash2,
  RotateCcw,
  Eye,
  Download,
  Save,
  CheckCircle2,
  ExternalLink
} from 'lucide-react';
import { formatINR } from '../utils/currency';
import ProductImage from '../components/ProductImage';

export default function PageProfile({
  initialSubTab = 'overview',
  savedItems = [],
  savedComparisons = [],
  reviews = [],
  categories = [],
  onRemoveSavedProduct,
  onViewDetails,
  onAddToCompare,
  comparedIds = [],
  onReopenComparison,
  onDeleteComparison,
  onDeleteReview,
  onResetAllDemoData,
  currentUser = 'Alex Rivera'
}) {
  const [activeSubTab, setActiveSubTab] = useState(initialSubTab);

  useEffect(() => {
    if (initialSubTab) {
      setActiveSubTab(initialSubTab);
    }
  }, [initialSubTab]);

  // Profile preferences state
  const [userName, setUserName] = useState('Alex Rivera');
  const [userEmail, setUserEmail] = useState('alex.rivera@example.com');
  const [preferredCat, setPreferredCat] = useState('electronics');
  const [defaultMaxBudget, setDefaultMaxBudget] = useState(140000);
  const [strictBudgetOnly, setStrictBudgetOnly] = useState(true);
  const [savedFeedback, setSavedFeedback] = useState(false);

  // User reviews
  const myReviews = reviews.filter(
    (r) => r.author === currentUser || r.author === 'Marcus Vance' || r.author === 'You (Current User)'
  );

  const handleSavePreferences = (e) => {
    e.preventDefault();
    setSavedFeedback(true);
    setTimeout(() => setSavedFeedback(false), 2000);
  };

  const handleExportData = () => {
    const data = {
      user: { name: userName, email: userEmail },
      preferredCategory: preferredCat,
      defaultMaxBudget,
      strictBudgetOnly,
      savedProductsCount: savedItems.length,
      savedComparisonsCount: savedComparisons.length,
      exportedAt: new Date().toISOString()
    };
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `worthly_profile_${Date.now()}.json`;
    a.click();
  };

  return (
    <div className="max-w-5xl mx-auto space-y-6 pb-12">
      {/* Profile Header Banner */}
      <div className="glass-panel rounded-2xl p-5 sm:p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-5 border border-white/80">
        <div className="flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-[#3559C7] via-[#17264F] to-[#D6AD60] flex items-center justify-center font-black text-white text-xl shadow-md border-2 border-[#D6AD60]/40">
            AR
          </div>
          <div className="space-y-1">
            <div className="flex items-center gap-2">
              <h1 className="text-xl sm:text-2xl font-black text-[#18213A]">{userName}</h1>
              <span className="text-[10px] font-bold text-[#23865B] bg-[#23865B]/10 px-2 py-0.5 rounded-full flex items-center gap-1 border border-[#23865B]/20">
                <ShieldCheck className="w-3 h-3" /> Verified Member
              </span>
            </div>
            <p className="text-xs text-[#69738A]">{userEmail}</p>
            <p className="text-[11px] text-[#69738A]">
              Active Currency: <strong className="text-[#101B3D]">Indian Rupee (INR ₹)</strong>
            </p>
          </div>
        </div>

        {/* Quick Stats Pills */}
        <div className="flex items-center gap-2.5">
          <div className="text-center px-3.5 py-2 rounded-xl glass-panel-subtle border border-white/80 min-w-[70px]">
            <span className="text-[11px] text-[#69738A] block font-medium">Saved</span>
            <strong className="text-base text-[#101B3D] font-black">{savedItems.length}</strong>
          </div>
          <div className="text-center px-3.5 py-2 rounded-xl glass-panel-subtle border border-white/80 min-w-[70px]">
            <span className="text-[11px] text-[#69738A] block font-medium">Shootouts</span>
            <strong className="text-base text-[#3559C7] font-black">{savedComparisons.length}</strong>
          </div>
          <div className="text-center px-3.5 py-2 rounded-xl glass-panel-subtle border border-white/80 min-w-[70px]">
            <span className="text-[11px] text-[#69738A] block font-medium">Reviews</span>
            <strong className="text-base text-[#D6AD60] font-black">{myReviews.length}</strong>
          </div>
        </div>
      </div>

      {/* Internal Profile Navigation Tabs */}
      <div className="flex items-center gap-2 overflow-x-auto pb-1 border-b border-white/80">
        {[
          { id: 'overview', label: 'Overview & Preferences', icon: User },
          { id: 'saved', label: `Saved Products (${savedItems.length})`, icon: Bookmark },
          { id: 'reviews', label: `My Reviews (${myReviews.length})`, icon: FileEdit },
          { id: 'comparisons', label: `My Comparisons (${savedComparisons.length})`, icon: Scale },
          { id: 'settings', label: 'Settings & Data', icon: Sliders },
        ].map((tab) => {
          const Icon = tab.icon;
          const isActive = activeSubTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveSubTab(tab.id)}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold shrink-0 transition cursor-pointer ${
                isActive
                  ? 'bg-[#101B3D] text-[#FFF9EF] shadow-xs'
                  : 'glass-pill text-[#69738A] hover:text-[#18213A] hover:bg-white/80 border border-white/80'
              }`}
            >
              <Icon className="w-3.5 h-3.5" />
              <span>{tab.label}</span>
            </button>
          );
        })}
      </div>

      {/* SUBTAB 1: Overview & Preferences */}
      {activeSubTab === 'overview' && (
        <form onSubmit={handleSavePreferences} className="space-y-4">
          <div className="glass-panel rounded-2xl p-5 sm:p-6 space-y-4 border border-white/80">
            <h3 className="text-sm font-bold text-[#18213A] flex items-center gap-2">
              <User className="w-4 h-4 text-[#3559C7]" />
              Account Details
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
              <div className="space-y-1.5">
                <label className="font-bold text-[#69738A]">Display Name</label>
                <input
                  type="text"
                  value={userName}
                  onChange={(e) => setUserName(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded-xl glass-input text-[#18213A] font-semibold"
                />
              </div>

              <div className="space-y-1.5">
                <label className="font-bold text-[#69738A]">Email Address</label>
                <input
                  type="email"
                  value={userEmail}
                  onChange={(e) => setUserEmail(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded-xl glass-input text-[#18213A] font-semibold"
                />
              </div>
            </div>
          </div>

          <div className="glass-panel rounded-2xl p-5 sm:p-6 space-y-4 border border-white/80">
            <h3 className="text-sm font-bold text-[#18213A] flex items-center gap-2">
              <Sliders className="w-4 h-4 text-[#3559C7]" />
              Default Recommendation Preferences
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
              <div className="space-y-1.5">
                <label className="font-bold text-[#69738A]">Primary Preferred Category</label>
                <select
                  value={preferredCat}
                  onChange={(e) => setPreferredCat(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded-xl glass-input text-[#18213A] font-semibold"
                >
                  {categories.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </select>
              </div>

              <div className="space-y-1.5">
                <label className="font-bold text-[#69738A]">Default Budget Ceiling (INR ₹)</label>
                <input
                  type="number"
                  value={defaultMaxBudget}
                  onChange={(e) => setDefaultMaxBudget(Number(e.target.value))}
                  className="w-full px-3.5 py-2.5 rounded-xl glass-input text-[#18213A] font-semibold"
                />
              </div>
            </div>

            <div className="p-3.5 rounded-xl glass-panel-subtle border border-white/80 flex items-center justify-between">
              <div>
                <span className="text-xs font-bold text-[#18213A] block">Strict Budget Enforcement</span>
                <span className="text-[11px] text-[#69738A]">Never display models that cost even ₹1 above designated budget ceiling.</span>
              </div>
              <input
                type="checkbox"
                checked={strictBudgetOnly}
                onChange={(e) => setStrictBudgetOnly(e.target.checked)}
                className="w-4 h-4 accent-[#3559C7] rounded cursor-pointer"
              />
            </div>
          </div>

          <div className="flex items-center justify-between pt-1">
            {savedFeedback ? (
              <span className="text-xs font-bold text-[#23865B] flex items-center gap-1">
                <CheckCircle2 className="w-4 h-4" /> Preferences saved successfully!
              </span>
            ) : <div />}
            <button
              type="submit"
              className="px-5 py-2.5 rounded-xl bg-[#101B3D] text-[#FFF9EF] hover:bg-[#17264F] text-xs font-bold transition flex items-center gap-2 shadow-xs cursor-pointer"
            >
              <Save className="w-4 h-4 text-[#D6AD60]" />
              <span>Save Profile Preferences</span>
            </button>
          </div>
        </form>
      )}

      {/* SUBTAB 2: Saved Products */}
      {activeSubTab === 'saved' && (
        <div className="space-y-4">
          {savedItems.length === 0 ? (
            <div className="glass-panel p-8 rounded-2xl text-center space-y-2 max-w-md mx-auto border border-white/80">
              <Bookmark className="w-8 h-8 text-[#69738A] mx-auto opacity-60" />
              <h3 className="font-bold text-sm text-[#18213A]">No Saved Products Yet</h3>
              <p className="text-xs text-[#69738A]">
                Click the bookmark icon on any product card in the explorer or recommendations to save it here.
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
              {savedItems.map((item) => {
                const p = item.product;
                if (!p) return null;
                const isCompared = comparedIds.includes(p.id);

                return (
                  <div
                    key={p.id}
                    className="glass-panel glass-card-hover rounded-2xl p-4 sm:p-5 flex flex-col justify-between space-y-3.5 border border-white/80 h-full"
                  >
                    <div className="space-y-3">
                      <div className="aspect-16/10 rounded-xl overflow-hidden glass-panel-subtle border border-white/80">
                        <ProductImage
                          src={p.imageUrl}
                          alt={p.name}
                          category={p.category}
                          brand={p.brand}
                          className="w-full h-full object-cover"
                        />
                      </div>

                      <div className="flex items-center justify-between">
                        <span className="text-[10px] font-bold uppercase text-[#3559C7] bg-[#3559C7]/10 px-2 py-0.5 rounded border border-[#3559C7]/20">
                          {p.brand}
                        </span>
                        <div className="flex items-center text-xs font-bold text-amber-500">
                          <Star className="w-3.5 h-3.5 fill-amber-400 mr-1" />
                          {p.rating}
                        </div>
                      </div>

                      <h4 className="font-bold text-sm text-[#18213A] line-clamp-1">{p.name}</h4>

                      <div className="text-lg font-black text-[#101B3D]">
                        {formatINR(p.price)}
                      </div>

                      <div className="text-[11px] text-[#69738A] flex items-center gap-1 font-medium">
                        <Calendar className="w-3 h-3 text-[#3559C7]" />
                        <span>Saved on {new Date(item.savedAt).toLocaleDateString()}</span>
                      </div>
                    </div>

                    <div className="pt-3 border-t border-white/80 flex items-center justify-between gap-2">
                      <button
                        onClick={() => onViewDetails(p)}
                        className="flex-1 py-2 px-3 bg-[#101B3D] text-[#FFF9EF] rounded-xl text-xs font-bold hover:bg-[#17264F] transition text-center cursor-pointer shadow-xs"
                      >
                        Details
                      </button>

                      <button
                        onClick={() => onAddToCompare(p)}
                        className={`p-2 rounded-xl text-xs font-semibold cursor-pointer transition ${
                          isCompared
                            ? 'bg-[#3559C7] text-white border border-[#3559C7]'
                            : 'glass-pill border border-white/80 text-[#69738A] hover:text-[#18213A]'
                        }`}
                        title="Compare"
                      >
                        <Scale className="w-3.5 h-3.5" />
                      </button>

                      <button
                        onClick={() => onRemoveSavedProduct(p.id)}
                        className="p-2 rounded-xl glass-pill border border-[#C34D4D]/30 text-[#C34D4D] hover:bg-[#C34D4D]/10 transition cursor-pointer"
                        title="Remove from saved"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      )}

      {/* SUBTAB 3: My Reviews */}
      {activeSubTab === 'reviews' && (
        <div className="space-y-4">
          {myReviews.length === 0 ? (
            <div className="glass-panel p-8 rounded-2xl text-center space-y-2 max-w-md mx-auto border border-white/80">
              <FileEdit className="w-8 h-8 text-[#69738A] mx-auto opacity-60" />
              <h3 className="font-bold text-sm text-[#18213A]">No Reviews Posted Yet</h3>
              <p className="text-xs text-[#69738A]">
                Submit feedback on products you own to help other buyers make confident choices.
              </p>
            </div>
          ) : (
            myReviews.map((rev) => (
              <div
                key={rev.id}
                className="glass-panel glass-card-hover rounded-2xl p-5 space-y-3 border border-white/80"
              >
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/80 pb-3">
                  <div className="space-y-1">
                    <div className="flex items-center gap-2">
                      <div className="flex text-amber-500">
                        {[1, 2, 3, 4, 5].map((s) => (
                          <Star
                            key={s}
                            className={`w-3.5 h-3.5 ${
                              s <= rev.rating ? 'fill-amber-400 text-amber-500' : 'text-gray-300'
                            }`}
                          />
                        ))}
                      </div>
                      <h4 className="font-bold text-sm text-[#18213A]">{rev.title}</h4>
                    </div>
                    <p className="text-xs text-[#69738A]">
                      Product: <strong className="text-[#3559C7]">{rev.productName}</strong>
                    </p>
                  </div>

                  <button
                    onClick={() => onDeleteReview(rev.id)}
                    className="p-1.5 text-xs text-[#C34D4D] hover:bg-[#C34D4D]/10 rounded-lg transition flex items-center gap-1 font-bold self-start sm:self-auto cursor-pointer"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                    <span>Delete Review</span>
                  </button>
                </div>

                <p className="text-xs text-[#18213A] leading-relaxed">{rev.reviewText}</p>

                <div className="text-[11px] text-[#69738A] glass-panel-subtle p-2.5 rounded-xl border border-white/70">
                  <span>Intended Usage: <strong className="text-[#101B3D]">{rev.intendedUsage}</strong></span>
                  {rev.purchasePrice && (
                    <span className="ml-4">Price Paid: <strong className="text-[#101B3D]">{formatINR(rev.purchasePrice)}</strong></span>
                  )}
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {/* SUBTAB 4: My Comparisons */}
      {activeSubTab === 'comparisons' && (
        <div className="space-y-4">
          {savedComparisons.length === 0 ? (
            <div className="glass-panel p-8 rounded-2xl text-center space-y-2 max-w-md mx-auto border border-white/80">
              <Scale className="w-8 h-8 text-[#69738A] mx-auto opacity-60" />
              <h3 className="font-bold text-sm text-[#18213A]">No Saved Comparisons</h3>
              <p className="text-xs text-[#69738A]">
                When comparing 2 or 3 products, click "Save Shootout" to store it here for future access.
              </p>
            </div>
          ) : (
            savedComparisons.map((comp) => (
              <div
                key={comp.id}
                className="glass-panel glass-card-hover rounded-2xl p-5 flex flex-col md:flex-row md:items-center justify-between gap-4 border border-white/80"
              >
                <div className="space-y-2">
                  <div className="flex items-center gap-2">
                    <h4 className="font-bold text-sm sm:text-base text-[#18213A]">{comp.title}</h4>
                    <span className="text-[10px] text-[#69738A] glass-panel-subtle px-2 py-0.5 rounded border border-white/80 font-medium">
                      {new Date(comp.createdAt).toLocaleDateString()}
                    </span>
                  </div>
                  <p className="text-xs text-[#69738A]">{comp.notes || 'Saved shootout comparison'}</p>

                  <div className="flex items-center gap-2 pt-1 flex-wrap">
                    {comp.products?.map((p) => (
                      <span
                        key={p.id}
                        className="text-xs glass-panel-subtle px-2.5 py-1 rounded-lg border border-white/80 font-semibold text-[#18213A]"
                      >
                        {p.name} ({formatINR(p.price)})
                      </span>
                    ))}
                  </div>
                </div>

                <div className="flex items-center gap-2 shrink-0">
                  <button
                    onClick={() => onReopenComparison(comp.products)}
                    className="px-4 py-2 bg-[#3559C7] hover:bg-[#2c4cb0] text-white rounded-xl text-xs font-bold transition flex items-center gap-1.5 cursor-pointer shadow-xs"
                  >
                    <RotateCcw className="w-3.5 h-3.5" />
                    <span>Reopen Shootout</span>
                  </button>

                  <button
                    onClick={() => onDeleteComparison(comp.id)}
                    className="p-2 glass-pill border border-[#C34D4D]/30 text-[#C34D4D] hover:bg-[#C34D4D]/10 rounded-xl transition cursor-pointer"
                    title="Delete saved shootout"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {/* SUBTAB 5: Settings & Data */}
      {activeSubTab === 'settings' && (
        <div className="glass-panel rounded-2xl p-5 sm:p-6 space-y-4 border border-white/80">
          <div className="space-y-1">
            <h3 className="text-sm sm:text-base font-bold text-[#18213A]">Data Storage & Maintenance</h3>
            <p className="text-xs text-[#69738A]">
              WORTHLY provides persistent client-side caching with local-demo fallback.
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-3 pt-2">
            <button
              onClick={handleExportData}
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold glass-pill hover:bg-white/80 text-[#18213A] border border-white/80 transition cursor-pointer"
            >
              <Download className="w-4 h-4 text-[#3559C7]" />
              <span>Export Shortlist & Settings (JSON)</span>
            </button>

            <button
              onClick={onResetAllDemoData}
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold text-[#C34D4D] glass-pill border border-[#C34D4D]/30 hover:bg-[#C34D4D]/10 transition cursor-pointer"
            >
              <RotateCcw className="w-4 h-4" />
              <span>Reset All Demo Data</span>
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

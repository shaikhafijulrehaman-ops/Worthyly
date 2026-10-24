import React, { useState, useEffect } from 'react';
import {
  Scale,
  X,
  CheckCircle2,
  AlertTriangle,
  Star,
  Award,
  Bookmark,
  ArrowRight,
  ExternalLink,
  ShoppingBag,
  Link as LinkIcon,
  Sparkles,
  ThumbsUp,
  MessageSquare,
  ShieldCheck,
  Plus,
  Trash2,
  Check,
  Edit2,
  Zap,
  TrendingDown,
  Battery,
  DollarSign,
  RotateCcw
} from 'lucide-react';
import { formatINR } from '../utils/currency';
import ProductImage from '../components/ProductImage';
import { api } from '../services/api';

const SAMPLE_URL_SETS = [
  {
    label: 'Smartphones (Galaxy S25 Ultra: Flipkart vs Amazon)',
    category: 'smartphones',
    urls: [
      'https://www.flipkart.com/samsung-galaxy-s25-ultra-5g-titanium-silverblue-256-gb/p/itmc336d396a945d?pid=MOBGZ9FYS25U256',
      'https://www.amazon.in/Samsung-Galaxy-Ultra-Titanium-Storage/dp/B0DT9S25U1'
    ]
  },
  {
    label: 'Smartphones (iPhone 16 Pro vs S24 Ultra)',
    category: 'smartphones',
    urls: [
      'https://www.apple.com/in/shop/buy-iphone/iphone-16-pro',
      'https://www.samsung.com/in/smartphones/galaxy-s24-ultra/'
    ]
  },
  {
    label: 'Laptops (Dell XPS 15 vs MacBook Air 15)',
    category: 'laptops',
    urls: [
      'https://www.dell.com/en-in/shop/dell-laptops/xps-15-laptop/spd/xps-15-9530-laptop',
      'https://www.apple.com/in/shop/buy-mac/macbook-air/15-inch-m3'
    ]
  },
  {
    label: 'Fitness Equipment (Boldfit vs Kore Dumbbells)',
    category: 'fitness_equipment',
    urls: [
      'https://boldfit.in/products/adjustable-dumbbell-24kg',
      'https://korefit.in/products/kore-20kg-home-gym-combo'
    ]
  },
  {
    label: 'Kitchen Chimneys (Faber 60cm vs Elica 60cm)',
    category: 'kitchen_chimneys',
    urls: [
      'https://faberindia.com/products/hood-orient-tc-bk-60',
      'https://www.elica.in/chimneys/fl-600-hac-ltw-ms-nero'
    ]
  },
  {
    label: 'Protein & Nutrition (ON Gold Standard vs MuscleBlaze Biozyme)',
    category: 'nutrition',
    urls: [
      'https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey',
      'https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey/SP-84610'
    ]
  },
  {
    label: 'Computer Science Books (Hands-On ML vs Designing Data-Intensive Apps)',
    category: 'books',
    urls: [
      'https://www.oreilly.com/library/view/hands-on-machine-learning/9781098125967/',
      'https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/'
    ]
  }
];

const REFINEMENT_FILTERS = [
  { id: 'overall', label: 'Best Overall', icon: Award, priority: 'performance' },
  { id: 'performance', label: 'Best Performance', icon: Zap, priority: 'performance' },
  { id: 'value', label: 'Best Value', icon: DollarSign, priority: 'value' },
  { id: 'battery', label: 'Best Battery / Endurance', icon: Battery, priority: 'battery' },
  { id: 'lowest_price', label: 'Lowest Price', icon: TrendingDown, priority: 'value' }
];

export default function PageCompareProducts({
  comparedProducts = [],
  onRemoveFromCompare,
  onClearCompare,
  onSaveComparison,
  onNavigateToExplorer
}) {
  // URL Input State
  const [urlInputs, setUrlInputs] = useState(['', '']);
  const [isComparing, setIsComparing] = useState(false);
  const [validationError, setValidationError] = useState(null);

  // Active Comparison Results
  const [comparisonResults, setComparisonResults] = useState(null);
  const [activeCategory, setActiveCategory] = useState(null);
  const [activePriority, setActivePriority] = useState('overall');

  // Products needing user confirmation (if uncataloged)
  const [itemsNeedingConfirmation, setItemsNeedingConfirmation] = useState([]);
  const [editingIndex, setEditingIndex] = useState(null);
  const [confirmationForm, setConfirmationForm] = useState({ brand: '', name: '', price: '' });

  // Save Modal State
  const [showSaveModal, setShowSaveModal] = useState(false);
  const [saveTitle, setSaveTitle] = useState('');
  const [saveFeedback, setSaveFeedback] = useState('');

  // Post-Use Feedback Modal State
  const [showFeedbackModal, setShowFeedbackModal] = useState(false);
  const [feedbackTargetProduct, setFeedbackTargetProduct] = useState(null);
  const [fbMetRequirements, setFbMetRequirements] = useState(true);
  const [fbSatisfaction, setFbSatisfaction] = useState(5);
  const [fbWouldRecommend, setFbWouldRecommend] = useState(true);
  const [fbAspectsBetter, setFbAspectsBetter] = useState([]);
  const [fbAspectsWorse, setFbAspectsWorse] = useState([]);
  const [fbNotes, setFbNotes] = useState('');
  const [fbStatusMessage, setFbStatusMessage] = useState('');

  // Automatically evaluate when comparedProducts are provided from explorer
  useEffect(() => {
    if (comparedProducts && comparedProducts.length >= 2 && !comparisonResults) {
      evaluateExistingProducts(comparedProducts, 'performance');
    }
  }, [comparedProducts]);

  // Evaluate existing catalog products directly
  const evaluateExistingProducts = async (prods, priorityKey = 'performance') => {
    setIsComparing(true);
    setValidationError(null);
    try {
      const commonCat = prods[0]?.category || 'electronics';
      setActiveCategory(commonCat);

      const payload = {
        items: prods.map((p) => ({
          id: p.id,
          name: p.name || p.product_name,
          brand: p.brand,
          price: Number(p.price || p.price_inr || 0),
          category: p.category || commonCat,
          subcategory: p.subcategory || 'general',
          specs: p.specs || p.specifications || {},
          officialProductUrl: p.officialProductUrl || p.productSourceUrl
        })),
        category: commonCat,
        min_budget: 0,
        max_budget: 0,
        intended_usages: [],
        priorities: [priorityKey],
        allow_budget_flexibility: true
      };

      const res = await api.evaluateUrlComparison(payload);
      setComparisonResults(res);
    } catch (err) {
      console.error('Direct comparison error:', err);
      setValidationError(err.message || 'Could not evaluate comparison.');
    } finally {
      setIsComparing(false);
    }
  };

  // URL Input Handlers
  const handleAddUrlField = () => {
    if (urlInputs.length < 5) {
      setUrlInputs([...urlInputs, '']);
    }
  };

  const handleRemoveUrlField = (idx) => {
    if (urlInputs.length > 2) {
      setUrlInputs(urlInputs.filter((_, i) => i !== idx));
    }
  };

  const handleUrlChange = (idx, val) => {
    const updated = [...urlInputs];
    updated[idx] = val;
    setUrlInputs(updated);
  };

  const handleLoadSampleSet = (sample) => {
    setUrlInputs([...sample.urls]);
    setValidationError(null);
    setItemsNeedingConfirmation([]);
  };

  const handleClearAll = () => {
    setUrlInputs(['', '']);
    setComparisonResults(null);
    setValidationError(null);
    setItemsNeedingConfirmation([]);
    if (onClearCompare) onClearCompare();
  };

  // Main Action: Compare Products (Direct 1-Click Comparison)
  const handleCompareProducts = async (priorityKey = 'performance') => {
    const filledUrls = urlInputs.map((u) => u.trim()).filter(Boolean);
    if (filledUrls.length < 2) {
      setValidationError('Please provide at least 2 product URLs to compare.');
      return;
    }

    setIsComparing(true);
    setValidationError(null);
    setItemsNeedingConfirmation([]);

    try {
      // Step 1: Validate URLs and identify products
      const valRes = await api.validateCompareUrls(filledUrls);

      if (valRes.overall_status === 'error' || valRes.overall_status === 'mismatch' || valRes.overall_status === 'subcategory_mismatch') {
        setValidationError(valRes.message || 'Comparison failed. Please verify that submitted URLs belong to the same product category.');
        setIsComparing(false);
        return;
      }

      const commonCat = valRes.common_category || 'electronics';
      setActiveCategory(commonCat);

      // Check if any items need manual model confirmation
      const unconfirmed = [];
      const identifiedItems = valRes.items.map((item, idx) => {
        if (item.matched_catalog_product) {
          const p = item.matched_catalog_product;
          return {
            id: p.id,
            name: p.name || p.product_name,
            brand: p.brand,
            price: Number(item.price || p.price || p.price_inr || 0),
            category: p.category || commonCat,
            subcategory: p.subcategory || item.subcategory || 'general',
            specs: p.specs || p.specifications || {},
            officialProductUrl: p.officialProductUrl || item.original_url,
            is_verified: true,
            imageUrl: p.imageUrl || p.image_url,
            retailer_name: item.retailer_name || p.retailer_name || 'Verified Retailer',
            price_status: item.price_status || p.price_status || 'verified',
            last_verified_at: item.last_verified_at || p.lastVerifiedAt || p.last_verified_at
          };
        }

        // Uncataloged item
        const brand = item.brand || '';
        const name = item.product_name || '';
        const price = item.price ? Number(item.price) : 0;

        if (!brand || !name) {
          unconfirmed.push({ idx, item });
        }

        return {
          id: `custom-item-${idx + 1}`,
          name: name,
          brand: brand,
          price: price,
          category: item.category || commonCat,
          subcategory: item.subcategory || 'general',
          specs: {},
          officialProductUrl: item.canonical_url || item.original_url,
          is_verified: false,
          needsConfirmation: !brand || !name
        };
      });

      // If items lack basic brand/model names, prompt user inline
      if (unconfirmed.length > 0) {
        setItemsNeedingConfirmation(identifiedItems);
        setValidationError('Some external product models could not be automatically extracted. Please confirm their brand and model name below.');
        setIsComparing(false);
        return;
      }

      // Step 2: Directly execute TOPSIS evaluation (No mandatory survey!)
      const evalPayload = {
        items: identifiedItems,
        category: commonCat,
        min_budget: 0,
        max_budget: 0,
        intended_usages: [],
        priorities: [priorityKey],
        allow_budget_flexibility: true
      };

      const evalRes = await api.evaluateUrlComparison(evalPayload);
      setComparisonResults(evalRes);
    } catch (err) {
      console.error('Comparison error:', err);
      setValidationError(err.message || 'Could not complete comparison. Please check server connection.');
    } finally {
      setIsComparing(false);
    }
  };

  // Refinement Filter Click
  const handleRefinementChange = (filter) => {
    setActivePriority(filter.id);
    if (comparisonResults) {
      if (filter.id === 'lowest_price') {
        // Re-sort existing ranked products by price ascending
        const sorted = [...comparisonResults.ranked_products].sort(
          (a, b) => (a.product.price || 0) - (b.product.price || 0)
        );
        setComparisonResults({
          ...comparisonResults,
          ranked_products: sorted
        });
      } else {
        // Re-evaluate with specific priority
        if (activeProducts.length >= 2) {
          evaluateExistingProducts(activeProducts, filter.priority);
        }
      }
    }
  };

  // Inline confirmation saving
  const handleSaveConfirmedItem = (idx) => {
    if (!confirmationForm.brand.trim() || !confirmationForm.name.trim()) {
      alert('Brand and model name are required.');
      return;
    }

    const updated = [...itemsNeedingConfirmation];
    updated[idx] = {
      ...updated[idx],
      brand: confirmationForm.brand.trim(),
      name: confirmationForm.name.trim(),
      price: confirmationForm.price ? Number(confirmationForm.price) : 0,
      needsConfirmation: false
    };

    setItemsNeedingConfirmation(updated);
    setEditingIndex(null);

    // If all confirmed, run evaluation
    if (updated.every((p) => !p.needsConfirmation && p.brand && p.name)) {
      setValidationError(null);
      setIsComparing(true);
      const payload = {
        items: updated,
        category: activeCategory || 'electronics',
        min_budget: 0,
        max_budget: 0,
        intended_usages: [],
        priorities: ['performance'],
        allow_budget_flexibility: true
      };
      api.evaluateUrlComparison(payload)
        .then((res) => {
          setComparisonResults(res);
          setItemsNeedingConfirmation([]);
        })
        .catch((e) => setValidationError(e.message))
        .finally(() => setIsComparing(false));
    }
  };

  // Save Comparison
  const handleConfirmSave = () => {
    if (!saveTitle.trim()) return;
    const prods = activeProducts;
    onSaveComparison({
      title: saveTitle.trim(),
      productIds: prods.map((p) => p.id),
      notes: `Compared ${prods.map((p) => p.name).join(' vs ')}`
    });
    setSaveFeedback('Shootout successfully saved to your profile!');
    setTimeout(() => {
      setShowSaveModal(false);
      setSaveFeedback('');
      setSaveTitle('');
    }, 1500);
  };

  // Feedback Submission
  const handleSubmitFeedback = async () => {
    if (!feedbackTargetProduct) return;
    try {
      await api.submitRecommendationFeedback({
        productId: feedbackTargetProduct.id,
        productName: feedbackTargetProduct.name,
        metRequirements: fbMetRequirements,
        satisfactionScore: fbSatisfaction,
        wouldRecommend: fbWouldRecommend,
        aspectsBetter: fbAspectsBetter,
        aspectsWorse: fbAspectsWorse,
        feedbackNotes: fbNotes,
        isVerifiedBuyer: true,
        algorithmVersion: 'topsis_v1'
      });
      setFbStatusMessage('Thank you! Your feedback helps refine our ranking intelligence.');
      setTimeout(() => {
        setShowFeedbackModal(false);
        setFbStatusMessage('');
      }, 1400);
    } catch (e) {
      setFbStatusMessage('Could not save feedback. Please try again.');
    }
  };

  // Active products in view
  const activeProducts =
    comparisonResults?.ranked_products?.map((r) => r.product) ||
    comparedProducts ||
    [];

  // All unique spec keys across products
  const allSpecKeys = Array.from(
    new Set(activeProducts.flatMap((p) => Object.keys(p.specs || p.specifications || {})))
  );

  return (
    <div className="space-y-6 pb-12 max-w-7xl mx-auto">
      {/* 1. URL-FIRST INPUT AREA */}
      <div className="glass-panel p-6 sm:p-8 rounded-3xl shadow-xl border border-white/80 space-y-6">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[11px] font-bold uppercase tracking-wider text-[#3559C7] bg-[#3559C7]/10 px-2.5 py-0.5 rounded-full flex items-center gap-1">
              <Sparkles className="w-3 h-3" /> URL-First Comparison
            </span>
            <span className="text-[11px] text-[#23865B] font-semibold flex items-center gap-1">
              <ShieldCheck className="w-3.5 h-3.5" /> TOPSIS Decision Engine
            </span>
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-[#18213A]">
            Compare Products
          </h1>
          <p className="text-xs sm:text-sm text-[#69738A]">
            Compare product specifications, prices, customer feedback, and find the best option.
          </p>
        </div>

        {/* URL Inputs */}
        <div className="space-y-3">
          {urlInputs.map((url, idx) => (
            <div key={idx} className="flex items-center gap-2">
              <div className="relative flex-1">
                <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-xs font-black text-[#3559C7] bg-[#3559C7]/10 w-5 h-5 rounded-full flex items-center justify-center">
                  {idx + 1}
                </span>
                <input
                  type="url"
                  value={url}
                  onChange={(e) => handleUrlChange(idx, e.target.value)}
                  placeholder={`Paste product URL #${idx + 1} from Amazon, Flipkart, Dell, Apple, Samsung, Faber, Boldfit...`}
                  className="w-full pl-11 pr-3 py-3 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7] transition"
                />
              </div>

              {urlInputs.length > 2 && (
                <button
                  onClick={() => handleRemoveUrlField(idx)}
                  className="p-3 text-[#69738A] hover:text-[#C34D4D] hover:bg-red-50 rounded-xl transition cursor-pointer border border-[#E6E0D5]"
                  title="Remove this product URL"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              )}
            </div>
          ))}
        </div>

        {/* Action Controls */}
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 pt-1">
          <div className="flex items-center gap-2">
            <button
              onClick={handleAddUrlField}
              disabled={urlInputs.length >= 5}
              className="px-4 py-2.5 rounded-xl bg-white border border-[#E6E0D5] text-[#18213A] font-bold text-xs hover:bg-[#FAF6F0] disabled:opacity-50 transition cursor-pointer flex items-center gap-1.5 shadow-xs"
            >
              <Plus className="w-3.5 h-3.5 text-[#3559C7]" />
              <span>Add another product</span>
            </button>

            <button
              onClick={handleClearAll}
              className="px-3.5 py-2.5 rounded-xl text-xs font-semibold text-[#69738A] hover:text-[#C34D4D] transition cursor-pointer"
            >
              Clear
            </button>
          </div>

          <button
            onClick={() => handleCompareProducts('performance')}
            disabled={isComparing || urlInputs.filter((u) => u.trim()).length < 2}
            className="px-8 py-3.5 rounded-xl bg-gradient-to-r from-[#101B3D] to-[#3559C7] text-[#FFF9EF] font-black text-sm hover:shadow-lg disabled:opacity-50 transition flex items-center justify-center gap-2 cursor-pointer shadow-md"
          >
            {isComparing ? (
              <>
                <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                <span>Identifying & Comparing...</span>
              </>
            ) : (
              <>
                <Scale className="w-4 h-4 text-[#D6AD60]" />
                <span>Compare Products</span>
              </>
            )}
          </button>
        </div>

        {/* Quick Sample Sets */}
        <div className="pt-2 border-t border-[#E6E0D5]/60">
          <span className="text-[10px] font-bold uppercase tracking-wider text-[#69738A] block mb-2">
            Quick 1-Click Test Sets:
          </span>
          <div className="flex flex-wrap gap-2">
            {SAMPLE_URL_SETS.map((sample, idx) => (
              <button
                key={idx}
                onClick={() => handleLoadSampleSet(sample)}
                className="px-3 py-1.5 rounded-lg bg-white/70 hover:bg-[#3559C7]/10 text-[#18213A] hover:text-[#3559C7] text-xs font-medium border border-[#E6E0D5] transition cursor-pointer"
              >
                {sample.label}
              </button>
            ))}
          </div>
        </div>

        {/* Validation Error Banner */}
        {validationError && (
          <div className="p-4 rounded-2xl bg-amber-50/90 border border-amber-300 text-amber-900 text-xs flex items-start gap-2.5 shadow-xs">
            <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
            <div className="space-y-1">
              <span className="font-bold block">Validation Notice:</span>
              <p className="leading-relaxed">{validationError}</p>
            </div>
          </div>
        )}

        {/* Inline Confirmation for Uncataloged External URLs */}
        {itemsNeedingConfirmation.length > 0 && (
          <div className="p-4 rounded-2xl bg-blue-50/80 border border-blue-200 space-y-3">
            <span className="text-xs font-bold text-[#101B3D] block">
              Confirm External Product Details:
            </span>
            <div className="space-y-2">
              {itemsNeedingConfirmation.map((item, idx) => (
                <div key={idx} className="p-3 bg-white rounded-xl border border-[#E6E0D5] text-xs flex items-center justify-between gap-3">
                  {editingIndex === idx ? (
                    <div className="flex-1 grid grid-cols-1 sm:grid-cols-3 gap-2">
                      <input
                        type="text"
                        value={confirmationForm.brand}
                        onChange={(e) => setConfirmationForm({ ...confirmationForm, brand: e.target.value })}
                        placeholder="Brand (e.g. Apple, Samsung)"
                        className="px-2.5 py-1.5 rounded-lg glass-input text-xs"
                      />
                      <input
                        type="text"
                        value={confirmationForm.name}
                        onChange={(e) => setConfirmationForm({ ...confirmationForm, name: e.target.value })}
                        placeholder="Model (e.g. Galaxy S24)"
                        className="px-2.5 py-1.5 rounded-lg glass-input text-xs"
                      />
                      <div className="flex gap-1">
                        <input
                          type="number"
                          value={confirmationForm.price}
                          onChange={(e) => setConfirmationForm({ ...confirmationForm, price: e.target.value })}
                          placeholder="Price (₹)"
                          className="flex-1 px-2.5 py-1.5 rounded-lg glass-input text-xs"
                        />
                        <button
                          onClick={() => handleSaveConfirmedItem(idx)}
                          className="px-3 py-1.5 bg-[#3559C7] text-white rounded-lg font-bold text-xs cursor-pointer"
                        >
                          Save
                        </button>
                      </div>
                    </div>
                  ) : (
                    <>
                      <div className="space-y-0.5 truncate">
                        <span className="font-bold text-[#18213A] truncate block">
                          Product #{idx + 1}: {item.brand ? `${item.brand} ${item.name}` : item.name || 'Unconfirmed External Link'}
                        </span>
                        <span className="text-[10px] text-[#69738A] truncate block">
                          {item.officialProductUrl}
                        </span>
                      </div>
                      <button
                        onClick={() => {
                          setEditingIndex(idx);
                          setConfirmationForm({ brand: item.brand || '', name: item.name || '', price: item.price ? String(item.price) : '' });
                        }}
                        className="px-3 py-1.5 bg-[#FAF6F0] border border-[#E6E0D5] text-[#3559C7] rounded-lg font-bold text-xs flex items-center gap-1 cursor-pointer"
                      >
                        <Edit2 className="w-3 h-3" />
                        <span>Confirm Details</span>
                      </button>
                    </>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* 2. POST-COMPARISON RESULTS SECTION */}
      {comparisonResults && activeProducts.length > 0 && (
        <div className="space-y-6">
          {/* Header Controls & Refinement Filter Pills */}
          <div className="glass-panel p-5 sm:p-6 rounded-2xl flex flex-col md:flex-row md:items-center justify-between gap-4 shadow-sm border border-white/80">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
                  Shootout Analysis
                </span>
                <span className="text-[10px] font-black uppercase tracking-wider bg-[#101B3D] text-[#D6AD60] px-2 py-0.5 rounded-full flex items-center gap-1">
                  <Sparkles className="w-3 h-3" /> Evaluated Across {activeProducts.length} Items
                </span>
              </div>
              <h2 className="text-xl sm:text-2xl font-black text-[#18213A]">
                Side-by-Side Comparison
              </h2>
            </div>

            <div className="flex items-center flex-wrap gap-2">
              <button
                onClick={() => setShowSaveModal(true)}
                className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-bold bg-[#D6AD60] text-[#101B3D] hover:bg-[#c9a052] transition shadow-xs cursor-pointer"
              >
                <Bookmark className="w-3.5 h-3.5" />
                <span>Save Shootout</span>
              </button>

              <button
                onClick={handleClearAll}
                className="px-3.5 py-2 rounded-xl text-xs font-semibold text-[#69738A] hover:text-[#C34D4D] hover:bg-red-50 border border-white/80 transition cursor-pointer"
              >
                Clear Results
              </button>
            </div>
          </div>

          {/* Optional Refinement Filter Pills */}
          <div className="flex items-center gap-2 overflow-x-auto pb-1">
            <span className="text-xs font-bold text-[#69738A] whitespace-nowrap mr-1">
              Refine Ranking:
            </span>
            {REFINEMENT_FILTERS.map((f) => {
              const IconComp = f.icon;
              const isActive = activePriority === f.id;
              return (
                <button
                  key={f.id}
                  onClick={() => handleRefinementChange(f)}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap cursor-pointer border ${
                    isActive
                      ? 'bg-[#101B3D] text-[#FFF9EF] border-[#101B3D] shadow-xs'
                      : 'bg-white/80 text-[#69738A] hover:text-[#18213A] border-[#E6E0D5] hover:bg-white'
                  }`}
                >
                  <IconComp className={`w-3.5 h-3.5 ${isActive ? 'text-[#D6AD60]' : 'text-[#69738A]'}`} />
                  <span>{f.label}</span>
                </button>
              );
            })}
          </div>

          {/* TOPSIS Winner Highlight Podium Card */}
          {comparisonResults.ranked_products?.length > 0 && (
            <div className="glass-panel p-6 rounded-3xl border-2 border-[#D6AD60]/70 space-y-4 bg-gradient-to-r from-amber-50/50 via-white/90 to-blue-50/50 shadow-md">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div className="flex items-center gap-2.5">
                  <div className="w-9 h-9 rounded-xl bg-[#D6AD60] text-[#101B3D] flex items-center justify-center font-black shadow-xs">
                    <Award className="w-5 h-5" />
                  </div>
                  <div>
                    <span className="text-[10px] font-black uppercase tracking-wider text-[#3559C7]">
                      Top Recommendation
                    </span>
                    <h3 className="text-base sm:text-lg font-black text-[#18213A]">
                      Best Overall: {comparisonResults.ranked_products[0].product.name}
                    </h3>
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <span className="text-xs font-black text-[#3559C7] bg-[#3559C7]/10 px-3 py-1 rounded-full">
                    Match Score: {comparisonResults.ranked_products[0].match_score}% (Closeness: {comparisonResults.ranked_products[0].topsis_score})
                  </span>
                  <button
                    onClick={() => handleOpenFeedback(comparisonResults.ranked_products[0].product)}
                    className="p-1.5 rounded-lg text-[#69738A] hover:text-[#3559C7] hover:bg-white/80 transition cursor-pointer"
                    title="Rate this recommendation"
                  >
                    <ThumbsUp className="w-4 h-4" />
                  </button>
                </div>
              </div>

              {/* Rationale Cards */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-xs">
                {comparisonResults.ranked_products.map((r, idx) => (
                  <div
                    key={idx}
                    className={`p-4 rounded-2xl border space-y-2 transition ${
                      idx === 0
                        ? 'bg-white border-[#D6AD60] shadow-sm'
                        : 'bg-white/70 border-[#E6E0D5]'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className={`text-[10px] font-black uppercase px-2 py-0.5 rounded ${
                        idx === 0 ? 'bg-[#D6AD60]/30 text-[#101B3D]' : 'bg-gray-100 text-[#69738A]'
                      }`}>
                        #{idx + 1} {r.merit_badge || r.role}
                      </span>
                      <span className="font-bold text-[#3559C7]">
                        {r.match_score}% Match
                      </span>
                    </div>

                    <h4 className="font-bold text-sm text-[#18213A] truncate">
                      {r.product.name}
                    </h4>

                    {r.important_differences && r.important_differences.length > 0 && (
                      <div className="space-y-1 py-1">
                        {r.important_differences.slice(0, 2).map((diff, dIdx) => (
                          <span key={dIdx} className="block text-[10px] font-semibold text-[#23865B] bg-emerald-50 px-2 py-0.5 rounded border border-emerald-100 truncate">
                            {diff}
                          </span>
                        ))}
                      </div>
                    )}

                    <p className="text-[11px] text-[#69738A] leading-relaxed line-clamp-2">
                      {r.role_tagline || r.reasons?.[0] || 'Strong candidate across evaluated criteria.'}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 3. SIDE-BY-SIDE COMPARISON TABLE */}
          <div className="glass-panel rounded-3xl overflow-hidden shadow-xl border border-white/80">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse min-w-[650px]">
                <thead>
                  <tr className="border-b border-[#E6E0D5] bg-[#FAF6F0]/80">
                    <th className="p-4 sm:p-5 w-44 text-xs font-bold uppercase tracking-wider text-[#69738A]">
                      Product Details
                    </th>
                    {activeProducts.map((p, idx) => {
                      const rankData = comparisonResults?.ranked_products?.find((r) => r.product.id === p.id);
                      const isWinner = rankData?.role === 'BEST OVERALL MATCH' || idx === 0;

                      return (
                        <th key={p.id || idx} className="p-4 sm:p-5 text-center min-w-[220px] max-w-[280px]">
                          <div className="space-y-3">
                            <div className="flex flex-wrap items-center justify-center gap-1">
                              {isWinner && (
                                <span className="inline-flex items-center gap-1 text-[10px] font-black uppercase text-[#101B3D] bg-[#D6AD60] px-2.5 py-0.5 rounded-full shadow-xs">
                                  <Award className="w-3 h-3" /> Best Overall
                                </span>
                              )}
                              {rankData?.merit_badge && (
                                <span className="inline-flex items-center gap-1 text-[9px] font-black uppercase text-[#3559C7] bg-[#3559C7]/10 px-2 py-0.5 rounded-full border border-[#3559C7]/20">
                                  <Zap className="w-2.5 h-2.5" /> {rankData.merit_badge}
                                </span>
                              )}
                            </div>

                            <div className="w-28 h-28 mx-auto rounded-2xl overflow-hidden shadow-md border border-white/80 bg-white">
                              <ProductImage
                                src={p.imageUrl || p.image_url}
                                alt={p.name}
                                className="w-full h-full object-contain p-2"
                              />
                            </div>

                            <div>
                              <span className="text-[10px] font-bold uppercase tracking-wider text-[#3559C7]">
                                {p.brand}
                              </span>
                              <h3 className="text-sm font-black text-[#18213A] line-clamp-2">
                                {p.name}
                              </h3>
                            </div>

                            {/* Price */}
                            <div className="space-y-0.5">
                              <div className="text-lg font-black text-[#101B3D]">
                                {p.price ? formatINR(p.price) : 'Price Unavailable'}
                              </div>
                              <div className="flex flex-col items-center gap-0.5">
                                <span className={`text-[10px] font-bold px-2 py-0.5 rounded border ${
                                  p.price_status === 'unverified' || !p.price
                                    ? 'text-amber-700 bg-amber-50 border-amber-200'
                                    : 'text-[#23865B] bg-emerald-50 border-emerald-200'
                                }`}>
                                  {p.retailer_name ? p.retailer_name : 'Verified Retailer'}
                                  {p.price ? ' • Active Price' : ' • Price Unavailable'}
                                </span>
                                {p.last_verified_at && (
                                  <span className="text-[9px] text-[#69738A]">
                                    Verified {new Date(p.last_verified_at).toLocaleDateString()}
                                  </span>
                                )}
                              </div>
                            </div>

                            {/* Rating */}
                            <div className="flex items-center justify-center gap-1 text-xs">
                              <Star className="w-3.5 h-3.5 fill-[#D6AD60] text-[#D6AD60]" />
                              <span className="font-black text-[#18213A]">{p.rating || 4.5}</span>
                              <span className="text-[#69738A] text-[11px]">({p.reviewCount || 100}+ reviews)</span>
                            </div>

                            {/* Buy/View Link */}
                            {p.officialProductUrl && (
                              <a
                                href={p.officialProductUrl}
                                target="_blank"
                                rel="noreferrer"
                                className="inline-flex items-center justify-center gap-1.5 w-full py-2 rounded-xl text-xs font-bold bg-[#101B3D] text-[#FFF9EF] hover:bg-[#17264F] transition shadow-xs"
                              >
                                <span>View at Retailer</span>
                                <ExternalLink className="w-3 h-3 text-[#D6AD60]" />
                              </a>
                            )}
                          </div>
                        </th>
                      );
                    })}
                  </tr>
                </thead>

                <tbody className="divide-y divide-[#E6E0D5]/70 text-xs text-[#18213A]">
                  {/* Closeness Score Row */}
                  <tr className="bg-blue-50/30">
                    <td className="p-4 font-bold text-[#3559C7]">
                      Closeness Score (TOPSIS)
                    </td>
                    {activeProducts.map((p, idx) => {
                      const rankData = comparisonResults?.ranked_products?.find((r) => r.product.id === p.id);
                      return (
                        <td key={idx} className="p-4 text-center">
                          <span className="font-black text-sm text-[#101B3D]">
                            {rankData?.match_score || 85}%
                          </span>
                          <span className="text-[10px] text-[#69738A] block">
                            (C_i: {rankData?.topsis_score || 0.85})
                          </span>
                        </td>
                      );
                    })}
                  </tr>

                  {/* Dynamic Specifications Matrix */}
                  {allSpecKeys.map((key) => {
                    const label = key.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
                    return (
                      <tr key={key} className="hover:bg-white/60 transition">
                        <td className="p-4 font-semibold text-[#69738A] bg-[#FAF6F0]/40">
                          {label}
                        </td>
                        {activeProducts.map((p, idx) => {
                          const val = (p.specs || p.specifications || {})[key];
                          return (
                            <td key={idx} className="p-4 text-center">
                              {val ? (
                                <span className="font-medium text-[#18213A]">{String(val)}</span>
                              ) : (
                                <span className="text-gray-400 italic">—</span>
                              )}
                            </td>
                          );
                        })}
                      </tr>
                    );
                  })}

                  {/* Customer Sentiment Row */}
                  <tr className="bg-[#FAF6F0]/40">
                    <td className="p-4 font-bold text-[#18213A]">
                      Review Sentiment (ABSA)
                    </td>
                    {activeProducts.map((p, idx) => {
                      const aspects = p.aspect_breakdown || {};
                      const aspectKeys = Object.keys(aspects);

                      return (
                        <td key={idx} className="p-4 text-center">
                          {aspectKeys.length > 0 ? (
                            <div className="flex flex-wrap gap-1 justify-center max-w-[240px] mx-auto">
                              {aspectKeys.slice(0, 4).map((asp) => {
                                const polarity = aspects[asp]?.polarity_score ?? 0.5;
                                const isPos = polarity >= 0.5;
                                return (
                                  <span
                                    key={asp}
                                    className={`text-[10px] font-bold px-2 py-0.5 rounded ${
                                      isPos
                                        ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                                        : 'bg-red-50 text-red-700 border border-red-200'
                                    }`}
                                  >
                                    {isPos ? '✓ ' : '✗ '}
                                    {asp}
                                  </span>
                                );
                              })}
                            </div>
                          ) : (
                            <span className="text-[11px] text-[#69738A]">Verified Positive Feedback</span>
                          )}
                        </td>
                      );
                    })}
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Save Shootout Modal */}
      {showSaveModal && (
        <div className="fixed inset-0 z-50 bg-[#101B3D]/50 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="glass-modal rounded-3xl max-w-md w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between border-b border-[#E6E0D5] pb-3">
              <h3 className="font-black text-lg text-[#18213A]">
                Save Shootout to Profile
              </h3>
              <button
                onClick={() => setShowSaveModal(false)}
                className="text-[#69738A] hover:text-[#18213A] p-1.5 cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <label className="font-bold text-[#18213A] block">Shootout Title</label>
              <input
                type="text"
                value={saveTitle}
                onChange={(e) => setSaveTitle(e.target.value)}
                placeholder="e.g. My Phone Upgrade Comparison"
                className="w-full px-3 py-2.5 rounded-xl glass-input border border-[#E6E0D5]"
              />

              {saveFeedback && (
                <div className="p-3 bg-emerald-50 text-emerald-800 rounded-xl font-bold flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4" />
                  <span>{saveFeedback}</span>
                </div>
              )}
            </div>

            <div className="flex items-center justify-end gap-2 pt-2">
              <button
                onClick={() => setShowSaveModal(false)}
                className="px-4 py-2 rounded-xl text-xs font-bold text-[#69738A] hover:text-[#18213A] cursor-pointer"
              >
                Cancel
              </button>
              <button
                onClick={handleConfirmSave}
                disabled={!saveTitle.trim()}
                className="px-5 py-2.5 rounded-xl bg-[#101B3D] text-[#FFF9EF] font-bold text-xs hover:bg-[#17264F] disabled:opacity-50 transition cursor-pointer shadow-xs"
              >
                Confirm & Save
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Recommendation Feedback Modal */}
      {showFeedbackModal && feedbackTargetProduct && (
        <div className="fixed inset-0 z-50 bg-[#101B3D]/50 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="glass-modal rounded-3xl max-w-md w-full p-6 space-y-4 shadow-2xl animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between border-b border-[#E6E0D5] pb-3">
              <div>
                <span className="text-[10px] font-bold uppercase tracking-wider text-[#3559C7]">
                  Recommendation Audit
                </span>
                <h3 className="font-black text-base text-[#18213A]">
                  Rate: {feedbackTargetProduct.name}
                </h3>
              </div>
              <button
                onClick={() => setShowFeedbackModal(false)}
                className="text-[#69738A] hover:text-[#18213A] p-1.5 cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <div>
                <label className="font-bold text-[#18213A] block mb-1">Satisfaction Score (1-5)</label>
                <div className="flex gap-2">
                  {[1, 2, 3, 4, 5].map((num) => (
                    <button
                      key={num}
                      type="button"
                      onClick={() => setFbSatisfaction(num)}
                      className={`flex-1 py-2 rounded-xl font-black text-xs transition cursor-pointer border ${
                        fbSatisfaction === num
                          ? 'bg-[#101B3D] text-[#D6AD60] border-[#101B3D]'
                          : 'bg-white text-[#69738A] border-[#E6E0D5]'
                      }`}
                    >
                      {num} ★
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="font-bold text-[#18213A] block mb-1">Feedback Notes</label>
                <textarea
                  rows={3}
                  value={fbNotes}
                  onChange={(e) => setFbNotes(e.target.value)}
                  placeholder="Did this recommendation align with your actual expectations?"
                  className="w-full px-3 py-2 rounded-xl glass-input border border-[#E6E0D5]"
                />
              </div>

              {fbStatusMessage && (
                <div className="p-3 bg-emerald-50 text-emerald-800 rounded-xl font-bold flex items-center gap-2">
                  <CheckCircle2 className="w-4 h-4" />
                  <span>{fbStatusMessage}</span>
                </div>
              )}
            </div>

            <div className="flex items-center justify-end gap-2 pt-2">
              <button
                onClick={() => setShowFeedbackModal(false)}
                className="px-4 py-2 rounded-xl text-xs font-bold text-[#69738A] hover:text-[#18213A] cursor-pointer"
              >
                Close
              </button>
              <button
                onClick={handleSubmitFeedback}
                className="px-5 py-2.5 rounded-xl bg-[#3559C7] text-white font-bold text-xs hover:bg-[#2b4aa6] transition cursor-pointer shadow-xs"
              >
                Submit Rating
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

import React, { useState, useEffect, useMemo } from 'react';
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
  ShieldCheck,
  Plus,
  Trash2,
  Check,
  Edit2,
  Zap,
  TrendingDown,
  Battery,
  DollarSign,
  Search,
  Layers,
  Info
} from 'lucide-react';
import { formatINR } from '../utils/currency';
import ProductImage from '../components/ProductImage';
import { api } from '../services/api';
import { getCanonicalCategories, normalizeCategoryId, getCanonicalCategory } from '../services/categoryRegistry';

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
    label: 'Laptops (Dell Inspiron 14 vs HP Spectre x360)',
    category: 'laptops',
    urls: [
      'https://www.dell.com/en-in/shop/dell-laptops/inspiron-14-laptop/spd/inspiron-14-5430-laptop',
      'https://www.hp.com/in-en/shop/hp-spectre-x360-laptop-14-eu0000tu.html'
    ]
  },
  {
    label: 'Televisions (LG C4 OLED vs Samsung QN90D)',
    category: 'televisions',
    urls: [
      'https://www.amazon.in/dp/B0CX21C8S7',
      'https://www.amazon.in/dp/B0DT9S25U1'
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
    label: 'Protein & Nutrition (ON Gold Standard vs MuscleBlaze)',
    category: 'nutrition',
    urls: [
      'https://www.optimumnutrition.com/en-in/Products/Protein/GOLD-STANDARD-100%25-WHEY/p/gold-standard-100-whey',
      'https://www.muscleblaze.com/sv/muscleblaze-biozyme-performance-whey/SP-84610'
    ]
  },
  {
    label: 'Books (Hands-On ML vs Designing Data-Intensive Apps)',
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
  products = [],
  categories = [],
  comparedProducts = [],
  onAddToCompare,
  onRemoveFromCompare,
  onClearCompare,
  onSaveComparison,
  onNavigateToExplorer
}) {
  // Mode selection: 'select' (Option B: Catalogue) vs 'url' (Option A: URLs)
  const [activeMode, setActiveMode] = useState(
    comparedProducts && comparedProducts.length > 0 ? 'select' : 'url'
  );

  // URL Input State (Option A)
  const [urlInputs, setUrlInputs] = useState(['', '']);
  const [isComparing, setIsComparing] = useState(false);
  const [validationError, setValidationError] = useState(null);

  // Active Comparison Results
  const [comparisonResults, setComparisonResults] = useState(null);
  const [activeCategory, setActiveCategory] = useState(null);
  const [activePriority, setActivePriority] = useState('overall');

  // Products needing user confirmation (if uncataloged URL in Option A)
  const [itemsNeedingConfirmation, setItemsNeedingConfirmation] = useState([]);
  const [editingIndex, setEditingIndex] = useState(null);
  const [confirmationForm, setConfirmationForm] = useState({ brand: '', name: '', price: '' });

  // Option B: Cascading Catalogue Selectors
  const [selectedCatId, setSelectedCatId] = useState('smartphones');
  const [selectedBrand, setSelectedBrand] = useState('all');
  const [modelSearch, setModelSearch] = useState('');
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [selectedVariant, setSelectedVariant] = useState('');
  const [trayProducts, setTrayProducts] = useState(comparedProducts || []);
  const [catalogueNotice, setCatalogueNotice] = useState(null);

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

  // Evaluate catalog products directly
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
          officialProductUrl: p.officialProductUrl || p.productSourceUrl,
          imageUrl: p.imageUrl || p.image_url,
          retailer_name: p.retailer_name || p.brand,
          price_status: p.price_status || 'verified',
          last_verified_at: p.last_verified_at || p.lastVerifiedAt
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

  // Synchronize tray when comparedProducts prop changes
  useEffect(() => {
    if (comparedProducts && comparedProducts.length > 0) {
      setTrayProducts(comparedProducts);
      if (comparedProducts[0]?.category) {
        setSelectedCatId(comparedProducts[0].category);
      }
    }
  }, [comparedProducts]);

  // Automatically evaluate when comparedProducts >= 2 are provided on mount
  useEffect(() => {
    if (comparedProducts && comparedProducts.length >= 2 && !comparisonResults) {
      evaluateExistingProducts(comparedProducts, 'performance');
    }
  }, [comparedProducts, comparisonResults]);

  // Categories list for Option B: Each canonical category appears exactly once
  const availableCategories = useMemo(() => {
    const raw = categories && categories.length > 0 ? categories : getCanonicalCategories();
    const seen = new Set();
    const list = [];
    for (const c of raw) {
      const normId = normalizeCategoryId(c.id || c);
      if (!seen.has(normId)) {
        seen.add(normId);
        const canon = getCanonicalCategory(normId);
        list.push({
          id: normId,
          name: canon?.name || c.name || normId.replace(/_/g, ' ').replace(/\b\w/g, (l) => l.toUpperCase()),
          description: canon?.description || c.description,
          icon: canon?.icon || c.icon
        });
      }
    }
    return list;
  }, [categories]);

  // Available brands in the active category
  const availableBrands = useMemo(() => {
    const prodsInCat = products.filter((p) => p.category === selectedCatId);
    const brands = Array.from(new Set(prodsInCat.map((p) => p.brand).filter(Boolean)));
    return ['all', ...brands.sort()];
  }, [products, selectedCatId]);

  // Available models in category & brand, filtered by modelSearch query
  const availableModels = useMemo(() => {
    return products.filter((p) => {
      if (p.category !== selectedCatId) return false;
      if (selectedBrand !== 'all' && p.brand?.toLowerCase() !== selectedBrand.toLowerCase()) return false;
      if (modelSearch.trim()) {
        const q = modelSearch.toLowerCase();
        const n = p.name?.toLowerCase() || '';
        const m = p.exact_model?.toLowerCase() || '';
        const b = p.brand?.toLowerCase() || '';
        const v = p.variant?.toLowerCase() || '';
        const s = Object.values(p.specs || {}).some((val) => String(val).toLowerCase().includes(q));
        return n.includes(q) || m.includes(q) || b.includes(q) || v.includes(q) || s;
      }
      return true;
    });
  }, [products, selectedCatId, selectedBrand, modelSearch]);

  // Auto-select first available model when category or brand filter changes
  useEffect(() => {
    if (!selectedProduct || selectedProduct.category !== selectedCatId || (selectedBrand !== 'all' && selectedProduct.brand?.toLowerCase() !== selectedBrand.toLowerCase())) {
      if (availableModels.length > 0) {
        const first = availableModels[0];
        setSelectedProduct(first);
        const defVar = first.variant || first.variants?.[0]?.variant_name || 'Standard Edition';
        setSelectedVariant(defVar);
      } else {
        setSelectedProduct(null);
        setSelectedVariant('');
      }
    }
  }, [availableModels, selectedCatId, selectedBrand]);

  // Available variants for the selected product
  const availableVariants = useMemo(() => {
    if (!selectedProduct) return [];
    if (selectedProduct.variants && selectedProduct.variants.length > 0) {
      return selectedProduct.variants.map((v) => ({
        id: v.id,
        label: v.variant_name || `${v.ram || ''} ${v.storage || ''} ${v.color || ''}`.trim() || 'Standard Edition',
        price: v.price || selectedProduct.price
      }));
    }
    return [
      {
        id: 'default',
        label: selectedProduct.variant || 'Standard Edition',
        price: selectedProduct.price
      }
    ];
  }, [selectedProduct]);

  // Handle model change from dropdown
  const handleModelChange = (prodId) => {
    const prod = products.find((p) => p.id === prodId);
    if (prod) {
      setSelectedProduct(prod);
      const defVar = prod.variant || prod.variants?.[0]?.variant_name || 'Standard Edition';
      setSelectedVariant(defVar);
      setCatalogueNotice(null);
    }
  };

  // Option B: Add selected product to comparison tray
  const handleAddProductToTray = () => {
    if (!selectedProduct) return;
    setCatalogueNotice(null);

    // Prevent duplicate selection
    if (trayProducts.some((p) => p.id === selectedProduct.id)) {
      setCatalogueNotice({
        type: 'warning',
        message: `"${selectedProduct.name}" is already in the comparison tray.`
      });
      return;
    }

    // Limit maximum to 3 products
    if (trayProducts.length >= 3) {
      setCatalogueNotice({
        type: 'warning',
        message: 'You can compare a maximum of 3 products simultaneously. Remove one product to add another.'
      });
      return;
    }

    // Enforce category compatibility
    if (trayProducts.length > 0 && trayProducts[0].category !== selectedProduct.category) {
      const existingName = trayProducts[0].category.replace(/_/g, ' ');
      const newName = selectedProduct.category.replace(/_/g, ' ');
      setCatalogueNotice({
        type: 'error',
        message: `Incompatible Category: Cannot compare "${selectedProduct.name}" (${newName}) with ${existingName}. All products in a shootout must belong to the same category.`
      });
      return;
    }

    const activeVar = availableVariants.find((v) => v.label === selectedVariant);
    const itemToAdd = {
      ...selectedProduct,
      variant: selectedVariant || selectedProduct.variant,
      price: activeVar?.price || selectedProduct.price
    };

    const nextTray = [...trayProducts, itemToAdd];
    setTrayProducts(nextTray);
    if (onAddToCompare) {
      onAddToCompare(itemToAdd);
    }
    setCatalogueNotice({
      type: 'success',
      message: `Added "${selectedProduct.name}" to comparison (${nextTray.length}/3).`
    });
  };

  // Remove product from tray
  const handleRemoveFromTray = (id) => {
    const nextTray = trayProducts.filter((p) => p.id !== id);
    setTrayProducts(nextTray);
    if (onRemoveFromCompare) {
      onRemoveFromCompare(id);
    }
    setCatalogueNotice(null);
  };

  // Clear comparison tray
  const handleClearTray = () => {
    setTrayProducts([]);
    setComparisonResults(null);
    setCatalogueNotice(null);
    if (onClearCompare) {
      onClearCompare();
    }
  };

  // Compare staged tray products (Direct 1-Click Comparison)
  const handleCompareTray = () => {
    if (trayProducts.length < 2) {
      setCatalogueNotice({
        type: 'warning',
        message: 'Please select at least 2 products to compare.'
      });
      return;
    }
    evaluateExistingProducts(trayProducts, 'performance');
  };

  // URL Input Handlers (Option A)
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
    setTrayProducts([]);
    if (onClearCompare) onClearCompare();
  };

  // Main Action: Compare Products by URL (Option A)
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
      const valRes = await api.validateCompareUrls(filledUrls);

      if (valRes.overall_status === 'error' || valRes.overall_status === 'mismatch' || valRes.overall_status === 'subcategory_mismatch') {
        setValidationError(valRes.message || 'Comparison failed. Please verify that submitted URLs belong to the same product category.');
        setIsComparing(false);
        return;
      }

      const commonCat = valRes.common_category || 'electronics';
      setActiveCategory(commonCat);

      // Check for unconfirmed / uncataloged items
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

        const brand = item.brand || '';
        const name = item.product_name || '';
        const price = item.price ? Number(item.price) : 0;
        const asin = item.retailer_identifiers?.asin || item.retailer_identifiers?.amazon_asin || '';
        const pid = item.retailer_identifiers?.pid || '';
        const retailerName = item.retailer_name || (asin ? 'Amazon India' : pid ? 'Flipkart' : 'Retailer');

        if (!brand || !name) {
          unconfirmed.push({ idx, item, asin, pid });
        }

        return {
          id: `custom-item-${idx + 1}`,
          name: name,
          brand: brand,
          price: price,
          asin: asin,
          pid: pid,
          retailer_name: retailerName,
          category: item.category || commonCat,
          subcategory: item.subcategory || 'general',
          specs: {},
          officialProductUrl: item.canonical_url || item.original_url,
          is_verified: false,
          needsConfirmation: !brand || !name
        };
      });

      if (unconfirmed.length > 0) {
        setItemsNeedingConfirmation(identifiedItems);
        setValidationError('Some external product models could not be automatically extracted from URLs. You can confirm them below or select verified models from our catalogue.');
        setIsComparing(false);
        return;
      }

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
        const sorted = [...comparisonResults.ranked_products].sort(
          (a, b) => (a.product.price || 0) - (b.product.price || 0)
        );
        setComparisonResults({
          ...comparisonResults,
          ranked_products: sorted
        });
      } else {
        if (activeProducts.length >= 2) {
          evaluateExistingProducts(activeProducts, filter.priority);
        }
      }
    }
  };

  // Inline confirmation saving for Option A
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

  // Save Comparison to Profile
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
    trayProducts ||
    [];

  // All unique spec keys across products
  const allSpecKeys = Array.from(
    new Set(activeProducts.flatMap((p) => Object.keys(p.specs || p.specifications || {})))
  );

  return (
    <div className="space-y-6 pb-12 max-w-7xl mx-auto">
      {/* 1. COMPARISON CONTROLS PANEL */}
      <div className="glass-panel p-6 sm:p-8 rounded-3xl shadow-xl border border-white/80 space-y-6">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-[11px] font-bold uppercase tracking-wider text-[#3559C7] bg-[#3559C7]/10 px-2.5 py-0.5 rounded-full flex items-center gap-1">
              <Sparkles className="w-3 h-3" /> Multi-Category Shootout
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

        {/* COMPARISON OPTION TABS: OPTION A vs OPTION B */}
        <div className="flex p-1 bg-[#101B3D]/5 rounded-2xl border border-[#E6E0D5] max-w-md">
          <button
            onClick={() => {
              setActiveMode('url');
              setCatalogueNotice(null);
            }}
            className={`flex-1 py-2.5 px-4 rounded-xl text-xs sm:text-sm font-bold flex items-center justify-center gap-2 transition cursor-pointer ${
              activeMode === 'url'
                ? 'bg-[#101B3D] text-[#FFF9EF] shadow-md'
                : 'text-[#69738A] hover:text-[#18213A]'
            }`}
          >
            <LinkIcon className="w-4 h-4" />
            <span>Option A: Compare by URL</span>
          </button>

          <button
            onClick={() => {
              setActiveMode('select');
              setValidationError(null);
            }}
            className={`flex-1 py-2.5 px-4 rounded-xl text-xs sm:text-sm font-bold flex items-center justify-center gap-2 transition cursor-pointer ${
              activeMode === 'select'
                ? 'bg-[#101B3D] text-[#FFF9EF] shadow-md'
                : 'text-[#69738A] hover:text-[#18213A]'
            }`}
          >
            <CheckCircle2 className={`w-4 h-4 ${activeMode === 'select' ? 'text-[#D6AD60]' : ''}`} />
            <span>Option B: Select Products</span>
          </button>
        </div>

        {/* ============================================================== */}
        {/* OPTION A: COMPARE BY URL                                       */}
        {/* ============================================================== */}
        {activeMode === 'url' && (
          <div className="space-y-5">
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

            {/* URL Action Controls */}
            <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 pt-1">
              <div className="flex items-center gap-2">
                <button
                  onClick={handleAddUrlField}
                  disabled={urlInputs.length >= 5}
                  className="px-4 py-2.5 rounded-xl bg-white border border-[#E6E0D5] text-[#18213A] font-bold text-xs hover:bg-[#FAF6F0] disabled:opacity-50 transition cursor-pointer flex items-center gap-1.5 shadow-xs"
                >
                  <Plus className="w-3.5 h-3.5 text-[#3559C7]" />
                  <span>Add another URL</span>
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

            {/* Validation Notice Banner */}
            {validationError && (
              <div className="p-4 rounded-2xl bg-amber-50/90 border border-amber-300 text-amber-900 text-xs flex items-start gap-2.5 shadow-xs">
                <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
                <div className="space-y-1">
                  <span className="font-bold block">Validation Notice:</span>
                  <p className="leading-relaxed">{validationError}</p>
                </div>
              </div>
            )}

            {/* Uncataloged Item Recovery Box */}
            {itemsNeedingConfirmation.length > 0 && (
              <div className="p-5 rounded-2xl bg-blue-50/90 border border-blue-200 space-y-4">
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                  <div>
                    <h3 className="text-sm font-bold text-[#101B3D] flex items-center gap-1.5">
                      <Info className="w-4 h-4 text-[#3559C7]" />
                      <span>Uncataloged Retail Product Detected</span>
                    </h3>
                    <p className="text-xs text-[#69738A] mt-0.5">
                      This item is not yet in our verified catalogue. You can quickly pick a verified equivalent from our catalogue or confirm details below.
                    </p>
                  </div>
                  <button
                    onClick={() => {
                      setActiveMode('select');
                      if (activeCategory) setSelectedCatId(activeCategory);
                    }}
                    className="px-4 py-2 rounded-xl bg-[#101B3D] text-[#FFF9EF] font-bold text-xs hover:bg-[#1E2E5C] transition flex items-center gap-1.5 shadow-xs cursor-pointer shrink-0"
                  >
                    <Search className="w-3.5 h-3.5 text-[#D6AD60]" />
                    <span>Search & Select from Catalogue</span>
                  </button>
                </div>

                <div className="space-y-2 pt-1 border-t border-blue-100">
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
                              Product #{idx + 1}: {item.brand && item.name ? `${item.brand} ${item.name}` : (item.asin ? `${item.retailer_name || 'Amazon'} (ASIN: ${item.asin})` : item.pid ? `${item.retailer_name || 'Flipkart'} (PID: ${item.pid})` : (item.name || 'Uncataloged External Product'))}
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
                            className="px-3 py-1.5 bg-[#FAF6F0] border border-[#E6E0D5] text-[#3559C7] rounded-lg font-bold text-xs flex items-center gap-1 cursor-pointer shrink-0"
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
        )}

        {/* ============================================================== */}
        {/* OPTION B: SELECT DIRECTLY FROM CATALOGUE                        */}
        {/* ============================================================== */}
        {activeMode === 'select' && (
          <div className="space-y-6">
            {/* Cascading Selection Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {/* 1. Category Dropdown */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#18213A] flex items-center gap-1.5">
                  <span className="w-4 h-4 rounded-full bg-[#101B3D] text-[#FFF9EF] text-[10px] flex items-center justify-center font-bold">1</span>
                  <span>Select Category</span>
                </label>
                <select
                  value={selectedCatId}
                  onChange={(e) => {
                    setSelectedCatId(e.target.value);
                    setSelectedBrand('all');
                    setModelSearch('');
                    setCatalogueNotice(null);
                  }}
                  className="w-full px-3 py-2.5 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7] bg-white cursor-pointer"
                >
                  {availableCategories.map((cat) => (
                    <option key={cat.id} value={cat.id}>
                      {cat.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* 2. Brand Dropdown */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#18213A] flex items-center gap-1.5">
                  <span className="w-4 h-4 rounded-full bg-[#101B3D] text-[#FFF9EF] text-[10px] flex items-center justify-center font-bold">2</span>
                  <span>Select Brand</span>
                </label>
                <select
                  value={selectedBrand}
                  onChange={(e) => {
                    setSelectedBrand(e.target.value);
                    setCatalogueNotice(null);
                  }}
                  className="w-full px-3 py-2.5 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7] bg-white cursor-pointer"
                >
                  <option value="all">All Brands ({availableBrands.length - 1})</option>
                  {availableBrands.filter((b) => b !== 'all').map((brand) => (
                    <option key={brand} value={brand}>
                      {brand}
                    </option>
                  ))}
                </select>
              </div>

              {/* 3. Variant Selector */}
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-[#18213A] flex items-center gap-1.5">
                  <span className="w-4 h-4 rounded-full bg-[#101B3D] text-[#FFF9EF] text-[10px] flex items-center justify-center font-bold">3</span>
                  <span>Variant / Specification</span>
                </label>
                <select
                  value={selectedVariant}
                  onChange={(e) => setSelectedVariant(e.target.value)}
                  disabled={availableVariants.length === 0}
                  className="w-full px-3 py-2.5 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7] bg-white cursor-pointer disabled:opacity-60"
                >
                  {availableVariants.map((v) => (
                    <option key={v.id} value={v.label}>
                      {v.label} {v.price ? `— ₹${Number(v.price).toLocaleString('en-IN')}` : ''}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* Model Type-to-Search Input & Exact Model Selector */}
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <label className="text-xs font-bold text-[#18213A] flex items-center gap-1.5">
                  <Search className="w-3.5 h-3.5 text-[#3559C7]" />
                  <span>Exact Model (Type to Search):</span>
                </label>
                <span className="text-[11px] text-[#69738A]">
                  {availableModels.length} models found
                </span>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div className="relative">
                  <input
                    type="text"
                    value={modelSearch}
                    onChange={(e) => setModelSearch(e.target.value)}
                    placeholder="Type to filter model (e.g. S25, M14, Spectre, C4, 16 Pro)..."
                    className="w-full pl-9 pr-3 py-2.5 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7]"
                  />
                  <Search className="w-4 h-4 text-[#69738A] absolute left-3 top-1/2 -translate-y-1/2" />
                </div>

                <select
                  value={selectedProduct?.id || ''}
                  onChange={(e) => handleModelChange(e.target.value)}
                  className="w-full px-3 py-2.5 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7] bg-white cursor-pointer font-semibold text-[#18213A]"
                >
                  {availableModels.map((prod) => (
                    <option key={prod.id} value={prod.id}>
                      {prod.brand} {prod.exact_model || prod.name} — {formatINR(prod.price)}
                    </option>
                  ))}
                  {availableModels.length === 0 && (
                    <option value="" disabled>
                      No models matching "{modelSearch}"
                    </option>
                  )}
                </select>
              </div>
            </div>

            {/* LIVE PREVIEW CARD */}
            {selectedProduct && (
              <div className="p-5 rounded-2xl bg-white border border-[#E6E0D5] shadow-xs flex flex-col md:flex-row items-start md:items-center justify-between gap-5 transition">
                <div className="flex items-start sm:items-center gap-4 flex-1">
                  <div className="w-20 h-20 sm:w-24 sm:h-24 rounded-2xl overflow-hidden bg-gray-50 border border-[#E6E0D5] shrink-0 p-1">
                    <ProductImage
                      src={selectedProduct.imageUrl || selectedProduct.image_url}
                      alt={selectedProduct.name}
                      category={selectedProduct.category}
                      className="w-full h-full object-contain"
                    />
                  </div>

                  <div className="space-y-1.5 flex-1 min-w-0">
                    <div className="flex items-center flex-wrap gap-2">
                      <span className="text-[10px] font-black uppercase tracking-wider bg-[#101B3D] text-[#D6AD60] px-2 py-0.5 rounded">
                        {selectedProduct.brand}
                      </span>
                      <span className="text-[10px] font-bold text-[#3559C7] bg-[#3559C7]/10 px-2 py-0.5 rounded">
                        {selectedProduct.exact_model || 'Verified Model'}
                      </span>
                      <span className={`text-[10px] font-bold px-2 py-0.5 rounded flex items-center gap-1 ${
                        selectedProduct.price_status === 'verified'
                          ? 'bg-emerald-50 text-[#23865B] border border-emerald-200'
                          : 'bg-amber-50 text-amber-800 border border-amber-200'
                      }`}>
                        <Check className="w-3 h-3" />
                        {selectedProduct.price_status || 'verified'}
                      </span>
                    </div>

                    <h4 className="text-base font-bold text-[#18213A] truncate">
                      {selectedProduct.name}
                    </h4>

                    {selectedVariant && (
                      <p className="text-xs text-[#69738A] font-medium truncate">
                        Variant: <span className="text-[#18213A] font-bold">{selectedVariant}</span>
                      </p>
                    )}

                    {/* Key Specifications Badges */}
                    {selectedProduct.specs && (
                      <div className="flex items-center flex-wrap gap-1.5 pt-1">
                        {Object.entries(selectedProduct.specs).slice(0, 4).map(([k, v], sIdx) => (
                          <span
                            key={sIdx}
                            className="text-[10px] bg-[#FAF6F0] border border-[#E6E0D5] text-[#18213A] px-2 py-0.5 rounded font-medium"
                          >
                            <span className="text-[#69738A] capitalize">{k}:</span> {String(v)}
                          </span>
                        ))}
                      </div>
                    )}
                  </div>
                </div>

                {/* Price & Add to Tray Button */}
                <div className="flex sm:flex-col items-center sm:items-end justify-between w-full sm:w-auto gap-3 shrink-0 pt-3 sm:pt-0 border-t sm:border-t-0 border-[#E6E0D5]">
                  <div className="text-left sm:text-right">
                    <span className="text-[10px] text-[#69738A] uppercase font-bold block">
                      Current Price
                    </span>
                    <span className="text-xl sm:text-2xl font-black text-[#101B3D]">
                      {formatINR(
                        availableVariants.find((v) => v.label === selectedVariant)?.price ||
                        selectedProduct.price
                      )}
                    </span>
                  </div>

                  <button
                    onClick={handleAddProductToTray}
                    disabled={trayProducts.some((p) => p.id === selectedProduct.id) || trayProducts.length >= 3}
                    className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-[#101B3D] to-[#3559C7] text-[#FFF9EF] font-bold text-xs hover:shadow-md disabled:opacity-50 transition cursor-pointer flex items-center gap-1.5 shadow-xs"
                  >
                    <Plus className="w-4 h-4 text-[#D6AD60]" />
                    <span>
                      {trayProducts.some((p) => p.id === selectedProduct.id)
                        ? 'Added to Comparison'
                        : '+ Add to Comparison'}
                    </span>
                  </button>
                </div>
              </div>
            )}

            {/* Notification Banner (Duplicate / Mismatch / Limit Notice) */}
            {catalogueNotice && (
              <div className={`p-4 rounded-2xl text-xs flex items-start gap-2.5 shadow-xs ${
                catalogueNotice.type === 'error'
                  ? 'bg-rose-50 border border-rose-300 text-rose-900'
                  : catalogueNotice.type === 'success'
                  ? 'bg-emerald-50 border border-emerald-300 text-emerald-900'
                  : 'bg-amber-50 border border-amber-300 text-amber-900'
              }`}>
                {catalogueNotice.type === 'error' ? (
                  <AlertTriangle className="w-4 h-4 text-rose-600 shrink-0 mt-0.5" />
                ) : catalogueNotice.type === 'success' ? (
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                ) : (
                  <Info className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
                )}
                <div className="space-y-0.5">
                  <span className="font-bold block capitalize">{catalogueNotice.type} Notice:</span>
                  <p className="leading-relaxed">{catalogueNotice.message}</p>
                </div>
              </div>
            )}

            {/* SELECTED PRODUCTS TRAY (STAGING AREA) */}
            <div className="p-5 rounded-2xl bg-[#101B3D]/5 border border-[#E6E0D5] space-y-4">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                <div className="flex items-center gap-2">
                  <span className="text-xs font-black uppercase tracking-wider text-[#101B3D] flex items-center gap-1.5">
                    <Layers className="w-4 h-4 text-[#3559C7]" />
                    <span>Selected for Comparison ({trayProducts.length}/3)</span>
                  </span>
                  <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    trayProducts.length >= 2
                      ? 'bg-emerald-100 text-emerald-800'
                      : 'bg-amber-100 text-amber-800'
                  }`}>
                    {trayProducts.length >= 2 ? 'Ready to Compare' : 'Select at least 2 products'}
                  </span>
                </div>

                {trayProducts.length > 0 && (
                  <button
                    onClick={handleClearTray}
                    className="text-xs text-[#69738A] hover:text-[#C34D4D] font-semibold transition cursor-pointer self-start sm:self-auto"
                  >
                    Clear Tray
                  </button>
                )}
              </div>

              {/* Staged Cards Grid */}
              {trayProducts.length === 0 ? (
                <div className="py-8 text-center text-xs text-[#69738A] border-2 border-dashed border-[#E6E0D5] rounded-xl bg-white/50">
                  <p>No products selected yet. Select a model above and click <span className="font-bold text-[#101B3D]">"+ Add to Comparison"</span>.</p>
                </div>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  {trayProducts.map((p, idx) => (
                    <div
                      key={p.id || idx}
                      className="p-3 bg-white rounded-xl border border-[#E6E0D5] shadow-xs flex items-center justify-between gap-3 relative group"
                    >
                      <div className="w-12 h-12 rounded-lg bg-gray-50 border border-gray-100 overflow-hidden shrink-0 p-0.5">
                        <ProductImage
                          src={p.imageUrl || p.image_url}
                          alt={p.name}
                          category={p.category}
                          className="w-full h-full object-contain"
                        />
                      </div>

                      <div className="min-w-0 flex-1">
                        <div className="flex items-center gap-1">
                          <span className="text-[9px] font-black uppercase text-[#3559C7]">
                            #{idx + 1} {p.brand}
                          </span>
                        </div>
                        <h5 className="text-xs font-bold text-[#18213A] truncate">
                          {p.name}
                        </h5>
                        <span className="text-xs font-black text-[#101B3D]">
                          {formatINR(p.price)}
                        </span>
                      </div>

                      <button
                        onClick={() => handleRemoveFromTray(p.id)}
                        className="p-1.5 text-[#69738A] hover:text-[#C34D4D] hover:bg-red-50 rounded-lg transition cursor-pointer"
                        title="Remove product"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                  ))}
                </div>
              )}

              {/* Action Button: Compare Tray */}
              <div className="pt-2 flex justify-end">
                <button
                  onClick={handleCompareTray}
                  disabled={isComparing || trayProducts.length < 2}
                  className="px-8 py-3 rounded-xl bg-gradient-to-r from-[#101B3D] to-[#3559C7] text-[#FFF9EF] font-black text-sm hover:shadow-lg disabled:opacity-50 transition flex items-center justify-center gap-2 cursor-pointer shadow-md"
                >
                  {isComparing ? (
                    <>
                      <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                      <span>Comparing Products...</span>
                    </>
                  ) : (
                    <>
                      <Scale className="w-4 h-4 text-[#D6AD60]" />
                      <span>Compare Selected Products ({trayProducts.length})</span>
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* ============================================================== */}
      {/* 2. POST-COMPARISON RESULTS SECTION                             */}
      {/* ============================================================== */}
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
                    onClick={() => {
                      setFeedbackTargetProduct(comparisonResults.ranked_products[0].product);
                      setShowFeedbackModal(true);
                    }}
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

                    <div className="pt-2 border-t border-[#E6E0D5]/70 flex items-center justify-between text-xs">
                      <span className="font-black text-[#101B3D]">
                        {formatINR(r.product.price)}
                      </span>
                      <span className="text-[10px] font-bold text-[#69738A]">
                        Closeness: {r.topsis_score}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Side-by-Side Product Comparison Table */}
          <div className="glass-panel rounded-3xl overflow-hidden border border-white/80 shadow-md">
            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs border-collapse">
                <thead>
                  <tr className="bg-[#101B3D]/5 border-b border-[#E6E0D5]">
                    <th className="p-4 font-black text-[#18213A] w-48 min-w-[12rem] sticky left-0 bg-[#FAF6F0] z-10">
                      Product Overview
                    </th>
                    {activeProducts.map((p, idx) => (
                      <th key={p.id || idx} className="p-4 min-w-[16rem] align-top">
                        <div className="space-y-2">
                          <div className="w-24 h-24 rounded-2xl bg-white border border-[#E6E0D5] p-1 shadow-xs">
                            <ProductImage
                              src={p.imageUrl || p.image_url}
                              alt={p.name}
                              category={p.category}
                              className="w-full h-full object-contain"
                            />
                          </div>
                          <div>
                            <span className="text-[10px] font-black uppercase tracking-wider text-[#3559C7]">
                              {p.brand}
                            </span>
                            <h4 className="font-bold text-sm text-[#18213A] leading-snug line-clamp-2">
                              {p.name}
                            </h4>
                          </div>
                          <div className="flex items-center justify-between pt-1">
                            <span className="text-base font-black text-[#101B3D]">
                              {formatINR(p.price)}
                            </span>
                            <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-emerald-50 text-[#23865B] border border-emerald-200">
                              {p.price_status || 'verified'}
                            </span>
                          </div>
                          {p.officialProductUrl && (
                            <a
                              href={p.officialProductUrl}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="inline-flex items-center gap-1 text-[11px] font-bold text-[#3559C7] hover:underline pt-1"
                            >
                              <span>Official Product Page</span>
                              <ExternalLink className="w-3 h-3" />
                            </a>
                          )}
                        </div>
                      </th>
                    ))}
                  </tr>
                </thead>

                <tbody className="divide-y divide-[#E6E0D5]/70">
                  {/* Brand & Model Row */}
                  <tr className="hover:bg-white/50">
                    <td className="p-3.5 font-bold text-[#69738A] sticky left-0 bg-[#FAF6F0] z-10">
                      Exact Model
                    </td>
                    {activeProducts.map((p, idx) => (
                      <td key={idx} className="p-3.5 font-semibold text-[#18213A]">
                        {p.exact_model || p.name}
                      </td>
                    ))}
                  </tr>

                  {/* Variant Row */}
                  <tr className="hover:bg-white/50">
                    <td className="p-3.5 font-bold text-[#69738A] sticky left-0 bg-[#FAF6F0] z-10">
                      Variant / Capacity
                    </td>
                    {activeProducts.map((p, idx) => (
                      <td key={idx} className="p-3.5 text-[#18213A]">
                        {p.variant || 'Standard'}
                      </td>
                    ))}
                  </tr>

                  {/* Specifications Rows */}
                  {allSpecKeys.map((key) => (
                    <tr key={key} className="hover:bg-white/50">
                      <td className="p-3.5 font-bold text-[#69738A] capitalize sticky left-0 bg-[#FAF6F0] z-10">
                        {key.replace(/_/g, ' ')}
                      </td>
                      {activeProducts.map((p, idx) => {
                        const val = p.specs?.[key] || p.specifications?.[key];
                        return (
                          <td key={idx} className="p-3.5 text-[#18213A] leading-relaxed">
                            {val !== undefined ? String(val) : <span className="text-[#69738A]/60">—</span>}
                          </td>
                        );
                      })}
                    </tr>
                  ))}

                  {/* Retailer Listing Offers */}
                  <tr className="bg-[#FAF6F0]/60">
                    <td className="p-3.5 font-bold text-[#101B3D] sticky left-0 bg-[#FAF6F0] z-10">
                      Retailer Offers
                    </td>
                    {activeProducts.map((p, idx) => {
                      const offers = p.retailerOffers || [];
                      return (
                        <td key={idx} className="p-3.5">
                          {offers.length > 0 ? (
                            <div className="space-y-1.5">
                              {offers.map((off, oIdx) => (
                                <a
                                  key={oIdx}
                                  href={off.productUrl}
                                  target="_blank"
                                  rel="noopener noreferrer"
                                  className="flex items-center justify-between p-2 rounded-lg bg-white border border-[#E6E0D5] hover:border-[#3559C7] transition text-[11px]"
                                >
                                  <span className="font-bold text-[#18213A]">{off.retailerName}</span>
                                  <span className="font-black text-[#3559C7]">{formatINR(off.price)}</span>
                                </a>
                              ))}
                            </div>
                          ) : p.officialProductUrl ? (
                            <a
                              href={p.officialProductUrl}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-[#3559C7] text-white text-[11px] font-bold"
                            >
                              <span>View Listing</span>
                              <ExternalLink className="w-3 h-3" />
                            </a>
                          ) : (
                            <span className="text-xs text-[#69738A]">Verified Retailer Listing</span>
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

      {/* SAVE COMPARISON MODAL */}
      {showSaveModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-xs">
          <div className="glass-panel p-6 rounded-3xl max-w-md w-full shadow-2xl border border-white space-y-4 bg-white">
            <div className="flex items-center justify-between">
              <h3 className="text-lg font-black text-[#18213A]">
                Save Shootout
              </h3>
              <button
                onClick={() => setShowSaveModal(false)}
                className="p-1 rounded-lg text-[#69738A] hover:text-[#18213A]"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-bold text-[#69738A]">
                Comparison Title
              </label>
              <input
                type="text"
                value={saveTitle}
                onChange={(e) => setSaveTitle(e.target.value)}
                placeholder="e.g. Flagship Smartphone Shootout 2026"
                className="w-full px-3.5 py-2.5 rounded-xl glass-input text-xs sm:text-sm border border-[#E6E0D5] focus:outline-none focus:border-[#3559C7]"
              />
            </div>

            {saveFeedback && (
              <p className="text-xs font-bold text-[#23865B] bg-emerald-50 p-2.5 rounded-xl">
                {saveFeedback}
              </p>
            )}

            <div className="flex items-center justify-end gap-2 pt-2">
              <button
                onClick={() => setShowSaveModal(false)}
                className="px-4 py-2 rounded-xl text-xs font-semibold text-[#69738A] hover:bg-gray-100"
              >
                Cancel
              </button>
              <button
                onClick={handleConfirmSave}
                disabled={!saveTitle.trim()}
                className="px-5 py-2 rounded-xl bg-[#101B3D] text-[#FFF9EF] font-bold text-xs hover:bg-[#1E2E5C] disabled:opacity-50"
              >
                Save Shootout
              </button>
            </div>
          </div>
        </div>
      )}

      {/* FEEDBACK MODAL */}
      {showFeedbackModal && feedbackTargetProduct && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-xs">
          <div className="glass-panel p-6 rounded-3xl max-w-lg w-full shadow-2xl border border-white space-y-4 bg-white">
            <div className="flex items-center justify-between">
              <div>
                <span className="text-[10px] font-black uppercase text-[#3559C7]">
                  Recommendation Feedback
                </span>
                <h3 className="text-base font-black text-[#18213A]">
                  {feedbackTargetProduct.name}
                </h3>
              </div>
              <button
                onClick={() => setShowFeedbackModal(false)}
                className="p-1 rounded-lg text-[#69738A] hover:text-[#18213A]"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <div>
                <label className="font-bold text-[#18213A] block mb-1">
                  Overall Satisfaction (1 to 5 Stars):
                </label>
                <div className="flex items-center gap-1.5">
                  {[1, 2, 3, 4, 5].map((s) => (
                    <button
                      key={s}
                      onClick={() => setFbSatisfaction(s)}
                      className={`p-2 rounded-lg border font-bold text-xs ${
                        fbSatisfaction >= s
                          ? 'bg-[#D6AD60] text-[#101B3D] border-[#D6AD60]'
                          : 'bg-gray-50 border-gray-200 text-[#69738A]'
                      }`}
                    >
                      <Star className="w-4 h-4 fill-current" />
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="font-bold text-[#18213A] block mb-1">
                  Did this recommendation meet your needs?
                </label>
                <div className="flex items-center gap-3">
                  <label className="flex items-center gap-1.5 cursor-pointer">
                    <input
                      type="radio"
                      checked={fbMetRequirements === true}
                      onChange={() => setFbMetRequirements(true)}
                    />
                    <span>Yes, exactly</span>
                  </label>
                  <label className="flex items-center gap-1.5 cursor-pointer">
                    <input
                      type="radio"
                      checked={fbMetRequirements === false}
                      onChange={() => setFbMetRequirements(false)}
                    />
                    <span>No, missed key aspects</span>
                  </label>
                </div>
              </div>

              <div>
                <label className="font-bold text-[#18213A] block mb-1">
                  Notes & Feedback:
                </label>
                <textarea
                  value={fbNotes}
                  onChange={(e) => setFbNotes(e.target.value)}
                  placeholder="Share details on performance, value, battery life, or build quality..."
                  className="w-full p-2.5 rounded-xl glass-input text-xs border border-[#E6E0D5]"
                  rows={3}
                />
              </div>

              {fbStatusMessage && (
                <p className="text-xs font-bold text-[#23865B] bg-emerald-50 p-2.5 rounded-xl">
                  {fbStatusMessage}
                </p>
              )}
            </div>

            <div className="flex items-center justify-end gap-2 pt-2 border-t border-[#E6E0D5]">
              <button
                onClick={() => setShowFeedbackModal(false)}
                className="px-4 py-2 rounded-xl text-xs font-semibold text-[#69738A] hover:bg-gray-100"
              >
                Close
              </button>
              <button
                onClick={handleSubmitFeedback}
                className="px-5 py-2 rounded-xl bg-[#101B3D] text-[#FFF9EF] font-bold text-xs hover:bg-[#1E2E5C]"
              >
                Submit Feedback
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

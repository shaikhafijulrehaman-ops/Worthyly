import React, { useState, useMemo } from 'react';
import { motion } from 'framer-motion';
import {
  Search,
  Filter,
  SlidersHorizontal,
  Star,
  Scale,
  Bookmark,
  Eye,
  Calendar,
  X,
  ExternalLink,
  ShieldCheck,
  RotateCcw,
  ShoppingBag,
  Sparkles,
  LayoutGrid,
  Laptop,
  Footprints,
  Utensils,
  Armchair,
  Dumbbell,
  GraduationCap,
  Smartphone,
  BookOpen,
  Newspaper,
  Headphones,
  Flame,
  Package
} from 'lucide-react';
import { formatINR } from '../utils/currency';
import ProductImage from '../components/ProductImage';

const CATEGORY_ICONS = {
  all: LayoutGrid,
  smartphones: Smartphone,
  laptops: Laptop,
  books: BookOpen,
  magazines: Newspaper,
  consumer_electronics: Headphones,
  fitness_equipment: Dumbbell,
  kitchen_chimneys: Flame,
  nutrition: Package,
  electronics: Laptop,
  footwear: Footprints,
  home_kitchen: Utensils,
  furniture: Armchair,
  fitness: Dumbbell,
  education: GraduationCap
};

export default function PageProductExplorer({
  products = [],
  categories = [],
  onViewDetails,
  onAddToCompare,
  comparedIds = [],
  onToggleSave,
  savedIds = [],
  initialCategory = 'all',
  onStartFinding
}) {
  const [search, setSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState(initialCategory);
  const [selectedBrand, setSelectedBrand] = useState('all');
  const [minPrice, setMinPrice] = useState('');
  const [maxPrice, setMaxPrice] = useState('');
  const [sortBy, setSortBy] = useState('rating');

  // Extract unique brands from active category
  const availableBrands = useMemo(() => {
    let prods = products;
    if (selectedCategory !== 'all') {
      prods = prods.filter((p) => p.category === selectedCategory);
    }
    const brands = new Set(prods.map((p) => p.brand).filter(Boolean));
    return ['all', ...Array.from(brands).sort()];
  }, [products, selectedCategory]);

  const filteredProducts = useMemo(() => {
    let list = [...products];

    if (selectedCategory !== 'all') {
      list = list.filter((p) => p.category === selectedCategory);
    }

    if (selectedBrand !== 'all') {
      list = list.filter((p) => p.brand.toLowerCase() === selectedBrand.toLowerCase());
    }

    if (minPrice) {
      list = list.filter((p) => p.price >= Number(minPrice));
    }

    if (maxPrice) {
      list = list.filter((p) => p.price <= Number(maxPrice));
    }

    if (search.trim()) {
      const q = search.toLowerCase();
      list = list.filter(
        (p) =>
          p.name.toLowerCase().includes(q) ||
          p.brand.toLowerCase().includes(q) ||
          Object.values(p.specs || {}).some((v) => String(v).toLowerCase().includes(q)) ||
          p.features?.some((f) => f.toLowerCase().includes(q))
      );
    }

    // Sort
    if (sortBy === 'price_asc') {
      list.sort((a, b) => a.price - b.price);
    } else if (sortBy === 'price_desc') {
      list.sort((a, b) => b.price - a.price);
    } else if (sortBy === 'rating') {
      list.sort((a, b) => b.rating - a.rating);
    } else if (sortBy === 'review_count') {
      list.sort((a, b) => b.reviewCount - a.reviewCount);
    } else {
      list.sort((a, b) => a.name.localeCompare(b.name));
    }

    return list;
  }, [products, selectedCategory, selectedBrand, minPrice, maxPrice, search, sortBy]);

  const handleResetFilters = () => {
    setSearch('');
    setSelectedCategory('all');
    setSelectedBrand('all');
    setMinPrice('');
    setMaxPrice('');
    setSortBy('rating');
  };

  return (
    <div className="space-y-6 pb-12">
      {/* Header Banner */}
      <div className="glass-panel p-5 sm:p-6 rounded-2xl flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div className="space-y-1">
          <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
            Verified Indian Catalog
          </span>
          <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
            Explore Products
          </h1>
          <p className="text-xs md:text-sm text-[#69738A]">
            Search, filter, and inspect verified specifications across all available models.
          </p>
        </div>

        {onStartFinding && (
          <button
            onClick={onStartFinding}
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-bold bg-[#101B3D] text-[#FFF9EF] hover:bg-[#17264F] transition shadow-xs self-start md:self-auto cursor-pointer"
          >
            <Sparkles className="w-3.5 h-3.5 text-[#D6AD60]" />
            <span>Launch Match Wizard</span>
          </button>
        )}
      </div>

      {/* Filter & Search Bar */}
      <div className="glass-panel p-4 sm:p-5 rounded-2xl space-y-3.5">
        {/* Search input & Sort */}
        <div className="grid grid-cols-1 md:grid-cols-12 gap-3">
          <div className="md:col-span-8 relative">
            <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-[#69738A]" />
            <input
              type="text"
              placeholder="Search by product name, brand, processor, RAM, features..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-xs sm:text-sm text-[#18213A]"
            />
            {search && (
              <button
                onClick={() => setSearch('')}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            )}
          </div>

          <div className="md:col-span-4 flex items-center gap-2">
            <label className="text-xs font-bold text-[#69738A] shrink-0">Sort By:</label>
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="w-full px-3 py-2 rounded-xl glass-input text-xs font-semibold text-[#18213A]"
            >
              <option value="rating">Highest Rating</option>
              <option value="price_asc">Price: Low to High</option>
              <option value="price_desc">Price: High to Low</option>
              <option value="review_count">Most Reviews</option>
              <option value="name">Product Name (A-Z)</option>
            </select>
          </div>
        </div>

        {/* Circular Categories Bar (Streaming-App Inspired Circular Sketch UI) */}
        <div className="space-y-2 pt-1 border-t border-white/60">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold uppercase tracking-wider text-[#69738A]">
              Filter by Category
            </span>
            <span className="text-[11px] text-[#69738A] font-medium">
              Showing {filteredProducts.length} of {products.length} products
            </span>
          </div>

          <div className="flex items-start gap-3 sm:gap-5 overflow-x-auto pb-1 pt-1 scrollbar-none">
            {/* All Categories Option */}
            <button
              onClick={() => {
                setSelectedCategory('all');
                setSelectedBrand('all');
              }}
              className="flex flex-col items-center justify-center group cursor-pointer focus:outline-none shrink-0"
              aria-label="All Categories"
            >
              <div
                className={`w-11 h-11 sm:w-12 sm:h-12 rounded-full flex items-center justify-center transition-all duration-200 ${
                  selectedCategory === 'all'
                    ? 'bg-gradient-to-br from-[#101B3D] via-[#17264F] to-[#3559C7] text-[#FFF9EF] ring-2 ring-[#D6AD60] shadow-md scale-105'
                    : 'bg-white/70 backdrop-blur-md text-[#18213A]/80 border border-white/90 shadow-xs group-hover:bg-white group-hover:text-[#3559C7] group-hover:scale-105 group-hover:shadow-md'
                }`}
              >
                <LayoutGrid className="w-5 h-5 transition-transform group-hover:scale-110" />
              </div>
              <span
                className={`text-[10px] sm:text-[11px] font-semibold text-center mt-1 leading-tight tracking-tight max-w-[70px] truncate ${
                  selectedCategory === 'all' ? 'text-[#101B3D] font-bold' : 'text-[#69738A] group-hover:text-[#18213A]'
                }`}
              >
                All
              </span>
              {selectedCategory === 'all' && (
                <span className="w-1.5 h-1.5 rounded-full bg-[#3559C7] mt-0.5" />
              )}
            </button>

            {/* Individual Categories */}
            {categories.map((c) => {
              const Icon = CATEGORY_ICONS[c.id] || Laptop;
              const isSelected = selectedCategory === c.id;

              return (
                <button
                  key={c.id}
                  onClick={() => {
                    setSelectedCategory(c.id);
                    setSelectedBrand('all');
                  }}
                  className="flex flex-col items-center justify-center group cursor-pointer focus:outline-none shrink-0"
                  aria-label={c.name}
                >
                  <div
                    className={`w-11 h-11 sm:w-12 sm:h-12 rounded-full flex items-center justify-center transition-all duration-200 ${
                      isSelected
                        ? 'bg-gradient-to-br from-[#101B3D] via-[#17264F] to-[#3559C7] text-[#FFF9EF] ring-2 ring-[#D6AD60] shadow-md scale-105'
                        : 'bg-white/70 backdrop-blur-md text-[#18213A]/80 border border-white/90 shadow-xs group-hover:bg-white group-hover:text-[#3559C7] group-hover:scale-105 group-hover:shadow-md'
                    }`}
                  >
                    <Icon className="w-5 h-5 transition-transform group-hover:scale-110" />
                  </div>
                  <span
                    className={`text-[10px] sm:text-[11px] font-semibold text-center mt-1 leading-tight tracking-tight max-w-[80px] truncate ${
                      isSelected ? 'text-[#101B3D] font-bold' : 'text-[#69738A] group-hover:text-[#18213A]'
                    }`}
                  >
                    {c.name.split(' ')[0]}
                  </span>
                  {isSelected && (
                    <span className="w-1.5 h-1.5 rounded-full bg-[#3559C7] mt-0.5" />
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Brand & Price Filters */}
        <div className="flex flex-wrap items-center gap-3 pt-2 border-t border-white/80 text-xs">
          <div className="flex items-center gap-1.5">
            <span className="font-bold text-[#69738A]">Brand:</span>
            <select
              value={selectedBrand}
              onChange={(e) => setSelectedBrand(e.target.value)}
              className="px-2.5 py-1.5 rounded-xl glass-input font-medium text-[#18213A]"
            >
              {availableBrands.map((b) => (
                <option key={b} value={b}>
                  {b === 'all' ? 'All Brands' : b}
                </option>
              ))}
            </select>
          </div>

          <div className="flex items-center gap-1.5">
            <span className="font-bold text-[#69738A]">Min Price (₹):</span>
            <input
              type="number"
              placeholder="₹ Min"
              value={minPrice}
              onChange={(e) => setMinPrice(e.target.value)}
              className="w-24 px-2.5 py-1.5 rounded-xl glass-input text-[#18213A]"
            />
          </div>

          <div className="flex items-center gap-1.5">
            <span className="font-bold text-[#69738A]">Max Price (₹):</span>
            <input
              type="number"
              placeholder="₹ Max"
              value={maxPrice}
              onChange={(e) => setMaxPrice(e.target.value)}
              className="w-24 px-2.5 py-1.5 rounded-xl glass-input text-[#18213A]"
            />
          </div>

          {(search || selectedCategory !== 'all' || selectedBrand !== 'all' || minPrice || maxPrice) && (
            <button
              onClick={handleResetFilters}
              className="ml-auto text-xs font-bold text-[#C34D4D] hover:underline flex items-center gap-1 cursor-pointer"
            >
              <RotateCcw className="w-3 h-3" /> Clear Filters
            </button>
          )}
        </div>
      </div>

      {/* Results Count Bar */}
      <div className="flex items-center justify-between text-xs text-[#69738A] px-1">
        <span>
          Showing <strong>{filteredProducts.length}</strong> verified product(s)
        </span>
        <span className="flex items-center gap-1 text-[#23865B] font-semibold">
          <ShieldCheck className="w-3.5 h-3.5" /> All prices verified in INR
        </span>
      </div>

      {/* Products Grid */}
      {filteredProducts.length === 0 ? (
        <div className="glass-panel p-6 rounded-2xl text-center space-y-3 max-w-md mx-auto my-6">
          <p className="text-sm font-bold text-[#18213A]">
            No products matched your exact filter combination.
          </p>
          <button
            onClick={handleResetFilters}
            className="px-4 py-2 bg-[#101B3D] text-[#FFF9EF] text-xs font-bold rounded-xl cursor-pointer hover:bg-[#17264F] transition shadow-xs"
          >
            Reset All Filters
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredProducts.map((p) => {
            const isCompared = comparedIds.includes(p.id);
            const isSaved = savedIds.includes(p.id);

            return (
              <motion.div
                key={p.id}
                initial={{ opacity: 0, y: 15 }}
                animate={{ opacity: 1, y: 0 }}
                className="glass-panel glass-card-hover rounded-2xl flex flex-col justify-between overflow-hidden border border-white/80 transition group h-full shadow-xs"
              >
                <div className="p-5 space-y-3">
                  {/* Image & Badges */}
                  <div className="aspect-16/10 rounded-xl overflow-hidden bg-white/40 border border-white/70 relative">
                    <ProductImage
                      src={p.imageUrl}
                      alt={p.name}
                      category={p.category}
                      brand={p.brand}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                    <span className="absolute top-2.5 left-2.5 bg-[#101B3D] text-[#FFF9EF] text-[10px] font-bold px-2 py-0.5 rounded-md">
                      {p.brand}
                    </span>
                    <span className="absolute top-2.5 right-2.5 bg-white/95 backdrop-blur-xs text-[#18213A] text-[10px] font-bold px-2 py-0.5 rounded-md border border-white/90 flex items-center gap-1 shadow-xs">
                      <Star className="w-3 h-3 fill-amber-400 text-amber-500" />
                      {p.rating}
                    </span>
                  </div>

                  {/* Title & Price */}
                  <div>
                    <h3 className="font-bold text-base text-[#18213A] line-clamp-1">
                      {p.name}
                    </h3>
                    <div className="flex items-baseline justify-between mt-1">
                      <span className="text-xl font-black text-[#101B3D]">
                        {formatINR(p.price)}
                      </span>
                      <span className="text-[11px] text-[#69738A]">
                        {p.reviewCount} reviews
                      </span>
                    </div>
                  </div>

                  {/* Highlight Specs */}
                  <div className="bg-white/60 backdrop-blur-md p-3 rounded-xl border border-white/80 text-[11px] space-y-1">
                    {Object.entries(p.specs || {}).slice(0, 3).map(([key, val]) => (
                      <div key={key} className="flex justify-between">
                        <span className="text-[#69738A] capitalize font-medium">{key}:</span>
                        <span className="text-[#18213A] font-semibold truncate max-w-[170px]">{String(val)}</span>
                      </div>
                    ))}
                  </div>

                  {/* Short Recommendation Tag */}
                  <p className="text-[11px] text-[#69738A] line-clamp-1 italic">
                    "{p.pros?.[0] || 'Meets verified specifications within its segment.'}"
                  </p>

                  <div className="flex items-center gap-1 text-[10px] text-[#69738A]">
                    <Calendar className="w-3 h-3 text-[#3559C7]" />
                    <span>Price verified: {new Date(p.lastVerified || p.lastVerifiedAt).toLocaleDateString()}</span>
                  </div>
                </div>

                {/* Footer Action Bar: Details, Buy Now, Compare, Save */}
                <div className="px-5 py-3 bg-white/50 backdrop-blur-md border-t border-white/80 flex items-center justify-between gap-2">
                  <button
                    onClick={() => onViewDetails(p)}
                    className="flex-1 py-2 px-3 bg-[#101B3D] text-[#FFF9EF] rounded-xl text-xs font-bold hover:bg-[#17264F] transition text-center cursor-pointer shadow-xs"
                  >
                    Details
                  </button>

                  {p.officialProductUrl && (
                    <a
                      href={p.officialProductUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="py-2 px-3 bg-[#3559C7] text-white rounded-xl text-xs font-bold hover:bg-[#2e4eb2] transition flex items-center gap-1 cursor-pointer shadow-xs"
                      title="Buy at Official Store"
                    >
                      <ShoppingBag className="w-3 h-3" />
                      <span>Buy</span>
                      <ExternalLink className="w-2.5 h-2.5" />
                    </a>
                  )}

                  <button
                    onClick={() => onAddToCompare(p)}
                    className={`p-2 rounded-xl border text-xs font-semibold transition cursor-pointer ${
                      isCompared
                        ? 'bg-[#3559C7] border-[#3559C7] text-white'
                        : 'glass-pill text-[#18213A] hover:bg-white'
                    }`}
                    title={isCompared ? 'In Comparison' : 'Add to Comparison'}
                  >
                    <Scale className="w-3.5 h-3.5" />
                  </button>

                  <button
                    onClick={() => onToggleSave(p.id)}
                    className={`p-2 rounded-xl border text-xs font-semibold transition cursor-pointer ${
                      isSaved
                        ? 'bg-[#D6AD60] border-[#D6AD60] text-[#101B3D]'
                        : 'glass-pill text-[#18213A] hover:bg-white'
                    }`}
                    title={isSaved ? 'Saved' : 'Save Product'}
                  >
                    <Bookmark className={`w-3.5 h-3.5 ${isSaved ? 'fill-current' : ''}`} />
                  </button>
                </div>
              </motion.div>
            );
          })}
        </div>
      )}
    </div>
  );
}

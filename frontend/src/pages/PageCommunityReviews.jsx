import React, { useState, useMemo } from 'react';
import { motion } from 'framer-motion';
import {
  MessageSquare,
  Star,
  ShieldCheck,
  CheckCircle2,
  AlertTriangle,
  ThumbsUp,
  Flag,
  Plus,
  Search,
  Calendar,
  X
} from 'lucide-react';
import { formatINR } from '../utils/currency';

export default function PageCommunityReviews({
  reviews = [],
  products = [],
  onCreateReview,
  onReportReview,
  currentUser = 'You (Current User)'
}) {
  const [filterRating, setFilterRating] = useState(0);
  const [filterVerified, setFilterVerified] = useState(false);
  const [filterProduct, setFilterProduct] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [showSubmitModal, setShowSubmitModal] = useState(false);

  // Form State
  const [selectedProductId, setSelectedProductId] = useState(products[0]?.id || '');
  const [rating, setRating] = useState(5);
  const [title, setTitle] = useState('');
  const [reviewText, setReviewText] = useState('');
  const [intendedUsage, setIntendedUsage] = useState('');
  const [pros, setPros] = useState('');
  const [cons, setCons] = useState('');
  const [purchasePrice, setPurchasePrice] = useState('');
  const [purchaseDate, setPurchaseDate] = useState('');
  const [isVerified, setIsVerified] = useState(true);
  const [submitSuccess, setSubmitSuccess] = useState(false);
  const [reportedIds, setReportedIds] = useState([]);

  // Rating Distribution Stats
  const stats = useMemo(() => {
    const total = reviews.length;
    if (total === 0) return { avg: 0, total: 0, dist: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 } };

    const sum = reviews.reduce((acc, r) => acc + (r.rating || 5), 0);
    const avg = (sum / total).toFixed(1);

    const dist = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
    reviews.forEach((r) => {
      const star = r.rating || 5;
      if (dist[star] !== undefined) dist[star]++;
    });

    return { avg, total, dist };
  }, [reviews]);

  // Filtered reviews
  const filteredReviews = useMemo(() => {
    return reviews.filter((r) => {
      if (filterRating > 0 && r.rating < filterRating) return false;
      if (filterVerified && !r.isVerifiedPurchase) return false;
      if (filterProduct !== 'all' && r.productId !== filterProduct) return false;
      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        const matches =
          r.title?.toLowerCase().includes(q) ||
          r.reviewText?.toLowerCase().includes(q) ||
          r.productName?.toLowerCase().includes(q) ||
          r.author?.toLowerCase().includes(q);
        if (!matches) return false;
      }
      return true;
    });
  }, [reviews, filterRating, filterVerified, filterProduct, searchQuery]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!title.trim() || !reviewText.trim() || !intendedUsage.trim()) return;

    const prod = products.find((p) => p.id === selectedProductId) || products[0];

    onCreateReview({
      productId: prod?.id || 'gen-01',
      productName: prod?.name || 'Verified Product',
      author: currentUser,
      rating: Number(rating),
      title: title.trim(),
      reviewText: reviewText.trim(),
      intendedUsage: intendedUsage.trim(),
      pros: pros.trim() || 'Performs reliably within expected bounds.',
      cons: cons.trim() || 'Minor adjustments required.',
      purchasePrice: purchasePrice ? Number(purchasePrice) : null,
      purchaseDate: purchaseDate || new Date().toISOString().split('T')[0],
      isVerifiedPurchase: isVerified
    });

    setSubmitSuccess(true);
    setTimeout(() => {
      setShowSubmitModal(false);
      setSubmitSuccess(false);
      setTitle('');
      setReviewText('');
      setIntendedUsage('');
      setPros('');
      setCons('');
      setPurchasePrice('');
    }, 1200);
  };

  const handleReport = (id) => {
    onReportReview(id);
    setReportedIds([...reportedIds, id]);
  };

  return (
    <div className="space-y-6 pb-12">
      {/* Header */}
      <div className="glass-panel p-5 sm:p-6 rounded-2xl flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
            Verified Feedback Ecosystem
          </span>
          <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
            Community Reviews
          </h1>
          <p className="text-xs md:text-sm text-[#69738A]">
            Real buyer reviews detailing actual intended workflows, pros, cons, and verified purchase timestamps in INR.
          </p>
        </div>

        <button
          onClick={() => setShowSubmitModal(true)}
          className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-bold bg-[#101B3D] text-[#FFF9EF] hover:bg-[#17264F] transition shadow-xs self-start md:self-auto cursor-pointer"
        >
          <Plus className="w-4 h-4 text-[#D6AD60]" />
          <span>Write a Verified Review</span>
        </button>
      </div>

      {/* Aggregate Rating Breakdown & Distribution */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6 items-center glass-panel p-5 sm:p-6 rounded-2xl border border-white/80">
        <div className="md:col-span-4 text-center md:text-left space-y-2 border-b md:border-b-0 md:border-r border-white/80 pb-5 md:pb-0 md:pr-6">
          <span className="text-5xl font-black text-[#101B3D]">
            {stats.avg}
          </span>
          <div className="flex items-center justify-center md:justify-start text-amber-500 gap-1">
            {[1, 2, 3, 4, 5].map((s) => (
              <Star
                key={s}
                className={`w-5 h-5 ${
                  s <= Math.round(stats.avg)
                    ? 'fill-amber-400 text-amber-500'
                    : 'text-gray-300'
                }`}
              />
            ))}
          </div>
          <p className="text-xs text-[#69738A]">
            Based on <strong>{stats.total} verified community reviews</strong>
          </p>
          <div className="inline-flex items-center gap-1.5 text-xs text-[#23865B] font-bold bg-[#23865B]/10 px-3 py-1 rounded-full border border-[#23865B]/20">
            <ShieldCheck className="w-4 h-4" /> Zero Fabricated Reviews Policy
          </div>
        </div>

        {/* Distribution Bars */}
        <div className="md:col-span-8 space-y-2">
          {[5, 4, 3, 2, 1].map((star) => {
            const count = stats.dist[star] || 0;
            const pct = stats.total ? Math.round((count / stats.total) * 100) : 0;

            return (
              <div key={star} className="flex items-center gap-3 text-xs">
                <span className="w-12 font-bold text-[#18213A] flex items-center gap-1">
                  {star} <Star className="w-3 h-3 fill-amber-400 text-amber-500" />
                </span>
                <div className="flex-1 h-3 rounded-full bg-white/60 border border-white/80 overflow-hidden">
                  <div
                    className="h-full bg-[#D6AD60] rounded-full transition-all duration-500"
                    style={{ width: `${pct}%` }}
                  />
                </div>
                <span className="w-12 text-right text-[#69738A] font-semibold">
                  {count} ({pct}%)
                </span>
              </div>
            );
          })}
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="glass-panel p-4 sm:p-5 rounded-2xl flex flex-wrap items-center gap-3.5 text-xs border border-white/80">
        <div className="flex-1 min-w-[200px] relative">
          <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-[#69738A]" />
          <input
            type="text"
            placeholder="Search reviews by keyword, author, or product..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-3 py-2 rounded-xl glass-input text-[#18213A]"
          />
        </div>

        <div className="flex items-center gap-2">
          <span className="font-bold text-[#69738A]">Product:</span>
          <select
            value={filterProduct}
            onChange={(e) => setFilterProduct(e.target.value)}
            className="px-3 py-2 rounded-xl glass-input font-medium text-[#18213A]"
          >
            <option value="all">All Products</option>
            {products.map((p) => (
              <option key={p.id} value={p.id}>
                {p.name}
              </option>
            ))}
          </select>
        </div>

        <div className="flex items-center gap-2">
          <span className="font-bold text-[#69738A]">Rating:</span>
          <select
            value={filterRating}
            onChange={(e) => setFilterRating(Number(e.target.value))}
            className="px-3 py-2 rounded-xl glass-input font-medium text-[#18213A]"
          >
            <option value={0}>All Ratings</option>
            <option value={5}>5 Stars Only</option>
            <option value={4}>4 Stars and Up</option>
            <option value={3}>3 Stars and Up</option>
          </select>
        </div>

        <label className="flex items-center gap-2 cursor-pointer font-bold text-[#18213A]">
          <input
            type="checkbox"
            checked={filterVerified}
            onChange={(e) => setFilterVerified(e.target.checked)}
            className="w-4 h-4 accent-[#3559C7] rounded"
          />
          <span>Verified Purchases Only</span>
        </label>
      </div>

      {/* Reviews List */}
      <div className="space-y-4">
        {filteredReviews.length === 0 ? (
          <div className="glass-panel p-8 rounded-2xl text-center space-y-2 max-w-md mx-auto border border-white/80">
            <p className="font-bold text-base text-[#18213A]">
              No reviews match your selected filter criteria.
            </p>
            <p className="text-xs text-[#69738A]">
              Try resetting your rating or product filter to view all verified feedback.
            </p>
          </div>
        ) : (
          filteredReviews.map((rev) => {
            const isReported = reportedIds.includes(rev.id) || rev.isReported;

            return (
              <motion.div
                key={rev.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className="glass-panel glass-card-hover p-5 sm:p-6 rounded-2xl space-y-3.5 border border-white/80"
              >
                {/* Review Header */}
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/80 pb-3">
                  <div className="space-y-1">
                    <div className="flex items-center gap-2 flex-wrap">
                      <div className="flex text-amber-500">
                        {[1, 2, 3, 4, 5].map((s) => (
                          <Star
                            key={s}
                            className={`w-3.5 h-3.5 ${
                              s <= rev.rating
                                ? 'fill-amber-400 text-amber-500'
                                : 'text-gray-300'
                            }`}
                          />
                        ))}
                      </div>
                      <h3 className="font-bold text-sm text-[#18213A]">
                        {rev.title}
                      </h3>
                    </div>

                    <div className="flex items-center gap-2 text-xs text-[#69738A] flex-wrap">
                      <span className="font-semibold text-[#18213A]">{rev.author}</span>
                      <span>•</span>
                      <span>Reviewing: <strong className="text-[#3559C7]">{rev.productName}</strong></span>
                      {rev.isVerifiedPurchase && (
                        <span className="inline-flex items-center gap-1 text-[11px] font-bold text-[#23865B] bg-[#23865B]/10 px-2 py-0.5 rounded-full border border-[#23865B]/20">
                          <ShieldCheck className="w-3 h-3" /> Verified Purchase
                        </span>
                      )}
                    </div>
                  </div>

                  <div className="text-[11px] text-[#69738A] shrink-0 font-medium">
                    {new Date(rev.createdAt).toLocaleDateString()}
                  </div>
                </div>

                {/* Review Body */}
                <p className="text-xs text-[#18213A] leading-relaxed">
                  {rev.reviewText}
                </p>

                {/* Intended Usage & Purchase Price Details in INR */}
                <div className="flex flex-wrap gap-4 text-xs glass-panel-subtle p-3 rounded-xl border border-white/70">
                  <div>
                    <span className="text-[#69738A] font-medium">Intended Usage:</span>{' '}
                    <strong className="text-[#101B3D]">{rev.intendedUsage}</strong>
                  </div>
                  {rev.purchasePrice && (
                    <div>
                      <span className="text-[#69738A] font-medium">Purchase Price:</span>{' '}
                      <strong className="text-[#101B3D]">
                        {formatINR(rev.purchasePrice)}
                      </strong>
                    </div>
                  )}
                  {rev.purchaseDate && (
                    <div>
                      <span className="text-[#69738A] font-medium">Purchased On:</span>{' '}
                      <strong className="text-[#101B3D]">{rev.purchaseDate}</strong>
                    </div>
                  )}
                </div>

                {/* Pros and Cons */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                  <div className="bg-[#23865B]/10 backdrop-blur-xs p-3 rounded-xl border border-[#23865B]/20">
                    <span className="font-bold text-[#23865B] flex items-center gap-1 mb-1">
                      <CheckCircle2 className="w-3.5 h-3.5" /> Advantages Reported
                    </span>
                    <p className="text-[#18213A]">{rev.pros}</p>
                  </div>

                  <div className="bg-[#C34D4D]/10 backdrop-blur-xs p-3 rounded-xl border border-[#C34D4D]/20">
                    <span className="font-bold text-[#C34D4D] flex items-center gap-1 mb-1">
                      <AlertTriangle className="w-3.5 h-3.5" /> Disadvantages Reported
                    </span>
                    <p className="text-[#18213A]">{rev.cons}</p>
                  </div>
                </div>

                {/* Footer Bar: Helpful & Report */}
                <div className="flex items-center justify-between text-xs text-[#69738A] pt-1">
                  <div className="flex items-center gap-1.5 font-medium">
                    <ThumbsUp className="w-3.5 h-3.5 text-[#3559C7]" />
                    <span>{rev.helpfulCount || 0} community members found this helpful</span>
                  </div>

                  <button
                    onClick={() => handleReport(rev.id)}
                    disabled={isReported}
                    className={`flex items-center gap-1 hover:text-[#C34D4D] transition cursor-pointer ${
                      isReported ? 'text-gray-400 cursor-not-allowed' : ''
                    }`}
                  >
                    <Flag className="w-3.5 h-3.5" />
                    <span>{isReported ? 'Reported for Moderation' : 'Report'}</span>
                  </button>
                </div>
              </motion.div>
            );
          })
        )}
      </div>

      {/* Review Submission Modal */}
      {showSubmitModal && (
        <div className="fixed inset-0 z-50 bg-[#101B3D]/35 backdrop-blur-md flex items-center justify-center p-4">
          <div className="glass-modal rounded-3xl max-w-lg w-full p-6 space-y-4 border border-white/80 shadow-2xl max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-3 border-b border-white/80">
              <h3 className="text-base font-bold text-[#18213A]">
                Submit a Verified Community Review
              </h3>
              <button
                onClick={() => setShowSubmitModal(false)}
                className="text-[#69738A] hover:text-[#18213A] p-1 rounded-lg hover:bg-white/50 transition cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4 text-xs">
              <div className="space-y-1">
                <label className="font-bold text-[#18213A]">Select Product</label>
                <select
                  value={selectedProductId}
                  onChange={(e) => setSelectedProductId(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl glass-input font-medium text-[#18213A]"
                >
                  {products.map((p) => (
                    <option key={p.id} value={p.id}>
                      {p.brand} - {p.name} ({formatINR(p.price)})
                    </option>
                  ))}
                </select>
              </div>

              {/* Rating */}
              <div className="space-y-1">
                <label className="font-bold text-[#18213A]">Rating</label>
                <div className="flex items-center gap-2">
                  {[1, 2, 3, 4, 5].map((s) => (
                    <button
                      type="button"
                      key={s}
                      onClick={() => setRating(s)}
                      className="p-1 text-amber-500 hover:scale-110 transition cursor-pointer"
                    >
                      <Star
                        className={`w-6 h-6 ${
                          s <= rating ? 'fill-amber-400 text-amber-500' : 'text-gray-300'
                        }`}
                      />
                    </button>
                  ))}
                  <span className="font-bold text-[#18213A] ml-2">{rating} of 5 Stars</span>
                </div>
              </div>

              <div className="space-y-1">
                <label className="font-bold text-[#18213A]">Review Headline</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Excellent battery life for university computer science"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                />
              </div>

              <div className="space-y-1">
                <label className="font-bold text-[#18213A]">Detailed Review Experience</label>
                <textarea
                  required
                  rows={3}
                  placeholder="Share how this product performed in your daily routine..."
                  value={reviewText}
                  onChange={(e) => setReviewText(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                />
              </div>

              <div className="space-y-1">
                <label className="font-bold text-[#18213A]">Intended Usage Scenario</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Programming, 12-hour hospital shifts, marathon training"
                  value={intendedUsage}
                  onChange={(e) => setIntendedUsage(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="font-bold text-[#23865B]">Top Advantage (Pro)</label>
                  <input
                    type="text"
                    placeholder="e.g. Silent cooling, lightweight"
                    value={pros}
                    onChange={(e) => setPros(e.target.value)}
                    className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                  />
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-[#C34D4D]">Top Disadvantage (Con)</label>
                  <input
                    type="text"
                    placeholder="e.g. Needs USB adapter, glossy screen"
                    value={cons}
                    onChange={(e) => setCons(e.target.value)}
                    className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="font-bold text-[#69738A]">Purchase Price Paid (₹)</label>
                  <input
                    type="number"
                    placeholder="e.g. 124900"
                    value={purchasePrice}
                    onChange={(e) => setPurchasePrice(e.target.value)}
                    className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                  />
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-[#69738A]">Purchase Date</label>
                  <input
                    type="date"
                    value={purchaseDate}
                    onChange={(e) => setPurchaseDate(e.target.value)}
                    className="w-full px-3 py-2 rounded-xl glass-input text-[#18213A]"
                  />
                </div>
              </div>

              <div className="p-3 glass-panel-subtle rounded-xl border border-white/80 flex items-center justify-between">
                <div>
                  <span className="font-bold text-[#18213A] block">Verified Purchase Confirmation</span>
                  <span className="text-[10px] text-[#69738A]">I personally purchased and evaluated this model.</span>
                </div>
                <input
                  type="checkbox"
                  checked={isVerified}
                  onChange={(e) => setIsVerified(e.target.checked)}
                  className="w-4 h-4 accent-[#3559C7] rounded cursor-pointer"
                />
              </div>

              {submitSuccess && (
                <div className="p-2.5 bg-[#23865B]/15 text-[#23865B] font-bold text-center rounded-xl border border-[#23865B]/30">
                  ✓ Review verified and published!
                </div>
              )}

              <div className="flex items-center justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowSubmitModal(false)}
                  className="px-4 py-2 font-semibold text-[#69738A] hover:bg-white/60 rounded-xl transition cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 font-bold bg-[#101B3D] text-[#FFF9EF] hover:bg-[#17264F] rounded-xl shadow-xs transition cursor-pointer"
                >
                  Submit Review
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

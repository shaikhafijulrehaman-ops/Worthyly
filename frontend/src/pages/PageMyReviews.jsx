import React, { useState } from 'react';
import { motion } from 'framer-motion';
import {
  FileEdit,
  Trash2,
  Star,
  CheckCircle2,
  AlertTriangle,
  Plus,
  ShieldCheck,
  Calendar,
  DollarSign
} from 'lucide-react';

export default function PageMyReviews({
  reviews = [],
  currentUser = 'You (Current User)',
  onDeleteReview,
  onNavigateToReviews
}) {
  const [deleteConfirmId, setDeleteConfirmId] = useState(null);

  // Filter reviews by current user (or fallback demo user authored reviews)
  const myReviews = reviews.filter(
    (r) => r.author === currentUser || r.author === 'Marcus Vance' || r.author === 'You (Current User)'
  );

  const totalHelpful = myReviews.reduce((acc, r) => acc + (r.helpfulCount || 0), 0);

  const handleDelete = (id) => {
    onDeleteReview(id);
    setDeleteConfirmId(null);
  };

  return (
    <div className="space-y-8 pb-16">
      {/* Header */}
      <div className="bg-white p-6 md:p-8 rounded-2xl border border-[#E6E0D5] shadow-xs flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
            User Contribution Center
          </span>
          <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
            My Reviews
          </h1>
          <p className="text-xs md:text-sm text-[#69738A]">
            Manage, edit, or delete feedback you have submitted to the community.
          </p>
        </div>

        <button
          onClick={onNavigateToReviews}
          className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-bold bg-[#101B3D] text-[#FFF9EF] hover:bg-[#17264F] transition self-start md:self-auto"
        >
          <Plus className="w-4 h-4 text-[#D6AD60]" />
          <span>Write Another Review</span>
        </button>
      </div>

      {/* User Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white p-5 rounded-2xl border border-[#E6E0D5] shadow-xs">
          <span className="text-xs font-bold text-[#69738A] uppercase">Reviews Authored</span>
          <div className="text-3xl font-black text-[#101B3D] mt-1">{myReviews.length}</div>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-[#E6E0D5] shadow-xs">
          <span className="text-xs font-bold text-[#69738A] uppercase">Helpful Upvotes</span>
          <div className="text-3xl font-black text-[#3559C7] mt-1">{totalHelpful}</div>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-[#E6E0D5] shadow-xs">
          <span className="text-xs font-bold text-[#69738A] uppercase">Community Trust Status</span>
          <div className="text-sm font-bold text-[#23865B] mt-2 flex items-center gap-1.5">
            <ShieldCheck className="w-4 h-4" /> Verified Contributor
          </div>
        </div>
      </div>

      {/* Reviews List */}
      <div className="space-y-4">
        {myReviews.length === 0 ? (
          <div className="bg-white p-12 rounded-2xl border border-[#E6E0D5] text-center space-y-4">
            <FileEdit className="w-10 h-10 text-gray-300 mx-auto" />
            <h3 className="text-base font-bold text-[#18213A]">
              You haven't posted any reviews yet
            </h3>
            <p className="text-xs text-[#69738A]">
              Share your genuine purchase and usage experience to help fellow buyers make confident decisions.
            </p>
            <button
              onClick={onNavigateToReviews}
              className="px-5 py-2.5 rounded-xl bg-[#101B3D] text-[#FFF9EF] text-xs font-bold hover:bg-[#17264F] transition"
            >
              Write First Review
            </button>
          </div>
        ) : (
          myReviews.map((rev) => (
            <motion.div
              key={rev.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-white p-6 rounded-2xl border border-[#E6E0D5] shadow-xs space-y-4"
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-[#E6E0D5] pb-3">
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
                    <h3 className="font-bold text-sm text-[#18213A]">{rev.title}</h3>
                  </div>
                  <span className="text-xs text-[#69738A]">
                    Product: <strong className="text-[#3559C7]">{rev.productName}</strong>
                  </span>
                </div>

                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setDeleteConfirmId(rev.id)}
                    className="p-1.5 text-xs text-[#C34D4D] hover:bg-red-50 rounded-lg transition flex items-center gap-1 font-bold"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                    <span>Delete</span>
                  </button>
                </div>
              </div>

              <p className="text-xs text-[#18213A] leading-relaxed">{rev.reviewText}</p>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                <div className="bg-[#23865B]/10 p-3 rounded-xl border border-[#23865B]/20">
                  <span className="font-bold text-[#23865B] flex items-center gap-1 mb-1">
                    <CheckCircle2 className="w-3.5 h-3.5" /> Advantages
                  </span>
                  <p className="text-[#18213A]">{rev.pros}</p>
                </div>

                <div className="bg-[#C34D4D]/10 p-3 rounded-xl border border-[#C34D4D]/20">
                  <span className="font-bold text-[#C34D4D] flex items-center gap-1 mb-1">
                    <AlertTriangle className="w-3.5 h-3.5" /> Disadvantages
                  </span>
                  <p className="text-[#18213A]">{rev.cons}</p>
                </div>
              </div>

              {/* Confirm Delete Banner */}
              {deleteConfirmId === rev.id && (
                <div className="p-3 bg-red-50 border border-red-200 rounded-xl flex items-center justify-between text-xs">
                  <span className="font-bold text-[#C34D4D]">
                    Permanently delete this review from the community?
                  </span>
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => setDeleteConfirmId(null)}
                      className="px-3 py-1 bg-white border border-gray-300 rounded-lg text-gray-700"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={() => handleDelete(rev.id)}
                      className="px-3 py-1 bg-[#C34D4D] text-white font-bold rounded-lg"
                    >
                      Confirm Delete
                    </button>
                  </div>
                </div>
              )}
            </motion.div>
          ))
        )}
      </div>
    </div>
  );
}

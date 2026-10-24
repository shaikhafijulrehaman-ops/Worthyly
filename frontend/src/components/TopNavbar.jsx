import React, { useState, useRef, useEffect } from 'react';
import {
  ShieldCheck,
  ChevronDown,
  X,
  Sparkles,
  LogOut,
  User,
  Bookmark,
  FileEdit,
  Scale,
  Sliders
} from 'lucide-react';

/* =========================================================================
   1. HAND-DRAWN SKETCH ART SVG ICONS
   Custom sketch line-art designed specifically for WORTHLY's brand aesthetic
   (Consistent 24x24 viewBox, 1.75 stroke width, round caps & joins)
   ========================================================================= */

/** Home — Hand-sketched home roof, chimney & door */
function SketchHome({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M3 10.5l9-7.5 9 7.5" strokeWidth={2} />
      <path d="M18 6.5v-3h-2.5v1" opacity="0.75" />
      <path d="M5 9.5v10.5a1.5 1.5 0 0 0 1.5 1.5h11a1.5 1.5 0 0 0 1.5-1.5V9.5" />
      <path d="M10 21.5v-6a2 2 0 0 1 4 0v6" />
      <path d="M12 5.5l1.5 1.2" opacity="0.6" />
    </svg>
  );
}

/** Find My Best 3 — Target with broken sketch rings & checklist tick */
function SketchTargetChecklist({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M12 3a9 9 0 0 1 8.6 6.5" />
      <path d="M20.6 12a9 9 0 0 1-2.6 6.4" strokeDasharray="3 2" />
      <path d="M15.5 20.4A9 9 0 0 1 3.4 12" />
      <path d="M3.4 12A9 9 0 0 1 9.5 3.5" strokeDasharray="2.5 2" />
      <path d="M12 1.5v2.5M12 20v2.5M1.5 12h2.5M20 12h2.5" opacity="0.75" />
      <circle cx="12" cy="12" r="4.5" strokeDasharray="3 1.5" opacity="0.6" />
      <path d="M8.5 12.2l2.3 2.5 5.2-5.5" strokeWidth={2} />
    </svg>
  );
}

/** Explore — Hand-sketched magnifier with reflection & discovery sparkle */
function SketchMagnifier({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <circle cx="10.5" cy="10.5" r="6.75" />
      <path d="M7.5 8a4.5 4.5 0 0 1 5-1.5" opacity="0.65" strokeDasharray="2 1.5" />
      <path d="M15.5 15.5l5.5 5.5" strokeWidth={2.2} />
      <path d="M17.8 17.2l1.4 1.4" opacity="0.6" strokeWidth={1.5} />
      <path d="M19.5 5.5v2M18.5 6.5h2" opacity="0.8" />
    </svg>
  );
}

/** Compare — Side-by-side product comparison cards with balance arrows */
function SketchComparison({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <rect x="2.5" y="4" width="8" height="15.5" rx="2" />
      <path d="M4.5 7.5h4M4.5 10.5h2.5M4.5 13.5h3.5" opacity="0.7" />
      <rect x="13.5" y="4" width="8" height="15.5" rx="2" />
      <path d="M15.5 7.5h4M15.5 10.5h2.5M15.5 13.5h3.5" opacity="0.7" />
      <path d="M9 2.5h6M14 1l2 1.5-2 1.5" opacity="0.8" />
      <path d="M15 21.5H9M10 20l-2 1.5 2 1.5" opacity="0.8" />
    </svg>
  );
}

/** Action / Portal Arrow — Matching the rightmost icon in reference */
function SketchActionArrow({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M9 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h4" />
      <path d="M16 17l5-5-5-5" strokeWidth={2} />
      <path d="M21 12H9" strokeWidth={2} />
      <path d="M18.5 9.5l1.5 2.5-1.5 2.5" opacity="0.4" strokeDasharray="1.5 1.5" />
    </svg>
  );
}

/** Community Reviews — Speech bubble with star */
function SketchCommunityReviews({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M4 6a3 3 0 0 1 3-3h10a3 3 0 0 1 3 3v7.5a3 3 0 0 1-3 3H10.5l-4 3.5v-3.5H7a3 3 0 0 1-3-3z" />
      <path d="M12 6.8l1 1.9 2.1.3-1.5 1.5.4 2.1-2-1-2 1 .4-2.1-1.5-1.5 2.1-.3z" strokeWidth={1.5} />
      <path d="M7 7.5h1.5" opacity="0.6" />
    </svg>
  );
}

/** Budget Finder — Wallet & currency mark */
function SketchBudgetFinder({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <rect x="2.5" y="6" width="19" height="13" rx="2.5" />
      <path d="M4 8.5h16" strokeDasharray="2 1.5" opacity="0.5" />
      <path d="M15 11h4a1.5 1.5 0 0 1 1.5 1.5v0a1.5 1.5 0 0 1-1.5 1.5h-4z" />
      <circle cx="17" cy="12.5" r="0.8" fill="currentColor" />
      <path d="M8 4a3 3 0 0 1 4 0" opacity="0.75" />
      <path d="M7.5 13.5h3.5M7.5 15h3.5M7.5 13.5a1.8 1.8 0 0 0 2.2 1.8l-2.2 2.2" opacity="0.85" strokeWidth={1.5} />
    </svg>
  );
}

/** Saved Products — Bookmark ribbon with heart */
function SketchSavedProducts({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M5.5 3.5a1.5 1.5 0 0 1 1.5-1.5h10a1.5 1.5 0 0 1 1.5 1.5V21l-6.5-3.8L5.5 21z" />
      <path d="M8 4.5v12.5M16 4.5v12.5" strokeDasharray="2 2" opacity="0.5" />
      <path d="M12 7.8c-.8-1-2-.5-2 .6 0 1 2 2.3 2 2.3s2-1.3 2-2.3c0-1.1-1.2-1.6-2-.6z" strokeWidth={1.5} />
    </svg>
  );
}

/** My Comparisons — Balance scale */
function SketchComparisonsHistory({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M12 3v17M8 20.5h8" />
      <path d="M4 6.5l16-1.5" />
      <circle cx="12" cy="4" r="1.2" fill="currentColor" opacity="0.8" />
      <path d="M4 6.5l-2 4.5M4 6.5l2 4.5" opacity="0.75" />
      <path d="M1.5 11h5a2.5 2.5 0 0 1-5 0z" />
      <path d="M20 5l-2 4.5M20 5l2 4.5" opacity="0.75" />
      <path d="M17.5 9.5h5a2.5 2.5 0 0 1-5 0z" />
    </svg>
  );
}

/** My Reviews — Pen & notepad */
function SketchMyReviews({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M5.5 3.5a1.5 1.5 0 0 1 1.5-1.5h8l4.5 4.5v13.5a1.5 1.5 0 0 1-1.5 1.5h-11a1.5 1.5 0 0 1-1.5-1.5z" />
      <path d="M15 2v5h5" />
      <path d="M8 10.5h5M8 13.5h7M8 16.5h4" opacity="0.65" />
      <path d="M17 14l2.5 2.5-5 5-2 .5.5-2z" strokeWidth={1.5} />
    </svg>
  );
}

/** Settings — Adjustment slider rails */
function SketchSettings({ className = "w-4.5 h-4.5 sm:w-5 sm:h-5", strokeWidth = 1.75 }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M3.5 6.5h17" />
      <circle cx="8" cy="6.5" r="2.2" fill="white" />
      <path d="M3.5 12h17" />
      <circle cx="16" cy="12" r="2.2" fill="white" />
      <path d="M3.5 17.5h17" />
      <circle cx="10" cy="17.5" r="2.2" fill="white" />
    </svg>
  );
}

/* =========================================================================
   2. MAIN WORTHLY TOP NAVBAR COMPONENT
   Harmonizes the reference capsule button layout with:
   - Hand-drawn sketch line-art icons
   - WORTHLY brand palette (Royal Navy #101B3D, Primary Blue #3559C7, Gold #D6AD60, Warm Ivory #FFF9EF)
   ========================================================================= */

export default function TopNavbar({
  activeTab = 'landing',
  setActiveTab,
  profileSubTab = 'overview',
  compareCount = 0,
  savedCount = 0,
  onOpenProfileTab
}) {
  const [expandableOpen, setExpandableOpen] = useState(false);
  const [profileDropdownOpen, setProfileDropdownOpen] = useState(false);

  const capsuleNavRef = useRef(null);
  const profileDropdownRef = useRef(null);

  // Close menus on outside click or Escape key
  useEffect(() => {
    function handleKeyDown(e) {
      if (e.key === 'Escape') {
        setExpandableOpen(false);
        setProfileDropdownOpen(false);
      }
    }

    function handleClickOutside(event) {
      if (capsuleNavRef.current && !capsuleNavRef.current.contains(event.target)) {
        setExpandableOpen(false);
      }
      if (profileDropdownRef.current && !profileDropdownRef.current.contains(event.target)) {
        setProfileDropdownOpen(false);
      }
    }

    document.addEventListener('keydown', handleKeyDown);
    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('keydown', handleKeyDown);
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  // Navigation handlers
  const handleNavClick = (tabId) => {
    setActiveTab(tabId);
    setExpandableOpen(false);
    setProfileDropdownOpen(false);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleProfileMenuClick = (subTab) => {
    setExpandableOpen(false);
    setProfileDropdownOpen(false);
    if (onOpenProfileTab) {
      onOpenProfileTab(subTab);
    } else {
      setActiveTab('profile');
    }
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  // Determine active states for the 4 primary sketch tabs
  const isHomeActive = activeTab === 'landing' || activeTab === 'overview';
  const isBuilderActive = activeTab === 'builder' || activeTab === 'recommendations';
  const isExplorerActive = activeTab === 'explorer';
  const isCompareActive = activeTab === 'compare';

  // Determine if active route is inside the expandable menu
  const isExpandableRouteActive =
    activeTab === 'community-reviews' ||
    activeTab === 'reviews' ||
    activeTab === 'budget-finder' ||
    activeTab === 'profile' ||
    activeTab === 'saved-products';

  // Subtab active checks
  const isReviewsActive = activeTab === 'community-reviews' || activeTab === 'reviews';
  const isBudgetActive = activeTab === 'budget-finder';
  const isSavedActive = (activeTab === 'profile' && profileSubTab === 'saved') || activeTab === 'saved-products';
  const isComparisonsActive = activeTab === 'profile' && profileSubTab === 'comparisons';
  const isMyReviewsActive = activeTab === 'profile' && profileSubTab === 'reviews';
  const isSettingsActive = activeTab === 'profile' && profileSubTab === 'settings';

  return (
    <header className="sticky top-0 z-40 w-full bg-[#FAF6F0]/85 backdrop-blur-md border-b border-[#E6E0D5]/60 transition-all">
      <div className="max-w-7xl mx-auto px-3 sm:px-6 lg:px-8 h-16 sm:h-[68px] flex items-center justify-between gap-2 sm:gap-4 relative">
        {/* =================================================================
            1. LEFT: WORTHLY LOGO & BRAND
            ================================================================= */}
        <div
          onClick={() => handleNavClick('landing')}
          className="flex items-center gap-2.5 sm:gap-3 cursor-pointer group shrink-0"
          title="WORTHLY — Know What It's Worth."
        >
          <div className="w-8 h-8 sm:w-9 sm:h-9 rounded-xl bg-gradient-to-tr from-[#3559C7] via-[#101B3D] to-[#D6AD60] flex items-center justify-center font-black text-white text-sm sm:text-base shadow-sm border border-white/80 group-hover:scale-105 transition-transform">
            W
          </div>
          <div>
            <div className="text-base sm:text-lg font-black tracking-tight text-[#18213A] flex items-center gap-1 leading-none">
              WORTHLY
            </div>
            <p className="hidden md:block text-[9px] sm:text-[10px] text-[#69738A] font-medium tracking-wide mt-0.5">
              Know What It's Worth.
            </p>
          </div>
        </div>

        {/* =================================================================
            2. CENTER: CAPSULE NAVIGATION BAR
            - Uses reference button structure with authentic sketch line-art icons
            - Styled with WORTHLY's brand palette (Primary Blue, Gold Accent, Royal Navy)
            ================================================================= */}
        <div className="relative flex items-center justify-center" ref={capsuleNavRef}>
          <nav
            className="rounded-full bg-white/95 backdrop-blur-xl border border-white/95 shadow-[0_8px_30px_rgba(53,89,199,0.12),0_2px_8px_rgba(25,45,85,0.06)] px-1.5 sm:px-2 py-1 sm:py-1.5 flex items-center gap-1 sm:gap-1.5 transition-all duration-200"
            aria-label="WORTHLY capsule navigation bar"
          >
            {/* 1. Home Sketch Icon Button */}
            <button
              onClick={() => handleNavClick('landing')}
              title="Home"
              aria-label="Home"
              aria-pressed={isHomeActive}
              className={`w-9 h-9 sm:w-10 sm:h-10 rounded-full flex items-center justify-center transition-all duration-200 cursor-pointer ${
                isHomeActive
                  ? 'border-2 border-[#3559C7] bg-[#3559C7]/10 text-[#3559C7] shadow-[0_2px_10px_rgba(53,89,199,0.22)] ring-1 ring-[#D6AD60]/40'
                  : 'text-[#18213A]/75 hover:text-[#3559C7] hover:bg-[#F7F1E6]'
              }`}
            >
              <SketchHome className="w-4.5 h-4.5 sm:w-5 sm:h-5" />
            </button>

            {/* 2. Find My Best 3 — Target / Checklist Sketch Icon Button */}
            <button
              onClick={() => handleNavClick('builder')}
              title="Find My Best 3 — Requirement Matching Wizard"
              aria-label="Find My Best 3"
              aria-pressed={isBuilderActive}
              className={`w-9 h-9 sm:w-10 sm:h-10 rounded-full flex items-center justify-center transition-all duration-200 cursor-pointer ${
                isBuilderActive
                  ? 'border-2 border-[#3559C7] bg-[#3559C7]/10 text-[#3559C7] shadow-[0_2px_10px_rgba(53,89,199,0.22)] ring-1 ring-[#D6AD60]/40'
                  : 'text-[#18213A]/75 hover:text-[#3559C7] hover:bg-[#F7F1E6]'
              }`}
            >
              <SketchTargetChecklist className="w-4.5 h-4.5 sm:w-5 sm:h-5" />
            </button>

            {/* 3. Explore — Magnifier Sketch Icon Button */}
            <button
              onClick={() => handleNavClick('explorer')}
              title="Explore Products — Full Verified Catalog"
              aria-label="Explore Products"
              aria-pressed={isExplorerActive}
              className={`w-9 h-9 sm:w-10 sm:h-10 rounded-full flex items-center justify-center transition-all duration-200 cursor-pointer ${
                isExplorerActive
                  ? 'border-2 border-[#3559C7] bg-[#3559C7]/10 text-[#3559C7] shadow-[0_2px_10px_rgba(53,89,199,0.22)] ring-1 ring-[#D6AD60]/40'
                  : 'text-[#18213A]/75 hover:text-[#3559C7] hover:bg-[#F7F1E6]'
              }`}
            >
              <SketchMagnifier className="w-4.5 h-4.5 sm:w-5 sm:h-5" />
            </button>

            {/* 4. Compare — Dual Cards Sketch Icon Button (with live badge) */}
            <button
              onClick={() => handleNavClick('compare')}
              title="Compare Products — Side-by-Side Analysis"
              aria-label="Compare Products"
              aria-pressed={isCompareActive}
              className={`relative w-9 h-9 sm:w-10 sm:h-10 rounded-full flex items-center justify-center transition-all duration-200 cursor-pointer ${
                isCompareActive
                  ? 'border-2 border-[#3559C7] bg-[#3559C7]/10 text-[#3559C7] shadow-[0_2px_10px_rgba(53,89,199,0.22)] ring-1 ring-[#D6AD60]/40'
                  : 'text-[#18213A]/75 hover:text-[#3559C7] hover:bg-[#F7F1E6]'
              }`}
            >
              <SketchComparison className="w-4.5 h-4.5 sm:w-5 sm:h-5" />

              {/* Compare Count Badge */}
              {compareCount > 0 && (
                <span className="absolute -top-0.5 -right-0.5 bg-[#3559C7] text-white text-[9px] font-black px-1.5 py-0.2 min-w-[16px] text-center rounded-full border-2 border-white ring-1 ring-[#D6AD60]/60 shadow-xs animate-in zoom-in-75">
                  {compareCount}
                </span>
              )}
            </button>

            {/* Vertical Hairline Divider */}
            <div className="h-5 w-px bg-[#E6E0D5] mx-0.5 sm:mx-1 shrink-0" />

            {/* 5. Rounded Pill Button (Matching reference capsule pill) */}
            <button
              onClick={() => setExpandableOpen(!expandableOpen)}
              title="More Discovery Tools"
              aria-label="More Options"
              aria-expanded={expandableOpen}
              className={`rounded-full px-3 sm:px-3.5 py-1 sm:py-1.5 text-xs font-bold tracking-wider uppercase transition-all duration-150 cursor-pointer shadow-xs select-none ${
                expandableOpen || isExpandableRouteActive
                  ? 'bg-[#3559C7] text-[#FFF9EF] border-transparent ring-2 ring-[#D6AD60]/50 shadow-[0_2px_10px_rgba(53,89,199,0.3)]'
                  : 'bg-[#F7F1E6] text-[#101B3D] hover:bg-[#FFF9EF] hover:border-[#3559C7]/30 border border-[#E6E0D5]'
              }`}
            >
              MORE
            </button>

            {/* 6. Action / Portal Sketch Icon (Matching reference right icon) */}
            <button
              onClick={() => setProfileDropdownOpen(!profileDropdownOpen)}
              title="Profile & Quick Menu"
              aria-label="Profile Menu"
              className="w-9 h-9 sm:w-10 sm:h-10 rounded-full flex items-center justify-center text-[#18213A]/75 hover:text-[#3559C7] hover:bg-[#F7F1E6] transition-all duration-150 cursor-pointer"
            >
              <SketchActionArrow className="w-4.5 h-4.5 sm:w-5 sm:h-5" />
            </button>
          </nav>

          {/* =================================================================
              FLOATING FROSTED-GLASS DROPDOWN MENU
              Reveals remaining discovery options with sketch line-art icons
              ================================================================= */}
          {expandableOpen && (
            <div
              className="absolute top-full mt-3 left-1/2 -translate-x-1/2 w-[92vw] max-w-sm glass-modal rounded-3xl p-4 sm:p-5 shadow-2xl border border-white/95 z-50 animate-in fade-in zoom-in-95 duration-150"
              role="dialog"
              aria-label="More navigation tools"
            >
              {/* Header */}
              <div className="flex items-center justify-between pb-2.5 mb-3 border-b border-[#E6E0D5]/60">
                <div className="flex items-center gap-2">
                  <Sparkles className="w-3.5 h-3.5 text-[#3559C7]" />
                  <span className="text-[11px] font-bold uppercase tracking-wider text-[#18213A]">
                    WORTHLY Discovery Suite
                  </span>
                </div>
                <button
                  onClick={() => setExpandableOpen(false)}
                  className="w-6 h-6 rounded-lg bg-white/60 hover:bg-white text-[#69738A] hover:text-[#18213A] flex items-center justify-center transition border border-white/80 cursor-pointer"
                  aria-label="Close"
                >
                  <X className="w-3.5 h-3.5" />
                </button>
              </div>

              {/* Grid of Remaining Tools with Sketch Icons */}
              <div className="grid grid-cols-3 gap-2.5">
                {/* 1. Community Reviews */}
                <button
                  onClick={() => handleNavClick('community-reviews')}
                  className="flex flex-col items-center justify-center p-2 rounded-2xl hover:bg-[#F7F1E6] transition group cursor-pointer focus:outline-none"
                >
                  <div
                    className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                      isReviewsActive
                        ? 'border-2 border-[#3559C7] bg-[#3559C7]/12 text-[#3559C7]'
                        : 'bg-white/80 border border-[#E6E0D5] text-[#18213A] group-hover:text-[#3559C7] group-hover:border-[#3559C7]/40'
                    }`}
                  >
                    <SketchCommunityReviews className="w-4.5 h-4.5" />
                  </div>
                  <span className="text-[10px] font-semibold text-[#18213A] mt-1 leading-tight group-hover:text-[#3559C7]">
                    Reviews
                  </span>
                </button>

                {/* 2. Budget Finder */}
                <button
                  onClick={() => handleNavClick('budget-finder')}
                  className="flex flex-col items-center justify-center p-2 rounded-2xl hover:bg-[#F7F1E6] transition group cursor-pointer focus:outline-none"
                >
                  <div
                    className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                      isBudgetActive
                        ? 'border-2 border-[#3559C7] bg-[#3559C7]/12 text-[#3559C7]'
                        : 'bg-white/80 border border-[#E6E0D5] text-[#18213A] group-hover:text-[#3559C7] group-hover:border-[#3559C7]/40'
                    }`}
                  >
                    <SketchBudgetFinder className="w-4.5 h-4.5" />
                  </div>
                  <span className="text-[10px] font-semibold text-[#18213A] mt-1 leading-tight group-hover:text-[#3559C7]">
                    Budget
                  </span>
                </button>

                {/* 3. Saved Products */}
                <button
                  onClick={() => handleProfileMenuClick('saved')}
                  className="flex flex-col items-center justify-center p-2 rounded-2xl hover:bg-[#F7F1E6] transition group cursor-pointer focus:outline-none"
                >
                  <div
                    className={`relative w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                      isSavedActive
                        ? 'border-2 border-[#3559C7] bg-[#3559C7]/12 text-[#3559C7]'
                        : 'bg-white/80 border border-[#E6E0D5] text-[#18213A] group-hover:text-[#3559C7] group-hover:border-[#3559C7]/40'
                    }`}
                  >
                    <SketchSavedProducts className="w-4.5 h-4.5" />
                    {savedCount > 0 && (
                      <span className="absolute -top-1 -right-1 bg-[#D6AD60] text-[#101B3D] text-[9px] font-bold px-1.5 py-0.2 rounded-full border border-white">
                        {savedCount}
                      </span>
                    )}
                  </div>
                  <span className="text-[10px] font-semibold text-[#18213A] mt-1 leading-tight group-hover:text-[#3559C7]">
                    Saved
                  </span>
                </button>

                {/* 4. My Comparisons */}
                <button
                  onClick={() => handleProfileMenuClick('comparisons')}
                  className="flex flex-col items-center justify-center p-2 rounded-2xl hover:bg-[#F7F1E6] transition group cursor-pointer focus:outline-none"
                >
                  <div
                    className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                      isComparisonsActive
                        ? 'border-2 border-[#3559C7] bg-[#3559C7]/12 text-[#3559C7]'
                        : 'bg-white/80 border border-[#E6E0D5] text-[#18213A] group-hover:text-[#3559C7] group-hover:border-[#3559C7]/40'
                    }`}
                  >
                    <SketchComparisonsHistory className="w-4.5 h-4.5" />
                  </div>
                  <span className="text-[10px] font-semibold text-[#18213A] mt-1 leading-tight group-hover:text-[#3559C7]">
                    Comparisons
                  </span>
                </button>

                {/* 5. My Reviews */}
                <button
                  onClick={() => handleProfileMenuClick('reviews')}
                  className="flex flex-col items-center justify-center p-2 rounded-2xl hover:bg-[#F7F1E6] transition group cursor-pointer focus:outline-none"
                >
                  <div
                    className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                      isMyReviewsActive
                        ? 'border-2 border-[#3559C7] bg-[#3559C7]/12 text-[#3559C7]'
                        : 'bg-white/80 border border-[#E6E0D5] text-[#18213A] group-hover:text-[#3559C7] group-hover:border-[#3559C7]/40'
                    }`}
                  >
                    <SketchMyReviews className="w-4.5 h-4.5" />
                  </div>
                  <span className="text-[10px] font-semibold text-[#18213A] mt-1 leading-tight group-hover:text-[#3559C7]">
                    My Reviews
                  </span>
                </button>

                {/* 6. Settings */}
                <button
                  onClick={() => handleProfileMenuClick('settings')}
                  className="flex flex-col items-center justify-center p-2 rounded-2xl hover:bg-[#F7F1E6] transition group cursor-pointer focus:outline-none"
                >
                  <div
                    className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                      isSettingsActive
                        ? 'border-2 border-[#3559C7] bg-[#3559C7]/12 text-[#3559C7]'
                        : 'bg-white/80 border border-[#E6E0D5] text-[#18213A] group-hover:text-[#3559C7] group-hover:border-[#3559C7]/40'
                    }`}
                  >
                    <SketchSettings className="w-4.5 h-4.5" />
                  </div>
                  <span className="text-[10px] font-semibold text-[#18213A] mt-1 leading-tight group-hover:text-[#3559C7]">
                    Settings
                  </span>
                </button>
              </div>

              {/* Bottom Note */}
              <div className="mt-3 pt-2.5 border-t border-[#E6E0D5]/50 flex items-center justify-between text-[10px] text-[#69738A]">
                <span className="flex items-center gap-1 font-medium">
                  <ShieldCheck className="w-3 h-3 text-[#23865B]" />
                  <span>100% Verified Indian Pricing (INR)</span>
                </span>
                <button
                  onClick={() => handleNavClick('landing')}
                  className="font-bold text-[#3559C7] hover:underline cursor-pointer"
                >
                  Return to Home
                </button>
              </div>
            </div>
          )}
        </div>

        {/* =================================================================
            3. RIGHT: PROFILE BADGE & QUICK MENU
            ================================================================= */}
        <div className="flex items-center justify-end gap-2 shrink-0">
          <div className="relative" ref={profileDropdownRef}>
            <button
              onClick={() => setProfileDropdownOpen(!profileDropdownOpen)}
              className="flex items-center gap-1.5 sm:gap-2 p-1.5 px-2 sm:px-2.5 rounded-full bg-white/75 hover:bg-white transition border border-white/90 focus:outline-none focus:ring-2 focus:ring-[#3559C7] cursor-pointer shadow-xs"
              aria-label="User Profile Menu"
              aria-expanded={profileDropdownOpen}
            >
              <div className="w-7 h-7 rounded-full bg-gradient-to-br from-[#3559C7] via-[#17264F] to-[#101B3D] border border-white/80 flex items-center justify-center font-bold text-white text-xs shadow-xs">
                AR
              </div>
              <span className="hidden lg:inline-block text-xs font-bold text-[#18213A] max-w-[80px] truncate">
                Alex R.
              </span>
              <ChevronDown
                className={`w-3.5 h-3.5 text-[#69738A] transition-transform duration-200 ${
                  profileDropdownOpen ? 'rotate-180' : 'rotate-0'
                }`}
              />
            </button>

            {/* Profile Dropdown Menu */}
            {profileDropdownOpen && (
              <div className="absolute right-0 mt-2 w-64 rounded-2xl glass-modal shadow-2xl py-2 z-50 animate-in fade-in slide-in-from-top-2">
                <div className="px-4 py-3 border-b border-white/80 space-y-0.5">
                  <p className="text-xs font-bold text-[#18213A]">Alex Rivera</p>
                  <p className="text-[11px] text-[#69738A] truncate">alex.rivera@example.com</p>
                  <div className="flex items-center gap-1 text-[10px] text-[#23865B] font-semibold pt-1">
                    <ShieldCheck className="w-3 h-3" />
                    <span>Verified Shopper (INR)</span>
                  </div>
                </div>

                <div className="py-1 text-xs text-[#18213A] font-semibold">
                  <button
                    onClick={() => handleProfileMenuClick('overview')}
                    className="w-full text-left px-4 py-2 hover:bg-[#F7F1E6] flex items-center gap-2.5 transition cursor-pointer"
                  >
                    <User className="w-4 h-4 text-[#3559C7]" />
                    <span>My Profile</span>
                  </button>

                  <button
                    onClick={() => handleProfileMenuClick('saved')}
                    className="w-full text-left px-4 py-2 hover:bg-[#F7F1E6] flex items-center justify-between transition cursor-pointer"
                  >
                    <div className="flex items-center gap-2.5">
                      <Bookmark className="w-4 h-4 text-[#D6AD60]" />
                      <span>Saved Products</span>
                    </div>
                    {savedCount > 0 && (
                      <span className="text-[10px] font-bold bg-[#D6AD60] text-[#101B3D] px-2 py-0.5 rounded-full">
                        {savedCount}
                      </span>
                    )}
                  </button>

                  <button
                    onClick={() => handleProfileMenuClick('reviews')}
                    className="w-full text-left px-4 py-2 hover:bg-[#F7F1E6] flex items-center gap-2.5 transition cursor-pointer"
                  >
                    <FileEdit className="w-4 h-4 text-[#3559C7]" />
                    <span>My Reviews</span>
                  </button>

                  <button
                    onClick={() => handleProfileMenuClick('comparisons')}
                    className="w-full text-left px-4 py-2 hover:bg-[#F7F1E6] flex items-center gap-2.5 transition cursor-pointer"
                  >
                    <Scale className="w-4 h-4 text-[#3559C7]" />
                    <span>My Comparisons</span>
                  </button>

                  <button
                    onClick={() => handleProfileMenuClick('settings')}
                    className="w-full text-left px-4 py-2 hover:bg-[#F7F1E6] flex items-center gap-2.5 transition cursor-pointer"
                  >
                    <Sliders className="w-4 h-4 text-[#69738A]" />
                    <span>Settings</span>
                  </button>
                </div>

                <div className="pt-1 border-t border-[#E6E0D5]">
                  <button
                    onClick={() => handleProfileMenuClick('signout')}
                    className="w-full text-left px-4 py-2 text-xs font-semibold text-[#C34D4D] hover:bg-red-50 flex items-center gap-2.5 transition cursor-pointer"
                  >
                    <LogOut className="w-4 h-4" />
                    <span>Sign Out</span>
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
}

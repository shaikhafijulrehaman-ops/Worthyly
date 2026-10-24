import React, { useState } from 'react';
import {
  Sparkles,
  Compass,
  Search,
  Scale,
  MessageSquare,
  DollarSign,
  Bookmark,
  FileEdit,
  Settings,
  Menu,
  X,
  ShieldCheck,
  Zap,
  ChevronRight
} from 'lucide-react';
import NeonBorder from './NeonBorder';

export const NAV_ITEMS = [
  { id: 'overview', label: 'Overview', icon: Compass },
  { id: 'builder', label: 'Find My Product', icon: Sparkles, highlight: true },
  { id: 'explorer', label: 'Explore Products', icon: Search },
  { id: 'compare', label: 'Compare Products', icon: Scale, badgeKey: 'compareCount' },
  { id: 'community-reviews', label: 'Community Reviews', icon: MessageSquare },
  { id: 'budget-finder', label: 'Budget Finder', icon: DollarSign },
  { id: 'saved-products', label: 'Saved Products', icon: Bookmark, badgeKey: 'savedCount' },
  { id: 'my-reviews', label: 'My Reviews', icon: FileEdit },
  { id: 'settings', label: 'Settings', icon: Settings },
];

export default function Navigation({
  activeTab,
  setActiveTab,
  compareCount = 0,
  savedCount = 0,
  onOpenAssistant
}) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const handleSelect = (id) => {
    setActiveTab(id);
    setMobileMenuOpen(false);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <>
      {/* Top Mobile Bar */}
      <header className="lg:hidden sticky top-0 z-40 bg-[#101B3D] text-[#FFF9EF] px-4 py-3 flex items-center justify-between border-b border-[#17264F] shadow-md">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-[#3559C7] to-[#D6AD60] flex items-center justify-center font-bold text-white shadow-sm">
            W
          </div>
          <div>
            <span className="font-extrabold tracking-tight text-white text-base">
              WORTHLY
            </span>
            <p className="text-[10px] text-[#D6AD60]/90 font-medium leading-none">Know What It's Worth.</p>
          </div>
        </div>

        <button
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          className="p-2 rounded-lg bg-[#17264F] text-[#FFF9EF] hover:bg-[#3559C7] transition"
          aria-label="Toggle menu"
        >
          {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
        </button>
      </header>

      {/* Desktop Persistent Sidebar */}
      <aside className="hidden lg:flex flex-col w-64 bg-[#101B3D] text-[#FFF9EF] border-r border-[#17264F] min-h-screen sticky top-0 shrink-0 z-30">
        {/* Brand Header */}
        <div className="p-6 border-b border-[#17264F]/80">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-[#3559C7] via-[#17264F] to-[#D6AD60] flex items-center justify-center font-black text-white text-xl shadow-lg border border-[#D6AD60]/40">
              W
            </div>
            <div>
              <div className="text-xl font-extrabold tracking-tight text-white flex items-center gap-1.5">
                WORTHLY
              </div>
              <p className="text-[11px] text-[#FFF9EF]/70 font-medium">
                Know What It's Worth.
              </p>
            </div>
          </div>
        </div>

        {/* Navigation Links */}
        <div className="flex-1 py-6 px-3 space-y-1.5 overflow-y-auto">
          <div className="px-3 pb-2 text-[10px] font-bold uppercase tracking-wider text-[#D6AD60]">
            Core Dashboard
          </div>

          {NAV_ITEMS.map((item) => {
            const Icon = item.icon;
            const isActive = activeTab === item.id;
            const count =
              item.badgeKey === 'compareCount'
                ? compareCount
                : item.badgeKey === 'savedCount'
                ? savedCount
                : null;

            return (
              <button
                key={item.id}
                onClick={() => handleSelect(item.id)}
                className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-semibold transition-all duration-200 group text-left ${
                  isActive
                    ? 'bg-gradient-to-r from-[#3559C7] to-[#17264F] text-white shadow-md border-l-4 border-[#D6AD60]'
                    : 'text-[#FFF9EF]/80 hover:text-white hover:bg-[#17264F]/70'
                }`}
              >
                <div className="flex items-center gap-3">
                  <Icon
                    className={`w-4 h-4 transition-colors ${
                      isActive ? 'text-[#D6AD60]' : 'text-[#FFF9EF]/60 group-hover:text-white'
                    }`}
                  />
                  <span>{item.label}</span>
                </div>

                {count !== null && count > 0 && (
                  <span className="text-xs bg-[#D6AD60] text-[#101B3D] font-bold px-2 py-0.5 rounded-full shadow-xs">
                    {count}
                  </span>
                )}
                {item.highlight && !isActive && (
                  <span className="w-2 h-2 rounded-full bg-[#D6AD60] animate-pulse" />
                )}
              </button>
            );
          })}
        </div>

        {/* AI Assistant Callout with Neon Border */}
        <div className="p-4 border-t border-[#17264F]">
          <div className="p-3.5 rounded-xl bg-gradient-to-b from-[#17264F] to-[#101B3D] border border-[#3559C7]/40 shadow-inner">
            <div className="flex items-center gap-2 text-xs font-bold text-[#D6AD60] mb-1">
              <Zap className="w-3.5 h-3.5 text-[#3559C7]" />
              <span>Smart Recommendation AI</span>
            </div>
            <p className="text-[11px] text-[#FFF9EF]/70 mb-3 leading-relaxed">
              Deterministic, zero-hallucination product matching based on verified facts.
            </p>
            <button
              onClick={() => handleSelect('builder')}
              className="w-full text-xs font-bold py-2 px-3 rounded-lg bg-[#3559C7] hover:bg-[#2e4eb2] text-white transition flex items-center justify-center gap-1.5"
            >
              <span>Start Match Wizard</span>
              <ChevronRight className="w-3 h-3" />
            </button>
          </div>

          <div className="mt-3 flex items-center justify-between text-[11px] text-[#FFF9EF]/50 px-1">
            <span className="flex items-center gap-1">
              <ShieldCheck className="w-3 h-3 text-[#23865B]" /> Verified Engine
            </span>
            <span>v1.0.0</span>
          </div>
        </div>
      </aside>

      {/* Mobile Menu Overlay */}
      {mobileMenuOpen && (
        <div
          className="fixed inset-0 z-50 bg-black/60 lg:hidden flex flex-col justify-end"
          onClick={() => setMobileMenuOpen(false)}
        >
          <div
            className="bg-[#101B3D] text-[#FFF9EF] rounded-t-3xl p-6 max-h-[85vh] overflow-y-auto space-y-2 border-t border-[#D6AD60]/40"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between pb-4 border-b border-[#17264F]">
              <span className="text-sm font-bold text-[#D6AD60] uppercase tracking-wider">
                Select Navigation Page
              </span>
              <button
                onClick={() => setMobileMenuOpen(false)}
                className="p-1 rounded-lg hover:bg-white/10"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="grid grid-cols-1 gap-1.5 pt-2">
              {NAV_ITEMS.map((item) => {
                const Icon = item.icon;
                const isActive = activeTab === item.id;
                const count =
                  item.badgeKey === 'compareCount'
                    ? compareCount
                    : item.badgeKey === 'savedCount'
                    ? savedCount
                    : null;

                return (
                  <button
                    key={item.id}
                    onClick={() => handleSelect(item.id)}
                    className={`flex items-center justify-between p-3 rounded-xl text-sm font-semibold transition ${
                      isActive
                        ? 'bg-[#3559C7] text-white font-bold'
                        : 'text-[#FFF9EF]/80 hover:bg-[#17264F]'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <Icon className="w-4 h-4 text-[#D6AD60]" />
                      <span>{item.label}</span>
                    </div>
                    {count !== null && count > 0 && (
                      <span className="text-xs bg-[#D6AD60] text-[#101B3D] font-bold px-2 py-0.5 rounded-full">
                        {count}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      )}
    </>
  );
}

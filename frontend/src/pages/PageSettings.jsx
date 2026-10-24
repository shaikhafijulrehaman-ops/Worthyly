import React, { useState } from 'react';
import { motion } from 'framer-motion';
import {
  Settings,
  User,
  Sliders,
  DollarSign,
  ShieldCheck,
  Download,
  RotateCcw,
  LogOut,
  Save,
  CheckCircle2
} from 'lucide-react';

export default function PageSettings({
  categories = [],
  savedCount = 0,
  onResetAllDemoData
}) {
  const [userName, setUserName] = useState('Alex Rivera');
  const [userEmail, setUserEmail] = useState('alex.rivera@example.com');
  const [preferredCat, setPreferredCat] = useState('electronics');
  const [defaultMaxBudget, setDefaultMaxBudget] = useState(1500);
  const [strictBudgetOnly, setStrictBudgetOnly] = useState(true);
  const [prioritizeVerifiedOnly, setPrioritizeVerifiedOnly] = useState(true);
  const [savedFeedback, setSavedFeedback] = useState(false);

  const handleSave = (e) => {
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
      exportedAt: new Date().toISOString()
    };
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `worthly_preferences_${Date.now()}.json`;
    a.click();
  };

  return (
    <div className="max-w-4xl mx-auto space-y-8 pb-16">
      {/* Header */}
      <div className="bg-white p-6 md:p-8 rounded-2xl border border-[#E6E0D5] shadow-xs space-y-2">
        <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
          Preferences & Account
        </span>
        <h1 className="text-2xl md:text-3xl font-black text-[#18213A]">
          Dashboard Settings
        </h1>
        <p className="text-xs md:text-sm text-[#69738A]">
          Configure your default recommendation heuristics, account profile, and data storage.
        </p>
      </div>

      <form onSubmit={handleSave} className="space-y-6">
        {/* Profile Card */}
        <div className="bg-white p-6 md:p-8 rounded-2xl border border-[#E6E0D5] shadow-xs space-y-4">
          <h3 className="text-base font-bold text-[#18213A] flex items-center gap-2">
            <User className="w-5 h-5 text-[#3559C7]" />
            User Profile
          </h3>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-1.5">
              <label className="text-xs font-bold text-[#69738A]">Display Name</label>
              <input
                type="text"
                value={userName}
                onChange={(e) => setUserName(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl border border-[#E6E0D5] text-sm text-[#18213A] focus:outline-none focus:ring-2 focus:ring-[#3559C7]"
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-bold text-[#69738A]">Email Address</label>
              <input
                type="email"
                value={userEmail}
                onChange={(e) => setUserEmail(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl border border-[#E6E0D5] text-sm text-[#18213A] focus:outline-none focus:ring-2 focus:ring-[#3559C7]"
              />
            </div>
          </div>
        </div>

        {/* Heuristic Preferences */}
        <div className="bg-white p-6 md:p-8 rounded-2xl border border-[#E6E0D5] shadow-xs space-y-4">
          <h3 className="text-base font-bold text-[#18213A] flex items-center gap-2">
            <Sliders className="w-5 h-5 text-[#3559C7]" />
            Recommendation Heuristics
          </h3>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-1.5">
              <label className="text-xs font-bold text-[#69738A]">Primary Preferred Category</label>
              <select
                value={preferredCat}
                onChange={(e) => setPreferredCat(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl border border-[#E6E0D5] text-sm text-[#18213A]"
              >
                {categories.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-bold text-[#69738A]">Default Budget Ceiling ($)</label>
              <input
                type="number"
                value={defaultMaxBudget}
                onChange={(e) => setDefaultMaxBudget(Number(e.target.value))}
                className="w-full px-4 py-2.5 rounded-xl border border-[#E6E0D5] text-sm text-[#18213A]"
              />
            </div>
          </div>

          <div className="space-y-3 pt-2">
            <div className="flex items-center justify-between p-3.5 rounded-xl bg-[#F7F1E6] border border-[#E6E0D5]">
              <div>
                <span className="text-sm font-bold text-[#18213A] block">Strict Budget Enforcement</span>
                <span className="text-xs text-[#69738A]">Never display models that cost even $1 above designated budget.</span>
              </div>
              <input
                type="checkbox"
                checked={strictBudgetOnly}
                onChange={(e) => setStrictBudgetOnly(e.target.checked)}
                className="w-5 h-5 accent-[#3559C7] rounded"
              />
            </div>

            <div className="flex items-center justify-between p-3.5 rounded-xl bg-[#F7F1E6] border border-[#E6E0D5]">
              <div>
                <span className="text-sm font-bold text-[#18213A] block">Prioritize Verified Purchase Reviews</span>
                <span className="text-xs text-[#69738A]">Weigh verified community feedback above standard unverified ratings.</span>
              </div>
              <input
                type="checkbox"
                checked={prioritizeVerifiedOnly}
                onChange={(e) => setPrioritizeVerifiedOnly(e.target.checked)}
                className="w-5 h-5 accent-[#3559C7] rounded"
              />
            </div>
          </div>
        </div>

        {/* Data Persistence & Export */}
        <div className="bg-white p-6 md:p-8 rounded-2xl border border-[#E6E0D5] shadow-xs space-y-4">
          <h3 className="text-base font-bold text-[#18213A] flex items-center gap-2">
            <ShieldCheck className="w-5 h-5 text-[#23865B]" />
            Data Storage & Export
          </h3>

          <p className="text-xs text-[#69738A]">
            You have <strong>{savedCount} products</strong> saved to your local session.
          </p>

          <div className="flex flex-wrap items-center gap-3 pt-2">
            <button
              type="button"
              onClick={handleExportData}
              className="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold bg-[#F7F1E6] hover:bg-[#E6E0D5] text-[#18213A] border border-[#E6E0D5] transition"
            >
              <Download className="w-4 h-4 text-[#3559C7]" />
              <span>Export Preferences (JSON)</span>
            </button>

            <button
              type="button"
              onClick={onResetAllDemoData}
              className="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold text-[#C34D4D] hover:bg-red-50 border border-red-200 transition"
            >
              <RotateCcw className="w-4 h-4" />
              <span>Reset All Demo Data</span>
            </button>
          </div>
        </div>

        {/* Save Bar */}
        <div className="flex items-center justify-between pt-2">
          {savedFeedback ? (
            <span className="text-xs font-bold text-[#23865B] flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4" /> Preferences successfully saved!
            </span>
          ) : (
            <div />
          )}

          <button
            type="submit"
            className="flex items-center gap-2 px-6 py-2.5 rounded-xl bg-[#101B3D] hover:bg-[#17264F] text-[#FFF9EF] font-bold text-sm transition shadow-md"
          >
            <Save className="w-4 h-4 text-[#D6AD60]" />
            <span>Save Preferences</span>
          </button>
        </div>
      </form>
    </div>
  );
}

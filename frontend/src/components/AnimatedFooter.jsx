import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import {
  Sparkles,
  ArrowRight,
  ShieldCheck,
  Scale,
  Award,
  ExternalLink,
  X,
  Mail,
  Heart,
  HelpCircle
} from 'lucide-react';

const FOOTER_GLITCH_MESSAGES = [
  "Discover Value Beyond Price.",
  "Know What It's Worth.",
  "Find Better. Choose Smarter.",
  "Compare Before You Buy.",
  "Your Budget. Your Best Choices."
];

function FooterGlitchText() {
  const [index, setIndex] = useState(0);
  const [isGlitching, setIsGlitching] = useState(false);

  useEffect(() => {
    const interval = setInterval(() => {
      setIsGlitching(true);
      const timer1 = setTimeout(() => {
        setIndex((prev) => (prev + 1) % FOOTER_GLITCH_MESSAGES.length);
        const timer2 = setTimeout(() => {
          setIsGlitching(false);
        }, 180);
        return () => clearTimeout(timer2);
      }, 250);
      return () => clearTimeout(timer1);
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  const currentMsg = FOOTER_GLITCH_MESSAGES[index];

  return (
    <div className="py-2 flex justify-center">
      <div className="inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-white/8 backdrop-blur-md border border-[#D6AD60]/35 shadow-[0_2px_12px_rgba(214,173,96,0.12)]">
        <span className="relative flex h-2 w-2 shrink-0">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-[#D6AD60] opacity-75" />
          <span className="relative inline-flex rounded-full h-2 w-2 bg-[#D6AD60]" />
        </span>
        <span
          className={`text-xs sm:text-[13px] font-bold tracking-wider text-[#D6AD60] uppercase transition-all duration-150 select-none ${
            isGlitching
              ? 'translate-x-0.5 skew-x-3 opacity-90'
              : 'translate-x-0 skew-x-0 opacity-100'
          }`}
          style={
            isGlitching
              ? {
                  textShadow: '2px 0 #3559C7, -2px 0 #FFF9EF, 0 1px #D6AD60',
                  filter: 'contrast(1.2)'
                }
              : {
                  textShadow: '0 0 14px rgba(214,173,96,0.3)'
                }
          }
        >
          {currentMsg}
        </span>
      </div>
    </div>
  );
}

export default function AnimatedFooter({ onNavigate, onStartFinding }) {
  const currentYear = new Date().getFullYear();
  const [modalContent, setModalContent] = useState(null);

  const MODAL_DATA = {
    about: {
      title: 'About WORTHLY',
      subtitle: 'Decision Intelligence • Know What It’s Worth',
      content: (
        <div className="space-y-4 text-xs text-[#18213A] leading-relaxed">
          <p>
            <strong>WORTHLY</strong> was built to solve a simple yet frustrating consumer reality:
            ordinary shopping search engines are ad-driven catalogs designed to show you what pays the highest affiliate commission, rather than what actually suits your budget and requirements.
          </p>
          <p>
            At WORTHLY, we don't treat budget as a loose suggestion. Our deterministic recommendation engine evaluates verified technical specifications, battery benchmarks, compute metrics, and community feedback across audited Indian retail availability.
          </p>
          <div className="p-3.5 glass-panel-subtle rounded-xl border border-white/80 space-y-1.5">
            <div className="font-bold text-[#101B3D] flex items-center gap-1.5">
              <ShieldCheck className="w-4 h-4 text-[#23865B]" />
              <span>Our 3 Core Commitments:</span>
            </div>
            <ul className="list-disc list-inside space-y-1 text-[#69738A]">
              <li><strong>Zero Ad Bias:</strong> No manufacturer can pay to be recommended.</li>
              <li><strong>Strict Budget Caps:</strong> If you set ₹1,00,000, not a single match costs ₹1,00,001.</li>
              <li><strong>Curated Best 3:</strong> Best Overall, Best Value, and Best Alternative.</li>
            </ul>
          </div>
        </div>
      )
    },
    contact: {
      title: 'Contact WORTHLY Support',
      subtitle: 'Indian Market Editorial & Engineering Team',
      content: (
        <div className="space-y-4 text-xs text-[#18213A] leading-relaxed">
          <p>
            Have product dataset corrections, new retail pricing tips, or feature requests?
            We actively maintain and audit our hardware database weekly.
          </p>
          <div className="space-y-2.5">
            <div className="flex items-center gap-3 p-3 glass-panel-subtle rounded-xl border border-white/80">
              <Mail className="w-4 h-4 text-[#3559C7]" />
              <div>
                <span className="font-bold text-[#101B3D] block">Editorial & Verification</span>
                <span className="text-[#69738A]">editorial@worthly.ai</span>
              </div>
            </div>
            <div className="flex items-center gap-3 p-3 glass-panel-subtle rounded-xl border border-white/80">
              <HelpCircle className="w-4 h-4 text-[#D6AD60]" />
              <div>
                <span className="font-bold text-[#101B3D] block">Customer Feedback & Inquiries</span>
                <span className="text-[#69738A]">hello@worthly.ai</span>
              </div>
            </div>
          </div>
          <p className="text-[11px] text-[#69738A]">
            Response turnaround within 24 business hours.
          </p>
        </div>
      )
    },
    privacy: {
      title: 'Privacy Policy',
      subtitle: 'Zero Data Brokerage • Client-Side Caching',
      content: (
        <div className="space-y-3.5 text-xs text-[#18213A] leading-relaxed">
          <p>
            Your trust is our foundation. WORTHLY collects zero personal telemetry and never sells user search inputs or budget limits to third-party ad networks.
          </p>
          <ul className="list-disc list-inside space-y-1.5 text-[#69738A]">
            <li><strong>Local Storage:</strong> Shortlists, shootouts, and preferences remain cached locally in your browser.</li>
            <li><strong>No Tracking Cookies:</strong> We do not track you across other websites.</li>
            <li><strong>Export / Wipe Anytime:</strong> You can export or purge all cached data in one click under Profile &gt; Settings.</li>
          </ul>
        </div>
      )
    },
    terms: {
      title: 'Terms of Service',
      subtitle: 'Verified Product Decision Advisory',
      content: (
        <div className="space-y-3 text-xs text-[#18213A] leading-relaxed">
          <p>
            WORTHLY provides automated hardware evaluation and product recommendations based on publicly available specifications and official Indian retail listings.
          </p>
          <p>
            While prices are periodically audited against official brand stores and authorized retailers in INR (₹), retail promotional pricing and inventory availability may fluctuate on third-party sites.
          </p>
          <p className="text-[11px] text-[#69738A]">
            Always verify final delivery charges and retailer warranty terms at the point of official checkout.
          </p>
        </div>
      )
    }
  };

  return (
    <>
      <footer className="relative w-full bg-gradient-to-b from-[#101B3D] via-[#142144] to-[#0A1128] text-[#FFF9EF] pt-14 pb-8 overflow-hidden border-t border-white/10">
        {/* Subtle Ambient Glows */}
        <div className="absolute top-0 left-1/4 -translate-y-1/2 w-96 h-96 bg-[#3559C7]/20 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute bottom-10 right-1/4 w-80 h-80 bg-[#D6AD60]/15 rounded-full blur-3xl pointer-events-none" />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 space-y-12">
          {/* Top Banner: Animated Headline & Primary CTA */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.2 }}
            transition={{ duration: 0.65, ease: [0.16, 1, 0.3, 1] }}
            className="text-center space-y-6 max-w-3xl mx-auto pt-2"
          >
            {/* Kicker Tag */}
            <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-white/10 backdrop-blur-md border border-white/15 text-xs font-semibold text-[#D6AD60]">
              <Sparkles className="w-3.5 h-3.5 text-[#D6AD60]" />
              <span>WORTHLY Decision Intelligence</span>
            </div>

            {/* Primary Main Statement (Drop Text entrance) */}
            <div className="space-y-1">
              <h2 className="text-3xl sm:text-4xl md:text-5xl font-black text-white tracking-tight leading-[1.15]">
                Don't Just Buy It.
              </h2>
              <h2 className="text-3xl sm:text-4xl md:text-5xl font-black text-[#D6AD60] tracking-tight leading-[1.15]">
                Know Its Worth.
              </h2>
            </div>

            {/* Supporting Statement */}
            <p className="text-xs sm:text-sm md:text-base text-[#FFF9EF]/80 max-w-xl mx-auto leading-relaxed">
              Make informed decisions. Compare with confidence. Choose products that match your needs and budget.
            </p>

            {/* Subtle Glitch Secondary Brand Message */}
            <FooterGlitchText />

            {/* Prominent CTA */}
            <div className="pt-2 flex justify-center">
              <button
                onClick={onStartFinding}
                className="px-8 py-3.5 rounded-xl font-black text-sm bg-gradient-to-r from-[#D6AD60] to-[#e4c07c] text-[#101B3D] hover:shadow-lg hover:shadow-[#D6AD60]/20 transition-all flex items-center gap-2 cursor-pointer group"
              >
                <span>Find My Best 3</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </button>
            </div>
          </motion.div>

          {/* Middle Grid: Brand Info, Navigation & Functional Links */}
          <div className="grid grid-cols-1 md:grid-cols-12 gap-8 pt-8 border-t border-white/10 text-xs">
            {/* Column 1: Brand Info & Positioning */}
            <div className="md:col-span-5 space-y-3.5">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-xl bg-gradient-to-tr from-[#3559C7] via-[#101B3D] to-[#D6AD60] flex items-center justify-center font-black text-white text-sm shadow-md border border-white/20">
                  W
                </div>
                <div>
                  <span className="text-base font-black tracking-tight text-white block">
                    WORTHLY
                  </span>
                  <span className="text-[10px] text-[#D6AD60] font-semibold">
                    Know What It's Worth.
                  </span>
                </div>
              </div>

              <p className="text-[#FFF9EF]/70 leading-relaxed max-w-sm">
                Compare smarter. Understand the trade-offs. Find products that match your needs and budget.
              </p>

              <div className="flex items-center gap-2 text-[11px] text-[#23865B] font-semibold bg-[#23865B]/10 px-3 py-1 rounded-full border border-[#23865B]/20 w-fit">
                <ShieldCheck className="w-3.5 h-3.5" />
                <span>Zero Sponsored Placements Policy</span>
              </div>
            </div>

            {/* Column 2: Navigation Links */}
            <div className="md:col-span-4 space-y-3">
              <span className="font-bold text-xs uppercase tracking-wider text-[#D6AD60] block">
                Platform Navigation
              </span>
              <ul className="space-y-2 text-[#FFF9EF]/80">
                <li>
                  <button
                    onClick={() => onNavigate('landing')}
                    className="hover:text-white transition cursor-pointer flex items-center gap-1.5"
                  >
                    <span>Home</span>
                  </button>
                </li>
                <li>
                  <button
                    onClick={() => onNavigate('explorer')}
                    className="hover:text-white transition cursor-pointer flex items-center gap-1.5"
                  >
                    <span>Explore Products</span>
                  </button>
                </li>
                <li>
                  <button
                    onClick={onStartFinding}
                    className="hover:text-[#D6AD60] transition cursor-pointer flex items-center gap-1.5"
                  >
                    <span>Find My Best 3 (Wizard)</span>
                  </button>
                </li>
                <li>
                  <button
                    onClick={() => onNavigate('compare')}
                    className="hover:text-white transition cursor-pointer flex items-center gap-1.5"
                  >
                    <span>Compare Shootout</span>
                  </button>
                </li>
                <li>
                  <button
                    onClick={() => onNavigate('reviews')}
                    className="hover:text-white transition cursor-pointer flex items-center gap-1.5"
                  >
                    <span>Community Reviews</span>
                  </button>
                </li>
              </ul>
            </div>

            {/* Column 3: Trust & Legal Links */}
            <div className="md:col-span-3 space-y-3">
              <span className="font-bold text-xs uppercase tracking-wider text-[#D6AD60] block">
                Advisory & Support
              </span>
              <ul className="space-y-2 text-[#FFF9EF]/80">
                <li>
                  <button
                    onClick={() => setModalContent(MODAL_DATA.about)}
                    className="hover:text-white transition cursor-pointer"
                  >
                    About WORTHLY
                  </button>
                </li>
                <li>
                  <button
                    onClick={() => setModalContent(MODAL_DATA.contact)}
                    className="hover:text-white transition cursor-pointer"
                  >
                    Contact Support
                  </button>
                </li>
                <li>
                  <button
                    onClick={() => setModalContent(MODAL_DATA.privacy)}
                    className="hover:text-white transition cursor-pointer"
                  >
                    Privacy Policy
                  </button>
                </li>
                <li>
                  <button
                    onClick={() => setModalContent(MODAL_DATA.terms)}
                    className="hover:text-white transition cursor-pointer"
                  >
                    Terms of Service
                  </button>
                </li>
              </ul>
            </div>
          </div>

          {/* Bottom Bar: Copyright & Attribution */}
          <div className="pt-6 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-3 text-[11px] text-[#FFF9EF]/60">
            <span>© {currentYear} WORTHLY. All rights reserved.</span>
            <div className="flex items-center gap-1">
              <span>Engineered with Decision Intelligence for the Indian Consumer Market</span>
            </div>
          </div>
        </div>
      </footer>

      {/* Legal & Advisory Info Modal */}
      {modalContent && (
        <div className="fixed inset-0 z-50 bg-[#101B3D]/50 backdrop-blur-md flex items-center justify-center p-4">
          <div className="glass-modal rounded-3xl max-w-lg w-full p-6 space-y-4 border border-white/80 shadow-2xl max-h-[85vh] overflow-y-auto">
            <div className="flex items-start justify-between pb-3 border-b border-white/80">
              <div>
                <h3 className="text-base font-bold text-[#18213A]">{modalContent.title}</h3>
                <p className="text-[11px] text-[#3559C7] font-semibold">{modalContent.subtitle}</p>
              </div>
              <button
                onClick={() => setModalContent(null)}
                className="text-[#69738A] hover:text-[#18213A] p-1 rounded-lg hover:bg-white/50 transition cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {modalContent.content}

            <div className="pt-2 flex justify-end">
              <button
                onClick={() => setModalContent(null)}
                className="px-5 py-2 bg-[#101B3D] text-[#FFF9EF] text-xs font-bold rounded-xl hover:bg-[#17264F] transition cursor-pointer shadow-xs"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

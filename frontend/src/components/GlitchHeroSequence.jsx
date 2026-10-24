import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import GlitchEffect from './originkit/ui/glitch-text';

export const WORTHLY_MESSAGES = [
  "Know What It's Worth.",
  "Find Better. Choose Smarter.",
  "Compare Before You Buy.",
  "Discover Value Beyond Price.",
  "Your Budget. Your Best Choices."
];

/**
 * GlitchHeroSequence
 *
 * Sequence:
 * 1. 'drop-in'    (~500ms) - Drop Text entrance: enters smoothly from above with natural easing
 * 2. 'readable'   (~2000ms) - sentence settles completely still, sharp, 100% readable for 2 seconds
 * 3. 'glitch-out' (~350ms) - short glitch transition introducing the next message
 * Then cycles to next message and repeats.
 *
 * Zero text clipping, zero layout shift (reserved min-height), responsive typography.
 */
export default function GlitchHeroSequence({
  messages = WORTHLY_MESSAGES,
  className = '',
  color = '#101B3D'
}) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [phase, setPhase] = useState('drop-in'); // 'drop-in' | 'readable' | 'glitch-out'
  const [prefersReducedMotion, setPrefersReducedMotion] = useState(false);
  const timerRef = useRef(null);

  // Check prefers-reduced-motion
  useEffect(() => {
    const mq = window.matchMedia?.('(prefers-reduced-motion: reduce)');
    if (mq) {
      setPrefersReducedMotion(mq.matches);
      const listener = (e) => setPrefersReducedMotion(e.matches);
      mq.addEventListener?.('change', listener);
      return () => mq.removeEventListener?.('change', listener);
    }
  }, []);

  // State Machine Timer Loop
  useEffect(() => {
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }

    if (prefersReducedMotion) {
      timerRef.current = setTimeout(() => {
        setCurrentIndex((prev) => (prev + 1) % messages.length);
      }, 2500);
      return () => {
        if (timerRef.current) clearTimeout(timerRef.current);
      };
    }

    if (phase === 'drop-in') {
      // Drop text entrance takes 500ms to settle
      timerRef.current = setTimeout(() => {
        setPhase('readable');
      }, 500);
    } else if (phase === 'readable') {
      // Holds completely readable for approx 2.0s AFTER settling
      timerRef.current = setTimeout(() => {
        setPhase('glitch-out');
      }, 2000);
    } else if (phase === 'glitch-out') {
      // 350ms glitch-out transition before dropping in the next message
      timerRef.current = setTimeout(() => {
        setCurrentIndex((prev) => (prev + 1) % messages.length);
        setPhase('drop-in');
      }, 350);
    }

    return () => {
      if (timerRef.current) {
        clearTimeout(timerRef.current);
        timerRef.current = null;
      }
    };
  }, [phase, currentIndex, messages.length, prefersReducedMotion]);

  // Jump to specific message cleanly
  const handleSelect = (idx) => {
    if (idx === currentIndex) return;
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
    setCurrentIndex(idx);
    setPhase('drop-in');
  };

  const currentMessage = messages[currentIndex];
  const isGlitching = phase === 'glitch-out' && !prefersReducedMotion;

  return (
    <div className={`w-full max-w-4xl mx-auto flex flex-col items-center justify-center text-center ${className}`}>
      {/* 
        Reserved Min-Height Box to prevent layout shifts.
      */}
      <div className="w-full min-h-[85px] sm:min-h-[100px] md:min-h-[110px] flex items-center justify-center px-2 sm:px-4 py-2">
        {prefersReducedMotion ? (
          <h2 className="text-2xl sm:text-3xl md:text-4xl lg:text-[42px] font-black text-[#101B3D] tracking-tight leading-snug max-w-3xl">
            {currentMessage}
          </h2>
        ) : (
          <AnimatePresence mode="wait">
            <motion.div
              key={currentIndex}
              initial={{ y: -22, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{
                duration: 0.45,
                ease: [0.16, 1, 0.3, 1]
              }}
              className="w-full flex items-center justify-center"
            >
              <GlitchEffect
                mode="text"
                text={currentMessage}
                font={{
                  fontFamily: 'Inter, system-ui, -apple-system, sans-serif',
                  fontSize: 'clamp(1.5rem, 4vw, 2.75rem)',
                  fontWeight: 900,
                  lineHeight: 1.25,
                  letterSpacing: '-0.03em',
                  whiteSpace: 'normal',
                  textAlign: 'center'
                }}
                color={color}
                active={isGlitching}
                shake={{
                  enabled: true,
                  intensity: 6,
                  x: 3.5,
                  y: 3.5
                }}
                slice={{
                  enabled: true,
                  intensity: 28,
                  minHeight: 15,
                  maxHeight: 65
                }}
                transition={{ duration: 0.35, ease: 'easeOut', delay: 0 }}
              />
            </motion.div>
          </AnimatePresence>
        )}
      </div>

      {/* Discrete sequence pagination pills */}
      <div className="flex items-center justify-center gap-2 pt-2">
        {messages.map((_, idx) => (
          <button
            key={idx}
            onClick={() => handleSelect(idx)}
            aria-label={`Show message ${idx + 1}: ${messages[idx]}`}
            className={`h-1.5 rounded-full transition-all duration-300 cursor-pointer ${
              idx === currentIndex
                ? 'w-6 bg-[#3559C7]'
                : 'w-2 bg-black/15 hover:bg-black/35'
            }`}
          />
        ))}
      </div>
    </div>
  );
}

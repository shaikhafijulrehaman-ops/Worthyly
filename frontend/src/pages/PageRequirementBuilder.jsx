import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import {
  Sparkles,
  ArrowRight,
  ArrowLeft,
  Check,
  Laptop,
  Footprints,
  Utensils,
  Armchair,
  Dumbbell,
  GraduationCap,
  SlidersHorizontal,
  Target,
  Layers,
  CheckCircle2,
  AlertCircle
} from 'lucide-react';
import NeonBorder from '../components/NeonBorder';
import { formatINR } from '../utils/currency';

const CATEGORY_DEFINITIONS = [
  {
    id: 'electronics',
    name: 'Electronics & Gadgets',
    icon: Laptop,
    budgetPresets: [40000, 75000, 120000, 160000],
    defaultMax: 140000,
    minSlider: 20000,
    maxSlider: 200000,
    stepSlider: 5000,
    usages: [
      { id: 'college', label: 'College & Assignments', desc: 'Writing, research, lecture note-taking, browser multitasking' },
      { id: 'programming', label: 'Programming & Development', desc: 'Compiling code, Docker, web dev, backend databases' },
      { id: 'ai_ml', label: 'AI / ML Development', desc: 'Local model inference, PyTorch, CUDA cores, heavy tensor math' },
      { id: 'gaming', label: 'Gaming & 3D Rendering', desc: 'High framerates, ray tracing, Blender, AAA gaming' },
      { id: 'video_editing', label: 'Video Editing & Content Creation', desc: 'Premiere Pro, DaVinci Resolve, 4K timeline scrubbing' },
      { id: 'office', label: 'Business & Office Work', desc: 'Spreadsheets, Zoom calls, presentation decks, CRM tools' }
    ],
    priorities: [
      { id: 'performance', label: 'Performance', desc: 'Raw CPU and GPU compute horsepower' },
      { id: 'battery', label: 'Battery Life', desc: 'All-day endurance away from electrical outlets' },
      { id: 'portability', label: 'Portability', desc: 'Lightweight build and slim backpack profile' },
      { id: 'ram', label: 'RAM / Multitasking', desc: '16GB or 32GB+ for heavy containerization' },
      { id: 'build_quality', label: 'Build Quality', desc: 'Premium metal unibody, high-resolution screen' },
      { id: 'value', label: 'Value for Money', desc: 'Maximum performance per rupee spent' }
    ],
    optionalFields: [
      {
        id: 'min_ram',
        label: 'Minimum RAM Desired',
        type: 'select',
        options: ['Any', '8GB', '16GB', '32GB', '64GB']
      },
      {
        id: 'dedicated_gpu',
        label: 'Require Dedicated NVIDIA / AMD GPU',
        type: 'boolean'
      },
      {
        id: 'preferred_brand',
        label: 'Brand Preference',
        type: 'select',
        options: ['Any', 'Apple', 'Dell', 'Lenovo', 'ASUS', 'Acer', 'Sony']
      }
    ]
  },
  {
    id: 'footwear',
    name: 'Fashion & Footwear',
    icon: Footprints,
    budgetPresets: [4000, 7000, 10000, 15000],
    defaultMax: 12000,
    minSlider: 3000,
    maxSlider: 25000,
    stepSlider: 1000,
    usages: [
      { id: 'running', label: 'Running & Marathon Training', desc: 'Road miles, track pacing, 5K to half-marathon' },
      { id: 'walking', label: 'Daily Walking & Commute', desc: 'Comfortable 10,000+ daily steps, hospital/office shifts' },
      { id: 'college_daily', label: 'Daily College Campus Wear', desc: 'Casual everyday sneakers with stylish silhouettes' },
      { id: 'formal', label: 'Formal Events & Office Wear', desc: 'Business attire, client presentations, formal shoes' },
      { id: 'gym_training', label: 'Gym & Cross Training', desc: 'Squats, HIIT circuits, and lateral support' }
    ],
    priorities: [
      { id: 'comfort', label: 'Comfort', desc: 'Plush underfoot cushioning and soft step-in feel' },
      { id: 'fit', label: 'Fit & Support', desc: 'Roomy toe box with zero heel slippage' },
      { id: 'durability', label: 'Durability', desc: 'Hardwearing rubber outsole that resists wear' },
      { id: 'weight', label: 'Lightweight', desc: 'Featherlight construction for minimal fatigue' },
      { id: 'material', label: 'Premium Materials', desc: 'Genuine leather or engineered air-mesh' },
      { id: 'value', label: 'Value for Money', desc: 'Long-lasting reliability without brand inflation' }
    ],
    optionalFields: [
      {
        id: 'preferred_brand',
        label: 'Brand Preference',
        type: 'select',
        options: ['Any', 'Nike', 'Brooks', 'New Balance', 'Clarks', 'Asics']
      }
    ]
  },
  {
    id: 'home_kitchen',
    name: 'Home & Kitchen',
    icon: Utensils,
    budgetPresets: [8000, 25000, 70000, 120000],
    defaultMax: 75000,
    minSlider: 5000,
    maxSlider: 150000,
    stepSlider: 5000,
    usages: [
      { id: 'daily_cooking', label: 'Quick Daily Meal Prep', desc: 'Speedy weekday cooking, reheating snacks' },
      { id: 'specialty_coffee', label: 'Artisanal Coffee & Espresso', desc: 'Café grade 9-bar espresso and microfoam milk' },
      { id: 'automated_cleaning', label: 'Automated Floor Cleaning', desc: 'Hands-off vacuuming and mopping' },
      { id: 'healthy_baking', label: 'Healthy Air Frying & Baking', desc: 'Crispy textures with 75% less oil' }
    ],
    priorities: [
      { id: 'ease_of_cleaning', label: 'Ease of Cleaning', desc: 'Dishwasher safe parts, self-emptying' },
      { id: 'capacity', label: 'Capacity', desc: 'Generous volume for cooking family batches' },
      { id: 'energy_efficiency', label: 'Energy Efficiency', desc: 'Low power consumption and fast preheating' },
      { id: 'durability', label: 'Durability', desc: 'Heavy duty motor and metal heating coils' },
      { id: 'compact_size', label: 'Compact Countertop Size', desc: 'Fits easily under standard Indian kitchen cabinets' },
      { id: 'value', label: 'Value for Money', desc: 'Maximum appliance longevity per rupee' }
    ],
    optionalFields: [
      {
        id: 'preferred_brand',
        label: 'Brand Preference',
        type: 'select',
        options: ['Any', 'Ninja', 'Breville', 'Roborock', 'Philips', 'Cosori']
      }
    ]
  },
  {
    id: 'furniture',
    name: 'Furniture & Home Office',
    icon: Armchair,
    budgetPresets: [25000, 45000, 80000, 130000],
    defaultMax: 80000,
    minSlider: 15000,
    maxSlider: 150000,
    stepSlider: 5000,
    usages: [
      { id: 'remote_work', label: 'Full-Time Remote Work (8+ hrs)', desc: 'Continuous desk sitting and spinal care' },
      { id: 'coding_setup', label: 'Multi-Monitor Coding Setup', desc: 'Heavy monitors, cable management, sturdy frame' },
      { id: 'student_study', label: 'Student Study & Reading', desc: 'Writing space, quiet adjustment, study ergonomics' }
    ],
    priorities: [
      { id: 'ergonomics', label: 'Ergonomic Support', desc: 'Targeted lumbar, pelvic, and thoracic alignment' },
      { id: 'adjustability', label: 'Adjustability', desc: 'Armrest angles, height presets, tilt limiter' },
      { id: 'sturdiness', label: 'Sturdiness & Stability', desc: 'Heavy-gauge steel frame with zero wobble' },
      { id: 'assembly', label: 'Easy Assembly', desc: 'Pre-assembled parts and clear toolkits' },
      { id: 'value', label: 'Value for Money', desc: 'Backed by long 10+ year warranty' }
    ],
    optionalFields: [
      {
        id: 'preferred_brand',
        label: 'Brand Preference',
        type: 'select',
        options: ['Any', 'Herman Miller', 'FLEXISPOT', 'Steelcase', 'Autonomous']
      }
    ]
  },
  {
    id: 'fitness',
    name: 'Fitness & Sports',
    icon: Dumbbell,
    budgetPresets: [15000, 30000, 40000, 50000],
    defaultMax: 40000,
    minSlider: 10000,
    maxSlider: 60000,
    stepSlider: 2500,
    usages: [
      { id: 'strength_training', label: 'Strength & Muscle Building', desc: 'Dumbbell supersets, hypertrophy, home gym' },
      { id: 'cardio_tracking', label: 'Cardio Pacing & Running', desc: 'Heart rate zones, VO2 max, GPS road pacing' },
      { id: 'outdoor_hiking', label: 'Outdoor Hiking & Trails', desc: 'Topographical tracking and multi-day battery' }
    ],
    priorities: [
      { id: 'accuracy', label: 'Sensor Accuracy', desc: 'Multi-band satellite and precision sensors' },
      { id: 'durability', label: 'Durability', desc: 'Sweat-proof, 5 ATM water resistance' },
      { id: 'battery_life', label: 'Battery Life', desc: 'Multiple days or weeks between charges' },
      { id: 'space_saving', label: 'Space Saving', desc: 'Replaces bulky racks or heavy footprint' },
      { id: 'app_ecosystem', label: 'Free Ecosystem', desc: 'Zero subscription paywalls for metrics' },
      { id: 'value', label: 'Value for Money', desc: 'High quality materials that last years' }
    ],
    optionalFields: [
      {
        id: 'preferred_brand',
        label: 'Brand Preference',
        type: 'select',
        options: ['Any', 'Garmin', 'Bowflex', 'Fitbit', 'Apple']
      }
    ]
  },
  {
    id: 'education',
    name: 'Education & Student Essentials',
    icon: GraduationCap,
    budgetPresets: [8000, 25000, 40000, 65000],
    defaultMax: 40000,
    minSlider: 5000,
    maxSlider: 80000,
    stepSlider: 2500,
    usages: [
      { id: 'handwritten_notes', label: 'Handwritten Notes & PDF Markup', desc: 'Low latency pen writing on digital paper' },
      { id: 'textbook_reading', label: 'Textbook & Article Reading', desc: 'Glance-free eye comfort for long study hours' },
      { id: 'library_focus', label: 'Library Focus & Noise Reduction', desc: 'Active noise cancellation blocking ambient chatter' },
      { id: 'lecture_recording', label: 'Lecture Recording & Playback', desc: 'Microphones and high fidelity audio drivers' }
    ],
    priorities: [
      { id: 'battery_life', label: 'Battery Life', desc: 'Lasts entire week of classes on a single charge' },
      { id: 'stylus_latency', label: 'Stylus Response', desc: 'Zero perceptible lag for smooth handwriting' },
      { id: 'portability', label: 'Portability', desc: 'Under 500 grams in a student backpack' },
      { id: 'eye_comfort', label: 'Eye Comfort', desc: 'Non-glare, paper-like display or low blue light' },
      { id: 'audio_anc', label: 'Noise Cancellation', desc: 'Cuts out library and coffee shop noise' },
      { id: 'value', label: 'Student Budget Friendly', desc: 'Exceptional features without premium markup' }
    ],
    optionalFields: [
      {
        id: 'preferred_brand',
        label: 'Brand Preference',
        type: 'select',
        options: ['Any', 'reMarkable', 'Apple', 'Anker', 'Sony']
      }
    ]
  }
];

const STEPS = [
  'Select Category',
  'Set Budget (INR)',
  'Intended Usage',
  'Select Priorities',
  'Optional Specs',
  'Review & Submit'
];

export default function PageRequirementBuilder({
  initialCategory = 'electronics',
  onSubmitRequirements
}) {
  const [currentStep, setCurrentStep] = useState(1);
  const [category, setCategory] = useState(initialCategory);
  const [minBudget, setMinBudget] = useState('');
  const [maxBudget, setMaxBudget] = useState(140000);
  const [allowFlexibility, setAllowFlexibility] = useState(false);
  const [selectedUsages, setSelectedUsages] = useState([]);
  const [selectedPriorities, setSelectedPriorities] = useState([]);
  const [optionalSpecs, setOptionalSpecs] = useState({});
  const [errorMsg, setErrorMsg] = useState('');

  // Active Category Definition
  const activeCatDef = CATEGORY_DEFINITIONS.find((c) => c.id === category) || CATEGORY_DEFINITIONS[0];

  useEffect(() => {
    if (activeCatDef) {
      setMaxBudget(activeCatDef.defaultMax);
      setSelectedUsages([activeCatDef.usages[0]?.id || '']);
      setSelectedPriorities([activeCatDef.priorities[0]?.id || '']);
      setOptionalSpecs({});
      setErrorMsg('');
    }
  }, [category]);

  const toggleUsage = (id) => {
    if (selectedUsages.includes(id)) {
      if (selectedUsages.length > 1) {
        setSelectedUsages(selectedUsages.filter((u) => u !== id));
      }
    } else {
      setSelectedUsages([...selectedUsages, id]);
    }
  };

  const togglePriority = (id) => {
    if (selectedPriorities.includes(id)) {
      if (selectedPriorities.length > 1) {
        setSelectedPriorities(selectedPriorities.filter((p) => p !== id));
      }
    } else {
      if (selectedPriorities.length < 3) {
        setSelectedPriorities([...selectedPriorities, id]);
      } else {
        setSelectedPriorities([...selectedPriorities.slice(1), id]);
      }
    }
  };

  const handleNext = () => {
    setErrorMsg('');
    if (currentStep === 2) {
      const min = minBudget ? Number(minBudget) : 0;
      const max = Number(maxBudget);
      if (isNaN(max) || max <= 0) {
        setErrorMsg('Please enter a valid maximum budget in INR (₹).');
        return;
      }
      if (min > max) {
        setErrorMsg('Minimum budget cannot be higher than maximum budget.');
        return;
      }
    }
    if (currentStep === 3) {
      if (selectedUsages.length === 0) {
        setErrorMsg('Please select at least one intended usage scenario.');
        return;
      }
    }
    if (currentStep === 4) {
      if (selectedPriorities.length === 0) {
        setErrorMsg('Please select at least one priority factor.');
        return;
      }
    }

    if (currentStep < 6) {
      setCurrentStep(currentStep + 1);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
      onSubmitRequirements({
        category,
        min_budget: minBudget ? Number(minBudget) : null,
        max_budget: Number(maxBudget),
        intended_usages: selectedUsages,
        priorities: selectedPriorities,
        optional_specs: optionalSpecs,
        allow_budget_flexibility: allowFlexibility
      });
    }
  };

  const handleBack = () => {
    setErrorMsg('');
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6 pb-12">
      {/* Step Progress Header */}
      <div className="glass-panel p-5 sm:p-6 rounded-2xl space-y-3">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/80 pb-3">
          <div>
            <span className="text-xs font-bold uppercase tracking-wider text-[#3559C7]">
              Step {currentStep} of 6
            </span>
            <h2 className="text-xl font-extrabold text-[#18213A]">
              {STEPS[currentStep - 1]}
            </h2>
          </div>
          <span className="text-xs text-[#69738A]">
            Configuring: <strong className="text-[#101B3D]">{activeCatDef.name}</strong>
          </span>
        </div>

        {/* Progress Bar Dots */}
        <div className="grid grid-cols-6 gap-2">
          {STEPS.map((s, i) => {
            const stepNum = i + 1;
            const isCompleted = stepNum < currentStep;
            const isCurrent = stepNum === currentStep;

            return (
              <div
                key={s}
                onClick={() => {
                  if (stepNum < currentStep) setCurrentStep(stepNum);
                }}
                className={`h-2 rounded-full transition-all duration-300 ${
                  isCompleted
                    ? 'bg-[#3559C7] cursor-pointer'
                    : isCurrent
                    ? 'bg-[#D6AD60] shadow-sm'
                    : 'bg-white/60 border border-white/70'
                }`}
                title={s}
              />
            );
          })}
        </div>
      </div>

      {/* Validation Error Banner */}
      {errorMsg && (
        <div className="bg-red-50/90 backdrop-blur-md border border-red-200 text-[#C34D4D] p-3.5 rounded-xl flex items-center gap-3 text-sm font-semibold">
          <AlertCircle className="w-5 h-5 shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}

      {/* STEP 1: Select Category */}
      {currentStep === 1 && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="space-y-4"
        >
          <div>
            <h3 className="text-lg font-bold text-[#18213A]">
              Choose the Product Category
            </h3>
            <p className="text-xs text-[#69738A]">
              Scoring criteria dynamically adapt specifically to your chosen product category.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
            {CATEGORY_DEFINITIONS.map((cat) => {
              const Icon = cat.icon;
              const isSelected = category === cat.id;

              return (
                <div
                  key={cat.id}
                  onClick={() => setCategory(cat.id)}
                  className={`p-5 rounded-2xl glass-panel glass-card-hover border transition-all cursor-pointer flex flex-col justify-between space-y-3 ${
                    isSelected
                      ? 'border-[#3559C7] bg-white/90 shadow-md ring-2 ring-[#3559C7]'
                      : 'border-white/80 hover:border-[#3559C7]/50'
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div
                      className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                        isSelected
                          ? 'bg-[#101B3D] text-[#D6AD60]'
                          : 'bg-white/70 border border-white/90 text-[#18213A]'
                      }`}
                    >
                      <Icon className="w-6 h-6" />
                    </div>
                    {isSelected && (
                      <span className="w-6 h-6 rounded-full bg-[#3559C7] text-white flex items-center justify-center">
                        <Check className="w-4 h-4 stroke-[3]" />
                      </span>
                    )}
                  </div>

                  <div>
                    <h4 className="font-bold text-[#18213A] text-base">
                      {cat.name}
                    </h4>
                    <p className="text-xs text-[#69738A] mt-1">
                      {cat.usages.length} workflows, {cat.priorities.length} priority factors
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </motion.div>
      )}

      {/* STEP 2: Set Budget (INR) */}
      {currentStep === 2 && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="glass-panel p-6 md:p-8 rounded-2xl space-y-6"
        >
          <div>
            <h3 className="text-lg font-bold text-[#18213A]">
              What is your maximum target budget?
            </h3>
            <p className="text-xs text-[#69738A]">
              WORTHLY strictly enforces budget limits in Indian Rupees (₹). No over-budget models will be displayed without explicit flexibility.
            </p>
          </div>

          {/* Quick Presets */}
          <div className="space-y-2">
            <span className="text-xs font-semibold text-[#69738A]">
              Quick INR Budget Presets:
            </span>
            <div className="flex flex-wrap gap-2.5">
              {activeCatDef.budgetPresets.map((preset) => (
                <button
                  key={preset}
                  onClick={() => setMaxBudget(preset)}
                  className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition cursor-pointer ${
                    maxBudget === preset
                      ? 'bg-[#101B3D] text-[#FFF9EF] shadow-xs'
                      : 'glass-pill text-[#18213A] hover:bg-white'
                  }`}
                >
                  {formatINR(preset)}
                </button>
              ))}
            </div>
          </div>

          {/* Budget Input & Range */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-1">
            <div className="space-y-1.5">
              <label className="text-xs font-bold uppercase tracking-wider text-[#101B3D] flex items-center gap-1.5">
                Maximum Budget Limit (Strict Limit)
              </label>
              <div className="relative">
                <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-500 font-bold">₹</span>
                <input
                  type="number"
                  min="2000"
                  max="1000000"
                  step="1000"
                  value={maxBudget}
                  onChange={(e) => setMaxBudget(Number(e.target.value))}
                  className="w-full pl-8 pr-4 py-2.5 rounded-xl glass-input font-bold text-base text-[#18213A]"
                />
              </div>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-bold uppercase tracking-wider text-[#69738A] flex items-center gap-1.5">
                Minimum Budget (Optional Floor)
              </label>
              <div className="relative">
                <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-500 font-bold">₹</span>
                <input
                  type="number"
                  min="0"
                  placeholder="0 (No floor)"
                  value={minBudget}
                  onChange={(e) => setMinBudget(e.target.value)}
                  className="w-full pl-8 pr-4 py-2.5 rounded-xl glass-input font-semibold text-base text-[#18213A]"
                />
              </div>
            </div>
          </div>

          {/* Slider */}
          <div className="space-y-2 pt-1">
            <input
              type="range"
              min={activeCatDef.minSlider}
              max={activeCatDef.maxSlider}
              step={activeCatDef.stepSlider}
              value={maxBudget}
              onChange={(e) => setMaxBudget(Number(e.target.value))}
              className="w-full accent-[#3559C7] cursor-pointer"
            />
            <div className="flex justify-between text-xs text-[#69738A]">
              <span>{formatINR(activeCatDef.minSlider)}</span>
              <span>{formatINR(activeCatDef.maxSlider / 2)}</span>
              <span>{formatINR(activeCatDef.maxSlider)}+</span>
            </div>
          </div>

          {/* Budget Flexibility Toggle */}
          <div className="p-3.5 rounded-xl bg-white/60 backdrop-blur-md border border-white/80 flex items-start gap-3">
            <input
              type="checkbox"
              id="flexibilityToggle"
              checked={allowFlexibility}
              onChange={(e) => setAllowFlexibility(e.target.checked)}
              className="mt-1 w-4 h-4 accent-[#3559C7] rounded"
            />
            <label htmlFor="flexibilityToggle" className="text-xs text-[#18213A] cursor-pointer">
              <span className="font-bold block text-sm">Allow subtle budget flexibility (+15%)</span>
              If a product vastly outscores all alternatives for just a small margin above budget, allow the engine to evaluate it.
            </label>
          </div>
        </motion.div>
      )}

      {/* STEP 3: Select Intended Usage */}
      {currentStep === 3 && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="space-y-4"
        >
          <div>
            <h3 className="text-lg font-bold text-[#18213A]">
              How will you use this {activeCatDef.name.toLowerCase()}?
            </h3>
            <p className="text-xs text-[#69738A]">
              Select all scenarios that reflect your typical routine. Questions adapt to your category.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {activeCatDef.usages.map((u) => {
              const isSelected = selectedUsages.includes(u.id);

              return (
                <div
                  key={u.id}
                  onClick={() => toggleUsage(u.id)}
                  className={`p-4 rounded-2xl glass-panel glass-card-hover border transition cursor-pointer flex items-start justify-between gap-3 ${
                    isSelected
                      ? 'border-[#3559C7] bg-white/90 shadow-sm ring-1 ring-[#3559C7]'
                      : 'border-white/80 hover:border-[#3559C7]/40'
                  }`}
                >
                  <div className="space-y-1">
                    <h4 className="font-bold text-sm text-[#18213A]">
                      {u.label}
                    </h4>
                    <p className="text-xs text-[#69738A] leading-relaxed">
                      {u.desc}
                    </p>
                  </div>
                  <div
                    className={`w-6 h-6 rounded-lg flex items-center justify-center shrink-0 border ${
                      isSelected
                        ? 'bg-[#3559C7] border-[#3559C7] text-white'
                        : 'border-[#E6E0D5] bg-white'
                    }`}
                  >
                    {isSelected && <Check className="w-4 h-4 stroke-[3]" />}
                  </div>
                </div>
              );
            })}
          </div>
        </motion.div>
      )}

      {/* STEP 4: Select Priorities */}
      {currentStep === 4 && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="space-y-4"
        >
          <div>
            <h3 className="text-lg font-bold text-[#18213A]">
              Choose Your Top Priorities
            </h3>
            <p className="text-xs text-[#69738A]">
              Select up to 3 factors that matter most to you (ranked by priority).
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
            {activeCatDef.priorities.map((p) => {
              const isSelected = selectedPriorities.includes(p.id);
              const rank = selectedPriorities.indexOf(p.id) + 1;

              return (
                <div
                  key={p.id}
                  onClick={() => togglePriority(p.id)}
                  className={`p-4 rounded-2xl glass-panel glass-card-hover border transition cursor-pointer flex flex-col justify-between space-y-3 ${
                    isSelected
                      ? 'border-[#D6AD60] bg-white/90 shadow-sm ring-1 ring-[#D6AD60]'
                      : 'border-white/80 hover:border-[#D6AD60]/50'
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold text-[#3559C7]">
                      {isSelected ? `Priority #${rank}` : 'Factor'}
                    </span>
                    <div
                      className={`w-6 h-6 rounded-full flex items-center justify-center font-bold text-xs ${
                        isSelected
                          ? 'bg-[#D6AD60] text-[#101B3D]'
                          : 'border border-[#E6E0D5] text-transparent'
                      }`}
                    >
                      {isSelected ? rank : ''}
                    </div>
                  </div>

                  <div>
                    <h4 className="font-bold text-sm text-[#18213A]">
                      {p.label}
                    </h4>
                    <p className="text-xs text-[#69738A] mt-1 leading-relaxed">
                      {p.desc}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </motion.div>
      )}

      {/* STEP 5: Optional Requirements */}
      {currentStep === 5 && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="glass-panel p-5 sm:p-7 rounded-2xl space-y-5"
        >
          <div>
            <h3 className="text-lg font-bold text-[#18213A]">
              Optional Constraints & Preferences
            </h3>
            <p className="text-xs text-[#69738A]">
              Fine-tune technical requirements if desired. Leave as "Any" if you prefer standard matching.
            </p>
          </div>

          <div className="space-y-3.5">
            {activeCatDef.optionalFields?.map((field) => {
              if (field.type === 'select') {
                return (
                  <div key={field.id} className="space-y-1.5">
                    <label className="text-xs font-bold text-[#18213A]">
                      {field.label}
                    </label>
                    <select
                      value={optionalSpecs[field.id] || 'Any'}
                      onChange={(e) =>
                        setOptionalSpecs({
                          ...optionalSpecs,
                          [field.id]: e.target.value
                        })
                      }
                      className="w-full px-4 py-2.5 rounded-xl glass-input text-sm font-medium text-[#18213A]"
                    >
                      {field.options.map((opt) => (
                        <option key={opt} value={opt}>
                          {opt}
                        </option>
                      ))}
                    </select>
                  </div>
                );
              }

              if (field.type === 'boolean') {
                return (
                  <div
                    key={field.id}
                    className="p-3.5 rounded-xl bg-white/60 backdrop-blur-md border border-white/80 flex items-center justify-between"
                  >
                    <div>
                      <h4 className="text-sm font-bold text-[#18213A]">
                        {field.label}
                      </h4>
                      <p className="text-xs text-[#69738A]">
                        Hard requirement: filters out products lacking this hardware.
                      </p>
                    </div>
                    <input
                      type="checkbox"
                      checked={Boolean(optionalSpecs[field.id])}
                      onChange={(e) =>
                        setOptionalSpecs({
                          ...optionalSpecs,
                          [field.id]: e.target.checked
                        })
                      }
                      className="w-5 h-5 accent-[#3559C7] rounded"
                    />
                  </div>
                );
              }

              return null;
            })}
          </div>
        </motion.div>
      )}

      {/* STEP 6: Review Requirements */}
      {currentStep === 6 && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="glass-panel p-5 sm:p-7 rounded-2xl space-y-5"
        >
          <div>
            <h3 className="text-xl font-bold text-[#18213A]">
              Review Your Requirements
            </h3>
            <p className="text-xs text-[#69738A]">
              Confirm your criteria before the recommendation engine evaluates the verified Indian dataset.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl glass-panel-subtle border border-white/80 space-y-1.5">
              <span className="text-xs font-bold text-[#3559C7] uppercase tracking-wider">
                Category & Budget (INR)
              </span>
              <p className="text-sm font-bold text-[#18213A]">
                {activeCatDef.name}
              </p>
              <p className="text-xs text-[#69738A]">
                Budget: <strong>{formatINR(minBudget || 0)} - {formatINR(maxBudget)}</strong> {allowFlexibility ? '(+15% flexibility allowed)' : '(Strict Ceiling)'}
              </p>
              <button
                onClick={() => setCurrentStep(2)}
                className="text-xs text-[#3559C7] font-semibold underline pt-1 block cursor-pointer"
              >
                Edit Budget
              </button>
            </div>

            <div className="p-4 rounded-xl glass-panel-subtle border border-white/80 space-y-1.5">
              <span className="text-xs font-bold text-[#3559C7] uppercase tracking-wider">
                Intended Workflows ({selectedUsages.length})
              </span>
              <div className="flex flex-wrap gap-1.5 pt-1">
                {selectedUsages.map((uid) => (
                  <span
                    key={uid}
                    className="text-xs bg-[#101B3D] text-[#FFF9EF] px-2.5 py-0.5 rounded-full font-medium"
                  >
                    {activeCatDef.usages.find((u) => u.id === uid)?.label || uid}
                  </span>
                ))}
              </div>
              <button
                onClick={() => setCurrentStep(3)}
                className="text-xs text-[#3559C7] font-semibold underline pt-1 block cursor-pointer"
              >
                Edit Workflows
              </button>
            </div>

            <div className="p-4 rounded-xl glass-panel-subtle border border-white/80 space-y-1.5">
              <span className="text-xs font-bold text-[#3559C7] uppercase tracking-wider">
                Ranked Priorities ({selectedPriorities.length})
              </span>
              <div className="flex flex-wrap gap-1.5 pt-1">
                {selectedPriorities.map((pid, idx) => (
                  <span
                    key={pid}
                    className="text-xs bg-[#D6AD60] text-[#101B3D] px-2.5 py-0.5 rounded-full font-bold"
                  >
                    #{idx + 1} {activeCatDef.priorities.find((p) => p.id === pid)?.label || pid}
                  </span>
                ))}
              </div>
              <button
                onClick={() => setCurrentStep(4)}
                className="text-xs text-[#3559C7] font-semibold underline pt-1 block cursor-pointer"
              >
                Edit Priorities
              </button>
            </div>

            <div className="p-4 rounded-xl glass-panel-subtle border border-white/80 space-y-1.5">
              <span className="text-xs font-bold text-[#3559C7] uppercase tracking-wider">
                Technical Preferences
              </span>
              <p className="text-xs text-[#18213A] leading-relaxed">
                Brand: <strong>{optionalSpecs.preferred_brand || 'Any'}</strong>
                {optionalSpecs.min_ram && <> | Min RAM: <strong>{optionalSpecs.min_ram}</strong></>}
                {optionalSpecs.dedicated_gpu && <> | <strong>Dedicated GPU Required</strong></>}
              </p>
              <button
                onClick={() => setCurrentStep(5)}
                className="text-xs text-[#3559C7] font-semibold underline pt-1 block cursor-pointer"
              >
                Edit Preferences
              </button>
            </div>
          </div>
        </motion.div>
      )}

      {/* Wizard Navigation Footer */}
      <div className="flex items-center justify-between pt-4">
        {currentStep > 1 ? (
          <button
            onClick={handleBack}
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-xs font-semibold text-[#18213A] bg-white/70 hover:bg-white border border-white/80 shadow-xs transition cursor-pointer"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Previous Step</span>
          </button>
        ) : (
          <div />
        )}

        {currentStep < 6 ? (
          <button
            onClick={handleNext}
            className="flex items-center gap-2 px-6 py-2.5 rounded-xl text-xs font-bold bg-[#3559C7] hover:bg-[#2e4eb2] text-white transition shadow-sm"
          >
            <span>Next: {STEPS[currentStep]}</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        ) : (
          <NeonBorder
            variant="button"
            onClick={handleNext}
            className="text-xs"
          >
            <Sparkles className="w-4 h-4 text-[#D6AD60]" />
            <span>Find My Top 3 Products</span>
            <ArrowRight className="w-4 h-4" />
          </NeonBorder>
        )}
      </div>
    </div>
  );
}

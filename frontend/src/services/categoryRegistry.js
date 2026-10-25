/**
 * WORTHLY - Frontend Canonical Category Registry & Normalization
 * Ensures every category appears EXACTLY ONCE across all dropdowns,
 * navigation bars, tabs, and filters throughout the application.
 */

export const CATEGORY_ALIASES = {
  // Smartphones
  smartphone: 'smartphones',
  smartphones: 'smartphones',
  mobile: 'smartphones',
  mobiles: 'smartphones',
  'mobile phone': 'smartphones',
  'mobile phones': 'smartphones',
  'cell phone': 'smartphones',
  'cell phones': 'smartphones',
  phones: 'smartphones',

  // Laptops
  laptop: 'laptops',
  laptops: 'laptops',
  notebook: 'laptops',
  notebooks: 'laptops',
  ultrabook: 'laptops',
  'laptops & computers': 'laptops',

  // Televisions
  tv: 'televisions',
  tvs: 'televisions',
  television: 'televisions',
  televisions: 'televisions',
  'smart tv': 'televisions',
  'smart tvs': 'televisions',
  'televisions & smart tvs': 'televisions',

  // Refrigerators
  refrigerator: 'refrigerators',
  refrigerators: 'refrigerators',
  fridge: 'refrigerators',
  fridges: 'refrigerators',
  'refrigerators & freezers': 'refrigerators',

  // Washing Machines
  'washing machine': 'washing_machines',
  'washing machines': 'washing_machines',
  washing_machine: 'washing_machines',
  washing_machines: 'washing_machines',
  washer: 'washing_machines',

  // Air Conditioners
  'air conditioner': 'air_conditioners',
  'air conditioners': 'air_conditioners',
  air_conditioner: 'air_conditioners',
  air_conditioners: 'air_conditioners',
  ac: 'air_conditioners',
  acs: 'air_conditioners',

  // Tablets & Monitors
  tablet: 'tablets_monitors',
  tablets: 'tablets_monitors',
  monitor: 'tablets_monitors',
  monitors: 'tablets_monitors',
  'tablets & displays': 'tablets_monitors',
  'tablets and monitors': 'tablets_monitors',
  tablets_monitors: 'tablets_monitors',

  // Audio & Wearables
  consumer_electronics: 'consumer_electronics',
  'consumer electronics': 'consumer_electronics',
  'audio & wearables': 'consumer_electronics',
  audio: 'consumer_electronics',
  headphones: 'consumer_electronics',
  earbuds: 'consumer_electronics',
  smartwatch: 'consumer_electronics',
  smartwatches: 'consumer_electronics',

  // Fitness Equipment
  fitness: 'fitness_equipment',
  'fitness & sports': 'fitness_equipment',
  fitness_equipment: 'fitness_equipment',
  'fitness equipment': 'fitness_equipment',
  sports: 'fitness_equipment',
  gym: 'fitness_equipment',

  // Kitchen Chimneys
  kitchen_chimneys: 'kitchen_chimneys',
  'kitchen chimney': 'kitchen_chimneys',
  'kitchen chimneys': 'kitchen_chimneys',
  chimney: 'kitchen_chimneys',

  // Books
  book: 'books',
  books: 'books',
  'books & study materials': 'books',
  'study materials': 'books',
  education: 'books',
  'education & student essentials': 'books',

  // Magazines
  magazine: 'magazines',
  magazines: 'magazines',
  'magazines & periodicals': 'magazines',

  // Nutrition
  nutrition: 'nutrition',
  'protein & nutrition': 'nutrition',
  protein: 'nutrition',

  // Home & Kitchen
  home_kitchen: 'home_kitchen',
  'home & kitchen': 'home_kitchen',
  'home appliances': 'home_kitchen',

  // Furniture
  furniture: 'furniture',
  'furniture & home office': 'furniture',

  // Footwear
  footwear: 'footwear',
  'fashion & footwear': 'footwear',
  shoes: 'footwear'
};

export const CANONICAL_CATEGORIES = [
  {
    id: 'smartphones',
    name: 'Smartphones',
    description: 'Flagship, premium, and value 5G mobile smartphones',
    icon: 'Smartphone'
  },
  {
    id: 'laptops',
    name: 'Laptops & Computers',
    description: 'Productivity, ultrabook, creator, and gaming laptops',
    icon: 'Laptop'
  },
  {
    id: 'televisions',
    name: 'Televisions & Smart TVs',
    description: '4K OLED, QLED, Mini-LED, and Smart 4K UHD TVs',
    icon: 'Tv'
  },
  {
    id: 'refrigerators',
    name: 'Refrigerators & Freezers',
    description: 'Frost-free double door, French door, and side-by-side smart refrigerators',
    icon: 'Box'
  },
  {
    id: 'washing_machines',
    name: 'Washing Machines',
    description: 'Front load, top load, inverter, and smart washer-dryers',
    icon: 'Disc'
  },
  {
    id: 'air_conditioners',
    name: 'Air Conditioners',
    description: 'Smart inverter split ACs, dual inverter, and high-ambient cooling',
    icon: 'Wind'
  },
  {
    id: 'tablets_monitors',
    name: 'Tablets & Displays',
    description: 'Productivity tablets, iPads, graphic tablets, and 4K monitors',
    icon: 'Tablet'
  },
  {
    id: 'consumer_electronics',
    name: 'Audio & Wearables',
    description: 'Noise-cancelling headphones, wireless earbuds, smartwatches',
    icon: 'Headphones'
  },
  {
    id: 'fitness_equipment',
    name: 'Fitness Equipment',
    description: 'Home gym gear, treadmills, exercise bikes, and recovery gear',
    icon: 'Dumbbell'
  },
  {
    id: 'kitchen_chimneys',
    name: 'Kitchen Chimneys',
    description: 'Filterless, auto-clean, curved glass, and high-suction chimneys',
    icon: 'Flame'
  },
  {
    id: 'books',
    name: 'Books & Study Materials',
    description: 'Academic textbooks, reference manuals, and exam prep',
    icon: 'BookOpen'
  },
  {
    id: 'magazines',
    name: 'Magazines & Periodicals',
    description: 'Technology reviews, business intelligence, and scientific journals',
    icon: 'Newspaper'
  },
  {
    id: 'nutrition',
    name: 'Protein & Nutrition',
    description: 'Whey isolate, plant protein, creatine, and performance nutrition',
    icon: 'ShieldCheck'
  },
  {
    id: 'home_kitchen',
    name: 'Home & Kitchen Appliances',
    description: 'Smart air fryers, multi-cookers, espresso machines, and blenders',
    icon: 'Home'
  },
  {
    id: 'furniture',
    name: 'Furniture & Home Office',
    description: 'Ergonomic executive chairs, dual-motor standing desks',
    icon: 'Armchair'
  },
  {
    id: 'footwear',
    name: 'Fashion & Footwear',
    description: 'Marathon distance running shoes, carbon-plated racers',
    icon: 'Footprints'
  }
];

const CANONICAL_IDS_SET = new Set(CANONICAL_CATEGORIES.map((c) => c.id));

export function normalizeCategoryId(raw) {
  if (!raw) return 'smartphones';
  const clean = String(raw).trim().toLowerCase();
  const cleanKey = clean.replace(/[\s\-_]+/g, ' ');
  if (CATEGORY_ALIASES[clean]) return CATEGORY_ALIASES[clean];
  if (CATEGORY_ALIASES[cleanKey]) return CATEGORY_ALIASES[cleanKey];

  if (CANONICAL_IDS_SET.has(clean)) return clean;
  return 'smartphones';
}

export function getCanonicalCategories() {
  return CANONICAL_CATEGORIES;
}

export function getCanonicalCategory(catId) {
  const norm = normalizeCategoryId(catId);
  return CANONICAL_CATEGORIES.find((c) => c.id === norm) || null;
}

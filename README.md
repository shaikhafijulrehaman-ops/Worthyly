# SmartBuy AI 🎯
> **"Your Needs. Your Budget. Your Best 3 Choices."**

SmartBuy AI is an intelligent product purchase decision platform. Unlike ordinary shopping search engines that require users to know product model numbers, SmartBuy AI allows buyers to simply describe their budget, intended usage, requirements, and preferences. The platform analyzes verified product datasets and recommends the three most suitable products, providing evidence-based explanations for each choice.

---

## 🎨 Design System & Palette

Crafted as a premium, modern SaaS dashboard using a bright warm-ivory surface with bold navy navigation, gold accents, and royal-blue highlights:

| Token | Hex | Role |
| :--- | :--- | :--- |
| **Royal Navy** | `#101B3D` | Primary brand identity, navigation sidebar, card accents |
| **Deep Navy** | `#17264F` | Sidebar sub-elements, dark card backings |
| **Primary Blue** | `#3559C7` | Active controls, highlights, primary action triggers |
| **Warm Ivory** | `#FFF9EF` | Main dashboard content surface, cozy readability |
| **Soft Ivory** | `#F7F1E6` | Secondary surfaces, table headers, pill backgrounds |
| **Pure White** | `#FFFFFF` | Content card surfaces, modals |
| **Gold Accent** | `#D6AD60` | Trophy accents, score indicators, premium status badges |
| **Main Text** | `#18213A` | High-contrast readable typography |
| **Secondary Text** | `#69738A` | Sub-labels, captions, specifications |
| **Borders** | `#E6E0D5` | Subtle neutral dividers |
| **Success** | `#23865B` | Verified purchases, advantages |
| **Warning** | `#C58B28` | Budget warnings |
| **Error** | `#C34D4D` | Budget exclusions, disadvantages |

---

## ⚡ Originkit Neon Border Component

SmartBuy AI incorporates the **Originkit Neon Border** design effect selectively for high-value interactions:
- Primary **"Find My Best Match"** wizard launch buttons
- The highlighted **"Best Overall Match"** recommendation card
- Active AI heuristic evaluation states

### Security Compliance
- Authenticates via the `ORIGINKIT_API_KEY` environment variable.
- Secrets are never hardcoded in client-side code or committed to Git.
- When `ORIGINKIT_API_KEY` is not present in the environment, the application automatically uses the native CSS-based Neon Border component with a refined royal-blue (`#3559C7`) and warm-gold (`#D6AD60`) glow.

---

## 🚀 Key Functional Pages

The platform features 9 fully functional sections accessible from the responsive sidebar:

1. **Overview / Landing Page**: Hero section, "Find My Best Match" CTA with Neon Border, 6 category grid, and 4-step "How It Works" walkthrough.
2. **Find My Product (Requirement Builder)**: 6-step wizard:
   - *Step 1: Select Category* (adaptive cards)
   - *Step 2: Set Budget* (min & max inputs, slider, quick presets, strict budget toggle)
   - *Step 3: Select Intended Usage* (category-dependent scenarios)
   - *Step 4: Select Priorities* (ranked top 3 factors)
   - *Step 5: Optional Specs* (RAM, dedicated GPU, brand preferences)
   - *Step 6: Review & Submit* (summary with editable steps)
3. **Top 3 Recommendations**:
   - `BEST OVERALL MATCH` (highlighted with Neon Border)
   - `BEST VALUE` (optimal score-to-price ratio)
   - `BEST ALTERNATIVE` (distinct form-factor or brand)
   - Animated match percentage gauges, evidence-based bullet explanations, advantages, and disadvantages.
4. **Product Explorer**: Searchable, filterable catalogue across categories, brands, price ranges, and sorting modes (price, rating, reviews).
5. **Product Comparison**: Side-by-side shootout matrix for 2-3 products, automatic difference highlighting, and priority-alignment winner analysis.
6. **Community Reviews**: Verified review ecosystem with rating distribution graphs, intended usage scenarios, pros/cons, and moderation reporting.
7. **Budget Finder**: Analyzes any custom budget into 4 distinct non-interchangeable tiers:
   - *Lowest Price* vs *Budget Friendly* vs *Best Value* vs *Best Performance*, along with direct specification compromise analysis.
8. **Saved Products**: Bookmarked items shortlist and stored shootout comparisons with one-click restore.
9. **Settings**: User profile, default budget preferences, recommendation strictness toggles, and data export.

---

## 🧠 Deterministic Recommendation Engine

The recommendation engine strictly adheres to factual verification:
- **Mandatory Budget Constraints**: Over-budget items are strictly excluded unless the user explicitly enables budget flexibility (+15%).
- **Hard Technical Requirements**: Dedicated GPU and RAM thresholds are verified before scoring.
- **Category-Specific Scoring Rules**:
  - *Electronics*: Multi-core processor suitability, RAM headroom (16GB vs 32GB+), dedicated ray-tracing GPUs, thermal profiles.
  - *Footwear*: Cushioning foam technologies (ReactX, DNA LOFT), outsole durability, drop height, and foot strike intent.
  - *Home & Kitchen*: Heating mechanisms, dishwasher-safe components, capacity, and hands-off automation.
  - *Furniture*: PostureFit lumbar ergonomics, weight limits, dual motors, and manufacturer warranties.
  - *Fitness & Sports*: Multi-band GPS accuracy, subscription-free data models, and adjustable weight increments.
  - *Education*: Paper-feel stylus latency, battery endurance, and noise cancellation.
- **Transparent Evidence Generation**: Formulates real explanations based on the product's actual specifications.

---

## 🛠️ Tech Stack

- **Frontend**: React 19, Vite, Tailwind CSS v4, Framer Motion, Lucide React, Canvas Confetti.
- **Backend API**: Python 3.12+, FastAPI, Uvicorn, Pydantic, Pytest.
- **Database / Storage**: PostgreSQL / Supabase schema (`backend/schema.sql`) with client-side demo persistence.

---

## 💻 Setup & Running Locally

### 1. Start the FastAPI Backend
```bash
# Navigate to workspace
cd Michack

# Run pytest unit tests to verify recommendation logic
py -3.12 -m pytest backend/tests -v

# Start FastAPI server on port 8000
py -3.12 -m uvicorn backend.main:app --host 127.0.0.1 --port 8000 --reload
```
The FastAPI backend will start at `http://127.0.0.1:8000` with interactive Swagger docs at `http://127.0.0.1:8000/docs`.

### 2. Start the React Frontend
```bash
# In a separate terminal
cd Michack/frontend

# Install dependencies (if not already installed)
npm install

# Start Vite dev server
npm run dev
```
Open `http://localhost:5173` in your browser.

---

## 🧪 Testing

Run backend tests using:
```bash
py -3.12 -m pytest backend/tests -v
```
Tests verify:
- Strict budget enforcement (over-budget exclusions)
- 3 distinct role assignments (`BEST OVERALL MATCH`, `BEST VALUE`, `BEST ALTERNATIVE`)
- Category-specific scoring logic
- Insufficient products handling with available range notice
- Budget finder tier calculations

---

## 🔒 Security & Data Integrity

- No secrets or keys are hardcoded in source code.
- Verified price timestamps and authorized retail sources are explicitly displayed on all product cards.
- Client-side and backend validation protect against invalid budget inputs and empty review submissions.

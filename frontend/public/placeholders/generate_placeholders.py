import os

out_dir = os.path.join("frontend", "public", "placeholders")
os.makedirs(out_dir, exist_ok=True)

CATEGORIES = [
    ("smartphones", "Smartphone", "M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"),
    ("laptops", "Laptop", "M20 16V4a2 2 0 00-2-2H6a2 2 0 00-2 2v12m16 0H4m16 0a2 2 0 012 2v1a1 1 0 01-1 1H3a1 1 0 01-1-1v-1a2 2 0 012-2"),
    ("televisions", "Television", "M20 7H4a2 2 0 00-2 2v10a2 2 0 002 2h16a2 2 0 002-2V9a2 2 0 00-2-2zM17 2l-5 5-5-5"),
    ("refrigerators", "Refrigerator", "M5 3a2 2 0 012-2h10a2 2 0 012 2v18a2 2 0 01-2 2H7a2 2 0 01-2-2V3zm0 7h14M9 6v1m0 8v3"),
    ("washing_machines", "Washing Machine", "M4 4a2 2 0 012-2h12a2 2 0 012 2v16a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm8 14a5 5 0 100-10 5 5 0 000 10zm0-3a2 2 0 100-4 2 2 0 000 4z"),
    ("air_conditioners", "Air Conditioner", "M3 6a2 2 0 012-2h14a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2V6zm4 11l2 2m4-2l2 2m4-2l2 2"),
    ("tablets_monitors", "Tablet & Display", "M12 18h.01M5 3h14a2 2 0 012 2v14a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2z"),
    ("consumer_electronics", "Audio & Wearables", "M3 18v-6a9 9 0 0118 0v6M21 19a2 2 0 01-2 2h-1a2 2 0 01-2-2v-3a2 2 0 012-2h3zM3 19a2 2 0 002 2h1a2 2 0 002-2v-3a2 2 0 00-2-2H3z"),
    ("fitness_equipment", "Fitness Equipment", "M6 5v14M18 5v14M3 9v6M21 9v6M6 12h12"),
    ("kitchen_chimneys", "Kitchen Chimney", "M8 21h8M12 17v4M4 17l4-9h8l4 9H4zM9 8V3h6v5"),
    ("books", "Books & Study", "M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"),
    ("magazines", "Magazines", "M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m4 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"),
    ("nutrition", "Protein & Nutrition", "M12 2l7 4v6c0 5.5-3.8 10.7-7 12-3.2-1.3-7-6.5-7-12V6l7-4zm0 6a2 2 0 100 4 2 2 0 000-4z"),
    ("home_kitchen", "Home & Kitchen", "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"),
    ("furniture", "Furniture", "M5 11l2-7h10l2 7M4 11h16a1 1 0 011 1v7a1 1 0 01-1 1H4a1 1 0 01-1-1v-7a1 1 0 011-1zm2 8v3m12-3v3"),
    ("footwear", "Footwear", "M4 16l3-10h4l2 5 7 1a2 2 0 012 2v2a2 2 0 01-2 2H4a2 2 0 01-2-2v-1a1 1 0 011-1h1"),
    ("default_product", "Product Image Pending", "M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z")
]

for slug, label, path_data in CATEGORIES:
    svg_content = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 300" width="100%" height="100%">
  <defs>
    <linearGradient id="bg_{slug}" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0f172a" />
      <stop offset="100%" stop-color="#1e293b" />
    </linearGradient>
    <linearGradient id="acc_{slug}" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#38bdf8" />
      <stop offset="100%" stop-color="#818cf8" />
    </linearGradient>
  </defs>
  <rect width="400" height="300" rx="16" fill="url(#bg_{slug})" stroke="#334155" stroke-width="2"/>
  <circle cx="200" cy="120" r="48" fill="#1e293b" stroke="#475569" stroke-width="1.5"/>
  <path d="{path_data}" transform="translate(186, 106) scale(1.15)" fill="none" stroke="url(#acc_{slug})" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <text x="200" y="200" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="14" font-weight="600" fill="#f8fafc" letter-spacing="0.5">{label}</text>
  <text x="200" y="222" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="11" fill="#94a3b8">Verified Image Pending • Specification Confirmed</text>
  <rect x="140" y="240" width="120" height="20" rx="10" fill="#0f172a" stroke="#334155" stroke-width="1"/>
  <text x="200" y="254" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="9" font-weight="700" fill="#38bdf8" letter-spacing="1">WORTHLY VERIFIED</text>
</svg>'''
    filepath = os.path.join(out_dir, f"{slug}.svg")
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(svg_content)

print(f"Generated {len(CATEGORIES)} neutral SVG placeholders in {out_dir}")

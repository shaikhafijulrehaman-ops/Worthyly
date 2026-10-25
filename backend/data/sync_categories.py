import json
import os
import sys

sys.path.insert(0, os.path.abspath('backend'))
from category_registry import CANONICAL_CATEGORIES, normalize_category_id

backend_cats_path = os.path.join('backend', 'data', 'categories.json')
frontend_cats_path = os.path.join('frontend', 'src', 'services', 'fallbackCategories.json')

with open(backend_cats_path, 'r', encoding='utf-8') as f:
    existing_data = json.load(f)

existing_cats = existing_data.get('categories', [])
existing_by_id = {c['id']: c for c in existing_cats}

# Build unified, deduplicated categories list matching CANONICAL_CATEGORIES
unified_cats = []
for cdef in CANONICAL_CATEGORIES:
    cid = cdef['id']
    # Merge existing rich presets/usages/priorities if available
    if cid in existing_by_id:
        entry = dict(existing_by_id[cid])
        entry['id'] = cid
        entry['name'] = cdef['name']
        entry['description'] = cdef['description']
        entry['icon'] = cdef['icon']
    else:
        entry = {
            'id': cid,
            'name': cdef['name'],
            'description': cdef['description'],
            'icon': cdef['icon'],
            'budgetPresets': cdef['budgetPresets'],
            'defaultMax': cdef['defaultMax'],
            'budgetRange': cdef['budgetRange'],
            'usages': [{'id': 'general', 'label': f'General {cdef["name"]} Use'}],
            'priorities': [{'id': 'performance', 'label': 'Performance & Reliability'}, {'id': 'value', 'label': 'Value for Money'}],
            'optionalSpecs': []
        }
    unified_cats.append(entry)

print(f"Total canonical categories generated: {len(unified_cats)}")
print("Categories:")
for c in unified_cats:
    print(f"  {c['id']}: {c['name']}")

output_data = {'categories': unified_cats}

with open(backend_cats_path, 'w', encoding='utf-8') as f:
    json.dump(output_data, f, indent=2)
print(f"Updated {backend_cats_path}")

with open(frontend_cats_path, 'w', encoding='utf-8') as f:
    json.dump(unified_cats, f, indent=2)
print(f"Updated {frontend_cats_path}")

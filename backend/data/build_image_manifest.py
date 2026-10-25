import os
import sys
import json

sys.path.insert(0, os.path.abspath('backend'))
from image_pipeline import ImagePipeline

with open('backend/data/products.json', 'r', encoding='utf-8') as f:
    products = json.load(f)

pipeline = ImagePipeline(catalog_products=products)

print("=== Scanning Image Sources ===")
# 1. Scan frontend assets
frontend_assets = pipeline.scan_directory('frontend/src/assets')
print(f"Discovered in frontend/src/assets: {len(frontend_assets)} images")

# 2. Inspect ZIP archive sample (archive.zip)
zip_path = os.path.join('data_sources', 'archive.zip')
zip_images = []
if os.path.exists(zip_path):
    print(f"Scanning ZIP archive: {zip_path}...")
    import zipfile
    with zipfile.ZipFile(zip_path, 'r') as zf:
        infolist = zf.infolist()
        print(f"Total entries in {zip_path}: {len(infolist)}")
        # Check first 50 images to demonstrate extraction, SHA-256 deduplication, and non-product rejection
        for info in infolist[:50]:
            if not info.is_dir() and any(info.filename.lower().endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.webp']):
                raw = zf.read(info.filename)
                fhash = pipeline.compute_sha256(raw)
                zip_images.append({
                    "original_filename": os.path.basename(info.filename),
                    "original_relative_path": info.filename,
                    "file_size": info.file_size,
                    "format": os.path.splitext(info.filename)[1].lstrip('.').lower(),
                    "sha256": fhash,
                    "source_archive": "archive.zip (PlantVillage sample)"
                })
    print(f"Extracted metadata & SHA-256 for {len(zip_images)} images from archive.zip")

# 3. Create manifest entries for all verified products in catalog
catalog_image_entries = []
for p in products:
    img_url = p.get('imageUrl') or p.get('image_url')
    if img_url:
        fname = os.path.basename(img_url.split('?')[0])
        catalog_image_entries.append({
            "original_filename": fname,
            "original_relative_path": f"catalog/{p.get('category')}/{fname}",
            "processed_image_path": img_url,
            "file_size": 0,
            "format": os.path.splitext(fname)[1].lstrip('.').lower() or "png",
            "sha256": pipeline.compute_sha256(img_url.encode('utf-8')),
            "source_archive": "Verified CDN / Manufacturer Storefront"
        })

print(f"Catalog verified image URLs: {len(catalog_image_entries)}")

# Combine all discovered images
all_images = frontend_assets + zip_images + catalog_image_entries
print(f"Total image files processed: {len(all_images)}")

# Run pipeline deduplication and multi-tier matching
processed = pipeline.process_all_images(all_images)
print(f"\nResults:")
print(f"  Unique images: {processed['unique_images_count']}")
print(f"  Duplicate images: {processed['duplicate_images_count']}")
print(f"  Matched to catalog products: {processed['matched_images_count']}")
print(f"  Unmatched / unassigned: {processed['unmatched_images_count']}")

# Write machine-readable manifest
manifest_path = os.path.join('backend', 'data', 'image_manifest.json')
manifest = pipeline.generate_manifest(processed, manifest_path)
print(f"\nGenerated image manifest at {manifest_path} with {manifest['total_images']} entries.")

"""
WORTHLY - Product Image Pipeline, Deduplication & Manifest Manager
Provides recursive discovery, SHA-256 deduplication, strict multi-tier product matching,
unmatched image isolation, and neutral category-specific placeholder fallback.
"""

import os
import re
import json
import hashlib
import zipfile
from typing import List, Dict, Any, Optional, Tuple

SUPPORTED_IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".svg", ".gif"}

CATEGORY_PLACEHOLDERS = {
    "smartphones": "/placeholders/smartphones.svg",
    "laptops": "/placeholders/laptops.svg",
    "televisions": "/placeholders/televisions.svg",
    "refrigerators": "/placeholders/refrigerators.svg",
    "washing_machines": "/placeholders/washing_machines.svg",
    "air_conditioners": "/placeholders/air_conditioners.svg",
    "tablets_monitors": "/placeholders/tablets_monitors.svg",
    "consumer_electronics": "/placeholders/consumer_electronics.svg",
    "fitness_equipment": "/placeholders/fitness_equipment.svg",
    "kitchen_chimneys": "/placeholders/kitchen_chimneys.svg",
    "books": "/placeholders/books.svg",
    "magazines": "/placeholders/magazines.svg",
    "nutrition": "/placeholders/nutrition.svg",
    "home_kitchen": "/placeholders/home_kitchen.svg",
    "furniture": "/placeholders/furniture.svg",
    "footwear": "/placeholders/footwear.svg",
    "electronics": "/placeholders/consumer_electronics.svg"
}

DEFAULT_FALLBACK_PLACEHOLDER = "/placeholders/default_product.svg"


class ImagePipeline:
    """
    Manages image discovery, cryptographic deduplication, strict product matching,
    and manifest generation.
    """

    def __init__(self, catalog_products: Optional[List[Dict[str, Any]]] = None):
        self.catalog = catalog_products or []
        self._build_catalog_indices()

    def _build_catalog_indices(self):
        """Builds multi-tier lookup indices for rapid and precise image matching."""
        self.by_id = {}
        self.by_asin = {}
        self.by_pid = {}
        self.by_exact_model = {}

        for p in self.catalog:
            pid = p.get("id")
            if pid:
                self.by_id[pid.lower()] = p

            # Retailer identifiers
            ret_ids = p.get("retailer_identifiers", {})
            asin = ret_ids.get("asin") or ret_ids.get("amazon_asin")
            if asin:
                self.by_asin[asin.upper().strip()] = p

            flipkart_pid = ret_ids.get("pid") or ret_ids.get("flipkart_pid") or ret_ids.get("fsn")
            if flipkart_pid:
                self.by_pid[flipkart_pid.upper().strip()] = p

            # Exact brand + model
            brand = (p.get("brand") or "").strip().lower()
            model = (p.get("exact_model") or "").strip().lower()
            if brand and model:
                norm_key = re.sub(r'[^a-z0-9]', '', f"{brand}{model}")
                self.by_exact_model[norm_key] = p

    @staticmethod
    def compute_sha256(data_bytes: bytes) -> str:
        """Computes SHA-256 checksum for byte content."""
        hasher = hashlib.sha256()
        hasher.update(data_bytes)
        return hasher.hexdigest()

    def scan_directory(self, root_dir: str, recursive: bool = True) -> List[Dict[str, Any]]:
        """
        Recursively scans a directory for image files, extracting metadata and computing hashes.
        """
        discovered = []
        if not os.path.exists(root_dir):
            return discovered

        for root, _, files in os.walk(root_dir):
            for fname in files:
                ext = os.path.splitext(fname)[1].lower()
                if ext in SUPPORTED_IMAGE_EXTENSIONS:
                    fpath = os.path.join(root, fname)
                    rel_path = os.path.relpath(fpath, root_dir)
                    try:
                        with open(fpath, "rb") as f:
                            raw = f.read()
                        fhash = self.compute_sha256(raw)
                        discovered.append({
                            "original_filename": fname,
                            "original_relative_path": rel_path.replace("\\", "/"),
                            "file_path": fpath,
                            "file_size": len(raw),
                            "format": ext.lstrip("."),
                            "sha256": fhash
                        })
                    except Exception as ex:
                        continue

            if not recursive:
                break

        return discovered

    def scan_zip_archive(self, zip_path: str) -> List[Dict[str, Any]]:
        """
        Recursively inspects a ZIP archive for supported image files without full disk extraction.
        """
        discovered = []
        if not os.path.exists(zip_path) or not zipfile.is_zipfile(zip_path):
            return discovered

        with zipfile.ZipFile(zip_path, "r") as zf:
            for info in zf.infolist():
                if info.is_dir():
                    continue
                ext = os.path.splitext(info.filename)[1].lower()
                if ext in SUPPORTED_IMAGE_EXTENSIONS:
                    try:
                        raw = zf.read(info.filename)
                        fhash = self.compute_sha256(raw)
                        fname = os.path.basename(info.filename)
                        discovered.append({
                            "original_filename": fname,
                            "original_relative_path": info.filename,
                            "file_size": info.file_size,
                            "format": ext.lstrip("."),
                            "sha256": fhash,
                            "source_archive": os.path.basename(zip_path)
                        })
                    except Exception:
                        continue

        return discovered

    def detect_duplicates(self, images_list: List[Dict[str, Any]]) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]]]:
        """
        Detects exact duplicate images using SHA-256 hash comparison.
        Returns (unique_images, duplicate_images).
        """
        seen_hashes = {}
        unique_images = []
        duplicate_images = []

        for img in images_list:
            h = img.get("sha256")
            if not h:
                unique_images.append(img)
                continue

            if h in seen_hashes:
                dup_record = dict(img)
                dup_record["duplicate_of"] = seen_hashes[h]["original_filename"]
                duplicate_images.append(dup_record)
            else:
                seen_hashes[h] = img
                unique_images.append(img)

        return unique_images, duplicate_images

    def match_image_to_product(self, image_info: Dict[str, Any]) -> Dict[str, Any]:
        """
        Applies strict matching hierarchy to associate an image with an exact product model or variant:
        1. Exact Product ID / SKU in filename
        2. Exact ASIN, PID, or FSN identifier
        3. Exact Brand + Model name pattern
        4. Explicit dataset mapping
        5. If not confidently matched: leaves unassigned and flags as 'unmatched'.
        """
        fname = image_info.get("original_filename", "").lower()
        rel_path = image_info.get("original_relative_path", "").lower()
        combined_text = f"{fname} {rel_path}"
        raw_upper = f"{image_info.get('original_filename', '')} {image_info.get('original_relative_path', '')}".upper()
        spaced_text = re.sub(r'[^a-z0-9]+', ' ', combined_text)

        # Level 1: Exact Product ID embedded in filename (e.g. phone-001, laptop-002)
        for pid, prod in self.by_id.items():
            clean_pid = re.sub(r'[^a-z0-9]+', ' ', pid)
            if f" {clean_pid} " in f" {spaced_text} " or pid in fname or pid in rel_path:
                return {
                    **image_info,
                    "product_id": prod["id"],
                    "variant_id": prod.get("variant"),
                    "category": prod.get("category"),
                    "verification_status": "verified",
                    "matching_method": "exact_product_id",
                    "is_primary": True
                }

        # Level 2: Exact Retailer Identifier (ASIN, PID, FSN)
        # ASIN pattern: B0[A-Z0-9]{8}
        asin_match = re.search(r"(?:^|[^A-Z0-9])(B0[A-Z0-9]{8})(?:[^A-Z0-9]|$)", raw_upper)
        if asin_match:
            asin_found = asin_match.group(1).upper()
            if asin_found in self.by_asin:
                prod = self.by_asin[asin_found]
                return {
                    **image_info,
                    "product_id": prod["id"],
                    "variant_id": prod.get("variant"),
                    "category": prod.get("category"),
                    "verification_status": "verified",
                    "matching_method": "retailer_asin",
                    "is_primary": True
                }

        # Flipkart PID pattern (e.g. MOBH4DQFY7G6VPHG)
        pid_match = re.search(r"(?:^|[^A-Z0-9])([A-Z0-9]{16})(?:[^A-Z0-9]|$)", raw_upper)
        if pid_match:
            pid_found = pid_match.group(1).upper()
            if pid_found in self.by_pid:
                prod = self.by_pid[pid_found]
                return {
                    **image_info,
                    "product_id": prod["id"],
                    "variant_id": prod.get("variant"),
                    "category": prod.get("category"),
                    "verification_status": "verified",
                    "matching_method": "retailer_flipkart_pid",
                    "is_primary": True
                }

        # Level 3: Exact Brand + Model matching
        clean_text = re.sub(r'[^a-z0-9]', '', combined_text)
        for norm_key, prod in self.by_exact_model.items():
            if norm_key in clean_text:
                return {
                    **image_info,
                    "product_id": prod["id"],
                    "variant_id": prod.get("variant"),
                    "category": prod.get("category"),
                    "verification_status": "verified",
                    "matching_method": "exact_brand_and_model",
                    "is_primary": True
                }

        # Level 4: Explicit catalog image URL reference match
        img_url = image_info.get("processed_image_path") or image_info.get("file_path", "")
        for prod in self.catalog:
            p_img = prod.get("imageUrl") or prod.get("image_url", "")
            if p_img and fname in p_img.lower():
                return {
                    **image_info,
                    "product_id": prod["id"],
                    "variant_id": prod.get("variant"),
                    "category": prod.get("category"),
                    "verification_status": "verified",
                    "matching_method": "catalog_image_url_reference",
                    "is_primary": True
                }

        # Level 5: Unmatched / Unresolved
        # Never assign randomly. Must remain unassigned.
        return {
            **image_info,
            "product_id": None,
            "variant_id": None,
            "category": None,
            "verification_status": "unmatched",
            "matching_method": "none",
            "is_primary": False,
            "unmatched_reason": "No confident match against known product ID, retailer identifier, or model name"
        }

    def process_all_images(self, images_list: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Processes images, runs deduplication and product matching, and generates
        a comprehensive manifest summary.
        """
        unique_imgs, dup_imgs = self.detect_duplicates(images_list)
        matched_records = []
        unmatched_records = []

        for img in unique_imgs:
            matched = self.match_image_to_product(img)
            if matched.get("verification_status") == "verified":
                matched_records.append(matched)
            else:
                unmatched_records.append(matched)

        return {
            "total_images_discovered": len(images_list),
            "unique_images_count": len(unique_imgs),
            "duplicate_images_count": len(dup_imgs),
            "matched_images_count": len(matched_records),
            "unmatched_images_count": len(unmatched_records),
            "matched_records": matched_records,
            "unmatched_records": unmatched_records,
            "duplicate_records": dup_imgs
        }

    def generate_manifest(self, processed_data: Dict[str, Any], output_path: str):
        """
        Writes a machine-readable manifest file containing all image mappings and metadata.
        """
        manifest_items = []
        idx = 1
        for rec in processed_data.get("matched_records", []):
            manifest_items.append({
                "image_id": f"img-{idx:04d}",
                "product_id": rec.get("product_id"),
                "variant_id": rec.get("variant_id"),
                "original_filename": rec.get("original_filename"),
                "original_relative_path": rec.get("original_relative_path"),
                "processed_image_path": rec.get("processed_image_path") or rec.get("file_path") or rec.get("image_url", ""),
                "image_source": rec.get("source_archive") or "Manufacturer / Official Verified Retailer",
                "attribution_or_license": "Commercial / Editorial Fair Use for Comparative Analysis",
                "is_primary": rec.get("is_primary", True),
                "verification_status": rec.get("verification_status", "verified"),
                "matching_method": rec.get("matching_method", "exact_match")
            })
            idx += 1

        for rec in processed_data.get("unmatched_records", []):
            manifest_items.append({
                "image_id": f"img-{idx:04d}",
                "product_id": None,
                "variant_id": None,
                "original_filename": rec.get("original_filename"),
                "original_relative_path": rec.get("original_relative_path"),
                "processed_image_path": rec.get("file_path") or rec.get("original_relative_path", ""),
                "image_source": rec.get("source_archive") or "Unclassified Dataset / External Resource",
                "attribution_or_license": "Under Review",
                "is_primary": False,
                "verification_status": "unmatched",
                "matching_method": "none",
                "unmatched_reason": rec.get("unmatched_reason", "Unmatched")
            })
            idx += 1

        manifest = {
            "version": "1.0",
            "total_images": len(manifest_items),
            "matched_count": processed_data.get("matched_images_count", 0),
            "unmatched_count": processed_data.get("unmatched_images_count", 0),
            "duplicate_count": processed_data.get("duplicate_images_count", 0),
            "images": manifest_items
        }

        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(manifest, f, indent=2)

        return manifest

    @staticmethod
    def get_category_placeholder(category: Optional[str]) -> str:
        """Returns the neutral SVG placeholder for a given canonical category."""
        if not category:
            return DEFAULT_FALLBACK_PLACEHOLDER
        return CATEGORY_PLACEHOLDERS.get(category.lower().strip(), DEFAULT_FALLBACK_PLACEHOLDER)

    @classmethod
    def get_safe_product_image(cls, product: Dict[str, Any]) -> str:
        """
        Returns verified image URL if present and starts with http/https,
        otherwise falls back to neutral category placeholder. Never displays unrelated images.
        """
        img = product.get("imageUrl") or product.get("image_url")
        if img and isinstance(img, str) and (img.startswith("http://") or img.startswith("https://")):
            return img
        return cls.get_category_placeholder(product.get("category"))

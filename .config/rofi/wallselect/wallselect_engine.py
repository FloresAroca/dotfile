#!/usr/bin/env python3
import os
import sys
import glob
import random
from concurrent.futures import ThreadPoolExecutor
from PIL import Image, ImageOps, ImageDraw, ImageColor
import colorsys

WALL_DIR = os.path.expanduser("~/.config/wallpapers")
CACHE_DIR = os.path.expanduser("~/.cache/wallselect")
THUMB_DIR = os.path.join(CACHE_DIR, "thumbs")
CAT_DIR = os.path.join(CACHE_DIR, "categories")

os.makedirs(THUMB_DIR, exist_ok=True)
os.makedirs(CAT_DIR, exist_ok=True)

CATEGORIES = [
    ("all", "ALL", None, "#00f0ff"),
    ("Blue", "BLUE", "Blue", "#0099ff"),
    ("Red", "RED", "Red", "#ff0055"),
    ("Green", "GREEN", "Green", "#00ff66"),
    ("Oranje", "ORANJE", "Oranje", "#ffaa00"),
    ("Violet", "VIOLET", "Violet", "#d900ff"),
    ("Dark", "DARK", "Dark", "#546e7a"),
    ("Clear", "CLEAR", "Clear", "#00ffff"),
    ("Grey", "GREY", "Grey", "#90a4ae"),
    ("random", "RANDOM", None, "#ff00aa"),
]

KNOWN_FOLDERS = {"Blue", "Clear", "Dark", "Green", "Grey", "Oranje", "Red", "Violet"}


def classify_by_hsv(img_path):
    try:
        with Image.open(img_path) as img:
            img = img.convert("RGB").resize((40, 40))
            pixels = list(img.getdata())

            h_sum, s_sum, v_sum = 0, 0, 0
            for r, g, b in pixels:
                h, s, v = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
                h_sum += h * 360
                s_sum += s
                v_sum += v

            n = len(pixels)
            avg_h = h_sum / n
            avg_s = s_sum / n
            avg_v = v_sum / n

            if avg_v < 0.25:
                return "Dark"
            elif avg_v > 0.85 and avg_s < 0.15:
                return "Clear"
            elif avg_s < 0.15:
                return "Grey"

            if avg_h >= 345 or avg_h < 15:
                return "Red"
            elif 15 <= avg_h < 75:
                return "Oranje"
            elif 75 <= avg_h < 165:
                return "Green"
            elif 165 <= avg_h < 255:
                return "Blue"
            else:
                return "Violet"
    except Exception:
        return "Grey"


def get_wallpaper_category(img_path):
    parent = os.path.basename(os.path.dirname(img_path))
    if parent in KNOWN_FOLDERS:
        return parent
    return classify_by_hsv(img_path)


def get_thumb_path(img_path):
    safe_name = img_path.replace("/", "_").strip("_") + ".png"
    return os.path.join(THUMB_DIR, safe_name)


def generate_thumb(img_path):
    dst = get_thumb_path(img_path)
    if os.path.exists(dst) and os.path.getmtime(img_path) <= os.path.getmtime(dst):
        return dst
    try:
        with Image.open(img_path) as img:
            thumb = ImageOps.fit(img, (200, 400), Image.Resampling.LANCZOS)

            card = Image.new("RGBA", (200, 400), (10, 12, 18, 255))
            card.paste(thumb, (0, 0))

            overlay = Image.new("RGBA", (200, 400), (0, 0, 0, 0))
            draw = ImageDraw.Draw(overlay)

            # Subtle scanlines
            for y in range(0, 400, 4):
                draw.line([(0, y), (200, y)], fill=(0, 0, 0, 35))

            # Border accent
            draw.rectangle([0, 0, 199, 399], outline=(0, 240, 255, 90), width=1)

            final_img = Image.alpha_composite(card, overlay)
            final_img.convert("RGB").save(dst, "PNG", optimize=True)
    except Exception:
        pass
    return dst


def get_all_wallpapers():
    files = glob.glob(os.path.join(WALL_DIR, "**", "*"), recursive=True)
    wallpapers = []
    for f in sorted(files):
        if f.lower().endswith((".jpg", ".jpeg", ".png", ".webp")):
            wallpapers.append(f)
    return wallpapers


def generate_category_card(cat_id, cat_name, hex_color, cat_wallpapers):
    dst = os.path.join(CAT_DIR, f"{cat_id}.png")

    if os.path.exists(dst) and os.path.getsize(dst) > 0:
        return dst

    card = Image.new("RGBA", (200, 400), (10, 12, 18, 255))

    if cat_wallpapers and cat_id != "random":
        sf = random.choice(cat_wallpapers)
        try:
            with Image.open(sf) as img:
                crop = ImageOps.fit(img, (200, 400), Image.Resampling.LANCZOS)
                card.paste(crop, (0, 0))
        except Exception:
            pass

    overlay = Image.new("RGBA", (200, 400), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # Cyberpunk scanlines
    for y in range(0, 400, 4):
        draw.line([(0, y), (200, y)], fill=(0, 0, 0, 50))

    # Dark gradient overlay from bottom
    for y in range(400):
        alpha = int(190 * (y / 400.0) ** 1.3)
        draw.line([(0, y), (200, y)], fill=(6, 8, 12, alpha))

    rgb = ImageColor.getrgb(hex_color)

    # Double Neon Border
    draw.rectangle([0, 0, 199, 399], outline=(rgb[0], rgb[1], rgb[2], 240), width=2)
    draw.rectangle([2, 2, 197, 397], outline=(0, 0, 0, 180), width=1)

    # Top color badge bar
    draw.rectangle([0, 0, 199, 10], fill=rgb)

    card = Image.alpha_composite(card, overlay)
    card.convert("RGB").save(dst, "PNG")
    return dst


def sync_cache():
    wallpapers = get_all_wallpapers()
    with ThreadPoolExecutor(max_workers=8) as executor:
        executor.map(generate_thumb, wallpapers)


def list_categories():
    sync_cache()
    wallpapers = get_all_wallpapers()

    cat_map = {c[0]: [] for c in CATEGORIES if c[0] not in ("all", "random")}
    for w in wallpapers:
        cat = get_wallpaper_category(w)
        if cat in cat_map:
            cat_map[cat].append(w)
        else:
            cat_map.setdefault(cat, []).append(w)

    for cat_id, display_title, folder, hex_color in CATEGORIES:
        if cat_id == "all":
            cat_walls = wallpapers
            count_str = f"[{len(wallpapers)}]"
        elif cat_id == "random":
            cat_walls = wallpapers
            count_str = "[EXEC]"
        else:
            cat_walls = cat_map.get(cat_id, [])
            count_str = f"[{len(cat_walls)}]"

        card_icon = generate_category_card(cat_id, display_title, hex_color, cat_walls)

        full_label = f"{display_title} {count_str}".strip()
        print(f"{cat_id}\0display\x1f{full_label}\x1ficon\x1f{card_icon}")


def list_wallpapers(filter_cat=None):
    sync_cache()
    wallpapers = get_all_wallpapers()

    if filter_cat and filter_cat != "all":
        filtered = [w for w in wallpapers if get_wallpaper_category(w) == filter_cat]
    else:
        filtered = wallpapers

    back_icon = os.path.join(CAT_DIR, "all.png")
    print(f"BACK_TO_MENU\0display\x1f<< RETURN\x1ficon\x1f{back_icon}")

    for w in filtered:
        fname = os.path.basename(w)
        thumb = get_thumb_path(w)
        print(f"{w}\0display\x1f {fname}\x1ficon\x1f{thumb}")


def get_random_wallpaper(filter_cat=None):
    wallpapers = get_all_wallpapers()
    if filter_cat and filter_cat not in ("all", "random"):
        filtered = [w for w in wallpapers if get_wallpaper_category(w) == filter_cat]
    else:
        filtered = wallpapers
    if filtered:
        return random.choice(filtered)
    return None


if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "--categories":
            list_categories()
        elif cmd == "--wallpapers":
            cat = sys.argv[2] if len(sys.argv) > 2 else "all"
            list_wallpapers(cat)
        elif cmd == "--random":
            cat = sys.argv[2] if len(sys.argv) > 2 else None
            rw = get_random_wallpaper(cat)
            if rw:
                print(rw)
        elif cmd == "--sync":
            sync_cache()
            print("Cache synchronized.")
    else:
        list_categories()

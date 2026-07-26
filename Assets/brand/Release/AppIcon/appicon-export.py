#!/usr/bin/env python3
"""Export OneulRhythm App Icon from the Release SVG master.

Source of truth (geometry):
  Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg

Presentation only:
  - uniform scale to fit optical safe area
  - centering on the square canvas
  - approved Brand Lock day background
  - export resolution

Does not modify E10 geometry.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path
from xml.etree import ElementTree as ET

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[4]
SVG_MASTER = ROOT / "Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg"
OUT = ROOT / "Assets/brand/Release/AppIcon"

# Approved Brand Lock day field
BG_TOP = (0xE9, 0xEF, 0xE9)  # #E9EFE9
BG_BOTTOM = (0xD7, 0xE2, 0xD8)  # #D7E2D8

# Optical safe area: 14% clear margin each edge
MARGIN_RATIO = 0.14

NS = "{http://www.w3.org/2000/svg}"


def load_master() -> tuple[str, str]:
    root = ET.parse(SVG_MASTER).getroot()
    path_el = root.find(f"{NS}path")
    if path_el is None:
        raise SystemExit(f"No path in SVG master: {SVG_MASTER}")
    d = path_el.get("d")
    fill = path_el.get("fill") or "#2F4A3C"
    if not d:
        raise SystemExit("SVG master path has empty d")
    return d, fill


def parse_points(d: str):
    nums = [float(x) for x in re.findall(r"-?\d+\.?\d*", d)]
    return [(nums[i], nums[i + 1]) for i in range(0, len(nums) - 1, 2)]


def bbox(pts):
    xs = [p[0] for p in pts]
    ys = [p[1] for p in pts]
    return min(xs), min(ys), max(xs), max(ys)


def hex_to_rgb(h: str):
    h = h.lstrip("#")
    return tuple(int(h[i : i + 2], 16) for i in (0, 2, 4))


def draw_background(img: Image.Image) -> None:
    w, h = img.size
    px = img.load()
    for y in range(h):
        ty = y / (h - 1)
        for x in range(w):
            t = min(1.0, max(0.0, 0.85 * ty + 0.15 * (x / (w - 1))))
            r = int(BG_TOP[0] + (BG_BOTTOM[0] - BG_TOP[0]) * t)
            g = int(BG_TOP[1] + (BG_BOTTOM[1] - BG_TOP[1]) * t)
            b = int(BG_TOP[2] + (BG_BOTTOM[2] - BG_TOP[2]) * t)
            px[x, y] = (r, g, b, 255)


def place_mark(size: int, d: str, fill_hex: str) -> Image.Image:
    pts = parse_points(d)
    minx, miny, maxx, maxy = bbox(pts)
    gw, gh = maxx - minx, maxy - miny
    content = size * (1 - 2 * MARGIN_RATIO)
    scale = content / max(gw, gh)  # uniform scale only

    cx_glyph = (minx + maxx) / 2
    cy_glyph = (miny + maxy) / 2
    cx_canvas = size / 2
    cy_canvas = size / 2

    scaled = [
        ((x - cx_glyph) * scale + cx_canvas, (y - cy_glyph) * scale + cy_canvas)
        for x, y in pts
    ]

    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw_background(img)
    ImageDraw.Draw(img).polygon(scaled, fill=(*hex_to_rgb(fill_hex), 255))
    return img.convert("RGB")


def rounded_preview(img: Image.Image, radius_ratio: float = 0.2237) -> Image.Image:
    w, h = img.size
    r = int(w * radius_ratio)
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, w - 1, h - 1), radius=r, fill=255)
    rgba = img.convert("RGBA")
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    out.paste(rgba, mask=mask)
    bg = Image.new("RGB", (w, h), (246, 242, 235))
    bg.paste(out, mask=out.split()[-1])
    return bg


def main() -> int:
    if not SVG_MASTER.is_file():
        raise SystemExit(f"Missing SVG master: {SVG_MASTER}")

    OUT.mkdir(parents=True, exist_ok=True)
    d, fill = load_master()
    digest = hashlib.sha256(d.encode("utf-8")).hexdigest()

    icon1024 = place_mark(1024, d, fill)
    icon1024.save(OUT / "AppIcon-1024.png", format="PNG", optimize=True)

    preview = rounded_preview(place_mark(512, d, fill))
    preview.save(OUT / "AppIcon-Preview.png", format="PNG", optimize=True)

    # Confirm we did not alter the master file
    d2, _ = load_master()
    if d2 != d:
        raise SystemExit("SVG master changed during export — abort")

    print("OK — App Icon exports regenerated")
    print(f"source={SVG_MASTER}")
    print(f"path_sha256={digest}")
    print(f"margin_ratio={MARGIN_RATIO}")
    print(f"fill={fill}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

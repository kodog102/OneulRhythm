#!/usr/bin/env python3
"""Reproduce Release/Logo assets from approved Breath Flow E10 fill.

Source of truth:
  Assets/brand/Work/Sprint-13-2-Breath-E-Optical-Refinement/variants.json
  → variant id == "E10" → property "fill"

Does not redesign or adjust geometry. Presentation color only for mono variants.
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path
from xml.etree import ElementTree as ET

from PIL import Image, ImageDraw
from reportlab.graphics import renderPDF
from svglib.svglib import svg2rlg

ROOT = Path(__file__).resolve().parents[3]
SOURCE_JSON = ROOT / "Assets/brand/Work/Sprint-13-2-Breath-E-Optical-Refinement/variants.json"
LOGO = ROOT / "Assets/brand/Release/Logo"

PRIMARY = "#2F4A3C"
MONO_LIGHT = "#2F4A3C"
MONO_DARK = "#D7E4DB"
VIEWBOX = "0 0 100 100"


def load_e10_fill() -> str:
    variants = json.loads(SOURCE_JSON.read_text(encoding="utf-8"))
    e10 = next(v for v in variants if v["id"] == "E10")
    fill = e10["fill"]
    if not fill.strip().endswith("Z"):
        raise SystemExit("E10 fill must be a closed path")
    return fill


def svg_document(fill: str, fill_color: str) -> str:
    return (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{VIEWBOX}" '
        'width="100" height="100" fill="none" role="img" '
        'aria-label="OneulRhythm Breath Flow">\n'
        f'  <path id="breath-flow-e10" d="{fill}" fill="{fill_color}"/>\n'
        "</svg>\n"
    )


def write_svg(name: str, fill: str, color: str) -> Path:
    path = LOGO / name
    path.write_text(svg_document(fill, color), encoding="utf-8")
    return path


def parse_fill_points(d: str):
    nums = [float(x) for x in re.findall(r"-?\d+\.?\d*", d)]
    return [(nums[i], nums[i + 1]) for i in range(0, len(nums) - 1, 2)]


def export_png(fill: str, color_hex: str, out: Path, size: int = 1024) -> None:
    pts = parse_fill_points(fill)
    scale = size / 100.0
    scaled = [(x * scale, y * scale) for x, y in pts]
    r = int(color_hex[1:3], 16)
    g = int(color_hex[3:5], 16)
    b = int(color_hex[5:7], 16)
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(img).polygon(scaled, fill=(r, g, b, 255))
    img.save(out, format="PNG", optimize=True)


def export_pdf(svg_path: Path, pdf_path: Path) -> None:
    drawing = svg2rlg(str(svg_path))
    if drawing is None:
        raise SystemExit(f"Failed to parse SVG: {svg_path}")
    renderPDF.drawToFile(drawing, str(pdf_path), fmt="PDF")


def validate(fill: str) -> None:
    for name in (
        "oneulrhythm-breath-flow-primary.svg",
        "oneulrhythm-breath-flow-mono-light.svg",
        "oneulrhythm-breath-flow-mono-dark.svg",
    ):
        d = ET.parse(LOGO / name).getroot().find("{http://www.w3.org/2000/svg}path").get("d")
        if d != fill:
            raise SystemExit(f"Geometry mismatch: {name}")


def main() -> int:
    LOGO.mkdir(parents=True, exist_ok=True)
    fill = load_e10_fill()
    primary = write_svg("oneulrhythm-breath-flow-primary.svg", fill, PRIMARY)
    write_svg("oneulrhythm-breath-flow-mono-light.svg", fill, MONO_LIGHT)
    write_svg("oneulrhythm-breath-flow-mono-dark.svg", fill, MONO_DARK)
    export_pdf(primary, LOGO / "oneulrhythm-breath-flow-primary.pdf")
    export_png(fill, PRIMARY, LOGO / "oneulrhythm-breath-flow-primary.png", 1024)
    validate(fill)
    digest = hashlib.sha256(fill.encode("utf-8")).hexdigest()
    print("OK — Breath Flow E10 exports regenerated")
    print(f"fill_sha256={digest}")
    print(f"source={SOURCE_JSON}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

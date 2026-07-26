# Release Logo — Breath Flow

Production logo assets for Brand Lock v1.0.

---

## Brand Lock Reference

| Item | Value |
|------|-------|
| Brand Lock | **v1.0** |
| Status | **Approved** |
| Effective Sprint | Sprint 13 |
| Master Symbol | Breath Flow |
| Locked Production Master | **E10 — Soft Taper Synthesis** |

---

## Geometry Source

**Production master (authority for all raster/icon exports):**

```text
Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg
```

**Historical origin (freeze source for logo regenerate script only):**

```text
Assets/brand/Work/Sprint-13-2-Breath-E-Optical-Refinement/variants.json
→ id: "E10"
→ property: "fill"
```

After the Release SVG exists, do not hand-edit exports. Regenerate via `Assets/brand/Guide/export-logo-from-e10.py`, then re-run App Icon export from the Release SVG.

`fill` SHA-256:

```text
ed64b7938f49ebbdaa01139dfbb2f0a4da929e7c7e2698db81ed6f7808175d64
```

Do not redraw, trace, smooth, or adjust control points. Regenerate from source via the export script.

---

## Export Process

Reproducible pipeline:

```text
Assets/brand/Guide/export-logo-from-e10.py
```

Run from repo root:

```bash
python3 Assets/brand/Guide/export-logo-from-e10.py
```

Pipeline:

1. Load E10 `fill` from `variants.json`  
2. Write SVG masters (primary + mono) with identical `d`  
3. Generate PDF from primary SVG (`svglib` → ReportLab)  
4. Generate PNG from exact fill coordinates (Pillow polygon, 1024×1024)  
5. Validate SVG path strings match source fill  

---

## Coordinate System

| Property | Value |
|----------|-------|
| Units | User SVG units |
| Origin | Top-left |
| +X | Right |
| +Y | Down |
| Glyph space | `0 … 100` on both axes |

---

## ViewBox

```text
viewBox="0 0 100 100"
width="100" height="100"
```

---

## Asset List

| File | Role |
|------|------|
| `oneulrhythm-breath-flow-primary.svg` | **Production master SVG** |
| `oneulrhythm-breath-flow-primary.pdf` | Vector export from SVG master |
| `oneulrhythm-breath-flow-primary.png` | 1024×1024 raster from E10 fill |
| `oneulrhythm-breath-flow-mono-light.svg` | Same geometry · fill `#2F4A3C` |
| `oneulrhythm-breath-flow-mono-dark.svg` | Same geometry · fill `#D7E4DB` |

Primary mark color: `#2F4A3C`

---

## Naming Convention

```text
oneulrhythm-breath-flow-{variant}.{extension}
```

Per `Assets/brand/ASSET-MANIFEST.md`. No Sprint numbers in Release filenames.

---

## Version

| Field | Value |
|-------|-------|
| Brand Lock | v1.0 |
| Asset package | Logo Release (Sprint 14-2) |
| Export date | 2026-07-26 |

---

## Related

- `Assets/brand/ASSET-MANIFEST.md`  
- `Assets/brand/SPRINT-14-PRODUCTION-PLAN.md`  
- `Assets/brand/Guide/export-logo-from-e10.py`

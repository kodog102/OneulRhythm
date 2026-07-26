# Release App Icon — Breath Flow

Production app icon for Brand Lock v1.0.

---

## Brand Lock

| Item | Value |
|------|-------|
| Brand Lock | **v1.0** |
| Status | **Approved** |
| Effective Sprint | Sprint 13 |
| Locked mark | Breath Flow E10 |

---

## Source SVG

```text
Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg
```

Geometry is read from this Release master only.

Do not regenerate from `Work/`.  
Do not edit E10.  
Do not redraw.

Path SHA-256 (must match Logo master):

```text
ed64b7938f49ebbdaa01139dfbb2f0a4da929e7c7e2698db81ed6f7808175d64
```

---

## Background Color

Approved Brand Lock **day** field:

| Stop | Hex |
|------|-----|
| Top / light | `#E9EFE9` |
| Bottom / soft | `#D7E2D8` |

Rendered as a calm soft-sage gradient (presentation only).

Mark fill from SVG master: `#2F4A3C`

---

## Safe-Area Margin

| Property | Value |
|----------|-------|
| Margin | **14%** of canvas edge (each side) |
| Content box | Central **72%** of the square |
| Scale | **Uniform** only (fit glyph bbox into content box) |
| Alignment | Glyph bounding-box center → canvas center |

### Alignment strategy

1. Parse the SVG path vertices (unchanged).  
2. Compute axis-aligned bounding box.  
3. Uniformly scale so the larger bbox side fits the content box.  
4. Translate so bbox center equals canvas center.

### Rationale

14% matches the Brand Lock safe-area concept: terminals stay clear of the iOS continuous-corner crop, while the horizontal breath cycle keeps optical presence without touching the squircle edge. No non-uniform stretch is applied, so E10 silhouette proportions stay identical to the Logo master.

---

## Export Resolution

| File | Size | Notes |
|------|------|-------|
| `AppIcon-1024.png` | **1024×1024** | Production / App Store master (opaque square) |
| `AppIcon-Preview.png` | **512×512** | Rounded preview for human review (not the store master) |

---

## Export Pipeline

```text
Assets/brand/Release/AppIcon/appicon-export.py
```

From repo root:

```bash
python3 Assets/brand/Release/AppIcon/appicon-export.py
```

Pipeline:

1. Load path `d` + fill from Release SVG master  
2. Paint approved day background  
3. Place mark with 14% optical margin (uniform scale + center)  
4. Write `AppIcon-1024.png`  
5. Write rounded `AppIcon-Preview.png`  
6. Confirm SVG master file unchanged  

---

## Asset List

| File | Role |
|------|------|
| `AppIcon-1024.png` | **Production app icon** |
| `AppIcon-Preview.png` | Home-Screen-style preview |
| `appicon-export.py` | Reproducible export |
| `README.md` | This document |

---

## Version

| Field | Value |
|-------|-------|
| Brand Lock | v1.0 |
| Asset package | App Icon Release (Sprint 14-3) |
| Production date | 2026-07-26 |

---

## Related

- `Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg`  
- `Assets/brand/Release/Logo/README.md`  
- `Assets/brand/ASSET-MANIFEST.md`

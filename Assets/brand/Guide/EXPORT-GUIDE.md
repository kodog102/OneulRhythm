# Export Guide

When to use each format, and how production assets are derived.

---

## Brand Lock

| Item | Value |
|------|-------|
| Brand Lock | **v1.0 · Approved** |
| Geometry master | `Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg` |
| Path SHA-256 | `ed64b7938f49ebbdaa01139dfbb2f0a4da929e7c7e2698db81ed6f7808175d64` |

---

## Recommended Workflow

```text
Approved Geometry (Brand Lock v1.0 · E10)
        ↓
Release SVG  (production master)
        ↓
Production Exports  (PDF / PNG / App Icon)
        ↓
Product Assets  (Xcode, in-app, system)
        ↓
Marketing Assets  (web, store, social)
```

**Exported assets should never become editable masters.**

If the mark must change, update Brand Lock → regenerate the Release SVG → re-export every downstream asset.

---

## When to Use Each Format

### SVG

Use for:

- Master geometry  
- Sharp UI / documentation embeds  
- Any size where vectors stay crisp  
- Input to automated export scripts  

Primary file:

```text
Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg
```

### PDF

Use for:

- Print / partner brand kits  
- Vector handoff where SVG tooling is limited  
- Archival vector companion to the SVG master  

Primary file:

```text
Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.pdf
```

Generated **from** the Release SVG. Do not reverse-edit the PDF into a new master.

### PNG

Use for:

- App Icon / raster slots that require bitmap  
- Previews and marketing frames at fixed pixel sizes  
- Places that cannot consume SVG/PDF  

Examples:

```text
Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.png
Assets/brand/Release/AppIcon/AppIcon-1024.png
Assets/brand/Release/AppIcon/AppIcon-Preview.png
```

PNG is a **presentation raster**. It is not an editable geometry source.

---

## Reproducible Pipelines

| Output | Script |
|--------|--------|
| Logo SVG / PDF / PNG / mono | `Assets/brand/Guide/export-logo-from-e10.py` |
| App Icon 1024 + Preview | `Assets/brand/Release/AppIcon/appicon-export.py` |

Logo pipeline note: `export-logo-from-e10.py` freezes geometry from the approved E10 fill into the Release SVG master, then derives PDF/PNG. After the SVG master exists, App Icon export must read **only** that Release SVG (not `Work/`).

App Icon pipeline:

1. Load path + fill from Release SVG  
2. Apply approved day background  
3. Place with 14% safe area (uniform scale + center)  
4. Write rasters  
5. Confirm SVG master unchanged  

---

## Production vs Marketing

| Layer | Rule |
|-------|------|
| Production | Use files under `Assets/brand/Release/` only |
| Marketing | May resize uniformly and apply approved backgrounds; must not edit paths |
| Evaluation comps | Label clearly if not the production asset |

---

## Mono Variants

`mono-light` and `mono-dark` SVGs share **identical** path `d` with primary.

Only the fill color differs (presentation).

Do not create ad-hoc recolors outside approved variants without Brand Lock / design approval.

---

## Incorrect Export Practice

Do not:

- Open a PNG and redraw vectors “cleanly”  
- Expand PDF and save as a new master SVG with altered points  
- Optimize SVG with tools that rewrite or simplify the path  
- Export from Figma/Sketch recreations  
- Keep hand-tuned copies beside Release (“final-final.svg”)  

Geometry fidelity always beats file-size optimization.

---

## Related

- `BRAND-USAGE.md`  
- `CONSTRUCTION-GRID.md`  
- `SAFE-AREA.md`  
- `Assets/brand/ASSET-MANIFEST.md`  
- `Assets/brand/Release/Logo/README.md`  
- `Assets/brand/Release/AppIcon/README.md`

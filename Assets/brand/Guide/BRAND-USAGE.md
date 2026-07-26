# Brand Usage Guide

Operational rules for applying OneulRhythm Brand Assets.

---

## Brand Lock

| Item | Value |
|------|-------|
| Brand Lock | **v1.0** |
| Status | **Approved** |
| Effective Sprint | Sprint 13 |
| Master Symbol | Breath Flow |
| Locked Production Master | **Breath Flow E10 — Soft Taper Synthesis** |

Authority:

- Philosophy → `Docs/BRAND.md`
- Architecture → ADR-010 / ADR-011 / ADR-012
- Asset storage / naming → `Assets/brand/ASSET-MANIFEST.md`

---

## Brand Philosophy

> One rhythm at a time.

The mark expresses presence, rhythm, flow, continuity, and calm.

It is a philosophical symbol before it is a decorative asset.

Prefer:

- Simplicity over decoration  
- Clarity over density  
- Rhythm over structure  
- Presence over productivity  

Avoid checklist, loop, smile, mountain, sunrise, and productivity metaphors.

---

## Approved Master Asset

**Production geometry master:**

```text
Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg
```

Related Release Logo exports:

- `oneulrhythm-breath-flow-primary.pdf`
- `oneulrhythm-breath-flow-primary.png`
- `oneulrhythm-breath-flow-mono-light.svg`
- `oneulrhythm-breath-flow-mono-dark.svg`

Geometry fingerprint (path `d` SHA-256):

```text
ed64b7938f49ebbdaa01139dfbb2f0a4da929e7c7e2698db81ed6f7808175d64
```

---

## Approved Icon

**Production app icon:**

```text
Assets/brand/Release/AppIcon/AppIcon-1024.png
```

Preview (review only, not store master):

```text
Assets/brand/Release/AppIcon/AppIcon-Preview.png
```

Derived from the Release SVG master with presentation rules only (margin, background, resolution). See `SAFE-AREA.md` and `../Release/AppIcon/README.md`.

---

## Single Source of Truth

| Concern | Authority |
|---------|-----------|
| Meaning | `Docs/BRAND.md` + ADR-010 |
| Locked geometry | Breath Flow E10 · Brand Lock v1.0 Approved |
| Editable production master | `Release/Logo/oneulrhythm-breath-flow-primary.svg` |
| Production files | `Assets/brand/Release/` |
| How to use / export | `Assets/brand/Guide/` |
| History | `Assets/brand/Work/` |

**Only Release assets are production assets.**

**Work assets are historical references only.** They must not be shipped, linked from the app, or treated as editable masters.

If Release and Work disagree, Release + Brand Lock win.

---

## Brand Hierarchy

```text
Brand Philosophy (BRAND.md / ADRs)
        ↓
Brand Lock v1.0 — Breath Flow E10
        ↓
Release SVG master
        ↓
Release exports (PDF / PNG / App Icon)
        ↓
Product & marketing surfaces
```

Do not invent parallel marks, lockups, or “improved” geometry below this hierarchy.

---

## Asset Locations

```text
Assets/brand/
  ASSET-MANIFEST.md
  Guide/                 ← this documentation
  Release/
    Logo/                ← production logo set
    AppIcon/             ← production app icon
    Preview/             ← optional marketing previews
  Work/                  ← historical only (not production)
```

---

## Naming Convention

Lowercase kebab-case for Release logo files:

```text
oneulrhythm-breath-flow-{variant}.{extension}
```

App Icon production filenames (current Release):

```text
AppIcon-1024.png
AppIcon-Preview.png
```

Rules:

- No Sprint numbers in `Release/` filenames  
- Sprint numbers allowed only under `Work/`  
- Do not invent `-final`, `-v2`, or duplicate masters  

Full policy: `Assets/brand/ASSET-MANIFEST.md`.

---

## Versioning Policy

| Layer | Rule |
|-------|------|
| Brand Lock | `vMAJOR.MINOR` — current **v1.0 · Approved** |
| Release package | Align major with Brand Lock when geometry changes |
| Individual files | Replace in place for export-quality fixes that do not change meaning |

Geometry change requires a new Brand Lock decision before Release replacement.

---

## Incorrect Usage

Do not:

- Stretch or skew the mark  
- Scale X and Y independently  
- Edit paths, tapers, or control points  
- Rotate the logo  
- Add shadows, glows, outlines, or filters that change the silhouette  
- Recolor without an approved variant / Brand Lock update  
- Rebuild from screenshots or App Store captures  
- Trace manually in Illustrator / Figma / etc.  
- Close the path into a loop or infinity mark  
- Use `Work/` exploration boards as production artwork  
- Treat PDF / PNG exports as editable masters  

Correct workflow: see `EXPORT-GUIDE.md`.

---

## Related Guides

- `CONSTRUCTION-GRID.md` — fixed geometry & coordinates  
- `SAFE-AREA.md` — logo & icon clear space  
- `EXPORT-GUIDE.md` — format choice & pipeline  
- `Assets/brand/ASSET-MANIFEST.md` — storage & naming authority

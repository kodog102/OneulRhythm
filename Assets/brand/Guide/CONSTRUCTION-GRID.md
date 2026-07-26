# Construction Grid

Construction principles for the locked Breath Flow mark.

Geometry is **fixed**. Reconstruction is **not allowed**.

---

## Brand Lock

| Item | Value |
|------|-------|
| Brand Lock | **v1.0 · Approved** |
| Effective Sprint | Sprint 13 |
| Locked mark | Breath Flow E10 |

---

## Geometry Authority

| Role | Path |
|------|------|
| Production master | `Assets/brand/Release/Logo/oneulrhythm-breath-flow-primary.svg` |
| Path fingerprint | SHA-256 of SVG path `d` |

```text
ed64b7938f49ebbdaa01139dfbb2f0a4da929e7c7e2698db81ed6f7808175d64
```

Any production asset whose path `d` does not match this fingerprint is incorrect—even if it looks similar.

Do not rebuild from:

- `Work/` exploration boards  
- Screenshots  
- Manual tracing  
- Memory  

---

## Source Geometry

The Release SVG contains a single closed path:

- Element: `<path id="breath-flow-e10">`  
- Data: soft-taper fill polygon (M / L / Z)  
- Fill (primary): `#2F4A3C`  

The historical centerline used during optical study is **not** the Release path. Release geometry is the approved **fill**.

---

## Coordinate System

| Property | Value |
|----------|-------|
| Origin | Top-left of the viewBox |
| +X | Right |
| +Y | Down |
| Units | SVG user units |
| Glyph space | `0 … 100` on both axes |

---

## ViewBox

```text
viewBox="0 0 100 100"
width="100" height="100"
```

Keep this viewBox stable for the master SVG. Presentation canvases (app icon, marketing frames) place this glyph into a larger square using uniform scale and translation only.

---

## Bounding Box

Approximate axis-aligned bounds of the E10 fill in glyph space:

| Edge | ≈ Value |
|------|---------|
| min X | 19.0 |
| min Y | 35.5 |
| max X | 81.0 |
| max Y | 66.5 |
| Width | 62.0 |
| Height | 31.0 |

Use the live SVG path for precise computation. Do not invent a new “construction outline” that replaces the path.

---

## Alignment Reference

| Context | Rule |
|---------|------|
| Logo on clear field | Place using uniform scale; preserve aspect ratio |
| App Icon | BBox center → canvas center inside the 14% safe area (see `SAFE-AREA.md`) |
| Optical judgment | Prefer calm horizontal reading; do not nudge by editing path points |

Alignment is a **placement** rule. It is not permission to alter geometry.

---

## Scaling Principles

Allowed:

- Uniform scale (same factor on X and Y)  
- Translation  
- Changing canvas / background around the mark  

Not allowed:

- Non-uniform scale  
- Stretch, skew, rotate  
- Path simplification or point reduction  
- Re-fitting control points “to look better”  

When fitting into a frame, scale so the **larger** side of the glyph bbox meets the content box, then center. Extra margin on the shorter axis is expected for this wide mark.

---

## Construction Grid (Conceptual)

```text
viewBox 0 ──────────── 100
        │              │
        │   clear      │
        │   ┌──────┐   │
        │   │ mark │   │   ← E10 fill (fixed)
        │   └──────┘   │
        │   clear      │
        └──────────────┘
```

For App Icon, clear margins are quantified in `SAFE-AREA.md` (14%).

There is no alternate construction grid that redefines the stroke. The path **is** the construction.

---

## Related

- `BRAND-USAGE.md`  
- `SAFE-AREA.md`  
- `EXPORT-GUIDE.md`  
- `Assets/brand/Release/Logo/README.md`

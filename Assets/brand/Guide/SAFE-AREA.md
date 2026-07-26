# Safe Area

Clear-space rules for Logo and App Icon.

Safe area protects **readability** and crop safety.

It does **not** redefine geometry.

---

## Brand Lock

| Item | Value |
|------|-------|
| Brand Lock | **v1.0 · Approved** |
| Locked mark | Breath Flow E10 |
| Geometry master | `Release/Logo/oneulrhythm-breath-flow-primary.svg` |

---

## Logo Safe Area

### Minimum surrounding clear space

Keep clear space around the mark of at least **one-eighth of the mark’s width** on all sides when placing the logo on UI, documentation, or marketing layouts.

Practical rule:

```text
clear_space ≥ 0.125 × logo_width
```

Do not place:

- Typography  
- Badges  
- Other icons  
- Busy photography focal points  

inside this clear space.

### Centering rules

- Prefer optical calm: horizontal reading, balanced air left/right.  
- Do not rotate.  
- Do not crop terminals.

### Scaling behavior

- Uniform scale only.  
- Maintain aspect ratio from the SVG master.  
- Prefer vector (SVG/PDF) for large or sharp presentation.

---

## App Icon Safe Area

Production rule used by `Release/AppIcon/appicon-export.py`:

| Property | Value |
|----------|-------|
| Margin | **14%** of canvas edge on each side |
| Content box | Central **72%** of the square |
| Scale | Uniform — fit glyph bbox into content box |
| Alignment | Glyph bbox center → canvas center |

```text
┌──────────────────────────┐
│         14%              │
│   ┌──────────────────┐   │
│   │                  │   │
│14%│   Breath Flow    │14%│
│   │                  │   │
│   └──────────────────┘   │
│         14%              │
└──────────────────────────┘
```

### Centering rules

1. Read path vertices from the Release SVG (unchanged).  
2. Compute axis-aligned bounding box.  
3. Uniformly scale so `max(bbox_width, bbox_height)` equals the content box size.  
4. Translate so bbox center equals canvas center.

### Scaling behavior

- Allowed: one uniform scale factor + translation.  
- Not allowed: independent X/Y scale, stretch, or path edits to “fill the square.”  
- Extra vertical air is expected — the mark is wider than it is tall.

---

## Rationale

| Goal | How 14% / clear space helps |
|------|------------------------------|
| iOS continuous-corner crop | Keeps terminals away from masked corners |
| Small-size readability | Prevents the cycle from touching the edge at 60pt / 29pt contexts |
| Brand calm | Breathing space is part of the product language |
| Geometry integrity | Margin is presentation-only; silhouette stays E10 |

Safe area is a **frame** around the locked mark. Changing margin for a special layout never authorizes changing the path.

---

## Incorrect Safe-Area Practice

Do not:

- Reduce margin until terminals touch the squircle edge  
- Enlarge the mark by non-uniform scaling to “use the space”  
- Crop the SVG viewBox to fake padding  
- Move individual path points for optical tweaks  

---

## Related

- `CONSTRUCTION-GRID.md`  
- `BRAND-USAGE.md`  
- `Assets/brand/Release/AppIcon/README.md`

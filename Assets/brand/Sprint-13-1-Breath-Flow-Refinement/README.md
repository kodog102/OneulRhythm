# Sprint 13-1 — Breath Flow Refinement Exploration

**Status:** Exploration deliverable (refinement phase)  
**Primary direction:** Concept 02 — Breath Flow (ADR-010)  
**Board:** [`board.html`](./board.html)

---

## Scope

This Sprint refines the approved Breath Flow concept into production-candidate mark geometry.

- Do **not** explore new concepts
- Do **not** revisit prior icon directions
- Do **not** introduce new metaphors

---

## Phase 1 — Refinement Axes

| # | Axis | Spectrum | Intent |
|---|------|----------|--------|
| 1 | **Curvature** | Organic ↔ Geometric | Living Bézier ease vs arc discipline |
| 2 | **Horizontal Balance** | Stable ↔ Dynamic | Quiet symmetry vs forward lean |
| 3 | **Amplitude** | Subtle ↔ Expressive | Vertical depth of the single inhale |
| 4 | **Stroke Ending** | Uniform → Rounded → Soft taper → Optical taper | How the breath begins and settles |
| 5 | **Optical Weight** | Light ↔ Bold | Mass that holds from 1024pt to 29pt |

Every variant moves along these axes only. Family DNA stays fixed: one open stroke, one full breath cycle (inhale → exhale), horizontal reading, soft geometry, no secondary marks. Not a hill. Not a smile. Not a closed loop.

---

## Phase 2 — Variants (15)

| ID | Name | Primary axis move |
|----|------|-------------------|
| A | Baseline | Reference balance |
| B | Flatter | Amplitude ↓ |
| C | Soft Organic | Curvature → organic |
| D | Reduced Amplitude | Amplitude ↓↓ |
| E | Soft Taper | Stroke ending → soft taper |
| F | Geometric | Curvature → geometric |
| G | Dynamic Flow | Balance → dynamic |
| H | Bold | Weight → bold |
| I | Light | Weight → light |
| J | Optical Taper | Stroke ending → optical taper |
| K | Expressive | Amplitude ↑ |
| L | Stable Peak | Balance → stable |
| M | Compressed | Span ↓ |
| N | Expanded | Span ↑ |
| O | Soft Geometric | Curvature hybrid |

---

## Phase 3 — Evaluation Criteria

Scored 1–5 on:

1. Brand philosophy alignment  
2. Calmness  
3. Recognition  
4. Small-size readability  
5. Long-term timelessness  

Full scores live on the presentation board.

---

## Phase 4 — Architect Recommendation

### TOP 5

**A · C · E · J · L**

Removed marks that felt chart-like (K), smile-adjacent (K), too light at 29pt (I, D), too cool/geometric (F), or too motion-like (G).

### TOP 3

**C · E · J**

Kept the three that remain calm under reduction and still read as one continuous breath—not a decorative wave.

### TOP 1

**Breath E — Soft Taper**

Soft taper on a full breath cycle—presence without hardness. Quieter than J, clearer than C at small size, more timeless than the baseline.

---

## Risks

1. **Abstraction** — May not read as a conventional task app. Accepted under ADR-010.  
2. **Wave cliché** — Over-amplitude or closed forms slip into wellness-generic. Keep open, single-cycle, restrained.  
3. **Scale** — Taper detail can vanish below ~29pt if overdone. Lock minimum end width before final export.

---

## Next Step

Product Owner review of Breath E (with C / J as alternates).  
If approved → Sprint 13 App Icon production lock (color, margins, export set).

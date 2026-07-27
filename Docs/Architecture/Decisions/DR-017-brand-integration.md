# DR-017 — Brand Integration Architecture

**Status:** Accepted  
**Decision Date:** Sprint 15-3B — Brand Integration Architecture Specification  
**Applies From:** Cross-surface Brand Expression / Product Language / Completion & Progress Roles

---

## Context

Sprint 14 established the Brand System (Breath Flow, cream/sage language, quiet motion).

Sprint 15-1 and 15-2 established Welcome and Launch as Identity Surfaces.

Sprint 15-3A reviewed brand integration across the product and found:

- Strong continuity on Launch → Welcome → Today field and motion
- Intentional Breath Flow absence on utility surfaces (correct)
- Residual productivity vocabulary (`완료`, `관리`, score-like `N / M`)
- Live Activity emoji stand-in instead of Breath Flow
- Progress that can compete with Day Complete closure
- Legacy orphan card / snooze patterns outside approved Today architecture

The product needed architectural rules for where brand appears, where it disappears, and how language and completion stay presence-first — without redesigning screens in place.

---

## Decision

Brand is expressed through a **presence hierarchy** and a **shared product voice**.

### Core rules

1. **Identity Surfaces** (App Icon, Launch, Welcome) — Breath Flow is primary (identity / presence / meaning).  
2. **Experience Surfaces** (Today family) — user’s rhythm is hero; Breath Flow does not compete as Hero.  
3. **Utility Surfaces** (My Rhythms, Create/Edit, Settings) — mark steps back; tokens may persist.  
4. **Completion = acknowledgment**, not scoring.  
5. **Progress = orientation**, not identity; must step back on Day Complete / Welcome / Launch.  
6. **Cross-surface identity** uses Breath Flow when a mark is required — not emoji substitutes.  
7. **Legacy checklist / snooze / orphan card patterns** are non-authoritative for new work.

### Authority document

Implementation and future UI work must follow:

`Docs/Product/Brand-Integration-Architecture.md`

Surface UI specs remain authoritative for layout and copy contracts within their scope, and must not contradict this hierarchy.

---

## Consequences

### Positive

- Clear rules for Breath Flow placement and absence
- Shared vocabulary direction across Today and platform surfaces
- Protects ADR-011 against score/checklist identity drift
- Separates Identity / Experience / Utility responsibilities

### Accepted trade-offs

- Some utility language remains plain (`저장`, interim `관리`) rather than poetic
- Acknowledgment-wording migration may be gradual where UI contracts still list interim labels
- Platform mark replacement (Live Activity) is architectural direction, not an instant UI redesign here

These trade-offs are accepted to preserve calm Experience surfaces without over-branding Utility.

---

## Alternatives Considered

### Repeat Breath Flow on every empty or utility screen

Rejected.

Turns brand into decoration and competes with user content.

### Keep surface-specific closure / completion dialects

Rejected.

Fractures one emotional voice (Today vs Live Activity).

### Treat progress counts as primary Today identity

Rejected.

Violates ADR-011 and Completion Philosophy.

---

## Related Decisions

- DR-008 — Single Focus Experience
- DR-009 — Single Primary Rhythm
- DR-015 — First Rhythm Onboarding Lifecycle
- DR-016 — Launch Experience Architecture
- ADR-010 — Primary Brand Symbol: Breath Flow
- ADR-011 — No Checklist Metaphor
- ADR-012 — Calm Before Productivity

---

## Related Documents

- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/BRAND.md`
- `Docs/Product/Welcome-Experience.md`
- `Docs/Product/Launch-Architecture-Specification.md`
- `Docs/Product/Today-UI-Specification.md`

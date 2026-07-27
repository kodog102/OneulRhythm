# DR-021 — Visual Identity and Warm Light Appearance Policy

**Status:** Accepted  
**Decision Date:** Sprint 16-2 — Visual Identity Decision Record  
**Applies From:** Product Appearance Ownership / Visual Identity Authority / Sprint 16 Visual Identity Integration Scope

---

## Context

Sprint 15 completed the core Product Experience:

- Welcome / First Journey  
- Launch  
- Today  
- My Rhythms  
- Create Rhythm  
- Settings  

Sprint 16 is named **Visual Identity Integration**.

Sprint 16-1 Experience Review confirmed:

- OneulRhythm already has a coherent Warm Cream + Sage identity on Welcome and Today  
- The primary gap is incomplete appearance ownership and uneven translation into system / utility chrome  
- System Dark Mode can currently produce mixed light and dark presentation  
- Live Activity visually forks from the app Design System  
- The current Hero expresses intended emotional atmosphere but is not a literal UI specification  

DR-017 already defines brand presence hierarchy and product voice. DR-020 states that Settings must not duplicate OS Appearance controls. The product still needed an explicit **Warm Light appearance policy**, **visual identity authority hierarchy**, and **Sprint 16 change boundary** before implementation.

---

## Decision

OneulRhythm integrates visual identity under a single supported product appearance and a clear authority hierarchy.

### 1. Supported Appearance

OneulRhythm officially supports a single product appearance:

**Warm Light Appearance.**

The app must preserve this intended appearance even when the device is configured for Dark Mode.

Dark Mode-specific palettes, layouts, screenshots, and QA are outside the current product scope.

Mixed system-driven light/dark presentation is considered a **product defect**.

### 2. Appearance Ownership

Appearance policy belongs to the **application shell** and **platform presentation boundaries**.

Feature views should consume semantic Design System tokens and should **not** independently determine the product color scheme.

The Widget Extension and Live Activity must align with the same brand palette where the platform permits it.

Platform-owned Dynamic Island chrome remains platform-owned and does not need to imitate the app’s cream surfaces.

**Relationship to DR-020:**  
This decision does **not** create an in-app Appearance preference section. OS Appearance settings remain OS-owned. The product locks Warm Light at the shell so Dark Mode does not produce mixed presentation. Preferring OS Appearance when “sufficient” (Settings Architecture) is superseded for product rendering by this Warm Light policy; Settings still must not expose a Light / Dark / Automatic product control.

### 3. Visual Identity Authority

Authority hierarchy:

1. **Product Principles** define the intended experience.  
2. **Brand documentation** and the **Design System** define the product visual language.  
3. **Decision Records** define approved behavioral and architectural constraints.  
4. **The Hero image** expresses emotional and marketing atmosphere.

The Hero is **not** a literal UI contract.

Do not copy marketing-only controls, layouts, decorative progress rings, tab structures, or unsupported platform claims into the product.

### 4. Brand Translation

Approved product-level visual characteristics:

- Warm cream atmospheric surfaces  
- Restrained sage accent  
- Soft continuous geometry  
- Quiet visual depth  
- Generous breathing space  
- One primary focus  
- Breath Flow as the primary brand mark when a mark is appropriate  
- Calm acknowledgment rather than productivity scoring  

Primarily marketing expressions (not product UI requirements):

- Still-life scenery  
- Leaf shadows and physical props  
- Decorative device compositions  
- Technology badges  
- Fictional or outdated UI controls  
- Unsupported platform representations  

### 5. Sprint 16 Scope

Sprint 16 **may** change:

- Application appearance enforcement  
- Semantic presentation tokens  
- Reusable visual components  
- Settings and List surface styling  
- Live Activity presentation views  
- Screenshot and repository marketing assets  

Sprint 16 **must not** change:

- Domain model  
- SwiftData schema  
- Schedule Engine  
- `TodayRhythmSnapshot` semantics  
- Management composition rules  
- First Journey lifecycle  
- Settings behavior or information architecture  
- Live Activity lifecycle  
- Navigation architecture  
- Product feature scope  

### 6. Product Quality Principle

Every user-visible state should feel intentionally finished.

This does not mean every screen receives decorative branding.

- **Identity surfaces** may carry stronger brand presence.  
- **Utility surfaces** should remain quieter while still using the same appearance, spacing, typography, and surface language.  

Screenshot readiness is a quality signal, not permission to distort product behavior for marketing.

### Authority documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`  
- `Docs/BRAND.md`  
- `Docs/Product/Brand-Integration-Architecture.md` (DR-017)  
- Design System implementation under `OneulRhythm/DesignSystem/`  

Surface UI specifications remain authoritative for layout and copy within their scope, and must not contradict this appearance policy.

---

## Consequences

### Positive

- Consistent Warm Light appearance across OS Appearance settings  
- Clearer brand continuity from Launch / Welcome / Today into utility and platform surfaces  
- Simpler current QA scope (one supported appearance)  
- Reduced visual drift between app tokens and Live Activity presentation  
- Honest screenshot production based on the shipped product, not marketing fiction  

### Accepted trade-offs

- No native Dark Mode experience in the current product  
- Some platform controls may require explicit light styling to avoid mixed presentation  
- Dynamic Island cannot fully reproduce app cream surfaces and should not be forced to  
- Future Dark Mode support would require a **new product decision** and Design System token expansion  

These trade-offs are accepted to protect calm Warm Light identity without expanding Sprint 16 into adaptive theming or feature work.

---

## Alternatives Considered

### A. Full adaptive Light and Dark support now

Rejected.

Doubles design and QA scope. Dark Mode is not a current product priority.

### B. Follow system appearance without a dedicated dark palette

Rejected.

Causes mixed and unintended presentation — the confirmed product defect Sprint 16 exists to prevent.

### C. Rebuild the app literally from the current Hero mockup

Rejected.

The Hero contains marketing composition and non-authoritative UI details. It is atmosphere, not a UI contract.

### D. Keep current implementation and only update screenshots

Rejected.

Appearance ownership and Live Activity inconsistency would remain unresolved. Screenshots would document a fractured identity.

---

## Related Decisions

- DR-006 — Live Activity Architecture  
- DR-014 — Product UI First Strategy  
- DR-015 — First Rhythm Onboarding Lifecycle  
- DR-016 — Launch Experience Architecture  
- DR-017 — Brand Integration Architecture  
- DR-018 — My Rhythms Architecture  
- DR-019 — Create Rhythm Architecture  
- DR-020 — Settings Architecture  
- ADR-010 — Primary Brand Symbol: Breath Flow  
- ADR-011 — No Checklist Metaphor  
- ADR-012 — Calm Before Productivity  

---

## Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`  
- `Docs/BRAND.md`  
- `Docs/Product/Brand-Integration-Architecture.md`  
- `Docs/Product/Settings-Architecture.md`  
- `Docs/Product/Launch-Architecture-Specification.md`  
- `Docs/Product/Welcome-Experience.md`  
- `Docs/Product/Today-UI-Specification.md`  
- `Docs/Design/LiveActivity.md`  
- `Docs/Design/Visual-Language-Specification.md`  
- `Assets/brand/Guide/BRAND-USAGE.md`  
- `Assets/hero/hero.png` (marketing atmosphere only)  

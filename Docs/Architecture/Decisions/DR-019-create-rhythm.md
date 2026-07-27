# DR-019 — Create Rhythm Architecture

**Status:** Accepted  
**Decision Date:** Sprint 15-5B — Create Rhythm Architecture  
**Applies From:** Create / Edit Rhythm Capture Hierarchy / Progressive Disclosure / Save Philosophy

---

## Context

Sprint 15-5A reviewed Create Rhythm and found:

- Correct utility classification (no Breath Flow, plain save, no celebration)
- Emotional mismatch: form feels like configuring a task/schedule object
- High cognitive load from always-visible category and recurrence
- Flat hierarchy of equal cards
- Create and Edit correctly share one screen — but first create needs Capture emphasis without forking Edit

DR-017 and DR-018 require Create to stay a subordinate utility form. The product still needed architecture for **Capture vs Configure** so UI Spec can reduce load without onboarding wizards or dual architectures.

---

## Decision

Create Rhythm is a **utility capture form** with **Capture-first** information hierarchy.

### Core rules

1. **Purpose** — Begin or refine one personal rhythm; not administer a task system.  
2. **Capture** — Identity (name) + primary time placement.  
3. **Configure** — Category, recurrence, reminder, end-time detail, and similar refinements — available but secondary.  
4. **Hierarchy** — Primary identity → Secondary time → Advanced Configure.  
5. **Progressive disclosure** — Configure may defer; Create remains one continuous surface — no multi-step wizard.  
6. **Create/Edit** — One architecture; create emphasizes beginning; edit emphasizes refinement.  
7. **Save** — Persistence + quiet return as acknowledgement of beginning/refinement; never celebration.  
8. **Brand** — No Breath Flow hero; no Welcome philosophy on the form.

### Authority document

- `Docs/Product/Create-Rhythm-Architecture.md`
- `Docs/Product/Create-Rhythm-UI-Specification.md`

---

## Consequences

### Positive

- Clear path to soften first-create cognitive load without a second product  
- Preserves shared Create/Edit model  
- Protects Welcome/Today from setup theater  
- Aligns utility language with ownership-first Capture  

### Accepted trade-offs

- Advanced fields remain in the same surface (disclosed), not a separate “power editor” app  
- Shipping UI may remain flatter until Create UI Spec / implementation sync  

---

## Alternatives Considered

### Multi-step create wizard

Rejected.

Conflicts with Welcome’s anti-wizard stance and Presence over Explanation.

### Separate Create vs Edit architectures

Rejected.

Duplicates product surface and violates DR-018 compatibility intent.

### Keep all Configure fields equal to Capture forever

Rejected.

Locks the task-configuration feeling identified in Sprint 15-5A.

---

## Related Decisions

- DR-015 — First Rhythm Onboarding Lifecycle  
- DR-017 — Brand Integration Architecture  
- DR-018 — My Rhythms Architecture  
- DR-020 — Settings Architecture  

---

## Related Documents

- `Docs/Product/Create-Rhythm-Architecture.md`
- `Docs/Product/Create-Rhythm-UI-Specification.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/Settings-Architecture.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`

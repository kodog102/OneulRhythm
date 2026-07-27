# DR-018 — My Rhythms Architecture

**Status:** Accepted  
**Decision Date:** Sprint 15-4B — My Rhythms Architecture Specification  
**Applies From:** My Rhythms / Collection Entry / Empty-State Philosophy / Utility Ownership Boundaries

---

## Context

Sprint 15-4A reviewed My Rhythms (Management) against Product Principles and Brand Integration.

Findings:

- The screen already behaves largely as a quiet personal collection
- Utility mark absence and list restraint are correct
- Entry label `관리` frames administration before ownership
- Empty copy that names the `+` control reads as CRUD instruction
- My Rhythms must not become a second Welcome or a productivity dashboard

`Management-UI-Specification.md` defines presentation behavior. The product still needed an architectural statement of **purpose, entry philosophy, empty-state role, and ownership**.

---

## Decision

My Rhythms is the user’s **quiet personal rhythm collection**.

### Core rules

1. **Purpose** — Personal Rhythm Collection + quiet maintenance — not task management, dashboard, or analytics.  
2. **Entry** — Collection access with ownership-aligned labeling as architectural direction; visible `관리` is legacy interim only; entry stays hidden on Welcome.  
3. **Hierarchy** — Rhythm titles primary; schedule secondary; chrome tertiary; no metrics/completion/progress as identity.  
4. **Empty** — Quiet ownership gap; not Welcome; canonical guidance avoids control instructions and philosophy repetition.  
5. **Utility** — Plain add/edit/delete/save language is acceptable; brand performance and celebration are forbidden.  
6. **Ownership** — Name-first rows; maintenance in the margins.  
7. **Future** — Create (15-5) and Settings (15-6) remain compatible without changing this role.

### Authority document

- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/My-Rhythms-UI-Specification.md` (entry, empty, delete failure, row chrome)

When these documents and `Management-UI-Specification.md` diverge on purpose, entry, empty-state copy, or delete-failure wording, **My Rhythms Architecture + UI Spec win**.

---

## Consequences

### Positive

- Clear emotional role distinct from Today and Welcome  
- Entry and empty-state direction aligned with ownership, not admin/CRUD tutoring  
- Protects Today’s single focus by keeping collection secondary  
- Compatible with later Create and Settings work  

### Accepted trade-offs

- Shipping UI may temporarily retain `관리` and control-instruction empty copy until UI Spec / implementation sync  
- Utility delete/edit language stays plain rather than poetic  

These trade-offs are accepted to avoid blocking architecture on immediate copy migration.

---

## Alternatives Considered

### Keep `관리` as permanent product vocabulary

Rejected.

Conflicts with Less Input / Presence and Brand Integration’s interim-only stance once ownership direction exists.

### Make My Rhythms empty a Welcome reprise

Rejected.

Violates DR-015 and turns utility into repeated introduction.

### Treat My Rhythms as the primary daily surface

Rejected.

Violates DR-008 / DR-009 single-focus Today experience.

---

## Related Decisions

- DR-008 — Single Focus Experience  
- DR-009 — Single Primary Rhythm  
- DR-015 — First Rhythm Onboarding Lifecycle  
- DR-017 — Brand Integration Architecture  

---

## Related Documents

- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/My-Rhythms-UI-Specification.md`
- `Docs/Product/Management-UI-Specification.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/Settings-Architecture.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`

# DR-020 — Settings Architecture

**Status:** Accepted  
**Decision Date:** Sprint 15-6B — Settings Architecture Decision  
**Applies From:** Settings / Support Utility Ownership / App vs OS Boundaries / Entry & Exit / Future Preference Admission

---

## Context

Sprint 15 completed Welcome, Launch, Brand Integration, My Rhythms, and Create Rhythm.

Sprint 15-6A defined Settings as OneulRhythm’s **quiet support utility** — outside the primary rhythm journey — with principles:

- Keep Me Out  
- Utilities Only  
- Quiet Exit  
- Reduce Configuration  
- Separate from the Collection  
- Plain Voice  

DR-017 already classifies Settings as a Utility Surface. DR-018 requires Settings to stay out of My Rhythms. DR-019 keeps system preferences out of Create’s Capture center (deep links OK for permission recovery).

The product still needed an architectural statement of **ownership, App vs OS responsibility, entry/exit, and Earn Sections** before UI Spec.

---

## Decision

Settings is the user’s **quiet support utility**.

### Core rules

1. **Purpose** — Own product-side support preferences, trust/legal, support pathways, and utility app identity — not rhythms or meaning.  
2. **Class** — Utility Surface (DR-017); outside the primary rhythm journey.  
3. **Boundaries** — Separate from Today, Welcome, My Rhythms, and Create ownership.  
4. **OS Owns the OS** — Do not duplicate OS permission, presentation, language, Appearance, or Focus controls; explain and deep-link.  
5. **Entry / Exit** — Secondary entry; Quiet Exit; never forced journey interrupt; never a destination.  
6. **MVP IA groups** — Notifications · Support · About (product groups only).  
7. **Earn Sections** — Admit future prefs only when real, non-OS, and principle-aligned; no empty future sections.  
8. **Brand** — No Breath Flow hero; no Welcome philosophy; plain utility voice.

### Authority document

- `Docs/Product/Settings-Architecture.md`
- `Docs/Product/Settings-UI-Specification.md`

---

## Consequences

### Positive

- Clear final Sprint 15 utility boundary  
- Protects Today / Welcome / My Rhythms / Create from preference dumping  
- Prevents OS Settings cloning and configuration culture  
- Scales to Widget / Watch / Sync without pre-built empty IA  

### Accepted trade-offs

- Fewer in-app toggles than a typical productivity settings screen  
- Some recovery flows require leaving the app for OS Settings  
- Implementation follows Sprint 15-6D against the approved UI Specification  

These trade-offs are accepted to preserve Less Input / Calm over Complexity.

---

## Alternatives Considered

### Absorb Settings into My Rhythms

Rejected.

Violates DR-018; turns the collection into a preferences hub.

### Mirror iOS Settings comprehensively in-app

Rejected.

Violates OS Owns the OS; increases configuration anxiety.

### Make Settings a primary tab / daily destination

Rejected.

Competes with Today’s single focus and Keep Me Out.

### Pre-create Widget / Watch / Sync / Appearance sections empty

Rejected.

Violates Earn Sections and invites clutter before demand.

---

## Related Decisions

- DR-014 — Product UI First Strategy  
- DR-015 — First Rhythm Onboarding Lifecycle  
- DR-017 — Brand Integration Architecture  
- DR-018 — My Rhythms Architecture  
- DR-019 — Create Rhythm Architecture  

---

## Related Documents

- `Docs/Product/Settings-Architecture.md`
- `Docs/Product/Settings-UI-Specification.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/Create-Rhythm-Architecture.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`

# DR-016 — Launch Experience Architecture

**Status:** Accepted  
**Decision Date:** Sprint 15-2B — Launch Architecture Specification  
**Applies From:** App Startup / Launch Screen Configuration

---

## Context

Sprint 15-1 completed the Welcome Experience.

Sprint 15-2A reviewed the full path from App Icon through System Launch Screen and initialization into Welcome or Today.

The review found that runtime launch was mostly unbranded and discontinuous:

- App Icon Release masters existed but were not installed in the app catalog
- Launch Screen used auto-generation only (blank / system)
- Today / Welcome used the cream product field with Breath Flow meaning on Welcome
- No artificial splash delay existed (a strength), but continuity into the product was weak

Welcome already owns product introduction. Launch must not become a second introduction or a branding theater.

This decision records Launch architecture. It does not redesign Welcome, DR-015, Schedule Engine ownership, or platform surfaces beyond startup continuity.

---

## Decision

Launch is a **continuity bridge**: Presence Before Interaction.

### Core rules

1. **Launch = Presence Before Interaction**  
   Launch must never explain, request action, onboard, or delay the user for branding.

2. **Breath Flow roles**  
   - Launch → Presence  
   - Welcome → Meaning  
   Same E10 identity; different purpose.

3. **System Launch Screen**  
   Static configuration matching the Today calm background. Quiet Breath Flow Presence is preferred. No app name, tagline, loading indicator, or animation.

4. **No post-launch branded interstitial**  
   First owned UI root remains Today. Apple’s Launch Screen disappears naturally into Today.

5. **Startup work**  
   Only necessary persistence, DR-015 bootstrap, daily sync, and Today load. Prohibit branding-only startup work and artificial delays.

6. **App Icon**  
   Approved Release App Icon must be installed in the app target asset catalog.

### Authority document

Implementation must follow:

- `Docs/Product/Launch-Architecture-Specification.md`
- `Docs/Product/Launch-UI-Specification.md` (visible Launch UI)

---

## Consequences

### Positive

- Startup has a clear emotional and architectural contract
- Welcome remains the meaning surface
- HIG-aligned static Launch Screen and no fake loading
- Reduced risk of duplicate branding and splash complexity

### Accepted trade-offs

- Launch background prioritizes Today cream continuity over exact App Icon sage matching
- Quiet Breath Flow on Launch is allowed as Presence (not required to be pixel-identical to Welcome Hero scale)

These trade-offs are accepted to preserve one calm inhale from icon to first interactive screen.

---

## Alternatives Considered

### Keep blank auto-generated Launch Screen

Rejected.

Creates visual discontinuity and contradicts Brand / ADR-010 Launch Screen expectation.

### Full-screen branded splash after process start

Rejected.

Duplicate branding, theatrical reveal, and risk of delay. Competes with Welcome.

### Put Welcome copy or tagline on Launch Screen

Rejected.

Violates Presence Before Interaction; pulls meaning into Launch.

### End First Journey on first app launch

Rejected.

DR-015 remains authoritative; Launch frequency must not control Welcome lifecycle.

---

## Related Decisions

- DR-001 — Project Principles
- DR-014 — Product UI First Strategy
- DR-015 — First Rhythm Onboarding Lifecycle
- ADR-010 — Primary Brand Symbol: Breath Flow

---

## Related Documents

- `Docs/Product/Launch-Architecture-Specification.md`
- `Docs/Product/Launch-UI-Specification.md`
- `Docs/Product/Welcome-Experience.md`
- `Docs/Product/Welcome-UI-Specification.md`
- `Docs/BRAND.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`

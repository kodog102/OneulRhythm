# DR-009 — Single Primary Rhythm

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Presentation Layer

---

## Context

The Single Focus Experience requires the application to present only one rhythm as the user's primary point of attention.

Although multiple rhythms may exist simultaneously within the business state, the presentation layer must expose a single, deterministic representation of what matters now.

Without a centralized selection process, different presentation surfaces could choose different rhythms, leading to inconsistent user experiences.

A single architectural decision is required to determine the presentation focus.

---

## Decision

The project adopts the concept of a **Single Primary Rhythm**.

For every presentation update, exactly one rhythm is selected as the primary presentation target.

The responsibility for selecting the primary rhythm belongs to the presentation layer, based on the resolved business state produced by the Schedule Engine.

Business logic determines the state of the day.

Presentation logic determines which resolved rhythm becomes the user's focus.

All presentation surfaces consume the same primary rhythm to ensure a consistent experience.

The selection mechanism itself is considered an implementation detail and is intentionally defined outside this Decision Record.

---

## Consequences

### Positive

- A single, consistent point of focus across the application.
- Stable behavior across all presentation surfaces.
- Clear separation between business interpretation and presentation decisions.
- Presentation logic remains centralized.
- Future changes to selection strategy remain localized.

### Negative

- Only one rhythm receives immediate attention, even when multiple rhythms may be relevant.
- The selection strategy becomes a critical presentation responsibility.

These trade-offs are accepted because maintaining a single point of focus is fundamental to the product philosophy.

---

## Alternatives Considered

### Multiple Primary Rhythms

Rejected.

Allowing multiple simultaneous primary rhythms would conflict with the project's Single Focus Experience and increase cognitive load.

### Independent Selection by Each Presentation Surface

Rejected.

Allowing each presentation surface to determine its own primary rhythm would produce inconsistent behavior between the application and Live Activity.

### Business Layer Determines the Primary Rhythm

Rejected.

Selecting the user's presentation focus is a presentation concern rather than a business concern.

Keeping this responsibility outside the Schedule Engine preserves clear architectural boundaries.

---

## Related Decisions

- DR-001 — Project Principles
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
- DR-006 — Live Activity Architecture
- DR-007 — Schedule Resolution
- DR-008 — Single Focus Experience
- DR-010 — Immediate Day Complete
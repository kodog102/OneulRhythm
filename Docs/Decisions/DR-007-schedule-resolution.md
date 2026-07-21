# DR-007 — Schedule Resolution

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Schedule Engine

---

## Context

Persisted rhythm data represents scheduled events and completion history.

However, the application cannot present persisted data directly.

At any given moment, the application must determine which rhythms are relevant based on the current time and completion state.

This interpretation is a business decision rather than a persistence concern or a presentation concern.

A consistent resolution process is required to ensure every feature observes the same understanding of the user's day.

---

## Decision

The project defines **Schedule Resolution** as the process of interpreting persisted rhythm data into a deterministic representation of the current day.

Schedule Resolution is owned exclusively by the Schedule Engine.

Its responsibilities include:

- Interpreting rhythms relative to the current time.
- Evaluating completion together with scheduling information.
- Producing a complete business representation of the day.
- Providing a consistent result to all presentation layers.

Schedule Resolution does not perform persistence.

Schedule Resolution does not render user interface.

Schedule Resolution does not make presentation decisions.

All application features requiring knowledge of the current day must rely on the Schedule Engine's resolution rather than independently interpreting persisted data.

---

## Consequences

### Positive

- A single interpretation of the user's day.
- Consistent behavior across all presentation surfaces.
- Business rules remain centralized.
- Future scheduling changes remain localized.
- Improved determinism and testability.

### Negative

- Every feature requiring schedule information depends on the Schedule Engine.
- Changes to scheduling behavior affect all consumers of resolved schedules.

These trade-offs are accepted because schedule interpretation is a core business responsibility.

---

## Alternatives Considered

### Independent Schedule Interpretation

Rejected.

Allowing multiple components to interpret schedules independently would inevitably produce inconsistent application behavior.

### Presentation-Layer Resolution

Rejected.

Presentation layers should consume business results rather than determine business state.

---

## Related Decisions

- DR-001 — Project Principles
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
- DR-008 — Single Focus Experience
- DR-009 — Single Primary Rhythm
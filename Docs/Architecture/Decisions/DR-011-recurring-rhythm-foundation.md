# DR-011 — Recurring Rhythm Foundation

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Domain Model

---

## Context

The initial version of OneulRhythm focuses on single-day rhythm management.

However, recurring rhythms are considered a fundamental capability of the product's long-term vision.

The architecture should support recurring rhythms in the future without requiring significant changes to the core scheduling, persistence, or presentation layers.

A forward-compatible foundation is therefore required.

---

## Decision

The project is designed to accommodate recurring rhythms as an extension of the existing architecture rather than as a separate scheduling system.

Recurring behavior is treated as a source of daily rhythms, not as a different type of rhythm.

Once a rhythm is resolved for a specific day, all downstream components operate on it in the same way regardless of how it originated.

The Schedule Engine remains responsible for interpreting the day's rhythms.

Presentation layers remain independent of recurrence rules.

The mechanism used to generate daily rhythms from recurrence definitions is intentionally left outside this Decision Record.

---

## Consequences

### Positive

- Preserves the existing architecture as recurring support is introduced.
- Prevents duplication of scheduling and presentation logic.
- Allows recurrence features to evolve independently of the user interface.
- Keeps business responsibilities clearly separated.

### Negative

- Introducing recurrence requires an additional generation process before schedule resolution.
- Future recurrence capabilities must integrate with the existing architecture rather than bypass it.

These trade-offs are accepted because architectural consistency is prioritized over introducing a separate recurrence workflow.

---

## Alternatives Considered

### Separate Recurring Schedule Engine

Rejected.

Maintaining independent scheduling paths for recurring and non-recurring rhythms would duplicate business logic and increase maintenance complexity.

### Presentation-Aware Recurrence

Rejected.

Presentation layers should remain unaware of how daily rhythms are produced.

Displaying rhythms should not depend on whether they originated from recurring definitions or one-time creation.

---

## Related Decisions

- DR-002 — SwiftData Persistence
- DR-003 — Repository Layer
- DR-004 — Schedule Engine
- DR-007 — Schedule Resolution
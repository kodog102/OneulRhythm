# DR-005 — Today Snapshot

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Presentation Layer

---

## Context

The application presents a time-aware view of the user's rhythms.

While the Schedule Engine determines the business state of rhythms, the user interface requires a presentation model that is stable, deterministic, and independent of business logic.

Allowing Views to interpret schedule information directly would duplicate presentation decisions and tightly couple the user interface to business state.

A dedicated presentation model is required to separate business interpretation from user interface rendering.

---

## Decision

The project adopts a **Snapshot** as the presentation model for the Today experience.

The Snapshot represents the complete state required by the user interface at a specific point in time.

Its responsibilities include:

- Representing presentation-ready data.
- Combining information from multiple business sources.
- Providing a stable interface for Views.
- Remaining immutable once created.

The Snapshot does not perform business calculations.

The Snapshot does not access persistence.

The Snapshot does not determine scheduling behavior.

Its responsibility is limited to presenting business results in a form suitable for rendering.

Views consume the Snapshot directly without additional interpretation.

---

## Consequences

### Positive

- Clear separation between business logic and presentation.
- Declarative Views with minimal conditional logic.
- Consistent rendering across application features.
- Simplified testing through immutable presentation state.
- Future UI changes remain isolated from business logic.

### Negative

- Introduces an additional transformation step between business logic and rendering.
- Requires explicit mapping from business models to presentation models.

These trade-offs are accepted because they improve maintainability and preserve architectural boundaries.

---

## Alternatives Considered

### Views Interpret Business State

Rejected.

Embedding presentation decisions inside Views would increase complexity and make rendering behavior inconsistent across the application.

### ViewModels Expose Domain Models Directly

Rejected.

Domain models represent business concepts rather than presentation concerns.

Exposing them directly would couple the user interface to business structures and encourage presentation logic to spread across multiple layers.

---

## Related Decisions

- DR-001 — Project Principles
- DR-003 — Repository Layer
- DR-004 — Schedule Engine
- DR-006 — Live Activity Architecture
- DR-009 — Single Primary Rhythm
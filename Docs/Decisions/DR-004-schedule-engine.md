# DR-004 — Schedule Engine

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Business Logic Layer

---

## Context

OneulRhythm presents users with rhythms based on the current point in time.

Determining which rhythm should be presented is a business decision rather than a presentation concern.

Without a dedicated scheduling component, this logic would gradually spread across ViewModels, Views, Live Activities, and future features, leading to inconsistent behavior and duplicated implementations.

The application requires a single component responsible for interpreting persisted rhythm data into a time-aware representation.

---

## Decision

The project adopts a dedicated **Schedule Engine** as the sole owner of schedule resolution.

The Schedule Engine is responsible for:

- Evaluating rhythms relative to the current time.
- Producing a consistent schedule representation.
- Interpreting completion state together with scheduled time.
- Providing the business state required by higher layers.

The Schedule Engine does not perform persistence.

The Schedule Engine does not render user interface.

The Schedule Engine does not contain presentation decisions.

Its responsibility is limited to transforming persisted domain data into deterministic scheduling information.

All application features requiring rhythm scheduling must rely on the Schedule Engine rather than implementing independent scheduling logic.

---

## Consequences

### Positive

- A single source of truth for schedule interpretation.
- Consistent behavior across all presentation layers.
- Elimination of duplicated scheduling logic.
- Improved testability through deterministic inputs and outputs.
- Future scheduling enhancements remain localized within a single component.

### Negative

- Introduces an additional architectural layer.
- Even simple scheduling scenarios must pass through the Schedule Engine.

These trade-offs are accepted because schedule resolution is a core business responsibility of the application.

---

## Alternatives Considered

### Schedule Resolution inside ViewModels

Rejected.

ViewModels are responsible for coordinating presentation state, not interpreting business schedules.

Embedding scheduling logic inside ViewModels would increase duplication and reduce consistency.

### Schedule Resolution inside Views

Rejected.

Views should remain declarative and presentation-focused.

Business logic within Views would be difficult to maintain and test.

### Schedule Resolution inside Repository

Rejected.

Repositories manage persistence.

Interpreting schedules is a business concern rather than a persistence concern.

---

## Related Decisions

- DR-001 — Project Principles
- DR-002 — SwiftData Persistence
- DR-003 — Repository Layer
- DR-005 — Today Snapshot
- DR-007 — Schedule Resolution
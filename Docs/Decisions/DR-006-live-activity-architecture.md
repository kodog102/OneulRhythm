# DR-006 — Live Activity Architecture

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Activity Presentation Layer

---

## Context

OneulRhythm extends the Today experience beyond the application by presenting the current rhythm through Live Activities.

The information displayed in a Live Activity must remain consistent with the information presented inside the application.

Maintaining separate business logic for the application and the Live Activity would introduce duplicated scheduling behavior and increase the risk of inconsistent user experiences.

A shared architectural approach is required.

---

## Decision

The project treats the Live Activity as an additional presentation surface rather than an independent feature.

Live Activities consume the same business state used by the application.

The Live Activity layer is responsible only for:

- Receiving presentation data.
- Mapping presentation data into ActivityKit models.
- Updating the active Live Activity.
- Ending the Live Activity when appropriate.

Business logic remains outside the Live Activity layer.

Scheduling decisions continue to be owned by the Schedule Engine.

Presentation decisions continue to be owned by the Snapshot.

The Live Activity layer exists solely to adapt application state for ActivityKit.

---

## Consequences

### Positive

- A single business flow serves both the application and Live Activity.
- Eliminates duplicated scheduling logic.
- Consistent user experience across presentation surfaces.
- Future presentation surfaces can reuse the same architecture.
- ActivityKit remains isolated from core business logic.

### Negative

- Requires an additional mapping layer between application models and ActivityKit models.
- Live Activity capabilities remain constrained by ActivityKit limitations.

These trade-offs are accepted to preserve architectural consistency.

---

## Alternatives Considered

### Independent Live Activity Logic

Rejected.

Allowing the Live Activity to resolve schedules independently would duplicate business rules and increase maintenance complexity.

### Live Activity Reads Persistence Directly

Rejected.

The Live Activity should not become another business component.

Persistence access remains the responsibility of the Repository layer.

---

## Related Decisions

- DR-001 — Project Principles
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
- DR-009 — Single Primary Rhythm
- DR-010 — Immediate Day Complete
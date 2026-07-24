# DR-012 — Notification Plan Architecture

**Status:** Accepted  
**Decision Date:** Sprint 7 — T2  
**Applies From:** Notification Mapping Layer

---

## Context

OneulRhythm schedules optional one-time reminder notifications after rhythm creation.

Sprint 7 T1 introduced `NotificationTriggerPolicy` as the single source of truth for trigger-date calculation. Presentation still owned notification identity, copy, and plan assembly at the call site.

Without a dedicated plan layer, notification desired state remains entangled with presentation and Apple scheduling APIs. Future synchronization against pending requests would then lack a pure desired-state model.

---

## Decision

Introduce a pure Notification Plan layer between domain rhythms and Apple scheduling.

### NotificationPlan ownership

`NotificationPlan` is the desired notification state only.

It owns:

- Ordered `NotificationPlanItem` values
- Identifier, title, body, and trigger date per item

It does not own:

- Synchronization metadata
- Pending request state
- Versioning or day stamps
- Diff operations
- Apple framework types
- Scheduling side effects

### NotificationMapper responsibility

`NotificationMapper` transforms domain `Routine` values into a `NotificationPlan`.

It is responsible for:

- Ignoring rhythms without a schedulable reminder
- Delegating trigger calculation to `NotificationTriggerPolicy`
- Producing deterministic plan item ordering
- Preserving notification title and body ownership outside presentation

It is not responsible for:

- Persistence
- Permission UX
- Calling `NotificationScheduling`
- Schedule Engine resolution

### Pipeline

```text
Routine
    │
    ▼
NotificationMapper
    │
    ▼
NotificationPlan
    │
    ▼
NotificationScheduling
    │
    ▼
NotificationService
```

`NotificationService` remains the Apple UserNotifications boundary.

`NotificationTriggerPolicy` remains the single trigger-date policy.

Notification failures must never fail persistence.

---

## Consequences

### Positive

- Desired notification state is a pure, testable value model.
- Presentation no longer owns notification identity, copy, or trigger assembly.
- Trigger calculation remains centralized in `NotificationTriggerPolicy`.
- Future synchronization can consume `NotificationPlan` without redesigning Schedule Engine.

### Negative

- An additional mapping step exists between domain rhythms and scheduling.
- Full schedule-driven notification synchronization remains a later Sprint slice.

These trade-offs are accepted to keep notification ownership aligned with the Mapping Layer.

---

## Alternatives Considered

### Keep plan assembly in AddRoutineView

Rejected.

Presentation would continue to own notification identity and copy, blocking a clean synchronization boundary.

### Move notification logic into Schedule Engine

Rejected.

Schedule Engine resolves business day state. Notification desired state is a surface-specific mapping concern.

### Introduce a Notification Coordinator in T2

Rejected.

Coordinator and pending-request reconciliation are out of scope for T2. Plan is desired state only.

---

## Related Decisions

- DR-001 — Project Principles
- DR-002 — SwiftData Persistence
- DR-004 — Schedule Engine
- DR-006 — Live Activity Architecture

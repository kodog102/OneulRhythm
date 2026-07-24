# DR-013 — Notification Synchronization

**Status:** Accepted  
**Decision Date:** Sprint 7 — T3  
**Applies From:** Notification Scheduling Layer

---

## Context

Sprint 7 T2 introduced `NotificationPlan` as the pure desired notification state and `NotificationMapper` as its producer.

Desired state alone does not keep UserNotifications pending requests aligned. Without an explicit reconciliation step, callers would either overwrite blindly or leave stale pending requests in place.

Synchronization must remain free of trigger-date policy and Schedule Engine concerns.



---

## Decision

NotificationScheduling owns reconciliation between desired `NotificationPlan` and currently pending notification requests.

### Ownership

`NotificationSynchronization` owns minimal deterministic diff calculation.

It produces only:

- remove operations
- schedule operations

An update is expressed as remove + schedule for the same identifier.

`NotificationScheduling.synchronize(with:)` owns applying that diff through Apple-isolated schedule/cancel APIs.

`NotificationService` remains the only UserNotifications boundary.

### Non-ownership

NotificationScheduling / NotificationSynchronization must not:

- calculate trigger dates
- contain Schedule Engine business rules
- duplicate `NotificationMapper` responsibilities
- introduce a Notification Coordinator

`NotificationPlan` remains desired state only. Diff metadata does not live on the plan model.

### Pipeline

```text
NotificationPlan (desired)
        │
        ▼
NotificationSynchronization (minimal diff)
        │
        ▼
NotificationScheduling.synchronize
        │
        ▼
NotificationService (Apple boundary)
```

Notification failures must never fail persistence.

---

## Consequences

### Positive

- Pending requests can be reconciled deterministically from desired state.
- Trigger policy and mapping remain unchanged.
- Apple framework interaction stays isolated in `NotificationService`.
- Sync logic is unit-testable without UserNotifications.

### Negative

- Callers that own only a partial plan must not treat it as the full desired state.
- App lifecycle / background invocation of synchronization remains a later concern.

These trade-offs are accepted to keep T3 scoped to synchronization mechanics.

---

## Alternatives Considered

### Blind reschedule (cancelAll + schedule plan)

Rejected.

Would perform unnecessary work and increase flakiness. Minimal diff is preferred.

### Put diff logic inside NotificationMapper

Rejected.

Mapper produces desired state. Reconciliation against pending requests is a scheduling concern.

### Introduce Notification Coordinator in T3

Rejected.

Coordinator and lifecycle integration are out of scope for T3.

---

## Related Decisions

- DR-012 — Notification Plan Architecture
- DR-001 — Project Principles
- DR-006 — Live Activity Architecture


NotificationSynchronization compares desired notification state with pending notification state. It does not interpret business rules.

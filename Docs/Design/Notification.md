# Notification

Notification defines how OneulRhythm expresses desired reminder state for rhythms and reconciles that state with pending UserNotifications requests.

Desired state is produced as a pure `NotificationPlan`. Delivery and pending-request reconciliation are owned by `NotificationScheduling`.

Schedule interpretation remains owned by the Schedule Engine. Apple delivery remains owned by `NotificationService`.

---

# Purpose

The Notification subsystem exists to:

- Transform rhythms with reminders into desired notification state.
- Keep trigger calculation centralized in `NotificationTriggerPolicy`.
- Reconcile desired state with pending notification requests.
- Isolate Apple UserNotifications behind `NotificationScheduling`.
- Preserve persistence success when notification delivery fails.

---

# Responsibilities

Notification is responsible for:

- Building a `NotificationPlan` from domain rhythms.
- Creating `NotificationPlanItem` values with identifier, title, body, and trigger date.
- Using `NotificationTriggerPolicy` for trigger-date calculation.
- Computing a minimal sync diff between desired plan and pending requests.
- Applying add / remove / update operations through `NotificationScheduling`.
- Keeping permission UX in Presentation.

---

# Non-Responsibilities

Notification is **not** responsible for:

- Schedule Engine resolution.
- Producing `ResolvedSchedule`.
- Background refresh.
- App lifecycle integration.
- Recurring reminder scheduling.
- Widget, Watch, or Live Activity behavior.
- Changing notification copy independently of the mapper.
- Introducing a Notification Coordinator.

Recurring reminders remain persist-only. No OS notification is scheduled for recurring create flows in the current slice.

---

# Architecture

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
NotificationSynchronization  (minimal diff)
      │
      ▼
NotificationScheduling.synchronize
      │
      ▼
NotificationService
```

`NotificationPlan` is desired state only.

`NotificationSynchronization` compares desired state with pending requests. It does not interpret business rules or derive business state.

`NotificationService` is the Apple boundary.

`NotificationTriggerPolicy` is the single trigger-date policy.

---

# Data Flow

## One-time create

```text
AddRoutineView
      │
      ▼
Persist RoutineCreationInput
      │
      ▼
Routine (with reminderMinutes)
      │
      ▼
NotificationMapper.makePlan
      │
      ▼
NotificationPlan
      │
      ▼
NotificationScheduling.schedule (per item)
```

One-time create schedules the newly produced plan items after successful persistence.

Full pending-request reconciliation is available through `NotificationScheduling.synchronize(with:)` when the caller owns the complete desired plan.

Permission prompting remains in Presentation and is unchanged.

## Synchronization

```text
Desired NotificationPlan
      │
      ▼
pendingRequests()
      │
      ▼
NotificationSynchronization.changes
      │
      ▼
remove / schedule operations
      │
      ▼
NotificationService
```

---

# NotificationPlan

`NotificationPlan` contains ordered `NotificationPlanItem` values.

Each item contains:

- identifier
- title
- body
- triggerDate

Rules:

- Pure value model
- No Apple framework types
- No scheduling side effects
- Equatable

Out of scope for the plan model:

- Synchronization metadata
- Pending request state
- Versioning
- Day stamp
- Diff operations

---

# NotificationMapper

Conceptual API:

```text
NotificationMapper.makePlan(
    routines: [Routine],
    now: Date,
    calendar: Calendar
) -> NotificationPlan
```

Behavior:

- Ignore nil reminder through `NotificationTriggerPolicy`
- Omit past and exact-now triggers
- identifier = routine.id.uuidString
- Preserve existing title and body
- Sort deterministically by triggerDate, then identifier
- Perform no scheduling

---

# Notification Synchronization

Conceptual API:

```text
NotificationSynchronization.changes(
    desired: NotificationPlan,
    pending: [PendingNotificationRequest]
) -> [NotificationSyncChange]
```

Operations:

- `remove(identifier:)` when pending is absent from the plan, or must be replaced
- `schedule(NotificationPlanItem)` when desired is missing or was replaced

Update semantics:

```text
remove + schedule
```

for the same identifier when title, body, or triggerDate differs.

Ordering:

1. All removes, sorted by identifier
2. All schedules, sorted by triggerDate then identifier

`NotificationScheduling.synchronize(with:)` retrieves pending requests, computes the diff, and applies it.

`synchronize(with:)` treats the plan as the complete desired state. Passing a partial plan can cancel unrelated pending notifications that are absent from that plan.

Synchronization must not:

- calculate trigger dates
- contain business rules
- derive business state
- duplicate NotificationMapper responsibilities

---

# Domain Mapping

`Routine.reminderMinutes` is part of the domain model.

`RoutineEntity.toDomain()` maps persisted reminder configuration onto `Routine`.

`RoutineEntity(routine:)` writes `routine.reminderMinutes` back to persistence.

---

# Failure Isolation

Notification scheduling and synchronization failures must never fail rhythm persistence.

Save succeeds first. Notification work is best-effort afterward.

Permission denied leaves the saved rhythm intact and schedules nothing.

---

# Design Notes

`NotificationPlan` remains the source of truth for desired notification state.

Pending requests are current Apple state, not desired state.

The Schedule Engine remains free of notification logic.

---

# Related Decisions

- DR-013 — Notification Synchronization
- DR-012 — Notification Plan Architecture
- DR-001 — Project Principles
- DR-002 — SwiftData Persistence
- DR-004 — Schedule Engine

---

# Related Documents

- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Mapper.md
- Docs/Design/Scheduling.md
- Docs/Design/Persistence.md

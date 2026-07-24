# Notification

Notification defines how OneulRhythm expresses desired reminder state for rhythms.

It is a Mapping Layer concern. Desired state is produced as a pure `NotificationPlan` and delivered through `NotificationScheduling`.

Schedule interpretation remains owned by the Schedule Engine. Apple delivery remains owned by `NotificationService`.

---

# Purpose

The Notification subsystem exists to:

- Transform rhythms with reminders into desired notification state.
- Keep trigger calculation centralized in `NotificationTriggerPolicy`.
- Isolate Apple UserNotifications behind `NotificationScheduling`.
- Preserve persistence success when notification delivery fails.

---

# Responsibilities

Notification is responsible for:

- Building a `NotificationPlan` from domain rhythms.
- Creating `NotificationPlanItem` values with identifier, title, body, and trigger date.
- Using `NotificationTriggerPolicy` for trigger-date calculation.
- Scheduling plan items through `NotificationScheduling` after successful persistence.
- Keeping permission UX in Presentation.

---

# Non-Responsibilities

Notification is **not** responsible for:

- Schedule Engine resolution.
- Producing `ResolvedSchedule`.
- Pending request reconciliation.
- Cancel / reschedule synchronization.
- Background refresh.
- Recurring reminder scheduling.
- Widget, Watch, or Live Activity behavior.
- Changing notification copy independently of the mapper.

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
NotificationScheduling
      │
      ▼
NotificationService
```

`NotificationPlan` is desired state only.

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

Presentation does not own notification identifier, title, body, or trigger calculation after save.

Permission prompting remains in Presentation and is unchanged.

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

# Domain Mapping

`Routine.reminderMinutes` is part of the domain model.

`RoutineEntity.toDomain()` maps persisted reminder configuration onto `Routine`.

`RoutineEntity(routine:)` writes `routine.reminderMinutes` back to persistence.

---

# Failure Isolation

Notification scheduling failures must never fail rhythm persistence.

Save succeeds first. Scheduling is best-effort afterward.

Permission denied leaves the saved rhythm intact and schedules nothing.

---

# Design Notes

Notification Plan prepares the architecture for later schedule synchronization without implementing synchronization in this slice.

The Mapping Layer owns desired notification state.

The Apple boundary owns delivery.

The Schedule Engine remains free of notification logic.

---

# Related Decisions

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

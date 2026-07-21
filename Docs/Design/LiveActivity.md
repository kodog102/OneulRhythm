# Live Activity

The Live Activity subsystem presents the current rhythm on the Lock Screen and Dynamic Island.

It is a presentation surface built on ActivityKit and consumes business state through the standard Mapping pipeline.

Live Activity never performs business interpretation.

---

# Purpose

The Live Activity subsystem exists to:

- Present the current rhythm outside the application.
- Surface important progress at a glance.
- Reflect business state consistently with the Today screen.
- Integrate ActivityKit into the existing architecture.

Live Activity is an additional presentation surface, not a separate business subsystem.

---

# Responsibilities

The Live Activity subsystem is responsible for:

- Displaying ActivityKit content.
- Receiving mapped presentation models.
- Coordinating Activity lifecycle.
- Updating Activity content.
- Ending completed Activities.

---

# Non-Responsibilities

The Live Activity subsystem is **not** responsible for:

- Reading persistence.
- Resolving schedules.
- Selecting the primary rhythm.
- Executing business rules.
- Determining day completion.
- Managing application state.

Those responsibilities belong to lower architectural layers.

---

# Architecture

```
Repository
      │
      ▼
Schedule Engine
      │
      ▼
ResolvedSchedule
      │
      ▼
Live Activity Mapper
      │
      ▼
Activity Content
      │
      ▼
Coordinator
      │
      ▼
ActivityKit
```

Live Activity is the final consumer of Activity-specific presentation models.

---

# Components

## Activity Mapper

The Activity Mapper transforms a `ResolvedSchedule` into `Activity Content`.

Its responsibilities include:

- Selecting Activity values.
- Formatting presentation data.
- Producing Activity-ready models.

It never manages ActivityKit.

---

## Coordinator

The Coordinator owns the ActivityKit lifecycle.

Typical responsibilities include:

- Request Activity.
- Update Activity.
- End Activity.
- Reconcile Activity state.

The Coordinator never performs business interpretation.

---

## ActivityKit

ActivityKit renders Activity Content on supported Apple surfaces.

Framework behavior remains outside the application's business architecture.

---

# Data Flow

```
ResolvedSchedule
        │
        ▼
Activity Mapper
        │
        ▼
Activity Content
        │
        ▼
Coordinator
        │
        ▼
ActivityKit
```

Business interpretation occurs before Activity mapping.

---

# Lifecycle

The Coordinator responds to changes in business state.

Typical transitions include:

```
No Activity
      │
      ▼
Request
      │
      ▼
Active
      │
      ▼
Update
      │
      ▼
End
```

Activity lifecycle is independent from business interpretation.

---

# Day Complete

When the business state enters **Day Complete**, the current Activity ends immediately.

```
ResolvedSchedule
        │
        ▼
Day Complete
        │
        ▼
Coordinator
        │
        ▼
Activity.end(.immediate)
```

The completion experience belongs to the application.

The Lock Screen should not retain a completed Activity after the day has finished.

---

# Activity Ownership

Only one Live Activity represents the current day.

The Coordinator ensures:

- At most one active Activity.
- Consistent reconciliation after app launch.
- Recovery after unexpected termination.
- Immediate cleanup when no longer needed.

---

# Synchronization

The Live Activity always reflects the latest resolved business state.

Typical update triggers include:

- Rhythm completion.
- Time progression.
- Foreground transition.
- Repository changes.
- Application launch.

Every update begins with a new `ResolvedSchedule`.

---

# Relationship with Today Screen

The Today screen and Live Activity share the same business pipeline.

```
ResolvedSchedule
        │
        ├───────────────┐
        │               │
        ▼               ▼
Today Mapper    Activity Mapper
        │               │
        ▼               ▼
Today Snapshot  Activity Content
```

Neither presentation surface depends on the other.

Both consume the same business truth.

---

# Design Principles

## Shared Business Truth

Live Activity must never derive its own business state.

---

## Independent Presentation

Activity-specific presentation remains isolated from other UI surfaces.

---

## Single Activity

Only one Live Activity may represent the current day.

---

## Immediate Completion

Completed days immediately remove their Live Activity.

---

## Framework Isolation

ActivityKit-specific behavior remains inside the Coordinator.

The rest of the application remains framework-independent.

---

# Extension Strategy

Future Activity enhancements should integrate through the existing architecture.

Possible extensions include:

- Richer Dynamic Island layouts.
- Additional progress indicators.
- Apple Watch mirroring.
- Interactive Activity actions.

Business interpretation remains unchanged.

---

# Design Notes

Live Activity is a presentation concern.

Its role is to visualize the application's current business state through ActivityKit.

Separating Mapping, Coordinator and ActivityKit keeps business logic independent while allowing the Activity experience to evolve without affecting the rest of the application.

---

# Related Decisions

- DR-001 — Project Principles
- DR-006 — Live Activity Architecture
- DR-009 — Single Primary Rhythm
- DR-010 — Immediate Day Complete

---

# Related Documents

- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Mapper.md
- Docs/Design/Presentation.md
- Docs/Design/Scheduling.md
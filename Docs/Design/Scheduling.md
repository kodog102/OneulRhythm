# Scheduling

Scheduling defines how OneulRhythm interprets rhythms for the current day.

It is the core business subsystem responsible for transforming persisted rhythm data into a deterministic business representation.

The output of scheduling is always a single `ResolvedSchedule`.

Presentation surfaces never interpret schedules independently.

---

# Purpose

The Scheduling subsystem exists to:

- Interpret persisted rhythms.
- Resolve the current state of the day.
- Evaluate completion together with time.
- Produce a deterministic business state.
- Provide one shared interpretation for every presentation surface.

Scheduling is the only subsystem responsible for understanding the meaning of a user's day.

---

# Responsibilities

Scheduling is responsible for:

- Resolving rhythms relative to the current time.
- Evaluating completion state.
- Determining the state of the current day.
- Producing a `ResolvedSchedule`.
- Maintaining deterministic business behavior.

Scheduling owns business interpretation.

---

# Non-Responsibilities

Scheduling is **not** responsible for:

- Reading persistence implementations.
- Rendering UI.
- Producing presentation models.
- Selecting visual focus.
- Updating Live Activities.
- Managing ActivityKit lifecycle.
- Creating notifications.
- Building notification plans.

Those responsibilities belong to other architectural layers.

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
Mapping Layer
```

Scheduling begins after persistence has provided domain data.

Scheduling ends once `ResolvedSchedule` has been produced.

Everything after that belongs to presentation.

---

# Business Flow

```
Persisted Rhythms
        │
        ▼
Schedule Resolution
        │
        ▼
ResolvedSchedule
```

The business interpretation is performed exactly once.

All presentation surfaces consume the same result.

---

# Resolution Principles

Scheduling follows a small set of deterministic rules.

---

## Current-Time Based

Scheduling always evaluates rhythms relative to the current time.

Time is part of the business interpretation.

---

## Completion-Aware

Completion is evaluated together with schedule information.

Neither completion nor time alone is sufficient.

---

## Deterministic

The same persisted data and the same point in time must always produce the same `ResolvedSchedule`.

---

## Stateless

Scheduling does not retain UI state.

Every resolution is derived from persisted business data.

---

## Framework Independent

Scheduling is completely independent from:

- SwiftUI
- ActivityKit
- WidgetKit
- Apple Watch

Business interpretation must remain portable.

---

# ResolvedSchedule

`ResolvedSchedule` is the official output of Scheduling.

It represents the interpreted state of the current day.

A `ResolvedSchedule` may contain business information such as:

- Current Rhythm
- Past Rhythm
- Next Rhythm
- Progress
- Day Complete

The internal representation is considered an implementation detail.

Presentation surfaces consume the result rather than reconstructing it.

---

# Relationship with Mapping

Scheduling and Mapping have different responsibilities.

Scheduling answers:

> "What is true?"

Mapping answers:

> "How should it be presented?"

```
ResolvedSchedule
        │
        ▼
Mapper
        │
        ▼
Presentation Model
```

Scheduling never decides visual priority.

Mapping never changes business interpretation.

---

# Relationship with ViewModel

The ViewModel coordinates scheduling.

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
Mapper
      │
      ▼
Publish
```

The ViewModel does not resolve schedules.

The ViewModel does not duplicate business rules.

---

# State Evolution

Scheduling reacts to changes in business state.

Typical triggers include:

- Persisted rhythm changes.
- Completion changes.
- Current time progression.
- Application launch.
- Application foreground transition.

Each trigger produces a newly resolved business state.

Previously resolved state should not be manually patched.

---

# Extension Strategy

Future scheduling capabilities should extend the existing resolution process.

Examples include:

- Recurring rhythms
- Calendar integration
- Cloud synchronization
- Shared rhythms

These capabilities should contribute to the generation of a `ResolvedSchedule`.

They should not introduce parallel scheduling mechanisms.

---

# Design Notes

Scheduling defines business truth.

Presentation should never reinterpret business state.

Maintaining a single scheduling pipeline guarantees consistent behavior across every presentation surface.

Whenever scheduling behavior changes, the change should remain localized to the Schedule Engine.

---

# Related Decisions

- DR-001 — Project Principles
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
- DR-007 — Schedule Resolution
- DR-008 — Single Focus Experience
- DR-009 — Single Primary Rhythm
- DR-010 — Immediate Day Complete

---

# Related Documents

- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Mapper.md
- Docs/Design/Presentation.md
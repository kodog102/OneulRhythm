# Mapper

The Mapping Layer transforms business state into presentation state.

It exists to separate business interpretation from presentation concerns while allowing multiple presentation surfaces to consume the same business model independently.

A Mapper performs transformation only.

It never owns business logic.

---

# Purpose

The Mapping Layer exists to:

- Transform business models into presentation models.
- Adapt one business state for multiple presentation surfaces.
- Keep presentation-specific rules outside the Business Layer.
- Prevent presentation logic from leaking into Views and ViewModels.
- Preserve a single interpretation of business state across the application.

---



# Responsibilities

The Mapping Layer is responsible for:

- Transforming Business Models into Presentation Models.
- Producing presentation-ready values.
- Selecting presentation-specific focus.
- Preparing data for individual presentation surfaces.
- Adapting business state without modifying it.

A Mapper never changes the business state.

---



# Non-Responsibilities

The Mapping Layer is **not** responsible for:

- Reading persistence.
- Writing persistence.
- Schedule interpretation.
- Current time evaluation.
- Business rule execution.
- Application state mutation.
- SwiftUI state management.
- Activity lifecycle management.

---



# Architecture

```
Business Layer
       │
       ▼
ResolvedSchedule
       │
       ▼
 Mapper Layer
       │
       ▼
Presentation Models
```

The Mapping Layer exists entirely between Business and Presentation.

---



# Mapping Flow

```
Repository
      │
      ▼
Schedule Engine
      │
      ▼
ResolvedSchedule
      │
      ├──────────────────────────────┐
      │                              │
      ▼                              ▼
Today Snapshot Mapper      Live Activity Mapper
      │                              │
      ▼                              ▼
Today Snapshot            Activity Content
```

The same business state may be transformed into multiple presentation models.

Each mapper is independent.

---



# Mapping Principles



## One Input

A mapper receives one business model.

```
ResolvedSchedule
```

---



## One Output

A mapper produces one presentation model.

Examples:

```
Today Snapshot
```

```
Activity Content
```

```
Future Widget Model
```

---



## No Shared Presentation Models

Presentation models are never reused across presentation surfaces.

Forbidden:

```
ResolvedSchedule
      │
      ▼
Today Snapshot
      │
      ▼
Activity Content
```

Required:

```
ResolvedSchedule
      │
      ├──────────────┐
      │              │
      ▼              ▼
Today Mapper    Activity Mapper
```

Each presentation surface owns its own transformation.

---



## Read Only

Business models are immutable from the perspective of a Mapper.

A Mapper never mutates the input model.

---



## Deterministic

Mapping must always be deterministic.

The same business model must always produce the same presentation model.

---



# Presentation Selection

Business state may contain multiple valid business objects.

The Today Snapshot chooses which object becomes the Primary Rhythm.

Priority:

1. Current
2. Past Incomplete
3. Next

```
Resolved schedule state

Current Rhythm

Past Rhythm

Next Rhythm
```

↓

```
Today Rhythm Snapshot
```

↓

```
Primary Rhythm
```

The selection belongs to the Snapshot because it is presentation-specific rather than a Schedule Engine concern.

---



# ViewModel Collaboration

The intended workflow is:

```
Load Data
      │
      ▼
Resolve Business State
      │
      ▼
Map Presentation State
      │
      ▼
Publish
```

The ViewModel coordinates the workflow but does not perform mapping itself.

---



# Surface Independence

Each presentation surface owns an independent mapper.

Examples include:

- Today Snapshot Mapper
- Live Activity Mapper
- Notification Mapper
- Widget Mapper
- Watch Mapper

Adding a new presentation surface should require only a new mapper.

Existing mappers should remain unchanged.

---



# Notification Mapping

`NotificationMapper` transforms domain `Routine` values into a `NotificationPlan`.

Input:

```
[Routine]
```

Output:

```
NotificationPlan
```

Trigger dates are computed only through `NotificationTriggerPolicy`.

The mapper does not schedule notifications or touch Apple frameworks.

See `Docs/Design/Notification.md` for the notification subsystem specification.

---



# Extension Strategy

Future presentation surfaces should integrate through the Mapping Layer.

Example:

```
ResolvedSchedule
        │
        ├───────────────┐
        │               │
        ▼               ▼
Today Mapper      Widget Mapper
        │               │
        ▼               ▼
Today UI        Widget Timeline
```

Business interpretation remains unchanged.

---



# Design Notes

A Mapper performs transformation only.

Business interpretation belongs to the Business Layer.

Presentation rendering belongs to the Presentation Layer.

Framework lifecycle belongs to Coordinators.

Maintaining this separation keeps every presentation surface consistent while allowing each surface to evolve independently.

---



# Related Decisions

- DR-001 — Project Principles
- DR-005 — Today Snapshot
- DR-006 — Live Activity Architecture
- DR-007 — Schedule Resolution
- DR-009 — Single Primary Rhythm
- DR-012 — Notification Plan Architecture

---



# Related Documents

- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Scheduling.md
- Docs/Design/Presentation.md
- Docs/Design/Notification.md
- Docs/Design/LiveActivity.md


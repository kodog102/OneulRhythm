# Architecture

This document describes the high-level architecture of OneulRhythm.

Its purpose is to explain how the major parts of the application are organized, how data flows through the system, and which dependency boundaries must be preserved.

Implementation details belong in the Design documents.  
The reasoning behind architectural choices belongs in the Architecture Decision Records.

---

## Architecture Principles

The architecture is guided by the following principles:

- Single Source of Truth
- Derived State Over Stored State
- Deterministic Behavior
- Separation of Responsibilities
- Presentation Independence
- Offline First
- Simplicity Before Abstraction

These principles are formally defined in the Architecture Decision Records.

---

## High-Level Architecture

OneulRhythm follows a unidirectional architecture composed of four primary layers:

```text
┌─────────────────────────────────────┐
│            Presentation             │
│                                     │
│  SwiftUI Views · ViewModels         │
│  Live Activity · Widgets · Watch    │
└─────────────────▲───────────────────┘
                  │ Presentation Models
┌─────────────────┴───────────────────┐
│               Mapping               │
│                                     │
│  Today Snapshot Mapper              │
│  Live Activity Mapper               │
│  Future Surface Mappers             │
└─────────────────▲───────────────────┘
                  │ Business Models
┌─────────────────┴───────────────────┐
│              Business               │
│                                     │
│  Schedule Engine                    │
│  Schedule Resolution                │
└─────────────────▲───────────────────┘
                  │ Persisted Domain Data
┌─────────────────┴───────────────────┐
│                Data                 │
│                                     │
│  Repository · SwiftData             │
└─────────────────────────────────────┘
```

Each layer has one primary purpose:

- **Data** stores and retrieves rhythms.
- **Business** interprets rhythms into deterministic business state.
- **Mapping** transforms business state for a specific presentation surface.
- **Presentation** renders mapped state and handles user interaction.

---

## Layer Responsibilities

### Presentation Layer

The Presentation Layer delivers the user experience.

It includes:

- SwiftUI views
- ViewModels
- Today presentation
- Live Activity presentation
- Widget presentation
- Future Apple Watch presentation

The Presentation Layer is responsible for:

- Rendering presentation models
- Receiving user actions
- Publishing observable UI state
- Triggering application workflows
- Forwarding user intent to the appropriate component

The Presentation Layer is not responsible for:

- Reading or writing persistence directly
- Interpreting schedules
- Reconstructing business state
- Duplicating mapping rules inside views
- Independently resolving which business data is relevant

Views should consume presentation-ready state rather than derive it themselves.

---

### Mapping Layer

The Mapping Layer is the boundary between business state and presentation state.

It includes surface-specific mappers such as:

- Today Snapshot Mapper
- Live Activity Mapper
- Future Widget Mapper
- Future Watch Mapper
- Future Notification Mapper

The Mapping Layer is responsible for:

- Transforming business models into presentation models
- Applying presentation-specific selection rules
- Producing presentation-ready values
- Adapting the same business state for different surfaces
- Preventing presentation concerns from entering the Business Layer

The Mapping Layer is not responsible for:

- Accessing persistence
- Resolving schedules
- Determining temporal business state
- Mutating application state
- Updating views or Live Activities directly
- Coordinating framework lifecycle operations

Each presentation surface has its own mapper.

Mappers do not depend on the output of other mappers.

```text
                         ┌──────────────────────┐
                         │ Today Snapshot Mapper│
                         └──────────┬───────────┘
                                    ▼
Resolved Schedule ─────────► Today Snapshot

                         ┌──────────────────────┐
                         │ Live Activity Mapper │
                         └──────────┬───────────┘
                                    ▼
Resolved Schedule ─────────► Activity Content
```

The following chained mapping structure is forbidden:

```text
Resolved Schedule
        │
        ▼
Today Snapshot
        │
        ▼
Live Activity Content
```

A presentation surface must not depend on another presentation surface's model.

---

### Business Layer

The Business Layer determines the meaning of the user's day.

It includes:

- Schedule Engine
- Schedule Resolution
- Resolved Schedule

The Business Layer is responsible for:

- Interpreting rhythms relative to time
- Evaluating schedule and completion state together
- Producing deterministic business state
- Representing the resolved state of the current day
- Maintaining one consistent interpretation for all consumers

The Business Layer is not responsible for:

- Persistence implementation
- UI labels or formatting
- Visual priority
- SwiftUI state
- ActivityKit lifecycle
- Presentation-surface-specific output

The official output of Schedule Resolution is:

```text
ResolvedSchedule
```

`ResolvedSchedule` is a business model.

It represents the interpreted state of the schedule before any presentation-specific decisions are applied.

---

### Data Layer

The Data Layer owns persistence.

It includes:

- Repository abstractions
- Repository implementations
- SwiftData entities
- Persistence mapping

The Data Layer is responsible for:

- Creating, reading, updating, and deleting persisted rhythms
- Isolating SwiftData from the rest of the application
- Mapping between persistence entities and domain data
- Providing persisted data to application workflows

The Data Layer is not responsible for:

- Schedule interpretation
- Current-time evaluation
- Primary rhythm selection
- Snapshot construction
- UI or Live Activity behavior

Persistence data must not be presented directly to the user.

---

## Core Data Flow

The application follows a one-way data flow.

```text
SwiftData
    │
    ▼
Repository
    │
    ▼
Schedule Engine
    │
    ▼
ResolvedSchedule
    │
    ├───────────────────────────┐
    │                           │
    ▼                           ▼
Today Snapshot Mapper     Live Activity Mapper
    │                           │
    ▼                           ▼
Today Snapshot            Activity Content
    │                           │
    ▼                           ▼
Today View                Live Activity
```

Persisted data flows upward through business interpretation and surface-specific mapping.

Presentation layers never reconstruct the schedule independently.

---

## Interaction Flow

User actions travel toward the owning layer, while derived state flows back toward presentation.

```text
User Action
    │
    ▼
View
    │
    ▼
ViewModel
    │
    ├────────► Repository mutation
    │
    └────────► Application reconciliation
                      │
                      ▼
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
             Presentation Model
                      │
                      ▼
                    View
```

After persisted data changes, presentation state is regenerated from the source of truth.

The application does not manually patch derived presentation state when it can be recomputed.

---

## ViewModel Role

ViewModels coordinate presentation workflows.

A ViewModel may:

- Request persisted rhythm data
- Invoke the Schedule Engine
- Invoke the appropriate mapper
- Publish presentation models
- Forward persistence mutations
- Trigger reconciliation after state changes

A ViewModel must not:

- Reimplement schedule resolution
- Contain persistence implementation
- Duplicate mapper rules
- Construct ActivityKit content directly
- Become the owner of domain behavior

The intended orchestration is:

```text
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

ViewModels coordinate these steps but do not absorb the responsibilities of the participating components.

---

## Shared Business State

All presentation surfaces originate from the same resolved business state.

```text
                     ResolvedSchedule
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
     Today Mapper     Activity Mapper    Future Mapper
          │                 │                 │
          ▼                 ▼                 ▼
    Today Snapshot    Activity Content   Surface Model
```

This ensures that:

- The application and Live Activity share one interpretation of the day.
- Presentation surfaces may differ without duplicating business rules.
- A new presentation surface can be added without changing schedule resolution.
- Existing presentation models remain independent from one another.

---

## Primary Rhythm Ownership

The Business Layer resolves the available state of the day.

The Mapping Layer determines how that state is represented for a particular presentation surface.

For the Today experience, selection of the single primary rhythm is performed while mapping `ResolvedSchedule` into the Today presentation model.

```text
ResolvedSchedule
        │
        ▼
Today Snapshot Mapper
        │
        ├── Select presentation focus
        ├── Assign presentation role
        └── Produce presentation-ready state
        │
        ▼
Today Snapshot
```

The Schedule Engine does not decide which rhythm receives visual focus.

The View does not choose among business candidates.

This preserves the separation between business interpretation and presentation intent.

---

## Live Activity Architecture

Live Activity is an additional presentation surface, not an independent scheduling system.

```text
ResolvedSchedule
        │
        ▼
Live Activity Mapper
        │
        ▼
Activity Content
        │
        ▼
Activity Coordinator
        │
        ▼
ActivityKit
```

The Live Activity Mapper transforms business state into ActivityKit-compatible presentation data.

The Activity Coordinator owns framework lifecycle operations such as:

- Requesting an activity
- Updating an activity
- Ending an activity
- Reconciling existing activities

The Mapper does not perform lifecycle operations.

The Coordinator does not resolve schedules.

---

## Dependency Rules

Dependencies must point toward more fundamental layers.

```text
Presentation
      │
      ▼
Mapping
      │
      ▼
Business
      │
      ▼
Data
```

Allowed dependency direction:

```text
Presentation → Mapping
Mapping      → Business
Business     → Data abstractions
Data         → Persistence frameworks
```

Forbidden dependency direction:

```text
Data         → Business
Data         → Mapping
Data         → Presentation

Business     → Mapping
Business     → Presentation

Mapping      → Presentation frameworks
```

The Mapping Layer may produce models intended for a specific presentation framework, but it must not control framework lifecycle or observable UI state.

---

## Model Boundaries

Each model has one architectural role.

| Model | Layer | Purpose |
|---|---|---|
| Persistence Entity | Data | SwiftData storage representation |
| Domain Rhythm | Business boundary | Framework-independent rhythm data |
| ResolvedSchedule | Business | Interpreted schedule state |
| Today Snapshot | Mapping output | Today presentation state |
| Activity Content | Mapping output | Live Activity presentation state |

Models should not cross boundaries merely for convenience.

In particular:

- SwiftData entities must not reach views.
- `ResolvedSchedule` must not contain UI labels or visual styling.
- Today Snapshot must not be reused as Live Activity input.
- ActivityKit models must not enter the Business Layer.

---

## Extension Strategy

New capabilities should extend the architecture through the appropriate boundary.

Examples:

```text
New presentation surface
        │
        ├── Add a surface-specific mapper
        └── Reuse ResolvedSchedule
```

```text
New persistence implementation
        │
        ├── Implement the Repository abstraction
        └── Preserve the Business Layer
```

```text
New scheduling behavior
        │
        ├── Update Schedule Resolution
        └── Preserve presentation independence
```

Expected future extensions include:

- Recurring rhythms
- Notifications
- Widgets
- Apple Watch
- Cloud synchronization
- Siri and Shortcuts

These capabilities should integrate with the existing flow rather than bypass it.

---

## Architectural Invariants

The following rules must remain true as the project evolves:

1. SwiftData is accessed only through the Data Layer.
2. Schedule interpretation exists only in the Business Layer.
3. `ResolvedSchedule` is the official result of schedule resolution.
4. Presentation models are produced through surface-specific mappers.
5. Views do not derive business state.
6. Mappers do not access persistence or control framework lifecycles.
7. Presentation surfaces do not depend on one another.
8. Live Activity uses the same resolved business state as the application.
9. Derived state is regenerated from the source of truth after mutations.
10. New abstractions are introduced only when they preserve or simplify these boundaries.

---

## Relationship to Other Documentation

| Document | Purpose |
|---|---|
| Architecture | Overall structure, boundaries, and dependency direction |
| Design | Detailed implementation behavior and algorithms |
| Decision Records | Architectural decisions and their rationale |
| Roadmap | Planned work and future milestones |
| CHANGELOG | Completed work and project history |

Architecture explains **what the system looks like**.

Decision Records explain **why it looks that way**.

Design documents explain **how each part is implemented**.
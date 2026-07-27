# Presentation

The Presentation Layer is responsible for displaying application state to the user.

It consumes presentation models produced by the Mapping Layer and renders them through platform-specific user interfaces.

Presentation never interprets business state.

---

# Purpose

The Presentation Layer exists to:

- Display presentation models.
- React to user interaction.
- Coordinate presentation updates.
- Reflect business state consistently.
- Remain independent from business interpretation.

Presentation answers one question:

> "How should the current application state be presented?"

---

# Responsibilities

The Presentation Layer is responsible for:

- Rendering presentation models.
- Managing view lifecycle.
- Handling user interactions.
- Coordinating data loading.
- Publishing presentation state.
- Triggering business actions.

Presentation owns user experience.

---

# Non-Responsibilities

The Presentation Layer is **not** responsible for:

- Schedule interpretation.
- Current time evaluation.
- Business rule execution.
- Persistence access.
- Entity conversion.
- Business state mutation.
- Selecting business truth.

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
Mapper
      │
      ▼
Presentation Model
      │
      ▼
Presentation Layer
```

The Presentation Layer is the final consumer of the application's business pipeline.

---

# Components

The Presentation Layer consists of several cooperating components.

```
SwiftUI View
        ▲
        │
ViewModel
        ▲
        │
Presentation Model
```

Each component has a distinct responsibility.

---

## View

Views are responsible for rendering UI.

Views should:

- Display state.
- Bind user interaction.
- Delegate actions.

Views should not:

- Resolve schedules.
- Access persistence.
- Execute business logic.

Views remain declarative.

---

## ViewModel

The ViewModel coordinates presentation.

Typical responsibilities include:

- Requesting data.
- Invoking business services.
- Mapping business state.
- Publishing presentation state.

The ViewModel orchestrates the presentation workflow.

It does not own business rules.

---

## Presentation Model

Presentation Models contain values already prepared for rendering.

Examples include:

- Today Snapshot
- Activity Content

Presentation Models should require no further business interpretation.

---

# State Management

Presentation state is derived.

The ViewModel publishes presentation models.

Views react to published state.

Presentation state should never become an alternative source of truth.

---

# User Interaction

User actions originate in the Presentation Layer.

Typical flow:

```
User Action
      │
      ▼
View
      │
      ▼
ViewModel
      │
      ▼
Business Layer
      │
      ▼
Repository
```

Business changes eventually produce a newly resolved presentation state.

Presentation should never manually patch business-derived values.

---

# Refresh Cycle

Presentation refreshes whenever business state changes.

Typical triggers include:

- Application launch.
- Foreground transition.
- Rhythm completion.
- Persisted data changes.
- Time progression.

Each refresh follows the same business pipeline.

---

# Design Principles

## Declarative

Presentation describes what should be shown.

It does not describe how business state is computed.

---

## Derived State

Presentation state is always derived from business state.

It should never become a competing source of truth.

---

## Stateless Rendering

Views render the current presentation model.

Views should avoid reconstructing business information.

---

## Platform Specific

Presentation implementations may differ across platforms.

Business interpretation remains shared.

---

# Surface Variants

Multiple presentation surfaces may exist.

Examples include:

- Today Screen
- Live Activity
- Widgets
- Apple Watch

Each surface owns:

- Its own Mapper.
- Its own Presentation Model.
- Its own UI implementation.

Business interpretation remains shared.

---

# Today Screen Presentation (Sprint 18)

Today is the primary in-app surface. After Sprint 18 it presents snapshot-derived states inside one North Star visual shell:

| State | Presentation role |
|-------|-------------------|
| Active | Primary rhythm card, optional next / Progress Ratio, completion CTA when allowed |
| First Journey | Welcome introduction (Breath Flow, hero meaning, philosophy, create CTA) — DR-015 |
| Normal Empty | Quiet empty after first successful create — create affordance only |
| Day Complete | Peaceful completion message — no create CTA, no progress competition |

Shared Today presentation language (presentation only):

- Morning Landscape background asset
- Premium card chrome (primary / secondary)
- Progress Ratio indicator — fixed checkpoints mapped from overall completion ratio; exact counts remain numeric
- Remaining-time ring trim from remaining/total duration when available

These are visual / UX presentation concerns. They do not change Schedule Engine, Snapshot ownership, repositories, SwiftData schema, or Live Activity lifecycle policy.

Visual Source of Truth: `Docs/Visual/NorthStars/Today-NorthStar-v1.jpg` (see `Docs/Visual/README.md`).

---

# Collaboration

The Presentation Layer collaborates with:

- Repository (indirectly)
- Schedule Engine (indirectly)
- Mapping Layer (directly)

Presentation should depend only on presentation models.

---

# Extension Strategy

New presentation surfaces should reuse the existing business pipeline.

```
ResolvedSchedule
        │
        ├──────────────┐
        │              │
        ▼              ▼
Today Mapper      Widget Mapper
        │              │
        ▼              ▼
Today UI        Widget UI
```

Business logic remains centralized.

Presentation grows horizontally rather than duplicating business behavior.

---

# Design Notes

Presentation is the final step in the application's architecture.

Its purpose is to faithfully render business state without modifying or reinterpreting it.

Maintaining a strict separation between Business, Mapping and Presentation ensures consistent behavior across every user interface.

---

# Related Decisions

- DR-001 — Project Principles
- DR-005 — Today Snapshot
- DR-006 — Live Activity Architecture
- DR-008 — Single Focus Experience
- DR-009 — Single Primary Rhythm
- DR-015 — First Rhythm Onboarding Lifecycle

---

# Related Documents

- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Mapper.md
- Docs/Design/Scheduling.md
- Docs/Design/Persistence.md
- Docs/Visual/README.md
- Docs/Product/Today-UI-Specification.md
- Docs/Product/Welcome-UI-Specification.md

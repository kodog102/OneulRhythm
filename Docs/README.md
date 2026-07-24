# OneulRhythm

> Calm daily rhythm management for iOS.

OneulRhythm is an offline-first iOS application that helps users focus on what matters **right now**.

Instead of presenting long lists of tasks, the application continuously determines a single rhythm that deserves the user's attention and shares that interpretation consistently across every presentation surface.

The project is built around deterministic scheduling, clear architectural boundaries, and a calm user experience.

---

# Architecture at a Glance

```
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
      ▼
Mapper
      │
      ▼
Presentation
```

This pipeline represents the core architecture of OneulRhythm.

Business state is resolved exactly once and transformed for each presentation surface without duplicating business logic.

---

# Vision

OneulRhythm is designed around four long-term goals.

- Help users focus on one rhythm at a time.
- Produce deterministic and predictable behavior.
- Share one business interpretation across the entire application.
- Grow without increasing architectural complexity.

Every architectural decision supports these goals.

---

# Core Concepts

## Repository

The Repository abstracts persistence and isolates SwiftData from the rest of the application.

It is the only component responsible for reading and writing persisted rhythm data.

---

## Schedule Engine

The Schedule Engine is the heart of OneulRhythm.

It interprets persisted rhythm data relative to the current time and applies business rules to determine the state of the user's day.

The Schedule Engine never depends on UI frameworks or presentation concerns.

---

## ResolvedSchedule

`ResolvedSchedule` is the official business output of the Schedule Engine.

It represents the fully interpreted state of the current day before any presentation-specific transformation occurs.

Every presentation surface consumes the same resolved business state.

---

## Mapper

A Mapper transforms business state into presentation state.

Each presentation surface owns an independent mapper.

Examples include:

- Today Snapshot Mapper
- Live Activity Mapper
- Notification Mapper
- Future Widget Mapper
- Future Watch Mapper

Because mapping is isolated from business logic, new presentation surfaces can be added without modifying the Schedule Engine.

---

# High-Level Architecture

OneulRhythm follows a unidirectional architecture consisting of four primary layers.

```
                 Presentation
                        ▲
                        │
               Presentation Models
                        ▲
                        │
                   Mapping Layer
                        ▲
                        │
                  Business Models
                        ▲
                        │
                  Business Layer
                        ▲
                        │
                    Repository
                        ▲
                        │
                     SwiftData
```

Each layer owns exactly one responsibility.

| Layer | Responsibility |
|--------|----------------|
| Data | Persist rhythm data |
| Business | Resolve deterministic business state |
| Mapping | Transform business models into presentation models |
| Presentation | Render presentation models and receive user interaction |

---

# Application Flow

The application follows one-way data flow.

```
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
    ├──────────────────────────────┐
    │                              │
    ▼                              ▼
Today Snapshot Mapper      Live Activity Mapper
    │                              │
    ▼                              ▼
Today Snapshot            Activity Content
    │                              │
    ▼                              ▼
Today View                Live Activity
```

The schedule is interpreted exactly once.

Presentation layers never reconstruct business state independently.

---

# Architectural Principles

The architecture follows a small set of long-lived principles.

- Single Source of Truth
- Derived State Over Stored State
- Deterministic Behavior
- Separation of Responsibilities
- Presentation Independence
- Offline First
- Simplicity Before Abstraction

These principles guide every architectural decision and are formally documented in the Decision Records.

---

# Documentation

Project documentation is organized into complementary levels.

## Architecture

Explains the overall system structure.

Topics include:

- Layer responsibilities
- Dependency direction
- Data flow
- Core architectural concepts

```
Architecture/
```

---

## Decision Records

Decision Records explain **why** the architecture looks the way it does.

They capture long-term architectural intent instead of implementation details.

```
Architecture/Decisions/
```
---

## Design

Design documents describe **how** each subsystem is implemented.

Current specifications include:

- Scheduling
- Persistence
- Mapper
- Presentation
- Live Activity
- Notification

```
Design/
```

Recurrence is documented as an extension under `Extensions/`.

---

## Development

Development documents define the official Sprint workflow.

```
Development/
  DEVELOPMENT_WORKFLOW.md
  PROMPT_LIBRARY.md
  CURSOR_GUIDELINES.md
  SPRINT_CHECKLIST.md
```

Product philosophy and architecture rules for AI agents remain in `AI/AGENTS.md`.

The older `DEVELOPMENT-PLAYBOOK.md` is superseded by `Development/DEVELOPMENT_WORKFLOW.md`.

---

# Recommended Reading Order

New contributors should read the documentation in the following order.

```
README
    │
    ▼
Architecture
    │
    ▼
Decision Records
    │
    ▼
Design
    │
    ▼
Development
```

This progresses from project overview to architectural intent, implementation details, and then the Sprint process.

---

# Current Architecture

The current architectural foundation includes:

- Offline-first persistence
- Repository abstraction
- Deterministic Schedule Engine
- ResolvedSchedule business model
- Dedicated Mapping Layer
- Single Primary Rhythm
- Today Snapshot
- Live Activity integration
- Immediate Day Complete lifecycle

---

# Future Direction

The architecture is intentionally designed for extension without changing its foundation.

Current product work:

Sprint 7

- Notification Synchronization available; lifecycle invocation remains open if needed

Planned capabilities include:

- Widgets
- Apple Watch
- Siri & Shortcuts
- Cloud synchronization

Future features should integrate through the existing architecture rather than bypassing it.

---

# Philosophy

OneulRhythm intentionally favors:

- Deterministic behavior over hidden magic.
- Clear responsibilities over convenience.
- Stable architecture over premature abstraction.
- Reusable business logic over duplicated presentation logic.
- Long-term maintainability over short-term optimization.

A predictable architecture creates a predictable user experience.

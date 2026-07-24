# Persistence

Persistence defines how OneulRhythm stores and retrieves rhythm data.

The Persistence subsystem isolates storage implementation from the rest of the application through the Repository boundary.

Business behavior must remain independent from the persistence technology.

---

# Purpose

The Persistence subsystem exists to:

- Store rhythm data.
- Retrieve persisted rhythm data.
- Isolate SwiftData from the Business Layer.
- Preserve a single persistence boundary.
- Support future persistence implementations.

Persistence is responsible for data storage only.

---

# Responsibilities

Persistence is responsible for:

- Creating persisted rhythms.
- Reading persisted rhythms.
- Updating persisted rhythms.
- Deleting persisted rhythms.
- Mapping persistence entities to domain models.
- Mapping domain models to persistence entities.

Persistence owns storage.

---

# Non-Responsibilities

Persistence is **not** responsible for:

- Schedule interpretation.
- Current time evaluation.
- Business rule execution.
- Presentation models.
- UI rendering.
- Live Activity.
- Notifications.
- Activity lifecycle.

Persistence stores data.

It never interprets data.

---

# Architecture

```
SwiftData
      │
      ▼
Repository Implementation
      │
      ▼
Repository Interface
      │
      ▼
Business Layer
```

The Business Layer depends only on the Repository abstraction.

Persistence frameworks remain hidden behind the Repository boundary.

---

# Data Flow

```
Business Layer
      │
      ▼
Repository
      │
      ▼
SwiftData
```

Reading

```
SwiftData
      │
      ▼
Repository
      │
      ▼
Domain Model
```

Writing

```
Domain Model
      │
      ▼
Repository
      │
      ▼
SwiftData
```

The Business Layer never accesses SwiftData directly.

---

# Repository Boundary

The Repository defines the persistence boundary of the application.

Its responsibilities include:

- Storage access.
- Entity conversion.
- Persistence isolation.

It intentionally excludes:

- Business rules.
- Scheduling.
- Presentation.
- Framework coordination.

---

# Domain Mapping

Persistence models are not business models.

```
SwiftData Entity
        │
        ▼
Repository
        │
        ▼
Domain Model
```

Likewise,

```
Domain Model
        │
        ▼
Repository
        │
        ▼
SwiftData Entity
```

The Repository owns these transformations.

`RoutineEntity.reminderMinutes` maps onto domain `Routine.reminderMinutes`.

Reminder configuration is persisted data. Notification planning and scheduling belong outside Persistence.

---

# Persistence Principles

## Single Entry Point

All persistence operations occur through the Repository.

---

## Technology Isolation

Business behavior should not depend on SwiftData.

Replacing the persistence implementation should not require changes to business logic.

---

## Framework Independence

Persistence frameworks remain isolated inside the Data Layer.

---

## No Business Interpretation

Persistence stores values.

Business meaning is produced later by the Schedule Engine.

---

## Deterministic Mapping

Entity conversion must be deterministic.

The same persisted entity should always produce the same domain model.

---

# Collaboration

```
Business
      │
      ▼
Repository
      │
      ▼
SwiftData
```

The Repository collaborates with the Business Layer by supplying domain models.

It never performs business interpretation.

---

# Extension Strategy

Future persistence technologies should replace only the Repository implementation.

Examples include:

- CloudKit
- SQLite
- REST synchronization
- Shared database

The Repository interface should remain stable.

The Business Layer should remain unchanged.

---

# Design Notes

Persistence exists to protect the Business Layer from storage concerns.

All framework-specific behavior remains inside the Data Layer.

Maintaining a single persistence boundary allows storage technology to evolve without affecting business behavior.

---

# Related Decisions

- DR-001 — Project Principles
- DR-002 — SwiftData Persistence
- DR-003 — Repository Layer

---

# Related Documents

- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Scheduling.md
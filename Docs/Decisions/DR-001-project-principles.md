# DR-001 — Project Principles

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Entire Project

---

## Context

As OneulRhythm grows beyond a simple prototype, architectural decisions become increasingly interconnected.

Without a shared set of principles, implementation details can gradually diverge, resulting in duplicated logic, inconsistent behavior, and increased maintenance costs.

This Decision Record establishes the core principles that guide all future architectural decisions.

---

## Decision

The project adopts the following architectural principles.

### 1. Single Source of Truth

Every business rule must have one authoritative owner.

Examples include:

- Persistence belongs to the Repository.
- Schedule resolution belongs to the Schedule Engine.
- Presentation state belongs to the Snapshot.
- UI renders state but does not create business rules.

Duplicating business logic across layers is prohibited.

---

### 2. Derived State Over Stored State

Persist durable facts.

Derive temporary state.

Persist examples:

- Rhythm definitions
- Completion history
- Reminder configuration

Derived examples:

- Current Rhythm
- Past Rhythm
- Next Rhythm
- Day Complete
- Progress

Derived state minimizes synchronization problems and reduces migration complexity.

---

### 3. Deterministic Behavior

Given the same persisted data and the same point in time, the application must always produce identical results.

Business logic must never depend on:

- View lifecycle
- Collection ordering
- Rendering timing

---

### 4. Separation of Responsibilities

Each layer owns a single responsibility.

| Layer | Responsibility |
|--------|----------------|
| Repository | Persistence |
| Schedule Engine | Business scheduling |
| Snapshot | Presentation model |
| ViewModel | State coordination |
| View | Rendering |

Responsibilities should not overlap.

---

### 5. Offline First

Core application behavior must not require network connectivity.

Scheduling, completion tracking, and presentation should function entirely on-device.

Cloud synchronization may be added later without changing the domain model.

---

### 6. Calm User Experience

Architecture should support a focused and predictable experience.

Examples include:

- One primary rhythm
- Minimal visual noise
- Predictable transitions
- Clear completion flow

Implementation decisions should favor simplicity over feature density.

---

### 7. Simplicity Before Abstraction

Abstractions should solve existing problems rather than anticipated ones.

Avoid:

- Premature protocol hierarchies
- Generic frameworks
- Unnecessary extensibility

Complexity should be introduced only when justified by real product requirements.

---

## Consequences

### Positive

- Consistent architectural direction.
- Clear ownership of business logic.
- Easier long-term maintenance.
- Reduced architectural drift.
- Improved onboarding for future contributors.

### Negative

- Some implementations may appear more structured than strictly necessary for a project of this size.
- Architectural changes should be documented before being introduced.

These trade-offs are accepted to preserve long-term consistency.

---

## Alternatives Considered

### Architecture without documented principles

Rejected.

Architectural intent becomes difficult to preserve as the project evolves.

### Defining architecture only through implementation

Rejected.

Implementation changes frequently, while architectural decisions should remain stable and understandable over time.

---

## Related Decisions

- DR-002 — SwiftData Persistence
- DR-003 — Repository Layer
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
- DR-009 — Single Primary Rhythm
- DR-011 — Recurring Rhythm Foundation
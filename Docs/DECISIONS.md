# Architecture Decisions

This document records long-lived architectural decisions for OneulRhythm.
It intentionally captures *why* decisions were made rather than implementation details.

---

# ADR-001 — SwiftUI + SwiftData

## Status

Accepted

## Decision

The application uses SwiftUI for the UI layer and SwiftData as the primary persistence layer.

## Rationale

The project targets iOS 17 and later.

SwiftUI and SwiftData provide:

- Native Apple platform integration
- Simple state-driven UI updates
- Reduced boilerplate
- Good compatibility with WidgetKit and ActivityKit
- Long-term maintainability

No third-party persistence framework is introduced unless future requirements clearly justify it.

---

# ADR-002 — Repository Pattern

## Status

Accepted

## Decision

Business logic never communicates directly with SwiftData models.

A repository abstraction is used between the application layer and persistence.

## Rationale

Benefits include:

- Separation of concerns
- Easier testing
- Storage implementation can evolve independently
- ViewModels remain persistence-agnostic

---

# ADR-003 — Schedule Engine

## Status

Accepted

## Decision

Routine scheduling logic is centralized inside `RoutineScheduleEngine`.

ViewModels do not calculate routine state themselves.

## Rationale

Keeping scheduling logic in a dedicated engine:

- avoids duplicated rules
- improves consistency
- simplifies testing
- allows future scheduling policies without changing UI code

---

# ADR-004 — Snapshot-Driven UI

## Status

Accepted

## Decision

TodayView renders immutable schedule snapshots produced by the schedule engine.

The UI never derives its own interpretation of routine timing.

## Rationale

A single source of truth prevents inconsistencies between:

- Today screen
- Live Activity
- Widgets
- Future Apple Watch surfaces

---

# ADR-005 — One Logical Live Activity Per Day

## Status

Accepted

## Decision

At most one logical Live Activity exists for a calendar day.

Duplicate activities are automatically reconciled.

## Rationale

This provides:

- predictable behavior
- clean Lock Screen presentation
- deterministic synchronization
- simplified recovery after app relaunch

---

# ADR-006 — Canonical Activity Selection

## Status

Accepted

## Decision

If multiple activities exist for the same day, one canonical activity is selected.

Selection rules:

1. Latest `updatedAt`
2. Lexicographically smallest identifier as tie-breaker

Non-canonical activities are immediately ended.

## Rationale

The selection algorithm must always produce a deterministic result.

---

# ADR-007 — Shared Activity Definitions

## Status

Accepted

## Decision

ActivityKit models and presentation policies are shared between the app target and widget extension.

## Rationale

Shared definitions prevent:

- duplicate models
- inconsistent Activity state
- extension/app drift

The shared module is the single source of truth for ActivityKit contracts.

---

# ADR-008 — Immediate Day Completion

## Status

Accepted

## Decision

When every routine for the current day is completed:

- the Live Activity ends immediately
- no lingering state is kept
- no delayed dismissal is scheduled

## Rationale

The completion experience belongs to the application itself.

Using immediate dismissal:

- relies only on documented ActivityKit behavior
- avoids cancellation complexity
- avoids undocumented end-state transitions
- guarantees deterministic lifecycle behavior

---

# ADR-009 — Eligible Activity Cleanup

## Status

Accepted

## Decision

Lifecycle operations only target activities in eligible runtime states.

Ended activities are never modified again.

## Rationale

ActivityKit does not guarantee behavior when re-ending an already-ended activity.

Restricting operations to active/stale activities produces deterministic behavior.

---

# ADR-010 — Best-Effort Live Activity Synchronization

## Status

Accepted

## Decision

Live Activity synchronization is non-blocking.

Application state is always considered the source of truth.

Failures to create, update, or end Activities never interrupt application behavior.

## Rationale

The routine experience must remain functional even when:

- Live Activities are disabled
- Activity authorization changes
- system limits prevent Activity creation

---

# Superseded Decisions

## Former Day-Complete Linger

Previous versions kept the Live Activity visible for approximately three minutes after all routines completed.

This behavior has been removed.

Reason:

- depended on delayed dismissal scheduling
- introduced unnecessary lifecycle complexity
- provided no functional benefit over immediate completion
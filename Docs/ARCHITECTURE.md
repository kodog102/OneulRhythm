# Architecture

This document describes the runtime architecture of OneulRhythm.

Implementation details may evolve over time, but the architectural boundaries described here are intended to remain stable.

---

# High-Level Architecture

OneulRhythm follows a layered architecture.

```
                SwiftUI Views
                      │
                      ▼
                ViewModels
                      │
                      ▼
                 Repository
                      │
                      ▼
             RoutineScheduleEngine
                      │
                      ▼
              Schedule Snapshot
                 │          │
                 │          ▼
                 │   LiveActivityCoordinator
                 │          │
                 ▼          ▼
             TodayView   ActivityKit
                              │
                              ▼
                     Widget Extension
```

Every presentation surface is driven from the same schedule snapshot.

---

# Architectural Principles

## Single Source of Truth

The schedule snapshot represents the current application state.

Views, Live Activities, and future widgets never calculate scheduling independently.

---

## Layered Responsibilities

Each layer owns exactly one responsibility.

### Views

Responsible only for presentation and user interaction.

Views never calculate routine timing.

---

### ViewModels

Coordinate UI actions and expose presentation data.

They never implement scheduling algorithms.

---

### Repository

Provides persistence access.

Business logic is isolated from SwiftData.

---

### Schedule Engine

Calculates:

- today's routines
- current routine
- next routine
- completed routines
- progress

The engine owns all scheduling rules.

---

### Live Activity Coordinator

Synchronizes ActivityKit with the latest schedule snapshot.

Responsibilities include:

- create activities
- update activities
- reconcile duplicates
- cleanup stale activities
- end completed-day activities

The coordinator never owns business logic.

---

# Shared Module

ActivityKit definitions are shared between the application target and the widget extension.

```
App
     │
     ▼
OneulRhythmShared
     ▲
     │
Widget Extension
```

The shared module contains:

- ActivityAttributes
- ContentState
- presentation policies
- shared Activity models

This guarantees identical interpretation across targets.

---

# Widget Extension

The widget extension is a rendering layer.

It receives ActivityKit state from the system and renders:

- Lock Screen
- Dynamic Island
- Live Activity

The extension never accesses:

- SwiftData
- repositories
- schedule engine

Rendering remains completely independent.

---

# Runtime Flow

A typical routine completion follows this sequence.

```
User taps Complete

↓

Repository updates completion

↓

Schedule Engine creates new snapshot

↓

TodayView refreshes

↓

LiveActivityCoordinator synchronizes

↓

ActivityKit updates

↓

Widget Extension renders new state
```

The same flow is used after application launch and schedule reconciliation.

---

# Day Completion Flow

When every routine has been completed:

```
Routine completed

↓

Schedule Snapshot

↓

Phase = Day Complete

↓

TodayView shows completed day

↓

Coordinator ends Live Activity

↓

Immediate dismissal
```

No delayed dismissal or lingering state exists.

---

# Activity Lifecycle

The coordinator maintains one logical Live Activity for each calendar day.

Lifecycle operations include:

- create
- update
- reconcile
- cleanup
- immediate end

Only eligible runtime activities participate in reconciliation.

Previously ended activities are never modified again.

---

# Error Handling

Live Activity synchronization is best-effort.

Failures never interrupt:

- repository updates
- schedule generation
- TodayView rendering

The application state always remains authoritative.

---

# Future Architecture

Future features are expected to integrate into the existing architecture.

Examples include:

- Apple Watch
- interactive widgets
- notifications
- cloud synchronization

New presentation surfaces should consume schedule snapshots rather than implementing independent scheduling logic.
# OneulRhythm Roadmap

## Product Vision

OneulRhythm helps users stay connected with today's rhythm.

The application should minimize management and maximize presence throughout the day.

---

# Current Status

**Current Phase**

Implementation

**Architecture**

✅ Stable

**Documentation**

✅ Stable

**Current Sprint**

Sprint 6-4 — Recurring Rhythm

---

# Completed

## Sprint 1 — Project Foundation

### Goal

Establish the technical foundation of the application.

### Completed

- SwiftUI project setup
- SwiftData integration
- Initial project structure
- Core application architecture

**Status**

✅ Completed

---

## Sprint 2 — Rhythm Management

### Goal

Allow users to create and manage their rhythms.

### Completed

- Create Rhythm
- Edit Rhythm
- Delete Rhythm
- Repository introduction
- Basic data persistence

**Status**

✅ Completed

---

## Sprint 3 — Today Experience

### Goal

Introduce today's rhythm experience.

### Completed

- Today Screen
- Current Rhythm
- Next Rhythm
- Daily Progress
- Initial presentation flow

**Status**

✅ Completed

---

## Sprint 4 — Persistence

### Goal

Separate persistence from business logic.

### Completed

- SwiftData Repository
- Repository abstraction
- ViewModel integration
- Domain model mapping

**Status**

✅ Completed

---

## Sprint 5 — Schedule Engine

### Goal

Introduce deterministic schedule resolution.

### Completed

- Schedule Engine
- Current Rhythm resolution
- Next Rhythm resolution
- Progress calculation
- Business schedule interpretation

**Status**

✅ Completed

---

## Sprint 6-1 — Live Activity Lifecycle

### Goal

Introduce Live Activity using a stable architecture.

### Completed

- Shared Activity Model
- Activity Coordinator
- Activity Lifecycle
- Immediate Day Complete
- Widget Extension
- Activity reconciliation

**Status**

✅ Completed

---

## Sprint 6-2 — Single Primary Rhythm

### Goal

Create a calm Today experience by presenting only one primary rhythm.

### Completed

- Single Primary Rhythm
- Past Rhythm
- Completion Promotion
- Next Rhythm Preview
- Live Activity integration
- Calm presentation flow

**Status**

✅ Completed

---

## Sprint 6-3 — Documentation Architecture

### Goal

Establish a long-term documentation system for the project.

### Completed

#### Architecture

- Architecture documentation
- Product Principles

#### Decisions

- Decision Record system
- DR-001 ~ DR-011

#### Design

- Mapper
- Scheduling
- Persistence
- Presentation
- Live Activity

#### Extensions

- Extensions documentation
- Recurring Rhythm architecture

#### Documentation

- Documentation hierarchy
- Glossary
- Documentation standards

**Status**

✅ Completed

---

# Current

## Sprint 6-4 — Recurring Rhythm

### Goal

Users define a rhythm once.

The application automatically presents today's occurrence.

### Scope

- No Repeat
- Daily
- Weekdays
- Weekends
- Daily completion reset
- Schedule Engine integration

### Success Criteria

- Users never recreate recurring rhythms.
- Daily completion resets automatically.
- Existing Today experience remains unchanged.
- Live Activity continues to consume today's rhythm.
- Future consumers reuse the same scheduling pipeline.

### Out of Scope

- Notifications
- Widgets
- Apple Watch
- Statistics
- Advanced recurrence

**Status**

🚧 In Progress

---

# Planned

## Sprint 6-5 — Notification Architecture

### Goal

Notifications become another consumer of today's schedule.

### Scope

- Notification permission
- Notification Scheduler
- Notification Plan
- Schedule synchronization

**Status**

📅 Planned

---

## Sprint 6-6 — Widget Experience

### Goal

Bring today's rhythm to the Home Screen.

### Scope

- Home Widget
- Timeline
- Shared Snapshot

**Status**

📅 Planned

---

## Sprint 6-7 — Apple Watch

### Goal

Bring today's rhythm to Apple Watch.

### Scope

- Watch App
- Watch Complication
- Shared Schedule

**Status**

📅 Planned

---

# Future

## Advanced Recurrence

Examples

- Custom weekdays
- Monthly recurrence
- Every N days
- End date
- Exception dates
- Holiday support

---

## Statistics

Examples

- Completion history
- Weekly trend
- Monthly trend
- Consistency score

---

## Subscription

Examples

- Advanced recurrence
- Statistics
- Premium themes
- Premium widgets

---

## Platform Extensions

Examples

- Cloud Sync
- Calendar Integration
- Siri
- Shortcuts
- Family Sharing

---

# Product Principles

Every new feature should answer one question.

> **Does this help users stay connected with today's rhythm?**

If the answer is no,

the feature probably does not belong in OneulRhythm.

---

# Documentation

Product and architecture documentation remain stable.

Sprint process documentation lives under `Docs/Development/`.

Future architectural changes should follow this process:

1. Approve scope and architecture before implementation.
2. Update or propose Decision Records and Design documentation when architecture or contracts change.
3. Implement the approved scope.
4. Run a Documentation Pass to synchronize affected docs with implemented behavior.
5. Record completed work in the Changelog and update this Roadmap.

The Roadmap tracks product evolution rather than implementation details.
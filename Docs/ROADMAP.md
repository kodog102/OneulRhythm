# OneulRhythm Roadmap

# Product Vision

OneulRhythm helps users stay connected with today's rhythm.

The application should minimize management and maximize presence throughout the day.

---

# Current Status

## Current Phase

Feature Development — Product UI First

## Current Sprint

Sprint 9 — Routine Management

## Status

📅 Ready

## Current Goal

Strengthen in-app rhythm creation and management so daily use feels complete.

## Current Priority

Product UI First.

Sprint 8 completed the Today Product Experience.

Notification Foundation remains complete and stable.

Until the in-app experience reaches MVP quality, development prioritizes Product UI over Widgets, Apple Watch, and other platform integrations.

## Next Sprint

Sprint 10 — Settings & Preferences

---

# Strategy

## Product UI First

After Sprint 7, the core architecture has reached a stable point:

- Today Snapshot
- Notification Pipeline
- Trigger Policy
- Notification Plan
- Notification Synchronization
- Live Activity foundation

At this stage, Product UI provides more validation value than immediately expanding platform integrations.

Widget and Apple Watch remain intentional long-term surfaces. They are postponed—not cancelled—so that:

- In-app UX can be validated faster
- Existing architecture stays stable
- Widget and Watch can reuse a finalized Product UI
- Duplicate UI work and architectural churn are avoided

This is a planning change only. It is not an architecture redesign.

See `Docs/Architecture/Decisions/DR-014-product-ui-first.md`.

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

## Sprint 6-4 — Recurring Rhythm

### Goal

Users define a rhythm once.

The application automatically presents today's occurrence.

### Completed

- Recurring Rhythm support

- Daily / Weekdays / Weekends recurrence

- RecurringRhythmEntity persistence

- Automatic daily occurrence provisioning

- Foreground synchronization

- Schedule Engine integration

- Runtime QA completed successfully

**Status**

✅ Completed

---

## Sprint 6-5 — Primary Rhythm Ownership

### Goal

Refine the Today experience so presentation focus is owned by the Today Snapshot.

### Completed

- Primary Rhythm selection inside TodayRhythmSnapshot

- Priority: Current → Past Incomplete → Next

- TodayViewModel forwards snapshot primary state

- TodayView renders only the Primary Rhythm

- Live Activity consumes the same snapshot primary role

- Schedule Engine, Repository, and Activity lifecycle remain unchanged

**Status**

✅ Completed

---

## Sprint 7 — Notification Foundation

### Goal

Notifications become another consumer of today's schedule.

### Completed

#### T1 — Notification Trigger Policy

- Notification permission

- One-time notification scheduling

- NotificationTriggerPolicy

- NotificationService integration

#### T2 — Notification Plan

- NotificationPlan / NotificationPlanItem

- NotificationMapper

- Routine.reminderMinutes domain mapping

- One-time scheduling through NotificationPlan

#### T3 — Notification Synchronization

- NotificationSynchronization minimal diff

- NotificationScheduling.synchronize

- Add / remove / update reconciliation

### Deferred (non-blocking)

- App lifecycle / background invocation of synchronization remains optional future work if approved later

Notification Foundation is considered stable. Deferred lifecycle invocation does not block Product UI work.

**Status**

✅ Completed

---

## Sprint 8 — Today Product Experience

### Goal

Elevate the in-app Today experience toward MVP quality.

### Completed

- Calm single-focus Today experience
- Single Primary Rhythm presentation
- Empty State redesign
- Empty-only Create Rhythm CTA
- Day Complete experience
- Documentation First workflow completed for Today

**Status**

✅ Completed

---

# Planned

## Sprint 9 — Routine Management

### Goal

Strengthen in-app rhythm creation and management so daily use feels complete.

### Intent

Improve the management flows that support Today, without redesigning persistence or Schedule Engine ownership.

**Status**

📅 Ready

---

## Sprint 10 — Settings & Preferences

### Goal

Provide the preferences users need to support a calm in-app experience.

### Intent

Add settings that serve Product UI quality. Avoid expanding into platform integrations prematurely.

**Status**

📅 Planned

---

## Sprint 11 — UX Polish

### Goal

Raise overall in-app UX quality to MVP before platform expansion.

### Intent

Polish interaction, clarity, and calm presentation across the Product UI surfaces already in scope.

**Status**

📅 Planned

---

## Sprint 12 — Widget Experience

### Goal

Bring today's rhythm to the Home Screen.

### Intent

Widget implementation is intentionally postponed until Product UI reaches MVP quality.

When resumed, Widget should consume the existing Snapshot and mapping architecture rather than redefine business logic.

### Scope Direction

- Home Widget
- Timeline
- Shared Snapshot

**Status**

📅 Planned (postponed until after Product UI MVP)

---

## Sprint 13 — Apple Watch Integration

### Goal

Bring today's rhythm to Apple Watch.

### Intent

Apple Watch remains a future surface. It should reuse the finalized Product UI interpretation and existing architecture.

### Scope Direction

- Watch App
- Watch Complication
- Shared Schedule

**Status**

📅 Planned (postponed until after Product UI MVP)

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

> Does this help users stay connected with today's rhythm?

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

The Roadmap tracks product evolution and the current development status rather than implementation details.

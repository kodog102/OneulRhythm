# 🌿 ROADMAP

This roadmap tracks the evolution of OneulRhythm from a local MVP into a calm daily rhythm companion.

---

# Product Vision

OneulRhythm is not a task manager.

It is a calm companion that helps users stay connected with today's rhythm.

The long-term vision is:

```text

Today

↓

Live Activity

↓

Widget

↓

Apple Watch

↓

Ambient Computing

```

The application should require less attention over time, not more.

---

# Sprint 1 — Foundation

Status

✅ Complete

## Goals

- SwiftUI project
- MVVM
- Design System
- Today screen
- Add Routine screen
- Domain models
- Project documentation
- GitHub
- AI workflow

---



# Sprint 2 — Persistence & Smart Routine Engine

Status

✅ Complete

## Goals

- SwiftData
- Repository
- RoutineEntity
- Smart Schedule Engine
- Current rhythm
- Overdue rhythm
- Next rhythm
- Completion persistence
- Progress calculation

---



# Sprint 3 — Experience

Status

✅ Complete

## Goals

- Today experience refinement
- Korean UX
- Progress messaging
- Empty state
- Smart past-time creation
- Today / Tomorrow decision flow

---



# Sprint 4 — Notifications

Status

🚧 In Progress

## Completed

- NotificationService
- Permission Flow
- Reminder scheduling



## Remaining

- Notification cancellation on completion
- Notification cancellation on delete
- Notification rescheduling on edit

---



# Sprint 5 — Shared Snapshot & Live Activity

Status

🚧 In Progress

## Goals

- [x] TodayRhythmSnapshot
- [x] TodayViewModel Snapshot Adoption
- [ ] TodayView Snapshot Consumer
- [ ] LiveActivityCoordinator
- [ ] Lock Screen UI
- [ ] Dynamic Island
- [ ] Between Rhythms state
- [ ] Day Complete state



### Philosophy

One Live Activity represents one day.

Not one routine.

---



# Sprint 6 — Interactive Live Activity

Status

🟡 Planned

## Goals

- Interactive completion
- Deep link into current rhythm
- Live updates
- Notification cancellation integration
- Activity lifecycle optimization

---



# Sprint 7 — Widgets

Status

🟡 Planned

## Goals

- Home Screen widget
- Lock Screen widget
- Shared TodayRhythmSnapshot
- Timeline optimization

---



# Sprint 8 — Apple Watch

Status

🟡 Planned

## Goals

- Watch companion
- Complications
- Quick completion
- Shared snapshot

---



# Sprint 9 — Siri & App Intents

Status

🟡 Planned

## Goals

- Complete current rhythm
- Open today's rhythm
- Current rhythm shortcut
- Siri integration

---



# Sprint 10 — Polish

Status

🟡 Planned

## Goals

- Animation polish
- Haptics
- Accessibility
- VoiceOver
- Dynamic Type
- Localization
- Performance optimization

---



# Future



## iCloud Sync

Multiple device synchronization.

---



## Shared Routines

Family sharing.

---



## Calendar Integration

Apple Calendar.

Google Calendar.

---



## HealthKit

Read-only integrations.

---



## AI Suggestions

Rhythm recommendations.

Routine optimization.

Reflection summaries.

---



# Product Principles

Every Sprint should improve at least one of:

- Calmness
- Clarity
- Rhythm
- Accessibility
- Consistency

Never introduce features simply because they are technically possible.

---



# Current Priority

```text

TodayRhythmSnapshot

        ↓

LiveActivityCoordinator

        ↓

Lock Screen

        ↓

Dynamic Island

        ↓

Interactive Completion

        ↓

Widgets

        ↓

Apple Watch

```

---



# Success Criteria

OneulRhythm succeeds when users no longer need to repeatedly open the app.

Instead,

they naturally understand today's rhythm from wherever they are.

- Today screen
- Lock Screen
- Dynamic Island
- Widget
- Apple Watch

The experience should always feel calm, lightweight and quietly supportive.
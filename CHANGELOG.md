# 🌿 CHANGELOG

All notable changes to OneulRhythm will be documented in this file.

This project follows a Sprint-based development workflow.

The format is inspired by Keep a Changelog while remaining lightweight for iterative MVP development.

---

# Sprint 1 — Foundation

## Added

- Initial SwiftUI project

- MVVM architecture

- Design System

- Routine domain model

- Today screen

- Add Routine screen

- Navigation

- GitHub repository

- Project documentation

    - README

    - DESIGN

    - ARCHITECTURE

    - ROADMAP

    - AGENTS

- Cursor AI workflow

---

# Sprint 2 — Persistence & Smart Routine Engine

## Added

- SwiftData persistence

- RoutineEntity

- Repository pattern

- SwiftDataRoutineRepository

- Domain ↔ Entity mapping

- Smart Routine Engine

- Current routine resolution

- Overdue routine resolution

- Next routine resolution

- Today progress calculation

- Persisted completion status

## Changed

- Removed runtime mock data

- Today screen now loads persisted routines

---

# Sprint 3 — Experience

## Added

- Korean Today header

- Progress messages

- Progress count

- Improved empty state

- Smart past-time routine creation

- Today / Tomorrow selection dialog

## Changed

- Today experience refined

- Progress card hierarchy improved

- Reminder creation flow feels more natural

## Philosophy

OneulRhythm is a calm daily rhythm companion.

Users are gently guided toward tomorrow instead of being punished for selecting past times.

---

# Sprint 4 — Notifications (In Progress)

## Added

- NotificationService foundation

- NotificationScheduling protocol

- Reminder permission flow

## Changed

- Notification permission is requested only when users explicitly enable reminders.

- Notifications remain optional.

## Philosophy

Notifications are optional.

The primary experience is the Today screen and Live Activity.

Permission is requested only when users clearly understand why it is needed.

---

# Upcoming

## Sprint 4

- Notification scheduling

- Cancel on completion

- Snooze

## Sprint 5

- Live Activities

- Dynamic Island

- Lock Screen support

## Sprint 6

- WidgetKit

- Home Screen widgets

## Future

- Apple Watch

- iCloud Sync

- AI Routine Suggestions
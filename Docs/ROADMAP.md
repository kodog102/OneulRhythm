# OneulRhythm Roadmap

## Product Vision

OneulRhythm helps users stay connected with today's rhythm.

The application should minimize management and maximize presence throughout the day.

---

# Completed

## Sprint 1

Project Foundation

- SwiftUI project
- SwiftData setup
- Project structure

Status

✅ Completed

---

## Sprint 2

Routine Management

- Create Rhythm
- Edit Rhythm
- Delete Rhythm
- Repository

Status

✅ Completed

---

## Sprint 3

Today Experience

- Today Screen
- Current Rhythm
- Next Rhythm
- Progress

Status

✅ Completed

---

## Sprint 4

Persistence

- SwiftData integration
- Repository abstraction
- ViewModel integration

Status

✅ Completed

---



## Sprint 5

Schedule Engine

- RoutineScheduleEngine
- Current Rhythm
- Next Rhythm
- Progress calculation

Status

✅ Completed

---



# Sprint 6



## Sprint 6-1



### Live Activity Lifecycle

Goal

Introduce Live Activity using a stable architecture.

Completed

- Shared Activity Model
- Activity Lifecycle
- Coordinator
- Immediate Dismissal
- Widget Extension

Status

✅ Completed

---



## Sprint 6-2



### Past Rhythm Experience

Goal

Create a calm Today experience by presenting only one primary rhythm.

Completed

- Single Primary Rhythm
- Past Rhythm
- Completion Promotion
- Next Rhythm Preview
- Live Activity integration

Status

✅ Completed

---



## Sprint 6-3



### Recurring Rhythm Foundation

Goal

Users should define a rhythm once.

The application should automatically present it again according to its recurrence.

Scope

- Daily
- Weekdays
- Weekends
- No Repeat
- Daily completion state
- Schedule Engine update

Success Criteria

- No daily recreation
- Daily completion resets correctly
- Current → Past → Next flow preserved
- Live Activity continues to consume today's rhythm

Out of Scope

- Notifications
- Snooze
- Statistics
- Apple Watch
- Widgets
- Advanced recurrence

Status

🚧 Planned

---



## Sprint 6-4



### Notification Architecture

Goal

Notification becomes another consumer of today's schedule.

Notification should consume recurring rhythm occurrences.

Notification must never define recurrence itself.

Scope

- Permission
- NotificationScheduler
- NotificationPlan
- Schedule synchronization

Status

📅 Planned

---



## Sprint 6-5



### Widget Experience

Goal

Bring today's rhythm to the Home Screen.

Scope

- Home Widget
- Timeline
- Shared Snapshot

Status

📅 Planned

---



## Sprint 6-6



### Apple Watch

Goal

Bring today's rhythm to Apple Watch.

Scope

- Watch App
- Watch Complication
- Shared Schedule

Status

📅 Planned

---



# Future



## Advanced Recurrence

Examples

- Custom weekdays
- Monthly
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



## Smart Reminder

Examples

- Adaptive reminder
- Missed rhythm reminder
- Context-aware reminder

---



## Subscription

Examples

- Advanced recurrence
- Statistics
- Multiple themes
- Premium widgets
- Cloud Sync

---



# Product Principles

Every new feature should answer one question.

**Does this help users stay connected with today's rhythm?**

If the answer is no,

the feature probably does not belong in OneulRhythm.
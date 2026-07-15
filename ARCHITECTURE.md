# **🌿 ARCHITECTURE**

## **Overview**

OneulRhythm follows a layered architecture built around a single source of truth for today’s rhythm.

Business logic remains independent from SwiftUI.

Views never communicate directly with persistence, notifications or ActivityKit.

The architecture is designed so that Today, Live Activity, WidgetKit and Apple Watch can all share the same domain state.

---

# **Architecture Layers**

```text
SwiftData
        │
        ▼
SwiftDataRoutineRepository
        │
        ▼
RoutineScheduleEngine
        │
        ▼
TodayRhythmSnapshot
        │
        ├──────────────┐
        ▼              ▼
TodayView         Live Activity
        │              │
        ▼              ▼
WidgetKit      Apple Watch
```

Every presentation layer should consume the same snapshot.

No presentation layer calculates schedule state independently.

---

# **Layer Responsibilities**

## **SwiftData**

Responsible for:

- persistence
- storage
- entity lifecycle

Never:

- calculate schedule
- calculate UI state
- interact with notifications

---

## **Repository**

Responsible for:

- CRUD
- mapping
- persistence abstraction

Never:

- scheduling
- ActivityKit
- View logic

---

## **RoutineScheduleEngine**

Responsible for deriving today’s schedule.

Produces:

- current rhythm
- overdue rhythm
- next rhythm
- completed rhythm
- progress

Pure domain logic.

No SwiftUI.

No ActivityKit.

No UserNotifications.

---

## **TodayRhythmSnapshot**

This is the shared presentation model.

Purpose:

Represent today’s rhythm for every surface.

Consumers:

- TodayView
- Live Activity
- WidgetKit
- Apple Watch
- Siri / App Intents

Typical contents:

- current rhythm
- overdue rhythm
- next rhythm
- progress
- completion state
- current phase

Only this layer is shared across UI surfaces.

---

## **ViewModels**

Responsible for:

- user interaction
- orchestration
- repository calls
- schedule refresh
- snapshot generation

Never:

- persistence implementation
- ActivityKit implementation
- notification implementation

---

## **Views**

Responsible only for:

- layout
- interaction
- accessibility
- animation

Views never calculate business rules.

Views never access repositories.

Views never access ActivityKit directly.

---

# **Notification Architecture**

```text
ViewModel
        │
        ▼
NotificationScheduling
        │
        ▼
NotificationService
        │
        ▼
UNUserNotificationCenter
```

NotificationService knows:

How to send notifications.

It never decides:

- when to send
- whether reminders should exist
- product rules

Those decisions belong to ViewModels.

---

# **Live Activity Architecture**

```text
ViewModel
        │
        ▼
LiveActivityCoordinator
        │
        ▼
ActivityKit
```

The coordinator owns:

- start
- update
- end

Views never communicate with ActivityKit.

---

# **Live Activity Lifecycle**

```text
Inactive

↓

Day Session Starts

↓

Upcoming

↓

Current

↓

Between Rhythms

↓

Current

↓

Day Complete

↓

End Activity
```

Only one Live Activity represents one day.

Never create one activity per routine.

---

# **Product State**

The application recognizes these presentation states:

```text
Current

Overdue

Next

Between Rhythms

Day Complete
```

These are presentation concepts.

Persistence stores only necessary business state.

---

# **Completion Flow**

```text
Current Rhythm

↓

User completes

↓

Repository update

↓

Schedule Engine refresh

↓

Snapshot update

↓

Live Activity update

↓

Today refresh
```

Notification cancellation happens after completion.

---

# **Notification Flow**

```text
Reminder Enabled

↓

Permission Granted

↓

Routine Saved

↓

Schedule Notification
```

If scheduling fails:

Routine creation must still succeed.

Notifications are optional.

---

# **Design Principles**

Always prefer:

Single source of truth.

Pure domain logic.

Dependency injection.

Small services.

Composable ViewModels.

Shared presentation models.

---

# **Future Components**

Planned:

- LiveActivityCoordinator
- TodayRhythmSnapshot
- WidgetProvider
- AppGroupStore
- AppleWatchSync
- AppIntentsHandler

All future features should consume today’s snapshot instead of rebuilding schedule logic.

---

# **Dependency Rule**

```text
Views

↓

ViewModels

↓

Repositories

↓

SwiftData
```

Cross-cutting services:

```text
NotificationService

LiveActivityCoordinator
```

These are injected where required.

---

# **Testing Strategy**

Priority:

1. 1.

RoutineScheduleEngine

1. 2.

TodayRhythmSnapshot

1. 3.

NotificationService

1. 4.

Repository Mapping

1. 5.

ViewModels

Views should require minimal testing.

---

# **Architecture Goal**

Every surface in OneulRhythm should answer the same question:

“What is today’s current rhythm?”

No matter where users look—

Today screen,

Lock Screen,

Dynamic Island,

Widget,

or Apple Watch—

they should always see the same rhythm derived from the same snapshot.
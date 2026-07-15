# 🌿 Architectural Decisions

This document records product and architecture decisions that guide the long-term evolution of OneulRhythm.

These decisions are intentionally stable and should change only when the product philosophy changes.

---

# DR-001

## One Live Activity Represents One Day

**Status**

Accepted

### Decision

One Live Activity represents the user's entire day.

Individual routines never create their own Live Activities.

The content of a single Live Activity changes naturally as the user's day progresses.

### Rationale

This creates a calm, continuous experience and avoids Lock Screen clutter.

---



# DR-002



## Notifications Are Optional

**Status**

Accepted

### Decision

Notifications support Live Activity.

They do not drive the experience.

A reminder may be sent before a rhythm begins.

No additional notifications should be sent for:

- completion
- overdue rhythms
- repeated reminders



### Rationale

The Lock Screen should feel peaceful rather than demanding.

---



# DR-003



## Overdue Is Derived

**Status**

Accepted

### Decision

An overdue rhythm is never persisted.

Its state is always derived by `RoutineScheduleEngine`.

### Rationale

Overdue is a temporary presentation state rather than stored business data.

---



# DR-004



## Progress Represents Today's Rhythm

**Status**

Accepted

### Decision

Progress visualizes today's rhythm.

It is never treated as a productivity score.

Preferred representation:

```
2 / 5 리듬 완료
```

Avoid emphasizing percentages or performance.

### Rationale

The goal is awareness rather than evaluation.

---



# DR-005



## Past-Time Creation Requires User Choice

**Status**

Accepted

### Decision

When a user creates a rhythm whose start time has already passed today,

the application asks whether it should belong to:

- Today
- Tomorrow

The application never decides automatically.

### Rationale

The user understands today's intent better than the application.

---



# DR-006



## TodayRhythmSnapshot Is the Shared Presentation Model

**Status**

Accepted

### Decision

`TodayRhythmSnapshot` is the single presentation model shared across all user-facing surfaces.

Consumers include:

- Today View
- Live Activity
- Widget
- Apple Watch
- App Intents



### Rationale

Schedule logic remains inside `RoutineScheduleEngine`.

Presentation logic remains inside `TodayRhythmSnapshot`.

Every surface observes the same interpretation of today's rhythm.

---



# DR-007



## Live Activity Reflects the Current Rhythm

**Status**

Accepted

### Decision

Live Activity emphasizes the user's current rhythm.

It may gently preview the next rhythm when the current rhythm is approaching completion.

It intentionally avoids displaying:

- completion percentage
- remaining task count
- productivity score
- streak
- category
- urgency



### Principles

- Focus on the present.
- Gently introduce what comes next.
- Never pressure the user.



### Rationale

Live Activity is not a productivity dashboard.

It is a quiet companion for today's rhythm.

---



# DR-008



## Presentation Policy Owns Product Behavior

**Status**

Accepted

### Decision

A shared Presentation Policy determines **what** should be presented across Live Activity surfaces.

Presentation Policy owns product behavior such as:

- when the next rhythm becomes visible
- when completion becomes available
- how overdue should be presented
- when a day-complete state should end
- presentation modes shared across surfaces

Presentation Policy does **not** determine layout, typography, spacing, colors, animations, or component hierarchy.

Those remain the responsibility of each individual surface.

### Responsibilities

Presentation Policy decides:

- What should be shown
- When it should be shown
- Which semantic presentation mode is active

UI decides:

- How it looks
- How it is animated
- How it fits each surface



### Shared Consumers

The same policy should be reused by:

- Lock Screen
- Dynamic Island
- Apple Watch
- Future Widget surfaces



### Rationale

Keeping presentation behavior in one place prevents product rules from being duplicated across multiple UI implementations.

This ensures every surface behaves consistently while remaining free to present information differently.
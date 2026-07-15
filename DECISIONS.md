# 🌿 DECISIONS

This document records important architectural and product decisions made during the development of OneulRhythm.

Unlike the roadmap, this document explains **why** a decision was made.

When future discussions arise, always check this file before changing an established direction.

---

# Decision Record Format

Every decision should contain:

- Date
- Status
- Context
- Decision
- Consequences

---

# DR-001

## One Live Activity Per Day

**Date**

2026-07-15

**Status**

Accepted

### Context

We evaluated two approaches.

Option A

One Live Activity for every routine.

Option B

One Live Activity representing the entire day.

### Decision

Adopt Option B.

One Live Activity represents today's rhythm.

The content changes throughout the day as the schedule changes.

### Consequences

Advantages

- Cleaner Dynamic Island
- Better battery usage
- Simpler lifecycle
- Shared snapshot architecture
- Better Widget reuse
- Better Apple Watch reuse

Trade-offs

- Requires richer state updates.
- Requires a coordinator.

---



# DR-002



## Notifications Are Optional

**Date**

2026-07-15

**Status**

Accepted

### Context

Repeated reminders easily become noise.

The core experience should stay calm.

### Decision

Notifications are optional.

If enabled:

One reminder is delivered before a rhythm starts.

After that,

Live Activity becomes the primary experience.

### Consequences

No repeated reminders.

No completion reminders.

No overdue reminders.

Less interruption.

Better long-term usability.

---



# DR-003



## Overdue Is Derived

**Date**

2026-07-14

**Status**

Accepted

### Context

An overdue rhythm changes naturally with time.

Persisting this state would require unnecessary updates.

### Decision

Overdue is calculated by `RoutineScheduleEngine`.

It is never stored.

### Consequences

Persistence stays simple.

Business logic stays deterministic.

---



# DR-004



## Progress Represents Today's Flow

**Date**

2026-07-14

**Status**

Accepted

### Context

Many productivity apps treat progress as a score.

OneulRhythm should avoid this feeling.

### Decision

Progress is:

Completed Today

divided by

Scheduled Today

It exists only to help users understand today's rhythm.

### Consequences

No gamification.

No streak mentality.

Progress remains calm.

---



# DR-005



## Smart Past-Time Creation

**Date**

2026-07-15

**Status**

Accepted

### Context

Users often create routines after the intended time has already passed.

Automatically moving them to tomorrow feels surprising.

### Decision

Ask the user.

Options

- Register for Today
- Register for Tomorrow



### Consequences

Users stay in control.

The application remains predictable.

---



# DR-006



## TodayRhythmSnapshot Becomes the Shared Presentation Layer

**Date**

2026-07-15

**Status**

Accepted

### Context

Today screen,

Live Activity,

Widget,

Apple Watch,

and Siri all need identical schedule information.

Duplicating logic across these surfaces would increase maintenance cost.

### Decision

Introduce `TodayRhythmSnapshot`.

Every presentation surface consumes the same snapshot.

### Consequences

Single source of truth.

Simpler maintenance.

Shared UI behavior.

---



# DR-007



## Live Activity Reflects the Current Rhythm

**Date**

2026-07-15

**Status**

Accepted

### Context

Many productivity apps use Live Activities to push users toward completing more tasks by emphasizing remaining work, completion percentages, or urgency.

OneulRhythm has a different philosophy.

Its purpose is not to pressure users into being more productive, but to help them stay connected with the rhythm of their day.

### Decision

Live Activity focuses on the user's current rhythm.

When the current rhythm is close to finishing, it may gently preview the next rhythm to help users transition naturally.

Live Activity intentionally avoids displaying:

- Completion percentages
- Remaining task counts
- Productivity scores
- Streaks
- Urgent or warning-style messaging



### Principles

- Focus on the present.
- Gently introduce what comes next.
- Never pressure the user.



### Consequences

Lock Screen, Dynamic Island, Widget, Apple Watch, and future surfaces should all follow the same philosophy.

The primary purpose of Live Activity is to quietly support the user's daily flow rather than manage or evaluate it.

---



# Future Decisions

Examples

- Repeating routines
- HealthKit strategy
- iCloud Sync
- Apple Watch interactions
- Interactive Live Activity
- Widget timelines
- Calendar integration
- AI recommendations

---



# Guiding Principle

If a future discussion contradicts an accepted decision,

do not immediately change the implementation.

First,

update this document.

Architecture follows Decisions.

Code follows Architecture.
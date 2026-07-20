# OneulRhythm Design

## Vision

OneulRhythm is not a task management application.

Its purpose is not to help users remember what they have to do.

Its purpose is to help users naturally stay connected with today's rhythm.

Users define a rhythm once.

The application quietly brings that rhythm back every day.

Less Input.

More Presence.

---

# Product Philosophy

Today's rhythm is more important than today's tasks.

The application should reduce the amount of management users perform.

Instead, it should gently stay with the user throughout the day.

Technology exists to support calm experiences.

Architecture exists to support simplicity.

---



# Core Experience

The Today screen should never feel like an empty management screen.

It should always present the rhythm that matters most right now.

Priority

Current Rhythm

↓

Past Incomplete Rhythm

↓

Next Rhythm

↓

Day Complete

Only one primary rhythm should be presented at any time.

Showing fewer things creates more focus.

---



# Calm UX

OneulRhythm should feel calm.

Never busy.

Avoid long lists.

Avoid information overload.

Avoid multiple competing actions.

The user should always understand what deserves attention right now.

---



# Recurring Rhythm

Rhythms represent ongoing habits.

Users should not recreate the same rhythm every day.

Instead, a rhythm defines how it repeats.

MVP recurrence options

- Daily
- Weekdays
- Weekends
- No Repeat

Advanced recurrence rules are intentionally postponed.

Examples

Future versions may support

- Custom weekdays
- Monthly recurrence
- Interval recurrence
- End dates
- Exception dates

---



# Design Principles



## Reduce Input

Whenever possible, prefer reducing user input over adding configuration.

Simple choices should solve the majority of daily use cases.

---



## Progressive Complexity

Advanced customization should appear only when users genuinely need it.

The first experience should always remain simple.

---



## One Primary Focus

Only one rhythm deserves primary attention.

Users should never have to decide which card matters most.

The application makes that decision.

---



## Consistency

Every consumer should present the same rhythm.

Consumers include

- Today Screen
- Live Activity
- Notifications
- Widgets
- Apple Watch

They all consume the same schedule.

They never implement their own scheduling logic.

---



## Day Completion

Completing every rhythm should create a peaceful ending.

When the final rhythm is completed

- Today displays Day Complete.
- Live Activity ends immediately.
- The next valid rhythm appears on the next applicable day.

---



## Future Expansion

Future features should extend the experience without changing the product philosophy.

Examples

- Notifications
- Widgets
- Apple Watch
- Statistics
- Subscription Features

Every new feature should answer one question.

Does this help users stay connected with today's rhythm?

If not,

it probably does not belong in OneulRhythm.
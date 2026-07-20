# DR-011 — Separate Rhythm Definition from Daily Completion State

## Status

Accepted

---

## Context

Early versions of OneulRhythm stored completion directly on the rhythm itself.

This approach worked for one-time rhythms but became problematic once recurring rhythms were introduced.

A recurring rhythm represents a long-term lifestyle pattern.

Completion, however, belongs to a specific day.

Treating them as the same concept causes unnecessary complexity and makes recurrence difficult to support.

---

## Decision

Separate rhythm definition from daily completion state.

A rhythm represents what should happen.

Completion represents what happened today.

Rhythm Definition

- Title
- Time
- Category
- Recurrence
- Reminder
- Active

Daily Completion

- Rhythm Identifier
- Date
- Completed At

The application derives today's experience by combining both datasets.

---

## MVP Recurrence

The initial release intentionally limits recurrence options.

Supported

- Daily
- Weekdays
- Weekends
- No Repeat

Not Supported

- Custom weekdays
- Monthly recurrence
- Interval recurrence
- End dates
- Exception dates
- Holiday rules

The goal is to minimize user input while supporting the majority of daily use cases.

---

## Rationale

Most users repeatedly perform the same rhythms.

Recreating those rhythms every day introduces unnecessary friction.

The application should remember the rhythm so the user does not have to.

Less Input.

More Presence.

---

## Consequences

### Benefits

- Recurring rhythms become natural.
- Daily completion automatically resets.
- Schedule Engine remains deterministic.
- Live Activity consumes today's occurrence without additional logic.
- Notification scheduling becomes significantly simpler.
- Future recurrence patterns can be added without redesigning the architecture.

### Trade-offs

- Existing persistence requires migration.
- Completion is no longer stored directly on the rhythm.
- The Schedule Engine becomes responsible for composing today's state.

---

## Related Decisions

- DR-009 — Day Complete Lifecycle
- DR-010 — Single Primary Rhythm
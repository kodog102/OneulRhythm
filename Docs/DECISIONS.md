# # Decision Records

This document records architectural and product decisions that intentionally shape the long-term direction of OneulRhythm.

---

# DR-010 — Single Primary Rhythm Presentation

Status

Accepted

Sprint

Sprint 6-2

---

## Context

As routines progress throughout the day, users may have:

- a current routine

- one or more past incomplete routines

- future routines

Displaying multiple unfinished routines at once created a backlog-like experience that conflicted with OneulRhythm's calm, timeline-first philosophy.

The product should always encourage the next meaningful action without overwhelming the user.

---

## Decision

Today presents exactly one primary rhythm.

Presentation priority is fixed:

1. Current Rhythm

2. Past Incomplete Rhythm

3. Next Rhythm

4. Day Complete / Empty

Only one primary routine card is displayed.

Past incomplete routines are surfaced one at a time.

Future routines may appear only as lightweight preview information beneath the current primary rhythm.

---

## Architecture

Schedule interpretation remains the responsibility of:

- RoutineScheduleEngine

TodayRhythmSnapshot exposes schedule facts only.

Presentation composition belongs to:

- TodayViewModel

TodayView never performs:

- schedule interpretation

- sorting

- filtering

- priority selection

---

## Consequences

Benefits

- Single focus throughout the day.

- Calm experience without backlog pressure.

- Consistent presentation across TodayView and Live Activity.

- Clear separation between schedule logic and presentation logic.

Trade-offs

- Only one past incomplete routine is visible at a time.

- Users cannot review every unfinished routine directly from TodayView.

- Additional history or list-based views, if introduced in the future, should remain secondary experiences.

---

## Alternatives Considered

### Add new RoutineStatus values

Rejected.

Past incomplete is derived from time and completion state.

Persisting this information would duplicate schedule logic.

---

### Multiple primary cards

Rejected.

Multiple prominent cards compete for attention and violate the product philosophy.

---

### Presentation priority inside TodayView

Rejected.

Presentation logic belongs in TodayViewModel.

TodayView should remain a passive rendering layer.

---

## Related Decisions

- DR-009 — Immediate Day Complete Live Activity dismissal.

- DR-008 — One logical Live Activity per day.
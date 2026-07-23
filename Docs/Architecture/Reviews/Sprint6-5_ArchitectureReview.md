# Sprint 6-5 Architecture Review

## Goal

Refine the Today experience to focus on a single primary rhythm.

At any given moment, TodayView should present only the one rhythm that deserves the user's attention, reducing cognitive load and reinforcing the calm interaction model.

---

## Scope

This Sprint introduces a Primary Rhythm selection within the Today snapshot.

The scheduling logic remains unchanged.

The Schedule Engine continues to calculate routine state, while the Snapshot determines which routine should be presented to the UI.

---

## Architecture Decisions

### Primary Rhythm

The primary rhythm is selected using the following priority:

1. Current
2. Past Incomplete
3. Next

Only one routine may become the Primary Rhythm.

---

### Responsibility

Schedule Engine

- Calculates routine state
- Calculates current routine
- Calculates next routine
- Calculates past incomplete routines

Today Snapshot

- Determines Primary Rhythm
- Determines Primary Role
- Exposes presentation-ready state to the UI

TodayView

- Renders only the Primary Rhythm
- Does not perform business logic

---

## Constraints

### Do

- Keep Schedule Engine unchanged
- Keep Repository unchanged
- Keep SwiftData model unchanged
- Keep Activity lifecycle unchanged
- Select Primary Rhythm inside the Snapshot

### Don't

- Add new routine status
- Introduce data migration
- Refactor unrelated architecture
- Add UI selection logic inside TodayView
- Change persistence behavior

---

## Expected File Changes

Expected implementation should primarily affect:

- TodayRhythmSnapshot
- TodayViewModel
- TodayView
- TodayRhythmActivityMapper
- Preview (if needed)

No changes are expected in:

- RoutineEntity
- Repository
- Schedule Engine
- Activity Coordinator

---

## Definition of Done

The Sprint is complete when:

- Only one Primary Rhythm is displayed.
- Past incomplete routines replace Current only when Current does not exist.
- Next routine appears only when neither Current nor Past exists.
- TodayView contains no business decision logic.
- Live Activity follows the same priority rule.
- Existing behavior outside this scope remains unchanged.
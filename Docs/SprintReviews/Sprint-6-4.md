# Sprint 6-4 — Recurring Rhythm Product Integration

## Goal

Allow users to define a rhythm once and have the application automatically present today's occurrence, without changing the existing Today experience or Live Activity pipeline.

## Completed

- Recurring Rhythm product support
- Daily, Weekdays, and Weekends recurrence rules
- `RecurringRhythmEntity` persistence for recurring definitions
- Automatic daily occurrence provisioning from active definitions
- Foreground synchronization of today's occurrences
- Schedule Engine integration for provisioned daily rhythms
- Unit test foundation and recurrence coverage
- Runtime QA completed successfully

## Architecture Decisions

- Recurrence generates daily rhythms before Schedule Engine resolution; the engine continues to resolve only daily rhythms.
- `RecurringRhythmEntity` stores reusable definitions; materialized day rows remain ordinary routines.
- Supported rules are Daily, Weekdays, and Weekends only. One-time rhythms are represented by the absence of a recurrence rule (no `.none` case).
- Day identity and weekend classification are centralized through `CalendarDayPolicy`.
- Existing Today Snapshot and Live Activity consumers continue to read today's resolved schedule without recurrence awareness.

## QA Summary

- Build PASS
- Unit Tests PASS (102)
- Runtime QA PASS
- Live Activity PASS

## Lessons Learned

- Establishing the unit test target early made recurrence rules, provisioning, and persistence safer to evolve.
- Keeping recurrence outside the Schedule Engine preserved the Single Primary Rhythm and Live Activity contracts.
- Representing one-time rhythms by absence of recurrence avoided ambiguous rule states.
- Foreground synchronization is required so provisioned occurrences stay aligned with the calendar day the user is actually viewing.

## Next Sprint

Sprint 6-5 — Notification Architecture

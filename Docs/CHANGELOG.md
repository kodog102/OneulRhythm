# Changelog

All notable changes to OneulRhythm are documented here.

The project follows an incremental sprint-based development process.

---

# Sprint 6-2 — Past Rhythm Experience

## Summary

Completed the Past Rhythm Experience by introducing a single-primary presentation model while preserving the existing schedule architecture.

The Today screen now guides users naturally through today's rhythm without presenting a backlog of unfinished routines.

---

## Added

- Past Incomplete Rhythm presentation.
- Lightweight Next Rhythm preview beneath the primary rhythm.
- Gentle primary-routine promotion animation after completion.
- Visual connection between the current rhythm and the upcoming rhythm using a subtle accent indicator.
- Korean-localized time formatting within the Today screen.

---

## Changed

- Introduced presentation priority:

  1. Current Rhythm
  2. Past Incomplete Rhythm
  3. Next Rhythm

- Removed backlog-style presentation of multiple past incomplete routines.
- Only one primary routine card is shown at any time.
- Past incomplete routines now appear one at a time.
- Updated preview terminology from "Overdue" to "Past Incomplete".
- Primary past-incomplete cards now share the same visual emphasis as other primary cards.
- Next Rhythm is now presented as a lightweight preview instead of a competing card.

---

## Architecture

No architectural changes.

The following components remain unchanged:

- RoutineScheduleEngine
- Repository
- RoutineStatus
- LiveActivityCoordinator
- Activity lifecycle
- Widget architecture

Presentation composition is handled by TodayViewModel while TodayRhythmSnapshot continues to expose schedule facts only.

---

## Verification

Completed:

- Architecture Review
- Implementation Review
- QA Review
- QA Fix
- QA Re-check
- Manual Simulator Verification
- Visual QA

Verified scenarios:

- Current Rhythm priority
- Past Incomplete priority
- Next Rhythm priority
- Completion promotion
- Multiple past routines
- Day Complete
- Live Activity immediate dismissal
- Relaunch persistence

---

## Known Issues

- Live Activity currently displays times using the system default format (e.g. `4:02 PM`) instead of the Korean presentation used by TodayView (`오후 4:02`).
- This is a UX consistency issue only and has been deferred to a future sprint.

---

# Sprint 6-1 — Live Activity Lifecycle

## Summary

Completed the production Live Activity architecture.

The project now supports a single logical Live Activity for each day using ActivityKit and WidgetKit.

---

## Added

- Widget Extension.
- Shared ActivityKit models.
- Shared presentation policy.
- Live Activity coordinator.
- Activity reconciliation.
- Immediate day-complete dismissal.
- Empty snapshot cleanup.
- Canonical one-activity-per-day lifecycle.

---

## Changed

- Removed delayed day-complete dismissal.
- Removed Activity linger behavior.
- Shared Activity definitions between app and widget.
- Improved lifecycle reconciliation.

---

## Verification

Completed:

- Architecture Review
- Implementation Review
- QA Review
- Manual Simulator Verification

Verified:

- Single Activity per day
- Immediate dismissal
- Duplicate cleanup
- Previous-day cleanup
- Empty snapshot cleanup
- Widget rendering

---

# Previous Sprints

Earlier sprint changes focused on establishing the project's foundation, including:

- SwiftData persistence
- Repository abstraction
- Today screen
- Schedule Engine
- Live Activity integration
- Widget infrastructure
- Preview infrastructure
- Documentation
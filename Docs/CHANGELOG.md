# Changelog

All notable changes to OneulRhythm are documented here.

This document records completed work only.

For future plans, see `ROADMAP.md`.

---

# Sprint 9-2 — Management Model Alignment

**Date:** 2026-07-25

## Changed

### Definition-Based Management

- Routine Management now lists configured rhythms, not historical occurrence rows.
- Recurring rhythms appear once per active recurring definition (`RecurringRhythm.id`).
- One-time rhythms appear only when their calendar day is today or later (`Routine.id`).
- Historical recurring occurrences remain persisted but are excluded from Management.
- Past one-time routines remain persisted but are excluded from Management.
- Deactivated recurring definitions are excluded from Management (`fetchActive()`).

### Recurring Deletion Policy

- Recurring Management delete deactivates the definition.
- Past occurrences are preserved (completed and incomplete).
- Today completed occurrences are preserved.
- Today incomplete and future occurrences are removed.
- One-time delete still removes only that routine row.
- Inactive definitions no longer generate new occurrences through daily provisioning.

## Notes

Today, Schedule Engine, Snapshot, and Live Activity architecture remain unchanged.

Regression and final state verification confirmed that deleted today-incomplete rhythms leave Today / Live Activity correctly, and that preserved historical occurrences do not re-enter the current day experience.

### Verification

- Architecture Review: PASS
- Implementation Review: PASS
- QA Review: PASS
- Regression Review: PASS
- Manual UI QA: PASS
- Final State Verification: PASS WITH NOTES (resolved by this Documentation Pass)
- Full Test Suite: 143 tests, 0 failures
- Build: SUCCEEDED

---

# Sprint 9-1 — Routine Management MVP

**Date:** 2026-07-25

## Added

### Routine Management

- Added a dedicated Routine Management screen as the home of Routine CRUD.
- Added secondary Today navigation (`관리`) that opens Management without changing Today's single-focus layout.
- Restored ongoing Create from Management while preserving Empty-only Today onboarding.
- Implemented Edit by reusing `AddRoutineView` in create/edit mode (no `EditRoutineView`).
- Implemented Delete with swipe confirmation, repository deletion, and Today/Management refresh.

## Notes

Schedule Engine, Snapshot ownership, and Live Activity architecture remain unchanged.

Repository gained field `update` / `delete(id:)` helpers and recurring definition `update` to support Management persistence without redesigning the Repository boundary.

---

# Sprint 8 — Today Product Experience

**Date:** 2026-07-24

## Added

### Today Experience

- Redesigned Today as a calm, single-focus experience.
- Introduced the Single Primary Rhythm presentation.
- Improved information hierarchy and spacing so Primary Rhythm remains the emotional center.

### Empty State

- Redesigned Empty as an open invitation to begin.
- Added Empty Guidance with approved Product copy.
- Added Create Rhythm CTA visible only when Today has zero routines.
- Reused the existing routine creation flow for first-time onboarding.
- Eliminated the Empty-state onboarding dead-end discovered during Manual QA.

### Day Complete

- Added a dedicated Day Complete presentation.
- Introduced the approved completion message.
- Preserved quiet completion without celebration or additional actions.

### Product Documentation

- Completed the implementation-ready Product documentation for Today:
  - `Today-Experience.md`
  - `Today-Wireframe-Exploration.md`
  - `Today-UI-Specification.md`

## Notes

Manual Visual QA validated Empty, Upcoming, Current, Past Incomplete, and Day Complete.

Product documentation was refined from QA findings before the Empty Create Rhythm CTA was finalized.

Final implementation matches the approved Product Contract.

See `Docs/SprintReviews/Sprint-8.md` for the Sprint Review.

---

# Sprint 7 — Notification System (T3)

**Date:** 2026-07-24

## Added

### Notification Synchronization

- Introduced `NotificationSynchronization` as the pure minimal-diff reconciler between `NotificationPlan` and pending requests.
- Extended `NotificationScheduling` with `synchronize(with:)` to apply remove/schedule operations.
- Update semantics are expressed as remove + schedule for the same identifier.
- Unit tests cover empty pending, already synchronized, trigger update, removal, addition, and mixed synchronization.

## Notes

`NotificationPlan` remains desired state only.

`NotificationMapper` and `NotificationTriggerPolicy` responsibilities are unchanged.

`NotificationService` remains the Apple UserNotifications boundary.

One-time create continues to schedule plan items after save. App lifecycle / background sync invocation remain out of scope for T3.

Recurring reminder scheduling remains persist-only.

---

# Sprint 7 — Notification System (T2)

**Date:** 2026-07-24

## Added

### Notification Plan

- Introduced `NotificationPlan` and `NotificationPlanItem` as pure desired-state models.
- Introduced `NotificationMapper` to transform domain rhythms into a deterministic notification plan.
- Promoted `reminderMinutes` onto domain `Routine` and mapped it through `RoutineEntity`.
- One-time create flow now schedules through `Routine → NotificationMapper → NotificationPlan → NotificationScheduling`.

## Notes

Permission UX and `NotificationService` isolation are unchanged.

Recurring reminder scheduling remains persist-only and out of scope for T2.

Schedule synchronization remains a later Sprint 7 slice.

---

# Sprint 7 — Notification System (T1)

**Date:** 2026-07-23

## Added

### Notification Trigger Policy

- Introduced `NotificationTriggerPolicy` as the single source of truth for reminder trigger-date calculation.
- One-time create flow in `AddRoutineView` now schedules via the policy instead of inline date arithmetic.
- Unit tests cover missing offset, future, exact-now, past, and near-boundary cases.

## Notes

Permission flow and `NotificationScheduling` isolation are unchanged.

Recurring reminder scheduling remains persist-only and out of scope for T1.

Developer verification completed successfully.

---

# Sprint 6-5 — Primary Rhythm Ownership

**Date:** 2026-07-23

## Changed

### Today Snapshot

- Moved Primary Rhythm selection into `TodayRhythmSnapshot`.
- Established presentation priority: Current → Past Incomplete → Next.
- TodayViewModel now forwards snapshot-owned primary state instead of selecting focus.
- TodayView renders only the Primary Rhythm without selection logic.
- Live Activity mapper consumes snapshot `primaryRole` for focus.

## Notes

Schedule Engine, Repository, SwiftData models, and Activity lifecycle remain unchanged.

See `Docs/Architecture/Reviews/Sprint6-5_ArchitectureReview.md` and `Docs/SprintReviews/Sprint-6-5.md`.

---

# Sprint 6-4 — Recurring Rhythm

**Date:** 2026-07-22

## Added

### Recurring Rhythm

- Added Recurring Rhythm support.
- Added Daily, Weekdays, and Weekends recurrence rules.
- Introduced `RecurringRhythmEntity` as the persisted recurring definition.
- Added automatic daily occurrence provisioning from active recurring definitions.
- Added foreground synchronization so today's occurrences stay aligned when the app becomes active.

### Quality

- Runtime QA completed successfully.
- Unit test suite validated at 102 passing tests.

## Notes

Recurring definitions generate daily rhythms before Schedule Engine resolution.

One-time rhythms remain represented by the absence of a recurrence rule.

See `Docs/SprintReviews/Sprint-6-4.md` for the Sprint Review.

---

# Development Workflow Documentation

**Date:** 2026-07-22

## Added

### Development

- Added `Docs/Development/DEVELOPMENT_WORKFLOW.md` as the official Sprint workflow.
- Added `Docs/Development/PROMPT_LIBRARY.md`.
- Added `Docs/Development/CURSOR_GUIDELINES.md`.
- Added `Docs/Development/SPRINT_CHECKLIST.md`.

## Changed

### Development

- Superseded `Docs/DEVELOPMENT-PLAYBOOK.md` in favor of the official Development Workflow.
- Aligned `Docs/AI/AGENTS.md` process sections with ChatGPT / Cursor / Developer roles.
- Linked Development documentation from `Docs/README.md`.

## Notes

Sprint process is now defined under `Docs/Development/`.

Product philosophy and architecture rules remain in `Docs/AI/AGENTS.md`.

---

# Sprint 6-3 — Documentation Architecture

**Date:** 2026-07-20

## Added

### Architecture

- Added Architecture documentation.
- Added Product Principles.
- Established the official project architecture.

### Decision Records

- Introduced the Decision Record (DR) system.
- Added DR-001 through DR-011.

### Design

- Added Design documentation structure.
- Added Mapper design specification.
- Added Scheduling design specification.
- Added Persistence design specification.
- Added Presentation design specification.
- Added Live Activity design specification.

### Extensions

- Introduced the Extensions documentation.
- Added Recurring Rhythm extension design.

### Documentation

- Added project Glossary.
- Added documentation hierarchy.
- Added documentation standards.
- Defined documentation responsibilities.
- Standardized project terminology.

---

## Changed

### Architecture

- Promoted Mapping to an official architectural layer.
- Standardized `ResolvedSchedule` as the business output.
- Clarified Coordinator responsibilities.
- Separated Mapping from Business logic.

### Documentation

- Separated Architecture, Decisions, Design, and Extensions into independent documentation layers.
- Clarified the relationship between project documentation.
- Refined project terminology for consistency.

---

## Notes

The project documentation architecture from Sprint 6-3 remains the product and design documentation foundation.

Sprint process documentation was later established under `Docs/Development/` (see Development Workflow Documentation above).

---

# Sprint 6-2 — Single Primary Rhythm

## Added

- Introduced the Single Primary Rhythm experience.
- Added Past Rhythm presentation.
- Added Completion Promotion.
- Added Next Rhythm Preview.

## Changed

- Simplified Today experience to present only one primary rhythm.
- Updated Live Activity to consume the primary rhythm.

---

# Sprint 6-1 — Live Activity Lifecycle

## Added

- Shared Activity model.
- Activity Coordinator.
- Widget Extension.
- Live Activity lifecycle management.

## Changed

- Adopted Immediate Day Complete.
- Stabilized Activity lifecycle behavior.

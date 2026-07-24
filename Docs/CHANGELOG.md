# Changelog

All notable changes to OneulRhythm are documented here.

This document records completed work only.

For future plans, see `ROADMAP.md`.

---

# Planning — Product UI First Strategy

Date

2026-07-24

## Changed

### Roadmap Direction

- Adopted Product UI First as the current development priority after Notification Foundation stability.
- Reordered upcoming Sprints so Today Product Experience, Routine Management, Settings & Preferences, and UX Polish precede Widget Experience and Apple Watch Integration.
- Documented that Widget and Apple Watch remain planned surfaces but are intentionally postponed until in-app MVP quality is reached.
- Recorded the strategic decision in `DR-014-product-ui-first.md`.

## Notes

This is a planning and documentation update only.

No application architecture, Notification pipeline, Snapshot, or production code was changed.

---

# Sprint 7 — Notification System (T3)

Date

2026-07-24

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

Date

2026-07-24

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

Date

2026-07-23

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

Date

2026-07-23

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

Date

2026-07-22

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

Date

2026-07-22

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

Date

2026-07-20

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

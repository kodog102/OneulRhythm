# Changelog

All notable changes to OneulRhythm are documented here.

This document records completed work only.

For future plans, see `ROADMAP.md`.

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
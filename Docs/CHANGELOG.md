# Changelog

All notable changes to OneulRhythm are documented here.

This document records completed work only.

For future plans, see `ROADMAP.md`.

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

The project documentation is now considered stable.

Future architectural changes should follow this workflow:

1. Update the relevant Decision Record.
2. Update the Design documentation if necessary.
3. Implement the change.
4. Record the completed work in this Changelog.

Implementation continues with **Sprint 6-4 — Recurring Rhythm**.

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
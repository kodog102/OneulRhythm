# Changelog

All notable changes to OneulRhythm are documented in this file.

The format loosely follows Keep a Changelog and documents meaningful user-facing or architectural changes.

---

# Unreleased

## Added

### Live Activity

- Introduced ActivityKit-based Live Activity support.
- Added Widget Extension for Live Activity rendering.
- Introduced shared ActivityKit models through `OneulRhythmShared`.
- Added shared presentation policies for consistent Activity rendering.

### Architecture

- Introduced `LiveActivityCoordinator` as the single synchronization layer between schedule snapshots and ActivityKit.
- Centralized Activity reconciliation and cleanup.
- Shared Activity definitions across the app target and widget extension.

---

## Changed

### Day Completion

- Live Activities now end immediately when all routines for the current day are completed.
- Removed delayed dismissal behavior.
- TodayView remains the primary completion experience.

### Activity Lifecycle

- Enforced one logical Live Activity per calendar day.
- Canonical activity selection now uses:
  1. Latest `updatedAt`
  2. Lexicographically smallest identifier

- Cleanup operations now target only eligible runtime activities.

### Synchronization

- Live Activity synchronization remains best-effort.
- Application state continues to be the single source of truth.
- Serialization continues through the FIFO task chain.

---

## Removed

- Three-minute day-complete lingering behavior.
- Delayed dismissal scheduling using `.after(...)`.
- Internal waiting logic based on `Task.sleep`.
- Re-ending previously ended activities.

---

# Sprint History

## Sprint 6-1

### Completed

- Widget Extension
- Shared Activity definitions
- Live Activity runtime architecture
- Immediate day-complete dismissal
- Canonical reconciliation
- Duplicate cleanup
- Previous-day cleanup
- Eligible activity cleanup
- Snapshot-driven synchronization

---

## Previous Sprints

### Sprint 5

- Routine repository
- Schedule Engine
- TodayViewModel integration
- Progress calculation
- Routine completion persistence

### Sprint 4

- SwiftData integration
- Repository abstraction
- Today screen implementation

### Sprint 3

- Routine creation flow
- Add Routine UI
- Routine entity mapping

### Sprint 2

- Project structure
- MVVM foundation

### Sprint 1

- Initial application setup
- SwiftUI
- SwiftData project configuration
# 🌿 CHANGELOG

All notable changes to OneulRhythm are documented in this file.

This project follows a milestone-based changelog rather than strict semantic versioning.

---

# Unreleased

## Planned

### Live Activity

- Introduce `TodayRhythmSnapshot`
- Add `LiveActivityCoordinator`
- Lock Screen UI
- Dynamic Island UI
- Interactive completion
- Shared snapshot architecture

### Notifications

- Cancel notification on completion
- Cancel notification on delete
- Reschedule notification on edit

---

# 2026-07-15

## Sprint 4 — Notification Foundation

### Added

- Introduced `NotificationScheduling` protocol.
- Added `NotificationService`.
- Local notification authorization support.
- One-shot calendar notification scheduling.
- Pending notification inspection.
- Notification cancellation API.



### Added

Reminder permission flow.

- Permission requested only when Reminder is enabled.
- No permission request at app launch.
- Calm Settings guidance after denial.
- Reminder remains optional.



### Added

Notification scheduling after routine creation.

Rules:

- Reminder enabled
- Permission granted
- Reminder time is still in the future

Routine creation always succeeds even if scheduling fails.

### Product Decision

Notifications are optional.

Live Activity will become the primary experience.

Notifications exist only to gently invite users into today's rhythm.

---



# 2026-07-14



## Sprint 3 — Experience



### Added

Today experience improvements.

- Current rhythm
- Overdue rhythm
- Next rhythm
- Progress messaging
- Empty state
- Korean date formatting



### Added

Smart past-time routine creation.

If the selected time has already passed:

- Register for Today
- or
- Register for Tomorrow

The user decides.

### Changed

Progress card messaging.

Progress now feels calmer and more supportive.

---



# 2026


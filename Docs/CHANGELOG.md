# Sprint 6-3 Planning

Date

2026-07-20

---

## Product Direction

Changed the roadmap before implementation.

Recurring Rhythm Foundation will be implemented before Notification Architecture.

---

## Why

Real-world usage revealed that manually creating the same rhythm every day introduced unnecessary friction.

However, having a rhythm always visible throughout the day created a calm and reassuring experience.

The product should preserve that experience while reducing daily input.

---

## Product Decisions

- Introduced recurring rhythms.
- Added four MVP recurrence options.
    - Daily
    - Weekdays
    - Weekends
    - No Repeat
- Separated Rhythm Definition from Daily Completion State.
- Notification will consume recurring rhythm occurrences instead of defining recurrence.
- Advanced recurrence has been postponed.

---

## Product Philosophy

Users should not recreate the same rhythm every day.

The application should remember recurring rhythms for them.

Less Input.

More Presence.

---

## Architecture Impact

Recurring rhythm becomes a foundational capability.

All future consumers share the same schedule.

Consumers include

- Today Screen
- Live Activity
- Notifications
- Widgets
- Apple Watch

Scheduling logic continues to exist only inside the Schedule Engine.

---

## Next Sprint

Sprint 6-3

Recurring Rhythm Foundation
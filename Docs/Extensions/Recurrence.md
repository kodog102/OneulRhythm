# Recurrence

Recurring rhythms allow users to define reusable rhythm templates that automatically generate daily rhythms.

Recurrence extends the Scheduling subsystem without changing its business interpretation.

The Schedule Engine always resolves daily rhythms.

It never resolves recurrence definitions directly.

---

# Purpose

The Recurrence subsystem exists to:

- Define reusable rhythm schedules.
- Generate daily rhythms.
- Eliminate repetitive user input.
- Preserve deterministic scheduling.
- Keep Scheduling independent from recurrence rules.

---

# Responsibilities

Recurrence is responsible for:

- Defining recurrence patterns.
- Determining whether a rhythm occurs on a given day.
- Generating daily rhythms.
- Producing domain models consumable by Scheduling.

---

# Non-Responsibilities

Recurrence is **not** responsible for:

- Schedule resolution.
- Business interpretation.
- Presentation.
- Activity updates.
- Notifications.

Those responsibilities remain unchanged.

---

# Architecture

```
Recurring Rhythm
        │
        ▼
Recurrence Engine
        │
        ▼
Daily Rhythms
        │
        ▼
Repository
        │
        ▼
Schedule Engine
```

Recurrence completes before Scheduling begins.

Scheduling remains unaware of recurrence definitions.

---

# Business Flow

```
Recurring Definitions
          │
          ▼
Recurrence Evaluation
          │
          ▼
Daily Rhythm Generation
          │
          ▼
Repository
          │
          ▼
Schedule Engine
```

The Schedule Engine receives only daily rhythms.

---

# Recurrence Principles

## Daily First

Scheduling always works with daily rhythms.

Recurring definitions never enter the Scheduling subsystem.

---

## Deterministic

The same recurrence definition and date always produce the same daily rhythms.

---

## Stateless

Generated rhythms are derived from recurrence definitions.

No presentation state participates in generation.

---

## Independent

Recurrence does not modify Scheduling.

It only supplies daily rhythm data.

---

# Supported Concepts

Examples of recurrence patterns include:

- Every day
- Weekdays
- Weekends
- Specific weekdays
- Monthly
- Custom intervals

These patterns remain implementation details.

Scheduling consumes only the generated daily rhythms.

---

# Exception Strategy

Future recurrence enhancements may include:

- Skipped occurrences.
- Holiday exclusions.
- Temporary pauses.
- One-time overrides.

These behaviors should modify daily rhythm generation rather than Scheduling itself.

---

# Extension Strategy

Future integrations such as Calendar or Cloud Sync should contribute recurrence definitions through the same generation process.

```
Calendar
      │
Cloud
      │
Manual Input
      │
      ▼
Recurrence Engine
      │
      ▼
Daily Rhythms
```

The downstream business pipeline remains unchanged.

---

# Design Notes

Recurrence is an architectural extension rather than a replacement for Scheduling.

Its sole purpose is to generate daily rhythms.

Business interpretation remains centralized inside the Schedule Engine.

---

# Related Decisions

- DR-004 — Schedule Engine
- DR-007 — Schedule Resolution
- DR-011 — Recurring Rhythm Foundation

---

# Related Documents

- Docs/Extensions/README.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Design/Scheduling.md
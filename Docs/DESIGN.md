# Design

This document describes the user-facing behavior and runtime design of OneulRhythm.

Implementation details are documented elsewhere.
This document focuses on how the application behaves.

---

# Overview

OneulRhythm is designed around a single concept:

> Show only what matters right now.

Instead of presenting every routine equally, the application emphasizes the user's current rhythm while keeping future tasks visible and completed tasks unobtrusive.

The experience is intentionally calm, lightweight, and timeline-driven.

---

# Design Principles

The application follows several core principles.

## One current focus

Only one routine is considered the current rhythm.

The interface avoids presenting multiple competing primary actions.

---

## Timeline first

The schedule itself determines what is shown.

Views do not interpret time independently.

---

## Calm completion

Completing a routine should feel peaceful rather than celebratory.

Completion is reflected immediately inside TodayView.

The Live Activity disappears once its purpose has finished.

---

## Progressive disclosure

Information appears only when relevant.

Examples include:

- Current routine
- Upcoming routine
- Daily progress
- Empty state

Past information never competes with current work.

---

# Daily Routine Lifecycle

A routine progresses through the following logical states.

```

Upcoming

↓

Current

↓

Completed

```

The Schedule Engine determines these states from the current time and stored completion status.

---

# Schedule Engine

RoutineScheduleEngine is responsible for producing a schedule snapshot.

Each snapshot contains:

- today's routines
- current routine
- next routine
- completed routines
- progress information

The engine acts as the single source of truth for routine timing.

Views never calculate schedule state themselves.

---

# Today Screen

The Today screen displays the current schedule snapshot.

Its responsibilities include:

- current routine
- upcoming routine
- daily progress
- empty state
- routine completion

Completing a routine updates the underlying data and requests a new schedule snapshot.

---

# Live Activity

The Live Activity mirrors the current schedule.

Its purpose is to provide glanceable information outside the application.

The coordinator automatically keeps the Activity synchronized with the latest schedule snapshot.

Only one logical Live Activity exists for each day.

---

## Day completion

When all routines are completed:

- TodayView continues showing the completed day
- Live Activity ends immediately
- No delayed dismissal is scheduled

The completion experience belongs to the application rather than the Lock Screen.

---

# Widget Extension

The widget extension renders ActivityKit content using shared models.

Shared Activity definitions ensure:

- identical state interpretation
- consistent presentation
- independent rendering process

The extension never owns scheduling logic.

---

# State Flow

```

SwiftData

↓

Repository

↓

Schedule Engine

↓

Schedule Snapshot

↓

TodayView

↓

Live Activity Coordinator

↓

Widget Extension

```

Every presentation surface is derived from the same schedule snapshot.

---

# Future Evolution

Planned future improvements include:

- Snooze support
- Interactive widgets
- Apple Watch integration
- Notification scheduling
- Rich Dynamic Island layouts

These features will extend the existing snapshot architecture rather than introducing parallel scheduling systems.
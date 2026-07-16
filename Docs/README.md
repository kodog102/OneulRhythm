# OneulRhythm

OneulRhythm is a calm, timeline-driven routine application for iPhone.

Rather than overwhelming users with long task lists, the app focuses on the single rhythm that matters right now.

The project is built with modern Apple technologies and serves as an exploration of snapshot-driven architecture, SwiftUI, SwiftData, WidgetKit, and ActivityKit.

---

# Philosophy

OneulRhythm follows a simple principle:

> Focus on the present rhythm.

The application intentionally minimizes distractions by presenting:

- the current routine
- the next routine
- daily progress

Everything else stays out of the way.

---

# Current Features

## Routine Management

- Create routines
- Daily schedule
- Current routine
- Upcoming routine
- Routine completion
- Daily progress

---

## Schedule Engine

- Timeline-based scheduling
- Snapshot generation
- Current/Upcoming calculation
- Completed routine tracking

---

## Live Activity

- Lock Screen support
- Dynamic Island support
- Snapshot-driven synchronization
- One logical Activity per day
- Immediate dismissal when the day completes

---

# Technology

## UI

- SwiftUI

## Persistence

- SwiftData

## Architecture

- MVVM
- Repository Pattern
- Snapshot-driven scheduling

## Apple Frameworks

- WidgetKit
- ActivityKit

---

# Project Structure

```
App
DesignSystem
Features
Models
Services
OneulRhythmShared
Widgets
Resources
Extensions
```

---

# Documentation

The project documentation is organized as follows.

| Document | Purpose |
|----------|---------|
| DECISIONS.md | Long-term architectural decisions |
| DESIGN.md | User experience and runtime behavior |
| ARCHITECTURE.md | System architecture |
| ROADMAP.md | Future milestones |
| CHANGELOG.md | Project history |

---

# Current Status

Current milestone:

**Sprint 6-1 — Live Activity MVP**

Completed:

- Widget Extension
- Shared Activity definitions
- Activity synchronization
- Immediate day-complete dismissal
- Snapshot-driven architecture

---

# Future

Planned work includes:

- Notifications
- Snooze support
- Home Screen widgets
- Apple Watch
- Accessibility improvements
- iCloud synchronization

---

# License

This project is currently under active development.
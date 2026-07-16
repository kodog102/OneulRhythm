# 🌿 AGENTS

This document defines how AI agents collaborate while developing OneulRhythm.

Its purpose is to ensure every implementation remains consistent with the product philosophy, architecture, and long-term vision.

Agents should optimize for clarity, consistency, and maintainability over short-term convenience.

---

# Team

The project currently uses three primary AI roles.

## Architect (ChatGPT)

Responsibilities

- Product planning
- UX decisions
- Architecture
- Long-term roadmap
- Technical direction
- Sprint planning
- Reviewing architectural changes

Architect defines direction but does not modify production code.

---

## Implementation Agent

Responsibilities

- Implement approved tasks
- Preserve architectural boundaries
- Keep changes focused and minimal
- Build after every completed task
- Avoid unrelated refactoring

Every implementation should conclude with:

- Implementation Summary
- Build Status
- Preview Status
- Architecture Status
- Risks
- Technical Debt
- Manual Verification
- Next Recommended Step

Implementation Agents never:

- commit
- push
- redesign architecture without approval

---

## QA Agent

Responsibilities

- Review implementation
- Verify architectural boundaries
- Detect regressions
- Review Git changes
- Validate release readiness
- Produce manual verification checklists

QA Agents validate.

They never modify production code or redefine architecture.

---

# Workflow

Every feature follows the same workflow.

```text
Planning

↓

Architect

↓

Implementation

↓

Build

↓

QA Review

↓

Manual Verification

↓

Commit

↓

Push
```

No stage should be skipped.

---

# Product Philosophy

Every implementation should preserve the core principles of OneulRhythm.

## Calm

Avoid stressful or productivity-driven experiences.

The application should feel peaceful.

---

## Rhythm

The application focuses on today's rhythm.

It is not a task manager.

---

## Simplicity

Prefer small, incremental improvements.

Avoid unnecessary abstraction and large rewrites.

---

## Present Moment

Always prioritize what matters now.

Current rhythm should receive the highest emphasis.

---

# Architecture Principles

## Single Source of Truth

Routine timing belongs exclusively to:

- RoutineScheduleEngine

Presentation state belongs exclusively to:

- TodayRhythmSnapshot

Every presentation surface must consume the same snapshot.

Never calculate schedule state independently inside:

- TodayView
- Live Activity
- Widget Extension
- future Apple Watch features

---

## Layer Responsibilities

Views

- presentation
- layout
- accessibility
- animation

ViewModels

- orchestration
- interaction
- presentation state

Repositories

- persistence
- data access

Services

- infrastructure
- platform integration

Business logic should never appear inside Views.

---

# Shared Module Rules

ActivityKit contracts belong inside:

OneulRhythmShared

Never duplicate:

- ActivityAttributes
- ContentState
- presentation policies
- shared Activity models

The shared module is the only source of truth for ActivityKit definitions.

---

# Live Activity Rules

Only one logical Live Activity may exist for a calendar day.

The LiveActivityCoordinator owns the complete Activity lifecycle.

It is responsible for:

- creation
- update
- reconciliation
- cleanup
- completion

Never:

- create Activities directly from Views
- calculate Activity state outside the coordinator
- duplicate reconciliation logic
- modify already-ended Activities

Day completion always uses immediate dismissal.

No delayed dismissal or lingering behavior should be introduced.

---

# Notification Rules

Notifications remain optional.

Avoid:

- repeated reminders
- overdue warnings
- completion nagging
- anxiety-inducing messaging

One reminder is sufficient.

The Live Activity provides the continuous experience.

---

# UX Rules

Language should remain calm and encouraging.

Avoid:

- failed
- missed
- warning
- overdue
- urgent

Prefer:

- today's rhythm
- current rhythm
- next rhythm
- continue
- gently

---

# Documentation Rules

Documentation is part of the implementation.

Whenever architectural decisions change, update:

- DECISIONS.md
- ARCHITECTURE.md
- DESIGN.md
- README.md

Whenever a Sprint completes, update:

- CHANGELOG.md
- ROADMAP.md

Documentation should never fall behind implementation.

---

# QA Rules

Never claim verification that has not been performed.

Always distinguish between:

✅ Verified

⚠️ Not Verified

Manual verification is required for:

- ActivityKit
- WidgetKit
- notifications
- permissions
- every user-visible feature

A successful build is never proof of correctness.

---

# Git Rules

One task.

One commit.

Every commit should represent a complete, reviewable change.

Before completing a Sprint:

- working tree should be clean
- every new file must be tracked
- documentation should be updated

---

# Coding Rules

Prefer:

- small functions
- dependency injection
- protocol abstractions
- immutable models
- explicit responsibilities

Avoid:

- singleton abuse
- duplicated logic
- business logic inside Views
- architecture leakage between layers

When duplicated business logic appears, reconsider the architecture before implementing.

---

# Definition of Done

A task is complete only when:

- Implementation finished
- Build passed
- Architecture preserved
- Documentation updated (when required)
- QA review completed
- Manual verification completed

A Sprint is complete only when:

- all tasks are complete
- documentation reflects the current architecture
- Git working tree is clean
- release readiness has been reviewed

Only then should work be committed.

---

# Guiding Question

Every agent should ask:

> Does this implementation help users stay connected with today's rhythm?

If the answer is no,

the implementation probably does not belong in OneulRhythm.
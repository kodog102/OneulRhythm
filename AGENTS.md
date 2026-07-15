# 🌿 AGENTS

This document defines how AI agents collaborate while developing OneulRhythm.

The goal is consistency.

Every implementation should preserve the product philosophy, architecture and long-term vision.

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
- Reviewing major design decisions

Architect never edits code directly.

---

## Implementation Agent

Responsibilities

- Implement approved tasks
- Preserve architecture
- Keep changes as small as possible
- Build after every task
- Never introduce unrelated refactoring

Implementation Agent must finish every task with:

- Implementation Summary
- Build Status
- Preview Status
- Architecture Status
- Risks
- Technical Debt
- Manual Verification
- Next Recommended Step

Implementation Agent never commits.

Implementation Agent never pushes.

---



## QA Agent

Responsibilities

- Review implementation
- Verify architecture boundaries
- Detect regressions
- Review Git diff
- Review Release readiness
- Produce manual verification checklist

QA never changes production code.

QA never rewrites architecture.

QA validates.

---



# Workflow

Every feature follows the same pipeline.

```text
Planning

↓

Architect

↓

Implementation

↓

Build

↓

QA

↓

Manual Test

↓

Commit

↓

Push
```

No step should be skipped.

---



# Product Philosophy

Agents must preserve these principles.

## Calm

Never introduce stressful UX.

---



## Rhythm

The application is about today's rhythm.

Not productivity.

---



## Simplicity

Prefer small changes.

Avoid large rewrites.

---



## Shared Source of Truth

Schedule logic belongs inside:

RoutineScheduleEngine

Presentation state belongs inside:

TodayRhythmSnapshot

Never duplicate schedule logic.

---



# Architecture Rules

Views

- layout only
- accessibility
- animation

ViewModels

- orchestration
- interaction
- state

Repository

- persistence only

Services

- infrastructure

Never mix responsibilities.

---



# Live Activity Rules

One Live Activity per day.

Never one Live Activity per routine.

Live Activity represents:

- Current rhythm
- Next rhythm
- Today's flow

Notifications remain secondary.

---



# Notification Rules

Notifications are optional.

Never:

- repeated reminders
- completion nagging
- overdue alerts

One reminder is enough.

Live Activity becomes the ongoing experience.

---



# UX Rules

Avoid words like:

- failed
- missed
- warning
- urgent

Prefer:

- current rhythm
- next rhythm
- today
- gently
- continue

---



# Commit Rules

One task

↓

One commit

Every commit should be reviewable.

Avoid mixing unrelated work.

---



# Documentation Rules

Whenever architecture changes:

Update

- README
- ARCHITECTURE
- ROADMAP

Whenever product philosophy changes:

Update

- DESIGN
- DECISIONS

Whenever a Sprint completes:

Update

- CHANGELOG

---



# QA Rules

Never claim verification that was not actually performed.

Always distinguish:

✅ Verified

⚠️ Not Verified

Manual Simulator verification is required for:

- permissions
- notifications
- ActivityKit
- WidgetKit

---



# Coding Rules

Prefer

- small functions
- dependency injection
- protocol abstraction
- immutable models

Avoid

- singleton abuse
- duplicated logic
- business logic inside Views

---



# Definition of Done

A task is complete only if:

- Code implemented
- Build passed
- Architecture preserved
- QA reviewed
- Manual verification completed
- Documentation updated (if needed)

Only then should the task be committed.

---



# Guiding Question

Every agent should ask:

> Does this implementation help users stay connected with today's rhythm?

If the answer is no,

the implementation probably does not belong in OneulRhythm.
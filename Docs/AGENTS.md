# 🌿 AGENTS

This document defines how AI agents collaborate while developing OneulRhythm.

The goal is consistency.

Every implementation should preserve the product philosophy, architecture, and long-term vision.

---

# Team

The project currently uses three primary AI roles.

## Architect

Responsibilities

- Product planning
- UX decisions
- Architecture
- Long-term roadmap
- Technical direction
- Sprint planning
- Reviewing major design decisions

Architect does not modify production code.

Architect approves architecture before implementation begins.

---

## Implementation Agent

Responsibilities

- Implement approved work
- Preserve architecture
- Keep changes as small as possible
- Build after every task
- Avoid unrelated refactoring

Every implementation should finish with:

- Implementation Summary
- Files Changed
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
- Produce manual verification checklists

QA never changes production code.

QA validates implementation against approved architecture.

---

# Development Workflow

Every feature follows the same pipeline.

```text
Planning

↓

Architect Review

↓

Architecture Approval

↓

Implementation

↓

QA Review

↓

QA Fix

↓

QA Re-check

↓

Visual QA

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

- RoutineScheduleEngine

Presentation facts belong inside:

- TodayRhythmSnapshot

Presentation composition belongs inside:

- TodayViewModel

Never duplicate schedule logic.

---

# Architecture Rules

Views

- layout
- rendering
- accessibility
- animation

ViewModels

- presentation composition
- interaction
- orchestration

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

- Current Rhythm
- Past Incomplete Rhythm (when no current rhythm exists)
- Next Rhythm
- Today's flow

Notifications remain secondary.

---

# Notification Rules

Notifications are optional.

Never introduce:

- repeated reminders
- completion nagging
- overdue alerts

One reminder is enough.

Live Activity remains the primary ongoing experience.

---

# UX Rules

Avoid user-facing words like:

- failed
- missed
- overdue
- urgent
- warning

Prefer:

- current rhythm
- past rhythm
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
- DECISIONS

Whenever product behavior changes:

Update

- DESIGN
- CHANGELOG

Whenever a Sprint completes:

Update

- ROADMAP

Documentation should always reflect the current implementation.

---

# QA Rules

Never claim verification that was not actually performed.

Always distinguish:

✅ Verified

⚠️ Not Verified

Visual polish must be confirmed by rendering in Xcode Canvas or Simulator.

Source inspection alone cannot validate perceived UX quality.

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

A task is complete only when all of the following are true:

- Code implemented
- Build passed
- Architecture preserved
- QA reviewed
- QA Fix completed (if required)
- QA Re-check passed (if required)
- Manual Visual QA completed
- Documentation updated (when applicable)

Only then should the work be committed.

---

# Guiding Question

Every agent should ask:

> Does this implementation help users stay connected with today's rhythm?

If the answer is no,

the implementation probably does not belong in OneulRhythm.
# AGENTS

This document defines product philosophy and architecture rules for AI agents contributing to OneulRhythm.

Sprint process, prompts, Cursor working rules, and close-out checklists are defined in `Docs/Development/`.

This document does not replace the official Development Workflow.

---

# Roles

Collaboration roles match the official Development Workflow.

## ChatGPT

- Requirement analysis
- Architecture design
- Task scope definition
- Cursor prompt creation
- Code and architecture review
- QA result review
- Documentation review
- Sprint approval

ChatGPT does not modify the repository.

## Cursor

- Code implementation
- Test implementation
- Build and test execution
- Integration QA
- Documentation updates
- Structured implementation reports

Cursor never commits or pushes unless the developer explicitly requests it.

## Developer

- Final decisions
- Running and visually inspecting the app
- Approving changes
- Commit and push
- Product direction

Only the developer commits and pushes.

---

# Development Workflow

Follow the official Sprint pipeline in `Docs/Development/DEVELOPMENT_WORKFLOW.md`.

```text
Planning
  → Architecture and Task Design
  → Implementation
  → Implementation Report
  → Code Review
  → Fixes (as needed)
  → Integration QA
  → Final Review
  → Documentation Pass
  → Documentation Review
  → Sprint Retrospective
  → Commit and Push (Developer)
  → Next Sprint Kickoff
```

Related process documents:

- `Docs/Development/PROMPT_LIBRARY.md`
- `Docs/Development/CURSOR_GUIDELINES.md`
- `Docs/Development/SPRINT_CHECKLIST.md`

No process step should be skipped without an explicit developer decision.

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

Scheduling logic belongs inside:

- Schedule Engine

Business output is represented by:

- ResolvedSchedule

Presentation models are created by:

- Mappers

Presentation orchestration belongs inside:

- ViewModels

Never duplicate scheduling logic.

Never move business logic into presentation.

---

# Architecture Rules

## Views

Responsible for:

- Layout
- Rendering
- Accessibility
- Animation

---

## ViewModels

Responsible for:

- Presentation orchestration
- User interaction
- State management

ViewModels must not contain business logic.

---

## Mappers

Responsible for:

- Transforming business models into presentation models

Mappers must not contain:

- Business rules
- Persistence logic
- Framework lifecycle logic

---

## Repository

Responsible for:

- Persistence only

---

## Services

Responsible for:

- Infrastructure
- External systems

Never mix responsibilities across layers.

---

# Live Activity Rules

Only one Live Activity may exist per day.

Never create one Live Activity per rhythm.

Live Activity represents:

- Current Rhythm
- Past Rhythm (when no current rhythm exists)
- Next Rhythm
- Today's flow

Notifications remain secondary.

---

# Notification Rules

Notifications are optional.

Never introduce:

- Repeated reminders
- Completion nagging
- Overdue alerts

One reminder is enough.

Live Activity remains the primary ongoing experience.

---

# UX Rules

Avoid user-facing words like:

- Failed
- Missed
- Overdue
- Urgent
- Warning

Prefer:

- Current Rhythm
- Past Rhythm
- Next Rhythm
- Today
- Continue
- Gently

---

# Commit Rules

Commit and push are developer-owned steps.

Preferred shape:

One Sprint or one clearly scoped task

↓

One reviewable commit

Avoid mixing unrelated work.

---

# Documentation Rules

Documentation should always reflect the current implementation.

Process for documentation updates is defined by the Documentation Pass and Documentation Review stages in `Docs/Development/DEVELOPMENT_WORKFLOW.md`.

## Architecture Changes

When architecture changes:

Update:

- Architecture documentation
- Decision Records

Update Design documentation only if implementation contracts change.

---

## Product Behavior Changes

When product behavior changes:

Update:

- Design documentation
- CHANGELOG

---

## Sprint Completion

When a Sprint completes:

Update:

- ROADMAP
- CHANGELOG

---

## Documentation Hierarchy

Before making architectural or implementation decisions, consult documentation in the following order:

1. Docs/README.md
2. Docs/GLOSSARY.md
3. Docs/Architecture/
4. Docs/Decisions/
5. Docs/Design/
6. Docs/Extensions/
7. Docs/Development/
8. Docs/AI/AGENTS.md

When documentation conflicts, use the following priority:

Glossary

↓

Architecture

↓

Decision Records

↓

Design

↓

Extensions

Process conflicts are resolved by `Docs/Development/DEVELOPMENT_WORKFLOW.md`.

---

## Documentation Responsibilities

- Architecture defines the system structure.
- Decision Records explain why architectural decisions exist.
- Design documents describe how the system is implemented.
- Extensions describe architectural capabilities beyond the current core.
- Development documents define the Sprint process.
- Roadmap describes product direction.
- Changelog records completed work.

---

# QA Rules

Never claim verification that was not actually performed.

Always distinguish:

✅ Verified

⚠️ Not Verified

Visual polish must be confirmed using Xcode Canvas or Simulator.

Source inspection alone cannot validate perceived UX quality.

---

# Coding Rules

Prefer:

- Small functions
- Dependency Injection
- Protocol abstraction
- Immutable models

Avoid:

- Singleton abuse
- Duplicated logic
- Business logic inside Views

---

# Definition of Done

A Sprint task is complete only when the relevant stages of the official Development Workflow are satisfied, including:

- Approved scope implemented
- Build and relevant tests passed
- Architecture preserved
- Code Review completed
- Integration QA completed
- Manual Visual QA completed or recorded by the developer
- Documentation Pass completed when documentation is affected
- Documentation Review approved when documentation changed

Only then should the developer commit and push.

---

# Guiding Question

Every agent should ask:

> Does this implementation help users stay connected with today's rhythm?

If the answer is no,

the implementation probably does not belong in OneulRhythm.

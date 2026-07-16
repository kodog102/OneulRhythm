# 🌿 OneulRhythm Development Playbook

This document defines the standard development workflow for OneulRhythm.

Every Sprint should follow this process.

The objective is to maintain:

- Calm architecture
- Small changes
- High confidence
- Consistent quality

---

# Sprint Planning

Before implementation, define:

## Sprint Goal

Describe the primary objective.

Example

- Past Rhythm Experience
- Live Activity Lifecycle
- Notification Experience

---

## Success Criteria

Define what success looks like.

Example

- Single primary rhythm
- Completion promotion
- Immediate dismissal

Success criteria should be measurable.

---

## Out of Scope

Explicitly list what will NOT be implemented.

Example

- Statistics
- History screen
- Multiple primary cards
- Architecture redesign

Out-of-scope decisions reduce implementation drift.

---

# Development Workflow

Every Sprint follows this workflow.

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

Documentation

↓

Commit

↓

Push
```

No step should be skipped.

---

# Step 1 — Architect Review

Recommended Model

GPT-5 Thinking

Purpose

Review the current architecture before any implementation.

Deliverables

- Architecture Review
- Current Behavior
- Risks
- Alternatives
- Expected Files
- Implementation Plan

Architect never modifies production code.

---

# Step 2 — Architecture Approval

Purpose

Review the proposed architecture.

Produce:

- Final Design
- Constraints
- Approved Implementation Plan

Implementation begins only after approval.

---

# Step 3 — Implementation

Recommended Model

Claude Sonnet 5

Purpose

Implement the approved design.

Rules

- Keep changes minimal.
- Preserve architecture.
- Avoid unrelated refactoring.
- Build after implementation.

Deliverables

- Implementation Summary
- Files Changed
- Build Status
- Risks
- Manual Verification
- Next Recommendation

Implementation Agent never commits.

Implementation Agent never pushes.

---

# Step 4 — QA Review

Recommended Model

GPT-5 Thinking

Purpose

Verify implementation.

Review

- Architecture
- Regression
- Git Scope
- Release readiness

Return

- PASS
- PASS WITH CONDITIONS
- BLOCK

Never modify production code.

---

# Step 5 — QA Fix

Recommended Model

Claude Sonnet 5

Purpose

Address only QA findings.

Rules

- No new features.
- No architecture changes.
- No scope expansion.

---

# Step 6 — QA Re-check

Recommended Model

GPT-5 Thinking

Purpose

Verify only the QA fixes.

Do not repeat the full review.

Return

- PASS
- PASS WITH CONDITIONS
- BLOCK

---

# Step 7 — Visual QA

Performed by

Human

Verify

- Layout
- Typography
- Animation
- Spacing
- Accessibility
- Live Activity
- Widget rendering

Perceived UX quality cannot be verified by source inspection alone.

---

# Step 8 — Documentation

Always update documentation before committing.

Required

- CHANGELOG
- ROADMAP

When architecture changes

Update

- ARCHITECTURE
- DECISIONS

When product behavior changes

Update

- DESIGN

When workflow changes

Update

- AGENTS

Documentation should always match production behavior.

---

# Step 9 — Commit

One Sprint

↓

One Commit

The commit should be reviewable.

Avoid mixing unrelated work.

---

# Step 10 — Push

Push only after:

- Documentation
- QA
- Visual QA

are complete.

---

# Guiding Principles

Every Sprint should preserve:

- Calm
- Simplicity
- One primary focus
- Snapshot-driven architecture
- Small incremental changes

---

# Final Question

Before completing a Sprint, ask:

> Does this Sprint help users stay connected with today's rhythm?

If the answer is no,

the Sprint should be reconsidered.
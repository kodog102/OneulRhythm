# OneulRhythm Engineering Charter

> "Build a product that is calm to use and calm to develop."

Version: 1.0  
Status: Active

---

This repository is AI-driven.

The repository is the single source of truth.

Project documents are executable governance, not reference material.

Every implementation, validation, and review agent must read the required project documents before making decisions.

When repository content and conversational memory differ, the repository takes precedence.

---

# Purpose

The Engineering Charter defines the engineering principles that guide every technical decision in the OneulRhythm project.

Its purpose is to ensure that the project remains:

- Maintainable
- Predictable
- Consistent
- Reliable

The Charter is intentionally technology-agnostic.

It describes **how engineering decisions are made**, not which technologies are used.

---

# Core Principles

## 1. Architecture Before Implementation

Every significant feature begins with a reviewed architecture before production code is written.

Implementation should follow architecture—not define it.

---

## 2. Human Owns the Product

AI is an engineering partner.

Humans own:

- Product direction
- Architecture approval
- Release decisions
- Final responsibility

AI assists.

Humans decide.

---

## 3. Prefer Simplicity

When multiple solutions exist,

choose the simplest solution that satisfies the requirements.

Avoid unnecessary abstraction.

Avoid premature optimization.

Simple code is easier to review, test, and maintain.

---

## 4. Small, Incremental Changes

Large rewrites increase risk.

Prefer small, well-defined, incremental improvements.

Each change should be:

- Easy to understand
- Easy to review
- Easy to revert

---

## 5. Preserve Existing Behavior

New functionality must not unintentionally change existing behavior.

Regression is considered a defect.

Backward compatibility is the default.

---

## 6. Quality Before Speed

Shipping reliable software is more valuable than shipping quickly.

Every Sprint includes:

- Review
- QA
- Documentation

before release.

---

## 7. Documentation Is Development

Documentation is not optional.

A feature is not complete until its relevant documentation has been updated.

Engineering decisions should be recorded while they are still fresh.

---

## 8. One Responsibility Per Agent

Each AI Agent has a single, clearly defined responsibility.

Responsibilities should not overlap.

This keeps reviews objective and outputs predictable.

---

## 9. Deterministic Engineering

Engineering decisions should produce predictable results.

Prefer:

- Explicit behavior
- Documented platform APIs
- Deterministic state transitions

Avoid relying on undefined or undocumented behavior.

---

## 10. Continuous Improvement

Every Sprint should improve either:

- The product
- The engineering process
- Or both

Lessons learned should first improve existing documentation and workflows.

Introduce new governance only when repeated evidence shows that existing processes are insufficient.

---

## 11. Document the Why

Engineering documentation should explain not only **what** was built, but also **why** the decision was made.

Future maintainers should be able to understand the reasoning behind important decisions without relying on memory.

---

## 12. Repository First

The repository is the authoritative source of project knowledge.

Engineering decisions should be based on repository documentation rather than conversational memory.

If repository content and prior discussion conflict, update the discussion—not the repository.

---

# Engineering Workflow

Every feature follows the same lifecycle.

Requirements

↓

Repository Context

↓

Architecture

↓

Implementation

↓

Validation

↓

Review

↓

QA

↓

Documentation

↓

Sprint Review

↓

Release Approval

↓

Commit

↓

Push

---

# Definition of Done

A Sprint is complete only when all of the following are satisfied.

- Repository context reviewed
- Architecture approved
- Implementation completed
- Validation completed
- Review completed
- QA passed
- Documentation updated
- Sprint Review completed
- Release approved
- Commit completed
- Push completed

---

# Decision Framework

Repository consistency is assumed before applying this framework.

When choosing between multiple solutions, apply the following priorities.

1. Correctness
2. Simplicity
3. Maintainability
4. Readability
5. Extensibility

Performance optimization should only be introduced when there is measurable evidence that it is needed.

---

# Calm Engineering

OneulRhythm values calm engineering.

We intentionally favor software that is easy to understand over software that is clever.

Prefer:

- Explicit code
- Predictable behavior
- Stable architecture
- Small changes
- Clear documentation

Avoid:

- Clever code
- Hidden behavior
- Unnecessary complexity
- Premature abstraction

The codebase should remain approachable, even months after it was written.

---

# Engineering Culture

We optimize for long-term sustainability rather than short-term velocity.

Success is measured not only by delivering features, but also by maintaining a healthy and understandable codebase.

Every engineering decision should leave the project in a better state than before.

---

# Philosophy

Build products.

Not just features.

Build engineering systems that remain understandable months later.
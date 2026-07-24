# Prompt Library

This document defines the official prompt templates used throughout the OneulRhythm development workflow.

Prompt templates are considered project artifacts.

All Sprint implementation prompts should follow these templates unless the developer explicitly approves an exception.

---

# Sprint Implementation Prompt

Every Sprint implementation prompt should follow the structure below.

The section order should not be changed.

---

## 1. Sprint Context

Describe the purpose of the Sprint.

Include:

- Sprint objective
- Current project phase
- Relationship to previous Sprint
- Whether Product Design is already complete

This section answers:

> Why does this Sprint exist?

---

## 2. Governing Documents

List every document Cursor must review before implementation.

Order documents by priority.

Typical order:

- Product Experience
- Product Design
- UI Specification
- Decision Records
- Architecture
- Development Rules

Never implement before reviewing these documents.

---

## 3. Repository Context Summary (Required)

Summarize the current repository.

Do not require Cursor to rediscover existing architecture.

Include:

### Product Context

Summarize approved Product decisions.

### Architecture Context

Summarize important architecture.

### Existing Components

Summarize reusable code.

This section reduces unnecessary exploration.

---

## 4. Sprint Goal

Describe exactly what should be implemented.

Implementation should express approved Product decisions.

It should never redefine them.

---

## 5. Approved Architecture

Describe architectural boundaries.

Include:

- Existing responsibilities
- Existing data flow
- Existing layers

Explicitly identify what must remain unchanged.

---

## 6. Implementation Scope

Clearly define:

### In Scope

Everything expected.

### Out of Scope

Everything prohibited.

Avoid ambiguity.

---

## 7. Constraints

List implementation constraints.

Typical examples:

- Preserve architecture.
- Do not redesign Product behavior.
- Do not duplicate business logic.
- Do not reinterpret documentation.
- Preserve existing naming unless approved.

### Ambiguity Policy

If documentation is incomplete:

- Stop implementation.
- Report ambiguity.
- Request clarification.

Never guess Product behavior.

---

## 8. Tests

Describe automated verification.

Include:

- Build
- Unit Tests
- Existing regression checks

---

## 9. Manual QA

Describe required manual verification.

Examples:

- Empty
- Upcoming
- Current
- Past Rhythm
- Day Complete

Visual polish must always be manually confirmed.

---

## 10. Documentation Pass

Update documentation only when required.

Examples:

- CHANGELOG
- ROADMAP
- Design Documents
- Architecture
- Decision Records

Implementation must never invalidate approved documentation.

If documentation becomes incorrect,

stop and request documentation updates.

---

## 11. Code Review

Verify:

- Architecture
- Layer responsibilities
- Naming consistency
- Dependency direction
- Product contract compliance

---

## 12. Integration QA

Verify:

- Build
- Runtime behavior
- Existing features
- Regression
- Documentation consistency

Implementation is complete only after successful Integration QA.

---

## 13. Required Final Report

Every Sprint implementation must finish with the following report.

### Implementation Summary

Describe completed work.

---

### Files Changed

List modified files.

---

### Build Status

Success / Failed

---

### Tests

Describe executed tests.

---

### Manual QA

Describe manually verified scenarios.

Clearly distinguish:

✅ Verified

⚠️ Not Verified

---

### Documentation Updated

List updated documents.

If none:

State:

"No documentation changes required."

---

### Risks

Describe remaining concerns.

---

### Technical Debt

Describe intentionally postponed improvements.

---

### Open Questions

List unresolved questions.

Never silently make Product or Architecture decisions.

---

# Prompt Principles

Every Sprint prompt should follow these principles.

## Documentation First

Implementation follows approved documentation.

Never implement directly from conversations.

---

## Artifact First

Sprint prompts reference approved project artifacts.

They never replace them.

---

## Product UI First

Implementation expresses approved Product decisions.

Implementation Agents never redesign the product.

---

## No Guessing

When documentation is ambiguous,

stop implementation.

Ask questions.

Never invent Product behavior.

---

## Small, Reviewable Changes

Each Sprint should produce:

- One clear objective
- One reviewable implementation
- One reviewable report

Large unrelated changes should be split into multiple Sprints.
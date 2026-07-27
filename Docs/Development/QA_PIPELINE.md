# OneulRhythm QA Pipeline

## Purpose

The QA Pipeline defines the standard quality assurance process for every Sprint.

Its purpose is to ensure that implemented behavior is verified consistently before a Sprint is approved.

The QA Pipeline complements the official Development Workflow by defining how QA is performed.

---

# QA Principles

QA exists to improve quality—not to block development.

Finding an issue does not fail a Sprint.

Instead:

Issue Found

↓

Fix

↓

Re-run affected QA steps

↓

Product Owner Approval

Every verification must distinguish between:

- ✅ Verified
- ⚠️ Not Verified

Never claim verification that was not actually performed.

---

# QA Flow

Every Sprint follows the same QA sequence inside the canonical lifecycle
(`DEVELOPMENT_WORKFLOW.md` stages 4–8).

From Sprint 18, Product Experience / visual Sprints prefer **Visual QA before Technical QA** (see Visual-first in `DEVELOPMENT_WORKFLOW.md`).

Implementation Completed

↓

Implementation Report

↓

Code Review

↓

Visual QA (when Visual-first / user-facing)

↓

Technical / Integration QA

↓

Documentation Pass

↓

Document Integration Review (DIR)

↓

Planning Sync (PS)

↓

Product Owner Approval (Owner Review)

---

# 1. Code Review

Purpose

Verify that the implementation matches the approved scope.

Review Checklist

- Scope preserved
- Architecture preserved
- No unintended behavior changes
- No unnecessary complexity
- Code quality acceptable

Return:

- PASS
- PASS WITH CONDITIONS
- FAIL

---

# 2. Technical / Integration QA

Purpose

Verify that the implemented feature works correctly within the application.

Typical checks include:

- Build succeeds
- Application launches
- Feature behavior
- State transitions
- Persistence
- Existing behavior preserved
- Relevant tests pass

Return:

- PASS
- PASS WITH CONDITIONS
- FAIL

---

# 3. Visual QA

Purpose

Verify user experience that cannot be confirmed through source inspection.

When Visual-first applies (Sprint 18+), compare against:

- North Star
- Design Extraction Sheet
- Visual Review Guide (when present)

Artifact index: `Docs/Visual/README.md`.

Performed by QA Agent with Product Owner / Visual Director review support as needed.

Typical checks include:

- Layout and composition against the North Star
- UI consistency with Design Extraction
- Animation
- Accessibility
- Live Activity behavior
- Widget behavior (when applicable)

Items not visually verified must be recorded as Not Verified.

When Visual-first applies, prefer Visual QA before Technical / Integration QA so visual drift is caught before Sprint close-out.

---

# 4. Documentation Pass

Purpose

Ensure owner documents reflect implemented behavior.

Update only documentation affected by the Sprint.

Examples:

- Product / Design / Architecture / Decision Records
- Hub README membership
- Link repairs

Avoid unrelated documentation cleanup.

Documentation Pass does not replace DIR or Planning Sync. ROADMAP / CHANGELOG alignment belongs primarily to Planning Sync.

---

# 4A. Document Integration Review (DIR)

Purpose

Verify documentation system consistency (cross references, authority, terminology, orphans, contradictions).

Defined in `DEVELOPMENT_WORKFLOW.md` stage 6 — do not redefine here.

---

# 4B. Planning Sync (PS)

Purpose

Align ROADMAP, CHANGELOG, and README with reality; ensure unique sprint ownership and correct deferred work.

Defined in `DEVELOPMENT_WORKFLOW.md` stage 7 — do not redefine here.

---

# 5. Product Owner Approval (Owner Review)

A Sprint is ready for completion only when:

- Approved scope implemented (when applicable)
- Review completed
- Visual QA completed or recorded (when applicable)
- Technical / Integration QA passed
- DIR completed
- Planning Sync completed
- Outstanding risks understood and accepted by the Product Owner

Only then should the Product Owner commit and push.

---

# QA Iteration

QA is an iterative process.

If an issue is found:

Implementation

↓

QA

↓

Issue Found

↓

Fix

↓

Re-run affected QA steps

↓

Product Owner Approval

Only the affected QA stages need to be repeated.

The entire Sprint does not restart.

---

# Guiding Question

Every QA stage should ask:

> Does this Sprint behave as intended without degrading the existing product?
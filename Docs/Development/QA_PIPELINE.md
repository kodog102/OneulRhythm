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

Sprint Approval

Every verification must distinguish between:

- ✅ Verified
- ⚠️ Not Verified

Never claim verification that was not actually performed.

---

# QA Flow

Every Sprint follows the same QA sequence.

Implementation Completed

↓

Implementation Report

↓

Code Review

↓

Integration QA

↓

Manual Visual QA

↓

Documentation Pass

↓

Sprint Approval

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

# 2. Integration QA

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

# 3. Manual Visual QA

Purpose

Verify user experience that cannot be confirmed through source inspection.

Performed by the developer.

Typical checks include:

- Layout
- UI consistency
- Animation
- Accessibility
- Live Activity behavior
- Widget behavior (when applicable)

Items not visually verified must be recorded as Not Verified.

---

# 4. Documentation Pass

Purpose

Ensure documentation reflects implemented behavior.

Update only documentation affected by the Sprint.

Examples:

- Architecture
- Decision Records
- Design
- Roadmap
- Changelog

Avoid unrelated documentation cleanup.

---

# 5. Sprint Approval

A Sprint is ready for completion only when:

- Approved scope implemented
- Review completed
- Integration QA passed
- Manual Visual QA completed or recorded
- Documentation updated (when required)
- Outstanding risks understood and accepted by the developer

Only then should the developer commit and push.

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

Sprint Approval

Only the affected QA stages need to be repeated.

The entire Sprint does not restart.

---

# Guiding Question

Every QA stage should ask:

> Does this Sprint behave as intended without degrading the existing product?
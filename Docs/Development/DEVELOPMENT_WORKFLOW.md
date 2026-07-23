# OneulRhythm Development Workflow

## Introduction

This document defines the official Sprint workflow for OneulRhythm.

It is the authoritative source describing how every Sprint progresses from planning to completion.

Before implementation begins, all AI agents must follow the project governance defined in the repository.

Related documents:

- `ENGINEERING_CHARTER.md` — engineering principles
- `CURSOR_GUIDELINES.md` — execution rules for Cursor
- `PROMPT_LIBRARY.md` — reusable prompts
- `SPRINT_CHECKLIST.md` — Sprint completion checklist
- `QA_PIPELINE.md` — QA process
- `Docs/AI/AGENTS.md` — product and architecture rules

---

# Workflow Principles

Every Sprint follows these principles.

- Repository First
- Architecture Before Implementation
- Scope Before Code
- Validation Before Approval
- Documentation Before Completion

Repository documentation always takes precedence over conversational memory.

Implementation should improve existing documentation before introducing new governance.

Task slicing is optional and should only be used when it improves safety, validation, or implementation clarity.

---

# Roles

## ChatGPT

Responsible for:

- Requirement analysis
- Repository context analysis
- Architecture design
- Task scope definition
- Technical decision support
- Cursor prompt creation
- Architecture validation
- Sprint planning support

ChatGPT provides architectural guidance but does not replace implementation review or QA performed by Cursor.

---

## Cursor

Responsible for:

- Repository inspection
- Code implementation
- Test implementation
- Build execution
- Code review
- Integration QA
- Documentation Pass
- Documentation updates
- Structured implementation reports

Cursor must remain inside the approved Sprint scope.

Cursor never commits or pushes.

---

## Developer

Responsible for:

- Product direction
- Final decisions
- Visual verification
- Device verification
- Sprint approval
- Commit
- Push

The developer owns the final product.

---

# Sprint Lifecycle

## 1. Sprint Planning

ChatGPT and the developer define:

- Sprint goal
- Success criteria
- Scope
- Out of scope
- Acceptance criteria

Output:

Approved Sprint Goal

---

## 2. Repository Context Review

Before architecture or implementation begins, review the required project documents.

Typical required context includes:

- ENGINEERING_CHARTER
- DEVELOPMENT_WORKFLOW
- CURSOR_GUIDELINES

Then review Sprint-specific documentation and affected source code.

Output:

Approved implementation context.

---

## 3. Architecture and Task Design

ChatGPT analyzes:

- Current architecture
- Affected modules
- Implementation strategy

If the task is sufficiently large or risky, it may be divided into implementation slices.

Task slicing is optional.

Output:

Approved implementation plan.

---

## 4. Implementation

Cursor implements only the approved scope.

Rules:

- Preserve architecture
- Keep changes small
- Follow project governance
- Update tests when necessary
- Build successfully
- Never expand scope
- Never commit or push

Output:

Implementation Report

---

## 5. Implementation Report

Cursor reports:

1. Modified Files
2. Implementation Summary
3. Architecture Notes
4. Test Results
5. Build Results
6. Manual Verification Required
7. Remaining Risks

---

## 6. Code Review

Cursor reviews:

- Architecture preservation
- Scope adherence
- Regression risk
- Release readiness

Return:

- PASS
- PASS WITH CONDITIONS
- FAIL / BLOCK

---

## 7. Fixes

Cursor addresses only approved review findings.

Rules:

- No new features
- No architecture redesign
- No speculative improvements
- No scope expansion

---

## 8. Integration QA

Cursor verifies:

- Functional behavior
- Lifecycle behavior
- Persistence
- State transitions
- Actor isolation
- Idempotency
- Build
- Tests
- Regression

Developer performs:

- Visual QA
- Device verification

Return:

- PASS
- PASS WITH CONDITIONS
- FAIL

---

## 9. Sprint Review

ChatGPT verifies:

- Architecture consistency
- Scope completion
- Outstanding technical decisions

Developer performs:

- Final product approval

---

## 10. Documentation Pass

Cursor updates only documentation affected by the Sprint.

Typical targets include:

- Docs/Architecture/
- Docs/Architecture/Decisions/
- Docs/Design/
- Docs/ROADMAP.md
- Docs/CHANGELOG.md
- README.md (when necessary)

Avoid unrelated documentation cleanup.

---

## 11. Documentation Verification

Cursor verifies:

- Documentation consistency
- Repository consistency
- Broken references

Developer approves documentation as part of Sprint completion.

---

## 12. Sprint Retrospective

Capture:

- What changed
- Why it changed
- Lessons learned
- Technical debt
- Readiness for the next Sprint

When process improvements are identified, update existing documentation whenever possible.

Avoid introducing new governance unless repeated evidence shows it is necessary.

---

## 13. Commit and Push

Developer performs:

- Commit
- Push

Preferred shape:

One Sprint = One reviewable commit

unless multiple commits improve reviewability.

---

## 14. Next Sprint Kickoff

Review:

- Remaining technical debt
- Remaining roadmap
- Next Sprint goal

---

# Workflow Diagram

```mermaid
flowchart TD
    A[1. Sprint Planning]
    --> B[2. Repository Context Review]
    --> C[3. Architecture and Task Design]
    --> D[4. Implementation]
    --> E[5. Implementation Report]
    --> F[6. Code Review]

    F -->|Findings| G[7. Fixes]
    G --> F

    F -->|Approved| H[8. Integration QA]
    H -->|Findings| G

    H -->|Approved| I[9. Sprint Review]
    I --> J[10. Documentation Pass]
    J --> K[11. Documentation Verification]

    K -->|Changes Required| J

    K -->|Approved| L[12. Sprint Retrospective]
    L --> M[13. Commit and Push]
    M --> N[14. Next Sprint Kickoff]
```

```text
Planning
  → Repository Context Review
  → Architecture and Task Design
  → Implementation
  → Implementation Report
  → Code Review (Cursor)
  → Fixes (if needed)
  → Integration QA (Cursor)
  → Sprint Review (ChatGPT + Developer)
  → Documentation Pass (Cursor)
  → Documentation Verification (Cursor)
  → Sprint Retrospective
  → Commit and Push (Developer)
  → Next Sprint Kickoff
```

---

# Working Rules

- Repository documentation is the source of truth.
- Required project documents must be reviewed before implementation.
- Scope is approved before implementation.
- ChatGPT owns architecture and technical decisions.
- Cursor owns implementation quality.
- Cursor stays inside the approved scope.
- The developer owns the final product.
- Visual QA is performed by the developer.
- Documentation must reflect implemented behavior.
- Architecture changes require explicit approval.
- Task slicing is optional and should only be used when it improves implementation quality.
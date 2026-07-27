# OneulRhythm Development Workflow

## Introduction

This document defines the official Sprint workflow for OneulRhythm.

It is the **canonical** source for Sprint lifecycle stages, Document Integration Review (DIR), and Planning Sync (PS).

Other process documents reference this workflow. They must not redefine a competing lifecycle.

Before implementation begins, all AI agents must follow the project governance defined in the repository.

Related documents:

- `Docs/Engineering/ENGINEERING_CHARTER.md` — engineering principles
- `CURSOR_GUIDELINES.md` — execution rules for Cursor
- `PROMPT_LIBRARY.md` — reusable prompts
- `SPRINT_CHECKLIST.md` — Sprint completion checklist
- `QA_PIPELINE.md` — QA process
- `Docs/AI/AGENTS.md` — product and architecture rules
- `Docs/AI_Collaboration_Playbook_v2.2.md` — AI collaboration standard
- `Docs/Visual/README.md` — visual asset strategy and North Star index (Visual Source of Truth)

---

# Workflow Principles

Every Sprint follows these principles.

- Repository First
- Architecture Before Implementation
- Product Experience Before UI (when applicable)
- Scope Before Code
- Validation Before Approval
- Documentation Before Completion
- **Documentation System Consistency**

### Documentation System Consistency

Documentation quality includes not only the correctness of individual documents, but also the consistency of the documentation system as a whole.

Individual owner documents may be accurate in isolation and still leave the project inconsistent through broken links, conflicting authority, stale planning, or orphaned navigation.

Document Integration Review and Planning Sync exist to protect that system-level consistency.

Repository documentation always takes precedence over conversational memory.

Implementation should improve existing documentation before introducing new governance.

Task slicing is optional and should only be used when it improves safety, validation, or implementation clarity.

When a Sprint primarily delivers user-facing experience,
Product Experience should be defined before UI implementation.

Engineering-only Sprints do not require Experience Review or UI Specification.

---

# Roles

Role detail and collaboration hats live in `Docs/AI/AGENTS.md` and `Docs/AI_Collaboration_Playbook_v2.2.md`. This section summarizes workflow ownership only.

## ChatGPT

Responsible for:

- Requirement analysis and repository context analysis
- Product / UX / Visual direction facilitation (Product Architect, UX Architect, Visual Director hats)
- Architecture design and technical decision support
- Task scope definition
- North Star and Visual Analysis support (Image-Driven Development)
- Cursor prompt creation
- Architecture validation
- Sprint planning support
- DIR / Planning Sync review support when requested

ChatGPT provides architectural and visual guidance but does not replace implementation review or QA performed by Cursor / QA Agent.

---

## Cursor

Responsible for:

- Repository inspection
- Code implementation from approved Cursor prompts
- Test implementation
- Build execution
- Code review
- Technical / Integration QA
- Documentation Pass (owner-document updates)
- Document Integration Review (DIR)
- Planning Sync (PS)
- Structured implementation reports

Cursor must remain inside the approved Sprint scope.

Cursor never commits or pushes.

---

## QA Agent

Responsible for:

- Visual QA against the official North Star image when Image-Driven Development applies
  (layout, spacing, hierarchy, atmosphere, visual similarity)
- Technical QA (build, tests, integration, regression)
- Documentation consistency checks when a Documentation Pass occurred

QA does not redefine Product, Design, Architecture, or Visual direction.

---

## Product Owner (Developer)

Responsible for:

- Product direction
- Product experience and North Star acceptance
- Final decisions
- Visual / device verification as Owner Review
- Product Owner Approval
- Commit
- Push

The Product Owner owns the final product.

---

# Sprint Lifecycle

The standard Sprint Lifecycle is:

```text
1. Experience Review
2. Architecture Review (Decision Record)
3. UI Specification
4. Implementation
5. Product QA
6. Document Integration Review (DIR)
7. Planning Sync (PS)
8. Product Owner Approval
```

### Preconditions (every Sprint)

Before stage 1:

| Step | Purpose |
|------|---------|
| **Sprint Planning** | Goal, scope, out of scope, acceptance criteria (`Docs/ROADMAP.md` priorities) |
| **Repository Context Review** | Required Product / Architecture / process docs and Sprint-specific context |

Output: Approved Sprint Goal and implementation context.

### Applicability

| Stage | Product Experience / UI Sprints | Engineering-only Sprints |
|-------|----------------------------------|---------------------------|
| 1 Experience Review | Required | Skip (or replace with technical problem review) |
| 2 Architecture Review | Required when ownership/structure changes | Required when architecture changes |
| 3 UI Specification | Required for user-facing UI | Skip |
| 4–8 | Required | Required |

Do not reopen postponed platform work (for example Widget or Apple Watch) unless the Roadmap current priority has changed.

---

# Image-Driven Development (Sprint 18+)

From Sprint 18, Product Experience / visual Sprints execute stages 1–5 and 8 through Image-Driven Development.

The approved North Star image is the Visual Source of Truth. Visual implementation follows that image. Written UI descriptions and Visual Analysis sheets supplement it; they do not replace it.

This does not replace DIR or Planning Sync.

```text
Requirements
  → North Star
  → Visual Analysis
  → Implementation
  → Visual QA
  → Approval
```

Canonical mapping inside the Sprint Lifecycle:

```text
North Star Image
  → Visual Analysis (Design Extraction)
  → Cursor Prompt
  → Implementation (stage 4)
  → Self Visual Review
  → Visual QA
  → Technical QA
  → Document Integration Review (DIR)
  → Planning Sync (PS)
  → Owner Review
```

| Image-Driven stage | Canonical home | Purpose |
|--------------------|----------------|---------|
| **Requirements** | Sprint Planning + Stage 1 | Fix Product Vision and Sprint scope before treating any image as authority |
| **North Star** | Stage 1 Experience Review | Accept the official North Star image as Visual Source of Truth |
| **Visual Analysis** | Stage 3 UI Specification | Extract implementable visual rules from the North Star image |
| **Cursor Prompt** | Stage 4 entry | Freeze approved image + analysis + scope into an implementation prompt |
| **Implementation** | Stage 4 | Reproduce the visual language shown in the North Star; preserve architecture |
| **Self Visual Review** | Stage 4 close | Cursor checks layout, spacing, hierarchy, atmosphere, and similarity before handoff |
| **Visual QA** | Stage 5 Product QA | Verify the built UI against the official North Star image |
| **Technical QA** | Stage 5 Product QA | Verify build, tests, integration, and regression |
| **Approval** | Stage 8 Product Owner Approval | Final product and documentation acceptance |

Architecture Review (stage 2) still applies when ownership or structure changes.

Visual assets (North Star images, Design Extraction Sheets, Visual Review Guides) are indexed from `Docs/Visual/README.md`. The latest approved North Star for a surface is that surface's Visual Source of Truth.

Collaboration handoffs: `Docs/AI_Collaboration_Playbook_v2.2.md` (Image-Driven Development).

Engineering-only Sprints continue to skip Experience Review / UI Specification and do not require Image-Driven Development stages.

---

## 1. Experience Review

Define why the experience exists before architecture or UI.

Typical answers:

- Product purpose
- Emotional role
- Guiding principles
- What belongs / does not belong
- Relationship to other surfaces

No UI design. No implementation.

Output:

Approved Experience Review (session artifact or Product document, as appropriate).

---

## 2. Architecture Review (Decision Record)

Convert experience principles into ownership and architectural rules.

Typical outputs:

- Architecture specification under `Docs/Product/` or `Docs/Architecture/`
- Decision Record under `Docs/Architecture/Decisions/` when ownership or structure is lasting

No UI layout. No implementation.

Output:

Accepted Architecture Decision / Architecture Specification.

---

## 3. UI Specification

Translate approved architecture into an implementation-ready presentation contract.

Typical outputs:

- Navigation, hierarchy, copy locks, motion, accessibility contracts
- UI Specification under `Docs/Product/`

No implementation code.

Output:

Approved UI Specification.

---

## 4. Implementation

Cursor implements only the approved scope.

### Implementation activities

- Code and tests within approved architecture and UI contracts
- Build successfully
- Implementation Report
- Code Review (PASS / PASS WITH CONDITIONS / FAIL)
- Fixes for approved findings only — no scope expansion

### Documentation Pass (within Implementation close)

When behavior or contracts change, update **owner documents** before DIR:

- Product behavior → `Docs/Product/`
- Implementation contracts → `Docs/Design/` or `Docs/Extensions/`
- Architecture ownership → `Docs/Architecture/` and Decision Records
- Terminology → `Docs/GLOSSARY.md`
- Owning hub README Active/Historical listings when membership changes
- Repair affected links in the same pass

Documentation Pass updates owner content. It does **not** replace DIR or Planning Sync.

Rules:

- Preserve architecture
- Keep changes small
- Follow project governance
- Never expand scope
- Never commit or push

Output:

Implementation Report + owner-document updates (when required).

---

## 5. Product QA

Verify the product against approved contracts.

### Visual QA (Image-Driven Development / user-facing)

- Compare Simulator or device UI against the official North Star image
- Verify layout, spacing, hierarchy, atmosphere, and visual similarity
- Use Visual Analysis / Design Extraction and Visual Review Guide criteria when present under `Docs/Visual/`
- Source inspection alone cannot validate visual quality

### Technical QA (Cursor / QA Agent)

- Functional behavior
- Lifecycle / persistence / state transitions (as applicable)
- Build and tests
- Regression
- Integration QA result: PASS / PASS WITH CONDITIONS / FAIL

### Product Owner

- Owner Review inputs: Visual QA outcomes, Technical QA outcomes, device verification as needed

Return:

- PASS
- PASS WITH CONDITIONS
- FAIL

Product QA must complete before Document Integration Review.

When Image-Driven Development applies, prefer the order **Visual QA → Technical QA** so visual drift is caught before close-out.

---

## 6. Document Integration Review (DIR)

DIR verifies that the **documentation system** remains internally consistent.

A Sprint is not documentation-complete when individual leaves are correct but the system is not.

### DIR verifies

| Area | Questions |
|------|-----------|
| **Cross references** | Reachable? Broken links? Orphans? Forward/back refs where needed? |
| **Authority** | One source of truth per topic? Unintentional ownership moves? Duplicated decisions? |
| **Ownership** | Surface / domain boundaries still clear? |
| **Terminology** | Consistent product language? Conflicts with Glossary or Principles? |
| **Product consistency** | Aligns with PRODUCT-PRINCIPLES and BRAND? |
| **Documentation navigation** | Hubs index Active leaves? Role entry points still valid? |
| **Orphan documents** | New docs unreachable from hubs? |
| **Contradictions** | Conflicting status, sprint identity, or ownership claims? |

DIR does not redesign product. DIR does not implement code.

Output:

DIR report — findings, recommended fixes, verdict (ready / blocked).

Apply approved documentation fixes before Planning Sync when DIR is blocked.

---

## 7. Planning Sync (PS)

Planning Sync makes planning documents describe **reality**, not obsolete intentions.

### Planning Sync verifies and updates

| Document / concern | Requirement |
|--------------------|-------------|
| `Docs/ROADMAP.md` | Current sprint, status, deferred work, ownership |
| `Docs/CHANGELOG.md` | Completed work only — no invented implementation |
| Root `README.md` | Sprint summaries match ROADMAP |
| Sprint ownership | Unique; no duplicate “planned” owners for the same work |
| Deferred work | Widget / Watch / Future correctly postponed |
| Future sprint alignment | Numbers and names match current plan |

Planning documents must defer to Product / Architecture authorities (PRODUCT-PRINCIPLES, BRAND, Decision Records). They must not duplicate architectural decisions.

Output:

Planning Sync complete — ROADMAP / CHANGELOG / README aligned.

---

## 8. Product Owner Approval

The developer (Product Owner) gives final Sprint approval.

Includes:

- Final product acceptance
- Documentation approval (including DIR + Planning Sync outcomes)
- Commit
- Push

Preferred shape:

One Sprint = One reviewable commit

unless multiple commits improve reviewability.

After approval, prepare Next Sprint Kickoff from `Docs/ROADMAP.md` (remaining debt, current priority, next goal).

---

# Workflow Diagram

```mermaid
flowchart TD
    P[Sprint Planning + Repository Context]
    --> A[1. Experience Review]
    --> B[2. Architecture Review / DR]
    --> C[3. UI Specification]
    --> D[4. Implementation]
    --> E[5. Product QA]

    E -->|Findings| D
    E -->|Approved| F[6. Document Integration Review]
    F -->|Fixes required| F
    F -->|Approved| G[7. Planning Sync]
    G --> H[8. Product Owner Approval]
    H --> I[Next Sprint Kickoff]

    A -.->|Engineering-only may skip| D
    C -.->|Engineering-only may skip| D
```

```text
Sprint Planning + Repository Context
  → 1. Experience Review
  → 2. Architecture Review (Decision Record)
  → 3. UI Specification
  → 4. Implementation (+ Documentation Pass)
  → 5. Product QA
  → 6. Document Integration Review (DIR)
  → 7. Planning Sync (PS)
  → 8. Product Owner Approval
  → Next Sprint Kickoff
```

---

# Relationship to Earlier Stage Names

| Former name | Current home |
|-------------|--------------|
| Product Experience Design (3A) | Stage 1 Experience Review (+ Stage 3 UI Spec) |
| Architecture and Task Design | Stage 2 Architecture Review |
| Code Review / Fixes / Implementation Report | Stage 4 Implementation |
| Integration QA / Visual QA | Stage 5 Product QA |
| Documentation Pass | Stage 4 close (owner updates) |
| Documentation Verification | Expanded into Stage 6 DIR |
| ROADMAP / CHANGELOG updates alone | Stage 7 Planning Sync (systematically) |
| Sprint Review + Developer approval | Stage 8 Product Owner Approval |
| Sprint Retrospective | Capture lessons during Stage 8 / kickoff; update process docs when warranted |

---

# Working Rules

- Repository documentation is the source of truth.
- Required project documents must be reviewed before implementation.
- Scope is approved before implementation.
- Experience and architecture are defined before UI Specification when applicable.
- UI Specification is approved before Implementation when applicable.
- ChatGPT owns architecture, UX facilitation, and Visual Director support.
- Cursor owns implementation quality, DIR, and Planning Sync execution.
- QA Agent owns Visual QA and Technical QA verification against approved contracts.
- Cursor stays inside the approved scope.
- The Product Owner owns the final product and Product Owner Approval.
- Documentation must reflect implemented behavior **and** remain system-consistent (DIR).
- Planning documents must reflect current reality (Planning Sync).
- Architecture changes require explicit approval.
- Task slicing is optional and should only be used when it improves implementation quality.

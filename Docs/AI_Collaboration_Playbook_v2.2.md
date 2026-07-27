# AI Collaboration Playbook v2.2

## OneulRhythm Collaboration Standard

> Stable collaboration rules for ChatGPT (Product Architect, UX Architect,
> Visual Director), Cursor (Implementation), QA Agent, and the Product Owner.
>
> Sprint 12 established the Sprint governance model used from Sprint 13 onward.
> Sprint 18 introduces Image-Driven Development as the official visual workflow
> for Product Experience / visual Sprints. The approved North Star image is the
> Visual Source of Truth.

------------------------------------------------------------------------

# 1. Purpose

Goals

-   Finish the agreed scope before improving it.
-   Reduce prompt drift.
-   Keep Sprint execution predictable.
-   Separate Architecture, Implementation, QA, and Design review.
-   Build a reusable AI-assisted development workflow.
-   Keep Sprint goals and Sprint completion under Product Owner control
    while the Architect owns day-to-day Sprint execution.

------------------------------------------------------------------------

# 2. Golden Rules

1.  Finish before Improve.
2.  Scope is more important than optimization.
3.  Approved means Design Freeze.
4.  Future ideas go to the backlog.
5.  Never surprise the developer.

------------------------------------------------------------------------

# 3. Roles

## Product Owner

Responsibilities

-   Approves Sprint goals.
-   Approves North Star acceptance when Image-Driven Development applies.
-   Approves Sprint completion (Owner Review).
-   Makes product direction decisions.
-   Resolves business trade-offs.
-   Reviews Sprint deliverables as a whole rather than individual
    implementation steps.

The Product Owner is the final decision maker for Sprint objectives and
Sprint close.

------------------------------------------------------------------------

## ChatGPT

ChatGPT does not write production code. It works through three hats
(detail in `Docs/AI/AGENTS.md`):

### Product Architect

-   Sprint planning
-   Architecture design
-   ADR / DR decisions
-   Cursor task planning
-   Architecture review
-   Documentation review
-   Quality gate
-   Sprint close preparation

### UX Architect

-   Interaction and information architecture
-   UX review against Product Principles
-   Surface belonging / non-belonging clarity

### Visual Director (from Sprint 18)

-   Visual composition and atmosphere intent
-   North Star image and Visual Analysis (Design Extraction) support
-   Visual Review Guide criteria
-   Visual QA review against the official North Star image

Authority

-   May approve implementation work during an active Sprint without
    Product Owner approval.
-   Product Owner approval is required for Sprint goals, North Star
    acceptance (Image-Driven Development), and Sprint completion.

Not responsible for

-   Writing production code
-   Expanding approved scope

------------------------------------------------------------------------

## Cursor

Responsibilities

-   Implementation from approved Cursor prompts
-   Documentation
-   Refactoring
-   Build verification
-   Technical / Integration QA support
-   Self Visual Review against the North Star image when Image-Driven
-   Implementation reports

Constraints

-   Must not change architecture independently.
-   Must not introduce new product or visual decisions.
-   When an official North Star image exists, use it as the Visual Source
    of Truth. Do not redesign or reinterpret the UI.

Never redesign architecture.

------------------------------------------------------------------------

## QA Agent

Responsible for

-   Visual QA (when Image-Driven Development applies)
-   Technical QA / scope verification
-   Architecture verification
-   Documentation consistency
-   Release readiness

Visual QA verifies layout, spacing, hierarchy, atmosphere, and visual
similarity against the official North Star image.

Do not redesign.

------------------------------------------------------------------------

# 4. Standard Workflow

Idea

↓

Architecture

↓

Recommendation

↓

Architect Review

↓

Approved

↓

Implementation

↓

QA

↓

Commit

↓

Next Sprint

After **Approved**, no new recommendation cycle begins.

This is the task-level workflow inside an active Sprint.

------------------------------------------------------------------------

# 5. Sprint Lifecycle

The canonical Sprint Lifecycle is defined only in:

`Docs/Development/DEVELOPMENT_WORKFLOW.md`

Standard stages:

1. Experience Review  
2. Architecture Review (Decision Record)  
3. UI Specification  
4. Implementation  
5. Product QA  
6. Document Integration Review (DIR)  
7. Planning Sync (PS)  
8. Product Owner Approval  

From Sprint 18, Product Experience / visual Sprints specialize stages 1–5 and 8 through Image-Driven Development (see Chapter 5A below and `DEVELOPMENT_WORKFLOW.md`).

During the Sprint, Architect and Cursor iterate on planning, implementation, and review inside those stages.

The Product Owner reviews the Sprint as a completed unit (stage 8) rather than approving each implementation step.

Exceptional product decisions may require Product Owner input before Sprint completion.

Do not maintain a second lifecycle definition in this Playbook.

------------------------------------------------------------------------

# 5A. Image-Driven Development

Applies from Sprint 18 to Product Experience / visual Sprints.

Stage authority: `Docs/Development/DEVELOPMENT_WORKFLOW.md`.  
Role detail: `Docs/AI/AGENTS.md`.  
Visual artifact index: `Docs/Visual/README.md`.

This chapter describes collaboration through Image-Driven Development. It does not redefine the canonical Sprint Lifecycle.

Implementation begins by understanding the approved North Star image rather than interpreting text alone. Written descriptions supplement the image; they do not replace it. The latest approved North Star is the Visual Source of Truth for its surface.

## Official flow

```text
Product Vision
  → North Star Image
  → Visual Analysis
  → Implementation
  → Self Visual Review
  → Architect Review
  → Product Owner Approval
```

Canonical mapping inside the Sprint Lifecycle:

```text
North Star Image
  → Visual Analysis (Design Extraction)
  → Cursor Prompt
  → Implementation
  → Self Visual Review
  → Visual QA
  → Technical QA
  → Architect Review
  → Owner Review
```

DIR and Planning Sync still run before Owner Review completes the Sprint.

## Stages (collaboration view)

### Product Vision

Product Owner and ChatGPT (Product Architect) agree on experiential intent and Sprint goal before any visual artifact is treated as authority.

No implementation.

### North Star Image

Product Owner and ChatGPT (Product Architect + Visual Director) accept an official North Star image as the Visual Source of Truth for the Sprint surface.

Output: a versioned North Star image indexed from `Docs/Visual/`.

No implementation. No Visual Analysis sheet yet.

### Visual Analysis

Visual Analysis is an implementation preparation step.

It extracts implementation details from the approved North Star image.

It does not redesign, reinterpret, or evolve the product experience.

Its purpose is implementation fidelity.

ChatGPT (Visual Director + UX Architect) produces the analysis.

Output: Design Extraction Sheet and, when useful, a Visual Review Guide under `Docs/Visual/`.

Written analysis clarifies the image. It does not override it.

No code.

### Cursor Prompt

ChatGPT freezes approved North Star image + Visual Analysis + scope into a Cursor prompt.

After the prompt is approved, design is frozen for the Sprint (Chapter 8 Scope Lock).

### Implementation

Cursor reproduces the visual language shown in the North Star image while preserving project architecture.

Cursor must not redesign or reinterpret the UI.

### Self Visual Review

Cursor compares the built UI to the North Star image before handing off (layout, spacing, hierarchy, atmosphere, visual similarity).

Simulator or Canvas evidence is preferred. Source inspection alone is insufficient.

### Visual QA

QA Agent (with Visual Director review support) verifies layout, spacing, hierarchy, atmosphere, and visual similarity against the official North Star image and Visual Analysis artifacts.

Simulator or device evidence is required. Source inspection alone is insufficient.

### Technical QA

QA Agent / Cursor verify build, tests, integration, and regression against approved functional contracts.

### Architect Review

ChatGPT reviews implementation against Product, Architecture, and Visual Source of Truth constraints.

### Product Owner Approval

Product Owner accepts or rejects the Sprint as a whole, including visual quality and documentation close-out (DIR + Planning Sync).

## Role handoff

| Stage | Primary | Support |
|-------|---------|---------|
| Product Vision | Product Owner | Product Architect |
| North Star Image | Product Owner | Visual Director, Product Architect |
| Visual Analysis | Visual Director | UX Architect |
| Cursor Prompt | Product Architect / Visual Director | — |
| Implementation | Cursor | — |
| Self Visual Review | Cursor | — |
| Visual QA | QA Agent | Visual Director |
| Technical QA | QA Agent / Cursor | — |
| Architect Review | ChatGPT | — |
| Product Owner Approval | Product Owner | ChatGPT Sprint close prep |

## What this does not change

- Architecture Review remains required when ownership or structure changes.
- Product Principles, Brand, and Decision Records remain authoritative over visual taste alone.
- Engineering-only Sprints do not require Image-Driven Development stages.

------------------------------------------------------------------------

# 6. Sprint Governance

Key principles

-   The Architect owns day-to-day Sprint execution.
-   The Product Owner governs Sprint objectives and Sprint completion.
-   Cursor executes approved work.
-   Architecture decisions are centralized through the Architect.
-   Sprint approval occurs once at Sprint completion unless exceptional
    product decisions are required.

This governance model separates Sprint direction from Sprint execution.

Product Owner approval is a Sprint gate, not a step-by-step
implementation gate.

------------------------------------------------------------------------

# 7. Sprint Close Checklist

Before a Sprint is considered complete, the Architect verifies that the
canonical close stages in `Docs/Development/DEVELOPMENT_WORKFLOW.md`
are satisfied, including:

- Architecture / Decision Record consistency  
- Document Integration Review (DIR)  
- Planning Sync (ROADMAP / CHANGELOG / README)  
- Build status (when code changed)  
- Technical debt recorded  
- Sprint Definition of Done  

Sprint completion is recommended only after these checks pass.

After the Architect prepares Sprint close, the Product Owner gives final
Sprint approval (stage 8).

------------------------------------------------------------------------

# 8. Scope Lock

When Architect says **Approved**, the design is frozen.

Allowed

-   Implementation
-   Bug fixes
-   Documentation updates

Not allowed

-   Redesign
-   Unrelated cleanup
-   "While we're here..."

------------------------------------------------------------------------

# 9. Future Improvement Rule

New ideas discovered during implementation are recorded as **Future
Improvements** and never interrupt the current Sprint.

------------------------------------------------------------------------

# 10. Architect Operating Rules

Always

-   Solve the requested scope first
-   Separate optional ideas
-   Explain decisions clearly
-   Avoid hidden scope expansion

Never

-   Redesign after approval
-   Mix implementation with future planning
-   Introduce hidden scope

------------------------------------------------------------------------

# 11. Standard Prompt Template

1.  Goal
2.  Context
3.  Required References
4.  Scope
5.  Constraints
6.  Validation
7.  Self Review
8.  Output Format

------------------------------------------------------------------------

# 12. Required References Matrix

  Area            References
  --------------- ---------------------------------------------
  Product         Product / Design / Architecture / AGENTS
  Architecture    ADR / Reviews / Architecture Hub
  Sprint          Sprint Review / Roadmap / Changelog
  Documentation   Docs Hub / Workflow / Checklist / AGENTS
  AI Workflow     AGENTS / Cursor Guidelines / Prompt Library

------------------------------------------------------------------------

# 13. Prompt Checklist

-   Goal
-   Context
-   Explicit Scope
-   Required References
-   Constraints
-   Validation
-   Self Review
-   Output Format

------------------------------------------------------------------------

# 14. Prompt Anti-patterns

Avoid

-   maybe
-   if possible
-   improve further
-   additionally
-   feel free
-   as needed

Prefer

-   implement only
-   do not modify
-   keep unchanged
-   verify
-   report

------------------------------------------------------------------------

# 15. Architect Review Checklist

-   Scope satisfied
-   Architecture preserved
-   Product principles respected
-   Documentation reviewed
-   Validation completed

------------------------------------------------------------------------

# 16. QA Checklist

Verify only

-   Requested scope
-   Validation
-   Architecture
-   Documentation
-   Build status

------------------------------------------------------------------------

# 17. Definition of Done

Done means

-   Scope complete
-   Validation complete
-   QA complete
-   Documentation updated (if required)
-   Ready to commit

------------------------------------------------------------------------

# 18. Common Mistakes

-   Missing references
-   Prompt structure changes
-   Scope expansion
-   Missing validation
-   Missing self review
-   Undefined output
-   Mixing recommendations with implementation
-   New architecture after approval

------------------------------------------------------------------------

# 19. Communication Rules

Always separate

-   Requested Scope
-   Optional Improvements

Optional improvements never become implementation automatically.

------------------------------------------------------------------------

# 20. OneulRhythm Principles

The project values consistency over cleverness.

Architecture evolves Sprint by Sprint.

Every Sprint ends cleanly before the next begins.

------------------------------------------------------------------------

# 21. Design Collaboration

## Design Mission

OneulRhythm is not simply a habit tracker.

It is a product that helps users experience a calmer, softer day.

Every design decision should strengthen that experience.

## Design Review Process

1.  Observation
2.  Reason
3.  Product Principle
4.  Reference
5.  OneulRhythm Direction
6.  Implementation Cost

Never recommend changes only because they look better.

## Design Principles

### Calm before Pretty

Comfort comes before visual appeal.

### Meaningful Beauty

Every visual element should have a purpose.

### Remove Before Add

Prefer removing low-value features before introducing new ones.

### Delight in Small Moments

Small interactions create emotional satisfaction.

### One Beautiful Moment per Screen

Every screen should contain one memorable focal point.

### Brand before Feature

Choose experiences that reinforce the OneulRhythm identity.

### Does this make today softer?

Every UI decision should answer:

> Does this make the user's day feel a little softer?

## Design Review Checklist

Before approving a UI change:

-   Improves usability
-   Strengthens product identity
-   Reduces unnecessary complexity
-   Creates one memorable moment
-   Makes today feel a little softer

------------------------------------------------------------------------

# 22. Quality Vision

**Store Quality over MVP**

MVP is the starting point, not the destination.

Every improvement should move OneulRhythm toward a product that users
enjoy keeping on their Home Screen and returning to every day.


------------------------------------------------------------------------

# 23. Architecture Decision Quality

## Why This Exists

As OneulRhythm evolved beyond a functional MVP, the goal expanded from
shipping features to delivering an App Store-quality experience.

During Sprint planning, we considered introducing additional design
documents such as UI Guides, Asset Guides, and Motion Guides.

After evaluation, we concluded that increasing documentation would add
maintenance cost and process complexity without proportional value.

Instead, we decided to improve the quality and completeness of
Architecture Decisions.

This chapter records that decision.

------------------------------------------------------------------------

## Core Decision

Do not increase process complexity.

Increase the quality of decisions.

Architecture Decisions should reduce uncertainty before implementation
begins.

------------------------------------------------------------------------

## Architecture Decisions are Design Documents

OneulRhythm does not maintain separate design specifications unless a
recurring problem justifies them.

Instead, every Architecture Decision should contain enough design
context for implementation.

Each Architecture Decision becomes both:

- Architecture Contract
- Lightweight Design Specification

------------------------------------------------------------------------

## Required Design Context

When appropriate, include:

- Product Goal
- UX Intent
- Text-based Wireframe
- Visual Hierarchy
- Design Notes
- Implementation Notes

Only include information that removes ambiguity.

------------------------------------------------------------------------

## Design Clarity over Process

Prefer

- Better Architecture Decisions
- Better prompts
- Better implementation guidance

Instead of

- More documents
- More templates
- More approval stages

Documentation should become denser, not larger.

------------------------------------------------------------------------

## AI Collaboration Principle

ChatGPT removes ambiguity before implementation.

Cursor implements.

Cursor should never need to guess:

- Product intent
- UX intent
- Visual hierarchy
- Layout purpose

Planning should eliminate unnecessary interpretation.

------------------------------------------------------------------------

## Success Criteria

A successful Architecture Decision enables implementation with minimal
clarification.

If implementation repeatedly requires clarification about UX,
interaction, or layout, the planning phase was incomplete.

Good planning reduces uncertainty rather than coding effort.

------------------------------------------------------------------------

## Relationship to Existing Principles

This chapter extends—not replaces—the existing collaboration model.

It supports:

- Chapter 18: Design Collaboration
- Chapter 19: Quality Vision

------------------------------------------------------------------------

## Philosophy

> Don't add more process.
>
> Increase the quality of decisions.

The Playbook is not only a rulebook.

It is the historical record of why those rules exist.

The objective is App Store-quality user experience without
App Store-scale process.

------------------------------------------------------------------------

# 24. Simulator vs Physical Device

## Rule

Never perform architecture refactoring based solely on simulator
behavior.

Before changing architecture, at least one of the following must exist:

- Physical-device verification confirming the issue
- A reproducible issue across clean simulator environments
- Clear runtime evidence directly linking the problem to the proposed
  architectural cause

Simulator-only behavior is insufficient evidence for architecture
changes.

When simulator and physical-device behavior conflict, treat the
simulator result as a hypothesis until additional evidence is
collected.

Evidence always takes priority over intuition.

## Relationship

This is an engineering workflow rule, not a Decision Record.

It applies to Architect recommendations and Implementation Agent
investigation alike.

Verification process: `Docs/Development/QA_PIPELINE.md`  
Collaboration constraints: `Docs/AI/AGENTS.md`

------------------------------------------------------------------------

# 25. Documentation Freshness Rule

## Why This Exists

Project documents change as Sprints progress.

Architecture recommendations based on outdated memory create drift,
incorrect scope, and avoidable rework.

The Architect must verify the latest project documentation before making
recommendations.

------------------------------------------------------------------------

## Source of Truth

Project documents are the source of truth.

Never rely on memory when document status may have changed.

If memory and documents conflict, documents win.

------------------------------------------------------------------------

## Required Verification

Before making recommendations, the Architect must verify:

- Current DR list
- Latest Architecture Decisions
- Roadmap
- Sprint status
- Changelog when applicable

Verification is required even when the Architect believes the documents
have not changed.

------------------------------------------------------------------------

## Operating Rule

Always

- Read the latest documents first
- Base recommendations on verified current state
- Call out document conflicts when found

Never

- Recommend from memory alone
- Assume previous Sprint context is still valid
- Skip freshness checks to save time

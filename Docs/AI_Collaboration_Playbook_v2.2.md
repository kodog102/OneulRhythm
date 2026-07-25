# AI Collaboration Playbook v2.2

## OneulRhythm Collaboration Standard

> Stable collaboration rules for ChatGPT (Architect), Cursor
> (Implementation), QA, and the Developer.

------------------------------------------------------------------------

# 1. Purpose

Goals

-   Finish the agreed scope before improving it.
-   Reduce prompt drift.
-   Keep Sprint execution predictable.
-   Separate Architecture, Implementation, QA, and Design review.
-   Build a reusable AI-assisted development workflow.

------------------------------------------------------------------------

# 2. Golden Rules

1.  Finish before Improve.
2.  Scope is more important than optimization.
3.  Approved means Design Freeze.
4.  Future ideas go to the backlog.
5.  Never surprise the developer.

------------------------------------------------------------------------

# 3. Roles

## Architect (ChatGPT)

Responsible for

-   Product direction
-   Architecture
-   Product & UX review
-   Sprint planning
-   Prompt creation
-   Final approval

Additionally acts as

-   Product Designer
-   UX Reviewer
-   Brand Guardian

Not responsible for

-   Writing production code
-   Expanding approved scope

------------------------------------------------------------------------

## Cursor

Responsible for

-   Implementation
-   Small approved documentation updates
-   Build verification
-   Reporting

Never redesign architecture.

------------------------------------------------------------------------

## QA

Responsible for

-   Scope verification
-   Architecture verification
-   Documentation consistency
-   Release readiness

Do not redesign.

------------------------------------------------------------------------

## Developer

Final decision maker.

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

------------------------------------------------------------------------

# 5. Scope Lock

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

# 6. Future Improvement Rule

New ideas discovered during implementation are recorded as **Future
Improvements** and never interrupt the current Sprint.

------------------------------------------------------------------------

# 7. Architect Operating Rules

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

# 8. Standard Prompt Template

1.  Goal
2.  Context
3.  Required References
4.  Scope
5.  Constraints
6.  Validation
7.  Self Review
8.  Output Format

------------------------------------------------------------------------

# 9. Required References Matrix

  Area            References
  --------------- ---------------------------------------------
  Product         Product / Design / Architecture / AGENTS
  Architecture    ADR / Reviews / Architecture Hub
  Sprint          Sprint Review / Roadmap / Changelog
  Documentation   Docs Hub / Workflow / Checklist / AGENTS
  AI Workflow     AGENTS / Cursor Guidelines / Prompt Library

------------------------------------------------------------------------

# 10. Prompt Checklist

-   Goal
-   Context
-   Explicit Scope
-   Required References
-   Constraints
-   Validation
-   Self Review
-   Output Format

------------------------------------------------------------------------

# 11. Prompt Anti-patterns

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

# 12. Architect Review Checklist

-   Scope satisfied
-   Architecture preserved
-   Product principles respected
-   Documentation reviewed
-   Validation completed

------------------------------------------------------------------------

# 13. QA Checklist

Verify only

-   Requested scope
-   Validation
-   Architecture
-   Documentation
-   Build status

------------------------------------------------------------------------

# 14. Definition of Done

Done means

-   Scope complete
-   Validation complete
-   QA complete
-   Documentation updated (if required)
-   Ready to commit

------------------------------------------------------------------------

# 15. Common Mistakes

-   Missing references
-   Prompt structure changes
-   Scope expansion
-   Missing validation
-   Missing self review
-   Undefined output
-   Mixing recommendations with implementation
-   New architecture after approval

------------------------------------------------------------------------

# 16. Communication Rules

Always separate

-   Requested Scope
-   Optional Improvements

Optional improvements never become implementation automatically.

------------------------------------------------------------------------

# 17. OneulRhythm Principles

The project values consistency over cleverness.

Architecture evolves Sprint by Sprint.

Every Sprint ends cleanly before the next begins.

------------------------------------------------------------------------

# 18. Design Collaboration

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

# 19. Quality Vision

**Store Quality over MVP**

MVP is the starting point, not the destination.

Every improvement should move OneulRhythm toward a product that users
enjoy keeping on their Home Screen and returning to every day.


------------------------------------------------------------------------

# 20. Architecture Decision Quality

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

# 21. Documentation Freshness Rule

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

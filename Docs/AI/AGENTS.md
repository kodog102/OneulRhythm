# AGENTS

This document defines the collaboration model, product philosophy, and architectural rules for AI agents contributing to OneulRhythm.

Sprint workflows, implementation prompts, Cursor guidelines, QA processes, and close-out checklists are defined under `Docs/Development/`.

Stable collaboration rules for ChatGPT, Cursor, QA, and the Developer are defined in:

`Docs/AI_Collaboration_Playbook_v2.2.md`

This document complements, but does not replace, the official Development Workflow or the AI Collaboration Playbook.

---

# Core Principles

All contributors should follow these principles.

## Documentation First

Implementation follows approved documentation.

Conversation helps decisions.

Documentation preserves decisions.

Never implement directly from conversation alone.

---

## Artifact First

Every meaningful Product, Design, or Architecture discussion must produce or update an approved project artifact before implementation begins.

Conversation is temporary.

Documentation is the project's shared memory.

---

## Product UI First

User experience is designed before implementation.

Implementation exists to express approved Product decisions.

Implementation Agents never redesign the product.

---

# Roles

Collaboration roles follow the official Development Workflow.

## ChatGPT (Architect)

Responsible for:

- Requirement analysis
- Product design facilitation
- Architecture design
- Technical direction
- Task scope definition
- Artifact definition
- Documentation impact identification
- Cursor prompt creation
- Code and architecture review
- QA result review
- Documentation review
- Sprint approval

Before implementation begins, ChatGPT identifies:

- which project artifact should be created or updated
- which owner documents are affected
- whether Product, Design, Architecture/ADR, or process docs must change

ChatGPT does not modify repository code.

---

## Cursor (Implementation Agent)

Responsible for:

- Code implementation
- Test implementation
- Build execution
- Integration QA
- Owner-document updates during Documentation Pass
- Hub README maintenance when membership changes
- Link repair for affected documentation
- Structured implementation reports

Cursor implements approved Product and Architecture decisions.

Cursor must not create:

- Product decisions
- Design decisions
- Architecture decisions

When documentation is incomplete, ambiguous, or ownership is unclear:

- Stop implementation.
- Report the ambiguity.
- Request clarification.

Never silently invent Product behavior.

Never treat Archived documents as implementation authority.

Cursor never commits or pushes unless explicitly requested by the developer.

---

## QA

QA verifies that implemented behavior matches Active documentation contracts.

QA must:

- distinguish contract gaps from implementation bugs
- confirm Archived documents were not used as implementation authority
- verify documentation consistency when a Documentation Pass occurred

QA does not redefine Product, Design, or Architecture.

---

## Developer

Responsible for:

- Final decisions
- Product direction
- Running the application
- Manual visual verification
- Documentation approval
- Sprint approval
- Commit and push

Only the developer commits and pushes.

Documentation state transitions (Active, Archived, Superseded ADR, Delete) require developer approval.

---

# Development Workflow

Follow the official Sprint pipeline defined in:

`Docs/Development/DEVELOPMENT_WORKFLOW.md`

Canonical Sprint Lifecycle:

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

Do not redefine this lifecycle in AGENTS, the Playbook, or other process docs. Reference `DEVELOPMENT_WORKFLOW.md`.

Related process documents:

- Docs/AI_Collaboration_Playbook_v2.2.md
- Docs/Development/PROMPT_LIBRARY.md
- Docs/Development/CURSOR_GUIDELINES.md
- Docs/Development/SPRINT_CHECKLIST.md
- Docs/Development/QA_PIPELINE.md

No process step should be skipped without explicit developer approval.

---

# Product Philosophy

Canonical product philosophy: `Docs/Product/PRODUCT-PHILOSOPHY.md`.

Every implementation should preserve these principles.

## Calm

Never introduce stressful or attention-seeking UX.

---

## Rhythm

The application exists to support today's rhythm.

Not productivity.

Not task management.

---

## Simplicity

Prefer small improvements.

Avoid unnecessary rewrites.

---

## Shared Source of Truth

Scheduling logic belongs to:

- Schedule Engine

Business output is represented by:

- ResolvedSchedule

Presentation models are created by:

- Mappers

Presentation orchestration belongs to:

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

Views must remain lightweight.

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

Mappers must never contain:

- Business rules
- Persistence
- Framework lifecycle logic

---

## Repository

Responsible for persistence only.

---

## Services

Responsible for infrastructure and external systems.

Never mix responsibilities across architectural layers.

---

# Appearance Rules

Warm Light Appearance is product policy (DR-021).

- The app shell owns appearance via `INFOPLIST_KEY_UIUserInterfaceStyle = Light`.
- Feature views must not set `preferredColorScheme` independently.
- Do not add an in-app Light / Dark / Automatic Appearance control in Settings.
- Consume Design System tokens from `OneulRhythmShared/DesignSystem/`; do not invent local color schemes.
- Live Activity presentation must reuse the same tokens / Visual Language Specification.

Authority:

- `Docs/Architecture/Decisions/DR-021-visual-identity-warm-light-appearance.md`
- `Docs/Design/Visual-Language-Specification.md`

---

# Live Activity Rules

Only one Live Activity may exist per day.

Never create one Live Activity per rhythm.

Live Activity represents:

- Current Rhythm
- Past Rhythm
- Next Rhythm
- Today's Flow

Notifications remain secondary.

DEBUG ActivityKit platform QA (`-ORLiveActivityPlatformQA*`) is Debug-only reusable tooling. Production builds must never depend on it.

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

Avoid user-facing words such as:

- Failed
- Missed
- Overdue
- Urgent
- Warning

Prefer:

- Current Rhythm
- Past Rhythm
- Next Rhythm
- Continue
- Today
- Gently

---

# Documentation Rules

Documentation reflects both implementation and approved decisions.

Implementation should never become the primary source of truth.

Approved decisions must exist in documentation before implementation begins.

---

## Required References Before Implementation

Before implementation begins, AI agents should review:

1. Product Principles — `Docs/Product/PRODUCT-PRINCIPLES.md`
2. Architecture — `Docs/Architecture/ARCHITECTURE.md`
3. AI Collaboration Playbook — `Docs/AI_Collaboration_Playbook_v2.2.md`
4. Relevant Architecture Decision(s) — `Docs/Architecture/Decisions/`
5. Roadmap — `Docs/ROADMAP.md` (when applicable)

For Brand Foundation and Brand Assets work, also review:

- `Docs/BRAND.md`
- `Docs/ADR/`
- `Assets/brand/ASSET-MANIFEST.md` (when working with brand files)
- `Assets/brand/Guide/` (when applying or exporting brand assets)

Then continue with Sprint-specific Product and/or Design documents as needed.

---

## Documentation Hierarchy

AI implementation agents should read process and governance documents in this order:

1. `Docs/AI/AGENTS.md`
2. `Docs/AI_Collaboration_Playbook_v2.2.md`
3. `Docs/Development/DEVELOPMENT_WORKFLOW.md`
4. `Docs/Development/CURSOR_GUIDELINES.md`
5. `Docs/Engineering/ENGINEERING_CHARTER.md`
6. Sprint-specific Product and/or Design documents
7. `Docs/ROADMAP.md` (priority only)

Use `Docs/GLOSSARY.md` as the shared terminology reference when terms are unclear.

When conflicts exist:

README

↓

PRODUCT-PRINCIPLES

↓

BRAND

↓

Brand ADR

↓

Architecture

↓

Architecture Decision Records

↓

Design

↓

Extensions

↓

Development

Process conflicts are resolved by:

`Docs/Development/DEVELOPMENT_WORKFLOW.md`

Avoid circular navigation between documentation hubs.

---

## Documentation Responsibilities

Product documents define product decisions and UX contracts.

Architecture documents define system structure.

Decision Records explain why architectural decisions exist.

Design documents define implementation contracts.

Extensions describe optional capabilities.

Development documents define engineering processes.

The AI Collaboration Playbook defines stable collaboration rules across ChatGPT, Cursor, QA, and the Developer.

Hub READMEs index Active and Historical documents for their folder.

Roadmap defines future direction.

Changelog records completed work.

Archived documents are historical only. They are never implementation authority.

---

## Documentation Updates

Update the owner document only. Link instead of duplicating doctrine.

### Product Behavior Changes

Update:

- Product documentation first
- CHANGELOG

Update Design only when the implementation contract also changed.

---

### Implementation Contract Changes

Update:

- Design documentation
- Extensions documentation when an extension contract changed

---

### Architecture Ownership Changes

Update:

- Architecture documentation
- Decision Records

---

### Hub Membership Changes

When a document is added, archived, moved, or removed:

- Update the owning hub README Active/Historical listing
- Update `Docs/README.md` only if categories, paths, or role entry points change
- Repair affected links in the same Documentation Pass

---

### Terminology Changes

Update:

- `Docs/GLOSSARY.md`

---

### Sprint Completion

Complete Document Integration Review (DIR) and Planning Sync (PS) per `Docs/Development/DEVELOPMENT_WORKFLOW.md`.

Update:

- ROADMAP
- CHANGELOG
- Root README when sprint summaries are affected

Documentation should remain synchronized with the current state of the project.

Documentation maintenance follows:

Architect (identify impact)

↓

Cursor (update owner docs, hubs, DIR, Planning Sync)

↓

QA (verify consistency)

↓

Developer (Product Owner Approval)

---

# QA Rules

Never claim verification that was not actually performed.

Always distinguish:

✅ Verified

⚠️ Not Verified

Visual polish must be confirmed using Simulator or Xcode Canvas.

Source inspection alone cannot validate UX quality.

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

A Sprint is complete only when the relevant stages of the Development Workflow have been satisfied.

Including:

- Approved scope implemented (when the Sprint includes implementation)
- Build completed successfully (when code changed)
- Relevant tests passed (when code changed)
- Architecture preserved
- Code Review completed (when code changed)
- Product QA completed (Integration QA + Visual/Device as applicable)
- Document Integration Review (DIR) completed
- Planning Sync (PS) completed
- Product Owner Approval

Only then should the developer commit and push.

See `Docs/Development/DEVELOPMENT_WORKFLOW.md` for stage definitions.

---

# Guiding Questions

Every implementation should answer these questions.

> Does this implementation help users stay connected with today's rhythm?

> Is this behavior already documented?

> Am I implementing an approved decision, or accidentally creating a new one?

If the answer to the final question is "creating a new one,"

implementation should stop until the appropriate documentation has been updated.
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

# Visual Authority

When an official North Star image exists, it is the project's Visual Source of Truth for that surface.

- Cursor implements the approved image rather than redesigning it.
- Written UI specifications supplement the image; they do not replace it.
- If no North Star exists yet, the Product Architect defines visual direction through documentation until an official North Star is approved.

---

# Roles

Collaboration roles follow the official Development Workflow.

From Sprint 18, Product Experience / visual Sprints follow Image-Driven Development defined in `Docs/Development/DEVELOPMENT_WORKFLOW.md` and described for collaboration in `Docs/AI_Collaboration_Playbook_v2.2.md`.

## Product Owner (Developer)

Responsible for:

- Product direction and Sprint goals
- North Star acceptance (when Image-Driven Development applies)
- Final visual judgment after Visual QA
- Documentation state transitions (Active, Archived, Superseded ADR, Delete)
- Sprint approval (Product Owner Approval)
- Commit and push

Only the Product Owner commits and pushes.

The Product Owner reviews the Sprint as a completed unit rather than approving every implementation step.

---

## ChatGPT

ChatGPT does not modify repository code.

It operates through three complementary hats. One conversation may use one or more hats; the hat in use must be explicit.

### Product Architect

Responsible for:

- Requirement analysis
- Product meaning and experience boundaries
- Architecture design and technical direction
- Task scope definition
- Artifact definition and documentation impact identification
- Architecture / Decision Record support
- Code and architecture review
- Documentation review
- Sprint close preparation

### UX Architect

Responsible for:

- Interaction and information architecture
- Product design facilitation within approved experience boundaries
- UX review against Product Principles and calm-first rules
- Clarifying what belongs / does not belong on a surface

### Visual Director (from Sprint 18)

Responsible for:

- Visual composition, atmosphere, and hierarchy intent
- North Star definition support (visual target for the Sprint)
- Design Extraction Sheet authorship support
- Visual Review Guide criteria
- Visual QA review against North Star and Design Extraction
- Ensuring Cursor prompts carry visual intent, not only functional scope

Visual Director does not invent Product behavior or Architecture ownership.

Before implementation begins, ChatGPT (in the appropriate hat) identifies:

- which project artifact should be created or updated
- which owner documents are affected
- whether Product, Design, Architecture/ADR, Visual, or process docs must change
- the Cursor prompt that freezes approved scope

---

## Cursor (Implementation Agent)

Responsible for:

- Code implementation from approved contracts and Cursor prompts
- Test implementation
- Build execution
- Technical / Integration QA support
- Owner-document updates during Documentation Pass
- Hub README maintenance when membership changes
- Link repair for affected documentation
- Document Integration Review (DIR) and Planning Sync (PS) execution
- Structured implementation reports

Cursor implements approved Product, Architecture, and Visual decisions.

### Image-Driven Development (when a North Star image exists)

- Use the official North Star image as the Visual Source of Truth.
- Do not redesign or reinterpret the UI.
- Implement the visual language shown in the image.
- Written UI descriptions and Design Extraction Sheets supplement the image; they do not replace it.
- Preserve project architecture while reproducing the approved visual design.
- Begin by understanding the approved image, not by interpreting text alone.

Cursor must not create:

- Product decisions
- Design decisions
- Architecture decisions
- Visual direction (North Star or Design Extraction)

When documentation is incomplete, ambiguous, or ownership is unclear:

- Stop implementation.
- Report the ambiguity.
- Request clarification.

Never silently invent Product behavior.

Never treat Archived documents as implementation authority.

Cursor never commits or pushes unless explicitly requested by the Product Owner.

---

## QA Agent

QA verifies that implemented behavior matches Active documentation contracts.

QA must:

- run Visual QA against the official North Star image (and Design Extraction / Visual Review Guide when present) when Image-Driven Development applies
- verify layout, spacing, hierarchy, atmosphere, and visual similarity against the North Star image
- run Technical QA (build, tests, integration, regression) against approved functional contracts
- distinguish contract gaps from implementation bugs
- confirm Archived documents were not used as implementation authority
- verify documentation consistency when a Documentation Pass occurred

QA does not redefine Product, Design, Architecture, or Visual direction.

---

# Collaboration Flow (Image-Driven Development, Sprint 18+)

When a Sprint is Product Experience / visual:

```text
Product Vision
  → North Star Image
  → Visual Analysis
  → Implementation
  → Self Visual Review
  → Architect Review
  → Product Owner Approval
```

Role handoff for the same path:

```text
Product Owner
  → ChatGPT (Product Architect / UX Architect / Visual Director)
      → North Star Image (Visual Source of Truth)
      → Visual Analysis (Design Extraction)
      → Cursor Prompt
  → Cursor (implementation + Self Visual Review)
  → QA Agent (Visual QA → Technical QA)
  → ChatGPT (Architect Review)
  → Product Owner (Owner Review / approval)
```

Visual assets and review guides live under `Docs/Visual/`. The latest approved North Star image is the Visual Source of Truth for its surface.

Canonical stage definitions remain in `Docs/Development/DEVELOPMENT_WORKFLOW.md`.

Collaboration norms remain in `Docs/AI_Collaboration_Playbook_v2.2.md`.

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

Image-Driven Development (Sprint 18+, Product Experience / visual Sprints) specializes stages 1–5 and 8:

```text
Requirements
  → North Star
  → Visual Analysis
  → Implementation
  → Visual QA
  → Approval
```

Mapped collaboration detail: North Star Image → Visual Analysis (Design Extraction) → Cursor Prompt → Implementation → Self Visual Review → Visual QA → Technical QA → Architect Review → Owner Review.

DIR and Planning Sync remain required close-out stages.

Do not redefine this lifecycle in AGENTS, the Playbook, or other process docs. Reference `DEVELOPMENT_WORKFLOW.md`.

Related process documents:

- Docs/AI_Collaboration_Playbook_v2.2.md
- Docs/Development/PROMPT_LIBRARY.md
- Docs/Development/CURSOR_GUIDELINES.md
- Docs/Development/SPRINT_CHECKLIST.md
- Docs/Development/QA_PIPELINE.md
- Docs/Visual/README.md

No process step should be skipped without explicit Product Owner approval.

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

When Image-Driven Development applies, also review:

- `Docs/Visual/README.md`
- the official North Star image and Design Extraction Sheet indexed there
- `Docs/AI_Collaboration_Playbook_v2.2.md` Chapter 5A (Image-Driven Development)

---

## Documentation Hierarchy

AI implementation agents should read process and governance documents in this order:

1. `Docs/AI/AGENTS.md`
2. `Docs/AI_Collaboration_Playbook_v2.2.md`
3. `Docs/Development/DEVELOPMENT_WORKFLOW.md`
4. `Docs/Development/CURSOR_GUIDELINES.md`
5. `Docs/Engineering/ENGINEERING_CHARTER.md`
6. Sprint-specific Product and/or Design documents
7. `Docs/Visual/README.md` (when Image-Driven / North Star artifacts exist)
8. `Docs/ROADMAP.md` (priority only)

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

Visual (Sprint artifacts only)

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

`Docs/Visual/` indexes Sprint visual assets (North Star images, Design Extraction Sheets, Visual Review Guides) and names the latest approved North Star as Visual Source of Truth. It does not redefine Product or Design contracts.

The AI Collaboration Playbook defines stable collaboration rules across ChatGPT, Cursor, QA, and the Product Owner.

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

ChatGPT (identify impact)

↓

Cursor (update owner docs, hubs, DIR, Planning Sync)

↓

QA Agent (verify consistency)

↓

Product Owner Approval

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
- Product QA completed (Visual QA + Technical QA as applicable)
- Document Integration Review (DIR) completed
- Planning Sync (PS) completed
- Product Owner Approval

Only then should the Product Owner commit and push.

See `Docs/Development/DEVELOPMENT_WORKFLOW.md` for stage definitions.

---

# Guiding Questions

Every implementation should answer these questions.

> Does this implementation help users stay connected with today's rhythm?

> Is this behavior already documented?

> Am I implementing an approved decision, or accidentally creating a new one?

If the answer to the final question is "creating a new one,"

implementation should stop until the appropriate documentation has been updated.
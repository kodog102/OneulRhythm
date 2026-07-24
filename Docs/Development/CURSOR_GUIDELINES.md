# Cursor Guidelines

Project-wide execution rules for Cursor when contributing to OneulRhythm.

These guidelines apply to implementation, validation, QA, refactoring, and documentation work unless a prompt explicitly overrides them.

Cursor is responsible for executing approved work—not defining project direction.

Related documents:

- `Docs/Engineering/ENGINEERING_CHARTER.md`
- `DEVELOPMENT_WORKFLOW.md`
- `PROMPT_LIBRARY.md`
- `SPRINT_CHECKLIST.md`
- `Docs/AI/AGENTS.md`

---

# Repository First

The repository is the single source of truth.

Before making implementation decisions:

- Read the required project documents.
- Review Sprint-specific documentation.
- Inspect the affected source code.
- Base decisions on repository content rather than conversational memory.

When repository documentation and conversational context differ, the repository takes precedence.

Do not rely on assumptions or incomplete context.

---

# Current Project Priority

The Notification Foundation is complete and stable.

Until Product UI reaches MVP quality, all implementation work should prioritize the in-app experience over Widgets, Apple Watch, or additional platform integrations.

When implementing approved Product UI work:

- Reuse the existing Snapshot, Schedule Engine, Mapping, Notification, and Live Activity architecture.
- Avoid introducing new business logic unless the approved Product UI scope requires it.
- Do not expand into Widget, Watch, or other platform surfaces unless the current Sprint explicitly includes them.

Future platform integrations should consume the existing architecture instead of redefining it.

See `Docs/ROADMAP.md` and `Docs/Architecture/Decisions/DR-014-product-ui-first.md`.

---

# Required Context

Before implementation begins, review the required project documentation.

Mandatory project documents:

- `Docs/Engineering/ENGINEERING_CHARTER.md`
- `DEVELOPMENT_WORKFLOW.md`
- `CURSOR_GUIDELINES.md`

Then review Sprint-specific documentation as needed.

Examples include:

- Architecture Decisions
- Design documents
- Roadmap
- Changelog
- Feature documentation
- Existing implementation
- Existing tests

Implementation should begin only after sufficient context has been gathered.

---

# Before Editing

Before making any changes:

- Read the affected source code.
- Understand the existing architecture.
- Follow established naming conventions.
- Search for existing tests.
- Verify a file or symbol is unused before removing it.

Do not make implementation decisions based on assumptions.

---

# Scope Control

- Modify only the approved scope.
- Do not redesign architecture without explicit approval.
- Do not rename public APIs without approval.
- Do not add dependencies without approval.
- Do not perform unrelated cleanup.
- Do not introduce speculative abstractions.
- Prefer the smallest change that satisfies the approved requirements.

When uncertain,

stop and report the ambiguity rather than making assumptions.

---

# Architecture

- Preserve established layer boundaries.
- Respect existing architecture.
- Keep domain logic independent where intended.
- Respect `@MainActor` isolation.
- Respect SwiftData `ModelContext` ownership.
- Keep ViewModels free from application composition.
- Keep App composition free from feature coupling.
- Avoid hidden global state.
- Avoid unnecessary singletons.

Primary dependency direction:

```text
Data
    ↓
Business
    ↓
Mapping
    ↓
Presentation
```

Do not reverse dependencies.

Do not duplicate business logic in the Presentation layer.

---

# Implementation Principles

Every implementation should:

- Preserve existing behavior.
- Keep changes small.
- Be deterministic.
- Prefer explicit behavior.
- Prefer documented platform APIs.
- Avoid unnecessary complexity.

Task slicing is optional.

Use slices only when they improve implementation safety, validation clarity, or reduce implementation complexity.

Do not split work mechanically.

---

# Testing

- Add or update tests for changed behavior.
- Run the relevant build.
- Run the relevant test suite.
- Report skipped scenarios.
- Report unverified scenarios.
- Never claim manual validation that was not performed.

A successful build does not replace testing.

---

# Documentation

Update documentation only:

- when requested,
- or during an approved Documentation Pass.

Update existing documentation before introducing new documentation.

Avoid creating new governance unless repeated evidence shows that existing documentation is insufficient.

Clearly identify:

- unresolved decisions
- assumptions
- future work

Keep terminology consistent with:

- `Docs/GLOSSARY.md`

---

# Git

Never:

- Commit
- Push
- Rewrite Git history
- Modify repository configuration

Commit and Push are developer-owned responsibilities.

---

# Reporting

Every implementation report must include:

1. Modified Files
2. Implementation Summary
3. Architecture Notes
4. Test Results
5. Build Results
6. Manual Verification Required
7. Remaining Risks or Issues

Reports should be:

- factual
- concise
- limited to the approved scope

Do not report work that was not performed.

---

# General Behavior

When uncertain:

- Ask for clarification.
- Do not guess.
- Do not silently expand scope.
- Do not silently redesign architecture.

Prefer predictable engineering over clever engineering.

Repository consistency is always more important than conversational convenience.
# Cursor Guidelines

Project-wide working rules for Cursor when contributing to OneulRhythm.

These guidelines apply to implementation, QA, refactoring, and documentation work unless a prompt explicitly overrides them.

Related documents:

- `DEVELOPMENT_WORKFLOW.md`
- `PROMPT_LIBRARY.md`
- `SPRINT_CHECKLIST.md`
- `Docs/AI/AGENTS.md` — product philosophy and architecture rules

---

## Before Editing

Before making any changes:

- Read the relevant source code and documentation.
- Understand the existing architecture and naming conventions.
- Search for existing tests covering the affected behavior.
- Verify that a file or symbol is unused before removing it.

Do not make implementation decisions based on assumptions.

---

## Scope Control

- Modify only the approved scope.
- Do not redesign architecture without explicit approval.
- Do not rename public APIs without explicit approval.
- Do not add dependencies without explicit approval.
- Do not perform unrelated cleanup.
- Do not introduce speculative abstractions.
- Prefer the smallest change that satisfies the approved requirements.

---

## Architecture

- Preserve established layer boundaries.
- Keep domain logic independent where intended.
- Respect `@MainActor` isolation and SwiftData `ModelContext` ownership.
- Keep ViewModels free from app-composition responsibilities.
- Keep App composition free from feature-specific ViewModel coupling.
- Avoid hidden global state and unnecessary singletons.

Primary dependency direction:

```text
Data → Business → Mapping → Presentation
```

Do not reverse dependencies or duplicate business logic in the Presentation layer.

---

## Testing

- Add or update tests for changed behavior.
- Run the relevant build and test suite.
- Report skipped or unverified scenarios.
- Never claim manual validation that was not performed.

A successful build does not replace testing.

---

## Documentation

- Update documentation only when requested or as part of an approved Documentation Pass.
- Do not silently create new architectural decisions.
- Clearly identify unresolved decisions or assumptions.

When documentation is updated, keep terminology aligned with `Docs/GLOSSARY.md`.

---

## Git

- Never commit.
- Never push.
- Never rewrite Git history.
- Never modify repository configuration unless explicitly requested.

Commit and push are developer-owned steps defined in the Development Workflow.

---

## Reporting

Every implementation report must include:

1. Modified Files
2. Implementation Summary
3. Architecture Notes
4. Test and Build Results
5. Manual Verification Required
6. Remaining Risks or Issues

Reports should be factual, concise, and limited to the approved scope.
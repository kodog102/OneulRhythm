# Sprint Checklist

Reusable Sprint close-out checklist for OneulRhythm.

Canonical lifecycle: `DEVELOPMENT_WORKFLOW.md`.

Update only documentation affected by the Sprint. Not every document must change every Sprint.

Related documents:

- `DEVELOPMENT_WORKFLOW.md`
- `PROMPT_LIBRARY.md`
- `CURSOR_GUIDELINES.md`

---

## Preconditions

- [ ] Sprint goal defined
- [ ] Scope approved
- [ ] Repository context reviewed
- [ ] Acceptance criteria defined

---

## 1–3. Experience → Architecture → UI Spec

- [ ] Experience Review completed (or N/A for engineering-only)
- [ ] North Star accepted when Visual-first applies (Sprint 18+)
- [ ] Architecture Review / Decision Record completed when required
- [ ] UI Specification / Design Extraction approved when user-facing UI is in scope
- [ ] Cursor Prompt frozen when Visual-first applies

---

## 4. Implementation

- [ ] Approved scope implemented
- [ ] Tests added or updated
- [ ] Build succeeds
- [ ] Relevant test suite passes
- [ ] Implementation Report reviewed
- [ ] Code Review completed
- [ ] Documentation Pass completed when owner docs must change

---

## 5. Product QA

- [ ] Visual QA completed against North Star / Design Extraction (or N/A)
- [ ] Technical / Integration QA completed
- [ ] Regression risks reviewed
- [ ] Blocking issues resolved

---

## 6. Document Integration Review (DIR)

- [ ] Cross references verified (no broken links / orphans)
- [ ] Authority / ownership clear (one source of truth per topic)
- [ ] Terminology consistent
- [ ] Product Principles / Brand consistency checked
- [ ] Hub navigation indexes Active documents
- [ ] Contradictions resolved
- [ ] DIR verdict recorded (ready / blocked → fixes applied)

---

## 7. Planning Sync (PS)

- [ ] `Docs/ROADMAP.md` reflects current reality
- [ ] `Docs/CHANGELOG.md` records completed work only
- [ ] Root `README.md` matches roadmap summaries
- [ ] Sprint ownership unique (no duplicate planned owners)
- [ ] Deferred work correctly postponed
- [ ] Future sprint alignment verified

Planning notes:

- Planning docs defer to Product / Architecture authorities — do not duplicate Decision Records.
- Glossary updated when terminology changed (`Docs/GLOSSARY.md`).
- `Docs/README.md` updated only when categories, paths, or role entry points change.
- Archived documents are historical only and are never implementation authority.

---

## 8. Product Owner Approval

- [ ] Product Owner Approval given
- [ ] Technical debt recorded (as needed)
- [ ] Commit message prepared
- [ ] Commit completed by the developer
- [ ] Push completed by the developer
- [ ] Next Sprint prepared from `Docs/ROADMAP.md`

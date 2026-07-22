# Prompt Library

Reusable Cursor prompts for the OneulRhythm Sprint workflow.

Copy a template, replace the placeholders, and paste it into Cursor.

Placeholders:

- `[SPRINT NAME]`
- `[TASK NAME]`
- `[APPROVED SCOPE]`
- `[EXPECTED BEHAVIOR]`
- `[REPRODUCTION PATH]`
- `[FINDINGS TO FIX]`
- `[AFFECTED DOCUMENTS]`

Related documents:

- `DEVELOPMENT_WORKFLOW.md`
- `CURSOR_GUIDELINES.md`
- `SPRINT_CHECKLIST.md`

---

## Architecture Review Prompt

```text
You are performing an Architecture Review for OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Proposed Scope: [APPROVED SCOPE]

Inspect the relevant source code and documentation before reviewing.

Do not modify any files unless explicitly instructed.

Deliver:

1. Current Architecture Relevant to This Task
2. Affected Files and Responsibilities
3. Risks and Constraints
4. Recommended Implementation Direction
5. Out of Scope (What Must Not Change)
6. Open Questions Requiring Developer Approval

Preserve existing layer boundaries.
Do not invent architecture.
Do not commit or push.
```

---

## Implementation Prompt

```text
You are implementing an approved task for OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Approved Scope: [APPROVED SCOPE]
Expected Behavior: [EXPECTED BEHAVIOR]

Rules:

1. Inspect the relevant source code and documentation first.
2. Implement only the approved scope.
3. Preserve the existing architecture.
4. Do not redesign architecture, rename public APIs, or add dependencies without explicit approval.
5. Do not perform unrelated cleanup.
6. Prefer the smallest change that satisfies the approved requirements.
7. Add or update tests for changed behavior.
8. Run the relevant build and test suite.
9. Do not commit or push.

Report:

1. Modified Files
2. Implementation Summary
3. Architecture Notes
4. Key Decisions
5. Test and Build Results
6. Manual Verification Required
7. Remaining Risks or Issues
```

---

## Integration QA Prompt

```text
You are performing Integration QA for OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Approved Scope: [APPROVED SCOPE]
Expected Behavior: [EXPECTED BEHAVIOR]

Verify:

1. Functional behavior matches the approved scope
2. Launch and lifecycle behavior
3. Persistence behavior
4. Idempotency where applicable
5. MainActor isolation and ModelContext ownership
6. Regressions in related flows
7. Build and test results
8. Manual verification items that still require the developer

Do not expand scope.
Do not redesign architecture.
Do not commit or push.

Return one of:

- PASS
- PASS WITH CONDITIONS
- FAIL

Report:

1. Result
2. Verified Items
3. Manual Verification Required
4. Findings
5. Regression Risks
6. Recommended Fixes (if any)
```

---

## Bug Investigation Prompt

```text
You are investigating a bug in OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Observed Behavior: [EXPECTED BEHAVIOR]
Reproduction Path: [REPRODUCTION PATH]

Do not modify code during the investigation unless explicitly instructed.

Deliver:

1. Reproduction Path
2. Root Cause
3. Affected Scope
4. Evidence
5. Minimal Fix Proposal
6. Regression Risks
7. Open Questions

Do not commit or push.
```

---

## Documentation Pass Prompt

```text
You are performing a Documentation Pass for OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Implemented Behavior: [EXPECTED BEHAVIOR]
Likely Affected Documents: [AFFECTED DOCUMENTS]

Intent:

- Synchronize documentation with the implemented behavior
- Update only affected documents
- Verify terminology, architecture, lifecycle, roadmap, and changelog consistency
- Remove obsolete statements
- Do not invent architecture
- Do not modify production code or tests
- Do not commit or push

Deliver:

1. Modified Files
2. Summary by File
3. Consistency Issues
4. Documentation Debt
5. Remaining Decisions
```

---

## Documentation Review Prompt

```text
You are performing a Documentation Review for OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Expected Behavior: [EXPECTED BEHAVIOR]

Review:

1. Implementation-documentation consistency
2. Architecture correctness
3. Terminology consistency with Docs/GLOSSARY.md
4. Roadmap status accuracy
5. Changelog completeness
6. Obsolete statements
7. Missing design decisions

Do not modify files unless explicitly instructed.
Do not invent architecture.
Do not commit or push.

Return one of:

- APPROVED
- CHANGES REQUIRED

Report:

1. Result
2. Findings
3. Required Changes
```

---

## Sprint Retrospective Prompt

```text
You are writing the Sprint Retrospective for OneulRhythm.

Sprint: [SPRINT NAME]

Include:

1. Sprint Goal
2. What Changed
3. Key Decisions
4. Problems Found
5. Solutions Applied
6. Technical Debt
7. Lessons Learned
8. Readiness for the Next Sprint

Keep the report factual and concise.
Do not present unfinished work as completed.
Do not commit or push unless explicitly requested by the developer.
```

---

## Refactoring Prompt

```text
You are performing a scoped refactor for OneulRhythm.

Sprint: [SPRINT NAME]
Task: [TASK NAME]
Approved Scope: [APPROVED SCOPE]

Rules:

1. Do not intentionally change behavior.
2. Review current test coverage before editing.
3. Prefer small, reversible changes.
4. Preserve architecture and public APIs unless explicitly approved.
5. Run the relevant build and test suite.
6. Explicitly report any behavior that could not be preserved.
7. Do not commit or push.

Report:

1. Modified Files
2. Refactoring Summary
3. Behavior Preservation Status
4. Test and Build Results
5. Remaining Risks or Issues
```

---

## Release QA Prompt

```text
You are performing Release QA for OneulRhythm.

Release / Sprint: [SPRINT NAME]
Expected Behavior: [EXPECTED BEHAVIOR]

Verify:

1. Clean build
2. Test suite
3. Launch
4. Persistence
5. Critical user flows
6. Notifications and Live Activities (when applicable)
7. Migration risks
8. Known limitations
9. Release-blocking issues

Clearly distinguish verified items from those that still require developer validation.

Do not expand scope.
Do not commit or push.

Return one of:

- PASS
- PASS WITH CONDITIONS
- FAIL

Report:

1. Result
2. Verified Items
3. Manual Verification Required
4. Known Limitations
5. Release-Blocking Issues
```
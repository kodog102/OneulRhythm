# Architecture Decision Records

This directory contains the Architecture Decision Records (ADRs) for OneulRhythm.

Each Decision Record captures a significant architectural decision, the context in which it was made, the chosen solution, and its long-term consequences.

The purpose of these records is to preserve architectural intent, making it easier to understand why the system is designed the way it is as the project evolves.

---

## Decision Status

The following status values are used throughout this directory.

| Status | Description |
|---------|-------------|
| Proposed | Under discussion and not yet accepted. |
| Accepted | Official architectural decision. |
| Superseded | Replaced by a newer decision. |
| Deprecated | Retained for historical reference but no longer recommended. |

---

## Reading Order

The Decision Records are intended to be read in numerical order because later decisions build upon earlier architectural foundations.

| ID | Title | Status |
|----|-------|--------|
| DR-001 | Project Principles | Accepted |
| DR-002 | SwiftData Persistence | Accepted |
| DR-003 | Repository Layer | Accepted |
| DR-004 | Schedule Engine | Accepted |
| DR-005 | Today Snapshot | Accepted |
| DR-006 | Live Activity Architecture | Accepted |
| DR-007 | Schedule Resolution | Accepted |
| DR-008 | Single Focus Experience | Accepted |
| DR-009 | Single Primary Rhythm | Accepted |
| DR-010 | Immediate Day Complete | Accepted |
| DR-011 | Recurring Rhythm Foundation | Accepted |

---

## Scope

Decision Records describe **architectural decisions**, not implementation details.

Appropriate topics include:

- Architectural boundaries
- Domain responsibilities
- Data ownership
- Persistence strategy
- Scheduling architecture
- Presentation responsibilities
- Lifecycle management
- Long-term product architecture

The following should generally be documented elsewhere:

- Algorithms
- UI layouts
- API usage
- Code structure
- Implementation details
- Feature specifications

These belong in design documents or the source code itself.

---

## Relationship to Other Documentation

| Document | Purpose |
|----------|---------|
| Architecture | Overall system structure and component relationships |
| Design | Feature design and implementation details |
| Roadmap | Planned work and future milestones |
| CHANGELOG | Completed work and release history |
| Decision Records | Architectural decisions and their rationale |

---

## Maintaining Decision Records

Create a new Decision Record whenever a significant architectural decision is made.

Decision Records should describe *why* a decision exists rather than *how* it is implemented.

Avoid rewriting historical decisions.

If an architectural decision changes:

1. Create a new Decision Record.
2. Mark the previous record as **Superseded**.
3. Add cross-references between the related records.

This preserves the architectural history of the project while keeping the current direction clear.
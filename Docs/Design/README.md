# Design

## Purpose

Design documentation defines how the architecture is implemented.

Design documents are implementation contracts, not product decisions and not Architecture Decision Records.

## Audience

Implementers, design/architecture agents, and maintainers changing subsystem behavior.

## Scope

- Subsystem responsibilities and non-responsibilities
- Data flow, state transitions, and collaboration rules
- Extension strategy at the subsystem boundary

## Primary navigation

| Document | Purpose | Status |
|----------|---------|--------|
| `Scheduling.md` | Schedule resolution and business flow | Active |
| `Persistence.md` | Persistence implementation | Active |
| `Mapper.md` | Business → presentation transformation | Active |
| `Presentation.md` | Presentation architecture | Active |
| `LiveActivity.md` | ActivityKit implementation | Active |
| `Notification.md` | Notification Plan and scheduling boundary | Active |

Recurring rhythm design lives in `Docs/Extensions/Recurrence.md`.

## What this hub does NOT contain

- Product philosophy or UX layout contracts
- Architecture Decision rationale catalogs
- Sprint workflow or QA process
- Glossary term definitions

## Design document structure

```text
Purpose
Responsibilities
Non-Responsibilities
Data Flow
Design Principles
Extension Strategy
Design Notes
Related Decisions
```

Individual sections may be omitted when irrelevant.

## Design rules

- Behavior should be deterministic.
- Each subsystem owns one responsibility.
- Preserve architectural dependency direction.
- Prefer framework-independent business behavior.
- Integrate future capabilities through existing boundaries.

Terminology is defined in `Docs/GLOSSARY.md`.

System structure is defined in `Docs/Architecture/ARCHITECTURE.md`.  
Related “why” decisions live under `Docs/Architecture/Decisions/`.

# Design

The Design documentation defines how the architecture is implemented.

While the Architecture documents describe the structure of the system and the Decision Records explain why architectural decisions were made, the Design documents specify how each subsystem behaves and how those architectural decisions are realized.

Design documents are implementation specifications rather than implementation code.

---

# Purpose

The Design documentation exists to:

- Define implementation responsibilities.
- Describe subsystem behavior.
- Specify interactions between components.
- Preserve implementation consistency.
- Support future maintenance and extension.

Design documents intentionally avoid repeating architectural decisions that are already documented elsewhere.

---

# Relationship to Other Documentation

The project documentation is organized into four complementary levels.

```
README
    │
    ▼
Architecture
    │
    ▼
Decision Records
    │
    ▼
Design
```

Each document answers a different question.

| Document | Purpose |
|----------|---------|
| README | What is this project? |
| Architecture | What is the system structure? |
| Decision Records | Why was this architecture chosen? |
| Design | How is each subsystem implemented? |

---

# Design Principles

Every design document should follow these principles.

## Deterministic

Behavior should be predictable.

The same input should always produce the same output.

---

## Single Responsibility

Each subsystem owns one responsibility.

Responsibilities should not overlap.

---

## Layer Respect

Design must preserve the architectural boundaries defined in Architecture.md.

Implementation convenience must never violate dependency direction.

---

## Framework Independence

Business behavior should remain independent from SwiftUI, ActivityKit, SwiftData, or any presentation framework whenever possible.

---

## Extensibility

Future capabilities should integrate through existing architectural boundaries rather than introducing parallel implementations.

---

# Design Scope

A design document may describe:

- Responsibilities
- Non-responsibilities
- Data flow
- State transitions
- Algorithms
- Interaction sequences
- Component collaboration
- Extension strategy

A design document should not contain implementation code.

Pseudo-code may be used when it improves understanding.

---

# Standard Document Structure

Every Design document follows the same structure.

```text
Purpose

Responsibilities

Non-Responsibilities

Architecture

Data Flow

State

Algorithms

Sequence

Design Notes

Related Decisions
```

Individual sections may be omitted if they are not relevant to the subsystem.

---

# Current Design Documents

| Document | Purpose |
|----------|---------|
| Mapper.md | Business → Presentation transformation |
| Scheduling.md | Schedule resolution and business flow |
| Persistence.md | Persistence implementation |
| Presentation.md | Presentation architecture |
| LiveActivity.md | ActivityKit implementation |
| Recurrence.md | Recurring rhythm implementation |

---

# Dependency Direction

Design documents follow the architectural dependency direction.

```
Presentation
      ▲
      │
Mapping
      ▲
      │
Business
      ▲
      │
Data
```

Implementation details must never introduce dependencies that violate this direction.

---

# Design Language

Throughout the Design documentation:

- English terminology is canonical.
- Terms are defined in `Docs/GLOSSARY.md`.
- Architectural terminology should not be redefined.
- Code examples are illustrative rather than authoritative.

When referring to architectural concepts, use the official names defined in the Glossary.

---

# Related Documents

- Docs/README.md
- Docs/GLOSSARY.md
- Docs/Architecture/ARCHITECTURE.md
- Docs/Decisions/
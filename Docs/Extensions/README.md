# Extensions

## Purpose

Extensions documentation describes capabilities that extend the core architecture without replacing it.

## Audience

Implementers and maintainers adding optional capabilities on the existing pipeline.

## Scope

- Extension integration points
- Current and planned optional capabilities
- Rules for preserving architectural consistency

## Primary navigation

| Document | Purpose | Status |
|----------|---------|--------|
| `Recurrence.md` | Generate daily rhythms from recurring definitions | Active |

## What this hub does NOT contain

- Core subsystem Design contracts for Scheduling, Persistence, Mapper, Presentation, Live Activity, or Notification
- Product UX specifications
- Architecture Decision Record catalogs

Core implementation contracts live under `Docs/Design/`.  
System structure lives under `Docs/Architecture/ARCHITECTURE.md`.

## Extension rules

Every extension should:

- Reuse the existing architecture
- Respect dependency direction
- Integrate through existing boundaries
- Avoid duplicating business logic
- Produce deterministic behavior

Extensions contribute to the existing pipeline. They do not replace it.

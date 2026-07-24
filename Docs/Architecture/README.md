# Architecture

## Purpose

Architecture documentation defines the system structure of OneulRhythm and preserves why that structure exists.

## Audience

Developers, architecture reviewers, maintainers, and AI agents changing system shape or ownership boundaries.

## Scope

- High-level architecture
- Architecture Decision Records
- Historical Architecture Reviews

## Primary navigation

| Document | Role | Status |
|----------|------|--------|
| `ARCHITECTURE.md` | System structure and dependency direction | Active |
| `Decisions/README.md` | ADR index and status | Active |
| `Reviews/README.md` | Pre-sprint architecture contracts | Historical |

Recommended path:

1. `ARCHITECTURE.md`
2. `Decisions/README.md` → relevant Decision Records

When implementation detail is required, continue to the matching document under `Docs/Design/`.

## What this hub does NOT contain

- Product philosophy or UX contracts
- Subsystem algorithms and implementation specs
- Sprint process or agent collaboration rules
- Roadmap timelines beyond pointers in Decision Records

Product behavior lives under `Docs/Product/`.  
Implementation contracts live under `Docs/Design/`.

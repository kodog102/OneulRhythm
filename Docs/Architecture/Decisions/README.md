# Architecture Decision Records

## Purpose

This directory preserves architectural intent.

Each Decision Record captures a significant architectural decision, its context, the chosen solution, and long-term consequences.

## Audience

Architecture reviewers, maintainers, and contributors changing ownership boundaries.

## Scope

- Architectural boundaries and domain ownership
- Persistence, scheduling, presentation, and lifecycle strategy
- Long-term architectural direction

## Primary navigation

Decision Records are intended to be read in numerical order when learning the foundations.

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
| DR-012 | Notification Plan Architecture | Accepted |
| DR-013 | Notification Synchronization | Accepted |
| DR-014 | Product UI First Strategy | Accepted |

## Decision status

| Status | Description |
|--------|-------------|
| Proposed | Under discussion and not yet accepted |
| Accepted | Official architectural decision |
| Superseded | Replaced by a newer decision |
| Deprecated | Retained historically but no longer recommended |

## What this hub does NOT contain

- Algorithms and UI layouts
- Feature UX specifications
- Sprint process details
- Full system structure narrative

System structure: `Docs/Architecture/ARCHITECTURE.md`  
Implementation contracts: `Docs/Design/`  
Product behavior: `Docs/Product/`

## Maintaining Decision Records

Create a new Decision Record when a significant architectural decision is made.

Prefer describing why a decision exists and what ownership it establishes.

Avoid rewriting historical decisions.

If a decision changes:

1. Create a new Decision Record.
2. Mark the previous record as **Superseded**.
3. Cross-reference the related records.

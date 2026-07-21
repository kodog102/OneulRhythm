# DR-008 — Single Focus Experience

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Presentation Layer

---

## Context

A rhythm application should reduce cognitive load rather than increase it.

Presenting multiple simultaneous rhythms, overdue lists, and competing actions requires users to continually decide where to focus.

While complete schedule information is valuable for business logic, exposing all of it simultaneously creates unnecessary complexity for the user experience.

The product requires a presentation philosophy that encourages clarity and sustained attention.

---



## Decision

The project adopts a **Single Focus Experience**.

At any given moment, the application presents one primary rhythm as the user's current point of attention.

Supporting information may exist internally, but it should not compete with the primary rhythm for visual attention.

Presentation decisions prioritize:

- Clarity over completeness.
- Focus over density.
- Calm interaction over information richness.
- Progressive disclosure over simultaneous presentation.

This principle applies consistently across all presentation surfaces, including the application and Live Activities.

---



## Consequences



### Positive

- Reduced cognitive load.
- Clear user attention.
- Consistent presentation philosophy.
- Simpler user interface.
- Better alignment with the project's calm design goals.



### Negative

- Some available schedule information is intentionally hidden from immediate view.
- Users may need additional interactions to inspect information beyond the primary rhythm.

These trade-offs are accepted because maintaining focus is considered more valuable than presenting all available information simultaneously.

---



## Alternatives Considered



### Present Multiple Active Sections

Rejected.

Displaying current, overdue, upcoming, and completed rhythms simultaneously increases visual complexity and divides user attention.

### Timeline-Based Presentation

Rejected.

Although comprehensive, a timeline emphasizes schedule completeness rather than the user's immediate action.

The project prioritizes guiding the next meaningful action instead.

---



## Related Decisions

- DR-001 — Project Principles
- DR-005 — Today Snapshot
- DR-006 — Live Activity Architecture
- DR-009 — Single Primary Rhythm


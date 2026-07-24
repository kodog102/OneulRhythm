# DR-014 — Product UI First Strategy

**Status:** Accepted  
**Decision Date:** Post Sprint 7 — Sprint 8 Preparation  
**Applies From:** Sprint Planning and Implementation Priority

---

## Context

Sprint 7 completed the Notification Foundation:

- Today Snapshot
- Notification Pipeline
- Trigger Policy
- Notification Plan
- Notification Synchronization
- Live Activity foundation

The earlier roadmap planned Widget Experience immediately after Notification Foundation.

At this stage, the architecture is stable enough that expanding platform surfaces first would delay validation of the in-app experience. Product UI now provides more value than immediate Widget or Apple Watch work.

This decision records a strategic planning change. It does not redesign architecture.

---

## Decision

Future development prioritizes Product UI before Widget and Apple Watch implementation.

### Current order

1. Today Product Experience
2. Routine Management
3. Settings & Preferences
4. UX Polish
5. Widget Experience
6. Apple Watch Integration

### Rules

- Notification Foundation is treated as complete and stable for Product UI work.
- Widget and Apple Watch remain planned surfaces; they are postponed, not cancelled.
- Implementation should reuse existing architecture whenever possible.
- New business logic should be introduced only when required by approved Product UI scope.
- Future platform integrations must consume the existing Snapshot, Schedule Engine, Mapping, Notification, and Live Activity architecture rather than redefine it.

---

## Reasons

- Faster UX validation of the primary in-app experience
- Existing architecture is already stable
- Avoid duplicate UI work across Product UI and platform surfaces
- Widget and Watch can reuse a finalized Product UI interpretation
- Reduce architectural churn while Product UI is still converging

---

## Consequences

### Positive

- Sprint order aligns with Product UI First
- Agents and contributors have a clear implementation priority
- Platform expansion waits for stronger in-app MVP quality
- Existing architecture remains the integration target for later surfaces

### Accepted trade-offs

- Widget implementation is intentionally delayed
- Apple Watch implementation is intentionally delayed
- Near-term roadmap emphasizes Product UI over platform breadth

These trade-offs are accepted. Architecture, Notification pipeline, Snapshot ownership, and Live Activity foundation remain unchanged.

---

## Alternatives Considered

### Proceed immediately to Widget Experience

Rejected.

Would expand platform surface area before the in-app experience reaches MVP quality, increasing duplicate UI and validation cost.

### Redesign architecture before Product UI

Rejected.

Notification Foundation and related surfaces are already stable. Product UI should consume that architecture rather than reopen it.

### Cancel Widget and Watch permanently

Rejected.

They remain valid long-term surfaces. Only sequencing changes.

---

## Related Decisions

- DR-001 — Project Principles
- DR-005 — Today Snapshot
- DR-006 — Live Activity Architecture
- DR-012 — Notification Plan Architecture
- DR-013 — Notification Synchronization

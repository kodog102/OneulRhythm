# DR-010 — Immediate Day Complete

**Status:** Accepted  
**Decision Date:** Sprint 6-1 Final Review  
**Applies From:** Live Activity Lifecycle

---

## Context

Live Activities represent the user's current rhythm throughout the day.

When all rhythms for the day are completed, the application must determine how the Live Activity lifecycle should end.

Several approaches were considered, including delaying dismissal to preserve a completion moment and immediately ending the activity once the day is complete.

The chosen solution must remain deterministic, align with ActivityKit's documented behavior, and preserve a consistent user experience.

---

## Decision

The project adopts an **Immediate Day Complete** lifecycle.

When the Schedule Engine determines that the current day has reached the completed state, the active Live Activity is ended immediately.

The completion experience belongs to the application itself rather than the Live Activity.

If a new incomplete rhythm later appears for the same day, a new Live Activity is created through the normal application lifecycle.

The timing of Live Activity dismissal is treated as an application lifecycle decision rather than a presentation concern.

---

## Consequences

### Positive

- Uses documented ActivityKit behavior.
- Eliminates ambiguity around deferred dismissal.
- Produces deterministic Live Activity lifecycle management.
- Simplifies lifecycle coordination.
- Prevents stale Live Activities from remaining visible.

### Negative

- The completion moment is no longer preserved within the Live Activity.
- A newly created rhythm later in the day results in a new Live Activity rather than extending the previous one.

These trade-offs are accepted because predictable lifecycle management is prioritized over preserving a completed activity.

---

## Alternatives Considered

### Delayed Dismissal

Rejected.

Keeping the completed Live Activity visible for a period introduces lifecycle ambiguity and depends on deferred dismissal behavior that is unnecessary for the project's goals.

### Persistent Daily Activity

Rejected.

Maintaining a single Live Activity for the entire day increases lifecycle complexity and weakens the relationship between the Live Activity and the user's current rhythm.

---

## Related Decisions

- DR-004 — Schedule Engine
- DR-006 — Live Activity Architecture
- DR-007 — Schedule Resolution
- DR-009 — Single Primary Rhythm
- DR-011 — Recurring Rhythm Foundation
# DR-006 — Live Activity Architecture

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Activity Presentation Layer  
**Amended:** Sprint 21 — Flagship Live Activity experience (visual states, Foreground Sync Option A)

---

## Context

OneulRhythm extends the Today experience beyond the application by presenting the current rhythm through Live Activities.

The information displayed in a Live Activity must remain consistent with the information presented inside the application.

Maintaining separate business logic for the application and the Live Activity would introduce duplicated scheduling behavior and increase the risk of inconsistent user experiences.

A shared architectural approach is required.

ActivityKit does not guarantee ContentState delivery while the host app is backgrounded, locked, suspended, or terminated. The product must state explicitly which transitions require an app reconciliation and which the widget may derive locally.

---

## Decision

The project treats the Live Activity as an additional presentation surface rather than an independent feature.

Live Activities consume the same business state used by the application.

### Ownership

| Concern | Owner |
| --- | --- |
| Schedule interpretation | Schedule Engine |
| Day presentation facts (phase, primary role, focus) | `TodayRhythmSnapshot` — **single source of truth** |
| ActivityKit ContentState generation | Live Activity Mapper (`TodayRhythmActivityMapper`) |
| ActivityKit request / update / end | `LiveActivityCoordinator` |
| Visual status / accent / dots (Lock Screen, Island) | Presentation resolver (`LiveActivityStateAccent`) |

Business logic remains outside the Live Activity layer.

The Live Activity layer exists solely to adapt Snapshot facts for ActivityKit and to render them calmly.

### Production flow

```text
Repository
    → Schedule Engine
    → TodayRhythmSnapshot
    → TodayRhythmActivityMapper
    → LiveActivityCoordinator
    → ActivityKit
```

### Foreground Sync (authoritative)

**Foreground sync is authoritative.**

Production path:

`TodayViewModel` refresh → Snapshot rebuild → Mapper → `LiveActivityCoordinator.sync` → `Activity.request` / `update` / `end`.

Triggers include:

- App launch (after initial daily rhythm sync)
- Scene becomes active
- Today surface becomes visible while active
- Timeline boundary refresh while Today is visible and the scene is active
- Routine create / edit / delete / user completion through Today

While the app is active and Today’s timeline refresh is armed, known start/end boundaries recalculate Snapshot so scheduled → running and active → overdue stay synchronized. Entering the foreground always catch-up reconciles missed transitions.

### Background presentation bridge

While the app is backgrounded, locked, suspended, or terminated:

- ContentState updates / `Activity.update()` are **not** guaranteed.
- The widget may derive **presentation-only** visual states from existing focus dates:
  - running
  - nearCompletion
  - completed
- The widget must **not** invent:
  - a new primary rhythm
  - next-routine handoff
  - overdue / dayComplete ContentState phase
- Next-rhythm handoff and mapped overdue / dayComplete occur on the **next foreground reconciliation**.

This is an accepted ActivityKit platform boundary, not a product defect.

### Visual state policy (Sprint 21)

Mutually exclusive presentation states (production path):

1. **completed**
2. **scheduled** (`시작 전`)
3. **nearCompletion** (`완료 임박`)
4. **running** (`진행 중`)

Inferred pause (“일시정지”) is not used. There is no domain pause source.

**Hybrid Near Completion** (centralized helper):

- `nearThreshold = min(5 minutes, totalDuration × 20%)`
- Effective near window is further clamped so a minimum running window (30 seconds when duration allows) remains
- Never classifies an entire active duration as near completion

Category identity remains separate from state accent.

### Day Complete

Day Complete still ends the Live Activity immediately (`dismissalPolicy: .immediate`). The peaceful completion experience continues in Today (DR-010). Unchanged by Sprint 21.

### Explicitly not adopted

- BGTaskScheduler / background polling
- Push-to-Live-Activity / silent push / server infrastructure
- Undocumented background timers
- Continuous second-by-second `Activity.update` calls

Local Live Activities use `pushType: nil`.

---

## Consequences

### Positive

- A single Snapshot-backed business flow serves Today and Live Activity.
- Consistent behavior whenever the app can reconcile.
- Clear Lock Screen expectation while suspended (date-derived visual bridge only).
- ActivityKit remains isolated from core business logic.
- No background execution or push infrastructure cost.

### Negative

- Requires a mapping layer between Snapshot and ActivityKit models.
- Live Activity capabilities remain constrained by ActivityKit limitations.
- Automatic next-rhythm handoff while suspended is unsupported until the next foreground sync.

These trade-offs are accepted to preserve architectural consistency and Option A simplicity.

---

## Alternatives Considered

### Independent Live Activity Logic

Rejected.

Allowing the Live Activity to resolve schedules independently would duplicate business rules and increase maintenance complexity.

### Live Activity Reads Persistence Directly

Rejected.

The Live Activity should not become another business component.

Persistence access remains the responsibility of the Repository layer.

### BGTaskScheduler or Push-to-Live-Activity for boundary updates

Rejected (Sprint 21).

Would improve suspended start/end handoff but adds platform complexity, push infrastructure, and battery policy surface area beyond the MVP. Foreground sync plus a presentation-only completion bridge is sufficient.

---

## Related Decisions

- DR-001 — Project Principles
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
- DR-009 — Single Primary Rhythm
- DR-010 — Immediate Day Complete

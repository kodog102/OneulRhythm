# DR-015 — First Rhythm Onboarding Lifecycle

**Status:** Accepted  
**Decision Date:** Product UI Refinement — Today Empty State Review  
**Applies From:** Today Empty State Presentation

---

## Context

During Product UI refinement, the Today Empty State design review revealed that Empty serves two fundamentally different purposes:

1. Introducing OneulRhythm to first-time users.
2. Providing a minimal empty state for existing users.

A single Empty State cannot satisfy both.

First-time users need product introduction and encouragement to begin.

Users who have already created a rhythm need calm, minimal guidance without repeated product explanation.

This decision defines the Today Empty State lifecycle. It does not redesign product principles, Schedule Engine ownership, or surfaces beyond Today Empty.

---

## Decision

The Today Empty State lifecycle is based on whether the user has ever successfully created a rhythm.

It is **not** based on:

- First app launch
- Installation date
- Number of launches

### Lifecycle rule

The onboarding experience remains active until the user successfully creates the first rhythm.

Immediately after the first rhythm is created, the onboarding experience permanently ends.

---

## Problem

A single Empty State cannot serve both first-time and returning users.

If Empty always introduces the product, returning users repeatedly see brand explanation when they only need a quiet path forward.

If Empty is always minimal, first-time users receive no philosophy or invitation strong enough to begin their first rhythm.

These needs conflict. Sharing one UI for both creates either noise for existing users or insufficient onboarding for new users.

---

## Product Goal

The first Empty State is part of onboarding.

It introduces the philosophy of OneulRhythm rather than merely indicating that no data exists.

Empty is not a broken day.

For first-time users, Empty is the beginning of the product experience.

---

## UX Intent

### Phase 1 — Before First Rhythm Creation

Contains:

- Hero Message
- Philosophy Card
- Primary CTA
- Brand introduction

Purpose:

Introduce the product and encourage creating the first rhythm.

### Phase 2 — After First Rhythm Creation

Contains only:

- Minimal Hero
- Primary CTA (when appropriate)
- Minimal empty guidance

No Philosophy Card.

No repeated product introduction.

Purpose:

Prioritize the user's content over the product itself.

---

## Lifecycle

```text
App Install
    │
    ▼
First Today
    │
    ▼
Onboarding Empty
    │
    ▼
Create First Rhythm
    │
    ▼
Normal Today Experience
```

Onboarding Empty remains until the first rhythm is successfully created.

After that moment, returning to Empty never restores onboarding.

---

## State Transition Rules

The onboarding experience is tied to the user's journey, not the current data.

Journey states:

- **First Journey** — onboarding remains active (Phase 1 Empty when Today is empty)
- **Normal Experience** — onboarding has permanently ended (Phase 2 Empty when Today is empty)

| Current State | Event | Next State |
|---------------|-------|------------|
| First Journey | App Relaunch | First Journey |
| First Journey | Create First Rhythm (Success) | Normal Experience |
| First Journey | Create Rhythm Cancelled | First Journey |
| Normal Experience | Delete All Rhythms | Normal Experience |
| Normal Experience | Fresh Install / Fresh Data | First Journey |

Deleting every rhythm does not restart onboarding.

Only a completely fresh application state — fresh install or cleared app data — returns to First Journey.

These rules exist to eliminate ambiguity during implementation.

---

## UX Principles

OneulRhythm should be experienced rather than repeatedly explained.

The product introduces itself only until the user begins their first rhythm.

After that moment, the user's rhythms become the primary experience.

This aligns with:

- Less Input. More Presence.
- Calm over Complexity.
- Architecture Serves Experience.

---

## Visual Hierarchy

### Phase 1 — Onboarding Empty

```text
Hero Message
    │
    ▼
Philosophy Card
    │
    ▼
Primary CTA
```

Brand introduction and product philosophy hold attention.

The Primary CTA is the single invitation to begin.

### Phase 2 — Minimal Empty

```text
Minimal Hero
    │
    ▼
Minimal Empty Guidance
    │
    ▼
Primary CTA (when appropriate)
```

No Philosophy Card.

No brand introduction block.

The layout stays quiet and subordinate to the user's ongoing rhythm life.

---

## Design Notes

### Why the Philosophy Card disappears

Once the user has created a rhythm, the product has already introduced itself.

Repeating philosophy increases visual noise without helping the user stay connected to today's rhythm.

### Why onboarding completion is tied to first rhythm creation

Launch count and installation date do not prove that the user understands OneulRhythm.

Creating the first rhythm is the moment the user begins the product experience.

That moment is the correct boundary between introduction and ongoing use.

### Why this creates a calmer long-term experience

Existing users are not re-onboarded.

Empty becomes quieter over time.

The long-term Today experience prioritizes the user's rhythms over the product's self-description.

---

## Implementation Notes

Implementation should persist whether the user has successfully created their first rhythm so the onboarding experience does not reappear.

This is durable user-progress state, not derived UI convenience.

Do not reintroduce onboarding after deletion, relaunch, or later Empty conditions once the first rhythm has been created.

Storage technology and property naming are implementation details and are intentionally left unspecified here.

Presentation remains responsible for choosing Phase 1 or Phase 2 Empty based on that persisted progress fact.

No Schedule Engine, Snapshot ownership, Notification, or Live Activity redesign is required by this decision.

---

## Consequences

### Positive

- First-time and returning Empty experiences have clear, separate purposes.
- Onboarding ends at a meaningful product moment.
- Long-term Today Empty stays calmer and less explanatory.
- Product principles remain intact while Empty UX becomes more precise.

### Accepted trade-offs

- Empty presentation now has two lifecycle phases instead of one shared layout.
- Implementation must retain first-rhythm progress across launches.

These trade-offs are accepted because repeated product introduction after the first rhythm would violate calm, presence-first product goals.

---

## Alternatives Considered

### Single shared Empty State for all users

Rejected.

Cannot introduce philosophy to first-time users without creating noise for returning users.

### End onboarding on first app launch

Rejected.

Launch does not equal understanding or beginning a rhythm.

### End onboarding after a fixed number of launches

Rejected.

Launch count is unrelated to whether the user has started their rhythm life.

### Restore onboarding if the user later has no rhythms

Rejected.

Once the product has been introduced through first rhythm creation, Empty should remain minimal.

---

## Related Decisions

- DR-001 — Project Principles
- DR-008 — Single Focus Experience
- DR-009 — Single Primary Rhythm
- DR-014 — Product UI First Strategy

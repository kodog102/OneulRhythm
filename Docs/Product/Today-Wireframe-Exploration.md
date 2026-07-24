> **Archived**
>
> This document is retained for historical reference.
> It is not an active product, architecture, or implementation contract.

# Today Wireframe Exploration

Sprint 8 — Product Design Exploration

This document explores information hierarchy for the Today screen.

It is not a visual design.

It does not define color, typography, spacing measurements, components, or implementation.

It explores:

- Information hierarchy
- Reading flow
- Emotional feeling
- User attention

Source of truth: `Docs/Product/Today-Experience.md`

---

# Exploration Rules

These constraints guided every concept:

1. Primary Rhythm must dominate within one second.
2. Progress stays intentionally quiet and low priority.
3. The screen must never feel like a task manager.
4. One Rhythm at a Time is non-negotiable.
5. Calm over Busy is the emotional filter for every layout.
6. The app should invite recognition, then release the user back to life.

---

# Concept 1 — Soft Card

## Philosophy

A single calm card holds the day's center.

The feeling is familiar, contained, and gently assured — like holding one clear thought in the hand.

## Strengths

- Instant focus: the eye lands on one object immediately
- Clear separation between primary rhythm and everything else
- Meaning and action live together without competition
- Easy to understand across states (Current, Upcoming, Past Incomplete)

## Weaknesses

- Card framing can feel slightly product-like or app-template-like
- If secondary content sits too close, the card stops feeling singular
- Risks becoming "a nice task card" if meaning is underplayed

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│           Good Morning               │
│           Friday, July 24            │
│                                      │
│                                      │
│      ┌────────────────────────┐      │
│      │                        │      │
│      │     Morning Walk       │      │
│      │                        │      │
│      │  Take a short walk     │      │
│      │  before work.          │      │
│      │                        │      │
│      │  07:30 – 08:00         │      │
│      │                        │      │
│      │       [ Done ]         │      │
│      │                        │      │
│      └────────────────────────┘      │
│                                      │
│                                      │
│              Next                    │
│           Drink Water                │
│              09:00                   │
│                                      │
│                                      │
│            Progress                  │
│            ●●○○○                     │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 2 — Paper Layout

## Philosophy

The screen reads like a quiet page.

The feeling is reflective and unhurried — as if today's rhythm were written once, clearly, then left alone.

## Strengths

- Strong top-to-bottom reading flow
- Meaning naturally follows the rhythm title, like a paragraph after a heading
- Feels literary rather than operational
- Progress can sit at the bottom like a footnote, not a score

## Weaknesses

- Vertical stacking can invite scanning like a document checklist
- Without strong size hierarchy, Next and Progress may compete with Primary
- May encourage lingering longer than needed (reading instead of returning to life)

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│  Friday, July 24                     │
│                                      │
│  ─────────────────────────────────   │
│                                      │
│  Morning Walk                        │
│                                      │
│  Take a short walk before work.      │
│                                      │
│  07:30 – 08:00                       │
│                                      │
│  Done                                │
│                                      │
│  ─────────────────────────────────   │
│                                      │
│  Later                               │
│  Drink Water · 09:00                 │
│                                      │
│                                      │
│                                      │
│  ●●○○○                               │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 3 — Minimal Timeline

## Philosophy

Time becomes a thin vertical thread.

The feeling is oriented and sequential — the day has order, but only the present moment is fully lit.

## Strengths

- Clear sense of continuity through the day
- Natural place for Past / Current / Next without equal weight
- Helps users who want gentle orientation in time
- Primary can still dominate if only the current node is expanded

## Weaknesses

- Timeline language easily drifts toward schedule management
- Multiple nodes risk becoming a task list in disguise
- Progress and next can visually "stack" into busyness
- Harder to protect Instant Orientation if the eye starts counting steps

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│           Friday, July 24            │
│                                      │
│                                      │
│   ○  Stretch                         │
│      06:45                           │
│                                      │
│   ●  Morning Walk                    │
│      Take a short walk before work.  │
│      07:30 – 08:00                   │
│                                      │
│           [ Done ]                   │
│                                      │
│   ○  Drink Water                     │
│      09:00                           │
│                                      │
│   ○  Evening Wind Down               │
│      21:00                           │
│                                      │
│                                      │
│            ●●○○○                     │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 4 — Floating Presence

## Philosophy

The primary rhythm floats alone in open space.

The feeling is spacious, almost meditative — one clear presence surrounded by quiet air.

## Strengths

- Maximum dominance for Primary Rhythm
- Empty space itself communicates Calm over Busy
- Instant Orientation is nearly automatic
- Next and Progress become peripheral whispers, not companions
- Strongly resists task-manager reading

## Weaknesses

- Extreme emptiness can feel incomplete if meaning is too thin
- Supporting information may become hard to discover
- Requires discipline: any added decoration breaks the stillness
- Day Complete and Empty states need careful emotional handling so space does not feel hollow

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│                                      │
│                                      │
│                                      │
│           Morning Walk               │
│                                      │
│     Take a short walk before work.   │
│                                      │
│           07:30 – 08:00              │
│                                      │
│                                      │
│             [ Done ]                 │
│                                      │
│                                      │
│                                      │
│                                      │
│                                      │
│     Next · Drink Water               │
│                                      │
│            ●●○○○                     │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 5 — Journal Style

## Philosophy

Today feels like a private entry.

The feeling is intimate and human — not tracking a habit, but noticing a moment in the day.

## Strengths

- Soft language and narrative meaning feel natural
- Completion can read as acknowledgment ("quietly done") rather than checking off
- Emotionally distant from productivity culture
- Works well with Past Incomplete as gentle continuation, not failure

## Weaknesses

- Journal framing can invite reflection and staying
- May blur the line between presence and diary writing
- Hierarchy can soften too much: everything feels equally "written"
- Instant Orientation depends heavily on typographic dominance (out of scope here, but structurally fragile)

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│  Today                               │
│  Friday, July 24                     │
│                                      │
│                                      │
│  This morning's rhythm               │
│                                      │
│  Morning Walk                        │
│                                      │
│  A short walk before work —          │
│  a quiet start to the day.           │
│                                      │
│  from 07:30 to 08:00                 │
│                                      │
│                                      │
│  Mark as quietly done                │
│                                      │
│                                      │
│  After this                          │
│  Drink Water at 09:00                │
│                                      │
│  The day so far  ●●○○○               │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 6 — Calm Dashboard

## Philosophy

A soft overview of the day, arranged with restraint.

The feeling aims for clarity and control — everything in its place, nothing shouting.

## Strengths

- Users quickly see Primary, Next, and Progress as distinct zones
- Familiar mental model for people used to home screens
- Easy to map states into labeled areas
- Useful for testing what "too much information" feels like

## Weaknesses

- Dashboard structure naturally encourages management
- Multiple zones compete even when one is larger
- Progress becomes easier to over-emphasize
- Strongest risk of feeling like a productivity surface
- Weakest alignment with "the app should not ask them to stay"

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│  Good Morning            Fri, Jul 24  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Now                            │  │
│  │ Morning Walk                   │  │
│  │ Take a short walk before work. │  │
│  │ 07:30 – 08:00        [ Done ]  │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌──────────────┐  ┌──────────────┐  │
│  │ Next         │  │ Progress     │  │
│  │ Drink Water  │  │ ●●○○○        │  │
│  │ 09:00        │  │ 2 of 5       │  │
│  └──────────────┘  └──────────────┘  │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 7 — Spotlight Stage

## Philosophy

The screen behaves like a stage with one performer.

The feeling is clear, present, and quietly dramatic — attention is directed, not demanded.

## Strengths

- Primary Rhythm is unmistakably the center
- Supporting cues can live at the edges like stage lights, not co-stars
- Strong Instant Orientation through spatial centering
- Action can appear as a single available gesture under the spotlight
- Emotionally distinct from lists, dashboards, and cards

## Weaknesses

- "Stage" energy can tip toward performance if completion feels like applause
- Edge content (Next, Progress) must stay truly peripheral or the metaphor collapses
- Can feel sparse on large screens if meaning text is too short
- Past Incomplete needs careful tone so the spotlight never feels accusatory

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│                 · · ·                │
│                                      │
│                                      │
│                                      │
│           Morning Walk               │
│                                      │
│     Take a short walk before work.   │
│                                      │
│           07:30 – 08:00              │
│                                      │
│                                      │
│             [ Done ]                 │
│                                      │
│                                      │
│                                      │
│  Next: Drink Water                   │
│                           ●●○○○      │
│                                      │
└──────────────────────────────────────┘
```

---

# Concept 8 — Breath Column

## Philosophy

Content arrives as a narrow vertical breath.

The feeling is slow, centered, and almost ceremonial — one line, then another, then rest.

## Strengths

- Extremely controlled reading flow
- Hierarchy can be expressed through sequence and pause rather than panels
- Naturally resists multi-column busyness
- Action appears as a pause in the breath, not a toolbar
- Strong emotional fit with "One moment. Then return to life."

## Weaknesses

- Narrow sequencing can feel sparse or incomplete
- Users may scroll or hunt for Next/Progress if they are too far below
- Less forgiving if Primary Meaning is long
- Can feel poetic in a way that slows brief interaction

## ASCII Wireframe

```
┌──────────────────────────────────────┐
│                                      │
│                                      │
│               Friday                 │
│                                      │
│                                      │
│            Morning Walk              │
│                                      │
│                                      │
│         Take a short walk            │
│           before work.               │
│                                      │
│                                      │
│           07:30 – 08:00              │
│                                      │
│                                      │
│              [ Done ]                │
│                                      │
│                                      │
│                                      │
│            Drink Water               │
│               soon                   │
│                                      │
│              ●●○○○                   │
│                                      │
└──────────────────────────────────────┘
```

---

# Cross-Concept Comparison

| Concept            | Instant Focus | Calm Feeling | Task-Manager Risk | Progress Restraint | Return-to-Life Fit |
|--------------------|---------------|--------------|-------------------|--------------------|--------------------|
| Soft Card          | High          | High         | Medium            | High               | High               |
| Paper Layout       | Medium-High   | High         | Medium            | High               | Medium             |
| Minimal Timeline   | Medium        | Medium       | High              | Medium             | Medium             |
| Floating Presence  | Very High     | Very High    | Very Low          | Very High          | Very High          |
| Journal Style      | Medium        | Very High    | Low               | High               | Low-Medium         |
| Calm Dashboard     | Medium        | Low-Medium   | Very High         | Low                | Low                |
| Spotlight Stage    | Very High     | High         | Low               | High               | High               |
| Breath Column      | High          | Very High    | Very Low          | High               | Medium             |

---

# Recommendation

**Recommended concept: Floating Presence**

## Why

Floating Presence best represents both product principles without compromise.

### One Rhythm at a Time

The layout has almost nowhere else for attention to go.

Primary Rhythm occupies the emotional and spatial center.
Next and Progress exist only as quiet periphery.
There is no second panel, no competing column, no timeline of peers.

Within one second, the user understands today's focus because the screen offers almost nothing else to understand.

### Calm over Busy

Open space is not decoration here — it is the message.

Busy interfaces create management.
This layout creates recognition.

The screen does not ask the user to compare, prioritize, or survey the day.
It offers one presence, one meaning, one gentle action, then silence.

That silence is what invites the return to life.

## Why not the closest alternatives

- **Spotlight Stage** is nearly as strong, but its theatrical metaphor risks turning acknowledgment into performance.
- **Soft Card** is clear and safe, yet the card container can still read as "an item to complete."
- **Breath Column** is emotionally beautiful, but its sequential reading can slow the brief interaction Today needs.
- **Journal Style** protects calm language, yet it invites staying and reflecting — the opposite of release.
- **Minimal Timeline** and **Calm Dashboard** orient well, but both reopen the door to day management.

## Product Integrity Check

Guiding question from Today Experience:

> Does this help the user reconnect with the one rhythm that matters most right now, understand it effortlessly, take one gentle action if needed, and confidently return to life?

Floating Presence answers yes most cleanly.

It protects Instant Orientation.
It protects Gentle Progress by demoting progress to the edge.
It protects Minimal Decision Making by refusing to present alternatives as equals.
It protects Return to Life by making the screen feel finished as soon as recognition happens.

---

# Out of Scope

This exploration does not decide:

- Visual design system
- Color or typography
- Exact spacing or component APIs
- SwiftUI structure
- Animation behavior
- Empty / Upcoming / Past Incomplete / Day Complete visual treatments in detail
- Widget, Live Activity, or Watch layouts

Those belong to later Product Design or implementation work.

---

# Next Suggested Step

Translate Floating Presence into a state-by-state information map:

- Empty
- Upcoming
- Current
- Past Incomplete
- Day Complete

Still without visual design.

Only hierarchy, attention, and emotional tone per state.

# Sprint 8 — Today Experience Exploration

Do NOT write SwiftUI code.

Do NOT implement anything.

This Sprint is a Product Design exploration.

---

## Context

Read first:

- Docs/Product/Today-Experience.md

This document is the source of truth.

The goal is to translate the Product philosophy into a visual information hierarchy.

---

## Task

Create a new document:

Docs/Product/Today-Wireframe-Exploration.md

---

## Objective

Explore multiple Today screen layouts.

Not visual design.

Not colors.

Not typography.

Only:

- Information hierarchy
- Reading flow
- Emotional feeling
- User attention

---

## Create at least 6 different concepts.

Each concept should have:

# Concept Name

## Philosophy

What feeling does this layout create?

## Strengths

## Weaknesses

## ASCII Wireframe

Simple text layout.

Example:

Good Morning ☀️

Friday, July 24

Morning Walk

Take a short walk before work.

07:30 – 08:00

[ Done ]

Next

Drink Water

09:00

Progress

●●○○○

---

## Explore different directions.

Examples:

- Soft Card
- Paper Layout
- Minimal Timeline
- Floating Card
- Journal Style
- Calm Dashboard

Do NOT stop at obvious ideas.

Explore different emotional directions.

---

## Important

Progress is intentionally low priority.

Primary Rhythm must always dominate.

The screen should never feel like a task manager.

The user should understand today's focus within one second.

---

## At the end

Recommend ONE concept.

Explain why it best represents:

"One Rhythm at a Time"

and

"Calm over Busy"

without considering implementation difficulty.
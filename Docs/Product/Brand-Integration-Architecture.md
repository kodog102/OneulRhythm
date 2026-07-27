# Brand Integration Architecture

This document defines how the OneulRhythm Brand System is expressed across the product.

It specifies:

- Where brand presence appears
- Where brand presence intentionally disappears
- How product language stays consistent
- How completion and progress remain presence-first

It does not redesign screens, define layout measurements, or prescribe SwiftUI structure.

**Status:** Approved Architecture Specification.  
**Decision record:** `Docs/Architecture/Decisions/DR-017-brand-integration.md`.  
**Basis:** Sprint 15-3A Brand Integration Review.

---

# Purpose

Provide architectural rules so every surface speaks one emotional language after Launch and Welcome are established.

Whenever ambiguity exists:

1. `PRODUCT-PRINCIPLES.md` / `BRAND.md` / ADR-010 / ADR-011 / ADR-012  
2. This Specification  
3. Surface UI contracts (`Welcome-UI-Specification.md`, `Today-UI-Specification.md`, `Launch-UI-Specification.md`, …)  
4. Engineering implementation  

DR-015 and DR-016 remain authoritative for Welcome lifecycle and Launch startup.

---

# 1. Brand Architecture Principles

## P1 — Brand enters, then steps aside

Breath Flow introduces the product.

After the first rhythm begins, the user’s rhythm is the hero.

Brand presence must not compete with today’s focus.

## P2 — Presence over explanation

Meaning is carried by hierarchy, whitespace, calm motion, and quiet language.

Do not solve brand gaps by adding more brand chrome, slogans, or decorative marks.

## P3 — One hero per surface

Every primary screen has exactly one emotional center.

Secondary chrome stays secondary.

## P4 — Completion is acknowledgment, not scoring

Acknowledging a rhythm preserves continuity.

Counting finished items must never become the product’s identity (ADR-011).

## P5 — Same voice across surfaces

In-app Today, Live Activity, notifications, and future Widget / Watch surfaces share:

- Cream / sage emotional field where color applies
- Presence-first vocabulary
- Breath Flow identity when a mark is required

They do not invent parallel mascots, emoji stand-ins, or productivity slogans.

## P6 — Utility may be plain; it must not become checklist identity

Management and Create may use clear operational language.

They must not export checklist metaphors back into Today, Launch, or Welcome.

---

# 2. Brand Presence Hierarchy

Breath Flow is the only primary brand mark (ADR-010).

Same visual identity. Different purpose by surface class.

## Identity Surfaces — Brand is primary

| Surface | Breath Flow role | Rule |
|---------|------------------|------|
| **App Icon** | Identity | Required. Production Release master. |
| **Launch** | Presence | Quiet centered presence. No meaning copy. DR-016 / Launch UI Spec. |
| **Welcome** | Meaning | Brand presence supports product introduction with Hero Meaning. Welcome UI Spec. |

### Identity rules

- Breath Flow may be the visual hero.
- Product introduction language may appear only on Welcome — not on Launch or App Icon.
- Do not add secondary marks, wordmarks, or taglines that compete with Breath Flow.
- Do not repeat Welcome’s full introduction after First Journey ends (DR-015).

## Experience Surfaces — Brand supports; user rhythm is hero

| Surface | Breath Flow | Rule |
|---------|-------------|------|
| **Today (active)** | Absent as Hero | Primary rhythm title is the hero. |
| **Day Complete** | Absent as Hero | Quiet closure line is the hero. |
| **Normal Empty** | Absent | Quiet invitation only — never Welcome re-introduction. |
| **Today atmosphere** | Absent | Greeting / Date remain atmosphere only. |

### Experience rules

- Do not place Breath Flow as a competing hero beside the primary rhythm.
- Do not use Breath Flow as empty-state decoration on Normal Empty.
- Cream field and quiet motion carry continuity from Launch / Welcome.
- Toolbar and progress remain quieter than the hero.

## Utility Surfaces — Brand intentionally steps back

| Surface | Breath Flow | Rule |
|---------|-------------|------|
| **My Rhythms / Management** | Absent | Operational overview. Cream/sage tokens only. |
| **Create Rhythm** | Absent | Form clarity over brand theater. |
| **Edit Rhythm** | Absent | Same as Create. |
| **Settings** | Absent as Hero | Quiet chrome; no onboarding mark. DR-020 / Settings Architecture. |
| **Alerts / confirmation dialogs** | Absent | System patterns; calm copy only. |

### Utility rules

- Do not brand-splash Management or Create with Breath Flow.
- Do not turn utility screens into second Welcome surfaces.
- Visual tokens (cream, sage, soft radius) persist; mark presence does not.
- Destructive and CRUD actions may be plain; they must stay off Today’s emotional center.

---

# Brand Presence Matrix

| Surface | Class | Breath Flow | Hero | Brand job |
|---------|-------|-------------|------|-----------|
| App Icon | Identity | Yes — identity | Mark | Recognize |
| Launch | Identity | Yes — presence | Mark + field | Quiet inhale |
| Welcome | Identity | Yes — meaning | Mark + Hero Meaning | Introduce |
| Today active | Experience | No (as Hero) | Primary rhythm | Accompany |
| Day Complete | Experience | No | Closure line | Close calmly |
| Normal Empty | Experience | No | Minimal invitation | Quiet path forward |
| My Rhythms | Utility | No | List / task at hand | Manage |
| Create / Edit | Utility | No | Form fields | Capture |
| Settings | Utility | No | Preference groups | Configure |
| Live Activity | Experience (platform) | Yes when a mark is needed | Current rhythm / quiet status | Remain present |
| Widget (future) | Experience (platform) | Optional quiet presence | Today’s rhythm | Glance continuity |
| Watch (future) | Experience (platform) | Optional minimal presence | Current rhythm | Glance continuity |

---

# 3. Product Language Dictionary

Canonical emotional voice: calm, human, non-judgmental, presence-first.

## Core concepts

### Acknowledging a rhythm (completion action)

| | |
|--|--|
| **Preferred** | Presence-oriented acknowledgment that the rhythm was lived / continued (product direction: align toward the `이어냈어요` family) |
| **Acceptable interim** | `완료했어요` while migration is incomplete — treat as legacy-facing action label, not brand slogan |
| **Forbidden as identity** | Checklist celebration, streak copy, “Done!”, scoreboard triumph, productivity hype |

**Architectural intent:** Action labels should eventually match Completion Philosophy (acknowledgment), not task-manager “complete.”

### Day closure

| | |
|--|--|
| **Preferred** | `오늘의 리듬을 모두 이어냈어요.` |
| **Acceptable** | Equivalent presence closure that avoids scoring |
| **Avoid** | Divergent platform lines that reframe closure as performance (`잘 마무리했어요` as a parallel brand line) |
| **Forbidden** | “All tasks done”, badges, confetti copy |

**Rule:** Today and Live Activity should converge on one closure voice.

### Creating a rhythm

| | |
|--|--|
| **Preferred (Welcome)** | `오늘의 첫 리듬 만들기` |
| **Preferred (Normal Empty / quiet create)** | Soft invitation that remains quieter than Welcome philosophy |
| **Acceptable (utility)** | `리듬 만들기`, `리듬 저장하기` on Create / Management |
| **Avoid** | `시작하기`, `Get started`, `Next`, bare setup funnel language on Welcome |
| **Forbidden** | Wizard step language on Identity / Experience surfaces |

### Adding / editing (utility)

| Concept | Preferred | Acceptable | Avoid / Forbidden |
|---------|-----------|------------|-------------------|
| Create screen title | `리듬 추가` (utility-plain) | Soft equivalent | Marketing slogans |
| Edit screen title | `리듬 편집` | Soft equivalent | — |
| Persist create | `리듬 저장하기` | Soft equivalent | `등록` as primary brand verb on Experience surfaces |
| Persist edit | `변경 저장하기` | Soft equivalent | — |
| Schedule confirmation | Prefer human time framing | `오늘로 등록` / `내일로 등록` as interim utility | Treating “등록” as emotional success copy |

**Rule:** `저장` is acceptable utility language. `등록` is utility-only and must not become Today hero language.

### Management chrome

| | |
|--|--|
| **Preferred visual role** | Quiet secondary trailing control |
| **Acceptable label** | `관리` while no calmer approved synonym exists |
| **Architectural intent** | Keep caption-level weight; never compete with Today / Welcome hero |
| **Forbidden** | Promoting Management to primary CTA; Management entry on Welcome |

### Loading / system status

| | |
|--|--|
| **Acceptable** | Brief status such as loading rhythms |
| **Forbidden** | Branding the wait; fake progress; setup checklist loading |

---

# 4. Completion Philosophy

## Definition

**Completion means acknowledging that a rhythm received attention.**

It does not mean winning a day.

It does not mean maximizing finished items.

It does not mean scoring the self.

## Consequences

### Button labels

- Prefer acknowledgment language over checklist “done” identity.
- One primary acknowledgment control per completable rhythm.
- No secondary “snooze / defer” patterns as brand-default behavior on Today.

### Success / closure copy

- Day Complete speaks continuity (`이어냈어요` family).
- No celebratory interstitial, badge, or confetti.
- Success is quiet return to calm presence — or quiet Day Complete — not a reward screen.

### Live Activity

- Reflect the same acknowledgment philosophy as Today.
- Closure copy must not invent a louder or more evaluative variant.
- When a mark is shown, use Breath Flow identity — not emoji substitutes.

### Accessibility wording

- Announce acknowledgment and state changes calmly.
- Avoid score-first summaries as the primary VoiceOver identity of the day (“X of Y completed” as the emotional headline).
- Counts may exist for orientation; they must not become the story.

---

# 5. Progress Architecture

## Role of progress

Progress is **orientation**, not identity.

It may help the user sense the shape of the day.

It must never become a productivity scoreboard (ADR-011).

## When progress may be visible

- During Active Today states where multiple rhythms exist and quiet orientation helps
- As a subordinate Level element — always below Primary Rhythm

## When progress must step back

- **Welcome** — hidden
- **Normal Empty** — hidden
- **Day Complete** — must not compete with closure; prefer hidden or non-score presentation so `이어냈어요` remains the only hero
- **Launch** — never
- **Utility screens** — not as Today-style day scoring

## When progress becomes a score (reject)

Progress has become a score when:

- Counts are the optical or emotional center
- Day Complete is framed as `N / N` triumph
- Copy emphasizes finishing quantity over presence
- Visual treatment resembles checklist completion meters as brand identity

## Active Today vs Day Complete

| State | Progress role |
|-------|----------------|
| **Active Today** | Optional quiet orientation under the primary rhythm |
| **Day Complete** | Steps fully back; closure line owns the surface |

Do not redesign meters in this document — only enforce that Day Complete is not a score screen.

---

# 6. Cross-Surface Rules

## What persists everywhere (identity continuity)

| Element | Persists? | Why |
|---------|-----------|-----|
| Calm emotional field (cream family where backgrounds apply) | Yes | Continuity from Launch into product |
| Sage emphasis as quiet action color | Yes | Soft geometry / calm action |
| Quiet motion (fade / settle; Reduce Motion) | Yes | Brand motion language |
| Presence-first vocabulary | Yes | One voice |
| Breath Flow geometry (when a mark is required) | Yes | ADR-010 single symbol |

## What intentionally disappears

| Element | Disappears after | Why |
|---------|------------------|-----|
| Launch centered presence mark | First interactive frame | Bridge only |
| Welcome philosophy + first-rhythm CTA framing | First successful rhythm (DR-015) | Introduction ends |
| Breath Flow as Hero | Experience / Utility surfaces | User rhythm becomes center |
| Brand tagline as UI chrome | Outside optional quiet whisper rules | Presence over explanation |

## Platform surfaces

| Surface | Persist | Disappear | Rule |
|---------|---------|-----------|------|
| **Live Activity** | Cream/sage field; rhythm title; Breath Flow if mark needed; shared closure voice | Emoji mascots; scoreboard; Welcome philosophy | Remain present with the day — do not re-introduce the product |
| **Widget (future)** | Glance of today’s rhythm; calm field; optional quiet mark | Full Welcome composition; Management chrome | Glance continuity, not branding poster |
| **Apple Watch (future)** | Current rhythm presence; minimal chrome | Decorative brand theater | Smallest faithful presence |

## Consistency test

> If the Home Screen icon, Launch, Today, and Live Activity were shown in sequence, would they feel like one companion — or like a branded splash followed by a different productivity app?

If the latter, identity has fractured.

---

# 7. Legacy Notes

The following patterns conflict with Brand Integration Architecture.

They are **legacy guidance only**. This document does not require immediate deletion or redesign, but they must not be treated as brand-approved defaults for new work.

| Legacy item | Why it conflicts | Guidance |
|-------------|------------------|----------|
| **Orphan `RoutineCardView` patterns** | Encodes older card + completion framing | Do not revive as Today hero template without Brand review |
| **Snooze / `10분 뒤에 하기`** | Deferral / checklist-adjacent control on Today | Not part of Brand Architecture; reject as default Today interaction |
| **Checklist metaphors as identity** | Violates ADR-011 | Counts may orient; must not brand the product |
| **Score-like Day Complete progress** | Competes with acknowledgment closure | Progress must step back on Day Complete |
| **Live Activity leaf emoji (`🌿`)** | Parallel mark; not Breath Flow | Replace with Breath Flow identity when platform work allows |
| **Divergent closure copy across surfaces** | Breaks one voice | Converge on Today’s presence closure family |
| **Interim `완료했어요` as long-term identity** | Task-complete tone | Acceptable only until acknowledgment wording is unified |
| **Welcome-as-Empty framing** | Superseded by Welcome Experience | Do not reintroduce Empty naming for First Journey |

---

# 8. Final Architectural Decision

## Decision

OneulRhythm expresses brand through a **presence hierarchy**, not through repeated decoration.

1. **Identity Surfaces** (Icon, Launch, Welcome) own Breath Flow.  
2. **Experience Surfaces** (Today family) own the user’s rhythm; brand supports through field, type, motion, and language.  
3. **Utility Surfaces** stay visually related but mark-free.  
4. **Completion is acknowledgment**; progress is orientation; neither is a score identity.  
5. **Cross-surface identity** prefers Breath Flow + shared voice over emoji or divergent slogans.  
6. **Legacy checklist / snooze / orphan card patterns** are non-authoritative for new work.

## Non-goals

- New brand marks or alternate symbols  
- Adding Breath Flow to Management / Create / Normal Empty  
- Turning utility copy into marketing poetry  
- UI redesign of Today, Welcome, or Launch in this document  

## Success condition

Across the product, a user should feel:

> The same calm companion met me at Launch, introduced itself once on Welcome, then stayed quietly with my rhythm — without asking me to perform productivity.

## Guiding question

> Does this surface keep Breath Flow, language, completion, and progress in their correct roles — so brand presence never competes with today’s rhythm?

If the answer is no, it does not belong in Brand Integration Architecture.

---

# Relationship to Existing Authority

| Authority | Relationship |
|-----------|--------------|
| `BRAND.md` / ADR-010 | Breath Flow identity |
| ADR-011 | No checklist metaphor as identity |
| ADR-012 | Calm before productivity |
| DR-015 | Welcome lifecycle boundary |
| DR-016 | Launch presence bridge |
| Welcome / Launch specs | Identity surface contracts |
| Today / Management UI specs | Experience / utility presentation |
| Sprint 15-3A Review | Empirical basis for language and Live Activity gaps |

---

# Out of Scope

- Exact SwiftUI components or point sizes  
- Immediate copy migrations (implementation sprints)  
- Widget / Watch layout design  
- Creating an in-app Settings IA beyond brand role (see DR-020 / `Settings-Architecture.md`)  

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`
- `Docs/ADR/ADR-011-No-Checklist-Metaphor.md`
- `Docs/ADR/ADR-012-Calm-Before-Productivity.md`
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`
- `Docs/Architecture/Decisions/DR-016-launch-experience.md`
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`
- `Docs/Architecture/Decisions/DR-021-visual-identity-warm-light-appearance.md`
- `Docs/Product/Welcome-Experience.md`
- `Docs/Product/Welcome-UI-Specification.md`
- `Docs/Product/Launch-Architecture-Specification.md`
- `Docs/Product/Launch-UI-Specification.md`
- `Docs/Product/Today-UI-Specification.md`
- `Docs/Product/Management-UI-Specification.md`

---

One rhythm at a time.

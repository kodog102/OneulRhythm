# Today UI Specification

This document defines the implementation-ready UI specification for the Today screen.

It translates the approved Product Experience into concrete UI behavior.

This document specifies what should appear, when it should appear, and how each component behaves.

It does not redefine Product Experience (`Docs/Product/Today-Experience.md`), Product Philosophy (`Docs/Product/PRODUCT-PHILOSOPHY.md`), or Architecture.

---

# Purpose

The purpose of this specification is to provide a single implementation contract for the Today screen.

Every implementation must follow this document before introducing new UI decisions.

Whenever ambiguity exists:

1. Product Experience

2. This Specification

3. Engineering implementation

---

# Screen Composition

The Today screen follows a single vertical flow.

Information appears in the following order.

Greeting

↓

Date

↓

Primary Rhythm Area

- Primary Rhythm
- Rhythm Meaning (when available)
- Time

↓

Next Rhythm Area (Optional)

↓

Progress Area (Optional)

No additional primary sections must exist.

The experience must feel light, calm, and spacious.

---

# Screen Rules

## One Primary Focus

Exactly one Primary Rhythm Area exists at any time.

No secondary component may compete for equal visual attention.

---

## Vertical Flow

Information flows vertically.

Primary information must never be presented side by side.

---

## Intentional Whitespace

Whitespace is part of the experience.

Empty space must never be filled simply because room exists.

Spacing helps the user understand importance.

---

## Calm Density

The screen must contain only information necessary for the current moment.

If information does not help the user understand today's rhythm, it must not appear.

The Create Rhythm CTA is the sole exception: it appears only in Empty so the user can begin or continue when Today has no rhythm.

---

# State Specifications

## Empty

Empty appears when Today has zero routines for the day.

Empty has two phases. The phase is chosen by whether the user has ever successfully created a rhythm (First Journey vs Normal Experience). It is not chosen by current routine count, launch count, or installation date.

Hidden in both Empty phases

- Primary Rhythm
- Primary Action
- Next Rhythm
- Progress

The Create Rhythm CTA is the only interactive control in Empty.

No additional controls may appear in this state.

See DR-015 — First Rhythm Onboarding Lifecycle.

---

### Phase 1 — First Journey Empty

> **Superseded for UI presentation by Welcome.**
>
> Product design: `Docs/Product/Welcome-Experience.md`  
> UI contract: `Docs/Product/Welcome-UI-Specification.md`
>
> DR-015 lifecycle (when Phase 1 applies) remains authoritative.  
> Do not implement the legacy First Journey Empty layout below for new work.

Purpose

Introduce OneulRhythm and invite the user to create their first rhythm.

When it appears

- Today has zero routines for the day
- The user has not yet successfully created a first rhythm

UI hierarchy

Greeting

↓

Date

↓

Hero Message

↓

Philosophy Card

↓

Primary CTA

↓

Brand footer

Approved Copy

Hero Message

오늘을  
하나의 리듬으로  
시작해보세요.

Philosophy Card

모든 것을 끝내는 앱이 아니에요.

지금 가장 중요한 하나의 리듬에 집중하도록 도와줘요.

Primary CTA

오늘의 첫 리듬 만들기

Brand footer

One rhythm at a time.

Primary CTA

- Opens the routine creation flow
- Visually primary invitation
- Must feel calm, not urgent

Brand footer

- Quiet brand introduction
- Must never compete with the Hero Message or Primary CTA

Notes

- First Journey Empty is part of onboarding, not a broken-day message
- Philosophy Card and brand footer appear only in this phase
- Cancelling create keeps First Journey Empty
- **New implementation must follow Welcome-UI-Specification instead of this legacy Phase 1 block**

---

### Phase 2 — Normal Experience Empty

Purpose

Provide calm, minimal guidance when Today is empty after the user has already begun their rhythm life.

When it appears

- Today has zero routines for the day
- The user has already successfully created at least one rhythm

UI hierarchy

Greeting

↓

Date

↓

Minimal Hero / Empty Guidance

↓

Primary CTA

Approved Copy

Minimal Hero / Empty Guidance

오늘의 리듬을 만들어보세요.

Primary CTA

리듬 만들기

Primary CTA

- Opens the routine creation flow
- Quieter than First Journey Empty
- Must feel like a gentle invitation, not product introduction

Notes

- No Philosophy Card
- No brand footer
- No repeated product introduction
- Deleting every rhythm does not restore First Journey Empty
- Only a fresh install or cleared app data returns to First Journey

---

## Upcoming

Visible

- Greeting
- Date
- Upcoming Rhythm
- Rhythm Meaning
- Time
- Progress (Optional)

Hidden

- Completion Button
- Create Rhythm CTA

---

## Current

Visible

- Greeting
- Date
- Primary Rhythm
- Rhythm Meaning
- Time
- Completion Button
- Next Rhythm (Optional)
- Progress (Optional)

Hidden

- Empty Guidance
- Day Complete Message
- Create Rhythm CTA

---

## Past Incomplete

Visible

- Greeting
- Date
- Past Rhythm
- Rhythm Meaning
- Time
- Completion Button
- Next Rhythm (Optional)
- Progress (Optional)

Hidden

- Empty Guidance
- Create Rhythm CTA

Past Incomplete must feel like a gentle continuation rather than a missed task.

---

## Day Complete

Visible

- Greeting
- Date
- Day Complete Message
- Progress (Optional)

Hidden

- Primary Rhythm
- Next Rhythm
- Completion Button
- Create Rhythm CTA

The screen must communicate quiet closure.

---

# CTA Visibility Contract

The Create Rhythm CTA is an Empty-only affordance.

It is not part of non-Empty Today states.

## Show Create Rhythm CTA

Show the Create Rhythm CTA only when:

- Today has zero routines.

This corresponds exclusively to the Empty state.

Empty phase (First Journey vs Normal Experience) determines CTA presentation and copy. Phase selection follows journey completion, not current routine count.

## Hide Create Rhythm CTA

Hide the Create Rhythm CTA when any of the following states apply:

- Upcoming
- Current
- Past Incomplete
- Day Complete

Once at least one routine exists for the day, the CTA must disappear completely.

The CTA must not reappear for the remainder of that day.

---

# UX Rationale — Create Rhythm CTA

## Empty Affordance

The Create Rhythm CTA exists so Empty never becomes a dead-end.

In First Journey Empty, it invites the first rhythm.

In Normal Experience Empty, it quietly allows creating a rhythm for an empty day after onboarding has ended.

## Not Non-Empty Today Experience

The CTA is intentionally excluded from Upcoming, Current, Past Incomplete, and Day Complete.

It is not routine management.

It does not compete with Primary Rhythm.

It does not persist once the day has content.

## Product Consistency

This affordance remains consistent with:

- **One Rhythm at a Time** — The CTA appears only when no rhythm exists for the day. It disappears as soon as Today has a rhythm to present.
- **Show Only What Matters Now** — When routines exist, Today shows only what matters for the current moment. The CTA does not belong in those states.
- **Calm Over Pressure** — The CTA supports a gentle invitation. It must not feel urgent, persistent, or like ongoing management.
- **First Rhythm Onboarding Lifecycle (DR-015)** — Onboarding presentation ends after the first successful rhythm creation and does not return when later Empty days occur.

Permanent routine management must not return to Today.

Ongoing Create, Edit, and Delete while rhythms exist belong in Routine Management (Sprint 9).

---

# Component Specifications

## Greeting

Purpose

Provide a warm emotional entry into Today.

Requirements

- Always visible.
- Changes according to time of day.
- Never interactive.

### Greeting Contract

Greeting copy is an approved Product Contract.

The greeting must change according to local time of day using the following ranges and strings.

Morning (05:00–11:59)

좋은 아침이에요.

Afternoon (12:00–17:59)

좋은 오후예요.

Evening (18:00–04:59)

편안한 저녁이에요.

No other greeting strings may be introduced without a new Product Decision.

---

## Date

Purpose

Provide temporal orientation.

Requirements

- Always visible.
- Secondary emphasis.

---

## Primary Rhythm

Purpose

Represent what deserves attention now.

Requirements

- Largest visual emphasis.
- Single line preferred.
- Maximum two lines.

---

## Rhythm Meaning

Purpose

Explain why this rhythm matters.

Requirements

- Appears directly below Primary Rhythm.
- Hidden when unavailable.
- Never replaced with placeholder text.

### Product Decision

Sprint 8 intentionally has no data source for Rhythm Meaning.

Rhythm Meaning must remain hidden.

No placeholder text may be shown.

Future Product Decisions may enable this component when a data source exists.

---

## Time

Purpose

Provide scheduling context.

Requirements

- Lower emphasis than Rhythm Meaning.
- Never visually dominate the Primary Rhythm.

---

## Completion Button

Purpose

Allow gentle acknowledgment.

Requirements

Visible only when completion is possible.

Never behaves as a call-to-action that pressures the user.

---

## Next Rhythm

Purpose

Provide quiet orientation for what follows.

Requirements

- Optional.
- Lower visual emphasis than Primary Rhythm.
- Must never become a second point of focus.

---

## Progress

Purpose

Provide a soft sense of movement through the day.

Progress exists only to provide quiet orientation.

Requirements

- Lowest visual emphasis.
- Positioned near the bottom of the screen.
- Optional.
- Must never become the primary focus.
- Must never compete with Primary Rhythm.
- Must always remain visually subtle.

---

## Empty Guidance

Purpose

Help the user begin when Today is empty.

Requirements

- Friendly.
- Calm.
- Never urgent.
- Phase-specific: First Journey uses Hero Message + Philosophy Card; Normal Experience uses Minimal Hero only.

Approved copy is defined in Approved Copy.

---

## Create Rhythm CTA

Purpose

Provide the Empty-only entry point to create a rhythm when Today has none.

Requirements

- Visible only in Empty.
- Hidden in all other states.
- Opens the routine creation flow.
- Must not compete with Primary Rhythm visual emphasis.
- Must feel like a gentle invitation, not a persistent call-to-action.
- Must disappear completely once at least one routine exists for the day.
- Copy and visual weight follow Empty phase (First Journey vs Normal Experience).

This component is an Empty affordance, not routine management.

Approved copy is defined in Approved Copy.

---

## Day Complete Message

Purpose

Close the day gently.

Requirements

- Calm.
- Short.
- Never celebratory.

Approved copy is defined in Approved Copy.

---

# Approved Copy

The following strings are approved Product copy for the Today screen.

No alternate Empty, Create Rhythm CTA, or Day Complete strings may be introduced without a new Product Decision.

#### First Journey Empty — Hero Message

오늘을  
하나의 리듬으로  
시작해보세요.

#### First Journey Empty — Philosophy Card

모든 것을 끝내는 앱이 아니에요.

지금 가장 중요한 하나의 리듬에 집중하도록 도와줘요.

#### First Journey Empty — Primary CTA

오늘의 첫 리듬 만들기

#### First Journey Empty — Brand footer

One rhythm at a time.

#### Normal Experience Empty — Minimal Hero / Empty Guidance

오늘의 리듬을 만들어보세요.

#### Normal Experience Empty — Primary CTA

리듬 만들기

#### Day Complete

오늘의 리듬을 모두 이어냈어요.

---

# Interaction Rules

## Completion Button

Enabled

- Current
- Past Incomplete

Hidden

- Empty
- Upcoming
- Day Complete

---

## Navigation

The Today screen must not require additional navigation to understand the current rhythm.

Secondary toolbar navigation (`관리`) opens Routine Management.

It must remain quiet and must never compete with Primary Rhythm.

Ongoing Create, Edit, and Delete while rhythms exist belong in Routine Management.

See `Docs/Product/Management-UI-Specification.md`.

---

## Create Rhythm CTA

Enabled

- Empty (zero routines for the day)

Hidden

- Upcoming
- Current
- Past Incomplete
- Day Complete

Action

- Opens the routine creation flow.
- Does not navigate away from Today permanently.
- After a routine is created, Today returns to the appropriate non-Empty state and the CTA must not reappear while routines remain for the day.
- Successful first rhythm creation ends First Journey permanently. Later Empty days use Normal Experience Empty.

---

## Recognition Before Interaction

Users must understand today's rhythm before deciding whether to interact.

---

# Visibility Rules

If Rhythm Meaning is unavailable

- Hide the component.
- Collapse the spacing.
- Do not show placeholder text.

---

If Next Rhythm is unavailable

- Hide the entire section.
- Do not preserve empty spacing.

---

If Progress is unavailable

- Hide the section completely.

---

If the screen enters Day Complete

- Remove the Primary Rhythm.
- Present quiet completion.

---

If Today has zero routines

- Show the Empty phase that matches journey completion:
  - First Journey Empty when the user has never successfully created a rhythm
  - Normal Experience Empty when the user has already successfully created a rhythm
- Hide Primary Rhythm, Next Rhythm, Progress, and Completion Button.

---

If Today has at least one routine

- Hide Create Rhythm CTA completely.
- Do not preserve spacing reserved for the CTA.

---

# Spacing Rules

Primary Rhythm owns the largest surrounding whitespace.

Whitespace must gradually decrease toward the bottom of the screen.

Supporting information must never visually crowd the Primary Rhythm.

---

# Typography Hierarchy

Level 1

Primary Rhythm

Level 2

Greeting

Level 3

Date / Rhythm Meaning

Level 4

Time

Level 5

Next Rhythm

Level 6

Progress

Level 7

Create Rhythm CTA (Empty only)

### Primary Rhythm hierarchy

Primary Rhythm is the emotional center.

It receives the strongest typography and surrounding whitespace.

Time, Completion, Next Rhythm, and Progress remain subordinate.

### Greeting hierarchy

Greeting and Date form one atmospheric header group above the Primary Rhythm Area.

Greeting welcomes the moment.

Date orients the day.

Neither may compete with Primary Rhythm for visual dominance.

In First Journey Empty, Hero Message leads; Philosophy Card supports; Primary CTA invites without replacing the hero.

In Normal Experience Empty, Minimal Hero leads; Primary CTA remains quieter and subordinate.

Typography must reinforce information hierarchy without relying solely on color.

---

# Animation Rules

Animations must confirm interaction.

Animations must never celebrate completion.

Animations must never compete for attention.

Motion must feel soft, quiet, and brief.

## Content Transition

When Today focus changes — Empty phase, Day Complete, or Primary Rhythm identity — content enters with a restrained transition.

Default motion

- Soft opacity fade combined with a slight vertical settle

Reduce Motion

- Opacity only
- No vertical offset

Loading toggles must not re-trigger content enter motion.

## Progress Animation

When progress value changes, the progress fill may animate quietly.

Default motion

- Soft ease-in-out fill update

Reduce Motion

- No progress fill animation

Progress motion must remain quieter than Primary Rhythm and must never feel like a score celebration.

---

# Accessibility

Information hierarchy must remain understandable without color.

Interactive elements must meet minimum touch target guidelines.

Dynamic Type must preserve hierarchy while avoiding layout collapse.

### Today accessibility contract

- Greeting is announced as a header.
- Primary Rhythm title is announced as a header.
- First Journey Philosophy Card is announced as one combined element.
- First Journey brand footer is decorative and hidden from VoiceOver.
- Create Rhythm CTA includes a quiet navigation hint.
- Completion Button includes a quiet completion hint while saving is in progress.
- Progress is announced as "오늘의 흐름" with a spoken completion summary.
- Reduce Motion softens content transition and disables progress fill animation.

---

# Implementation Notes

These notes clarify important implementation intent.

- Primary Rhythm remains the emotional center of the screen.
- Greeting remains an atmospheric entry and never outranks Primary Rhythm.
- Progress is supporting information, never the focus.
- Next Rhythm exists only for orientation.
- Past Incomplete reuses the same visual structure as Current whenever possible.
- Empty and Day Complete must follow the same visual language as the rest of Today.
- Empty has two phases per DR-015. Phase selection follows whether the user has ever successfully created a rhythm, not current routine count.
- Empty includes a Create Rhythm CTA only while Today has zero routines. It must not persist once routines exist for the day.
- First Journey Empty ends permanently after the first successful rhythm creation. Deleting every rhythm does not restore it.
- Existing creators receive Normal Experience through a one-time compatibility bootstrap on launch.
- Motion is restrained confirmation, never celebration.
- Spacing is part of the experience and must not be optimized away.
- Every component must justify its existence by helping the user understand today's rhythm, or by enabling Empty create when the day has no rhythm.
- Components without approved data must remain hidden.

---

# Out of Scope

This document does not define:

- Widget UI
- Live Activity UI
- Apple Watch UI
- Design Tokens
- SwiftUI implementation
- Layout constants
- Animation timing values
- Architecture
- Persistence technology
- Notification scheduling
- Routine creation flow details beyond the Empty-state entry point

The Create Rhythm CTA entry point is in scope for Empty only.

Routine creation form behavior, validation, and ongoing management flows belong to `Management-UI-Specification.md` and related Product or Engineering documents.

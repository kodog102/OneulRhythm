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

The Create Rhythm CTA is the sole exception: it appears only in Empty to enable first-time onboarding when no rhythm exists.

---

# State Specifications

## Empty

Visible

- Greeting
- Date
- Empty Guidance
- Create Rhythm CTA

Structure

Greeting

↓

Date

↓

Empty Guidance

↓

Create Rhythm CTA

Hidden

- Primary Rhythm
- Primary Action
- Next Rhythm
- Progress

The Create Rhythm CTA is the only interactive control in Empty.

No additional controls may appear in this state.

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

The Create Rhythm CTA is an onboarding affordance.

It is not part of the normal Today experience.

## Show Create Rhythm CTA

Show the Create Rhythm CTA only when:

- Today has zero routines.

This corresponds exclusively to the Empty state.

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

## Onboarding Affordance

The Create Rhythm CTA exists solely to help first-time users create their first rhythm.

Without it, Empty becomes a dead-end: users cannot begin using the app.

## Not Normal Today Experience

The CTA is intentionally excluded from the normal Today experience.

It is not routine management.

It does not compete with Primary Rhythm.

It does not persist once the day has content.

## Product Consistency

This affordance remains consistent with:

- **One Rhythm at a Time** — The CTA appears only when no rhythm exists. It disappears as soon as Today has a rhythm to present.
- **Show Only What Matters Now** — When routines exist, Today shows only what matters for the current moment. The CTA does not belong in those states.
- **Calm Over Pressure** — The CTA supports a gentle invitation to begin. It must not feel urgent, persistent, or like ongoing management.

Permanent routine management must not return to Today.

Routine creation beyond first onboarding belongs in Routine Management (Sprint 9).

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

Help the user begin the day.

Requirements

- Friendly.
- Calm.
- Never urgent.

Approved copy is defined in Approved Copy.

---

## Create Rhythm CTA

Purpose

Provide the only entry point for first-time users to create their first rhythm.

Requirements

- Visible only in Empty.
- Hidden in all other states.
- Opens the routine creation flow.
- Must not compete with Primary Rhythm visual emphasis.
- Must feel like a gentle invitation, not a persistent call-to-action.
- Must disappear completely once at least one routine exists for the day.

This component is an onboarding affordance, not routine management.

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

No alternate Empty Guidance, Create Rhythm CTA, or Day Complete strings may be introduced without a new Product Decision.

#### Empty Guidance

오늘의 첫 리듬을 만들어보세요.

#### Create Rhythm CTA

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
- After a routine is created, Today returns to the appropriate non-Empty state and the CTA must not reappear.

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

- Show Empty Guidance and Create Rhythm CTA.
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

The Create Rhythm CTA must remain visually subordinate to Empty Guidance.

It must never dominate the screen.

Typography must reinforce information hierarchy without relying solely on color.

---

# Animation Rules

Animations must confirm interaction.

Animations must never celebrate completion.

Animations must never compete for attention.

Motion must feel soft, quiet, and brief.

---

# Accessibility

Information hierarchy must remain understandable without color.

Interactive elements must meet minimum touch target guidelines.

Dynamic Type must preserve hierarchy while avoiding layout collapse.

---

# Implementation Notes

These notes clarify important implementation intent.

- Primary Rhythm remains the emotional center of the screen.
- Progress is supporting information, never the focus.
- Next Rhythm exists only for orientation.
- Past Incomplete reuses the same visual structure as Current whenever possible.
- Empty and Day Complete must follow the same visual language as the rest of Today.
- Empty includes a Create Rhythm CTA as an onboarding affordance only. It must not persist once routines exist.
- Spacing is part of the experience and must not be optimized away.
- Every component must justify its existence by helping the user understand today's rhythm, or by enabling first-time onboarding in Empty.
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
- Persistence
- Notification scheduling
- Routine creation flow details beyond the Empty-state entry point

The Create Rhythm CTA entry point is in scope for Empty only.

Routine creation form behavior, validation, and management flows belong to separate Product or Engineering documents.

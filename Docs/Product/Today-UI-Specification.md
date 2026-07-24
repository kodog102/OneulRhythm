# Today UI Specification

This document defines the implementation-ready UI specification for the Today screen.

It translates the approved Product Experience into concrete UI behavior.

This document specifies what should appear, when it should appear, and how each component behaves.

It does not redefine Product Experience, Product Philosophy, or Architecture.

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

---

# State Specifications

## Empty

Visible

- Greeting
- Date
- Empty Guidance

Hidden

- Primary Rhythm
- Primary Action
- Next Rhythm
- Progress

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

The screen must communicate quiet closure.

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

No alternate Empty or Day Complete strings may be introduced without a new Product Decision.

#### Empty

오늘의 첫 리듬을 만들어보세요.

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
- Spacing is part of the experience and must not be optimized away.
- Every component must justify its existence by helping the user understand today's rhythm.
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
- Routine creation flow

Those concerns belong to separate Product or Engineering documents.

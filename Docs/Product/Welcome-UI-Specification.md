# Welcome UI Specification

This document defines the implementation-ready UI specification for the Welcome Experience.

It translates the approved Product Design Specification (`Docs/Product/Welcome-Experience.md`) into concrete UI behavior.

It does not redefine product philosophy, brand meaning, or DR-015 lifecycle rules.

---

# Purpose

Provide a single UI contract for the first-launch Welcome surface on Today.

Every implementation must follow this document before introducing new UI decisions.

Whenever ambiguity exists:

1. `Welcome-Experience.md` (Approved Product Design)
2. This Specification
3. Engineering implementation

---

# Relationship to Today UI

Welcome replaces **First Journey Empty** presentation on Today.

| Concern | Authority |
|---------|-----------|
| When Welcome appears | DR-015 — First Journey + Today has zero routines |
| Welcome feeling and purpose | `Welcome-Experience.md` |
| Welcome UI behavior | This document |
| Greeting string contract (exact copy) | `Today-UI-Specification.md` Greeting Contract |
| Normal Experience Empty | `Today-UI-Specification.md` (unchanged) |
| Non-Empty Today states | `Today-UI-Specification.md` (unchanged) |

When Welcome is active, do not apply First Journey Empty layout, copy, or component rules from older Today Empty Phase 1 descriptions.

Toolbar Management entry follows Today quiet-secondary rules and must never compete with Welcome Hero.

---

# When Welcome Appears

Show Welcome only when all of the following are true:

- Today has zero routines for the day
- The user has not yet successfully created a first rhythm (First Journey / DR-015)

Hide Welcome after the first successful rhythm creation.

Cancel create → remain on Welcome.

Deleting all rhythms later does not restore Welcome.

---

# 1. Screen Hierarchy

Complete vertical structure from top to bottom:

```text
Safe Area
    ↓
Atmospheric Layer
    Greeting
    Date
    ↓
Hero Area
    Breath Flow (Brand Presence)
    One Rhythm at a Time (Hero Meaning)
    ↓
Philosophy
    ↓
Primary CTA
    ↓
Footer / Brand Whisper (optional residual)
```

Scroll is allowed only when Dynamic Type or compact height requires it.

At default text sizes on typical phone heights, Welcome should preferably read as one calm composition without feeling like a long form.

## Why each section exists

| Section | Purpose |
|---------|---------|
| Safe Area | Respect device insets; content never collides with system chrome |
| Greeting | Atmospheric warmth for time of day — not product messaging |
| Date | Quiet temporal orientation — not Hero |
| Breath Flow | Brand presence; product felt before explained |
| One Rhythm at a Time | Names the philosophy the mark embodies |
| Philosophy | Minimal clarity: what this is / is not |
| Primary CTA | Natural next step after introduction — not screen purpose |
| Footer whisper | Optional quiet residual brand line only if Hero does not already carry it loudly |

## Hidden while Welcome is active

- Primary Rhythm
- Rhythm Meaning
- Time (routine schedule)
- Completion control
- Next Rhythm
- Progress
- Normal Experience Empty guidance
- Secondary CTAs
- Tips, page dots, feature lists, progress through “steps”

---

# 2. Component Specification

## Atmospheric Layer — Greeting

### Purpose

Establish emotional context for the moment of day.

### Layout

- Top of content, below safe area / quiet toolbar region
- Leading alignment with screen content margin
- Stacked directly above Date with tight atmospheric grouping

### Hierarchy

- Below Hero in importance
- May appear first in reading order
- Never largest text on screen
- Never competing with Breath Flow or Hero Meaning

### Interaction

- Not interactive

### Accessibility

- Announced as a header only if it remains the opening atmospheric landmark; do not outrank Hero Meaning as the primary content header
- Preferred: Greeting is text; Hero Meaning is the primary content header for VoiceOver after Breath Flow

### Copy

Exact strings follow the Today Greeting Contract in `Today-UI-Specification.md`.

Welcome does not define alternate greetings.

---

## Atmospheric Layer — Date

### Purpose

Orient the calendar day quietly.

### Layout

- Immediately below Greeting
- Same leading alignment
- Grouped with Greeting as one atmospheric unit

### Hierarchy

- Secondary to Greeting within the atmospheric layer
- Far below Hero in importance

### Interaction

- Not interactive

### Accessibility

- Read with or after Greeting as supporting context
- Must not be announced as a primary header

---

## Hero — Breath Flow (Brand Presence)

### Purpose

Introduce the brand through presence.

### Clarification

Breath Flow is **Brand Presence**.

| Is | Is not |
|----|--------|
| Brand presence | App logo lockup for marketing chrome |
| Philosophical body of the product | Feature illustration |
| Required Hero element | Decoration that can be removed without changing meaning |
| Felt center of Welcome | Checklist, mascot, or instructional diagram |

Use the Sprint 14 approved Breath Flow production master (E10). Do not substitute alternate marks.

### Layout

- Sits in the Hero Area directly below the Atmospheric Layer
- Leading-aligned to the same content margin as Hero Meaning and Philosophy (one vertical column)
- Not a tiny leading icon beside text; not a full-bleed poster
- Clear space around the mark: at least the brand safe-area minimum (one-eighth of mark width on all sides). Prefer more air than the minimum
- Uniform scale only; do not crop, rotate, or distort

### Visual weight

- Largest silent visual element on the screen
- Approximate weight: clearly larger than any toolbar glyph; clearly smaller than a full-bleed marketing poster
- Occupies a calm focal band in the upper-middle of Welcome content
- Must remain recognizable at a glance without dominating so heavily that Philosophy and CTA are pushed into neglect on compact heights

### Spacing

- Owns the most generous surrounding whitespace on the screen
- Extra breathing room above (after Atmospheric Layer) and below (before Hero Meaning)
- Must not sit flush against Philosophy or CTA

### Interaction

- Not interactive
- No tap affordance
- No bounce, pulse, or attention-demanding loop

### Accessibility

- Decorative for VoiceOver if Hero Meaning + Philosophy already communicate introduction
- If exposed, label must be calm and non-instructional (brand presence), never “button” or “logo to continue”
- Prefer `accessibilityHidden` when text Hero already carries meaning (Presence over Explanation)

---

## Hero — One Rhythm at a Time (Hero Meaning)

### Purpose

Name the product philosophy in language after presence.

### Layout

- Directly below Breath Flow
- Leading alignment
- Multi-line allowed; maximum three short lines
- Part of the same Hero composition as Breath Flow — not a separate card

### Hierarchy

- Primary textual emphasis on Welcome
- Stronger than Philosophy, Greeting, Date, CTA label, and Footer
- Reading priority: first meaningful text after (or with) Breath Flow

### Interaction

- Not interactive

### Accessibility

- Primary content header for Welcome
- Announced as a header

### Approved copy

```text
오늘을
하나의 리듬으로
만나보세요.
```

No alternate Hero Meaning strings without a new Product Decision.

---

## Philosophy

### Purpose

Provide minimal clarity about what OneulRhythm is and is not.

### Layout

- Below Hero Meaning
- Leading alignment
- Open text — **not** a competing card surface
- Two short paragraphs / lines maximum
- No section title (“소개”, “About”, “How it works”)

### Hierarchy

- Supports Hero
- Quieter than Hero Meaning
- Stronger than Footer whisper
- Must not visually rival Breath Flow

### Interaction

- Not interactive

### Accessibility

- Combined into one accessibility element
- Not a header
- Read after Hero Meaning

### Approved copy

```text
모든 것을 끝내는 앱이 아니에요.

지금 가장 중요한 하나에
함께 머무르도록 도와줘요.
```

No third paragraph.

Do not place Philosophy inside an elevated card that competes with Hero presence.

---

## Primary CTA

### Purpose

Offer a quiet doorway to create the first rhythm after introduction.

### Layout

- Below Philosophy
- Full content-width within horizontal screen margins (width philosophy: comfortable full-bleed of the content column — not a tiny text link, not a floating oversized marketing button)
- Clear separation from Hero; never adjacent to Breath Flow

### Visual prominence

- Supportive, not heroic
- Visible and tappable
- Lower emphasis than Breath Flow and Hero Meaning
- Must pass the Welcome test: if CTA emphasis is reduced, product introduction still succeeds

### Interaction

- Single tap opens the routine creation flow
- Disabled / loading states may quiet the control; never add urgency copy
- No supporting microcopy under or beside the CTA by default

### Dynamic Type

- Label must reflow; control height grows with text
- Minimum touch target: 44 × 44 pt equivalent
- Must not clip at accessibility text sizes

### Accessibility

- Button trait
- Label equals visible CTA copy
- Quiet hint that navigation to create begins (calm wording; not “required” or “complete setup”)

### Approved copy

```text
오늘의 첫 리듬 만들기
```

Do not use `리듬 만들기`, `시작하기`, `계속`, or `Next`.

No supporting text under the CTA.

---

## Footer / Brand Whisper

### Purpose

Optional residual brand line when Hero Meaning does not already carry the English statement.

### Layout

- Bottom of Welcome content column
- Centered or quietly leading — prefer centered whisper
- Far below CTA with breathing room

### Hierarchy

- Lowest text emphasis on screen
- Must never compete with Hero

### Interaction

- Not interactive

### Accessibility

- Decorative; hidden from VoiceOver when present

### Approved copy (when shown)

```text
One rhythm at a time.
```

### Visibility rule

Show only as a quiet residual whisper.

If Hero Meaning already communicates equivalent meaning strongly, Footer may be omitted rather than duplicating the message loudly in two languages.

When shown, keep caption-level emphasis only.

---

## Toolbar — Management

### Purpose

Secondary access to rhythm management (Today shell).

### Layout

- System trailing toolbar placement
- Outside Welcome Hero composition

### Hierarchy

- Quieter than Atmospheric Layer and far quieter than Hero
- Caption-level secondary treatment

### Interaction

- Opens Management
- Must not appear as Welcome’s primary action

### Accessibility

- Distinct label for management (not confused with first-rhythm CTA)

---

# 3. Layout Specification

## Overall

- Single vertical flow
- One column
- No side-by-side primary information
- Content respects horizontal screen margins consistently
- Background remains the calm Today surface — no alternate “onboarding skin”

## Safe Area

- All content respects top, bottom, and lateral safe areas
- Atmospheric Layer starts below the top safe area (and below toolbar collision)
- Footer / CTA never collide with home indicator

## Vertical composition intent

```text
[ top safe + quiet toolbar ]

Atmospheric Layer
    (tight internal grouping)

        generous air

Hero Area
    Breath Flow
    (largest air above/below mark)
    Hero Meaning

Philosophy
    (moderate air from Hero Meaning)

Primary CTA
    (clear support gap from Philosophy; not Hero-adjacent)

Footer whisper (optional)
    (quiet air above)

[ bottom safe ]
```

## Alignment

| Element | Alignment |
|---------|-----------|
| Greeting, Date | Leading |
| Breath Flow | Leading (same content margin; presence scale, not icon scale) |
| Hero Meaning, Philosophy | Leading |
| Primary CTA | Full content width |
| Footer whisper | Center preferred |

## Card / surface rules

- Do not wrap Breath Flow, Hero Meaning, or Philosophy in a competing elevated card
- CTA may use the standard primary button surface
- No dashed “add” card pattern on Welcome

## Scroll behavior

- Prefer fitting without scroll at default Dynamic Type on common phone heights
- When scroll is required (Large Accessibility sizes, compact height), keep Hero Area above the fold as much as possible
- Do not pin CTA in a way that covers Breath Flow

---

# 4. Typography Hierarchy

Hierarchy only — relative emphasis. Exact point sizes are not required.

| Priority | Element | Relative size | Weight | Emphasis | Reading priority |
|----------|---------|---------------|--------|----------|------------------|
| 1 | Hero Meaning | Largest text | Semibold / strong | Primary | First meaningful text |
| 2 | Philosophy | Body | Regular | Secondary | After Hero Meaning |
| 3 | Greeting | Below Hero Meaning; above Date | Medium / moderate | Atmospheric | Early in order, low importance |
| 4 | Date | Below Greeting | Regular | Tertiary atmospheric | With Greeting |
| 5 | CTA label | Body | Semibold on button only | Supportive action | After Philosophy |
| 6 | Footer whisper | Smallest | Regular | Whisper | Last / optional |

### Rules

- Typography must reinforce importance without relying on color alone
- Greeting must never exceed Hero Meaning in size or weight
- CTA label semibold is for button legibility, not to crown the screen
- Philosophy never uses display / large-title emphasis
- Dynamic Type scales all text styles; relative order must survive

---

# 5. Spacing Rules

## Vertical rhythm

Whitespace decreases as importance decreases — with one exception:

**Breath Flow owns the largest surrounding whitespace**, even larger than the gap above Hero Meaning text alone.

Intentional generous air:

1. Between Atmospheric Layer and Breath Flow  
2. Around Breath Flow (safe clear space + extra calm)  
3. Between Hero Meaning and Philosophy (moderate; same composition, not a chasm that splits Hero)  
4. Between Philosophy and CTA (clear support separation so CTA does not attach to Hero)  
5. Between CTA and Footer whisper (quiet)

Compress first under pressure (compact height / large Dynamic Type):

1. Footer gap  
2. Atmospheric internal gaps (keep Greeting+Date grouped)  
3. Philosophy ↔ CTA gap (keep minimum touch comfort)  
4. Never collapse Breath Flow clear space below brand safe minimum  

## Breathing room requirements

- Breath Flow must never feel bolted to text  
- CTA must never sit in the Hero focal band  
- Do not fill unused vertical space with extra explanation, cards, or decorative rules  

---

# 6. Motion Specification

## Motion philosophy

Motion preserves continuity and calm.

Motion never celebrates, sells, or demands attention.

Prefer fade and gentle settle.

Avoid bounce, shake, overshoot, flash, and looping brand animation.

## Initial appearance

When Welcome appears (first launch into Welcome, or return while still First Journey):

- Soft opacity fade of Welcome content
- Optional slight vertical settle (small)
- Breath Flow may fade with the Hero composition — no separate spectacular entrance
- Duration feels brief and quiet

Reduce Motion:

- Opacity only
- No vertical offset
- No mark-specific motion

## While on Welcome

- No idle pulsing of Breath Flow
- No shimmer on CTA
- No parallax requirement

## Transition — Welcome → Create flow

- Standard navigation transition to create is acceptable
- No custom “onboarding step” transition

## Transition — First Rhythm Created → Normal Today

Emotional intent: evolve naturally; no graduation moment.

UI motion:

- Welcome content exits with soft fade (and slight settle only if Reduce Motion is off)
- Normal Today content enters with the same restrained Today content-transition language already used for focus changes
- No confetti, success badge, checkburst, or “You’re all set” interstitial
- Progress may appear only as part of Normal Today rules — never as Welcome completion scoring

Reduce Motion:

- Opacity crossfade only

## Loading toggles

Loading that does not change Welcome identity must not re-trigger Hero entrance motion.

---

# 7. Accessibility Checklist

## Dynamic Type

- [ ] All text uses scalable text styles
- [ ] Relative hierarchy (Hero Meaning > Philosophy > Greeting > Date > Footer) survives XXL sizes
- [ ] CTA height grows with label; no fixed clipping height
- [ ] Breath Flow may scale modestly but must not crush text; on extreme sizes, prioritize text hierarchy and allow scroll
- [ ] Layout does not truncate Hero Meaning mid-word without reflow

## VoiceOver order

Preferred order:

1. Greeting (atmospheric)  
2. Date  
3. Hero Meaning (header)  
4. Philosophy (combined)  
5. Primary CTA (button + quiet hint)  
6. Toolbar Management (when focused in bar)

Breath Flow: hidden when decorative.

Footer whisper: hidden when present.

## Touch targets

- [ ] Primary CTA meets minimum 44 × 44 pt equivalent
- [ ] Management toolbar control meets minimum touch target
- [ ] No reliance on tiny decorative hits

## Contrast

- [ ] Hero Meaning, Philosophy, Greeting, Date, CTA label meet readable contrast on Today background
- [ ] Breath Flow remains legible on Today background (use approved light-context variant as appropriate)
- [ ] Hierarchy remains understandable without color alone

## Reduce Motion

- [ ] Initial appearance: opacity only
- [ ] Welcome → Normal Today: opacity only
- [ ] No Breath Flow idle motion
- [ ] No progress/celebration motion tied to leaving Welcome

## Additional

- [ ] CTA hint does not imply setup obligation
- [ ] No accessibility language that frames Welcome as empty or broken
- [ ] Philosophy exposed as one combined element

---

# 8. Small Devices

## iPhone SE class / compact height

Preserve importance order even when vertical space is tight:

1. Keep Atmospheric Layer compact  
2. Keep Breath Flow present — reduce size before removing; never remove Brand Presence  
3. Keep Hero Meaning fully readable  
4. Keep Philosophy (shorten layout spacing before shortening approved copy)  
5. Keep CTA reachable without covering Hero  
6. Allow scroll rather than deleting Hero elements  

Do not replace Welcome with a CTA-only compact mode.

## Landscape

- Maintain single column
- Prefer scroll over multi-column redesign
- Breath Flow stays Brand Presence, not a side panel illustration
- CTA remains below Philosophy in document order

## Hierarchy survival test

On SE-class portrait and landscape, a squint test must still show:

- Presence (Breath Flow) and Hero Meaning as the center  
- CTA as secondary  
- Greeting as atmosphere  

If CTA becomes the optical center, spacing or mark scale is wrong.

---

# 9. Interaction Summary

| Control | Action | Result |
|---------|--------|--------|
| Primary CTA | Activate | Opens create-rhythm flow |
| Create success (first rhythm) | — | Welcome ends permanently; Today shows appropriate non-Welcome state |
| Create cancel | — | Return to Welcome unchanged |
| Management | Activate | Opens Management; Welcome remains First Journey until first successful create |

No other Welcome interactions.

---

# 10. Implementation Notes (UI only)

These notes guide UI implementation without prescribing code structure.

1. Welcome is a product introduction surface, not an Empty State layout variant with different copy only.  
2. Brand Presence (Breath Flow) is mandatory on Welcome.  
3. Do not elevate Philosophy or Hero Meaning into a competing card.  
4. CTA supports Hero; it must never become the reason the screen exists.  
5. Prefer presence and spacing over additional explanatory UI.  
6. Reuse Today atmospheric Greeting/Date chrome and quiet Management toolbar; do not invent Welcome-only navigation chrome.  
7. Motion must match Brand quiet-motion language and Today restrained transitions.  
8. DR-015 controls lifecycle; this document controls presentation only.  
9. Approved Welcome copy in this document is the UI copy contract for Welcome.  
10. After first successful create, never restore Welcome layout or copy.  
11. Normal Experience Empty remains a separate, quieter surface under `Today-UI-Specification.md`.  
12. Asset usage must follow Sprint 14 Release Breath Flow masters and Guide safe-area rules.  

---

# Approved Copy Contract (Welcome)

| Element | Copy |
|---------|------|
| Hero Meaning | 오늘을 / 하나의 리듬으로 / 만나보세요. |
| Philosophy line 1 | 모든 것을 끝내는 앱이 아니에요. |
| Philosophy line 2 | 지금 가장 중요한 하나에 함께 머무르도록 도와줘요. |
| Primary CTA | 오늘의 첫 리듬 만들기 |
| Footer whisper (optional) | One rhythm at a time. |
| Greeting / Date | Today Greeting Contract + Today date formatting |

No other Welcome marketing or instructional strings.

---

# Out of Scope

- SwiftUI view structure or APIs  
- Exact point sizes, token names, or animation duration values  
- Create-rhythm form field UI  
- Management UI internals  
- Widget / Live Activity / Watch  
- Normal Experience Empty redesign  
- Changes to DR-015  

---

# Related Documents

- `Docs/Product/Welcome-Experience.md`
- `Docs/Product/Today-Experience.md`
- `Docs/Product/Today-UI-Specification.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`
- `Docs/ADR/ADR-011-No-Checklist-Metaphor.md`
- `Docs/ADR/ADR-012-Calm-Before-Productivity.md`
- `Assets/brand/Guide/BRAND-USAGE.md`
- `Assets/brand/Guide/SAFE-AREA.md`

---

One rhythm at a time.

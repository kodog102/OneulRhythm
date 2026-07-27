# Launch UI Specification

This document defines the implementation-ready UI specification for the Launch Experience.

It translates the approved Launch Architecture Specification (`Docs/Product/Launch-Architecture-Specification.md`) into concrete visible UI behavior.

It does not redefine product philosophy, Welcome meaning, DR-015 lifecycle, or startup ownership.

**Status:** Implementation-ready UI contract.  
**Architecture authority:** `Launch-Architecture-Specification.md` / DR-016.

---

# Purpose

Provide a single, minimal UI contract for what is visible during Launch.

Launch exists only to establish **presence before interaction**.

Every implementation must follow this document before introducing new Launch UI decisions.

Whenever ambiguity exists:

1. `Launch-Architecture-Specification.md` (Approved Architecture)  
2. This Specification  
3. Engineering implementation  

Welcome presentation remains governed by `Welcome-UI-Specification.md`.  
Today presentation remains governed by `Today-UI-Specification.md`.

---

# Relationship to Other Surfaces

| Concern | Authority |
|---------|-----------|
| Launch purpose and lifecycle | `Launch-Architecture-Specification.md` / DR-016 |
| Launch visible UI | This document |
| Welcome UI | `Welcome-UI-Specification.md` |
| When Welcome appears | DR-015 |
| Today background / chrome | `Today-UI-Specification.md` + design tokens |
| Breath Flow master geometry | ADR-010 + Sprint 14 Release masters |

Launch is not a Today route and not a Welcome variant.

Launch is the static system Launch Screen configuration only.

---

# 1. Launch Screen Composition

Complete visible structure:

```text
Full-bleed Background (Today calm field)
        ↓
Centered Breath Flow (Presence only)
        ↓
(Empty space — intentional silence)
```

There are no other UI elements.

## Top to bottom

| Layer | Content |
|-------|---------|
| Background | Full-bleed calm Today field |
| Brand Presence | Single Breath Flow mark, optically centered |
| Remaining space | Empty — part of presence |

## Safe Area behavior

- Background extends edge to edge (under status bar / home indicator regions as system Launch Screen allows)
- Breath Flow remains inside a comfortable central safe region — never clipped by notch, Dynamic Island, or home indicator
- Do not pin the mark to top-leading chrome or toolbar positions
- Do not add Launch-only safe-area padding chrome, bars, or insets as visible UI

## Alignment

| Element | Alignment |
|---------|-----------|
| Background | Full bleed |
| Breath Flow | Horizontally and vertically centered (optical center) |
| All other content | None — must not exist |

## Empty space

Whitespace is required.

Empty space around Breath Flow is intentional silence — not unused layout to fill.

Do not add rules, captions, version text, or secondary marks to “balance” the screen.

## Confirmation — no other UI

Launch must not show:

- Greeting / Date
- Hero Meaning
- Philosophy
- CTA
- Toolbar / Management
- Progress
- Cards
- Spinners
- Any text

---

# 2. Background Specification

## Purpose

Establish the emotional room of the product before interaction.

The background is the primary continuity device from Launch into Today / Welcome.

## Color

Use the **Today product background** — the same calm field as Today / Welcome (`ORColors.background`).

Approximate token intent:

```text
Warm cream Today field
RGB ≈ (0.97, 0.95, 0.91)
```

Implementation must match the live Today background token, not a one-off Launch-only color.

## Relationship to Today

Launch background **intentionally matches** Today’s emotional tone and color field.

When Apple dismisses the Launch Screen, the first owned Today frame should feel like the same room.

## Relationship to Welcome

Welcome uses the same Today background.

Launch → Welcome continuity is background sameness plus quiet mark presence — not a second Welcome composition on Launch.

## Relationship to App Icon

App Icon may use the approved sage day field (`#E9EFE9` → `#D7E2D8`).

Launch background must **not** prioritize matching the App Icon field if that creates a jump into cream Today.

**Decision confirmed:** Launch background matches **Today / Welcome**, not the App Icon sage field.

---

# 3. Breath Flow Specification

## Visual role

Breath Flow on Launch is **Brand Presence** only.

| Is | Is not |
|----|--------|
| Silent presence | Product explanation |
| Continuity from App Icon identity | Logo lockup with wordmark |
| Calm focal stillness | Feature illustration |
| Bridge into Welcome Meaning | Welcome Hero composition |

Same visual identity as Welcome (Breath Flow E10). Different purpose: **Presence**, not **Meaning**.

## Asset

- Production master: Breath Flow E10 (Sprint 14 Release)
- Prefer light-context / primary mark appropriate for cream field
- Uniform scale only — no crop, rotate, skew, glow, shadow, or recolor outside approved variants

## Approximate size

Relative contract only — exact points may follow implementation constraints of the Launch Screen system.

| Intent | Guidance |
|--------|----------|
| Optical weight | Clearly present; quieter than Welcome Hero Breath Flow |
| Scale band | Calm mid-size presence — not a toolbar glyph; not a full-bleed poster |
| Compact devices | Reduce size before removing; never remove Brand Presence if the Launch includes the mark |

Welcome Hero Breath Flow remains the stronger presence band once interaction begins.

Launch mark should feel like a quiet inhale; Welcome mark should feel like the product meeting the user.

## Alignment

- Optically centered horizontally and vertically
- Not leading-aligned like Welcome Hero (Welcome’s leading column is a Today composition rule; Launch is a centered presence field)

## Clear space

- Minimum clear space: **one-eighth of mark width** on all sides (`Assets/brand/Guide/SAFE-AREA.md`)
- Prefer more air than the minimum
- No text, badges, or other marks inside clear space

## Accessibility

| Topic | Rule |
|-------|------|
| VoiceOver | Launch Screen is not an interactive accessibility destination. Do not author Launch-only accessibility labels, hints, or headers. VoiceOver begins on the first owned Today / Welcome screen. |
| Decorative role | If any Launch asset metadata is required by tooling, treat the mark as non-informative presence — never as a button or “logo to continue.” |
| Dynamic Type | Launch Screen is static system UI; Dynamic Type does not reflow Launch composition. Welcome / Today own Dynamic Type after first render. |

## Confirmation

Breath Flow on Launch is Brand Presence only.

Never product explanation.

Never logo presentation with name or tagline.

---

# 4. Forbidden Elements

Launch must not contain the following.

| Element | Forbidden? | Why excluded |
|---------|------------|--------------|
| **App name** | Yes | Text turns Launch into branding chrome; presence does not need naming. |
| **Tagline** (“One rhythm at a time.”) | Yes | Meaning language belongs to Welcome / brand whisper — not Launch. |
| **Hero copy** | Yes | Welcome owns Hero Meaning. Launch must not preview introduction copy. |
| **CTA** | Yes | Launch is Presence Before Interaction — no action, no invitation. |
| **Loading spinner** | Yes | Fake or decorative loading violates calm and HIG perceived performance. |
| **Progress indicator** | Yes | Implies setup, work, or waiting as the product story. |
| **Animation** | Yes | Launch Screen must remain static; motion would demand attention. |
| **Interaction** | Yes | No taps, gestures, or controls. Apple dismisses Launch when ready. |

Also forbidden:

- Onboarding steps, dots, “Skip,” “Next”
- Permission prompts presented as Launch UI
- Version numbers, build labels, or debug chrome
- Secondary illustrations or decorative shapes besides Breath Flow
- Cards, dividers, toolbars, or floating capsules

---

# 5. Accessibility

## VoiceOver

- No Launch VoiceOver script or ordered reading of Launch elements
- First meaningful VoiceOver experience is Welcome or Today per those UI specs
- Do not announce Launch as “loading,” “empty,” or “setup”

## Reduce Motion

- Launch Screen has **no motion** regardless of Reduce Motion setting
- Post-launch Today / Welcome motion follows existing Today / Welcome Reduce Motion rules
- Do not add Launch-specific fade choreography that must then be Reduce Motion gated

## Contrast

- Breath Flow must remain legible on the cream Today field (approved light-context / primary mark)
- Do not lighten the mark into low-contrast decoration
- Hierarchy is presence vs field only — no text contrast obligations on Launch because text is forbidden

## Static launch limitations

Apple’s Launch Screen is a static snapshot-like configuration.

It cannot:

- Update live with Dynamic Type
- Run Reduce Motion branches
- Host interactive accessibility focus

Those limitations are accepted. Accessibility quality is owned by the first interactive Today / Welcome frame.

---

# 6. Transition Contract

## Launch → Welcome

```text
Launch (cream field + quiet centered Breath Flow)
        ↓
Today shell (same cream field)
        ↓
Welcome (leading Breath Flow as Meaning + Hero + Philosophy + CTA)
```

### Visual continuity

- Background should feel continuous (same cream field)
- Breath Flow may continue from quiet centered Launch presence into Welcome’s leading Meaning presence
- Composition change (centered → Welcome hierarchy) is acceptable; it must not feel like a second branded splash

### Explicitly not required / not allowed

- Custom shared-element morph from Launch mark to Welcome mark
- Staged reveal of Welcome sections
- Fade choreography owned as “Launch transition”
- Theatrical logo animation

Apple dismisses the Launch Screen when the first app frame is ready.

Launch should **visually disappear** into the first owned screen.

No reveal.

No fade choreography.

No staged transition.

## Launch → Today (Normal Experience)

```text
Launch (cream field + quiet centered Breath Flow)
        ↓
Today shell (same cream field)
        ↓
Normal Today / Normal Empty / rhythm content
```

Same disappearance rule.

No Welcome philosophy or Welcome CTA.

User content (or quiet Normal Empty) becomes the center immediately.

---

# 7. Apple HIG Alignment

| HIG expectation | Launch UI decision |
|-----------------|--------------------|
| Launch Screen resembles first UI | Cream field matches Today / Welcome |
| Static, non-interactive | No animation, controls, or gestures |
| Avoid delay | No spinner; no hold for branding |
| Avoid fake loading | No progress UI on Launch |
| Downplay Launch as destination | Minimal presence only; Today owns interaction |
| Clear App Icon | Separate catalog requirement (DR-016); not Launch Screen UI |

### Intentional design decisions

1. **Quiet Breath Flow is included** on Launch for Presence continuity, even though a blank cream field would also match Today color — the mark prevents an empty “white gap” feeling between Icon and Welcome without explaining the product.
2. **Centered Launch mark vs leading Welcome mark** — different layout roles (Presence field vs Today Hero column). Continuity is emotional and chromatic, not pixel-identical layout.
3. **No Launch text** — stricter than many branded launches; protects Presence Before Interaction and Welcome ownership of meaning.

---

# 8. Final UI Decision

## Visible Launch UI

Only:

1. Full-bleed Today calm background  
2. Quiet, optically centered Breath Flow (Presence)  
3. Intentional empty space  

Nothing else.

## Success condition

A squint test during Launch should show:

- Soft cream room  
- One calm mark  
- No invitation to act  

When Launch disappears, the user should already feel inside OneulRhythm — ready for Welcome meaning or Today rhythm — without having been briefed.

## Guiding question

> Does this Launch UI establish calm presence and continuity into Today — without explanation, action, motion, or delay?

If the answer is no, it does not belong on the Launch Screen.

---

# Out of Scope

- SwiftUI / storyboard / Info.plist implementation details
- Exact export pipeline commands
- Welcome or Today layout changes
- App Icon pixel layout (Release App Icon README remains authority)
- Startup sequencing beyond what is visible on Launch

---

# Related Documents

- `Docs/Product/Launch-Architecture-Specification.md`
- `Docs/Architecture/Decisions/DR-016-launch-experience.md`
- `Docs/Product/Welcome-Experience.md`
- `Docs/Product/Welcome-UI-Specification.md`
- `Docs/Product/Today-UI-Specification.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`
- `Assets/brand/Guide/SAFE-AREA.md`
- `Assets/brand/Guide/BRAND-USAGE.md`

---

One rhythm at a time.

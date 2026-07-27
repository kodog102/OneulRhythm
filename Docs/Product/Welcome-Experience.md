# Welcome Experience

This document defines the product experience for OneulRhythm’s first-launch Today surface.

It treats the first screen — when the user has never successfully created a rhythm — as the **Welcome Experience**.

It is not an Empty State.

It is not an onboarding wizard.

It is not a setup checklist.

This is a Product Design Specification.

**Status:** Approved Product Design Specification. UI contract: `Docs/Product/Welcome-UI-Specification.md`.

It does not define layout measurements, components, tokens, animation timing, or engineering structure. Those belong to the Welcome UI Specification.

DR-015 lifecycle rules are unchanged.

---

# Relationship to Existing Authority

| Authority | Relationship |
|-----------|--------------|
| `PRODUCT-PRINCIPLES.md` | Non-negotiable constraints |
| `PRODUCT-PHILOSOPHY.md` | Why the product exists |
| `BRAND.md` | How the product should feel |
| ADR-010 / ADR-011 / ADR-012 | Breath Flow, no checklist metaphor, calm before productivity |
| DR-015 | Lifecycle: Welcome remains until first successful rhythm creation |
| `Today-Experience.md` | North Star for all Today meaning after Welcome ends |
| `Today-UI-Specification.md` | Current implementation contract; Welcome intent supersedes First Journey Empty naming after final approval |
| Sprint 14 Brand System | Breath Flow E10 is the approved master symbol for Welcome presence |

### Naming

| Prefer | Avoid for this surface |
|--------|-------------------------|
| Welcome Experience | Empty State |
| Product introduction | Setup / Get started funnel |
| First Journey (lifecycle term from DR-015) | Onboarding slides / wizard |
| Natural next step | Primary call to create |

DR-015 lifecycle rules remain binding.

This document defines the **feeling and product role** of Phase 1.

It does not change when Phase 1 ends.

---

# Product Principle — Welcome = Product Introduction

The first-launch Today screen is the product’s **introduction page**.

## Primary purpose

Introduce what OneulRhythm is.

Introduce why it exists.

Introduce what “One Rhythm at a Time” means.

Let the brand be felt.

## What is not the primary purpose

Encouraging the user to create a rhythm is **not** the primary purpose of Welcome.

Creating the first rhythm is the natural next step **after** the product has been understood and felt.

## Consequence for the CTA

The CTA must never become the primary purpose of the screen.

If the screen would fail without the button — if create is the reason the composition exists — Welcome has failed.

If the screen would still introduce OneulRhythm calmly with the CTA removed from attention, Welcome is working.

| Role | Owns |
|------|------|
| Welcome composition | Product introduction, brand introduction, emotional welcome |
| CTA | Quiet doorway after understanding — available, never central |

---

# Design Principle — Presence over Explanation

## Definition

Users should understand OneulRhythm primarily through **presence**, not through explanation.

The product should be **felt** before it is fully understood.

## Rule

Avoid solving understanding with additional text.

When meaning is unclear, do not add another paragraph.

Instead communicate philosophy through:

- Whitespace
- Hierarchy
- Rhythm
- Calm motion
- Brand presence

## Why this exists

Explanation turns Welcome into a briefing.

Presence turns Welcome into a meeting.

OneulRhythm is a companion for attention, not a product that persuades through copy density.

If Breath Flow, silence, and hierarchy already carry “one rhythm at a time,” more words are usually the wrong fix.

---

# Current First Journey — Evaluation

The current First Journey surface already contains valuable seeds:

- Approved hero invitation
- Anti-productivity philosophy lines
- A first-rhythm CTA that is stronger than generic “리듬 만들기”
- Quiet English brand footer
- Greeting and date as atmospheric entry

It does **not** yet fully succeed as Welcome.

## What currently communicates well

| Intent | Current signal | Assessment |
|--------|----------------|------------|
| Product philosophy | Philosophy card copy | Partially clear — anti-checklist and one-focus are present |
| Calmness | Soft palette, spacious type | Directionally calm |
| Focus | Single CTA; no rhythm list | Structure helps; CTA weight still risks primacy |
| Trust | Honest “not an app that finishes everything” | Builds trust through negation |

## What still feels wrong

### 1. Empty State

**Where:** Naming, mental model, and composition frame the screen as “Today with nothing in it.”

**Why:** Stacked explanatory content reads as an empty day waiting to be filled. Welcome should feel like meeting the product, not noticing missing data.

### 2. Task Manager / Create-first

**Where:** The create action can become the most assertive interactive climax.

**Why:** Without Breath Flow as emotional center — and if CTA is treated as the screen’s purpose — create becomes the product. That violates Welcome = Product Introduction.

### 3. Placeholder

**Where:** Philosophy lives in a card container; brand appears only as small footer text; master symbol is absent.

**Why:** After Sprint 14, Breath Flow is production-ready. A Welcome without the mark explains instead of embodying.

### 4. Setup screen / Explanation-first

**Where:** Vertical stack of explanation → explanation → button.

**Why:** Instructional sequencing is the shape of setup. Presence over Explanation rejects briefing the user into understanding.

## Emotional first-impression gaps

| Desired feeling | Current risk |
|-----------------|--------------|
| Product introduction | Create invitation can feel like the goal |
| Brand personality | Text-only; Breath Flow unused |
| Emotional welcome | Card + CTA stack feels app-template |
| Trust through presence | Philosophy explains; symbol does not yet embody |

---

# 1. Experience Goal

## The first 10 seconds

In the first ten seconds, the user should feel:

- Welcomed into the product, not managed into action
- Calm presence, not a briefing
- Clear that this is not a task app
- Quietly introduced to one rhythm at a time
- No obligation to create yet

They should leave those seconds having **met** OneulRhythm:

> This is a calm companion for the one rhythm that matters today.

They should not feel:

- That something is missing
- That they must complete setup
- That creating a rhythm is the point of this screen
- That they are behind
- That they are in a tutorial
- That the app wants more of their time

## Success condition

Welcome succeeds when the user has been introduced to the product and brand — and felt its calm — **before** creating anything.

The first rhythm, when chosen, feels like the natural next step after understanding — never like the assignment the screen was built to extract.

---

# 2. Atmospheric Layer — Greeting and Date

## Role

Greeting and Date are an **atmospheric layer**.

They are not Hero content.

They are not product messaging.

They do not introduce OneulRhythm.

They simply establish emotional context for the moment of day.

## Character

Greeting creates warmth and time-of-day presence only.

Examples of atmospheric character (illustrative):

- 편안한 아침이에요.
- 좋은 저녁이에요.

Exact greeting strings for Today continue to follow the approved Today greeting contract. Welcome does not invent a parallel greeting system. It clarifies **role**, not a new copy set.

Date orients the day quietly.

Neither line may:

- Explain the product
- Invite creation
- Compete with Breath Flow
- Compete with “One Rhythm at a Time”
- Compete with product philosophy

## Placement in attention

Greeting and Date may appear first in reading order as soft entry chrome.

They must remain last in **importance**.

Atmospheric layer ≠ Hero.

---

# 3. Visual Hierarchy

## Hero of the screen

The Hero of Welcome is the product introduction composition:

1. Breath Flow  
2. One Rhythm at a Time  
3. Product Philosophy  

These three form one emotional center.

Everything else supports them or stays quieter.

## Order of visual importance

```text
HERO — Product introduction
1. Breath Flow (brand presence)
        ↓
2. One Rhythm at a Time (brand / meaning statement)
        ↓
3. Product Philosophy (gentle clarity — minimal)

SUPPORT — After understanding
4. Primary invitation (first rhythm) — never the purpose of the screen

ATMOSPHERE — Context only
5. Greeting / Date — emotional context; not Hero; not messaging

OPTIONAL WHISPER
6. Quiet residual brand line — only if Hero does not already carry it
```

### Why this order

**Breath Flow** — Brand presence. Felt before explained.

**One Rhythm at a Time** — Names the philosophy the mark embodies.

**Product Philosophy** — Soft clarity about what this is and is not. Short. Never a lecture. Subject to Presence over Explanation.

**Primary invitation** — Natural next step after introduction. Available, subordinate. Never Hero.

**Greeting / Date** — Atmosphere only. May sit visually above Hero in layout while remaining below Hero in importance.

### Hierarchy rules

- Exactly one emotional center: Breath Flow + One Rhythm at a Time + Philosophy as one Welcome introduction  
- CTA must never outrank Hero elements in visual or emotional weight  
- Greeting / Date must never be treated as Hero or product copy  
- No second card competing with the Hero composition  
- No progress, lists, tips, page dots, or secondary CTAs  
- Management chrome, if visible, stays quieter than Hero and quieter than atmosphere  

---

# 4. Hero Area

## Role of Breath Flow

Breath Flow is **brand presence**.

It is not decoration sprinkled for polish.

It is not a didactic illustration that explains features.

It is not a mascot performance.

| Mode | Allowed? | Meaning |
|------|----------|---------|
| Brand presence | Yes — required | The product’s philosophical body on first meeting |
| Quiet illustration | Softly yes | May feel atmospheric if it still reads as the mark, not a scene |
| Decoration | No | Decoration can be removed without changing meaning; Welcome mark cannot |

## Visual emphasis

- Breath Flow holds primary visual gravity within the Hero  
- Emphasis is calm scale and surrounding silence — not glow, motion spectacle, or ornament  
- The mark should feel inevitable in the first glance, then rest  

## Whitespace

Whitespace is part of Welcome and part of Presence over Explanation.

Breath Flow must own generous surrounding silence:

- Enough quiet above and below that the mark can breathe  
- Enough distance from philosophy and CTA that neither crowds the symbol  
- Empty space must not be filled with more explanation because room exists  

Welcome fails if Breath Flow sits like an icon bolted onto a form.

## Composition intent

```text
[ Greeting / Date — atmosphere only ]

        Breath Flow
        (brand presence)

        One Rhythm at a Time
        (meaning)

        Product Philosophy
        (minimal clarity)

        Primary invitation
        (natural next step — not the purpose)

        optional quiet residual line
```

Breath Flow + One Rhythm at a Time + Philosophy should read as one product introduction — not three stacked lessons.

---

# 5. Copy Hierarchy

## Current approved text (First Journey)

| Role | Current copy |
|------|----------------|
| Hero | 오늘을 / 하나의 리듬으로 / 시작해보세요. |
| Philosophy | 모든 것을 끝내는 앱이 아니에요. |
| Philosophy | 지금 가장 중요한 하나의 리듬에 집중하도록 도와줘요. |
| CTA | 오늘의 첫 리듬 만들기 |
| Brand line | One rhythm at a time. |

## Copy evaluation

| Line | Strength | Risk |
|------|----------|------|
| Hero “시작해보세요” | Warm | Instructional; can pull toward setup / create-purpose |
| Philosophy anti-productivity line | Clear truth | Good — keep spirit; do not expand |
| Philosophy focus line | States focus | Mildly explanatory; keep short or feel via presence |
| “오늘의 첫 리듬 만들기” | Specific invitation | Must stay visually subordinate to Hero |
| “One rhythm at a time.” | Brand statement | Prefer carried by Hero presence; footer alone is weak |

## Recommended copy direction

Maintain calm tone.

Avoid marketing language.

Prefer presence over explanation.

Prefer recognition over instruction.

Do not add copy to fix hierarchy problems — fix hierarchy and presence first.

### One Rhythm at a Time / Hero meaning (recommended)

Keep a short, breathable statement. Soften instructional edge:

```text
오늘을
하나의 리듬으로
만나보세요.
```

**Why:** Welcomes presence. Avoids “start setup” energy.

Quieter alternative (statement, not invitation):

```text
오늘,
하나의 리듬이면
충분해요.
```

**Why:** States philosophy without commanding action. Aligns with Product Introduction: meaning first, create later.

The English brand statement may live in the Hero as “One rhythm at a time.” when it strengthens brand introduction — or remain a quiet whisper only if the Korean Hero already carries equivalent meaning. Do not duplicate the same message loudly in two languages.

Any copy change requires an explicit Product Decision before UI Spec update.

### Product Philosophy (recommended)

Two short lines maximum. Prefer fewer if presence already carries meaning.

```text
모든 것을 끝내는 앱이 아니에요.

지금 가장 중요한 하나에
함께 머무르도록 도와줘요.
```

Do not add a third explanatory paragraph.

Do not title the block “About,” “How it works,” or similar.

If review finds the block too explanatory, shorten further rather than rewriting longer. Presence over Explanation.

### CTA label (see Section 6)

Remains invitation copy only — not Hero copy.

### What introduction must land

Together, presence and minimal copy must introduce:

1. **What it is** — a companion for today’s one rhythm, not a task manager  
2. **Why it exists** — attention drifts; reconnecting with what matters today  
3. **What “One Rhythm at a Time” means** — one primary focus; enough is enough  

“Why create the first rhythm” is **not** a Welcome messaging goal.

The first rhythm matters as a natural continuation after introduction — not as a message the screen must sell.

---

# 6. Primary CTA

## Purpose relative to Welcome

The CTA is a **natural next step**, not the screen’s reason for existing.

Welcome introduces the product.

The CTA merely allows the user to continue into their first rhythm once that introduction has landed.

## Evaluate “리듬 만들기”

**Do not use “리듬 만들기” as the Welcome primary CTA.**

| Label | Fit for Welcome |
|-------|-----------------|
| 리듬 만들기 | Poor — generic; management-shaped |
| 오늘의 첫 리듬 만들기 | Acceptable invitation label — if visually subordinate |
| 시작하기 / Get started | Reject — setup / wizard language |
| 계속 / Next | Reject — onboarding slide language |

## Recommendation

Preferred invitation label:

```text
오늘의 첫 리듬 만들기
```

Acceptable quieter alternate:

```text
첫 리듬 만들기
```

Do not dilute to bare “리듬 만들기.”

### Supporting text

**Default: none.**

Extra microcopy under or beside the CTA usually violates Presence over Explanation and risks create-first framing.

### CTA emotional role

- Invitation, not demand  
- Available after introduction, never the Hero  
- Exists so Welcome is not a dead end — not so Welcome can convert  

**Test:** If emphasizing the CTA improves “conversion” but weakens product introduction, reject the emphasis.

---

# 7. Transition

```text
Welcome Experience
        ↓
First Rhythm Created
        ↓
Normal Today
```

## Emotional intent

The experience should **evolve naturally**.

Users should not feel they have “left onboarding.”

They should feel they have simply begun today’s rhythm after meeting the product.

| Moment | Should feel like |
|--------|------------------|
| Welcome | Product introduction — brand and calm |
| Creating first rhythm | Natural next step after understanding |
| Returning to Today | Already home — presence, not graduation |

## What must not happen

- Confetti, badges, “You’re all set,” or completion celebration  
- A distinct “onboarding complete” moment  
- Re-showing Welcome philosophy after success  
- A forced tour of Management, Live Activity, or settings  
- Language that frames Welcome as a phase the user escaped  
- Treating first-rhythm creation as the goal Welcome was optimized for  

## Continuity rules (aligned with DR-015)

- Welcome ends only after **successful** first rhythm creation  
- Cancel create → remain in Welcome  
- After success → Normal Today for that day’s focus  
- Later Empty days → Normal Experience Empty only (never Welcome again)  
- Deleting all rhythms does not restore Welcome  

## After the first rhythm

Today Experience takes over completely.

The product stops introducing itself.

The user’s rhythm becomes the center.

Welcome should feel, in memory, like a quiet introduction — not a tutorial room and not a setup funnel.

---

# 8. Design Risks

Anything that accidentally makes Welcome feel like the wrong product must be rejected.

## Onboarding wizard

**Risk signals**

- Multi-step pages, dots, “Next,” “Skip”  
- Feature carousel  
- Permission or capability tour before first rhythm  
- Long instructional copy blocks  

**Prevention**

- Single screen composition  
- No steps  
- Presence before action  
- Philosophy kept minimal  

## Productivity app

**Risk signals**

- Create button as the hero  
- Screen purpose framed as “create your first item”  
- Efficiency, planning the whole day, templates as center  

**Prevention**

- Welcome = Product Introduction  
- Breath Flow + One Rhythm at a Time + Philosophy outrank CTA  
- Anti-checklist language retained  

## Checklist

**Risk signals**

- Progress through onboarding steps  
- Checkmarks, streaks, “complete your profile”  
- Numbered benefits list  
- Dashed add-task empty patterns  

**Prevention**

- ADR-011 applies fully to Welcome  
- No progress meter on Welcome  
- No plus-dashed create card on Welcome  

## Empty placeholder

**Risk signals**

- “Nothing here yet”  
- Empty inbox illustration  
- Framing as broken or incomplete Today  

**Prevention**

- Never describe Welcome as empty  
- Breath Flow makes silence intentional presence  
- Greeting stays atmosphere — never implies missing routines  

## Explanation-first failure

**Risk signals**

- Adding paragraphs when users “might not get it”  
- Philosophy card expanding into a brief  
- Supporting text stacked under CTA  

**Prevention**

- Presence over Explanation  
- Fix hierarchy, whitespace, and brand presence before adding words  

## Premium / calm failure modes

| Failure | Cause |
|---------|--------|
| Feels cheap | Missing Breath Flow; template card stack |
| Feels loud | Motion spectacle; badge-like emphasis |
| Feels cold | Only negation without warm presence |
| Feels pushy | CTA-first layout; create as screen purpose |
| Feels like setup | Explanation → explanation → button as the story |

---

# Final Check — What Welcome Must Communicate

After this revision, Welcome must read as:

| Must communicate | How |
|------------------|-----|
| Product introduction | Welcome = Product Introduction; Hero is philosophy and meaning, not create |
| Brand introduction | Breath Flow as required brand presence; One Rhythm at a Time in Hero |
| Emotional welcome | Atmospheric greeting; calm presence; no obligation |

And must not read as:

| Must not communicate | Guard |
|----------------------|--------|
| Empty state | Naming, presence, and Hero replace “nothing here” |
| Setup flow | CTA is next step, not purpose; no get-started language |
| Onboarding wizard | Single composition; no steps; no graduation |
| Productivity app | Presence over Explanation; ADR-011; create never Hero |

---

# What Should Always Remain True

- Welcome is the product’s introduction page, not an Empty State  
- Primary purpose is introducing OneulRhythm — not encouraging create  
- Breath Flow is present as brand presence  
- Hero is Breath Flow + One Rhythm at a Time + Product Philosophy  
- Greeting and Date are atmosphere only  
- Presence over Explanation guides copy restraint  
- First rhythm is a natural next step after understanding  
- CTA never becomes the primary purpose of the screen  
- Tone stays calm, human, and non-judgmental  
- DR-015 lifecycle boundaries remain intact  
- After the first rhythm, Welcome never returns  

---

# What Should Never Happen

- Calling or framing this surface as Empty in product language  
- Treating create as the reason Welcome exists  
- Elevating Greeting to Hero or product messaging  
- Solving confusion with more explanatory text first  
- Onboarding slides or multi-page wizard  
- Checklist, streak, or setup progress metaphors  
- Generic “리듬 만들기” as the Welcome primary CTA  
- Marketing hype or productivity pressure  
- Celebrating the end of Welcome  

---

# Scope Boundary

### In scope

- Product principles and design principles for Welcome  
- Feeling, hierarchy, atmospheric vs Hero roles, copy direction, CTA intent, transition emotion, design risks  
- Relationship to DR-015 and Today Experience  
- Breath Flow’s role on first launch  

### Out of scope

- SwiftUI structure  
- Spacing, type tokens, color tokens  
- Animation curves and durations  
- Asset export pipelines  
- Create-rhythm form fields  
- Management, Widget, Live Activity, Watch  
- Normal Experience Empty redesign (except: it must not reuse Welcome)  
- Changes to DR-015  

Implementation details belong to a later UI Specification update after final Architect approval.

---

# Guiding Question

Every Welcome decision should answer:

> Does this introduce what OneulRhythm is — through presence, brand, and calm — so that the first rhythm feels like a natural next step rather than the purpose of the screen?

If the answer is no, it does not belong in Welcome.

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/Product/PRODUCT-PHILOSOPHY.md`
- `Docs/Product/Today-Experience.md`
- `Docs/Product/Today-UI-Specification.md`
- `Docs/BRAND.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`
- `Docs/ADR/ADR-011-No-Checklist-Metaphor.md`
- `Docs/ADR/ADR-012-Calm-Before-Productivity.md`
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`
- `Assets/brand/Guide/BRAND-USAGE.md`

---

One rhythm at a time.

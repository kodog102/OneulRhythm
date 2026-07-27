# Launch Architecture Specification

This document defines the architecture and implementation contract for OneulRhythm’s Launch Experience.

It translates the approved Launch Experience Review (Sprint 15-2A) into startup ownership, Launch Screen rules, transition expectations, and failure behavior.

It does not redefine product philosophy, Welcome meaning, or DR-015 lifecycle rules.

**Status:** Approved Architecture Specification.  
**Decision record:** `Docs/Architecture/Decisions/DR-016-launch-experience.md`.  
**UI contract:** `Docs/Product/Launch-UI-Specification.md`.

---

# Purpose

Provide a single contract for the journey from App Icon to the first interactive Today or Welcome surface.

Whenever ambiguity exists:

1. `PRODUCT-PRINCIPLES.md` / `BRAND.md` / ADR-010  
2. This Specification  
3. Engineering implementation  

Welcome presentation remains governed by:

- `Welcome-Experience.md`
- `Welcome-UI-Specification.md`

DR-015 remains the authority for First Journey vs Normal Experience.

---

# Principles

## Launch = Presence Before Interaction

Launch exists only to establish calm presence before interaction.

Launch is the first quiet breath before Today.

Launch must never:

- Explain the product
- Request user action
- Display onboarding
- Delay the user for branding effect
- Introduce a second product-introduction surface before Welcome

Launch succeeds when the user feels they are already inside OneulRhythm’s calm — without yet being asked to understand or act.

---

## Breath Flow Roles

Same visual identity. Different purpose.

| Surface | Breath Flow role | Purpose |
|---------|------------------|---------|
| **App Icon** | Identity mark | Recognize the product on the Home Screen |
| **Launch Screen** | **Presence** | Quiet continuity while the process starts |
| **Welcome** | **Meaning** | Introduce philosophy after presence is felt |
| **Normal Today** | Not required as Hero | User’s rhythm is the center |

### Launch — Presence

On Launch, Breath Flow may appear only as silent presence.

It must not teach, invite, or complete brand storytelling.

### Welcome — Meaning

On Welcome, Breath Flow is Brand Presence that supports product introduction with Hero Meaning and Philosophy (`Welcome-UI-Specification.md`).

### Rule

Do not treat Launch and Welcome as two branding beats that both “introduce” OneulRhythm.

Launch bridges.

Welcome introduces.

---

# 1. Launch Lifecycle

Complete startup lifecycle:

```text
App Icon
    ↓
System Launch Screen
    ↓
Initialization
    ↓
First Render (Today shell)
    ↓
Welcome or Today
```

## Phase ownership

| Phase | Owner | Responsibility |
|-------|-------|----------------|
| **App Icon** | OneulRhythm (asset) + Apple (Home Screen) | Approved Breath Flow App Icon installed in the app catalog. Apple composites and displays it. |
| **System Launch Screen** | Apple displays; OneulRhythm configures | Static Launch Screen asset / configuration that matches Today’s calm field. Shown until the first app frame is ready. |
| **Initialization** | OneulRhythm | Necessary persistence, DR-015 bootstrap, daily rhythm sync, and readiness for first load. No branding work. |
| **First Render** | OneulRhythm | `TodayView` (or equivalent Today root) paints on the product background. Atmospheric chrome may appear; interactive purpose remains Welcome or Today content. |
| **Welcome or Today** | OneulRhythm + DR-015 | First Journey empty → Welcome. Otherwise Normal Today / Normal Empty / rhythm states. |

## Where Apple owns the experience

Apple owns:

- Home Screen icon presentation
- Displaying the Launch Screen until the app’s first frame is ready
- Process lifecycle (cold/warm launch, background, terminate)
- System transitions into the app window

## Where OneulRhythm begins

OneulRhythm begins at Launch Screen **configuration** and continues through:

- App process initialization
- First rendered product UI
- Selection of Welcome vs Today per DR-015

OneulRhythm does **not** insert an owned interactive “splash app” between Apple’s Launch Screen and Today.

---

# 2. Launch Screen Specification

## Purpose

Provide a calm, static stand-in for the first product frame so startup feels continuous — not empty, and not explanatory.

## Background

Use the **Today / Welcome surface field** — the same calm product background family as `ORColors.background` (warm cream Today field).

Do **not** use:

- System default white as the intentional brand field
- A separate “marketing” gradient that does not appear on Today
- The App Icon sage field as Launch background if it creates a jump into cream Today

**Decision:** Launch background prioritizes **continuity into Today/Welcome** over matching the App Icon field exactly.

App Icon may remain the slightly cooler outer identity. Launch should already feel like being inside the app.

## Brand usage

| Element | Decision | Rationale |
|---------|----------|-----------|
| **Breath Flow** | **Allowed — quiet, centered or optically calm, presence scale** | Establishes Presence without explanation. Same E10 master as Welcome. |
| **App name** | **Not allowed** | Name is not required for presence; text turns Launch into branding chrome. |
| **Tagline** (“One rhythm at a time.”) | **Not allowed** | Welcome / optional Welcome footer own meaning language. Launch must not explain. |
| **Loading indicator** | **Not allowed** | Fake or decorative loading violates HIG perceived-performance guidance and calm. |
| **Animation** | **Not allowed** | Launch Screen is static. No pulse, fade loop, or mark motion. |

### Breath Flow on Launch (when present)

- Production master: Breath Flow E10 (Sprint 14 Release)
- Role: Presence only
- Not interactive
- Uniform scale; respect brand safe-area clear space
- Must not dominate so heavily that the field no longer feels like Today’s quiet room
- Prefer slightly quieter optical weight than Welcome Hero presence (Welcome still owns Meaning)

If implementation must choose between a cream-only Launch Screen and cream + quiet Breath Flow, **cream + quiet Breath Flow is preferred** for continuity with App Icon identity — provided it remains static and non-explanatory.

## Interaction

None.

Launch Screen is never interactive.

No buttons, no gestures, no VoiceOver product tour.

## Motion

None on the Launch Screen itself.

Any motion belongs only to normal Today content transitions **after** the first interactive frame — never as a launch “reveal.”

## Restrictions

Launch Screen must never include:

- Onboarding copy or steps
- Progress through setup
- CTA or “Get started”
- Tips, feature lists, or version labels
- Timed hold after the app is ready
- A second full-screen branded interstitial after Launch Screen dismissal

---

# 3. Startup Responsibility

## Allowed before / during first interactive screen

Work required for a correct first day:

| Work | Allowed? | Notes |
|------|----------|-------|
| SwiftData / ModelContainer setup | Yes | Persistence foundation |
| Repository composition | Yes | Architecture-preserving wiring |
| DR-015 compatibility bootstrap | Yes | Mark First Journey complete when creator evidence exists |
| Initial daily rhythm sync / provisioning | Yes | Today must reflect the correct day |
| Load Today snapshot / routines for first paint | Yes | Prefer stable first content over a misleading empty flash |
| Live Activity sync after snapshot exists | Yes | Must not block Launch Screen or invent splash UI |
| Logging of non-fatal bootstrap failures | Yes | Must not block launch with branding or error theater |

## Explicitly prohibited

| Work | Why prohibited |
|------|----------------|
| Artificial delay for “premium” feel | Delays the user for branding |
| Branding-only splash view after Launch Screen | Duplicate branding; theatrical |
| Preloading marketing assets unrelated to Today | Startup complexity without product need |
| Multi-step permission / feature tour before Welcome | Onboarding before presence/meaning |
| Holding Launch Screen after first frame is ready | Violates HIG; feels like waiting |
| Re-running Welcome introduction logic on every cold launch after First Journey ends | Violates DR-015 |

## Readiness rule

Initialization may run while Apple shows the Launch Screen and during early Today mount.

Initialization must not invent a **user-facing branding phase**.

If a brief in-content loading state is unavoidable, it must remain quiet, non-celebratory, and never replace Launch Screen design. Prefer stabilizing first content so Welcome/Today does not flash incorrectly before sync completes.

## Relationship to Welcome

Startup does not decide Welcome copy, hierarchy, or CTA.

Startup only ensures:

- Journey progress is correctly bootstrapped (DR-015)
- Today empty vs non-empty is based on real data after initial sync
- Welcome appears only when First Journey + zero routines

---

# 4. Transition Contract

## Launch → Welcome

```text
System Launch Screen (presence field [+ quiet Breath Flow])
        ↓
Today shell on the same calm field
        ↓
Welcome composition (Breath Flow as Meaning + Hero + Philosophy + CTA)
```

### Continuity expectations

- Background should feel continuous (cream field → cream Today)
- Breath Flow may continue from quiet Launch presence into Welcome Meaning without a blank gap
- No theatrical shared-element animation is required
- No confetti, logo slam, or “brand reveal”

### Emotional intent

The user should feel they remained in the same quiet room while the product became ready to meet them.

## Launch → Today (Normal Experience)

```text
System Launch Screen
        ↓
Today shell
        ↓
Normal Today / Normal Empty / rhythm states
```

### Continuity expectations

- Same background continuity rule
- No Welcome philosophy or Welcome CTA
- User’s rhythm (or quiet Normal Empty) is the center immediately

## Disappearance rule

Launch should **disappear naturally** into Today.

Apple dismisses the Launch Screen when the first app frame is ready.

OneulRhythm must not:

- Crossfade a custom splash on top of Today for effect
- Delay first interaction to finish a brand animation
- Present Launch as a route/screen inside the navigation stack

---

# 5. Failure & Recovery

| Scenario | Expected behavior |
|----------|-------------------|
| **Cold launch** | App Icon → Launch Screen → init → First Render → Welcome or Today per DR-015 + snapshot. |
| **Warm launch** | System may shorten or skip perceptible Launch Screen. App resumes into Today shell; content reflects current snapshot rules. No re-Welcome if journey complete. |
| **Resume from background** | No Launch Screen branding sequence. Refresh Today as existing scene-active rules require. Welcome must not replay. |
| **After force quit** | Behaves as cold launch. DR-015 preference persists. Welcome returns only if First Journey is still incomplete and Today has zero routines. |
| **Day rollover** | Not a Launch concern. Daily sync / provisioning on launch or become-active updates the day. Empty after rollover uses Normal Empty if journey complete — never Welcome again. |
| **Init failure (non-fatal)** | Prefer degraded Today with calm error messaging over blocking splash. Do not show branded recovery screens. |
| **Fatal persistence failure** | Follow existing app fatal/error policy; do not invent Launch-specific branding recovery. |

### DR-015 invariance

Launch frequency does not end or restart Welcome.

Only successful first rhythm creation (or compatibility evidence / fresh data rules in DR-015) changes journey phase.

---

# 6. Apple HIG Review

| HIG theme | OneulRhythm decision |
|-----------|----------------------|
| Launch Screen matches first UI | Launch field matches Today/Welcome cream field |
| Launch Screen is static | No animation, no video, no interactive controls |
| Avoid unnecessary delay | No artificial wait; no branding-only hold |
| Avoid fake loading | No Launch loading spinner; no deceptive progress |
| Perceived performance | Real init only; show product UI as soon as ready |
| Downplay launch as destination | Launch is continuity, not a screen users “use” |
| App Icon clarity | Approved Breath Flow App Icon must be installed in the asset catalog |

### Intentional decisions

1. **Quiet Breath Flow on Launch is allowed** even though HIG often favors near-identical first frames — Presence continuity with App Icon and Welcome outweighs a completely empty field, provided Launch stays static and non-textual.
2. **App Icon sage field need not equal Launch cream field** — continuity into Today is preferred over perfect icon-color matching.
3. **Welcome remains the meaning surface** — Launch will not carry tagline or philosophy to “finish branding early.”

---

# 7. Final Architecture Decision

## Decision

The Launch Experience is a **continuity bridge**, not a product introduction and not a splash product.

### Required architecture

1. **App Icon** — Install Sprint 14 Release App Icon into the app target catalog.  
2. **System Launch Screen** — Configure a static Launch Screen using the Today calm background; quiet Breath Flow Presence is preferred.  
3. **No post-launch branded interstitial** — First owned UI root remains Today.  
4. **Initialization** — Only necessary persistence, DR-015 bootstrap, daily sync, and Today load.  
5. **First interactive destination** — Welcome or Today exclusively via existing Today + DR-015 rules.  
6. **Breath Flow semantics** — Launch = Presence; Welcome = Meaning.  

### Non-goals

- Launch onboarding
- Launch CTA
- Launch animation system
- Duplicate Welcome composition on Launch
- Startup work that exists only for branding

### Success condition

From App Icon to Welcome or Today, the journey feels like **one calm inhale** — presence first, interaction second, meaning only where Welcome owns it.

### Guiding question

> Does this startup choice establish calm presence and continuity into Today — without explaining, delaying, or competing with Welcome?

If the answer is no, it does not belong in Launch.

---

# Relationship to Existing Authority

| Authority | Relationship |
|-----------|--------------|
| `PRODUCT-PRINCIPLES.md` | Calm, presence, less input |
| `BRAND.md` / ADR-010 | Breath Flow identity; Launch listed as brand surface |
| DR-015 | Welcome vs Normal; unchanged by Launch |
| `Welcome-Experience.md` | Welcome = product introduction after Launch |
| `Welcome-UI-Specification.md` | Welcome UI; Launch must not replace it |
| Apple HIG | Launch Screen and perceived performance constraints |
| Sprint 15-2A Launch Experience Review | Approved basis for this specification |

---

# Out of Scope

- SwiftUI structure or API choices
- Exact point sizes or animation curves for Today content (unchanged)
- Welcome copy or hierarchy changes
- Widget / Live Activity / Watch launch behavior beyond not blocking app Launch
- Redesign of App Icon geometry (Release master remains authoritative)

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`
- `Docs/Architecture/Decisions/DR-016-launch-experience.md`
- `Docs/Product/Welcome-Experience.md`
- `Docs/Product/Welcome-UI-Specification.md`
- `Docs/Product/Today-UI-Specification.md`
- `Assets/brand/Guide/BRAND-USAGE.md`
- `Assets/brand/Release/AppIcon/README.md`

---

One rhythm at a time.

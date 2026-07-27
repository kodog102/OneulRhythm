# Create Rhythm Architecture

This document defines the architectural principles for the Create Rhythm experience.

It governs how Create remains a utility surface while feeling like **beginning one personal rhythm**, not configuring a schedule object.

It does not define UI layout, controls, copy locks, or SwiftUI structure.

**Status:** Approved Architecture Specification.  
**Decision record:** `Docs/Architecture/Decisions/DR-019-create-rhythm.md`.  
**UI contract:** `Docs/Product/Create-Rhythm-UI-Specification.md`.  
**Basis:** Sprint 15-5A Create Rhythm Experience Review.

---

# Purpose

Provide architectural rules for Create (and shared Edit) so later UI Spec and implementation can reduce cognitive load without inventing onboarding, celebration, or a second product.

Whenever ambiguity exists:

1. `PRODUCT-PRINCIPLES.md` / `BRAND.md` / DR-017 / DR-018  
2. This Specification  
3. `Create-Rhythm-UI-Specification.md`  
4. Engineering implementation  

Welcome remains the product introduction (DR-015).  
Today remains the single-focus experience (DR-008 / DR-009).  
My Rhythms remains the personal collection (DR-018).

---

# Architecture Goal

Create Rhythm is a **utility surface**.

Its primary experience must still feel like:

> beginning one personal rhythm

not:

> configuring a full schedule object

Achieve this through **Capture vs Configure**, **information hierarchy**, and **progressive disclosure** — not through multi-step onboarding, brand theater, or separate Create/Edit architectures.

---

# 1. Purpose

## What users are trying to accomplish

Users arrive to **name and place one rhythm** in their day so Today can hold it as focus.

They are not trying to administer a productivity system.

## What the system is responsible for

| Responsibility | Role |
|----------------|------|
| Persist a valid rhythm | Utility |
| Apply sensible defaults | Reduce decisions |
| Return calmly to Today / My Rhythms | Continuity |
| Support later refinement (Edit) | Same architecture |
| End First Journey on first successful create | DR-015 (app lifecycle — not Create UI graduation) |

## What Create is

| Is | Meaning |
|----|---------|
| **Rhythm capture** | Record the rhythm’s identity and when it lives |
| **Quiet utility form** | No Breath Flow hero; cream/sage tokens OK (DR-017) |
| **Subordinate to Experience surfaces** | Entered from Welcome/Empty CTAs or My Rhythms; never the day’s emotional center |
| **Shared with Edit** | One architecture; different emotional emphasis |

## What Create is NOT

| Not | Why |
|-----|-----|
| **Task configuration console** | Violates presence-first product identity |
| **Onboarding wizard** | Welcome already introduced the product |
| **Second Welcome** | No philosophy, Breath Flow meaning, or brand lecture |
| **Celebration / graduation** | No confetti, success interstitial, or “You’re set” |
| **Settings** | System preferences belong elsewhere (DR-020) |
| **Today focus surface** | Acknowledgment and single focus stay on Today |
| **Separate product from Edit** | One form architecture |

### Success condition

> After save, the user should feel they have begun (or refined) a personal rhythm — and quietly returned to Today or My Rhythms — without having performed brand theater or finished a setup checklist.

---

# 2. Capture vs Configure

## Definitions

### Capture

Information required to **begin** a rhythm as a lived personal focus.

Capture answers:

> What is this rhythm, and when does it belong in my day?

### Configure

Information that **refines** how the rhythm repeats, is classified, or notifies — useful, not required to begin.

Configure answers:

> How should this rhythm behave over time or in the system?

## Boundary

```text
Capture  →  enough to begin one rhythm
Configure → available to refine without blocking beginning
```

## What belongs to Capture

| Concern | Why |
|---------|-----|
| **Identity (name)** | Ownership starts with the name (DR-018 ownership principle) |
| **Primary time placement** | Places the rhythm in today / the day without full schedule engineering |

Capture receives **primary emphasis**.

## What belongs to Configure

| Concern | Why |
|---------|-----|
| **Category / taxonomy** | Classification — settings-shaped if elevated |
| **Recurrence patterns** | Scheduling power — advanced for first beginning |
| **Reminder / notification options** | System adjunct — optional |
| **End-time / duration detail** | Refinement of span — optional when defaults suffice |
| **Other future schedule sophistication** | Must not become first-create hero |

Configure remains **available** but **secondary / advanced**.

## Emphasis rule

| Emphasis | Content |
|----------|---------|
| **Primary** | Capture |
| **Secondary / Advanced** | Configure |

Do not require Configure decisions to complete a valid first create when Capture is sufficient and defaults exist.

---

# 3. Information Hierarchy

Canonical hierarchy for Create / Edit:

## Primary

**Rhythm identity (name)**

Exists so the user begins with ownership — “this is my rhythm.”

Aligned with DR-017 Experience vs Utility: even on a utility surface, the emotional center of the form is the rhythm’s name, not chrome or taxonomy.

## Secondary

**Time placement**

Exists so Today can schedule and present the rhythm.

Supports Capture without becoming a full calendar product.

## Advanced

**Category, recurrence, reminder, end-time detail, and similar refinements**

Exist so power users and Edit can refine behavior.

Must not visually or cognitively equal Primary on first create.

## Explicitly out of this hierarchy as identity

| Excluded as form identity | Why |
|---------------------------|-----|
| Breath Flow / Welcome philosophy | Wrong surface class (DR-017) |
| Progress / completion / scores | Today owns acknowledgment |
| Settings dump | Separate surface |
| Metrics / analytics | ADR-011 |

### Hierarchy rule

> If Advanced options feel as mandatory as naming the rhythm, Create has become task configuration.

---

# 4. Progressive Disclosure Principles

## Immediately visible (architectural intent)

- Capture: identity  
- Capture: primary time placement  
- A single quiet path to persist  

## May be disclosed progressively

- End-time / duration detail  
- Reminder enablement and offsets  
- Category  
- Recurrence  
- Other Configure fields  

Disclosure may use expansion, secondary grouping, or deferred emphasis — **UI Spec chooses mechanism**. Architecture only requires that Configure not compete with Capture by default.

## Must never require multiple screens

| Forbidden | Why |
|-----------|-----|
| Multi-step onboarding wizard | Competes with Welcome; setup energy |
| “Next / Skip” create funnel | Wizard language (Welcome UI forbidden patterns) |
| Separate Create product vs Edit product | Two architectures |
| Brand interstitial before fields | Theatrical |

Create remains **one continuous utility surface** (scroll or equivalent), not a page carousel.

## Defaults principle

Sensible defaults should make Configure skippable for beginning.

Defaults must not invent fake urgency or fake completeness scores.

---

# 5. Create / Edit Relationship

## One architecture

Create and Edit share:

- Same surface class (utility)  
- Same Capture vs Configure model  
- Same hierarchy (Primary → Secondary → Advanced)  
- Same persistence philosophy  
- Same calm return (no celebration)  
- Same brand rules (no Breath Flow hero)  

## What remains identical

| Identical | Reason |
|-----------|--------|
| Field model / validation responsibilities | One rhythm object |
| Utility language class | DR-017 |
| No Welcome reprise | DR-015 |
| Entry from Experience/Collection, not a parallel app | DR-018 |

## What emotional emphasis differs

| | Create (especially first) | Edit |
|--|---------------------------|------|
| Emphasis | Beginning — Capture first | Refinement — Configure more welcome |
| Feeling | “Start this rhythm” | “Adjust this rhythm” |
| Advanced visibility | Prefer quieter / deferred | May be more readily available |
| Nav / save framing | Toward beginning (direction only) | Toward updating (utility-plain OK) |

## Coexistence rule

> Do not ship two products.  
> Ship one form architecture with **create-leaning Capture emphasis** and **edit-leaning Configure availability**.

First creation may use the same structure as Edit while still prioritizing Capture — progressive disclosure and hierarchy, not a fork.

---

# 6. Product Language Principles

Architectural direction only — not final copy locks.

## Utility wording

Acceptable for chrome and persistence:

- Add / edit / save family (`리듬 추가`, `리듬 편집`, `저장` …)  
- Clear destructive or permission language when required  

Utility wording must stay **plain**, not marketing.

## Ownership wording

Prefer language that treats the rhythm as **personal and begun**, especially around identity and create persistence framing.

Avoid language that treats the user as administering records.

## Scheduling terminology

Acceptable in Configure and time dialogs when accurate.

Must not dominate Capture or become Experience-surface hero language.

`등록`-style registration verbs remain **utility-dialog-only** (DR-017) — never Welcome/Today hero copy.

## Configuration terminology

Words like category, settings toggles, and taxonomy labels are Configure-class.

They must not read as the reason the screen exists.

## Language rule

> Capture speaks ownership.  
> Configure may speak schedule and system.  
> Neither speaks checklist, streak, or setup wizard.

---

# 7. Save Philosophy

## What Save represents

Save is **persistence of a begun (or refined) rhythm**.

It is also a quiet **acknowledgement that the rhythm now exists** in the user’s collection and can appear on Today.

| Aspect | Meaning |
|--------|---------|
| Persistence | Write the rhythm truthfully |
| Beginning (Create) | The rhythm has started its life in the product |
| Acknowledgement | Calm confirmation via return to Today / My Rhythms — not a reward |

## What Save must never become

| Never | Why |
|-------|-----|
| Celebration / graduation moment | Violates calm; Welcome already introduced |
| Checklist “task completed” identity | ADR-011 / DR-017 |
| Setup step completion | Wizard energy |
| Blocking brand interstitial | Theatrical |
| Requirement to finish all Configure fields | Capture must be enough when defaults exist |

## Return rule

After successful save: dismiss Create, refresh Today / My Rhythms as needed, no success theater.

First successful create may end First Journey (DR-015) without Create showing onboarding-complete UI.

---

# 8. Accessibility Principles

Architectural guidance only.

| Concern | Principle |
|---------|-----------|
| **VoiceOver** | Focus order follows Capture → Configure; Primary identity announced before Advanced options; selection state of choices must be conveyable |
| **Dynamic Type** | Primary actions and identity fields must reflow; fixed clipping of save/primary controls is unacceptable |
| **Focus order** | Matches information hierarchy; Advanced disclosure should not steal first focus from name |
| **Progressive disclosure** | Hidden Configure content is not required to begin; when shown, it remains reachable and labeled calmly |
| **Language** | A11y labels follow Product Language Principles — ownership for identity, utility-plain for persistence |

Accessibility must reinforce Capture-first hierarchy, not a flat “every control equal” settings sheet.

---

# 9. Future Compatibility

| Future | Compatibility rule |
|--------|-------------------|
| **DR-017** | Utility surface; no Breath Flow hero; shared voice; Configure ≠ Experience hero |
| **DR-018** | Create remains subordinate to My Rhythms ownership; returns without celebration |
| **Edit Rhythm** | Same architecture; Configure more available; no fork |
| **Settings (DR-020)** | System preferences stay out of Create’s Capture center; deep links OK for permission recovery |
| **Recurrence improvements** | Land in Configure / Advanced; must not force multi-step wizard or Capture overload |
| **Welcome / Launch** | Unchanged; Create must not absorb introduction |

---

# 10. Final Architecture Decision

## Decision

Create Rhythm is a **utility capture form** with a **Capture-first hierarchy**.

1. **Purpose** — Begin (or refine) one personal rhythm; not configure a task system.  
2. **Capture vs Configure** — Name + primary time placement are Capture; category, recurrence, reminder, end detail are Configure.  
3. **Hierarchy** — Primary identity → Secondary time → Advanced refinement.  
4. **Progressive disclosure** — Configure may defer; never multi-screen onboarding.  
5. **Create/Edit** — One architecture; create emphasizes beginning; edit emphasizes refinement.  
6. **Language** — Ownership for Capture; utility/schedule for Configure; no wizard/celebration.  
7. **Save** — Persistence + quiet beginning/acknowledgement via return; never reward theater.  
8. **A11y** — Hierarchy-respecting focus and scalable primary controls.  
9. **Future** — Compatible with Edit, Settings, richer recurrence without forking the product.

## Non-goals

- UI control specification  
- Final string locks  
- Multi-step create wizard  
- Breath Flow on Create  
- Separate Create vs Edit apps  

## Guiding question

> Does this decision help the user begin one personal rhythm with Capture first — while keeping Configure available, Edit unified, and Welcome/Today emotionally free of setup theater?

If the answer is no, it does not belong in Create Rhythm Architecture.

---

# Relationship to Existing Authority

| Authority | Relationship |
|-----------|--------------|
| `PRODUCT-PRINCIPLES.md` | Less input; calm; one focus elsewhere |
| `BRAND.md` / DR-017 | Utility mark absence; language classes |
| DR-018 | Create subordinate to collection ownership |
| DR-015 | First create ends Welcome without Create graduation UI |
| Sprint 15-5A Review | Empirical basis for Capture-first direction |

---

# Out of Scope

- Exact UI components or disclosure widgets  
- Locked copy tables (UI Spec later)  
- Schedule Engine / persistence technology  
- Notification pipeline redesign  

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`
- `Docs/Architecture/Decisions/DR-018-my-rhythms.md`
- `Docs/Architecture/Decisions/DR-019-create-rhythm.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/Welcome-Experience.md`

---

One rhythm at a time.

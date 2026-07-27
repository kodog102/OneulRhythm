# My Rhythms Architecture

This document defines the architectural role of **My Rhythms** within OneulRhythm.

It explains why the screen exists, what emotional job it serves, and how utility stays aligned with product philosophy.

It is not a CRUD specification and does not define layout measurements, row tokens, or SwiftUI structure.

Existing presentation details for section membership remain in `Docs/Product/Management-UI-Specification.md`.

Entry, empty-state copy, and delete-failure wording are governed by `Docs/Product/My-Rhythms-UI-Specification.md`.

**Status:** Approved Architecture Specification.  
**Decision record:** `Docs/Architecture/Decisions/DR-018-my-rhythms.md`.  
**UI contract:** `Docs/Product/My-Rhythms-UI-Specification.md`.  
**Basis:** Sprint 15-4A My Rhythms Experience Review.

---

# Purpose

Provide architectural rules so My Rhythms remains a **quiet personal collection**, not a productivity console.

Whenever ambiguity exists:

1. `PRODUCT-PRINCIPLES.md` / `BRAND.md` / DR-017  
2. This Specification  
3. `My-Rhythms-UI-Specification.md` (entry, empty, delete failure, row chrome)  
4. `Management-UI-Specification.md` (section membership / schedule formatting)  
5. Engineering implementation  

DR-015 remains authoritative for Welcome lifecycle.  
Today remains authoritative for single-focus experience (DR-008 / DR-009).

---

# Naming

| Prefer | Avoid as product identity |
|--------|---------------------------|
| My Rhythms | Management Console |
| Personal rhythm collection | Task list / habit tracker |
| Rhythm maintenance | CRUD admin panel |
| Quiet ownership | Dashboard / analytics |

Engineering may still use “Management” in type names. Product language should prefer **My Rhythms** / `내 리듬`.

---

# 1. Architectural Purpose

## What My Rhythms is

My Rhythms is the user’s **personal rhythm collection**.

It is where rhythms are kept, reviewed, and quietly maintained so Today can present **one rhythm at a time**.

### Architectural role

```text
Welcome / Launch  →  introduce presence
Today             →  live today’s focus
My Rhythms        →  own and maintain the collection
Create / Edit     →  capture details (utility form)
```

My Rhythms sits between Experience and deep utility:

- Emotionally: ownership of “my rhythms”
- Functionally: overview + entry to create / edit / delete
- Never: the day’s primary focus surface

## What My Rhythms is not

| Not this | Why |
|----------|-----|
| **Task Management** | Violates presence-first product identity; ADR-011 |
| **Productivity Dashboard** | Metrics and overview boards compete with calm |
| **Habit Analytics** | History-as-performance is out of scope for this surface |
| **Second Today** | Today owns current-moment focus (DR-008 / DR-009) |
| **Second Welcome** | Product introduction ends after first rhythm (DR-015) |

## What My Rhythms is

| Is this | Why |
|---------|-----|
| **Personal Rhythm Collection** | Titles are owned companions, not rows in a database UI |
| **Rhythm Maintenance** | Create / edit / delete exist so Today stays light |
| **Quiet Ownership** | The user recognizes “these are mine” without being managed by the app |

### Success condition

> Opening My Rhythms should feel like visiting a quiet shelf of personal rhythms — not opening an admin console.

---

# 2. Entry Decision

## Current state

Today trailing entry (after First Journey completes): visible label `관리`.

## Architectural question

Should the label change, or remain intentionally acceptable?

## Decision

**The entry’s job is collection access, not administration.**

`관리` is **not** the permanent product vocabulary for this door.

### Justification (Product Principles — not preference)

| Principle | Implication |
|-----------|-------------|
| **Less Input. More Presence.** | Entry should not frame the next action as “managing the app.” |
| **Calm over Complexity.** | Administrative wording raises console expectations before content appears. |
| **One Primary Focus (Today).** | The door must stay quiet secondary chrome — but quiet chrome should still speak ownership, not ops. |
| **DR-017 Product Language** | `관리` was acceptable interim only while no ownership-aligned direction existed. This document supplies that direction. |
| **Brand: Presence over productivity** | “Manage” is productivity-shaped; “my rhythms” is ownership-shaped. |

### Canonical entry rule

| | |
|--|--|
| **Preferred** | Ownership-aligned entry rooted in `내 리듬` (visible short label and/or quiet icon + accessibility label `내 리듬`) |
| **Visual weight** | Caption-level / secondary only — never a primary CTA |
| **Welcome** | Entry remains **hidden** until First Journey ends (DR-015 / Brand Integration) |
| **Deprecated as lasting identity** | Visible `관리` as the product’s name for this destination |
| **Acceptable until UI Spec migration** | Caption-weight `관리` may remain in shipping UI until My Rhythms / Today UI contracts are updated — treated as legacy interim, not architecture endorsement |

### Forbidden entry patterns

- Promoting the entry to hero or filled primary button on Today  
- Showing the entry during Welcome  
- Labeling the entry `설정`, `대시보드`, `할 일`, or setup language  

---

# 3. Information Hierarchy

## Primary

**Rhythm titles**

The emotional center of My Rhythms is the set of owned rhythm names.

When the collection is empty, the empty-state title is the temporary primary.

## Secondary

**Schedule orientation**

Time / recurrence (or date · time) may appear as supporting context.

One quiet secondary line is enough.

## Tertiary

**Navigation and maintenance affordances**

- Trailing create control  
- Chevron / row tap to edit  
- Swipe or context delete  
- System back navigation  

These must never outrank titles.

## Explicitly excluded from hierarchy (no hero competition)

| Excluded | Reason |
|----------|--------|
| Metrics / counts as identity | Scoreboard drift (ADR-011 / DR-017) |
| Completion controls | Today owns acknowledgment |
| Progress bars | Today orientation only; not collection identity |
| Breath Flow as Hero | Utility surface — mark steps back (DR-017) |
| Category / status as row hero | Optional detail belongs in Edit, not list identity |
| Reorder as default power feature | Avoid playlist-console energy unless later justified |

### Hierarchy rule

> If chrome, metrics, or destructive affordances become optically louder than rhythm titles, My Rhythms has failed its ownership role.

---

# 4. Empty-State Rules

## Role

My Rhythms empty is a **quiet ownership gap**, not a product introduction.

## It is not another Welcome

| Welcome | My Rhythms empty |
|---------|------------------|
| Brand presence + meaning | No Breath Flow hero |
| Philosophy lines | No philosophy repetition |
| First-journey CTA framing | Soft create invitation only |
| Ends at first successful create (DR-015) | May appear whenever the collection is empty after journey |

## It should

- Acknowledge that the collection is personally empty  
- Invite creating a rhythm  
- Stay calmer and shorter than Welcome  
- Keep create chrome available (trailing +) without narrating the control  

## It must avoid

| Avoid | Why |
|-------|-----|
| CRUD / control instructions (`+ 버튼으로…`) | Turns ownership into UI tutorial |
| Welcome philosophy or Breath Flow meaning block | Violates DR-015 / DR-017 |
| “Nothing here” / broken-empty framing | Implies failure |
| Setup / onboarding step language | Wizard energy |
| Score or streak emptiness copy | Productivity metaphor |

## Canonical guidance (architecture)

| Element | Direction |
|---------|-----------|
| **Title** | Soft ownership acknowledgment that no rhythms are in the collection yet |
| **Supporting line** | Quiet create invitation **without naming toolbar controls** |
| **Preferred spirit** | “Your collection is ready for a first rhythm” — not “Press the plus button” |
| **Existing shipping copy** | May remain until UI Spec update; architecture marks control-instruction empty copy as non-canonical |

Example direction (not a locked UI string set until UI Spec sync):

```text
아직 만든 리듬이 없어요.

첫 리듬을 만들어보세요.
```

(Welcome copy and hierarchy remain unchanged.)

---

# 5. Utility Principles

My Rhythms is allowed to be **plain** where maintenance requires clarity.

Plain is not the same as productive-console identity.

## Why utility becomes plain

- Create / edit / delete need unambiguous actions  
- Over-poetic destructive flows create confusion  
- Brand presence already lived on Launch / Welcome; utility must not re-perform branding  

## Acceptable utility language

| Action | Acceptable |
|--------|------------|
| Add / create entry | `리듬 추가`, soft create CTA, a11y `새 리듬 만들기` |
| Edit | `리듬 편집` |
| Save | `리듬 저장하기`, `변경 저장하기` |
| Delete | `삭제`, calm confirm (`리듬을 삭제할까요?`) |
| Failure | Action-accurate failure titles (delete fail ≠ “변경” fail) |

`등록` remains utility-only (e.g. schedule confirmation) and must not become Experience hero language (DR-017).

## Emotional language that must never appear here

| Never | Why |
|-------|-----|
| Welcome philosophy blocks | Introduction already happened |
| Launch / Breath Flow as Hero | Wrong surface class |
| Celebration on delete/create | Theatrical; not calm |
| Streak / score / “productivity win” | ADR-011 |
| `시작하기` / wizard steps | Onboarding funnel |
| Day Complete / `이어냈어요` as list identity | Today owns acknowledgment |

## Utility rule

> Maintenance verbs may be clear.  
> They must not redefine the screen’s purpose as task administration.

---

# 6. Ownership Rules

## What makes rhythms feel owned

| Signal | Architectural rule |
|--------|-------------------|
| Personal framing | Title and entry speak “my rhythms,” not “manage records” |
| Name-first rows | Title is primary; metadata stays secondary |
| Restraint | No status scoreboard on the collection |
| Continuity with Today | Same cream field and calm voice; different job |
| Honest maintenance | Delete is possible, confirmed, non-celebratory |
| Absence of brand lecture | No repeated philosophy |

## What makes rhythms feel managed

| Signal | Reject |
|--------|--------|
| Admin entry vocabulary as identity | Do not lock `관리` as permanent product language |
| Control tutorials in empty state | Do not instruct which button to press |
| Metrics, completion, progress on rows | Do not import Today acknowledgment or scoring |
| Dense record fields in the list | Keep category/reminder detail in Edit |
| Reorder / bulk ops as default identity | Avoid console power features unless later justified |
| Breath Flow / Welcome reprise | Do not re-introduce the product here |

## Ownership principle

> A rhythm feels owned when its **name** is the hero and maintenance stays in the margins.  
> A rhythm feels managed when **controls, statuses, or admin language** become the story.

---

# 7. Future Compatibility

## Create Rhythm (Sprint 15-5)

| Expectation | Rule |
|-------------|------|
| Relationship | Create/Edit are utility forms entered from My Rhythms (or Today empty CTAs) |
| Brand | No Breath Flow hero; cream/sage tokens OK (DR-017) |
| Language | Plain save/add/edit acceptable; no Welcome philosophy |
| Return | After save, collection and Today refresh; no graduation celebration |
| Capture-first | Follow `Create-Rhythm-Architecture.md` / DR-019 — identity + time primary; Configure secondary |
| Compatibility | Create remains subordinate to ownership; one architecture with Edit |

## Settings (DR-020)

| Expectation | Rule |
|-------------|------|
| Relationship | Settings is a separate utility surface — not inside My Rhythms as a dumping ground |
| Brand | Mark steps back; quiet chrome |
| Boundary | Preferences ≠ rhythm collection; do not merge Settings IA into My Rhythms rows |
| Compatibility | My Rhythms stays rhythms-only overview + maintenance |
| Authority | `Settings-Architecture.md` / DR-020 |

## Compatibility statement

My Rhythms Architecture is compatible with later Create and Settings work **without redesigning this screen’s role**.

Those sprints may refine forms and preferences; they must not convert My Rhythms into a dashboard or settings hub.

---

# 8. Final Architectural Decision

## Decision

My Rhythms is the **quiet personal rhythm collection** of OneulRhythm.

1. **Purpose** — Own and maintain rhythms; never task-manage the day.  
2. **Entry** — Collection access; ownership-aligned labeling is architectural direction; `관리` is legacy interim only.  
3. **Hierarchy** — Titles primary; schedule secondary; chrome tertiary; no metrics/completion/progress as identity.  
4. **Empty** — Quiet ownership gap; not Welcome; no control-instruction canonical copy.  
5. **Utility** — Plain maintenance language OK; emotional brand performance forbidden.  
6. **Ownership** — Name-first, chrome-second.  
7. **Future** — Create and Settings stay compatible without changing this role.

## Non-goals

- Visual redesign of list/cards  
- Immediate string migration in this document’s sprint  
- Adding analytics, reorder, or Breath Flow  
- Absorbing Settings into My Rhythms  

## Guiding question

> Does this decision help the user feel they **own** their rhythms — while keeping Today free to hold a single calm focus?

If the answer is no, it does not belong in My Rhythms Architecture.

---

# Relationship to Existing Authority

| Authority | Relationship |
|-----------|--------------|
| `PRODUCT-PRINCIPLES.md` | Calm, presence, single focus |
| `BRAND.md` / DR-017 | Utility mark absence; language hierarchy |
| DR-015 | No Welcome reprise; entry hidden on Welcome |
| DR-016 | Launch unrelated except shared calm field continuity |
| `Management-UI-Specification.md` | Current UI contract; defer to this doc for purpose/entry/empty philosophy when they diverge |
| Sprint 15-4A Review | Empirical basis |

---

# Out of Scope

- Exact UI strings lock beyond architectural direction (UI Spec sync later)  
- SwiftUI structure  
- Create Rhythm field design (Sprint 15-5 / DR-019)  
- Settings Implementation (Sprint 15-6D; architecture: DR-020; UI: Settings-UI-Specification)  

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`
- `Docs/Architecture/Decisions/DR-016-launch-experience.md`
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`
- `Docs/Architecture/Decisions/DR-018-my-rhythms.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/Management-UI-Specification.md`
- `Docs/Product/Today-UI-Specification.md`

---

One rhythm at a time.

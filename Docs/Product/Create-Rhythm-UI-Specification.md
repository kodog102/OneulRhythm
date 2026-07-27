# Create Rhythm UI Specification

This document defines the implementation-ready UI contract for Create Rhythm (and shared Edit).

It translates `Docs/Product/Create-Rhythm-Architecture.md` / DR-019 into concrete UI behavior.

It does not redefine Brand Integration, My Rhythms ownership, or Welcome.

**Status:** Implementation-ready UI contract.  
**Architecture authority:** `Create-Rhythm-Architecture.md` / DR-019.

---

# Purpose

Provide a single UI contract so Create feels like **beginning one personal rhythm** while remaining a utility surface.

Whenever ambiguity exists:

1. `Create-Rhythm-Architecture.md` (DR-019)  
2. This Specification  
3. Engineering implementation  

Entry points (Welcome CTA, Normal Empty, My Rhythms `+`, row Edit) remain owned by those surfaces. This document owns the Create/Edit form UI once pushed.

---

# Surface Class

| Rule | Requirement |
|------|-------------|
| Brand mark | No Breath Flow hero |
| Welcome philosophy | Never shown |
| Celebration | Never on save or dismiss |
| Multi-step wizard | Forbidden |
| Background | Today calm cream field |
| Chrome | Utility only |

---

# 1. Navigation Contract

## Titles

| Mode | Navigation title |
|------|------------------|
| Create | `리듬 추가` |
| Edit | `리듬 편집` |

Inline display mode.

## Leading action

| Action | Behavior |
|--------|----------|
| System Back | Dismisses Create/Edit without saving |

No custom branded leading item.

## Trailing action

| Action | Requirement |
|--------|-------------|
| Default | **None required** |
| Forbidden | Trailing “완료” / “저장” that duplicates content Save as a second hero |
| Forbidden | Trailing setup or Welcome actions |

## Save button placement

| Placement | Contract |
|-----------|----------|
| Primary Save | In the **content column**, after Capture and Configure — last major block before bottom safe padding |
| Not | Navigation trailing as the only save |
| Not | Floating celebration CTA |

## Confirmation

Navigation remains utility chrome.

It must never become a Welcome experience (no mark, philosophy, or onboarding steps in the bar).

---

# 2. Capture UI Contract

Capture implements DR-019 Capture: **identity + primary time placement**.

## Contents

| Field | Role |
|-------|------|
| Rhythm name | Primary Capture |
| Primary start time | Secondary Capture (still Capture, not Advanced) |

End time is **not** Capture — it belongs to Configure.

## Visual priority

| Element | Priority |
|---------|----------|
| Name field | Highest in the form — first meaningful focus |
| Start time | Second — clearly part of the same Capture group |
| Capture group vs Configure | Capture must optically outweigh Configure |

## Typography

| Element | Emphasis |
|---------|----------|
| Name | Strongest editable text (title-adjacent / prominent field) |
| Start time label + value | Body / secondary to name, stronger than Configure labels |
| Capture section label (if any) | Quiet; must not outshout the name field |

## Spacing & grouping

- Name and start time form **one Capture group** at the top of the scroll content  
- Tighter internal spacing within Capture than the gap between Capture and Configure  
- Generous air **below** Capture before Configure begins — Capture is the visual starting point  

## Why Capture is the starting point

Users begin a rhythm by naming it and placing it in time.

If Configure appears equal at first glance, Create reverts to task configuration (Sprint 15-5A failure mode).

## Defaults (Create)

| Field | Default intent |
|-------|----------------|
| Name | Empty (required to enable Save) |
| Start time | Sensible “now” aligned for picker precision (avoid accidental past-second dialogs) |
| Configure defaults | Applied without forcing Configure interaction |

## Placeholder

Human, ownership-toned example remains appropriate (shipping direction):

```text
예: 따뜻한 차 한잔 마시기
```

---

# 3. Configure UI Contract

Configure implements DR-019 Configure / Advanced.

## Contents

| Field | Role |
|-------|------|
| End time (optional span) | Advanced time refinement |
| Category | Taxonomy refinement |
| Repeat (recurrence) | Schedule refinement |
| Reminder | Notification refinement |

## Visual hierarchy

| Rule | Requirement |
|------|-------------|
| Weight | Quieter than Capture — lighter section emphasis, not equal “hero cards” competing with name |
| Order | Appears **below** Capture |
| Density | May use compact chips/toggles; must not tower over Capture |

## Disclosure behavior

| Concern | Contract |
|---------|----------|
| End time detail | Behind progressive disclosure (e.g. toggle) — collapsed by default on Create |
| Reminder offsets | Behind reminder enablement — collapsed until on |
| Category | Available without a second screen; **must not match Capture visual priority** on Create |
| Repeat | Same as Category |
| Create vs Edit | Create: Configure quieter / more deferred by default. Edit: Configure may be more readily visible while still below Capture |

### Mechanism (contract-level, not API)

Allowed approaches (pick one coherent pattern in implementation):

1. **Deferred emphasis** — Configure fields visible but secondary styling and grouped under a quieter Configure heading  
2. **Grouped disclosure** — a single quiet “more options” / Configure disclosure revealing category, repeat, reminder, end-time controls  

Forbidden:

- Multi-page wizard steps  
- Hiding Configure permanently on Edit  
- Elevating Category/Repeat to the top above name  

## How Configure supports Capture without competing

- Defaults make Configure skippable to save  
- Capture remains first in reading order and optical weight  
- Configure refinements do not block Save when Capture is valid  
- No checklist of “complete all sections”  

---

# 4. Form Hierarchy Contract

Canonical reading / layout order:

```text
Navigation chrome (utility)
        ↓
Capture
    Name
    Primary start time
        ↓
Configure
    End time (disclosed)
    Category
    Repeat
    Reminder (disclosed)
        ↓
Save
```

## Card weight

| Region | Weight |
|--------|--------|
| Capture | Strongest content surface |
| Configure | Secondary surface(s) — reduced competition with Capture |
| Save | Supportive primary action; not larger emotionally than name |

## Spacing rhythm

1. Capture internal — cohesive group  
2. Capture → Configure — clear separation (Configure starts a quieter band)  
3. Configure internal — moderate; disclosure expansions grow downward  
4. Configure → Save — clear support gap  
5. Bottom safe padding — Save never collides with home indicator  

## Section emphasis

- Capture may use one calm grouped surface  
- Configure must not present five equal “settings panels” that each rival the name  
- No Breath Flow, tips carousel, or progress-through-setup UI  

## Empty / invalid Capture

- Save disabled (or equivalently non-active) until name is non-empty after trim  
- No shaming validation theater  

---

# 5. Save Contract

## Wording (approved utility locks)

| Mode | Label |
|------|-------|
| Create | `리듬 저장하기` |
| Edit | `변경 저장하기` |

Direction: persistence acknowledgement — not “완료”, not “시작하기”, not wizard “Next”.

## Placement

- Full content-width within horizontal margins  
- Below Configure  
- Above bottom safe area padding  

## Safe area

- Respect bottom inset  
- Scroll content so Save remains reachable with keyboard open where system allows  

## Keyboard behavior

| Behavior | Contract |
|----------|----------|
| Name field | Submit/done dismisses keyboard where platform supports |
| Focus | Initial focus may land on name (Create); must not jump to Configure first |
| Keyboard avoidance | Standard scroll avoidance; no custom branded keyboard accessory required |

## Create vs Edit

| | Create | Edit |
|--|--------|------|
| Label | `리듬 저장하기` | `변경 저장하기` |
| Success | Dismiss + parent refresh; no toast/celebration | Same |
| Disabled | While name empty or saving | Same |

## Emotional rule

Save feels like quiet acknowledgement that the rhythm now exists (or was updated).

Save must never become completion theater, graduation, or checklist triumph.

## Failure

Calm utility alert (shipping direction):

| Element | Copy |
|---------|------|
| Title | `리듬을 저장하지 못했어요` |
| Message | `잠시 후 다시 시도해주세요.` |
| Action | `확인` |

Past-time and notification-permission dialogs remain utility confirmations (`등록` only inside those dialogs per DR-017).

---

# 6. Product Language Review

## Locked / acceptable utility (keep)

| Area | Copy | Notes |
|------|------|-------|
| Nav Create | `리듬 추가` | Utility-plain |
| Nav Edit | `리듬 편집` | Utility-plain |
| Save Create | `리듬 저장하기` | Persistence acknowledgement |
| Save Edit | `변경 저장하기` | Utility-plain |
| Name placeholder | `예: 따뜻한 차 한잔 마시기` | Ownership-toned |

## Configure labels — review (settings / scheduler / taxonomy tone)

| Current tendency | Risk | Calmer direction (recommend, not hard-lock) |
|------------------|------|-----------------------------------------------|
| `카테고리` | Taxonomy / settings | Quieter framing as optional refinement (e.g. mood/context wording) if renamed later |
| `종료 시간 설정` | Configuration UI | Prefer plain “종료 시간” + disclosure without “설정” |
| `반복` / `반복 안 함` | Scheduler | Acceptable in Configure; keep visually secondary |
| `시작 전에 알려주기` | Mild system | Acceptable |
| `오늘로 등록` / `내일로 등록` | Registration | Keep **dialog-only**; never nav/save/Experience |

## Forbidden on this surface

| Forbidden | Why |
|-----------|-----|
| Welcome philosophy lines | Second Welcome |
| `시작하기` / `계속` / `Next` | Wizard |
| Score / streak / “완료했어요” as save | Wrong philosophy |
| Control tutorials | CRUD coaching |

Implementation may retain existing Configure chip strings initially if hierarchy/disclosure is fixed first; language softening is secondary to Capture-first layout.

---

# 7. Motion Contract

| Moment | Motion |
|--------|--------|
| Push into Create/Edit | Standard system navigation |
| Keyboard appear/dismiss | System keyboard animation |
| Expanding Configure / end / reminder | Soft ease height change only — no bounce |
| Dismiss after save | Standard pop; no custom success choreography |
| Reduce Motion | No decorative expansion offset; prefer instantaneous or opacity-only if any transition is used |

## Forbidden

- Celebration / confetti  
- Staged onboarding section reveals as a tour  
- Bounce, overshoot, attention loops  

---

# 8. Accessibility Contract

## VoiceOver reading order

1. Navigation title  
2. Capture — name  
3. Capture — start time  
4. Configure fields (in on-screen order; disclosed content only when visible)  
5. Save button  

## Section headers

- Capture / Configure groupings announced as headers where structure exists  
- Name is the primary content field — not outranked by Configure headers  

## Chips / choices

- Selected state must be exposed (`isSelected` or equivalent)  
- Labels equal visible text  
- Disabled/unselected calmly conveyed  

## Dynamic Type

| Rule | Requirement |
|------|-------------|
| Name | Scales; no truncation mid-word without reflow |
| Save | Height grows with label; minimum 44pt; no fixed clip height |
| Chips | Reflow or wrap; remain tappable |
| Hierarchy | Name > time > Configure labels survives XXL |

## Focus behavior

- Create: prefer initial focus on name  
- Opening Configure disclosure must not steal focus from an in-progress name edit unexpectedly  
- Modal alerts (save fail, past time, notification settings) use system focus  

---

# 9. Future Compatibility

| Future | UI rule |
|--------|---------|
| Edit Rhythm | Same hierarchy; Configure may be more expanded; no second editor product |
| Settings | Permission recovery may deep-link; do not embed Settings IA in Capture |
| Richer recurrence | Add inside Configure / disclosure — never above name; never multi-step wizard |
| More optional configuration | Advanced band only |

No architectural changes in this document.

---

# 10. Final UI Decision

## Contract summary

1. Utility navigation: `리듬 추가` / `리듬 편집`; Back dismisses; Save in content  
2. Capture first: name + start time as the visual starting group  
3. Configure below: end time, category, repeat, reminder — quieter, disclosable, skippable via defaults  
4. One scroll surface — no wizard pages  
5. Save acknowledges persistence via quiet return — no theater  
6. A11y and motion reinforce Capture → Configure → Save  

## Success condition

> A squint test should show the name (and its Capture group) as the form’s center — with Configure clearly secondary and Save as a calm doorway back to Today or My Rhythms.

## Guiding question

> Does this UI help someone begin one personal rhythm with Capture first — without turning Create into settings, a scheduler console, or Welcome?

If the answer is no, it does not belong in this specification.

---

# Out of Scope

- SwiftUI structure  
- Exact point sizes / animation durations  
- Schedule Engine behavior  
- Welcome / My Rhythms entry chrome (already specified elsewhere)  
- Full rename of every Configure string (recommendations only unless locked above)  

---

# Related Documents

- `Docs/Product/Create-Rhythm-Architecture.md`
- `Docs/Architecture/Decisions/DR-019-create-rhythm.md`
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`
- `Docs/Architecture/Decisions/DR-018-my-rhythms.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`

---

One rhythm at a time.

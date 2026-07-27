# My Rhythms UI Specification

This document defines the implementation-ready UI contract for the My Rhythms experience.

It translates the approved My Rhythms Architecture (`Docs/Product/My-Rhythms-Architecture.md` / DR-018) into concrete UI behavior.

It does not redefine product philosophy, Brand Integration, or Create / Edit form internals.

**Status:** Implementation-ready UI contract.  
**Architecture authority:** `My-Rhythms-Architecture.md` / DR-018.

---

# Purpose

Provide a single UI contract for:

- Today entry into My Rhythms  
- Navigation chrome  
- Empty state  
- Rhythm list rows  
- Toolbar create affordance  
- Delete flow  
- Motion  
- Accessibility  

Whenever ambiguity exists:

1. `My-Rhythms-Architecture.md` (DR-018)  
2. This Specification  
3. `Management-UI-Specification.md` (membership / section rules)  
4. Engineering implementation  

When this document and `Management-UI-Specification.md` diverge on **entry label**, **empty copy**, or **delete failure wording**, **this document wins**.

Section membership, recurring vs one-time rules, and schedule formatting continue to follow `Management-UI-Specification.md` unless explicitly overridden here.

---

# Relationship to Today

| Concern | Authority |
|---------|-----------|
| When entry appears | DR-015 — after First Journey completes; hidden on Welcome |
| Entry UI | This document |
| Today primary focus | `Today-UI-Specification.md` — must not be competed with by entry |
| My Rhythms purpose | DR-018 |

---

# 1. Entry UI Contract

## Placement

- Today trailing toolbar  
- Secondary chrome only  
- Visible only when First Journey is complete  

## Displayed label

```text
내 리듬
```

Replaces legacy visible `관리`.

## Accessibility

| Trait | Copy |
|-------|------|
| Label | `내 리듬` |
| Hint | `리듬 목록을 엽니다` |

Do not use `리듬 관리` as the accessibility label.

## Visual weight

| Rule | Requirement |
|------|-------------|
| Typography | Caption-level (or equivalent quiet secondary) |
| Color | Secondary text — never primary filled button styling |
| Competition | Must never outrank Today’s primary rhythm title, Welcome Hero, or primary CTAs |

## Confirmation

Entry remains secondary chrome.

It must never compete with Today’s primary rhythm.

## Interaction

- Single tap pushes My Rhythms  
- No long-press menu required  

---

# 2. Navigation Contract

## Screen title

```text
내 리듬
```

Inline navigation title.

## Toolbar

| Item | Placement | Behavior |
|------|-----------|----------|
| Create | Trailing | Opens Create Rhythm flow |
| System back | Leading (system) | Returns to Today |

### Plus button

| Concern | Contract |
|---------|----------|
| Visible control | System/plus symbol (or equivalent quiet create glyph) |
| Tint | Product primary (sage) at toolbar weight — not a hero CTA block |
| Accessibility label | `새 리듬 만들기` |
| Result | Opens existing Create flow |

## Chevron

- Trailing on each row  
- Tertiary affordance only  
- Decorative for VoiceOver (`accessibilityHidden`)  
- Visual meaning: row opens Edit  

## Hierarchy (reading / visual importance)

```text
Navigation title (chrome)
        ↓
Rhythm titles (primary content)
        ↓
Schedule (secondary)
        ↓
Controls (tertiary: chevron, swipe, plus)
```

Navigation chrome frames the collection.  
Rhythm titles remain the content hero.

---

# 3. Rhythm Row Contract

## Primary

**Title** — strongest text in the row.

## Secondary

**Schedule** — one supporting line.

| Kind | Pattern |
|------|---------|
| Recurring | `{time} · {recurrence}` |
| One-time | `{date} · {time}` |

- One-time date uses `오늘` when local-day matched; otherwise short month-day  
- Visible recurrence stays short (`매일` / `평일` / `주말`) per existing Management rules  

## Tertiary

**Chevron** — edit affordance only.

## Interaction

| Action | Result |
|--------|--------|
| Tap row | Opens Edit for that rhythm |
| Swipe trailing / context menu | Delete (with confirmation) |

## Explicitly excluded from the row

| Forbidden | Why |
|-----------|-----|
| Category badge | Detail belongs in Edit; avoids console density |
| Completion control | Today owns acknowledgment (DR-017) |
| Progress | Not collection identity |
| Analytics / history | Out of scope |
| Metrics / counts as row identity | Score drift (ADR-011) |
| Breath Flow | Utility surface — mark absent (DR-017) |
| Status pills (done / overdue as brand) | Avoid checklist identity on collection |

## Sections

Retain calm sectioned overview:

- `반복되는 리듬` (when non-empty)  
- `예정된 리듬` (when non-empty)  

Hide empty sections entirely.

---

# 4. Empty-State Contract

Appears when there are no recurring definitions and no today/future one-time rhythms.

## Role

Quiet ownership gap — not Welcome, not CRUD tutorial.

## Approved copy

```text
아직 만든 리듬이 없어요.

첫 리듬을 만들어보세요.
```

| Element | Copy | Role |
|---------|------|------|
| Title | `아직 만든 리듬이 없어요.` | Ownership acknowledgment |
| Supporting | `첫 리듬을 만들어보세요.` | Quiet invitation |
| In-content CTA | **None** | Create remains the trailing plus |

## Replaces (non-canonical)

```text
+ 버튼으로 첫 리듬을 만들어보세요.
```

## Rules

| Must | Must not |
|------|----------|
| Feel calm and owned | Repeat Welcome philosophy |
| Invite creation softly | Name toolbar controls (`+ 버튼`) |
| Keep trailing plus available | Show Breath Flow / Hero Meaning |
| Stay shorter than Welcome | Use dashboard / “nothing here” failure tone |
| Combine for VoiceOver | Add secondary tips, dots, or setup steps |

---

# 5. Delete Contract

## Confirmation (required before mutation)

| Element | Copy |
|---------|------|
| Title | `리듬을 삭제할까요?` |
| Message | `삭제한 리듬은 되돌릴 수 없어요.` |
| Confirm | `삭제` (destructive) |
| Dismiss | `취소` |

## Success

- No success toast, badge, or celebration  
- List updates quietly (section membership / empty transition)  
- Recurring delete follows existing deactivation policy  
- One-time delete removes that routine only  

## Failure

Wording must match **delete** behavior (DR-017 / DR-018).

| Element | Copy |
|---------|------|
| Title | `리듬을 삭제하지 못했어요` |
| Message | `잠시 후 다시 시도해주세요.` |
| Action | `확인` |

### Forbidden failure framing

| Forbidden | Why |
|-----------|-----|
| `리듬을 변경하지 못했어요` for delete | Mismatched action language |
| Celebratory or shaming copy | Violates calm utility |

## Emotional rule

No emotional celebration on delete or delete success.

---

# 6. Motion Contract

| Moment | Motion |
|--------|--------|
| Push Today → My Rhythms | Standard system navigation transition |
| Empty ↔ catalog membership | Soft ease-in-out content transition only |
| Insertion (after create return) | Quiet list/content update — no fanfare |
| Deletion (after confirm) | Quiet list/content update — no fanfare |
| Reduce Motion | No content transition animation |

## Forbidden motion

- Bounce  
- Overshoot  
- Confetti / celebration  
- Attention-demanding delete flourishes  

Motion confirms quiet change only.

---

# 7. Accessibility Contract

## Entry (Today)

- Label: `내 리듬`  
- Hint: `리듬 목록을 엽니다`  
- Trait: button  

## Navigation

- Title announced as screen context (`내 리듬`)  
- Plus: `새 리듬 만들기`  

## Rows

- Accessibility label leads with title; schedule fragments follow  
- Trait: button  
- Hint: `편집하려면 탭하세요`  
- Chevron: hidden  
- Visible short recurrence; VoiceOver uses explicit `매일 반복` / `평일 반복` / `주말 반복` where applicable  

## Empty

- Combined into one accessibility element  
- Title may carry header trait  
- Supporting invitation included in the combined reading  

## Delete

- Confirmation uses system alert semantics  
- Destructive confirm labeled `삭제`  
- Failure alert title matches delete (`리듬을 삭제하지 못했어요`)  

## Dynamic Type

- Titles reflow; hierarchy Title > Schedule > Chrome survives  
- No clipping of rhythm titles at accessibility sizes  
- Row remains tappable at minimum touch expectations  

## Product language (DR-017)

- Prefer ownership / utility-plain wording  
- Avoid management identity labels on entry  
- Avoid score / completion language on this surface  

---

# 8. Final UI Decision

## Visible My Rhythms UI (this contract)

1. Today entry: caption-weight `내 리듬` (secondary)  
2. Screen: title `내 리듬` + trailing create + sectioned name-first list  
3. Empty: ownership acknowledgment + soft invitation; no control tutorial; no in-content CTA  
4. Delete: confirm → quiet update; failure titled as delete failure  
5. Motion: calm; Reduce Motion respected  
6. Accessibility: ownership-aligned labels; rows as edit buttons  

## Success condition

> From Today’s quiet `내 리듬` entry through the collection and empty state, the UI should feel like visiting a personal shelf — never like opening an admin console or a second Welcome.

## Guiding question

> Does this UI keep rhythm titles as the hero, chrome secondary, and language free of management / control-tutorial / Welcome reprise?

If the answer is no, it does not belong in this contract.

---

# Out of Scope

- Create / Edit form field UI (Sprint 15-5 territory)  
- Settings  
- Exact point sizes / token names  
- SwiftUI APIs  
- Reorder  
- Widget / Live Activity / Watch  
- Changing DR-015 lifecycle  

---

# Related Documents

- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Architecture/Decisions/DR-018-my-rhythms.md`
- `Docs/Product/Management-UI-Specification.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/Product/Today-UI-Specification.md`

---

One rhythm at a time.

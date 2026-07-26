# Management UI Specification

This document defines the implementation-ready UI specification for Routine Management.

It translates the approved Product relationship between Today and Management into concrete UI behavior.

This document specifies what should appear, when it should appear, and how each component behaves.

It does not redefine Product Experience (`Docs/Product/Today-Experience.md`), Product Philosophy (`Docs/Product/PRODUCT-PHILOSOPHY.md`), or Architecture.

---

# Purpose

Routine Management is the calm overview of the user's personal rhythms.

It is the home of ongoing Create, Edit, and Delete.

It is not Today.

It does not present a single primary focus for the current moment.

It helps the user configure the rhythms that Today later presents one at a time.

Whenever ambiguity exists:

1. Product Experience

2. This Specification

3. Engineering implementation

---

# Screen Title

내 리듬

---

# Screen Composition

Management follows a sectioned overview.

Screen title

↓

반복되는 리듬 (when present)

↓

예정된 리듬 (when present)

Empty sections are hidden completely.

No additional primary sections must exist.

---

# Product Responsibility

Management shows configured rhythms and upcoming one-time plans.

It does not show historical execution history as list rows.

Today remains responsible for the current-moment focus.

Management remains responsible for overview and configuration.

---

# Sections

## 반복되는 리듬

Contains active recurring definitions only.

Each recurring definition appears once.

Identity is the recurring definition id.

Historical recurring occurrences never appear as Management rows.

Deactivated recurring definitions never appear.

## 예정된 리듬

Contains today and future one-time rhythms only.

Identity is the one-time routine id.

Past one-time rhythms never appear.

Materialized recurring occurrences never appear in this section.

---

# Section Behavior

Management membership follows these rules:

- Recurring section: active recurring definitions only
- One-time section: today and future one-time rhythms only
- No historical recurring occurrences
- No past one-time rhythms

Persisted history may still exist for Today, Live Activity, and completion continuity.

That history must not re-enter Management as list content.

---

# Row Information Hierarchy

Each Management row presents information in this order of importance:

Title

↓

Time

↓

Recurrence / Date

### Visual presentation

Title is primary.

Schedule context appears as one secondary line.

Recurring secondary line

`{time} · {recurrence}`

One-time secondary line

`{date} · {time}`

One-time date uses `오늘` when the rhythm belongs to the current local day.

Otherwise it uses a short month-day date.

Title must remain the strongest signal.

Schedule context must never dominate the title.

---

# Empty State

Empty appears when Management has no recurring definitions and no today/future one-time rhythms.

Approved Copy

아직 만든 리듬이 없어요.

+ 버튼으로 첫 리듬을 만들어보세요.

Empty must feel calm and instructional.

It must not reintroduce Today First Journey onboarding.

---

# Navigation

## Tap row → edit

Tapping a row opens the existing edit flow for that rhythm.

## ＋ button → create

The trailing toolbar plus button opens create.

Accessibility label

새 리듬 만들기

## Swipe / context menu → delete

Trailing swipe and context menu offer delete.

Delete requires confirmation before mutation.

Approved confirmation

리듬을 삭제할까요?

삭제한 리듬은 되돌릴 수 없어요.

Recurring delete deactivates the definition according to the existing Management deletion policy.

One-time delete removes that routine only.

---

# Accessibility

Visible recurrence labels omit the word "반복" because the section already communicates recurrence:

- 매일
- 평일
- 주말

VoiceOver recurrence labels retain explicit repetition context:

- 매일 반복
- 평일 반복
- 주말 반복

### Row accessibility

- Row title leads the accessibility label.
- Schedule fragments follow the title.
- Rows are announced as buttons.
- Edit hint: `편집하려면 탭하세요`
- Decorative chevron is hidden from VoiceOver.
- Empty guidance is announced as one combined element.
- Dynamic Type must preserve readable hierarchy without clipping titles.

---

# Motion

Management uses subtle content transition when empty state and catalog membership change.

Default motion

- Soft ease-in-out content transition

Reduce Motion

- No content transition animation

Motion must confirm quiet list change only.

It must never celebrate creation, deletion, or completion.

---

# Interaction Rules

- Management is reached from Today secondary navigation (`관리`).
- Create, Edit, and Delete remain available while rhythms exist.
- Management must not become a second Today focus surface.
- Management must not show completion controls or Primary Rhythm presentation.

---

# Visibility Rules

If the recurring section has no items

- Hide the entire section.

If the one-time section has no items

- Hide the entire section.

If both sections are empty

- Show Empty State.
- Keep the create affordance available through the ＋ button.

---

# Implementation Notes

- Management lists configured rhythms, not occurrence history.
- Section titles are Product copy and must remain stable.
- Recurrence visible labels stay short; VoiceOver keeps the fuller repetition wording.
- Row schedule formatting belongs to Management presentation, not Today Snapshot.
- Existing create/edit flow is reused; Management does not introduce a parallel editor.
- Spacing and section surfaces should feel calm and connected, never dense or dashboard-like.

---

# Out of Scope

This document does not define:

- Today screen behavior
- Widget UI
- Live Activity UI
- Apple Watch UI
- Design Tokens
- SwiftUI implementation details
- Layout constants
- Animation timing values
- Architecture
- Persistence technology
- Schedule Engine ownership
- Notification scheduling
- Advanced recurrence beyond daily / weekdays / weekends

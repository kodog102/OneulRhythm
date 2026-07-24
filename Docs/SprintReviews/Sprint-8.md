> **Archived**
>
> This document is retained for historical reference.
> It is not an active product, architecture, or implementation contract.

# Sprint 8 — Today Product Experience

## Sprint Goal

Elevate the in-app Today experience toward MVP quality by completing the first full Documentation First development cycle: define Product Experience, explore hierarchy, lock an implementation-ready UI contract, then implement only what that contract requires — without reopening Schedule Engine, Repository, or Snapshot ownership.

---

## Major Product Changes

### Today UI Redesign

Today was rebuilt as a single vertical flow: Greeting → Date → Primary Rhythm Area → optional Next → optional Progress. The screen reads as one calm composition rather than a task dashboard. Whitespace, typography hierarchy, and component visibility follow the approved UI Specification.

### Single Primary Rhythm Experience

Exactly one Primary Rhythm Area holds attention at any time. Supporting information (time, Next Rhythm, Progress) remains subordinate. Rhythm Meaning stays hidden because Sprint 8 has no approved data source — no placeholder text is shown.

### Empty State Redesign

Empty is an open invitation, not a broken day. The state shows Greeting, Date, Empty Guidance, and a single onboarding control. Primary Rhythm, Completion, Next, and Progress remain hidden.

### Empty-only Create Rhythm CTA

`리듬 만들기` appears only when Today has zero routines. It opens the existing AddRoutine flow and must disappear completely once at least one routine exists. Permanent routine management does not return to Today; that belongs to Sprint 9.

### Day Complete Experience

When today's rhythms are complete, Today presents quiet closure with the approved message `오늘의 리듬을 모두 이어냈어요.` Primary Rhythm, Next, Completion, and Create Rhythm CTA are hidden. Progress may remain as soft orientation only.

---

## Documentation

Sprint 8 completed the Product documentation foundation for Today:

- `Docs/Product/Today-Experience.md` — North Star Product Experience for Today and future surfaces
- `Docs/Product/Today-Wireframe-Exploration.md` — information hierarchy and attention exploration
- `Docs/Product/Today-UI-Specification.md` — implementation-ready UI contract (states, visibility, approved copy, CTA rules)

Product documentation evolved from implementation feedback: Manual QA discovered that Empty without a create entry was a dead-end, so the Create Rhythm CTA contract was written into the UI Specification before the affordance was implemented.

Architecture and Product Principles remained the governing constraints (`Docs/Product/PRODUCT-PRINCIPLES.md`, DR-014 Product UI First). No Architecture redesign was required.

---

## Architecture

- Existing pipeline preserved: Repository → Schedule Engine → ResolvedSchedule → Snapshot → ViewModel → View
- Primary Rhythm ownership remains in `TodayRhythmSnapshot`
- No Repository or Schedule Engine changes
- No Notification, Live Activity, or persistence contract changes
- Presentation states are derived from existing snapshot facts only
- Product UI First strategy (DR-014) validated: in-app Today quality advanced without platform expansion

---

## Engineering

### Documentation First Implementation

Implementation followed the approved UI Specification as the single implementation contract. Greeting copy, Empty Guidance, Create Rhythm CTA, and Day Complete strings are Product Contracts, not ad-hoc UI strings.

### Minimal Implementation Scope

Changes stayed in the Today presentation layer:

- `TodayView` — vertical composition, state-driven visibility, Empty Create Rhythm entry
- `TodayViewModel` — `TodayScreenPresentation` mapping, greeting contract, CTA/completion visibility helpers
- `TodayProgressView` — reduced to quiet Level 6 orientation (no card framing, no motivational copy)

### Reuse Over Reinvention

- Existing `AddRoutineView` flow reused for Empty onboarding
- Snapshot-owned primary rhythm and secondary Next preview reused
- Live Activity sync path unchanged

### Scope Discipline

Widget, Watch, Notification scheduling, Rhythm Meaning data, and full Routine Management remained out of scope.

---

## QA

- Manual Visual QA across Empty, Upcoming, Current, Past Incomplete, and Day Complete
- Product Contract validation against `Today-UI-Specification.md` (visibility, hierarchy, approved copy)
- Empty-state onboarding issue discovered: Empty Guidance alone left first-time users without a path to create a rhythm
- Documentation updated before implementation: CTA Visibility Contract and approved copy added to the UI Specification
- Create Rhythm CTA implemented as Empty-only, then revalidated
- Final QA passed

---

## Lessons Learned

- Documentation First reduced implementation ambiguity. Approved Product contracts made UI decisions checkable rather than negotiable during coding.
- Manual QA validates user journeys, not only layouts. Empty looked calm but failed as an onboarding journey until the CTA contract existed.
- Product documentation should evolve from implementation feedback. Spec refinement after Manual QA kept the contract honest without expanding architecture.
- Small implementation scope reduces architectural risk. Preserving Repository, Schedule Engine, and Snapshot ownership let Sprint 8 deliver product quality without reopening earlier contracts.

---

## Sprint Result

Sprint 8 is complete.

The Today screen now expresses the approved Product Experience under a Documentation First workflow, with architecture preserved and Empty onboarding closed through an Empty-only Create Rhythm CTA.

---

## Next Sprint

Sprint 9 — Routine Management

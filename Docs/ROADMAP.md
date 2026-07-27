# OneulRhythm Roadmap

# Product Vision

OneulRhythm helps users stay connected with today's rhythm.

The application should minimize management and maximize presence throughout the day.

## Roadmap Philosophy

Development follows a deliberate sequence:

```text
Core Experience
  ↓
Brand Foundation
  ↓
Brand Assets & Experience
  ↓
Platform Expansion
```

1. **Core Experience** — Today, Live Activity, Management, and supporting foundations that keep users connected with today's rhythm.
2. **Brand Foundation** — Establish the project's long-term brand language, principles, and architectural records before producing visual assets.
3. **Brand Assets & Experience** — Apply the completed Brand Foundation across icon, launch, README, widget consistency, and product surfaces.
4. **Platform Expansion** — Extend the same meaning to Widget, Apple Watch, and other surfaces once foundation and assets are ready to reuse.

Today's experience together with Live Activity already provides the primary quick-access experience. After Brand Foundation and Brand Assets, Sprint 15 completed the in-app Product Experience (Welcome through Settings). Platform Expansion (Widget, Watch) remains intentionally postponed pending Product Owner review after real-world use.

---

# Current Status

## Current Phase

Product Experience (Sprint 15) complete → Next Sprint (pending Product Owner review)

## Current Sprint

Next Sprint — scope not finalized

## Status

✅ Sprint 14 Brand Assets & Design System complete; Brand Lock v1.0 Approved  
✅ Sprint 15 Product Experience complete (documentation + implementation through Settings)  
➡️ Next: Product Owner review after real-world testing; Platform Expansion remains postponed until explicitly scheduled

## Current Goal

Validate the shipped in-app Product Experience in real use before committing the next Sprint scope.

Do not invent new product direction in planning documents. Leave room for Product Owner review.

## Current Priority

Sprint 15 is complete. Prefer learning from the shipped experience over opening new metaphors or platform work.

Immediate focus:

- Keep Widget / Watch postponed until explicitly scheduled under Platform Expansion  
- Do not reopen Brand Lock geometry  
- Do not reopen Sprint 15 experience architecture (DR-017 ~ DR-020)  
- Finalize Next Sprint only after Product Owner review

Sprint 12 Brand Foundation is complete.  
Sprint 13 Brand Assets & Experience is complete (Brand Lock v1.0 Approved).  
Sprint 14 Brand Assets & Design System is complete.

Sprint 15 Product Experience is complete — documentation (Welcome through Settings UI Specification) and implementation (Welcome, Launch, Today refinements, My Rhythms, Create Rhythm, Settings), plus engineering workflow and documentation system updates.

Former Sprint 10 Settings planning is **superseded** by Sprint 15-6 (DR-020). Settings ownership remains unique under Sprint 15 and is implemented.

Widget Experience remains on the long-term roadmap (relocated to Sprint 16) and is intentionally postponed because Live Activity already satisfies the primary quick-access experience.

Notification Foundation remains complete and stable.

---

# Strategy

## Product UI First, Then Brand Before Platforms

After Sprint 7, the core architecture has reached a stable point:

- Today Snapshot
- Notification Pipeline
- Trigger Policy
- Notification Plan
- Notification Synchronization
- Live Activity foundation

Sprints 8–11 validated the in-app Core Experience (Today, Management, UX Polish).

Sprints 12–14 established Brand Foundation and Brand Assets.

Sprint 15 completed Product Experience documentation and implementation (Welcome through Settings).

The next validation value comes from real-world use of the shipped Product Experience, then an explicitly scheduled Next Sprint—not from immediately expanding Widget or Watch.

Widget and Apple Watch remain intentional long-term surfaces under Platform Expansion (Sprint 16 / Sprint 17). They are postponed—not cancelled—so that:

- Brand Foundation and Brand Assets stay stable before platform reuse
- Existing architecture stays stable
- Widget and Watch can reuse a finalized brand language and visual system
- Duplicate UI work and architectural churn are avoided

Widget implementation is intentionally postponed because Today and Live Activity already provide the primary quick-access experience. Widget remains part of the long-term roadmap and is not the automatic next Sprint until Product Owner review.

This is a planning change only. It is not an architecture redesign.

See `Docs/Architecture/Decisions/DR-014-product-ui-first.md`.

---

# Completed

## Sprint 1 — Project Foundation

### Goal

Establish the technical foundation of the application.

### Completed

- SwiftUI project setup

- SwiftData integration

- Initial project structure

- Core application architecture

**Status**

✅ Completed

---

## Sprint 2 — Rhythm Management

### Goal

Allow users to create and manage their rhythms.

### Completed

- Create Rhythm

- Edit Rhythm

- Delete Rhythm

- Repository introduction

- Basic data persistence

**Status**

✅ Completed

---

## Sprint 3 — Today Experience

### Goal

Introduce today's rhythm experience.

### Completed

- Today Screen

- Current Rhythm

- Next Rhythm

- Daily Progress

- Initial presentation flow

**Status**

✅ Completed

---

## Sprint 4 — Persistence

### Goal

Separate persistence from business logic.

### Completed

- SwiftData Repository

- Repository abstraction

- ViewModel integration

- Domain model mapping

**Status**

✅ Completed

---

## Sprint 5 — Schedule Engine

### Goal

Introduce deterministic schedule resolution.

### Completed

- Schedule Engine

- Current Rhythm resolution

- Next Rhythm resolution

- Progress calculation

- Business schedule interpretation

**Status**

✅ Completed

---

## Sprint 6-1 — Live Activity Lifecycle

### Goal

Introduce Live Activity using a stable architecture.

### Completed

- Shared Activity Model

- Activity Coordinator

- Activity Lifecycle

- Immediate Day Complete

- Widget Extension

- Activity reconciliation

**Status**

✅ Completed

---

## Sprint 6-2 — Single Primary Rhythm

### Goal

Create a calm Today experience by presenting only one primary rhythm.

### Completed

- Single Primary Rhythm

- Past Rhythm

- Completion Promotion

- Next Rhythm Preview

- Live Activity integration

- Calm presentation flow

**Status**

✅ Completed

---

## Sprint 6-3 — Documentation Architecture

### Goal

Establish a long-term documentation system for the project.

### Completed

#### Architecture

- Architecture documentation

- Product Principles

#### Decisions

- Decision Record system

- DR-001 ~ DR-011

#### Design

- Mapper

- Scheduling

- Persistence

- Presentation

- Live Activity

#### Extensions

- Extensions documentation

- Recurring Rhythm architecture

#### Documentation

- Documentation hierarchy

- Glossary

- Documentation standards

**Status**

✅ Completed

---

## Sprint 6-4 — Recurring Rhythm

### Goal

Users define a rhythm once.

The application automatically presents today's occurrence.

### Completed

- Recurring Rhythm support

- Daily / Weekdays / Weekends recurrence

- RecurringRhythmEntity persistence

- Automatic daily occurrence provisioning

- Foreground synchronization

- Schedule Engine integration

- Runtime QA completed successfully

**Status**

✅ Completed

---

## Sprint 6-5 — Primary Rhythm Ownership

### Goal

Refine the Today experience so presentation focus is owned by the Today Snapshot.

### Completed

- Primary Rhythm selection inside TodayRhythmSnapshot

- Priority: Current → Past Incomplete → Next

- TodayViewModel forwards snapshot primary state

- TodayView renders only the Primary Rhythm

- Live Activity consumes the same snapshot primary role

- Schedule Engine, Repository, and Activity lifecycle remain unchanged

**Status**

✅ Completed

---

## Sprint 7 — Notification Foundation

### Goal

Notifications become another consumer of today's schedule.

### Completed

#### T1 — Notification Trigger Policy

- Notification permission

- One-time notification scheduling

- NotificationTriggerPolicy

- NotificationService integration

#### T2 — Notification Plan

- NotificationPlan / NotificationPlanItem

- NotificationMapper

- Routine.reminderMinutes domain mapping

- One-time scheduling through NotificationPlan

#### T3 — Notification Synchronization

- NotificationSynchronization minimal diff

- NotificationScheduling.synchronize

- Add / remove / update reconciliation

### Deferred (non-blocking)

- App lifecycle / background invocation of synchronization remains optional future work if approved later

Notification Foundation is considered stable. Deferred lifecycle invocation does not block Product UI work.

**Status**

✅ Completed

---

## Sprint 8 — Today Product Experience

### Goal

Elevate the in-app Today experience toward MVP quality.

### Completed

- Calm single-focus Today experience
- Single Primary Rhythm presentation
- Empty State redesign
- Empty-only Create Rhythm CTA
- Day Complete experience
- Documentation First workflow completed for Today

**Status**

✅ Completed

---

## Sprint 9 — Routine Management

### Goal

Strengthen in-app rhythm creation and management so daily use feels complete.

### Intent

Improve the management flows that support Today, without redesigning persistence or Schedule Engine ownership.

### Completed

- Sprint 9-1 — Routine Management MVP: Management screen, Create/Edit/Delete, Today secondary navigation
- Sprint 9-2 — Management Model Alignment: definition-based Management list, today/future one-time visibility, recurring deletion policy with historical preservation, Today / Live Activity regression verification

**Status**

✅ Completed

---

## Sprint 11 — UX Polish

### Goal

Raise overall in-app UX quality to MVP before new feature work and platform expansion.

### Intent

Polish interaction, clarity, and calm presentation across the Product UI surfaces already in scope.

### Completed

- Today Empty Journey (First Journey Empty / Normal Experience Empty)
- Compatibility Bootstrap for existing creators (DR-015)
- Today Visual Polish
- Motion Polish
- Management redesign (sectioned overview: 내 리듬)
- Accessibility improvements
- Final copy polish
- Documentation synchronization for Today and Management

**Status**

✅ Completed

---

# Planned / In Progress

## Sprint 10 — Settings & Preferences

### Goal (historical)

Provide the preferences users need to support a calm in-app experience.

### Resolution

Sprint 10 Settings planning is **superseded** by Sprint 15-6.

Settings product ownership is defined by:

- `Docs/Architecture/Decisions/DR-020-settings.md`
- `Docs/Product/Settings-Architecture.md`
- `Docs/Product/Settings-UI-Specification.md`

Settings was implemented under **Sprint 15-6D**.

Do not plan a parallel Settings sprint. Do not duplicate Settings architecture here.

**Status**

♻️ Superseded by Sprint 15-6 (DR-020) — implemented in Sprint 15

---

## Sprint 12 — Brand Foundation

### Goal

Establish OneulRhythm's long-term brand foundation.

### Intent

Sprint 12 defines the brand language of the product. It does not produce final visual assets.

Foundation first. Implementation later.

The Sprint records approved brand meaning, design language, visual and motion principles, and architectural decisions so Sprint 13 can apply them consistently.

### Scope Direction

#### Brand Foundation Deliverables

- Brand Manifesto
- Brand Philosophy
- Design Language
- Visual Principles
- Motion Principles
- Breath Flow selected as the Master Symbol
- `Docs/BRAND.md`
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`
- `Docs/ADR/ADR-011-No-Checklist-Metaphor.md`
- `Docs/ADR/ADR-012-Calm-Before-Productivity.md`

### Definition of Done

- ROADMAP updated
- CHANGELOG updated
- PRODUCT-PRINCIPLES reviewed
- `Docs/BRAND.md` completed
- ADR-010 completed
- ADR-011 completed
- ADR-012 completed
- Terminology consistency verified
- Architect Review completed
- Product Owner approval completed

**Status**

✅ Completed

---

## Sprint 13 — Brand Assets & Experience

### Goal

Apply the completed Brand Foundation across product surfaces and brand assets.

### Intent

Sprint 13 is practical application of Sprint 12.

Sprint 12 → Foundation  
Sprint 13 → Application

After Brand Foundation is approved, produce and apply brand assets so every surface feels like one product.

### Scope Direction

Typical deliverables include:

- App Icon production
- Launch Screen
- README Hero
- Widget visual consistency
- Brand asset export
- Applying the approved design language across the product

### Completed

- Brand exploration
- Breath Flow refinement
- Optical refinement
- Brand validation
- Brand Lock v1.0 Approved

**Status**

✅ Completed

---

## Sprint 14 — Brand Assets & Design System

### Goal

Produce production brand assets and the design system package from approved Brand Lock v1.0.

### Scope Direction

- App Icon Assets
- SVG
- PDF
- PNG
- Construction Grid
- Safe Area
- Export Guide
- Motion Principle
- Brand Package

### Completed

- Brand asset architecture (`Work/` / `Release/` / `Guide/`)
- Master Logo exports (SVG / PDF / PNG / mono)
- App Icon 1024 + preview + export pipeline
- Usage, Construction, Safe Area, and Export guides
- Brand System Integration QA
- Brand Package inventory (`Release/` + `Guide/` + manifest)
- Motion Principle: product motion remains under `Docs/BRAND.md` (no separate asset geometry)

**Status**

✅ Completed

---

## Sprint 15 — Product Experience

### Goal

Lock the in-app Product Experience after Brand Assets — Welcome through Settings — so implementation follows approved architecture and UI contracts.

### Intent

Sprint 15 is Product Experience documentation, contracts, and implementation — not Platform Expansion.

It establishes surface purpose, ownership boundaries, and UI specifications for:

- Welcome Experience  
- Launch Experience  
- Brand Integration  
- My Rhythms  
- Create Rhythm  
- Settings  

Architecture authority remains in Decision Records and Product documents (DR-015 ~ DR-020). This roadmap entry does not redefine those decisions.

### Completed (documentation)

- Welcome Experience + UI Specification  
- Launch Architecture + UI Specification (DR-016)  
- Brand Integration Architecture (DR-017)  
- My Rhythms Architecture + UI Specification (DR-018)  
- Create Rhythm Architecture + UI Specification (DR-019)  
- Settings Architecture + UI Specification (DR-020 / Sprint 15-6A ~ 15-6C)  

### Completed (implementation)

- Welcome Experience  
- Launch Experience (Launch Screen + startup continuity)  
- Today Experience refinements aligned with Product Experience contracts  
- My Rhythms  
- Create Rhythm  
- Settings (Sprint 15-6D against DR-020)  
- Engineering workflow refinement (Experience Review → Planning Sync)  
- Documentation system improvements and planning sync

### Explicitly out of scope for Sprint 15

- Widget Experience (relocated to Sprint 16)  
- Apple Watch  
- Redesign of approved DR-017 ~ DR-020 decisions  

**Status**

✅ Completed

---

## Sprint 16 — Widget Experience

### Goal

Bring today's rhythm to the Home Screen.

### Intent

Widget remains part of the long-term roadmap under Platform Expansion.

Formerly numbered as Sprint 15 Widget Experience; relocated so Sprint 15 can represent completed Product Experience work.

Widget implementation remains intentionally postponed because Today and Live Activity already satisfy the primary quick-access experience.

Widget should consume the existing Snapshot, mapping architecture, and finalized Brand Foundation / Brand Assets rather than redefine business logic.

Next Sprint scope is not automatically Widget. Schedule only after Product Owner review.

### Scope Direction

- Home Widget
- Timeline
- Shared Snapshot

**Status**

📅 Planned (postponed; not current active scope)

---

## Sprint 17 — Apple Watch Integration

### Goal

Bring today's rhythm to Apple Watch.

### Intent

Apple Watch remains a future surface under Platform Expansion. It should reuse the finalized Brand Foundation, Brand Assets, and existing architecture.

Formerly Sprint 16; renumbered after Widget relocated to Sprint 16.

### Scope Direction

- Watch App
- Watch Complication
- Shared Schedule

**Status**

📅 Planned (postponed until after Brand Assets & Design System and Widget Experience)

---

# Future

## Advanced Recurrence

Examples

- Custom weekdays

- Monthly recurrence

- Every N days

- End date

- Exception dates

- Holiday support

---

## Statistics

Examples

- Completion history

- Weekly trend

- Monthly trend

- Consistency score

---

## Subscription

Examples

- Advanced recurrence

- Statistics

- Premium themes

- Premium widgets

---

## Platform Extensions

Examples

- Cloud Sync

- Calendar Integration

- Siri

- Shortcuts

- Family Sharing

---

# Product Principles

Every new feature should answer one question.

> Does this help users stay connected with today's rhythm?

If the answer is no,

the feature probably does not belong in OneulRhythm.

---

# Documentation

Product and architecture documentation remain stable.

Sprint process documentation lives under `Docs/Development/`.

Future architectural changes should follow this process:

1. Approve scope and architecture before implementation.

2. Update or propose Decision Records and Design documentation when architecture or contracts change.

3. Implement the approved scope.

4. Run a Documentation Pass to synchronize affected docs with implemented behavior.

5. Record completed work in the Changelog and update this Roadmap.

The Roadmap tracks product evolution and the current development status rather than implementation details.

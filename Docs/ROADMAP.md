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

Today's experience together with Live Activity already provides the primary quick-access experience. Near-term work therefore favors Brand Foundation, then Brand Assets & Experience, over new platform surfaces.

---

# Current Status

## Current Phase

Brand Assets & Experience

## Current Sprint

Sprint 13 — Brand Assets & Experience

## Status

📍 Current — Sprint 12 Brand Foundation complete; Sprint 13 Brand Assets & Experience is current

## Current Goal

Establish OneulRhythm's long-term brand foundation before producing visual assets or expanding to new surfaces.

## Current Priority

Foundation first. Implementation later.

Immediate focus:

- Brand Manifesto
- Brand Philosophy
- Design Language
- Visual Principles
- Motion Principles
- Breath Flow as the Master Symbol
- `Docs/BRAND.md`
- ADR-010 / ADR-011 / ADR-012 (`Docs/ADR/`)

Sprint 11 completed Today Empty Journey, visual/motion polish, Management redesign, accessibility and copy polish, and documentation synchronization.

Sprint 12 Brand Foundation is complete. Sprint 13 — Brand Assets & Experience applies that foundation.

Widget Experience remains on the long-term roadmap and is intentionally postponed because Live Activity already satisfies the primary quick-access experience.

Sprint 10 Settings & Preferences remains planned and does not redefine Sprint 12 or Sprint 13 scope.

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

The next validation value comes from Brand Foundation and Brand Assets & Experience—not from immediately expanding platform integrations.

Widget and Apple Watch remain intentional long-term surfaces under Platform Expansion. They are postponed—not cancelled—so that:

- Brand Foundation and Brand Assets can be completed first
- Existing architecture stays stable
- Widget and Watch can reuse a finalized brand language and visual system
- Duplicate UI work and architectural churn are avoided

Widget implementation is intentionally postponed because Today and Live Activity already provide the primary quick-access experience. Widget remains part of the long-term roadmap.

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

# Planned

## Sprint 10 — Settings & Preferences

### Goal

Provide the preferences users need to support a calm in-app experience.

### Intent

Add settings that serve Product UI quality. Avoid expanding into platform integrations prematurely.

Settings remains planned and does not redefine Sprint 12 Brand Foundation or Sprint 13 Brand Assets & Experience scope.

**Status**

📅 Planned

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

**Status**

📍 Current

---

## Sprint 14 — Widget Experience

### Goal

Bring today's rhythm to the Home Screen.

### Intent

Widget remains part of the long-term roadmap under Platform Expansion.

Widget implementation has been intentionally postponed because Today and Live Activity already satisfy the primary quick-access experience.

Widget should consume the existing Snapshot, mapping architecture, and finalized Brand Foundation / Brand Assets rather than redefine business logic.

### Scope Direction

- Home Widget
- Timeline
- Shared Snapshot

**Status**

📅 Planned (postponed until after Brand Foundation and Brand Assets & Experience)

---

## Sprint 15 — Apple Watch Integration

### Goal

Bring today's rhythm to Apple Watch.

### Intent

Apple Watch remains a future surface under Platform Expansion. It should reuse the finalized Brand Foundation, Brand Assets, and existing architecture.

### Scope Direction

- Watch App
- Watch Complication
- Shared Schedule

**Status**

📅 Planned (postponed until after Brand Foundation, Brand Assets & Experience, and Widget Experience)

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

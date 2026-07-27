# Settings Architecture

This document defines the architectural role of **Settings** within OneulRhythm.

It explains what Settings owns, what it must never own, how App vs OS responsibility is divided, and how future preferences may be admitted without turning Settings into a destination.

It does not define UI layout, cells, icons, copy locks, or SwiftUI structure.

**Status:** Approved Architecture Specification.  
**Decision record:** `Docs/Architecture/Decisions/DR-020-settings.md`.  
**UI contract:** `Docs/Product/Settings-UI-Specification.md`.  
**Basis:** Sprint 15-6A Settings Experience Review.

---

# Purpose

Provide architectural rules so Settings remains OneulRhythm’s **quiet support utility** — supporting the primary experience without competing with it.

Whenever ambiguity exists:

1. `PRODUCT-PRINCIPLES.md` / `BRAND.md` / DR-017 / DR-018 / DR-019  
2. This Specification  
3. `Settings-UI-Specification.md`  
4. Engineering implementation  

Welcome remains the product introduction (DR-015).  
Today remains the single-focus experience (DR-008 / DR-009).  
My Rhythms remains the personal collection (DR-018).  
Create / Edit remains Capture-first utility (DR-019).

---

# Architecture Goal

Settings is a **utility surface**.

Its primary job must feel like:

> adjust how the app supports the day — then leave

not:

> explore, configure, or live inside the product’s control plane

Achieve this through **ownership boundaries**, **OS Owns the OS**, **Quiet Exit**, and **Earn Sections** — not through feature discovery, brand theater, or preference sprawl.

---

# 1. Purpose

## What Settings owns

Settings owns **support around** the rhythm journey:

| Ownership | Meaning |
|-----------|---------|
| **Product-specific preferences** | Durable choices the app must remember that are not rhythm content (e.g. notification-related product prefs) |
| **Support pathways** | Feedback, contact, and similar help without polluting Experience surfaces |
| **App identity (utility)** | Version and related identity for trust and support |
| **Legal / trust documents** | Privacy, Terms, Open Source Licenses |
| **Permission recovery entry** | Clear path toward OS permission surfaces when the product cannot proceed |

## What Settings explicitly does not own

| Not owned | Owner |
|-----------|--------|
| Today’s current rhythm / acknowledgment | Today |
| Product meaning / brand introduction | Welcome |
| Rhythm collection overview | My Rhythms |
| Rhythm create / edit / delete | Create / Edit + My Rhythms |
| OS permission grant / deny | OS |
| OS notification presentation style | OS |
| System language / Appearance / Focus Mode | OS |
| Schedule Engine / Snapshot truth | Existing domain architecture |

## What Settings is

| Is | Meaning |
|----|---------|
| **Quiet support utility** | Preferences, trust, and help — sparse and plain |
| **Separate utility surface** | Not a section inside My Rhythms (DR-018) |
| **Subordinate to Experience** | Never the day’s emotional center |
| **Episodic** | Visited rarely; success is exit |

## What Settings is NOT

| Not | Why |
|-----|-----|
| **Part of the rhythm journey** | Journey is Welcome → Today (+ My Rhythms / Create as needed) |
| **Second Welcome** | No philosophy, Breath Flow meaning, or brand lecture |
| **Second Today** | No focus / acknowledgment identity |
| **Collection / CRUD hub** | My Rhythms + Create own rhythms |
| **OS Settings mirror** | OS Owns the OS |
| **Daily destination** | Violates Less Input / Keep Me Out |

### Success condition

> Opening Settings should feel like briefly adjusting support or checking trust — then returning to presence — never like entering a product console.

---

# 2. Surface Classification

## Classification

| Dimension | Decision |
|-----------|----------|
| **Surface class** | **Utility Surface** (DR-017) |
| **Brand mark** | Breath Flow absent as Hero; quiet chrome / tokens only |
| **Emotional role** | Quiet utility / Quiet Exit |
| **Journey membership** | **Outside** the primary rhythm journey |

## Relationship to other surfaces

```text
Welcome / Launch  →  introduce presence (Identity)
Today             →  live today’s focus (Experience)
My Rhythms        →  own and maintain the collection (Utility)
Create / Edit     →  capture / refine one rhythm (Utility)
Settings          →  support preferences, trust, help (Utility — deepest step-back)
```

| Surface | Relationship to Settings |
|---------|--------------------------|
| **Today** | Settings must not interrupt or reframe today’s focus. Return to Today is a valid Quiet Exit. |
| **My Rhythms** | Separate surface. Preferences ≠ collection. Do not merge Settings IA into My Rhythms rows (DR-018). |
| **Create / Edit** | System preferences stay out of Capture center. Deep links / prompts for permission recovery may hand off toward Settings or OS (DR-019). |
| **Welcome** | Settings must not appear as part of first-launch meaning. Entry remains appropriate only after Welcome’s product job (and must never re-teach philosophy). |

## Why Settings stays outside the primary journey

1. **One Primary Focus** — Today owns the day’s attention; Settings would dilute it if treated as peer journey.  
2. **Less Input. More Presence.** — Daily visits to Settings would mean the product is managing the user instead of staying quiet.  
3. **Calm over Complexity.** — Journey surfaces already carry enough decisions; Settings must not become a second decision surface for living the day.  
4. **Brand Integration** — Utility steps back; Settings is the furthest step-back and must not re-perform Identity.

---

# 3. Ownership Boundaries

## Settings owns

| Domain | Architectural scope |
|--------|---------------------|
| **Notifications (product)** | In-app preferences about how OneulRhythm uses reminders — not OS permission UI recreation |
| **Support** | Feedback, contact, and equivalent help exits |
| **About / App identity** | Version, licenses, and non-brand identity for support |
| **Legal** | Privacy Policy, Terms of Use (presentation / links) |
| **Future earned prefs** | Only after Earn Sections criteria (see §6) |

## MVP information architecture (product groups)

High-level groups only — not cell design:

| Section | Owns |
|---------|------|
| **Notifications** | Product-side notification / reminder preferences and recovery toward OS permission when needed |
| **Support** | Feedback / contact pathways |
| **About** | Legal, version, open-source licenses |

Do not invent empty sections for Widget, Watch, Sync, or Appearance until those preferences exist.

## Other surfaces own

### Today

| Owns | Does not own |
|------|--------------|
| Current primary rhythm | Preference matrix |
| Acknowledgment / Day Complete | Legal / support hubs |
| Day atmosphere and single focus | OS permission management |

### Create / Edit

| Owns | Does not own |
|------|--------------|
| Rhythm identity + time (Capture) | App-wide Settings IA |
| Per-rhythm Configure (e.g. reminder on a rhythm) | Global notification policy dump as Capture hero |
| Permission recovery prompts that deep-link out | Recreating OS Settings |

**Boundary note:** Per-rhythm reminder toggles may live on Create/Edit as Configure. **App-wide** notification preference and OS handoff belong to Settings (or OS). Do not duplicate the same control in both places without a clear ownership rule in UI Spec.

### My Rhythms

| Owns | Does not own |
|------|--------------|
| Personal rhythm collection | Preferences, legal, version |
| Entry to Create / Edit / Delete | Support / marketing / analytics |

### Welcome

| Owns | Does not own |
|------|--------------|
| Product meaning and first presence | Settings education |
| Natural next step toward first create | Preference onboarding |

### Launch / App Icon

| Owns | Does not own |
|------|--------------|
| Identity presence (Breath Flow) | Any Settings content |

---

# 4. App vs OS Responsibility

## Principle — OS Owns the OS

Do **not** duplicate operating system settings inside the app.

OneulRhythm may **explain**, **deep-link**, or **reflect** OS state when needed for recovery. It must not rebuild OS control panels.

## App owns

| Responsibility | Why |
|----------------|-----|
| Product-specific reminder enable/disable (where product-defined) | Part of OneulRhythm’s quiet presence model |
| Reminder timing / plan as defined by product + Schedule / Notification architecture | Domain logic — not a visual OS clone |
| Whether the product attempts to notify (within granted permission) | Product behavior |
| In-app preference persistence for product choices | App storage |
| Support / legal / version presentation | App trust surface |
| Deep link toward the relevant OS Settings pane | Recovery without duplication |

## OS owns

| Responsibility | Why |
|----------------|-----|
| Notification **permission** (authorize / deny) | System authority |
| Notification **presentation** (banners, sounds, Lock Screen, etc. as exposed by iOS) | System authority |
| System language / region | System authority |
| System Appearance (Light / Dark / Automatic) | System authority |
| Focus Mode / system interruption filters | System authority |
| Broader OS privacy toggles | System authority |

## Collaboration pattern

```text
Product preference (App)  →  may require permission (OS)
Permission denied         →  App explains + deep-links to OS
Permission granted        →  App resumes product preference behavior
```

Settings must never pretend the app can grant what only the OS can grant.

---

# 5. Entry & Exit Rules

## Entry

| Rule | Meaning |
|------|---------|
| **Secondary entry** | Settings is reachable but not a primary journey stop |
| **Utility framing** | Entry is for a job (adjust / trust / help), not for presence |
| **Not on Welcome as meaning** | Must not participate in product introduction |
| **Not inside My Rhythms IA** | Separate surface (DR-018) |
| **Recoverable from friction** | Create / notification friction may deep-link toward Settings or OS |

Exact chrome placement is a UI Spec concern. Architecture only requires: **discoverable, secondary, non-journey**.

## Exit

| Rule | Meaning |
|------|---------|
| **Quiet Exit** | Leaving is success; no completion theater |
| **Return to prior context** | Typically Today or the utility surface that led here |
| **No sticky exploration** | No “while you’re here” promos or tutorials |

## Must Settings ever interrupt the rhythm journey?

**No — not as a forced destination.**

Allowed:

- Optional recovery prompts when a user action requires permission the OS has denied  
- User-initiated entry from secondary chrome  

Forbidden:

- Blocking Today to tour Settings  
- Post-create graduation into Settings  
- Automatic Settings presentation as onboarding  

## Must Settings ever become a destination?

**No.**

Settings is a **stop**, not a place to stay. Architecture treats habitual Settings use as a product smell (Keep Me Out).

---

# 6. Future Extensibility

## Principle — Earn Sections

Do **not** create empty future sections.

A new Settings section or item is admitted only when:

1. A real user-controlled preference exists (not speculative), and  
2. It is **not** owned by Today / My Rhythms / Create / Welcome, and  
3. It is **not** an OS responsibility (OS Owns the OS), and  
4. It passes Product Principles: necessary, reduces or protects calm presence, does not invite configuration culture.

## Future candidates

| Candidate | Admission rule |
|-----------|----------------|
| **Widget preferences** | Only true product choices beyond architecture defaults; stay utility, not Widget marketing |
| **Apple Watch** | Same — consume shared schedule; no Watch control-panel identity |
| **Siri & Shortcuts** | Exposure / links OK; not an automation IDE inside Settings |
| **iCloud Sync** | Admit under Data & Sync only when sync is a real product feature |
| **Backup / Restore** | Same as sync — earned, not decorative |
| **Appearance** | Only if product-level appearance control is required; must not become brand playground or second Welcome. Prefer OS Appearance when sufficient. |

## Compatibility statement

Settings Architecture scales by **remaining sparse**.

Platform expansion (Widget, Watch, Shortcuts) must continue to **consume** Snapshot / Schedule / Notification architecture (DR-014) — Settings may expose limited preferences; it must not redefine those domains.

---

# 7. Non-goals

Settings must **never** become:

| Anti-pattern | Why forbidden |
|--------------|---------------|
| **Dashboard** | Competes with calm; invites overview identity |
| **Marketing surface** | Utility must not acquire users or upsell |
| **Tutorial center** | Presence over explanation; Welcome already introduced meaning |
| **Analytics / statistics center** | ADR-011 / no competitive scoring identity |
| **Productivity console** | Violates presence-first product identity |
| **Feature discovery hub** | Sticky exploration; Quiet Exit fails |
| **Brand philosophy room** | Welcome / Brand own meaning (DR-017) |
| **Social / sharing hub** | Non-presence, promotional energy |
| **Gamification board** | Brand forbids competitive feeling |
| **Rhythm management dump** | My Rhythms + Create ownership |
| **OS Settings clone** | OS Owns the OS |

---

# 8. Architectural Principles (normative)

1. **Keep Me Out** — Design so most users rarely need Settings.  
2. **Utilities Only** — Preferences, trust, support, app identity only.  
3. **Quiet Exit** — Success is leaving calmly.  
4. **Reduce Configuration** — Prefer defaults; admit prefs sparingly.  
5. **Separate from the Collection** — Never merge into My Rhythms.  
6. **Plain Voice** — Utility-plain language; no brand performance (DR-017).  
7. **OS Owns the OS** — Explain and deep-link; do not duplicate.  
8. **Earn Sections** — No empty future rooms.

### Guiding question

> Does this decision help the user adjust support around today’s rhythm — then return to presence — without inviting them to live inside Settings?

If the answer is no, it does not belong in Settings Architecture.

---

# 9. Final Architecture Decision

## Decision

Settings is OneulRhythm’s **quiet support utility**.

1. **Purpose** — Support preferences, trust, and help; not live or own rhythms.  
2. **Class** — Utility Surface; outside the primary rhythm journey.  
3. **Ownership** — Notifications (product), Support, About/Legal/Version; nothing owned by Today / Welcome / My Rhythms / Create.  
4. **OS boundary** — OS Owns the OS; App owns product prefs + deep-link recovery.  
5. **Entry / Exit** — Secondary entry; Quiet Exit; never forced journey interrupt; never a destination.  
6. **IA** — MVP groups: Notifications · Support · About.  
7. **Future** — Earn Sections; platform prefs stay sparse utilities.  
8. **Brand** — No Breath Flow hero; no Welcome philosophy.

## Implementation guidance (for later developers)

- Treat Settings as a **separate utility route**, not a My Rhythms subsection.  
- Prefer **deep links to OS Settings** for permission and system presentation.  
- Keep **per-rhythm Configure** on Create/Edit; keep **app-wide support prefs** in Settings — UI Spec must not double-own the same control without an explicit rule.  
- Do not add marketing, tips, stats, or brand essays.  
- Do not pre-create empty sections for Widget / Watch / Sync / Appearance.  
- Measure success by **rarity of visits** and **speed of exit**, not engagement time.

## Non-goals of this document

- UI layout, cells, icons, typography, color  
- Exact string locks  
- SwiftUI structure  
- Notification pipeline redesign  
- Widget / Watch implementation  

---

# Relationship to Existing Authority

| Authority | Relationship |
|-----------|--------------|
| `PRODUCT-PRINCIPLES.md` | Less input; calm; reduce configuration; consistency across surfaces |
| `BRAND.md` / DR-017 | Utility mark absence; plain voice; Settings as Utility |
| DR-018 | Settings separate from My Rhythms; preferences ≠ collection |
| DR-019 | System prefs out of Capture; deep links OK for permission recovery |
| DR-014 | Platform surfaces consume existing architecture; Settings must not redefine them |
| DR-015 | No Welcome reprise via Settings |
| Sprint 15-6A Review | Product purpose / principles / scope basis |

---

# Out of Scope

- Visual redesign beyond the approved Settings UI Specification  
- Exact preference schemas and storage keys (implementation detail)  
- OS entitlement / privacy nutrition details beyond ownership  
- Settings Implementation code (Sprint 15-6D)  

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`
- `Docs/Architecture/Decisions/DR-018-my-rhythms.md`
- `Docs/Architecture/Decisions/DR-019-create-rhythm.md`
- `Docs/Architecture/Decisions/DR-020-settings.md`
- `Docs/Product/Settings-UI-Specification.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/My-Rhythms-Architecture.md`
- `Docs/Product/Create-Rhythm-Architecture.md`

---

One rhythm at a time.

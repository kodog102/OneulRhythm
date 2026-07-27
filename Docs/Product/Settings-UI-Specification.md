# Settings UI Specification

This document defines the implementation-ready UI contract for the Settings experience.

It translates the approved Settings Architecture (`Docs/Product/Settings-Architecture.md` / DR-020) into concrete presentation behavior.

It does not redefine product philosophy, Brand Integration, My Rhythms, Create, or notification scheduling logic.

**Status:** Implementation-ready UI contract.  
**Architecture authority:** `Settings-Architecture.md` / DR-020.  
**Basis:** Sprint 15-6A Experience Review; Sprint 15-6B Architecture Decision.

---

# Purpose

Provide a single UI contract for:

- Today entry into Settings  
- Navigation chrome  
- Section hierarchy (Notifications · Support · About)  
- Row types and One Decision Per Row  
- Notification product vs OS presentation  
- Support and About rows  
- Language, motion, accessibility  
- Visual philosophy  

Whenever ambiguity exists:

1. `Settings-Architecture.md` (DR-020)  
2. This Specification  
3. Engineering implementation  

Exact mail addresses, policy URLs, and license document sources may be supplied by engineering / legal at implementation time. **Row roles and copy locks in this document remain binding.**

---

# Surface Class

| Rule | Requirement |
|------|-------------|
| Brand mark | No Breath Flow hero |
| Welcome philosophy | Never shown |
| Celebration | Never |
| Marketing / tips | Never |
| Background | Today calm cream field (utility token continuity) |
| Chrome | Utility only — first-party Settings feel |
| Destination energy | Forbidden — Quiet Exit is success |

---

# Relationship to Other Surfaces

| Concern | Authority |
|---------|-----------|
| Settings purpose / OS boundary | DR-020 / Settings Architecture |
| Today primary focus | `Today-UI-Specification.md` — entry must not compete |
| My Rhythms entry | `My-Rhythms-UI-Specification.md` — Settings is **not** inside My Rhythms |
| Per-rhythm reminder Configure | `Create-Rhythm-UI-Specification.md` — not duplicated as Settings Capture |
| Welcome | DR-015 — Settings entry hidden on Welcome |

### Create vs Settings reminder ownership (locked for UI)

| Control | Surface |
|---------|---------|
| Reminder on / off **for one rhythm** | Create / Edit Configure |
| App-wide reminder preference (if present) | Settings → Notifications |
| OS notification permission / presentation | OS (deep-link from Settings or Create recovery) |

Do not show the same toggle in both Create and Settings. Create may prompt and deep-link out when permission is denied; it must not embed the Settings Notifications section.

---

# 1. Entry UI Contract

## Placement

- Today toolbar — **secondary chrome only**  
- Separate from My Rhythms entry  
- Visible only when First Journey is complete (same lifecycle gate as My Rhythms)  
- Hidden on Welcome  

## Recommended control

| Concern | Contract |
|---------|----------|
| Visible control | System gear SF Symbol (`gearshape`) — quiet utility glyph |
| Placement | Leading toolbar (keeps trailing clear for `내 리듬`) |
| Tint | Secondary / toolbar weight — never primary filled button |
| Competition | Must never outrank Today’s primary rhythm title or My Rhythms entry clarity |

If a text label is used instead of a symbol, use `설정` at caption-level secondary weight. Prefer the gear for Keep Me Out (less journey language on Today).

## Accessibility

| Trait | Copy |
|-------|------|
| Label | `설정` |
| Hint | `앱 설정을 엽니다` |

## Interaction

- Single tap **pushes** Settings  
- No long-press menu  
- Never auto-presents Settings after create, launch, or Welcome  

## Confirmation

Entry remains secondary utility chrome.

It must never read as a primary journey stop.

---

# 2. Navigation Contract

## Screen title

```text
설정
```

Inline navigation title (`inline` display mode).

## Toolbar

| Item | Placement | Behavior |
|------|-----------|----------|
| System Back | Leading (system) | Pops Settings — Quiet Exit |
| Trailing actions | **None** | No Done, Save, Edit, or Share |

### Done button

| Presentation | Rule |
|--------------|------|
| Standard push from Today | **No Done** — Back is enough |
| If ever presented as a modal sheet (not preferred) | System `닫기` / `완료` dismiss only — never a branded CTA |

Preferred presentation: **push** on the existing navigation stack (utility, Quiet Exit via Back).

## How Settings communicates secondary utility

| Signal | Requirement |
|--------|-------------|
| Title | Plain `설정` — no subtitle, tagline, or brand line |
| Chrome | System back only; empty trailing |
| Content | Sparse grouped list; few rows |
| Mark | No Breath Flow |
| Density | First-party iOS Settings density — not a branded landing |
| Hero | **None** — preference groups are content, not emotional center |

Navigation remains utility chrome. It must never become a Welcome or Today experience.

---

# 3. Information Hierarchy

## Locked sections (order)

```text
1. 알림
2. 지원
3. 정보
```

English product names remain Notifications · Support · About.  
**Visible Korean section headers:**

| Section | Header |
|---------|--------|
| Notifications | `알림` |
| Support | `지원` |
| About | `정보` |

Do **not** introduce additional sections (Earn Sections / DR-020).

## Visual hierarchy

```text
Navigation title (chrome)
        ↓
Section headers (quiet grouping)
        ↓
Row primary labels (content)
        ↓
Secondary values / chevrons / toggles (tertiary)
```

No screen-level hero. No header illustration. No marketing banner above the list.

## Spacing & emphasis

| Rule | Requirement |
|------|-------------|
| Section order | Fixed: 알림 → 지원 → 정보 |
| Relative emphasis | All sections equal weight — About must not shout; Notifications must not become a dashboard |
| Inter-section spacing | System grouped-list spacing |
| Intra-section | System row spacing only |
| Extra decorative whitespace | Avoid large branded breathing compositions — Keep Me Out prefers compact utility |

## Grouping rules

- One `List` / grouped inset style for the whole screen  
- Each architecture section = one list section  
- Rows only inside their owning section  
- No cross-section composite cards  

---

# 4. Row Presentation

## Principle — One Decision Per Row

Each row represents **exactly one** user decision or destination.

| Allowed | Forbidden |
|---------|-----------|
| One label + optional secondary value | Toggle + chevron on the same row |
| One toggle | Multiple toggles |
| One disclosure destination | Embedded multi-field editors |
| One external action | Inline forms spanning several controls |

## Standard row anatomy

| Element | Role | Rules |
|---------|------|-------|
| **Leading icon** | Optional, quiet | SF Symbol only; monochrome secondary; **not required** on every row. Prefer **no icons** unless they improve scannability without decoration. If used, one consistent size/weight across the screen. |
| **Primary label** | Required | Plain utility Korean; body emphasis |
| **Secondary value** | Optional | Trailing text for status / static info (e.g. version, `허용 필요`) |
| **Chevron** | Disclosure only | System disclosure indicator; VoiceOver-decorative (`accessibilityHidden`) when the row is the button |
| **Toggle** | Binary preference only | System toggle; never combined with chevron |
| **Disclosure** | Navigation / external | Tap opens push, sheet, or OS / URL |

## Row types

| Type | Affordance | Use |
|------|------------|-----|
| **Preference (toggle)** | Toggle | App-owned binary preference |
| **Status + recovery** | Secondary value + optional disclosure | Reflect OS state; recover via deep-link |
| **Destination (in-app)** | Chevron | Push to in-app document (e.g. licenses) |
| **External** | Chevron (or none) | Opens Mail / Safari / OS Settings |
| **Information** | Secondary value only | Static display (version) — **not** tappable |

## Leading icons

| Decision | Contract |
|----------|----------|
| Default | **No leading icons** (calm, Keep Me Out, less decoration) |
| If product later adds icons | SF Symbols only; never emoji; never Breath Flow |

---

# 5. Notification Presentation

Section header: `알림`

## Product preference vs system configuration

| Kind | Owner | UI pattern |
|------|-------|------------|
| App reminder preference | App | Toggle row |
| Notification permission / presentation | OS | Disclosure / recovery row — **not** a fake permission toggle |

The UI must make this distinction legible:

- Product rows use **toggles** (app can change the value now).  
- System rows use **disclosure** (leaves the app or opens OS).  
- Never present an in-app toggle that claims to grant OS permission.

## Rows (MVP)

### Row A — App reminder preference

| Element | Contract |
|---------|----------|
| Type | Preference (toggle) |
| Primary label | `리마인더` |
| Secondary | None while enabled/disabled normally |
| Behavior | Toggles whether OneulRhythm attempts product reminders (within OS permission) |

When OS permission is **denied**, do **not** silently pretend the preference is fully active:

| State | Presentation |
|-------|--------------|
| Permission denied | Toggle may remain visible but preference is ineffective until OS allows; show recovery (Row B). Prefer keeping toggle enabled-state honest — if product cannot notify, secondary on Row B carries the truth. |
| Permission authorized | Toggle controls product preference only |

Do not invent extra educational paragraphs under the toggle.

### Row B — System notification settings (OS)

| Element | Contract |
|---------|----------|
| Type | External / OS disclosure |
| Primary label | `시스템 알림 설정` |
| Secondary value | Optional status: `허용됨` / `꺼짐` / `허용 필요` (derived from OS authorization — plain, short) |
| Chevron | Yes |
| Behavior | Opens the relevant **iOS Settings** notification pane for OneulRhythm (`openNotificationSettings` or equivalent) |

### Permission recovery (natural deep-link)

| Moment | UI |
|--------|-----|
| On this screen | Row B always available; secondary value surfaces need when denied |
| From Create friction | Existing Create alert may deep-link to OS Settings directly — need not bounce through Settings first |
| Copy tone | Utility only — never “unlock your full experience” |

### Forbidden in 알림

| Forbidden | Why |
|-----------|-----|
| Banner style / sound / Lock Screen pickers | OS Owns the OS |
| Focus Mode controls | OS |
| Per-rhythm reminder list | Create / My Rhythms ownership |
| Marketing “enable notifications” hero | Quiet Exit / Keep Me Out |
| Duplicate Create reminder toggle | Ownership lock |

---

# 6. Support Presentation

Section header: `지원`

## Rows

### Feedback

| Element | Contract |
|---------|----------|
| Type | External destination |
| Primary label | `피드백` |
| Secondary | None |
| Chevron | Yes |
| Behavior | Opens Mail (or equivalent) with a feedback intent |

### Contact

| Element | Contract |
|---------|----------|
| Type | External destination |
| Primary label | `문의` |
| Secondary | None |
| Chevron | Yes |
| Behavior | Opens Mail (or equivalent) with a contact intent |

## Presentation rules

| Question | Answer |
|----------|--------|
| Should Feedback and Contact look identical? | **Yes** — same row type, weight, and chevron treatment. Difference is label + destination only. |
| Destructive styling? | **Never** — neither is destructive. |
| Email vs web different treatment? | **No visual dialect.** Both use the same disclosure row. Accessibility must announce that the action opens mail or the browser as appropriate. |

### Forbidden in 지원

- Rating prompts / App Store review nags as Settings content  
- FAQ tutorial centers  
- Chat widgets or promotional help banners  
- Social links  

---

# 7. About Presentation

Section header: `정보`

Keep this section **visually quiet** — equal to other sections, never a brand closing statement.

## Rows

### Version

| Element | Contract |
|---------|----------|
| Type | Information (static) |
| Primary label | `버전` |
| Secondary value | Marketing version string (e.g. `1.0.0`) — build number optional as quieter secondary if needed |
| Chevron | **No** |
| Tappable | **No** |

### Privacy

| Element | Contract |
|---------|----------|
| Type | Destination (in-app push or Safari — product choice OK if consistent) |
| Primary label | `개인정보 처리방침` |
| Chevron | Yes |

### Terms

| Element | Contract |
|---------|----------|
| Type | Destination |
| Primary label | `이용약관` |
| Chevron | Yes |

### Open Source Licenses

| Element | Contract |
|---------|----------|
| Type | In-app disclosure (preferred) |
| Primary label | `오픈 소스 라이선스` |
| Chevron | Yes |
| Behavior | Pushes a plain license list / text screen — utility document, not branded story |

## Row classification summary

| Row | Pattern |
|-----|---------|
| 버전 | Information / static value |
| 개인정보 처리방침 | Disclosure (doc or link) |
| 이용약관 | Disclosure (doc or link) |
| 오픈 소스 라이선스 | Disclosure (in-app) |

### Forbidden in 정보

- Breath Flow, taglines, “One rhythm at a time”  
- Release notes marketing  
- Social / share sheet as About identity  
- Credits poetry beyond license requirements  

---

# 8. Language Contract

## Voice

| Required | Forbidden |
|----------|-----------|
| Plain utility Korean | Marketing slogans |
| Short labels | Welcome philosophy |
| Neutral status words | Celebration / graduation |
| System-adjacent wording | Checklist / score language |

Settings must **never** sound like Welcome.

## Locked visible strings

### Chrome & entry

| Location | String |
|----------|--------|
| Nav title | `설정` |
| Entry a11y label | `설정` |
| Entry a11y hint | `앱 설정을 엽니다` |

### Section headers

| Section | String |
|---------|--------|
| Notifications | `알림` |
| Support | `지원` |
| About | `정보` |

### Notification rows

| Row | String |
|-----|--------|
| App preference | `리마인더` |
| OS disclosure | `시스템 알림 설정` |
| Status (examples) | `허용됨` / `꺼짐` / `허용 필요` |

### Support rows

| Row | String |
|-----|--------|
| Feedback | `피드백` |
| Contact | `문의` |

### About rows

| Row | String |
|-----|--------|
| Version | `버전` |
| Privacy | `개인정보 처리방침` |
| Terms | `이용약관` |
| Licenses | `오픈 소스 라이선스` |

## Forbidden language examples

| Forbidden | Why |
|-----------|-----|
| `오늘 리듬을 더 잘 느껴보세요` | Welcome / marketing |
| `알림을 켜고 여정을 완성하세요` | Journey / completion pressure |
| `피드백을 보내 주셔서 감사해요` as a Settings hero | Celebration tone |
| `원울리듬은…` brand essays | Wrong surface |

---

# 9. Motion Contract

| Moment | Motion |
|--------|--------|
| Today → Settings push | Standard system navigation transition |
| Settings → Back (Quiet Exit) | Standard system pop |
| In-app disclosure push (licenses / policy) | Standard system push |
| Toggle | System toggle animation only |
| OS / Mail / Safari handoff | System handoff — no custom bridge animation |
| Reduce Motion | Honor system; no added content motion |

## Forbidden motion

- Custom branded transitions  
- Breath Flow / gentle-scale hero moments  
- Bounce, overshoot, flash  
- Success confetti or “saved” flourishes on toggle  

Motion confirms utility only. Quiet Exit needs no ceremony.

---

# 10. Accessibility Contract

Settings should behave like a **first-party iOS Settings** screen.

## VoiceOver order

1. Screen title `설정`  
2. Section `알림` → rows top to bottom  
3. Section `지원` → rows  
4. Section `정보` → rows  

## Row labeling

| Row kind | Label pattern |
|----------|---------------|
| Toggle | Label = primary (`리마인더`); value = On/Off via toggle traits |
| Disclosure | Label = primary; hint describes destination (`시스템 설정에서 알림을 변경합니다`, `메일을 엽니다`, `문서를 엽니다`) |
| Information | Label = primary + secondary value (`버전, 1.0.0`) |
| Chevron | `accessibilityHidden` when row is the control |

## External / OS announcements

| Action | Announce |
|--------|----------|
| OS Settings | Hint that system Settings opens |
| Mail | Hint that Mail opens |
| Safari / web | Hint that browser opens |

## Dynamic Type

- Labels and section headers reflow  
- Secondary values may truncate with middle/tail truncation only if unavoidable — prefer wrapping where system grouped lists allow  
- Hierarchy Primary > Secondary survives large content sizes  

## Touch targets

- System list row height / minimum touch expectations  
- Toggles use system control sizing  

## SF Symbols

- If gear entry or any leading icons: standard template rendering; VoiceOver uses text labels above, not symbol names alone  

## Confirmation

No custom accessibility theater. Prefer system traits (`button`, `switch`, headers).

---

# 11. Empty States

## Decision

**Settings must not use catalog-style empty states.**

| Why | Explanation |
|-----|-------------|
| Fixed IA | Notifications · Support · About always have defined rows |
| Not a collection | Unlike My Rhythms, there is no “no items yet” shelf |
| Keep Me Out | Empty illustrations would invite brand/Welcome energy |

## What is not an empty state

| Situation | Treatment |
|-----------|-----------|
| OS permission denied | Status secondary + OS disclosure row — **populated** recovery UI |
| Mail unavailable | System inability handling / alert — not an empty Settings screen |
| Missing version string | Engineering defect — show placeholder only if unavoidable (`—`) |

Do not design an empty Settings composition.

---

# 12. Visual Philosophy

## Preferred container

| Prefer | Avoid |
|--------|-------|
| **Grouped inset list** (system Settings idiom) | Custom card stacks as brand surfaces |
| System separators within sections | Hand-drawn rules / newspaper density |
| Cream field continuity behind list | Decorative gradients / hero imagery |
| Compact utility density | Large Welcome-like whitespace compositions |

## Cards

**Default: no custom cards.**

Grouped list sections already provide containment. Extra card chrome around the whole screen is unnecessary and risks dashboard energy.

## Separators

Remain via **system grouped list** separators. Do not invent custom divider art.

## Whitespace

| Amount | Guidance |
|--------|----------|
| Appropriate | System section spacing + calm cream margins |
| Too little | Crowded preference console |
| Too much | Branded landing / Keep Me Out failure |

## Reinforcement of principles

| Principle | Visual consequence |
|-----------|-------------------|
| Keep Me Out | Few rows; no discovery modules |
| Utilities Only | Grouped list; plain labels; no philosophy |
| Quiet Exit | Back-only chrome; no sticky footer CTA |

---

# 13. Final UI Decision

## Decision

Settings presents as a **sparse, first-party grouped Settings screen** titled `설정`.

1. **Entry** — Today secondary gear (or quiet `설정`); hidden on Welcome; push navigation.  
2. **Chrome** — Inline `설정`; system Back; no trailing actions.  
3. **Sections** — `알림` → `지원` → `정보` only.  
4. **Rows** — One Decision Per Row; default no leading icons.  
5. **Notifications** — `리마인더` toggle (app) + `시스템 알림 설정` disclosure (OS).  
6. **Support** — Identical `피드백` / `문의` disclosure rows; never destructive.  
7. **About** — Static `버전`; disclosure legal / licenses; visually quiet.  
8. **Language** — Plain utility Korean; never Welcome.  
9. **Motion** — System only.  
10. **A11y** — First-party Settings behavior.  
11. **Empty** — None.  
12. **Visual** — Grouped inset list; no custom cards; no Breath Flow.

## Guiding question

> Does this UI help the user adjust support or check trust — then leave — without feeling like a destination, Welcome, or control panel?

If the answer is no, it does not belong in this Specification.

---

# Out of Scope

- SwiftUI structure and binding  
- Preference persistence schema  
- Notification Plan / scheduling algorithms  
- Legal document content  
- Exact support email addresses / URLs (wiring only)  
- Future Earn Sections UI  

---

# Related Documents

- `Docs/Product/Settings-Architecture.md`
- `Docs/Architecture/Decisions/DR-020-settings.md`
- `Docs/Product/Brand-Integration-Architecture.md`
- `Docs/Product/My-Rhythms-UI-Specification.md`
- `Docs/Product/Create-Rhythm-UI-Specification.md`
- `Docs/Product/Today-UI-Specification.md`
- `Docs/Product/PRODUCT-PRINCIPLES.md`
- `Docs/BRAND.md`

---

One rhythm at a time.

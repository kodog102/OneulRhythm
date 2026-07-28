# Visual Language Specification

This document captures the visual language already expressed in OneulRhythm.

It is a **Design System contract** for future implementation.

It does **not** redesign screens, invent new tokens, or replace Product / Brand / Decision authority.

**Status:** Active  
**Basis:** Shipping Design System (`OneulRhythm/DesignSystem/`), Brand Integration (DR-017), Warm Light Appearance (DR-021), and surface UI as implemented.  
**Appearance policy:** Warm Light only (DR-021).

---

# Authority Order

When visual questions arise:

1. `Docs/Product/PRODUCT-PRINCIPLES.md`  
2. `Docs/BRAND.md` + Brand ADRs  
3. Architecture Decision Records (especially DR-017, DR-021)  
4. **This specification** (how the language is applied in UI)  
5. Surface UI Specifications (layout / copy contracts)  
6. Design System code (`ORColors`, `ORTypography`, `ORSpacing`, `ORRadius`, `ORCardStyle`)

The Hero image (`Assets/hero/hero.png`) is marketing atmosphere only. It is not a UI contract (DR-021).

---

# 1. Design Philosophy

OneulRhythm’s visual language exists to support **today’s rhythm**, not productivity theater.

Grounded principles (from Product Principles, Brand, and shipping UI):

### Calm over productivity

Surfaces stay warm, soft, and unhurried. Visual energy never pushes urgency, competition, or scorekeeping.

### One focus at a time

Every primary screen has one emotional center. Secondary information stays quieter than the hero (Brand: One Primary Focus; DR-008 / DR-009).

### Quiet confidence

Hierarchy comes from space, type weight, and soft elevation — not decoration, neon accent, or stacked chrome.

### Brand enters, then steps aside

Breath Flow introduces the product on Identity surfaces. After the first rhythm begins, the user’s rhythm is the hero (DR-017).

### Presence before information density

Whitespace is intentional. Empty regions are part of the rhythm, not unfinished layout. Prefer fewer elements that read clearly over dense operational dashboards.

### Warm Light continuity

The product presents a single Warm Cream + Sage field. Mixed system-driven light/dark presentation is a defect (DR-021).

---

# 2. Surface Hierarchy

Visual surfaces in the product fall into four levels. Higher levels carry more emotional weight; lower levels stay operational and quiet.

## Level 1 — Primary Surface

| | |
|--|--|
| **Purpose** | The atmospheric field of the day — the calm cream ground everything sits on. |
| **Visual weight** | Full-bleed; lowest chroma; defines Warm Light. |
| **Token** | `ORColors.background` (approx. warm cream `rgb(0.97, 0.95, 0.91)`). |
| **Where used** | Launch field, Today / Welcome scroll background, Create background, My Rhythms background, Settings page background, Live Activity Lock Screen tint (aligned cream). |
| **Where not used** | As a “card” fill competing with content; as a Dark Mode adaptive fill. |

## Level 2 — Secondary Surface

| | |
|--|--|
| **Purpose** | Elevate the one thing that deserves attention — a soft resting place for primary content. |
| **Visual weight** | Near-white card fill + quiet shadow; stronger than the field, still soft. |
| **Token / style** | `ORColors.card` + `.orCard()` (`ORRadius.lg`, `ORColors.cardShadow`). |
| **Where used** | Today Primary Rhythm card; Create **Capture** block (name + start). |
| **Where not used** | Welcome philosophy; next-rhythm preview; Settings rows as branded theater; every list cell by default. |

## Level 3 — Quiet Surface

| | |
|--|--|
| **Purpose** | Hold secondary structure without competing with Level 2. |
| **Visual weight** | Softened card or open text; little or no elevation. |
| **Expression today** | Create **Configure** blocks: `ORColors.card.opacity(0.72)`, same large radius, **no** card shadow; Welcome philosophy as open text on the Primary Surface; next rhythm as caption stack without a card. |
| **Where used** | Configure / advanced form regions; supporting orientation under a hero. |
| **Where not used** | As the emotional center of Today or Welcome. |

## Level 4 — Utility Surface

| | |
|--|--|
| **Purpose** | Clear operational reading — manage, configure preferences, trust copy. |
| **Visual weight** | Plain; mark-free; still Warm Light. |
| **Expression today** | My Rhythms name-first floating cards on softened atmosphere; Settings inset-grouped list on cream page background; system light chrome under Warm Light lock. |
| **Where used** | My Rhythms, Settings, Settings document pages, destructive confirmations (system roles). |
| **Where not used** | Product introduction; Today hero; Launch meaning. |

---

# 3. Card Hierarchy

Cards are used sparingly. If removing fill, shadow, or radius does not hurt understanding, it should not be a card (Brand Integration + shipping Today).

## Primary Rhythm Card

| Property | Current language |
|----------|------------------|
| **Role** | Emotional center of Active Today — rhythm title is the hero. |
| **Elevation** | Full `.orCard()` shadow. |
| **Radius** | `ORRadius.lg` (24), continuous. |
| **Shadow** | `ORColors.cardShadow`, radius 10, y: 4. |
| **Spacing** | `ORSpacing.cardPadding` (24) inside; large title → caption time → acknowledgment button. |
| **Priority** | Highest content surface on Today. |

## Secondary Card

| Property | Current language |
|----------|------------------|
| **Role** | Today does **not** elevate “다음 리듬” into a second card. |
| **Expression** | Caption-level open text under the primary card (`ORColors.textTertiary` / `textSecondary`). |
| **Priority** | Orientation only — never a second focus. |

Treat “Secondary Card” as a **reserved name** for future glance surfaces only if they remain quieter than Primary. Do not invent a competing card on Today.

## Capture Card

| Property | Current language |
|----------|------------------|
| **Role** | Create’s strongest form region — identity + start time (DR-019). |
| **Elevation** | Full `.orCard()`. |
| **Radius / shadow** | Same as Primary Rhythm Card. |
| **Spacing** | `ORSpacing.cardPadding`; internal divider uses `ORColors.divider`. |
| **Priority** | Highest surface on Create; Configure sits below. |

## Configuration Surface

| Property | Current language |
|----------|------------------|
| **Role** | End time, category, recurrence, reminder — secondary structure. |
| **Elevation** | **None** (no `.orCard()` shadow). |
| **Fill** | `ORColors.card.opacity(0.72)`. |
| **Radius** | `ORRadius.lg` continuous. |
| **Priority** | Visually quieter than Capture. |

## Empty Invitation

| Property | Current language |
|----------|------------------|
| **Role** | Normal Empty path to create — invitation, not Welcome reprise (DR-015). |
| **Elevation** | None. |
| **Fill** | None — dashed stroke only (`ORColors.divider`, dash pattern, `ORRadius.lg`). |
| **Accent** | Plus + label in sage / secondary text (`AddRoutineCardView`). |
| **Priority** | Soft call-to-action; never Breath Flow hero. |

Welcome First Journey intentionally uses **no card** for philosophy — open text on the Primary Surface.

---

# 4. Color Usage

Source of truth: `OneulRhythm/DesignSystem/ORColors.swift`.  
Do not introduce new palette entries in this specification.

| Role | Token | Usage in product |
|------|-------|------------------|
| **Background** | `background` | Warm Light atmospheric field for screens and Launch continuity. |
| **Surface** | `card` | Elevated content surfaces (Primary / Capture). Quieter Configure uses `card` at reduced opacity. |
| **Primary** | `primary` | Restrained sage — primary buttons, selected chips, progress fill, toggle tint, quiet accents. |
| **Primary muted** | `primaryMuted` | Soft selected/unselected chip grounds; progress track. |
| **Primary emphasis** | `primaryEmphasis` | Available sage emphasis (slightly softened primary). |
| **Secondary (action soft)** | — | No separate “secondary brand color.” Secondary hierarchy is carried by **text** tokens and quieter surfaces. |
| **Divider** | `divider` | Hairlines, dashed empty invitation, list separators (Management). |
| **Text primary** | `textPrimary` | Titles, hero meaning, primary labels. |
| **Text secondary** | `textSecondary` | Supporting body, atmosphere date-weight peers, section labels. |
| **Text tertiary** | `textTertiary` | Time, quiet meta, chevrons, progress count. |
| **Shadow** | `cardShadow` | Only with elevated `.orCard()` language. |

### Success

No dedicated success color token exists. Completion is **acknowledgment** (`이어냈어요` on sage primary buttons) — not green-check celebration chrome.

### Warning

No dedicated warning color token exists in `ORColors`.

### Error

No dedicated error color token exists in `ORColors`. Load/error copy uses `textSecondary` on the cream field. Destructive actions use system destructive roles (e.g. delete) without a custom error palette.

### Fixed contrast

White label text on sage primary buttons is intentional fixed contrast, not an adaptive semantic color.

---

# 5. Typography

Source of truth: `OneulRhythm/DesignSystem/ORTypography.swift` via `.orTypography(_:)`.

Map the shipping styles to the reading hierarchy below. Do not redesign type.

| Spec name | Shipping style | System mapping | Default weight | Use |
|-----------|----------------|----------------|----------------|-----|
| **Display** | `.largeTitle` | System largeTitle, **rounded**, semibold; lineSpacing 7 | Semibold | Welcome Hero Meaning; Primary Rhythm title — the loudest type. |
| **Title** | `.title` | System title2, **rounded**, semibold; lineSpacing 4 | Semibold | Day Complete / empty invitations; Capture name field; section-scale statements. |
| **Body** | `.body` | System body, default design, regular; lineSpacing 3 | Regular | Philosophy, form body, primary button labels (often semibold override), management titles. |
| **Caption** | `.caption` | System subheadline, default design, regular; lineSpacing 2; tracking 0.2 | Regular | Time, next rhythm, section labels (`ORSectionLabel` uses caption + medium), toolbar “내 리듬”, progress count. |

### Usage rules

- Rounded design is reserved for **Display** and **Title** — presence and softness at hero scale.  
- Body and Caption stay default design for calm readability in longer and utility text.  
- Do not introduce a fifth product type style without updating this specification and `ORTypography`.

---

# 6. Spacing

Source of truth: `OneulRhythm/DesignSystem/ORSpacing.swift`.

### Scale

| Token | Value |
|-------|------:|
| `xxs` | 4 |
| `xs` | 8 |
| `sm` | 12 |
| `md` | 16 |
| `lg` | 24 |
| `xl` | 32 |
| `xxl` | 40 |
| `xxxl` | 48 |

### Layout constants

| Token | Value | Role |
|-------|------:|------|
| `screenHorizontal` | 24 | Screen side inset |
| `screenTop` | 24 | Top safe padding on Today |
| `cardPadding` | 24 | Inner padding for elevated cards |
| `cardContentGap` | 18 | Internal card rhythm |
| `sectionGap` | 28 | Between major vertical sections |
| `scrollBottom` | 48 | Scroll breathing room |
| `primaryButtonHeight` | 48 | Primary CTA height |
| `progressBarHeight` | 6 | Quiet orientation bar only |

### Rhythm

Spacing grows toward calm: tighter (`xxs`–`sm`) for related meta; `md`–`lg` for component grouping; `xl`–`xxxl` when Identity / Experience surfaces need air (e.g. Welcome mark → meaning → CTA). Do not collapse Welcome or Today into dense forms to “fill” the screen.

---

# 7. Corner Radius

Source of truth: `OneulRhythm/DesignSystem/ORRadius.swift`.  
Soft continuous geometry — do not invent additional product radii.

| Token | Value | Typical use |
|-------|------:|-------------|
| `sm` | 12 | Smaller soft controls when needed |
| `md` | 16 | Chip / compact soft shapes (e.g. category chips) |
| `button` | 20 | Primary buttons |
| `lg` | 24 | Cards, empty invitation outline, Configure clips |
| `xl` | 28 | Largest soft containers when required |

Prefer `.continuous` rounded rectangles to match the shipping card language.

---

# 8. Shadow

### Existing shadow

Defined only through elevated card language:

- Color: `ORColors.cardShadow` (`Color.black.opacity(0.03)`)  
- Radius: **10**  
- Offset: **(0, 4)**  
- Applied by: `.orCard()` / `ORCardStyle`

Management section chrome reuses the same soft shadow language on the **first row** of a connected section only — not a second shadow system.

### Where shadows disappear

- Welcome (no cards)  
- Empty Invitation (stroke only)  
- Configure surfaces (fill, no shadow)  
- Next-rhythm preview (open text)  
- Settings inset-grouped system rows (no custom product shadow)  
- Live Activity Lock Screen / Island (platform chrome; no `.orCard()` shadow)

Shadows never become multi-layer glow or dramatic depth.

---

# 9. Brand Presence

Breath Flow (Brand Lock E10) is the only primary brand mark (ADR-010).

### Allowed (Identity / platform presence)

| Surface | Role |
|---------|------|
| **App Icon** | Identity |
| **Launch** | Quiet centered Presence — no meaning copy (DR-016) |
| **Welcome** | Meaning — mark supports Hero Meaning (DR-015) |
| **Live Activity** | Quiet mark when a mark is needed — never a competing hero |

### Not normally used

| Surface | Why |
|---------|-----|
| **Today Active / Day Complete / Normal Empty** | User’s rhythm (or quiet invitation) is the hero — mark must not compete (DR-017) |
| **My Rhythms / Management** | Utility overview — tokens persist; mark steps back |
| **Create / Configure** | Form clarity over brand theater |
| **Settings** | Quiet support utility — no onboarding mark (DR-020) |

### Rule of thumb

> If Breath Flow is not introducing the product or providing a minimal platform presence cue, it should not appear.

---

# 10. Motion

Experience philosophy (from `Docs/BRAND.md` and shipping transitions) — not API catalogs.

### Character

- Calm  
- Subtle  
- Never playful  
- Supports continuity; never demands attention  

### Preferred feeling

- Fade  
- Soft settle / small vertical ease  
- Progress fill that eases quietly  

### Shipping examples

- Today content: opacity + slight y-offset (~0.28s easeInOut); Reduce Motion → opacity only  
- Progress bar: ~0.3s easeInOut; respects Reduce Motion  
- My Rhythms empty/catalog: ~0.25s easeInOut; nil when Reduce Motion  

### Completion

Motion around acknowledgment stays quiet. Completion **acknowledges** presence (`이어냈어요` family) — it does not celebrate with bounce, confetti, or flash.

### Avoid

Bounce, shake, overshoot, flash, decorative loops (Brand Motion Principles).

Always respect Reduce Motion.

---

# 11. Screen Intent

Emotional purpose only — not layout recipes.

### Launch

A quiet inhale. The cream field and centered Breath Flow say “you are in the same calm place” before any interaction. No teaching, no CTA, no delay for branding.

### Welcome

The one introduction. Breath Flow, Hero Meaning, and short philosophy explain why the product exists, then invite the first rhythm. Management and Settings stay hidden until First Journey completes (DR-015).

### Today

The companion for the day. One primary rhythm holds attention; atmosphere (greeting / date) stays secondary; progress orients without becoming a scoreboard; completion acknowledges without judging.

### My Rhythms

A quiet collection room. Own and edit rhythms without restating brand philosophy. Operational clarity over presence theater.

### Create

Capture what matters first (name + time), then quieter configuration. Utility-plain language; soft Capture elevation; Configure steps back visually.

### Settings

Stay out of the way. Support preferences, trust, and recovery — never a second Welcome or brand playground (DR-020). Same Warm Light field, quieter voice.

### Live Activity

Remain present with today’s rhythm on the Lock Screen and Island. Share cream/sage identity where the platform allows; keep Breath Flow minimal; do not re-introduce the product or invent louder closure copy than Today.

---

# 12. Things We Explicitly Avoid

Grounded in Brand, ADR-011 / ADR-012, DR-017, DR-021, and shipping choices:

- Dashboard feeling / multi-hero layouts  
- Checklist identity and scoreboard triumph  
- Gamification, streaks-as-brand, confetti completion  
- Neon or high-chroma accents outside restrained sage  
- Heavy gradients as product chrome  
- Excessive or multi-layer shadows  
- Decorative animation and playful motion  
- Information overload and dense operational chrome on Experience surfaces  
- Parallel marks (emoji stand-ins, alternate logos)  
- Dark Mode product palettes or mixed light/dark presentation  
- Rebuilding UI from Hero marketing fiction (tab bars, illustrated card theater, unsupported Island controls)  
- Breath Flow decoration on Utility / Normal Empty surfaces  

---

# 13. Future Consistency Rules

Every new screen or visual change should satisfy:

1. **Warm Light** — Presents the cream/sage field; no scheme-dependent mixed chrome (DR-021).  
2. **One hero** — A single emotional center; secondary content is quieter.  
3. **Correct surface level** — Uses Level 1–4 intentionally; does not elevate utility into Identity.  
4. **Correct card language** — Elevated `.orCard()` only when content deserves Secondary Surface weight; Configure/empty stay quieter.  
5. **Tokens only** — Colors, type, space, radius come from the Design System; no one-off palettes.  
6. **Breath Flow placement** — Mark only where Identity or quiet platform presence requires it.  
7. **Acknowledgment over scoring** — Completion and progress do not become productivity identity.  
8. **Quiet motion** — Fade/settle; Reduce Motion respected; no playful ornament.  
9. **Intentionally finished** — Every visible state feels deliberate; utility may be plain but not broken or mixed.  
10. **Screenshot honesty** — Marketing follows the shipped language; the Hero does not redefine UI.

---

# Related Documents

- `Docs/Product/PRODUCT-PRINCIPLES.md`  
- `Docs/BRAND.md`  
- `Docs/Product/Brand-Integration-Architecture.md`  
- `Docs/Architecture/Decisions/DR-015-first-rhythm-onboarding-lifecycle.md`  
- `Docs/Architecture/Decisions/DR-017-brand-integration.md`  
- `Docs/Architecture/Decisions/DR-020-settings.md`  
- `Docs/Architecture/Decisions/DR-021-visual-identity-warm-light-appearance.md`  
- `Docs/ADR/ADR-010-Primary-Brand-Symbol-Breath-Flow.md`  
- `Docs/ADR/ADR-011-No-Checklist-Metaphor.md`  
- `Docs/ADR/ADR-012-Calm-Before-Productivity.md`  
- `Docs/Design/Presentation.md`  
- `Docs/Design/LiveActivity.md`  
- Design System: `OneulRhythm/DesignSystem/`  

---

# Out of Scope

- New color / type / radius tokens  
- Screen redesigns or layout measurements  
- Live Activity visual redesign recipes beyond presence rules  
- Hero or marketing asset production  
- Dark Mode adaptive palettes  

---

One rhythm at a time.

# Product

## Purpose

Product documentation defines what OneulRhythm should feel like and how user-facing behavior should work.

This hub indexes product decisions and UX contracts.

## Audience

Developers, product-minded contributors, architecture reviewers on UX sprints, and AI agents implementing Product UI work.

## Scope

- Product philosophy and principles
- Feature experience documents
- Implementation-ready UI specifications
- Index of archived product explorations

## Primary navigation

| Document | Role | Status |
|----------|------|--------|
| `PRODUCT-PHILOSOPHY.md` | Why the product exists | Active |
| `PRODUCT-PRINCIPLES.md` | Non-negotiable product constraints | Active |
| `Today-Experience.md` | Today North Star experience | Active |
| `Welcome-Experience.md` | First-launch Welcome Experience | Active — Approved |
| `Welcome-UI-Specification.md` | Welcome implementation-ready UI contract | Active |
| `Launch-Architecture-Specification.md` | App startup / Launch Experience architecture contract | Active — Approved |
| `Launch-UI-Specification.md` | Launch Screen implementation-ready UI contract | Active |
| `Brand-Integration-Architecture.md` | Cross-surface brand presence, language, completion, progress | Active — Approved |
| `My-Rhythms-Architecture.md` | My Rhythms purpose, entry, empty, ownership (utility collection) | Active — Approved |
| `My-Rhythms-UI-Specification.md` | My Rhythms implementation-ready UI contract | Active |
| `Create-Rhythm-Architecture.md` | Create/Edit Capture vs Configure hierarchy | Active — Approved |
| `Create-Rhythm-UI-Specification.md` | Create/Edit implementation-ready UI contract | Active |
| `Settings-Architecture.md` | Settings quiet support utility ownership / App vs OS / entry-exit | Active — Approved |
| `Settings-UI-Specification.md` | Settings implementation-ready UI contract | Active |
| `Today-UI-Specification.md` | Today implementation-ready UI contract | Active |
| `Management-UI-Specification.md` | My Rhythms section membership / legacy Management UI notes | Active — defer to My-Rhythms-UI-Spec on entry/empty/delete failure |
| `Today-Wireframe-Exploration.md` | Sprint 8 hierarchy exploration | Historical |

Brand Foundation lives outside this hub:

- `Docs/BRAND.md`
- `Docs/ADR/` (ADR-010 ~ ADR-012)

For current Product UI work, read:

1. `PRODUCT-PRINCIPLES.md`
2. `Today-Experience.md`
3. `Welcome-Experience.md` — first-launch product design
4. `Welcome-UI-Specification.md` — first-launch UI contract
5. `Launch-Architecture-Specification.md` — App Icon → Launch → Today/Welcome startup contract
6. `Launch-UI-Specification.md` — Launch Screen UI contract
7. `Brand-Integration-Architecture.md` — where brand appears / disappears; product voice
8. `My-Rhythms-Architecture.md` — My Rhythms collection purpose / entry / empty / ownership
9. `My-Rhythms-UI-Specification.md` — My Rhythms UI contract
10. `Create-Rhythm-Architecture.md` — Create/Edit Capture-first architecture
11. `Create-Rhythm-UI-Specification.md` — Create/Edit UI contract
12. `Settings-Architecture.md` — Settings support utility ownership / OS boundary
13. `Settings-UI-Specification.md` — Settings UI contract
14. `Today-UI-Specification.md`
15. `Management-UI-Specification.md` — section membership (see My-Rhythms-UI-Spec for entry/empty/delete)

## What this hub does NOT contain

- System structure or dependency diagrams
- Architecture Decision Records
- Subsystem implementation contracts
- Sprint process or QA workflow

When implementation begins, continue to `Docs/Design/README.md` for subsystem contracts.

# Documentation

## Purpose

This file is the documentation router for OneulRhythm.

It helps contributors decide where to go, which documents are active, and which role-based path to follow.

## Audience

All contributors, including developers, architecture reviewers, maintainers, and AI agents.

## Scope

- Documentation categories and ownership
- Active vs historical documents
- Role-based entry points
- Conflict resolution order
- Links to domain hubs and global references

## What this document does NOT contain

- Product philosophy or product behavior
- Architecture explanations or diagrams
- Design contracts
- Development workflow details

Authoritative content lives in the linked documents below.

---

# How to Navigate

```text
Docs/README.md          ← you are here (router)
    │
    ├─ Product/         ← product decisions & UX contracts
    ├─ BRAND.md         ← Brand Foundation
    ├─ ADR/             ← Brand Architecture Decision Records
    ├─ Architecture/    ← system structure, ADRs, architecture reviews
    ├─ Design/          ← implementation contracts
    ├─ Extensions/      ← optional capabilities
    ├─ Development/     ← how work is executed
    │     → Engineering charter
    │     → AI/AGENTS.md
    ├─ AI_Collaboration_Playbook_v2.2.md ← AI collaboration standard
    ├─ GLOSSARY.md      ← shared terminology
    ├─ ROADMAP.md       ← forward plan
    ├─ CHANGELOG.md     ← completed work
    └─ SprintReviews/   ← historical sprint records
```

Prefer:

Hub → leaf → authoritative document

Avoid circular navigation between hubs.

---

# Documentation Categories

| Category | Hub | Answers |
|----------|-----|---------|
| Product | `Product/README.md` | What should the product feel and behave like? |
| Brand | `BRAND.md`, `ADR/`, `../Assets/brand/` | How should the product feel, and where are production brand assets? |
| Architecture | `Architecture/README.md` | What is the system structure? Why was it chosen? |
| Design | `Design/README.md` | How is each subsystem implemented? |
| Extensions | `Extensions/README.md` | How do optional capabilities integrate? |
| Development | `Development/README.md` | How do we plan, implement, and validate work? |
| AI Collaboration | `AI_Collaboration_Playbook_v2.2.md` | How do ChatGPT, Cursor, QA, and the Developer collaborate? |
| Terminology | `GLOSSARY.md` | What do official terms mean? |
| Progress | `ROADMAP.md`, `CHANGELOG.md` | What is planned? What shipped? |
| History | `SprintReviews/README.md`, `Architecture/Reviews/` | What was decided in past sprints? |

---

# Active vs Historical

## Active (default reading)

- Product philosophy, principles, experience, and UI specifications
- Brand Foundation (`BRAND.md`) and Brand Architecture Decision Records (`ADR/`)
- Brand Assets (`../Assets/brand/` — `Release/` production, `Guide/` usage, `Work/` historical)
- Architecture structure and Decision Records
- Design and Extensions implementation contracts
- Development process documents, Engineering Charter, and `AI/AGENTS.md`
- `AI_Collaboration_Playbook_v2.2.md`
- Glossary, Roadmap, Changelog

## Historical (not part of default onboarding)

- `Product/Today-Wireframe-Exploration.md` (archived exploration)
- `Architecture/Reviews/` (archived pre-sprint architecture contracts)
- `SprintReviews/` (archived post-sprint reviews)

Historical documents remain in the repository for context. They are not sources of truth for current implementation.

---

# Lifecycle

| State | Meaning |
|-------|---------|
| Active | Current authority. No archive banner. Listed as Active in the owning hub. |
| Archived | Historical only. Uses the archive banner. Never implementation authority. |
| Superseded | ADR status only. Replaced by a newer Decision Record. |
| Delete | Rare. Use only when a document has no useful history and is safe to remove. Prefer Archive when uncertain. |

Do not invent additional lifecycle states.

---

# Role-Based Entry Points

## Public visitor

Start at the repository root README for product overview.

This router is for contributors.

## New developer

1. This router
2. `Product/README.md`
3. `GLOSSARY.md`
4. `Architecture/README.md` → `Architecture/ARCHITECTURE.md`
5. `Design/README.md`
6. `Development/README.md` → `Development/DEVELOPMENT_WORKFLOW.md`
7. `AI/AGENTS.md`
8. `AI_Collaboration_Playbook_v2.2.md`

## AI implementation agent

1. `AI/AGENTS.md`
2. `AI_Collaboration_Playbook_v2.2.md`
3. Product Principles — `Product/PRODUCT-PRINCIPLES.md`
4. Architecture — `Architecture/ARCHITECTURE.md`
5. Relevant Architecture Decision(s) — `Architecture/Decisions/`
6. `Development/DEVELOPMENT_WORKFLOW.md`
7. `Development/CURSOR_GUIDELINES.md`
8. `Engineering/ENGINEERING_CHARTER.md`
9. Sprint-specific Product and/or Design documents
10. `ROADMAP.md` (when applicable)

## Architecture reviewer

1. `Architecture/README.md` → `Architecture/ARCHITECTURE.md`
2. `Architecture/Decisions/README.md` → relevant Decision Records
3. Related Design documents
4. Product documents when the sprint is UX-facing

## Future maintainer

1. This router
2. `GLOSSARY.md`
3. `Product/README.md`
4. `Architecture/README.md`
5. `Design/README.md`
6. `Development/README.md`
7. `ROADMAP.md` and `CHANGELOG.md`
8. Historical indexes only when reconstructing history

---

# Authority When Documents Conflict

```text
README / Docs/README.md     ← navigation entry
    ↓
Product/PRODUCT-PRINCIPLES.md ← product constraints
    ↓
BRAND.md                    ← Brand Foundation
    ↓
ADR/                        ← Brand Architecture Decision Records
    ↓
Architecture/               ← system structure
    ↓
Architecture/Decisions/     ← system why / ownership
    ↓
Design/                     ← implementation contracts
    ↓
Extensions/
    ↓
Development/ and AI/AGENTS.md
```

`GLOSSARY.md` remains the terminology authority for shared terms.

Process conflicts are resolved by `Development/DEVELOPMENT_WORKFLOW.md`.

---

# Documentation Principles

1. One document, one responsibility.
2. Hubs navigate; leaves decide.
3. Link instead of duplicate.
4. Prefer the authoritative source.
5. Archive rather than delete history.
6. Active vs historical must be visible at the hub.
7. Product decisions before UI implementation contracts; contracts before code.
8. Architecture owns structure; Design owns how; Decisions own why.
9. Process docs never redefine product or architecture.
10. Avoid circular navigation.

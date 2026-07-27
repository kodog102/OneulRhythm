# Visual

## Purpose

This hub is the entry point for Sprint visual assets used by Image-Driven Development (Sprint 18+).

It indexes North Star images and supporting visual analysis so Product Owner, ChatGPT (Visual Director), Cursor, and QA Agent share one place to find the Visual Source of Truth.

The latest approved North Star image for a surface is that surface's Visual Source of Truth.

## Audience

Product Owner, ChatGPT (especially Visual Director / UX Architect), Cursor, and QA Agent on Product Experience / visual Sprints.

## Scope

- North Star images — official visual targets (Visual Source of Truth)
- Design Extraction Sheets — Visual Analysis: implementable rules extracted from a North Star
- Visual Review Guides — criteria used during Visual QA

## What this hub does NOT contain

- Product philosophy or UX experience contracts (`Docs/Product/`)
- Design System / visual language implementation contracts (`Docs/Design/Visual-Language-Specification.md`)
- Production brand marks and export guides (`Assets/brand/`)
- Sprint workflow stage definitions (`Docs/Development/DEVELOPMENT_WORKFLOW.md`)
- Collaboration role rules (`Docs/AI/AGENTS.md`, `Docs/AI_Collaboration_Playbook_v2.2.md`)

This hub defines visual asset strategy and navigation. It is not a place to redefine product behavior or architecture.

---

# Visual asset strategy

## Purpose of North Star images

A North Star image is the approved visual target for a product surface.

When one exists:

- It is the Visual Source of Truth for implementation and Visual QA.
- Cursor implements the visual language shown in the image.
- Written UI descriptions and Design Extraction Sheets supplement the image; they do not replace it.
- Agents must not redesign or reinterpret the UI from text alone.

## Storage location

```text
Docs/Visual/README.md     ← you are here (router)
    │
    ├─ NorthStars/           ← versioned North Star images
    ├─ DesignExtractions/     ← Visual Analysis sheets (when present)
    └─ ReviewGuides/         ← Visual QA criteria (when present)
```

## Image versioning

Name North Star files so surface and version are obvious:

```text
{Surface}-NorthStar-v{N}.{ext}
```

Example: `Today-NorthStar-v1.jpg`

Increment `N` when the Product Owner accepts a new official image for that surface.

## North Star Lifecycle

```text
Draft
  → Architect Review
  → Product Owner Approval
  → Official North Star
  → Implementation
  → Visual QA
  → Version Archive
```

- Approved images are never overwritten.
- New design directions create a new version (`vN+1`).
- Previous North Stars remain available for historical reference and are never implementation authority once superseded.

## Approval process

1. Product Vision and Sprint requirements are agreed.
2. A candidate North Star image is proposed.
3. Product Owner accepts the image as official for the surface.
4. Index the Active path in the table below.
5. Previous official versions move to Historical and remain in the repository.

Until Product Owner acceptance, a candidate image is not Visual Source of Truth.

## Preserving previous versions

Do not delete superseded North Star images.

Keep prior versions under `NorthStars/` and list them as Historical so visual history remains auditable. Archived images are never implementation authority.

---

# How to use

Preferred order for Image-Driven Development:

1. Accept or update the official North Star image
2. Produce Visual Analysis (Design Extraction Sheet)
3. Optionally add a Visual Review Guide
4. Index Active artifacts in the tables below
5. Reference those paths from the Cursor prompt and Visual QA

Link to Product / Design authorities instead of copying their content here.

---

# Current official image

| Surface | Path | Version | Sprint | Status |
|---------|------|---------|--------|--------|
| Today | `NorthStars/Today-NorthStar-v1.jpg` | v1 | 18 | Active — Visual Source of Truth |

This is the project's current official North Star for Today.

Sprint 18 implemented the Today Experience against this North Star (Morning Landscape, card chrome, Progress Ratio, and Active / First Journey / Normal Empty / Day Complete alignment). Further visual / theme work is planned after Sprint 19.

---

# Active artifacts

| Kind | Path | Sprint | Status |
|------|------|--------|--------|
| North Star | `NorthStars/Today-NorthStar-v1.jpg` | 18 | Active — Visual Source of Truth |

When a Sprint adds visual artifacts, list them here as Active and keep Product / Design owner documents authoritative for behavior.

---

# Historical artifacts

| Kind | Path | Sprint | Status |
|------|------|--------|--------|
| — | — | — | — |

Archive completed or superseded Sprint visual packs here when they are no longer implementation authority. Preserve previous North Star versions when a newer official image is accepted.

---

# Authority boundaries

| Topic | Authority |
|-------|-----------|
| Image-Driven Development stages | `Docs/Development/DEVELOPMENT_WORKFLOW.md` |
| Collaboration / roles | `Docs/AI/AGENTS.md`, `Docs/AI_Collaboration_Playbook_v2.2.md` |
| Product meaning / UX contracts | `Docs/Product/` |
| Visual language / Design System | `Docs/Design/Visual-Language-Specification.md` |
| Brand marks / production assets | `Docs/BRAND.md`, `Assets/brand/` |
| Visual appearance of a surface (when a North Star exists) | Latest approved North Star image indexed above |

When a visual artifact and a Product or Design document conflict, Product Principles and Active Product / Design contracts win until the Product Owner resolves the conflict in the owner document. The North Star still governs visual reproduction within those product boundaries.

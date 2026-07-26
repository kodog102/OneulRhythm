# Asset Manifest — OneulRhythm Brand Assets v1.0

Operational authority for brand asset storage, naming, and release.

---

## Brand Lock Authority

| Item | Value |
|------|-------|
| Brand Lock | **v1.0** |
| Status | **Approved** |
| Effective Sprint | Sprint 13 |
| Master Symbol | Breath Flow |
| Locked Production Master | **Breath Flow E10 — Soft Taper Synthesis** |
| Philosophy authority | `Docs/BRAND.md` |
| Architecture authority | ADR-010 / ADR-011 / ADR-012 |
| Historical optical work | `Assets/brand/Work/Sprint-13-2-Breath-E-Optical-Refinement/` |

E10 is the approved and locked production master. Sprint 14 reproduces, exports, and validates it. Do not redesign, refine, or reinterpret the locked mark in Release work.

---

## Work vs Release

| Area | Purpose |
|------|---------|
| `Assets/brand/Work/` | Historical exploration, refinement, optical study. Sprint-numbered. Not shipped. |
| `Assets/brand/Release/` | Production-ready exports only. No Sprint numbers in filenames. |
| `Assets/brand/Guide/` | Construction, safe area, export, motion, and package guides. |

Work informs Release. Release never depends on Work at runtime.

---

## Directory Map

```text
Assets/brand/
  ASSET-MANIFEST.md
  SPRINT-14-PRODUCTION-PLAN.md
  Work/                         ← exploration history
  Release/
    Logo/                       ← SVG / PDF / mono variants
    AppIcon/                    ← PNG app-icon set
    Preview/                    ← marketing / review previews
  Guide/                        ← production guides
```

---

## Planned Asset Types

| Type | Location | Extensions |
|------|----------|------------|
| Primary / mono logos | `Release/Logo/` | `.svg`, `.pdf`, `.png` |
| App Icon masters | `Release/AppIcon/` | `.png` |
| Preview surfaces | `Release/Preview/` | `.png`, `.pdf` (optional marketing) |
| Construction / safe area / export / motion | `Guide/` | `.md`, export scripts |

Logo and App Icon production assets are present. `Release/Preview/` may remain empty until marketing previews are exported.

---

## File Naming Convention

Lowercase kebab-case for **Logo** Release files.

**Logo pattern**

```text
oneulrhythm-breath-flow-{variant}.{extension}
```

**Logo examples**

```text
oneulrhythm-breath-flow-primary.svg
oneulrhythm-breath-flow-mono-light.svg
oneulrhythm-breath-flow-mono-dark.svg
```

**App Icon production filenames (Sprint 14-3)**

```text
AppIcon-1024.png
AppIcon-Preview.png
```

Rules:

- No Sprint numbers in `Release/` filenames  
- Sprint numbers allowed only under `Work/`  
- Logo uses kebab-case product prefix; App Icon uses the `AppIcon-*.png` production names above  
- Variant names describe usage (`primary`, `mono-light`, `mono-dark`); `E10` may appear in Guide docs  

Geometry fingerprint (Release SVG path `d` SHA-256):

```text
ed64b7938f49ebbdaa01139dfbb2f0a4da929e7c7e2698db81ed6f7808175d64
```

---

## Source-of-Truth Rules

1. **Meaning** → `Docs/BRAND.md` + ADR-010  
2. **Locked geometry** → Breath Flow E10 (Brand Lock v1.0 · Approved)  
3. **Production files** → `Assets/brand/Release/`  
4. **How to export / construct** → `Assets/brand/Guide/`  
5. **History** → `Assets/brand/Work/`  

If Release and Work disagree, Release + Brand Lock win. Update Work only as archive notes, never as a competing master.

---

## Versioning Rules

| Layer | Rule |
|-------|------|
| Brand Lock | `vMAJOR.MINOR` (current: **v1.0 · Approved**) |
| Release package | Align with Brand Lock major when geometry or core variants change |
| Individual files | Replace in place under the same canonical name when correcting export quality without meaning change |

Do not invent parallel filename versions (`-v2`, `-final`, `-final2`) inside Release.

---

## Replacement Policy

- Corrected exports replace the previous file at the same path and name.  
- Document the replacement reason in the Sprint notes or Guide changelog section when material.  
- Geometry changes require a new Brand Lock decision before Release replacement.

---

## Deprecated Asset Handling

1. Remove from `Release/` (or move to `Work/deprecated/` only if retention is required).  
2. Record deprecation in this manifest or Guide.  
3. Do not leave unmarked duplicates in Release.  
4. App targets must not reference deprecated paths.

---

## Related

- Production plan: `SPRINT-14-PRODUCTION-PLAN.md`  
- Guides: `Guide/README.md`  
- ROADMAP Sprint 14 scope: App Icon Assets, SVG, PDF, PNG, Construction Grid, Safe Area, Export Guide, Motion Principle (see `Docs/BRAND.md`), Brand Package (`Release/` + `Guide/`)

---

## Brand Package Inventory (v1.0)

| Member | Location |
|--------|----------|
| Logo master + exports | `Release/Logo/` |
| App Icon | `Release/AppIcon/` |
| Usage / construction / safe area / export | `Guide/` |
| Manifest | `ASSET-MANIFEST.md` |

Motion Principle for product UI remains documented in `Docs/BRAND.md` (Motion Principles). No separate asset-motion geometry exists.

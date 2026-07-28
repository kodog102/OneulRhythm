# North Stars

## Purpose

North Stars are the approved visual targets for product surfaces.

When a North Star exists for a surface, it is that surface's Visual Source of Truth.

## Visual Source of Truth

- The latest approved image under each screen folder is authoritative for visual appearance.
- Written UI specs and Design Extraction Sheets supplement the image; they do not replace it.
- Agents must not redesign or reinterpret the UI from text alone.

## Image-Driven Development

```text
North Star → Visual Analysis → Implementation → Visual QA
```

1. Accept the official North Star for the surface.
2. Extract implementable visual rules (when a Design Extraction Sheet exists).
3. Implement the visual language shown in the image.
4. Run Visual QA against the North Star.

Workflow authority: `Docs/Development/DEVELOPMENT_WORKFLOW.md`.

## How Cursor should use these assets

- Open the surface README and the linked North Star image before coding.
- Reproduce layout, atmosphere, hierarchy, and chrome from the image.
- Preserve architecture and Product contracts; do not invent visual direction.
- Prefer the image over prose when descriptions conflict on appearance.

Hub index: `Docs/Visual/README.md`.

## Screens

| Surface | Path | Status |
|---------|------|--------|
| Today | `Today/` | Active — Visual Source of Truth |
| Rhythm Editor | `RhythmEditor/` | Active — Visual Source of Truth |
| My Rhythms | `MyRhythms/` | Active — Visual Source of Truth |
| Settings | `Settings/` | Active — Visual Source of Truth |
| Live Activity | `LiveActivity/` | Active — Visual Source of Truth |

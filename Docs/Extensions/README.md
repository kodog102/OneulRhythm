# Extensions

The Extensions documentation describes capabilities that extend the core architecture without changing it.

Unlike the Design documentation, which specifies the implementation of the current system, Extensions define how future capabilities integrate into the existing architecture.

Extensions are optional additions.

The core architecture remains stable regardless of whether an extension is implemented.

---

# Purpose

Extensions exist to:

- Describe future architectural capabilities.
- Define integration points.
- Preserve architectural consistency.
- Avoid parallel implementations.
- Support long-term evolution.

---

# Principles

Every extension should:

- Reuse the existing architecture.
- Respect dependency direction.
- Integrate through existing boundaries.
- Avoid duplicating business logic.
- Produce deterministic behavior.

Extensions should never require changes to the fundamental architecture.

---

# Typical Extension Flow

```
Extension
      │
      ▼
Repository
      │
      ▼
Schedule Engine
      │
      ▼
ResolvedSchedule
      │
      ▼
Mapper
      │
      ▼
Presentation
```

Extensions contribute to the existing pipeline.

They do not replace it.

---

# Current Extensions

| Document | Purpose | Status |
|----------|---------|--------|
| Recurrence.md | Generate daily rhythms from recurring definitions | Foundation in progress (Sprint 6-4) |

---

# Future Extensions

Potential future extensions include:

- Calendar Integration
- Cloud Synchronization
- Apple Watch
- Siri
- Shortcuts
- Family Sharing
- AI Rhythm Suggestions

Each extension should integrate through the existing architecture rather than introducing new business pipelines.
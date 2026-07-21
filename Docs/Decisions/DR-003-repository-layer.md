# DR-003 — Repository Layer

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Data Access Layer

---

## Context

Business logic should remain independent of the persistence framework.

Directly accessing SwiftData from ViewModels or business components would tightly couple application logic to the storage implementation, making future changes more difficult and increasing the risk of duplicated data access logic.

A single abstraction is required to centralize persistence operations and isolate storage-specific concerns.

---

## Decision

The project adopts the **Repository Pattern** as the single access point for persisted data.

Repositories are responsible for:

- Reading persisted data
- Writing persisted data
- Updating persisted data
- Deleting persisted data
- Mapping persistence models to domain models

Business rules are explicitly excluded from the Repository layer.

Repositories expose domain models rather than persistence-specific models whenever possible.

ViewModels and other business components interact only with Repository interfaces and remain unaware of the underlying persistence implementation.

---

## Consequences

### Positive

- Clear separation between business logic and persistence.
- Reduced coupling to SwiftData.
- Centralized data access logic.
- Easier testing through repository abstraction.
- Future persistence changes have minimal impact on higher layers.

### Negative

- Introduces an additional abstraction layer.
- Simple persistence operations require repository implementations even when direct access would be shorter.

These trade-offs are accepted to maintain long-term architectural consistency.

---

## Alternatives Considered

### Direct SwiftData Access

Rejected.

Allowing ViewModels to access SwiftData directly would distribute persistence logic across the application and make future architectural changes more difficult.

### Generic Data Service

Rejected.

A generic data service would blur the distinction between persistence concerns and business responsibilities.

The Repository Pattern provides clearer ownership and aligns better with the project's domain-driven structure.

---

## Related Decisions

- DR-001 — Project Principles
- DR-002 — SwiftData Persistence
- DR-004 — Schedule Engine
- DR-005 — Today Snapshot
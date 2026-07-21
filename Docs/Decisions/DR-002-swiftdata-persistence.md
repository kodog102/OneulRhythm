# DR-002 — SwiftData Persistence

**Status:** Accepted  
**Decision Date:** Sprint 6 Planning  
**Applies From:** Persistence Layer

---

## Context

OneulRhythm is an offline-first application whose primary data consists of user-defined rhythms and their completion history.

The persistence layer must integrate naturally with SwiftUI, require minimal infrastructure, and remain easy to evolve as the domain model grows.

The project does not currently require:

- Cloud synchronization
- Multi-user collaboration
- Cross-platform shared persistence
- Complex relational queries
- Server-side storage

Given these requirements, a lightweight persistence solution is preferred over a more complex architecture.

---



## Decision

The project adopts **SwiftData** as the primary persistence framework.

SwiftData is responsible for storing durable application data, including:

- Rhythm definitions
- Daily completion history
- Reminder configuration
- Future user preferences

SwiftData is treated as an implementation detail of the persistence layer.

Business logic must not depend directly on SwiftData APIs.

Access to persisted data is performed through the Repository layer.

This allows domain logic to remain independent of the underlying persistence technology.

---



## Consequences



### Positive

- Native integration with SwiftUI.
- Reduced boilerplate compared to Core Data.
- Automatic model management for the project's current scale.
- Straightforward schema evolution through SwiftData migrations.
- Clear separation between persistence and business logic.



### Negative

- The application becomes dependent on iOS 17 or later.
- SwiftData is less mature than Core Data and may require careful migration planning.
- Advanced querying capabilities are intentionally deferred until they become necessary.

These trade-offs are accepted because they align with the project's current scope and goals.

---



## Alternatives Considered



### Core Data

Rejected.

Core Data provides greater flexibility and maturity but introduces additional complexity that is unnecessary for the current project.

### SQLite

Rejected.

Direct SQLite management would require significant infrastructure while providing little benefit for the application's current requirements.

### Realm

Rejected.

Realm offers a productive developer experience but introduces an external dependency without providing compelling advantages for this project.

### Server-side Persistence

Rejected.

The project is intentionally designed as an offline-first application.

Cloud synchronization may be introduced later without changing the domain architecture.

---



## Related Decisions

- DR-001 — Project Principles
- DR-003 — Repository Layer
- DR-011 — Recurring Rhythm Foundation


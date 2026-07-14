ARCHITECTURE.md

OneulRhythm Architecture Guide

This document defines the architectural principles of the OneulRhythm project.

Every new feature should follow these guidelines.

⸻

Philosophy

OneulRhythm is intentionally simple.

We prioritize:

* Readability
* Maintainability
* Incremental growth
* Small reusable components

Avoid unnecessary abstraction.

Prefer simple solutions that scale naturally.

⸻

Architecture

Current

SwiftUI

MVVM

ObservableObject

Future

SwiftData

Repository Pattern

WidgetKit

Live Activity

Apple Watch

AI Recommendation

⸻

Layer Structure

Views
        │
        ▼
ViewModels
        │
        ▼
Repositories (Future)
        │
        ▼
SwiftData

Views should never know where data comes from.

Changing the storage layer should not require changing the UI.

⸻

Folder Responsibilities

App

Application entry point.

Contains:

* App lifecycle
* App configuration

⸻

DesignSystem

Reusable visual resources.

Contains:

* ORColors
* ORSpacing
* ORTypography

Never place business logic here.

⸻

Features

Feature-based organization.

Example

Features
    Today
    Routines
    Onboarding

Each feature owns:

* Views
* ViewModels
* Local helper types

⸻

Models

Pure domain models.

Example

Routine

RoutineCategory

RoutineStatus

Models should contain minimal business logic.

No UI code.

⸻

Services

Application services.

Current

MockRoutineData

Future

NotificationService

RoutineRepository

WidgetService

HealthKitService

Services should be reusable across features.

⸻

Extensions

Small reusable extensions.

Avoid large utility files.

⸻

MVVM Rules

Views

Responsible for:

* Layout
* User interaction
* Binding

Views should never contain business logic.

⸻

ViewModels

Responsible for:

* Screen state
* User actions
* Business rules
* Formatting for UI when appropriate

ViewModels should never know about SwiftUI layout.

⸻

Models

Represent application data.

Models should be immutable whenever practical.

Prefer value types.

Example

routine.updatingStatus(.completed)

instead of mutating internal values.

⸻

State Management

Current

ObservableObject

@Published

@StateObject

Use:

View

↓

ViewModel

↓

Model

Avoid passing state across unrelated screens.

⸻

Data Flow

Current

MockRoutineData
        │
        ▼
TodayViewModel
        │
        ▼
TodayView

Future

SwiftData
        │
        ▼
RoutineRepository
        │
        ▼
TodayViewModel
        │
        ▼
TodayView

The UI should not notice when Mock data is replaced by SwiftData.

⸻

Reusable Components

Prefer reusable components.

Example

RoutineCardView

instead of:

CurrentRoutineCardView

NextRoutineCardView

if the layout is nearly identical.

⸻

Navigation

Each feature owns its navigation.

Avoid centralizing all navigation.

Keep navigation shallow.

⸻

Dependency Rules

Allowed

View

↓

ViewModel

↓

Repository

↓

SwiftData

Not allowed

View

↓

SwiftData

View

↓

NotificationManager

View

↓

HealthKit

Views should communicate only with ViewModels.

⸻

Async Work

Future async work should use:

Swift Concurrency

async/await

Avoid callback-based APIs when possible.

⸻

Testing Philosophy

Business logic should be testable without SwiftUI.

ViewModels should be easy to instantiate using mock data.

Future repositories should support mock implementations.

⸻

Preview Strategy

Every reusable View should support Preview.

Examples:

* Default
* Completed
* Empty
* Large Dynamic Type
* Dark Mode

Preview should never depend on production data.

⸻

Performance

Prefer value types.

Avoid unnecessary ObservableObjects.

Avoid deeply nested SwiftUI views.

Extract reusable components early.

⸻

Future Growth

The architecture should support:

* SwiftData
* Local notifications
* WidgetKit
* Live Activities
* Apple Watch
* AI-generated routines

without major refactoring.

⸻

Decision Making

When multiple implementations are possible:

1. Choose the simplest solution.
2. Prefer readability over cleverness.
3. Optimize only when necessary.
4. Keep ViewModels lightweight.
5. Avoid creating abstractions before they are needed.

Architecture should evolve gradually with the project, never ahead of it.
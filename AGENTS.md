AGENTS.md

OneulRhythm AI Development Guide

This document defines how AI coding assistants should work on the OneulRhythm project.

Always follow these rules unless explicitly instructed otherwise.

⸻

Project Overview

OneulRhythm is a calm Korean lifestyle routine app built with SwiftUI.

The purpose of the app is not productivity.

The purpose is helping users continue today’s rhythm in a calm and natural way.

Every design and engineering decision should support this philosophy.

⸻

Core Philosophy

Prefer:

* Calm
* Warm
* Minimal
* Spacious
* Simple

Avoid:

* Gamification
* Busy layouts
* Aggressive colors
* Complex interactions
* Productivity dashboard feeling

This should feel closer to Apple Health or Apple Journal than a task manager.

⸻

Architecture

Current architecture:

SwiftUI

MVVM

ObservableObject

Later:

SwiftData

Repository Pattern

WidgetKit

Live Activity

Apple Watch

Always prepare the code so new features can be added without major refactoring.

⸻

Folder Structure

App

DesignSystem

Features

Models

Services

Resources

Extensions

Do not create unnecessary folders.

Keep the project structure simple.

⸻

SwiftUI Rules

Prefer small reusable Views.

Do not create massive Views.

One View should generally stay below 200 lines.

Extract reusable components whenever duplication appears.

Use:

RoutineCardView

instead of multiple similar card implementations.

⸻

State Management

Current

ObservableObject

@Published

@StateObject

Future

SwiftData

Avoid global state.

Avoid singleton managers unless absolutely necessary.

⸻

Design System

Always use:

ORColors

ORSpacing

ORTypography

Do NOT hardcode:

colors

spacing

font sizes

corner radius

unless absolutely necessary.

If a new design token is required, add it to the DesignSystem.

⸻

UI Style

Background

Warm cream

Primary

Sage green

Cards

Rounded

Soft shadow

Large spacing

Typography

Rounded system font

Minimal

Apple-like

Premium

Never create overly decorative interfaces.

⸻

Components

Prefer composition.

Large Views should be composed from smaller reusable components.

Avoid duplicated UI.

⸻

Models

Models should be immutable whenever possible.

Prefer creating updated copies rather than mutating properties.

Example:

Routine.updatingStatus(…)

instead of mutating internal values.

⸻

View Models

Views should focus on layout.

Business logic belongs inside ViewModels.

Networking and persistence should never exist directly inside Views.

⸻

Data Layer

Current:

MockRoutineData

Future:

SwiftData

Repository

Do not tightly couple Views to data sources.

⸻

Preview

Every reusable View should have Preview support.

Provide multiple previews when meaningful.

Examples:

Current

Completed

Dark Mode

Large Dynamic Type

⸻

Accessibility

Support:

Dynamic Type

VoiceOver friendly labels where appropriate

Reasonable touch targets

Avoid tiny buttons.

⸻

Performance

Avoid unnecessary View updates.

Prefer value types.

Avoid deeply nested View hierarchies.

⸻

Code Style

Readable over clever.

Simple over abstract.

Explicit over magic.

Favor maintainability.

⸻

Naming

Use clear English type names.

Example:

Routine

TodayView

RoutineCardView

TodayViewModel

User-facing text should remain Korean.

⸻

Comments

Avoid unnecessary comments.

Write self-explanatory code.

Only comment when business rules are not obvious.

⸻

Future Features

SwiftData

Notifications

Routine Scheduling

WidgetKit

Live Activities

Apple Watch

Routine Statistics

AI Recommendations

Every new feature should integrate naturally into the existing architecture.

⸻

AI Instructions

When modifying the project:

* Preserve the existing architecture.
* Preserve the calm design language.
* Reuse existing components.
* Avoid unnecessary abstraction.
* Avoid premature optimization.
* Prefer incremental improvements over large rewrites.

If multiple solutions exist, choose the simplest solution that scales well.

The project should always feel handcrafted rather than generated.
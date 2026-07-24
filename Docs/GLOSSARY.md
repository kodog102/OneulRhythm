# Glossary

This glossary defines the official terminology used throughout the OneulRhythm project.

These definitions serve as the single source of truth for architectural and domain terminology.

English terms are the canonical names used in source code.

Korean descriptions are provided to improve readability for contributors.

---

# Architecture

## Repository

### Korean

저장소 계층.

SwiftData를 캡슐화하여 영속성 구현을 Business Layer로부터 분리한다.

애플리케이션에서 데이터에 접근하는 유일한 진입점이다.

### English

The Repository abstracts persistence and isolates SwiftData from the rest of the application.

It is the single entry point for reading and writing persisted rhythm data.

**Layer**

Data

**Produces**

Domain Models

**Consumed By**

Business Layer

---

## Schedule Engine

### Korean

프로젝트의 핵심 비즈니스 엔진.

저장된 리듬을 현재 시간 기준으로 해석하여 오늘의 비즈니스 상태를 결정한다.

UI나 플랫폼 프레임워크를 전혀 알지 않는다.

### English

The Schedule Engine interprets persisted rhythms relative to the current time and produces the business state of the current day.

It is completely independent from presentation frameworks.

**Layer**

Business

**Produces**

ResolvedSchedule

---

## ResolvedSchedule

### Korean

Schedule Engine이 생성하는 공식 비즈니스 결과 모델.

오늘 하루에 대한 해석이 완료된 상태를 표현하며, 모든 화면은 동일한 ResolvedSchedule을 기반으로 표현된다.

### English

ResolvedSchedule is the official business output produced by the Schedule Engine.

It represents the interpreted state of the current day before any presentation-specific transformation occurs.

**Layer**

Business

**Produced By**

Schedule Engine

**Consumed By**

- Today Snapshot Mapper
- Live Activity Mapper
- Notification Mapper
- Future Surface Mappers

**Not Responsible For**

- UI
- Formatting
- SwiftUI
- ActivityKit
- Framework lifecycle

---

## Mapper

### Korean

비즈니스 모델을 화면 모델로 변환하는 계층.

각 Presentation Surface는 독립적인 Mapper를 가진다.

Mapper는 비즈니스 규칙을 수행하지 않는다.

### English

A Mapper transforms business models into presentation models.

Each presentation surface owns its own mapper.

A Mapper never performs business logic.

**Layer**

Mapping

**Examples**

- Today Snapshot Mapper
- Live Activity Mapper
- Notification Mapper
- Widget Mapper
- Watch Mapper

---

## Notification Plan

### Korean

알림 표면이 소비하는 Desired State 모델.

스케줄링이나 Apple 프레임워크 타입을 포함하지 않으며, 원하는 알림 상태만 표현한다.

### English

Desired notification state produced by `NotificationMapper`.

It is a pure value model containing ordered `NotificationPlanItem` values. It does not schedule notifications or contain Apple framework types.

**Layer**

Mapping

**Produced By**

Notification Mapper

**Consumed By**

Notification Scheduling

**Not Responsible For**

- Persistence
- Permission UX
- Diff calculation (owned by Notification Synchronization)
- UserNotifications delivery

---

## Notification Synchronization

### Korean

원하는 `NotificationPlan`과 현재 pending notification을 최소 변경으로 맞추는 순수 조정 로직.

### English

Pure reconciliation that computes the minimal remove/schedule operations required to align pending notification requests with a desired `NotificationPlan`.

An update is expressed as remove + schedule for the same identifier.

**Layer**

Mapping / Scheduling boundary

**Produced By**

NotificationSynchronization.changes

**Applied By**

NotificationScheduling.synchronize

**Not Responsible For**

- Trigger-date calculation
- Schedule Engine business rules
- Deriving business state
- NotificationMapper responsibilities
- Apple framework interaction

---

## Notification Trigger Policy

### Korean

리마인더 트리거 시각을 계산하는 단일 정책.

### English

The single source of truth for reminder trigger-date calculation.

Returns `nil` when no notification should be scheduled.

**Layer**

Business / Domain Policy

---

## Coordinator

### Korean

플랫폼 프레임워크의 생명주기를 관리하는 구성 요소.

비즈니스 상태를 계산하지 않으며 프레임워크 동작만 관리한다.

### English

A Coordinator manages framework lifecycle operations without owning business logic.

Examples include requesting, updating and ending Live Activities.

**Layer**

Presentation Infrastructure

---

# Business

## Rhythm

### Korean

사용자가 수행하는 하나의 일정 또는 루틴.

### English

A Rhythm represents one scheduled activity performed by the user.

---

## Current Rhythm

### Korean

현재 시점에서 진행 중인 리듬.

### English

The rhythm currently active according to schedule resolution.

---

## Past Rhythm

### Korean

예정 시간이 지났지만 아직 완료되지 않은 리듬.

### English

A rhythm whose scheduled time has passed but remains incomplete.

---

## Next Rhythm

### Korean

현재 이후 가장 먼저 예정된 리듬.

### English

The next upcoming rhythm after the current time.

---

## Primary Rhythm

### Korean

현재 Presentation Surface에서 사용자에게 가장 중요하게 보여줄 단 하나의 리듬.

Today Snapshot이 Current → Past Incomplete → Next 우선순위로 선택한다.

### English

The single rhythm selected for presentation on a specific surface.

For Today, selection is owned by `TodayRhythmSnapshot` using the priority Current → Past Incomplete → Next.

---

## Day Complete

### Korean

오늘의 모든 리듬이 완료된 상태.

### English

The state in which all rhythms for the current day have been completed.

---

## Schedule Resolution

### Korean

저장된 리듬을 현재 시간 기준으로 해석하여 비즈니스 상태를 생성하는 과정.

### English

The business process that interprets persisted rhythms relative to the current time.

---

# Presentation

## Presentation Surface

### Korean

사용자에게 정보를 표현하는 개별 화면 또는 플랫폼.

Today 화면, Live Activity, Widget 등이 각각 하나의 Surface이다.

### English

An individual UI destination that presents application state to the user.

Examples include the Today screen, Live Activity, Widgets and Apple Watch.

---

## Today Snapshot

### Korean

Today 화면이 소비하는 Presentation Model.

### English

Presentation model consumed by the Today screen.

---

## Activity Content

### Korean

Live Activity가 소비하는 Presentation Model.

### English

Presentation model consumed by ActivityKit.

---

## Presentation Model

### Korean

UI가 직접 소비하는 모델.

비즈니스 계산은 모두 완료된 상태이다.

### English

A model specifically designed for presentation.

Business interpretation has already been completed.

---

# Persistence

## SwiftData Entity

### Korean

SwiftData에 저장되는 영속성 모델.

### English

Persistence model stored by SwiftData.

---

## Domain Model

### Korean

Business Layer에서 사용하는 프레임워크 독립 모델.

Persistence나 UI에 종속되지 않는다.

### English

Framework-independent model used inside the Business Layer.

---

# Documentation

## Architecture

### Korean

시스템 구조와 계층, 의존성 방향을 설명하는 문서.

### English

Describes the overall architecture, layers and dependency direction.

---

## Decision Record

### Korean

아키텍처 결정을 기록하는 문서.

무엇을 구현했는지가 아니라 왜 그렇게 결정했는지를 설명한다.

### English

Captures architectural decisions and the rationale behind them.

---

## Design

### Korean

각 구성 요소의 구현 명세를 정의하는 문서.

### English

Defines implementation specifications for each subsystem.

---

## Roadmap

### Korean

향후 개발 계획을 관리하는 문서.

### English

Describes planned future work.

---

## Changelog

### Korean

완료된 변경 사항을 기록하는 문서.

### English

Records completed project changes.
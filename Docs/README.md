# **🌿 OneulRhythm**

오늘의 흐름을 조용히 이어주는 iOS 리듬 앱

OneulRhythm(오늘리듬)은 할 일을 몰아붙이는 생산성 앱이 아닙니다.

사용자가 지금 해야 할 리듬과 다음 흐름을 자연스럽게 이해하고, 하루를 차분하게 이어갈 수 있도록 돕는 iOS 라이프스타일 앱입니다.

앱을 계속 열어보지 않아도 Today 화면, 알림, Live Activity를 통해 현재 리듬을 부담 없이 확인할 수 있는 경험을 목표로 합니다.

---

# **Product Philosophy**

OneulRhythm prioritizes rhythm over tasks.

- 현재 리듬은 할 일 목록보다 중요합니다.
- 지나간 리듬은 실패가 아닙니다.
- 알림은 선택사항입니다.
- Live Activity는 사용자를 방해하지 않고 곁에서 안내합니다.
- 진행률은 경쟁이나 성취 점수가 아니라 오늘의 흐름을 이해하기 위한 정보입니다.
- 사용자가 죄책감을 느끼게 하는 표현과 인터랙션을 피합니다.

---

# **Core Experience**

OneulRhythm의 핵심 경험은 다음 흐름을 기반으로 합니다.

```text
오늘의 루틴
    ↓
현재 리듬
    ↓
지나간 리듬
    ↓
다음 리듬
    ↓
오늘의 흐름
```

루틴 상태는 시간에 따라 자동으로 계산됩니다.

- 현재 진행 중인 루틴 → 현재 리듬
- 오늘 이미 지나갔지만 완료하지 않은 루틴 → 지나간 리듬
- 앞으로 예정된 루틴 → 다음 리듬
- 사용자가 완료한 루틴 → 완료된 리듬

---

# **Features**

## **Implemented**

- Today 화면
- 현재 리듬 자동 계산
- 지나간 리듬 표시
- 다음 리듬 자동 계산
- 오늘 진행률 계산
- 루틴 완료 상태 저장
- 루틴 생성
- 과거 시간 선택 시 오늘 또는 내일 등록
- SwiftData 기반 로컬 저장
- Repository 패턴
- NotificationService 기반
- 리마인더 권한 요청 흐름
- 선택적 리마인더 예약

## **In Progress**

- 알림 취소 및 완료 연동
- TodayRhythmSnapshot
- Live Activity
- Dynamic Island
- 잠금 화면 리듬 안내

## **Planned**

- WidgetKit
- Apple Watch
- App Intents / Siri
- iCloud Sync
- 반복 루틴
- 루틴 수정 및 삭제
- 접근성 및 자동 테스트
- TestFlight 및 App Store 출시

---

# **Live Activity First**

OneulRhythm의 주요 경험은 알림보다 Live Activity에 가깝습니다.

```text
알림
→ 새로운 리듬이 시작된다는 사실을 한 번 알려줌

Live Activity
→ 현재 리듬을 조용히 지속해서 보여줌
```

알림은 사용자가 명시적으로 활성화한 경우에만 사용됩니다.

Live Activity는 하루 전체의 리듬을 하나의 세션으로 표현하는 방향을 사용합니다.

- 하나의 루틴마다 별도 Activity를 생성하지 않습니다.
- 오늘 하루를 대표하는 하나의 Live Activity를 유지합니다.
- 현재 리듬, 다음 리듬, 진행 상태가 시간과 완료 상태에 따라 갱신됩니다.

---

# **Architecture**

현재 구조:

```text
SwiftData
    ↓
SwiftDataRoutineRepository
    ↓
RoutineScheduleEngine
    ↓
TodayViewModel
    ↓
TodayView
```

향후 공통 표현 계층:

```text
RoutineScheduleEngine
    ↓
TodayRhythmSnapshot
    ├─ TodayView
    ├─ Live Activity
    ├─ Widget
    ├─ Apple Watch
    └─ Siri / App Intents
```

알림 구조:

```text
Feature / ViewModel
    ↓
NotificationScheduling
    ↓
NotificationService
    ↓
UNUserNotificationCenter
```

Views는 SwiftData, ActivityKit, UserNotifications 같은 인프라에 직접 접근하지 않습니다.

---

# **Technology Stack**

- Swift
- SwiftUI
- SwiftData
- MVVM
- Repository Pattern
- UserNotifications
- ActivityKit (Planned)
- WidgetKit (Planned)
- App Intents (Planned)
- iOS 17+

---

# **Project Structure**

```text
OneulRhythm
├── App
├── DesignSystem
├── Features
│   ├── Today
│   ├── Routines
│   └── Onboarding
├── Models
├── Services
├── Extensions
├── Resources
└── OneulRhythmApp.swift
```

프로젝트 루트 문서:

```text
README.md
AGENTS.md
DESIGN.md
ARCHITECTURE.md
ROADMAP.md
CHANGELOG.md
DECISIONS.md
.cursor/rules/oneulrhythm.mdc
```

---

# **Design Direction**

- 따뜻한 크림 배경
- 세이지 그린 포인트 컬러
- 넓은 여백
- 둥근 카드
- 차분한 한국어 문구
- Apple 스타일의 간결한 인터랙션
- 과도한 알림과 경고 표현 배제
- 실패나 놓침을 강조하지 않는 UX

---

# **Development Workflow**

```text
ChatGPT
    ↓
Sprint Planning
    ↓
Implementation Agent
    ↓
Build & Preview
    ↓
QA Agent
    ↓
Manual QA
    ↓
Git Commit
    ↓
Git Push
```

개발은 작은 Task와 하나의 리뷰 가능한 커밋 단위로 진행합니다.

---

# **Running**

Requirements:

- Xcode
- iOS 17+
- macOS development environment

Steps:

1. 저장소를 Clone합니다.
2. `OneulRhythm.xcodeproj`를 Xcode에서 엽니다.
3. iOS 시뮬레이터를 선택합니다.
4. 앱을 실행합니다.

---

# **Current Direction**

현재 개발의 중심은 다음과 같습니다.

```text
TodayRhythmSnapshot
    ↓
Live Activity Foundation
    ↓
Lock Screen UI
    ↓
Dynamic Island
    ↓
Interactive Completion
    ↓
Widget / Watch reuse
```

OneulRhythm의 목표는 사용자를 계속 호출하는 앱이 아니라, 사용자의 하루 곁에 조용히 머무는 앱이 되는 것입니다.
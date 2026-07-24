> **Archived**
>
> This document is retained for historical reference.
> It is not an active product, architecture, or implementation contract.

# Sprint 6-5 — Primary Rhythm Ownership

## Goal

Refine the Today experience so that exactly one Primary Rhythm is selected inside the Today Snapshot, reducing cognitive load while keeping Schedule Engine behavior unchanged.

## Completed

- Primary Rhythm selection owned by `TodayRhythmSnapshot`
- Priority: Current → Past Incomplete → Next
- TodayViewModel forwards snapshot primary state
- TodayView renders only the Primary Rhythm
- Live Activity mapper consumes snapshot `primaryRole`
- Schedule Engine, Repository, SwiftData models, and Activity lifecycle unchanged

## Architecture Decisions

- Presentation focus is a Snapshot responsibility, not a View or Schedule Engine responsibility.
- Only one routine may become the Primary Rhythm.
- Live Activity reads the same snapshot primary role for focus consistency with Today.

## QA Summary

- Requirement Analysis, Architecture Review, and Sprint Scope completed
- Implementation and Implementation Report completed
- Code Review completed
- Integration QA completed
- Manual Visual QA completed

## Lessons Learned

- Moving focus selection into the Snapshot keeps TodayView free of business decision logic.
- Keeping the Schedule Engine unchanged preserved recurrence and Live Activity contracts from earlier Sprints.
- Snapshot-owned primary state gives Today and Live Activity a shared focus source without duplicating priority rules in the ViewModel.

## Next Sprint

Sprint 6-6 — Notification Architecture

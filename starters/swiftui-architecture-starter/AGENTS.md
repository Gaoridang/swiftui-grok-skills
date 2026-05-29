# AGENTS.md — SwiftUI Architecture Guidelines

> **Guideline-oriented instructions** for working with the Feature-Sliced architecture in SwiftUI apps (iOS 18+, Swift 6+).
>
> This file is designed to be copied into real projects as a living document.

---

## Core Philosophy

We follow a **Feature-Sliced (Vertical Slice)** architecture.

**Key principle**: Organize code by *what the user does* (features), not by technical layers (Views / Models / Services).

This approach:
- Makes features easier to develop, test, and delete
- Reduces cognitive load
- Works extremely well with feature flags
- Scales better for medium-to-large apps

---

## Folder Structure Rules

- `App/` → Composition root only (DependencyContainer, RootView, app wiring)
- `Features/` → Self-contained vertical slices
- `Core/` → Shared, stable, cross-cutting concerns (never feature-specific logic)
- `DesignSystem/` → Reusable UI components and tokens

**Strict rule**: Feature-specific logic belongs in `Features/YourFeature/`, not in `Core/`.

---

## Feature Guidelines

When creating or modifying a feature:

1. Every feature should have at minimum:
   - `YourFeatureView.swift`
   - `YourFeatureModel.swift` (using `@Observable`)
   - `YourFeatureService.swift` (define a protocol first)

2. Depend on protocols, not concrete implementations.

3. Register feature factories in `App/DependencyContainer.swift`.

4. Keep the feature as self-contained as reasonably possible.

---

## Dependency Injection Rules

- Use the explicit `DependencyContainer` pattern.
- Never use global singletons for business logic.
- All dependencies must be injected (constructor injection preferred).
- SwiftUI views should receive dependencies via the environment or initializer when possible.

---

## State Management

- Prefer `@Observable` + `Observation` framework over `ObservableObject`.
- Models (not "ViewModels") own state and business logic for a feature.
- Keep observable models focused — they should not become god objects.

---

## Navigation

- Model navigation destinations as data (enums + `NavigationPath` or typed destinations).
- Keep navigation logic out of individual feature models when possible.
- Use a dedicated navigation coordinator/router in `App/` or `Core/Navigation/` for complex flows.

---

## Testing & Previews

- Every feature must be easy to preview and test in isolation.
- Use `InMemory` or mock implementations for services in previews/tests.
- Avoid tight coupling that makes features hard to instantiate without the full app.

---

## Relationship with Feature Flags

This architecture was intentionally designed to work well with feature flags:

- New features can live in their own `Features/` folder.
- Entire features can be built behind flags with minimal blast radius.
- Deleting a feature is usually just deleting its folder.

When working on a feature behind a flag, still follow the same architectural patterns.

---

## AGENTS.md Integration

All significant architectural decisions should be documented in the project's `AGENTS.md` under an **Architecture** section.

When the architecture evolves, update both this file (in the starter) and the project's `AGENTS.md`.

---

**Remember**: Consistency matters more than perfection. If you need to deviate from these guidelines, document why in `AGENTS.md`.

---

*This document is part of the `swiftui-architecture-starter` pattern.*
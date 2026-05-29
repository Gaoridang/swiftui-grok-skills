# SwiftUI Architecture Guidelines (2026)

This document describes the recommended architecture for SwiftUI applications targeting iOS 18+ and Swift 6.

## Core Philosophy

We follow a **Feature-Sliced / Vertical Slice** architecture rather than traditional layered MVVM.

### Why This Approach?

- **Features are independent** as much as possible → easier to develop, test, and delete.
- **Lower cognitive load** — when working on a feature, most relevant code lives together.
- **Better scalability** for medium to large apps.
- **Faster onboarding** — new developers can understand one feature without knowing the whole system.
- Plays very well with **Feature Flags** (you can build entire features behind flags with minimal blast radius).

## Guiding Principles

| Principle                    | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| **Features over Layers**    | Organize by what the user does, not by technical role (View / ViewModel / Service) |
| **Protocol-Oriented**       | Depend on protocols, not concrete implementations                           |
| **Observable First**        | Prefer `@Observable` + `Observation` over `ObservableObject` when possible  |
| **Dependency Direction**    | Features → Core. Never the reverse.                                         |
| **Explicit Dependencies**   | No global singletons. All dependencies are injected.                        |
| **Navigation as Data**      | Navigation state is modeled explicitly (enums + NavigationPath)             |
| **Testability by Default**  | Every feature should be easy to test in isolation                           |

## Recommended Folder Structure

```
YourApp/
├── App/                          # App entry point + composition root
│   ├── YourApp.swift
│   ├── RootView.swift
│   └── DependencyContainer.swift
│
├── Features/                     # Vertical feature slices
│   ├── ProductList/
│   │   ├── ProductListView.swift
│   │   ├── ProductListModel.swift     # @Observable model
│   │   └── ProductListService.swift   # Protocol + implementation
│   │
│   └── Checkout/
│       ├── CheckoutView.swift
│       ├── CheckoutModel.swift
│       └── CheckoutService.swift
│
├── Core/                         # Shared, stable, cross-cutting concerns
│   ├── Models/                   # Domain models used across features
│   ├── Services/                 # Protocols + implementations for shared services
│   ├── Networking/
│   ├── Persistence/
│   └── Navigation/               # Routers, navigation models
│
├── DesignSystem/                 # Reusable UI components & styling
│   ├── Components/
│   ├── Tokens/
│   └── Theme.swift
│
└── Resources/
```

## Key Patterns

### 1. Feature Model (instead of ViewModel)

```swift
@Observable
final class ProductListModel {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    
    private let service: ProductListService
    
    init(service: ProductListService) {
        self.service = service
    }
    
    func loadProducts() async { ... }
}
```

### 2. Feature Service Protocol

Every feature that talks to the outside world should define its own service protocol.

This keeps the feature self-contained and easy to mock.

### 3. Dependency Container

A simple, explicit container at the App level is preferred over heavy DI frameworks.

See `App/DependencyContainer.swift` in this starter.

### 4. Navigation

We model navigation destinations as enums.

This works extremely well with SwiftUI's `NavigationStack` and `navigationDestination(for:)`.

## Relationship with Feature Flags

This architecture was specifically designed to work well with feature flags:

- New features can live in their own folder behind a flag
- You can delete an entire feature folder with low risk
- Feature-specific services and models stay isolated

## When to Break the Rules

- Very small apps (< 5-6 screens) can use a simpler structure
- If your team has deep experience with **The Composable Architecture (TCA)**, that is also a valid choice
- Heavy use of Swift Packages for modularity may change the structure

## AGENTS.md Integration

All architecture decisions should be documented in the project's `AGENTS.md` file under an **Architecture** section. This is especially important when AI agents are helping with development.

---

**This architecture is opinionated but pragmatic.** It prioritizes long-term maintainability and developer velocity over purity.
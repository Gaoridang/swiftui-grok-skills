# SwiftUI Architecture Starter

This folder contains a recommended starting architecture for SwiftUI apps targeting iOS 18+ and Swift 6.

## Philosophy

See [ARCHITECTURE.md](./ARCHITECTURE.md) for the full explanation.

**Key idea**: Organize code by **feature** (vertical slices) rather than by technical layer.

## How to Use

1. Copy the structure into your new Xcode project.
2. Adapt the `DependencyContainer` to your real services.
3. Create new features inside the `Features/` folder following the `ProductList` example.
4. Keep shared models, services, and utilities in `Core/`.

## Recommended Pairings

This architecture works especially well when combined with:
- `setup-swiftui-feature-flags` → Build features behind flags with low risk
- `setup-swiftui-github` → Professional CI and contribution process

## Customization

This is a **strong starting point**, not a rigid framework. Feel free to evolve it as your app grows. The most important thing is consistency.

If your team strongly prefers **The Composable Architecture (TCA)**, you can still use the same high-level folder structure (`Features/`, `Core/`, etc.) with TCA inside the feature folders.
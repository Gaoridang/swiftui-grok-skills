# SwiftUI Feature Flags Starter (LaunchDarkly)

A reusable, production-oriented pattern for adding **type-safe feature flags** to SwiftUI iOS apps using LaunchDarkly.

Designed as a **copy-and-adapt initializer** for any modern SwiftUI app targeting iOS 18+ and Swift 6+.

## Goals

- Enable **fast deployment** with safe, controlled releases
- Keep feature flag usage **type-safe** and pleasant to work with in SwiftUI
- Make testing, previews, and QA overrides trivial
- Provide clear guidelines for AI agents (and humans) working in the codebase

## Why This Approach?

Feature flags let you:
- Deploy code to production frequently (even daily)
- Control *when* and *to whom* new features are visible
- Have instant kill switches
- Run experiments safely

This starter gives you a clean, maintainable foundation instead of scattering `LDClient.boolVariation(...)` calls everywhere.

## How to Use This as an Initializer

1. Copy the entire `Sources/FeatureFlags/` folder into your project (adjust the module name if needed).
2. Add the official LaunchDarkly SDK:
   ```swift
   .package(url: "https://github.com/launchdarkly/ios-client-sdk.git", from: "9.0.0")
   ```
3. Customize `LaunchDarklyConfiguration.swift` with your mobile key and context building logic.
4. Initialize the service early in your app (ideally in `App` or a dedicated `AppDelegate` / `UIApplicationDelegateAdaptor`).
5. Start defining flags in `FeatureFlag.swift`.

See the example files in `Sources/FeatureFlags/` for the recommended patterns.

## Recommended Folder Structure (After Copying)

```
YourApp/
└── FeatureFlags/
    ├── Core/
    │   ├── FeatureFlag.swift
    │   └── FeatureFlagService.swift
    ├── LaunchDarkly/
    │   ├── LaunchDarklyFeatureFlagService.swift
    │   └── LaunchDarklyClient.swift
    ├── SwiftUI/
    │   └── FeatureFlagEnvironment.swift
    └── Testing/
        └── FeatureFlagOverrides.swift
```

## Key Files

- `FeatureFlag.swift` — Single source of truth for all your flags (type-safe enum)
- `FeatureFlagService.swift` — Protocol that the rest of the app depends on
- `LaunchDarklyFeatureFlagService.swift` — Concrete implementation
- `FeatureFlagOverrides.swift` — In-memory overrides for tests, SwiftUI previews, and debug menus
- `FeatureFlagEnvironment.swift` — SwiftUI `Environment` integration

## Philosophy

This starter follows these principles (also documented in `AGENTS.md`):

- Type safety over convenience
- One canonical definition of each flag
- Easy overrides at every layer (tests > debug > remote)
- Clear ownership and lifecycle for every flag
- SwiftUI-friendly ergonomics without magic

## Next Steps

Read `AGENTS.md` — it contains the full set of guidelines for working with feature flags in this style. It is written to be used by AI coding agents as well as human developers.

---

**Target**: iOS 18+ • Swift 6+ • SwiftUI • LaunchDarkly

Feel free to evolve the patterns for your specific needs. The goal is a *good starting point*, not a rigid framework.
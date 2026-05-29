# AGENTS.md — SwiftUI Feature Flags with LaunchDarkly

> **Guideline-oriented instructions** for working with feature flags in SwiftUI iOS apps (iOS 18+, Swift 6+).
>
> This file is designed to be copied into real projects as a living document. It is intentionally **not overly prescriptive** — it favors good judgment over rigid rules.

---

## 1. Philosophy: Why We Use Feature Flags

We use feature flags primarily to **decouple deployment from release**.

- We want to deploy code to production frequently and safely.
- We want to control *who sees what* independently of when the code was shipped.
- We treat flags as a first-class part of the product architecture, not as a temporary hack.

**Core mental model**:
> Ship the code. Control the experience.

This enables:
- Faster iteration
- Lower-risk deployments
- Real experiments with measurable impact
- Instant kill switches for production issues

---

## 2. Core Principles (Apply These Always)

| Principle                        | What It Means                                                                 | Why It Matters                              |
|----------------------------------|-------------------------------------------------------------------------------|---------------------------------------------|
| **Type Safety First**            | Never use raw strings or `LDClient.boolVariation("some-flag", ...)` in app code | Prevents typos, enables refactoring, better autocomplete |
| **Single Source of Truth**       | All flags are defined in `FeatureFlag.swift`                                  | Everyone knows where to look                |
| **Override Everything**          | Support easy overrides at every layer (tests, previews, debug, QA)            | Critical for development velocity           |
| **Safe Defaults**                | Every flag must have a conservative, safe default                             | Protects users when remote service is down  |
| **Explicit Ownership**           | Every flag should have a clear owner and removal criteria                     | Prevents permanent technical debt           |
| **SwiftUI Ergonomics**           | Using flags in views should feel natural, not boilerplate-heavy               | Maintains UI code quality                   |
| **Testability**                  | Any view or logic using flags must be easy to test in isolation               | High confidence changes                     |

---

## 3. Recommended Architecture

We follow a layered approach (see the example files in `Sources/FeatureFlags/`):

1. **Definition Layer** (`Core/FeatureFlag.swift`)
   - Enum of all flags + metadata + safe defaults
   - This file is the contract between product, engineering, and AI agents

2. **Service Layer** (`Core/FeatureFlagService.swift`)
   - Protocol that the rest of the app depends on
   - Never depend directly on LaunchDarkly in feature code

3. **Implementation Layer**
   - `LaunchDarklyFeatureFlagService`
   - `InMemoryFeatureFlagService` (previews, tests, early boot)
   - `FeatureFlagServiceWithOverrides` (composition for debug/QA)

4. **Presentation Layer** (`SwiftUI/FeatureFlagEnvironment.swift`)
   - `Environment` values
   - Property wrappers (`@FeatureFlag`, `@FeatureFlagValue`)
   - View modifiers for conditional rendering

**Guideline**: When in doubt, add one more small, focused file rather than putting everything in one giant service.

---

## 4. Adding a New Feature Flag — Recommended Workflow

1. **Define the flag**
   - Add a clear case to `FeatureFlag` enum
   - Write a good `defaultValue`
   - Add a description + owner + planned removal condition as a comment

2. **Implement any necessary logic**
   - Use the service protocol, not LaunchDarkly directly
   - Prefer the property wrappers in SwiftUI views when possible

3. **Consider observability**
   - If the flag controls significant behavior, consider adding a listener so the UI can react live

4. **Document removal criteria**
   - Boolean flags should almost always have a removal plan
   - Config-style flags (numbers, strings) may live longer

5. **Add at least one preview or test** that exercises the flag in both states

**Strongly preferred**: Add the flag + one usage + one preview in the same pull request.

---

## 5. Naming Conventions

**Good names**:
- `newCheckoutFlow`
- `aiProductRecommendations`
- `realTimeOrderTracking`
- `maxCartItemsBeforeUpsell`

**Avoid**:
- `flag1`, `newFeature`, `experimentA`
- Overly cute names that won't make sense in 6 months

**Guideline**: If a PM or designer cannot understand what the flag does from the name and comment, rename it.

---

## 6. SwiftUI Integration Guidelines

### Preferred Ways to Use Flags in Views (in order)

1. **Property wrappers** (best for simple boolean checks)
   ```swift
   @FeatureFlag(.newCheckoutFlow) private var useNewCheckout
   ```

2. **View modifiers** (great for larger conditional branches)
   ```swift
   .featureFlag(.aiProductRecommendations) {
       AIRecommendationsView()
   }
   ```

3. **Direct service access** (only when you must evaluate outside a view, e.g. coordinators, view models)

### Anti-patterns
- Passing the entire `FeatureFlagService` down many view layers manually
- Evaluating flags deep inside `body` when the result never changes during the view's lifetime (cache it)
- Using `@State` or `@ObservedObject` just to hold flag values

---

## 7. Testing & Previews

**Every feature flag must be controllable in tests and previews.**

Recommended pattern:
- Use `FeatureFlagOverrides` + `FeatureFlagServiceWithOverrides`
- In SwiftUI previews, create a fresh override set and inject a wrapped service
- In unit tests, prefer `InMemoryFeatureFlagService` with explicit values

**Guideline**: If you cannot easily write a preview that shows the view with the flag both on and off, the integration is too complicated.

---

## 8. LaunchDarkly Specific Guidance (iOS)

- Initialize the client **as early as possible** (before the first screen renders).
- Build good `LDContext` objects. Context attributes are extremely powerful for targeting.
- Prefer **streaming** mode on iOS when the app is foregrounded.
- After login/logout or major user state changes, call `identify` (via `LaunchDarklyClient.identify` or the service's `refresh`).
- Use **custom events** (`trackEvent`) to connect flag exposures to your analytics/metrics.
- Be mindful of mobile data usage and battery — the default SDK configuration is usually reasonable.

**Swift 6 Note**: The LDClient singleton requires some care with concurrency. Keep heavy usage off the main actor where practical.

---

## 9. Lifecycle & Flag Debt Management

Feature flags are **technical debt by default**.

### Rules of thumb:
- Every boolean flag should have an intended removal date or condition documented.
- Config-style flags (numbers, JSON) can live longer but should still be reviewed quarterly.
- When a flag reaches 100% rollout and has been stable for a while, plan the removal work.
- AI agents must not introduce new flags without also documenting removal criteria.

**Good practice**: Once per quarter, do a "flag cleanup" pass. Remove flags that are fully rolled out or abandoned.

---

## 10. Common Pitfalls to Avoid

| Pitfall                                    | Better Approach                                      |
|--------------------------------------------|------------------------------------------------------|
| Using raw strings for flag keys            | Always go through the `FeatureFlag` enum             |
| Evaluating flags on every `body` redraw    | Use property wrappers or cache the value             |
| No safe default when LaunchDarkly is down  | Every flag must define a conservative default        |
| Forgetting to support overrides in tests   | Always compose with `FeatureFlagServiceWithOverrides`|
| Flags with no owner or removal plan        | Require comments on every new case in the enum       |
| Treating all flags the same                | Distinguish release flags, experiments, and config   |
| Checking the same flag in 8 different places | Centralize logic in a view model or coordinator when possible |

---

## 11. When to Use Build-Time Flags vs Runtime Feature Flags

Use **compile-time** (`#if DEBUG`, build configurations, `DEBUG` / `RELEASE`):
- Debug-only UI
- Logging levels
- Test-only behavior
- Things that must never ship to users

Use **runtime feature flags** (LaunchDarkly):
- Anything that needs to change after the binary is built
- Gradual rollouts
- Kill switches
- Experiments
- User or segment targeting

When in doubt, prefer runtime flags for anything user-facing.

---

## 12. Working With This Document

This AGENTS.md is meant to be **living guidance**, not law.

- If a pattern here becomes painful, improve the pattern and update this file.
- When adding new examples or better approaches, add them to the `Sources/FeatureFlags/` structure and reference them here.
- Feel free to evolve the taxonomy (more flag categories, different SwiftUI helpers, etc.) as the product matures.

---

**Remember the goal**: Fast, safe deployments with excellent developer experience.

If something makes shipping safer *and* more pleasant, it belongs here.

---

*This document is part of the `swiftui-feature-flags-starter` initializer pattern. Adapt it freely for your project.*
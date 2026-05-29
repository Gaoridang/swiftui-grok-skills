---
name: setup-swiftui-project
description: One-command professional bootstrap for a brand new SwiftUI iOS project. After the user manually creates the Xcode project, this skill runs the complete recommended sequence (github → agents → architecture → feature-flags) in the correct order in a single session. Collects all answers upfront, creates all folders and files safely, and produces a fully initialized project with excellent AGENTS.md as the index. The recommended starting point for new projects.
---

# Setup SwiftUI Project (Full Professional Bootstrap)

**This is the recommended entry point for any new SwiftUI iOS project.**

**Critical prerequisite**: You must have already created the project manually in Xcode using `File > New > Project > iOS > App` (SwiftUI + SwiftData or SwiftUI + Core Data is fine). This skill is an **integrator**, not a project creator.

## What This Skill Does

It executes the full professional setup sequence in the exact recommended order:

1. **setup-swiftui-github** — Modern GitHub hygiene (CI with macos-26 + Xcode 26.5 + caching, templates, Dependabot, CONTRIBUTING.md, etc.)
2. **setup-swiftui-agents** — Creates `AGENTS.md` as the central living index + `docs/swift-build-settings.md` with 2026 Swift 6.3 / Xcode 26.5 recommendations.
3. **setup-swiftui-architecture** — Feature-Sliced architecture (`App/`, `Features/`, `Core/`, `DesignSystem/`) with RootView, DependencyContainer, and one example vertical slice.
4. **setup-swiftui-feature-flags** — Production-ready, type-safe LaunchDarkly integration (with excellent SwiftUI ergonomics and test doubles).

All steps follow the strict **XCODE_FIRST_GUIDELINES.md** rules (merge-only where appropriate, never delete user content, safe to re-run, clear communication).

## When to Use

- Immediately after creating a brand new SwiftUI project in Xcode 26.5+.
- When you want the fastest way to get a production-grade, AI-friendly project structure with one command.
- For solo or small-team projects where you want professional foundations from minute one.

**Do not use** this on large existing codebases without discussion.

---

## Step-by-Step Workflow (One Session)

### Step 1: Project Discovery

- Locate the `.xcodeproj`.
- Identify the main app target name / scheme (e.g. "Skylog").
- Note the current `@main` App struct file.
- Check what already exists (`AGENTS.md`, `.github/`, `docs/`, etc.).

### Step 2: Gather All Information Upfront (One or Two Messages)

Ask the user these questions (group them logically):

**Project Identity**
- App / scheme name (e.g. "Skylog", "Aether")
- Display name (for docs and comments)

**GitHub & CI**
- Do you want full CI (build + tests) or build-only for now?
- Will you use SwiftLint / SwiftFormat?
- Solo project or do you expect contributors?

**Architecture**
- Confirm Feature-Sliced (App/Features/Core/DesignSystem) — this is the default and recommended.
- Do you want a small **example feature** included so you can see the pattern immediately? (highly recommended)
- Any strong navigation preference already? (NavigationStack + enums is the default here)

**Feature Flags**
- Do you plan to use LaunchDarkly (or another provider later)? We will set up a clean, swappable system either way.
- Do you already have the LaunchDarkly SDK in the project?

**General**
- Preferred location for new top-level folders (`App/`, `Features/`, etc.) — default is project root (strongly recommended).
- Any existing `AGENTS.md` content you must preserve?

Store all answers. You will use them to customize every file.

### Step 3: Execute in Strict Order

#### 3.1 GitHub Hygiene (from setup-swiftui-github)
- Create/update `.github/workflows/ci.yml` (modern macos-26 + setup-xcode + irgaly cache + xcbeautify + signing disabled for tests).
- Create PR template, issue templates, dependabot.yml.
- Merge high-quality `.gitignore` entries.
- Create `CONTRIBUTING.md` (if missing).
- Create or lightly enhance `README.md`.

#### 3.2 AGENTS.md + Build Settings (from setup-swiftui-agents)
- Create `docs/` folder at project root.
- Create `docs/swift-build-settings.md` with the full 2026 guidance (Swift 6.3, iOS 18.0 min, Complete concurrency, Approachable Concurrency features, Main Actor default, philosophy about keeping project settings reasonable while writing modern code).
- Create or enhance `AGENTS.md` as the **central index** with links to:
  - Build Settings
  - GitHub & Contribution Workflow
  - Architecture
  - Feature Flags
- Add a strong "How to use this file" section at the top.

#### 3.3 Architecture — Feature-Sliced (from setup-swiftui-architecture)
Create at project root (unless user chose otherwise):

```
App/
  DependencyContainer.swift
  RootView.swift
Features/
  ExampleFeature/          (only if user requested an example)
    ExampleFeatureView.swift
    ExampleFeatureViewModel.swift
Core/
  (shared utilities, models, protocols)
DesignSystem/
  (tokens + reusable components — start minimal)
```

- Update the main `YourApp.swift` to use `RootView` (safely — show diff or proposed change first).
- Create a clean `DependencyContainer` as the composition root (simple `@Observable` or class with factories).
- If example feature requested: create one small, well-commented vertical slice that demonstrates the pattern.
- Append a high-quality **Architecture** section to `AGENTS.md`.

#### 3.4 Feature Flags (from setup-swiftui-feature-flags)
Create at project root:

```
FeatureFlags/
  Core/
    FeatureFlag.swift          (type-safe enum + string keys)
    FeatureFlagService.swift   (protocol)
  LaunchDarkly/
    LaunchDarklyFeatureFlagService.swift
    ...
  SwiftUI/
    FeatureFlagEnvironment.swift   (excellent @Environment + ViewModifier ergonomics)
  Testing/
    InMemoryFeatureFlagService.swift
    FeatureFlagOverrides.swift
```

- Provide a swappable design so you can use in-memory overrides in previews/tests and the real LaunchDarkly service in production.
- Append a **Feature Flags** section to `AGENTS.md` explaining the philosophy (safe deployments, type safety, no stringly-typed flags).

### Step 4: Final Index Update & Consistency Pass

- Re-read the final `AGENTS.md`.
- Ensure the Index at the top correctly links to all four major areas.
- Make sure any cross-references are consistent.

### Step 5: User Communication & Next Steps (Critical)

Give the user a very clear, structured final message:

**✅ Full professional bootstrap complete for {{APP_NAME}}**

**What was created:**
- List of all new folders and key files

**Manual Xcode steps you must do now:**
- Create Groups in the navigator for `App/`, `Features/`, `Core/`, `DesignSystem/`, `FeatureFlags/`, `docs/`
- (Optional) Delete or archive the old default `ContentView.swift`

**Immediate next actions:**
- Add any needed SPM packages (LaunchDarkly SDK if using real flags)
- Initialize the services in the App struct or DependencyContainer
- Open `AGENTS.md` and read it — it must stay in context for all future work

**Recommended follow-up:**
- Run individual skills later if you want to add more (e.g. a second real feature using the architecture pattern).
- Keep `AGENTS.md` at the very top of every agent conversation.

---

## Embedded High-Quality Templates

This skill contains self-contained, modern Swift 6 versions of the key files so it works without external local starter paths.

### Architecture Templates (Feature-Sliced)

**App/DependencyContainer.swift**
```swift
import SwiftUI
import Observation

@Observable
final class DependencyContainer {
    // MARK: - Services
    let featureFlagService: FeatureFlagService
    
    // MARK: - Feature ViewModels / Use Cases (lazy or factory)
    // Example:
    // func makeSkyLogViewModel() -> SkyLogViewModel { ... }
    
    init(featureFlagService: FeatureFlagService = LaunchDarklyFeatureFlagService()) {
        self.featureFlagService = featureFlagService
    }
}
```

**App/RootView.swift**
```swift
import SwiftUI

struct RootView: View {
    @State private var container = DependencyContainer()
    
    var body: some View {
        // Main navigation / tab structure goes here
        ContentView()
            .environment(\.featureFlagService, container.featureFlagService)
            // Inject other dependencies as needed
    }
}
```

(Plus a small example feature if requested, and a brief `ARCHITECTURE.md` in `docs/` or root.)

### Feature Flags Templates

The skill embeds clean versions of:
- `FeatureFlag.swift` (type-safe)
- `FeatureFlagService.swift` protocol
- LaunchDarkly implementation (with clear comments on how to finish wiring)
- `FeatureFlagEnvironment.swift` (the beautiful SwiftUI part)
- In-memory test double

These are written with the same high standards as the standalone `setup-swiftui-feature-flags` skill.

---

## Relationship to the Individual Skills

- You can still run `/setup-swiftui-github`, `/setup-swiftui-agents`, etc. individually later.
- This meta-skill simply runs their logic in the correct order with shared context, which is dramatically more convenient for greenfield projects.
- Any future improvements to the individual skills can be reflected here over time.

**End of Skill**

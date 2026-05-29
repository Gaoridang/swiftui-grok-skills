---
name: setup-swiftui-architecture
description: Runs after the user has manually created a new iOS SwiftUI project in Xcode (iOS 18+, Swift 6+). Integrates a modern Feature-Sliced architecture (App/, Features/, Core/, DesignSystem/) into the existing project. Updates the App entry point, adds an example feature, and contributes to AGENTS.md. Designed to work especially well with the feature-flags skill.
---

# Setup SwiftUI Architecture

**Important**: Before running this skill, read `XCODE_FIRST_GUIDELINES.md` (located in the skills folder). This skill is designed for Xcode-first workflows.

## Important Notes for This Skill

- This skill is intended to be run on a project the user created normally in Xcode.
- It will update the existing `YourApp.swift` rather than creating a duplicate entry point.
- It will append an Architecture section to `AGENTS.md` (or create one).
- It is safe to run more than once (it checks for existing folders).

## Purpose

This skill integrates a strong architectural foundation into a project the user has already created in Xcode.

It uses a **Feature-Sliced (Vertical Slice)** architecture. See `XCODE_FIRST_GUIDELINES.md` for the integration rules this skill follows.

## When to Use

- Right after creating a new Xcode SwiftUI project
- When starting a new feature-rich app where you expect the codebase to grow
- When you want architecture that works *beautifully* with feature flags
- Before writing significant production code

## Recommended Philosophy (Do Not Skip)

This skill is based on these core beliefs:

- Organize by **what the user does** (features), not by technical role (Views / Models / Services).
- Features should be as self-contained as reasonably possible.
- Use `@Observable` + protocols heavily.
- Make dependency injection explicit and simple.
- Navigation should be modeled as data.

Read `ARCHITECTURE.md` in the canonical starter for the full reasoning.

---

## Step-by-Step Workflow

### Step 1: Discover the Project (Xcode-First Mode)

This skill is designed for projects the user created manually in Xcode first.

1. Confirm there is a `.xcodeproj` or `.xcworkspace`.
2. Identify the **main app target folder** (the folder containing `Name.swift` where the name matches the project).
3. Note the existing entry point (usually `ContentView.swift` and/or `YourApp.swift`).
4. Check if `AGENTS.md` already exists.
5. Read the shared guidelines in `XCODE_FIRST_GUIDELINES.md` for placement and update rules.

**Default placement recommendation**: Create `App/`, `Features/`, `Core/`, and `DesignSystem/` at the **project root** (same level as the main app target folder). This is the cleanest long-term approach.

### Step 2: Ask Important Questions

Ask the user:

1. Do you want the **recommended Feature-Sliced architecture**, or are you strongly leaning toward **The Composable Architecture (TCA)**?
2. Do you already have a preferred navigation pattern? (NavigationStack + enums, Coordinator, TCA, etc.)
3. Should we create a small example feature (e.g. `ProductList`) so you can see the pattern in action?
4. Do you want me to also update/create the `AGENTS.md` with an **Architecture** section?
5. Quick check: Does `AGENTS.md` already exist in the project?

### Step 3: Create the Folder Structure

Follow the recommendations in `XCODE_FIRST_GUIDELINES.md`.

Default structure to create at the project root:

```
App/                    ← Composition root (DependencyContainer + RootView)
Features/               ← Vertical feature slices
Core/                   ← Shared models, services, utilities
DesignSystem/           ← Reusable UI components & tokens
```

Always confirm the location with the user if they have a strong preference.

### Step 4: Scaffold Core Files

Use the canonical templates from:

**`C:\Users\USER\Desktop\test\swiftui-architecture-starter\`**

Preferred method:
- Read the files from the starter using `read_file`
- Adapt them for the user's actual app name
- Write them into the project

Key files to create:
- `App/DependencyContainer.swift`
- `App/RootView.swift` (or modify existing entry point)
- Example feature under `Features/` (highly recommended)
- `ARCHITECTURE.md` (or add it to the project docs)

### Step 5: Update AGENTS.md

Add a high-quality **Architecture** section to the project's `AGENTS.md`.

This is critical so that future AI sessions understand the intended structure and don't create architectural drift.

### Step 6: Safety, Idempotency & User Communication

Follow `XCODE_FIRST_GUIDELINES.md` (especially the Safety & Idempotency and User Communication Requirements sections).

### Step 7: Provide Next Steps

Give the user:

1. Clear summary of created vs modified files (especially the update to `YourApp.swift`).
2. Manual Xcode steps (creating Groups for `App/`, `Features/`, `Core/`, `DesignSystem/`). 
3. Guidance on the old `ContentView.swift`.
4. How this architecture pairs extremely well with the feature flags skill.
5. Offer to immediately create the first real feature using the new pattern.

---

## Canonical Source of Truth

All high-quality reference files live here:

**`C:\Users\USER\Desktop\test\swiftui-architecture-starter\`**

The skill should prefer reading from this folder (especially `ARCHITECTURE.md`, `DependencyContainer.swift`, and the `ProductList` example feature).

---

## Final Output Format

After scaffolding, respond with something like:

**"✅ Architecture scaffolding complete for {{APP_NAME}} (Xcode-first integration)."**

Then provide:

1. Clear summary of what was created and what was modified.
2. **Important**: List any manual steps the user should do in Xcode (e.g. creating Groups in the navigator for `App/`, `Features/`, etc.).
3. Note about the old `ContentView.swift` (can usually be deleted later).
4. How this architecture pairs with the feature flags skill.
5. Offer to create the first real feature following the new pattern right now.

---

**End of Skill**
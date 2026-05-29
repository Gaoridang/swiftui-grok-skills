---
name: setup-swiftui-feature-flags
description: Runs after the user has manually created a new iOS SwiftUI project in Xcode (iOS 18+, Swift 6+). Integrates a production-grade LaunchDarkly feature flag system (with type-safe definitions and excellent SwiftUI ergonomics) into the existing project. Creates or appends to AGENTS.md. Designed for fast, safe deployments.
---

# Setup SwiftUI Feature Flags (LaunchDarkly)

**Important**: Before running this skill, read `XCODE_FIRST_GUIDELINES.md`. This skill is built for Xcode-first usage.

## Important Notes for This Skill

- This skill is designed to be safe to run more than once.
- It will append to an existing `AGENTS.md` instead of replacing it.
- It will not overwrite existing feature flag code unless the user explicitly confirms.

## Purpose

This skill integrates a production-grade feature flag system into a SwiftUI project the user has already created in Xcode. It follows the Xcode-first integration rules in `XCODE_FIRST_GUIDELINES.md`.

## When to Use This Skill

- User just ran "Create new Xcode project" with SwiftUI + iOS
- User mentions wanting feature flags, LaunchDarkly, or "fast deployment" setup
- User wants an `AGENTS.md` tailored for a SwiftUI project

**Do not use** for existing large projects without explicit confirmation (migration is more involved).

---

## Step-by-Step Workflow (Follow Strictly)

### Step 1: Discover the Project (Xcode-First)

This skill runs after the user has manually created the project in Xcode.

1. Find the `.xcodeproj`.
2. Identify the main app target folder.
3. Check if `AGENTS.md` already exists.
4. Read `XCODE_FIRST_GUIDELINES.md` for placement and update rules.

**Recommended default**: Place the `FeatureFlags/` folder at the **project root** (same level as the main app target). This keeps it clean and makes it easier to turn into a Swift Package later.

Confirm with the user if they have a different preference.

### Step 2: Gather Context (Ask These Questions)

Ask the user (one message is fine):

- What is the **display name** of the app? (e.g. "Aether", "Taskly")
- Do they already have the LaunchDarkly SDK added via Swift Package Manager?
- Any preference on folder location? (default to project root `FeatureFlags/`)
- Do they want the generated `AGENTS.md` to be quite detailed or more concise?
- Check current state: Does `AGENTS.md` already exist? Any other feature flag related code?

Store the app name — it will be used to customize comments in the generated files and the AGENTS.md.

### Step 3: Create the Folder Structure

Create the following structure under the chosen root:

```
FeatureFlags/
├── Core/
│   ├── FeatureFlag.swift
│   └── FeatureFlagService.swift
├── LaunchDarkly/
│   ├── LaunchDarklyConfiguration.swift
│   ├── LaunchDarklyFeatureFlagService.swift
│   └── LaunchDarklyClient.swift
├── SwiftUI/
│   └── FeatureFlagEnvironment.swift
└── Testing/
    ├── FeatureFlagOverrides.swift
    └── InMemoryFeatureFlagService.swift
```

### Step 4: Write All Source Files (Preferred Method)

**Best approach**: Use the canonical high-quality files from the local initializer as the source of truth:

Path: `C:\Users\USER\Desktop\test\swiftui-feature-flags-starter\Sources\FeatureFlags\`

For each file:
1. Read the original file using `read_file` tool.
2. Lightly customize it (replace generic comments with the user's actual app name where it makes sense).
3. Write it into the target location in the user's new Xcode project using the `write` tool.

This ensures the user always gets the most up-to-date, refined versions of the code.

### Step 5: Handle AGENTS.md

Follow the rules in `XCODE_FIRST_GUIDELINES.md`.

**Preferred behavior**:
- If `AGENTS.md` already exists → Append a strong "Feature Flags" section (do not overwrite).
- If it does not exist → Create a high-quality `AGENTS.md` using the canonical version from the starter as a base, customized for the project.

Always prefer appending over replacing when the file already exists.

### Step 6: Safety, Idempotency & User Communication

Follow `XCODE_FIRST_GUIDELINES.md` strictly, especially:
- Safety & Idempotency rules
- File Update Strategy
- User Communication Requirements

### Step 7: Provide Clear Next Steps to the User

After scaffolding, give the user:

1. Clear summary of what was created vs appended.
2. Manual Xcode steps (e.g. adding `FeatureFlags/` as a Group).
3. Next practical actions (add SPM, initialize the service in the App struct, etc.).
4. Reminder about keeping `AGENTS.md` in context for future sessions.
5. Offer to help with initialization code or a debug menu immediately.

---

## Canonical Source of Truth

All the best, most up-to-date file content lives in the canonical starter:

**`C:\Users\USER\Desktop\test\swiftui-feature-flags-starter\`**

**Strongly preferred behavior**:
- Use `read_file` to load the real files from the starter folder.
- Adapt them lightly for the user's app name.
- Write them into the new project.

This approach keeps the skill maintainable and ensures users always get the highest quality versions.

---

## Final Output to User

After everything is created successfully, reply with:

**"✅ Feature flags + AGENTS.md successfully initialized for {{APP_NAME}}."**

Follow with a clean, actionable "Next Steps" list, and offer to help with initialization code or the first real flags right away.

Always end by reminding the user:
- What was created vs appended.
- Any manual Xcode steps (e.g., adding the new `FeatureFlags/` folder as a Group in the navigator).
- The next practical steps (adding the LaunchDarkly SDK, initializing the service in the App struct, etc.).
- That future sessions should keep `AGENTS.md` in context so the guidelines are followed.

---

**End of Skill**
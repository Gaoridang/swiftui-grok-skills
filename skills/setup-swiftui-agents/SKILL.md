---
name: setup-swiftui-agents
description: Creates or enhances AGENTS.md as the central living index for the project. Seeds a docs/ folder with detailed Swift/Xcode build settings (2026 recommendations) and other key guidance files. AGENTS.md becomes the single source of truth that links to all other .md files (build settings, architecture, GitHub workflow, etc.). Follows Xcode-first safe merge rules. Run this early for any new SwiftUI project.
---

# Setup SwiftUI Agents (AGENTS.md as Central Index)

**Important**: Before running, read `XCODE_FIRST_GUIDELINES.md`. This skill follows the same Xcode-first, merge-only, never-delete rules.

## Purpose

Every professional SwiftUI project that uses AI agents (or has multiple contributors) benefits from a single, well-organized `AGENTS.md` at the root. This file acts as the **index and entry point** for all project conventions, architecture decisions, and tooling guidance.

This skill:
- Creates `AGENTS.md` (or safely enhances an existing one)
- Creates a `docs/` folder (recommended location for detailed guides per XCODE_FIRST_GUIDELINES)
- Seeds `docs/swift-build-settings.md` with the current 2026 professional recommendations (Swift 6.3, Xcode 26.5, iOS 18.0 minimum, strict concurrency, etc.)
- Makes `AGENTS.md` a clean, scannable index with links to all other important `.md` files
- Appends the GitHub contribution section if the github skill has already run

## When to Use

- Right after creating a new project in Xcode (often right after or together with `setup-swiftui-github`)
- When you want a single source of truth so future Grok / Claude / Cursor sessions stay consistent with your decisions
- Before starting architecture work (the architecture skill can then update the index)
- Any time you add a major new concern (feature flags, testing strategy, CI rules, etc.)

---

## Step-by-Step Workflow

### Step 1: Discovery

- Confirm the project root (look for `.xcodeproj`).
- Check if `AGENTS.md` already exists and its current structure/sections.
- Check if a `docs/` folder (or similar) already exists.
- Note any existing detailed `.md` files in the repo.

### Step 2: Ask Clarifying Questions

1. Do you want the detailed guides in a `docs/` folder at the project root? (recommended)
2. Should I include a **Swift/Xcode Build Settings** section right away? (strongly recommended for Swift 6+ projects)
3. Are there any other index sections you want seeded now? (e.g. Architecture, Testing Strategy, Feature Flags, Design System)
4. Do you already have an `AGENTS.md` with specific content I must preserve?
5. Preferred style: concise index + links, or more prose in the main file?

### Step 3: Create docs/ Folder and Build Settings File (if chosen)

- Create `docs/` at project root (alongside the Xcode target folders — this is the preferred location for new top-level documentation).
- Create `docs/swift-build-settings.md` containing the researched, up-to-date 2026 guidance.
- The content is designed so you can keep the Xcode project settings relatively loose during early development while still enforcing modern code style in AGENTS.md.

### Step 4: Create or Enhance AGENTS.md as the Index

If `AGENTS.md` does not exist:
- Create it with a standard header + clear index structure.

If it exists:
- Append new sections only (never overwrite).
- Add or update an `## Index` / table-of-contents block near the top.
- Add the new linked files.

Always ask before replacing an existing section with the same heading.

### Step 5: Update Cross-References

- Make sure the new build settings file links back to `AGENTS.md`.
- If `setup-swiftui-github` has already added the GitHub workflow section, ensure it appears in the index.
- Add placeholder links for skills the user plans to run next (architecture, feature-flags).

### Step 6: Final Summary

Tell the user exactly:
- What was created vs appended
- The new file locations
- How to keep the index up to date going forward
- Reminder that `AGENTS.md` should be the first thing in context for all future agent sessions on this project

---

## File Templates

### 1. docs/swift-build-settings.md (Detailed 2026 Recommendations)

```markdown
# Swift / Xcode Build Settings

**Last updated:** 2026-05-29  
**Applies to:** All new SwiftUI iOS projects in this repo

## Current Recommended Baseline (Greenfield Projects)

- **Swift Language Version**: 6.0 (or 6.3)
- **iOS Deployment Target**: 18.0 (or 18.6 for a slightly more modern baseline)
- **Xcode**: 26.5+
- **Build against**: Latest SDK (iOS 26.5 via Xcode 26.5)

## Key Build Settings (Target Level)

| Setting                              | Recommended Value          | Rationale |
|--------------------------------------|----------------------------|---------|
| Swift Language Version               | 6.0                        | Enables full Swift 6 mode and strict concurrency by default |
| iOS Deployment Target                | 18.0 (or 18.6)             | Good balance of reach + modern SwiftUI APIs. Never use 26.x as minimum for general apps |
| Strict Concurrency Checking          | Complete                   | Treat data-race safety violations as errors |
| Upcoming Features (Approachable Concurrency) | Yes (enable)        | `InferSendableFromCaptures`, `NonisolatedNonsendingByDefault`, etc. |
| Default Actor Isolation (main target)| Main Actor                 | Drastically reduces `@MainActor` boilerplate on UI code |
| Compilation Mode (Release)           | Whole Module               | Better optimization |

## Philosophy (Important)

We deliberately keep the Xcode project file settings reasonable but not overly aggressive during early development. 

**However**: All new code written in this project **must** follow full modern Swift 6+ idioms:
- Actors and `@MainActor`
- Structured concurrency (`async`/`await`, `Task`, `async let`)
- Proper `Sendable` conformance
- Isolation-aware design

The compiler settings above make the strictest rules active. Even if you temporarily relax a setting for migration, never write new code that would be rejected under "Complete" checking.

## References
- [AGENTS.md](../AGENTS.md)
- Apple: Adopting strict concurrency in Swift 6
- WWDC 2025 sessions on SwiftUI and concurrency
```

### 2. AGENTS.md (Initial Index Version)

```markdown
# AGENTS.md — {{APP_NAME}}

This is the single source of truth for all AI coding agents (Grok, Claude, Cursor, etc.) working on this project.

**Always read this file first** at the start of every session.

## Index

- [Swift / Xcode Build Settings](docs/swift-build-settings.md)
- [GitHub & Contribution Workflow](#github--contribution-workflow)
- [Architecture](#architecture) *(to be added by setup-swiftui-architecture)*
- [Feature Flags](#feature-flags) *(to be added by setup-swiftui-feature-flags)*
- [Testing Guidelines](#testing-guidelines) *(placeholder)*

## Project Philosophy

- Calm, high-quality SwiftUI iOS app (iOS 18+)
- Modern Swift 6+ with strict concurrency thinking
- Xcode-first workflow + skills for repeatable professional setup
- Private by default, minimal anxiety for users

## GitHub & Contribution Workflow

*(This section is usually appended by the `/setup-swiftui-github` skill)*

- Work on short-lived branches from `main`
- Every PR must pass CI (macos-26 + Xcode 26.5)
- Use the PR and issue templates
- Update this `AGENTS.md` when making significant changes

## How to Keep This Document Healthy

- When you introduce a new major concern (new architecture layer, new tool, new CI job, etc.), add or update the relevant section **and** add it to the Index above.
- Prefer linking to dedicated files in `docs/` for anything longer than ~30 lines.
- Run `/setup-swiftui-agents` again if you want to re-seed or reorganize the index.

---

**End of core index. Add more sections below as the project grows.**
```

---

## Final Notes for the Agent Running This Skill

- This skill is intentionally lightweight and focused on the **indexing role** of `AGENTS.md`.
- The actual detailed content for architecture, feature flags, etc. will be filled by the other skills or by hand.
- Always follow the merge/append rules from `XCODE_FIRST_GUIDELINES.md`.
- After running, remind the user to put `AGENTS.md` at the very top of the context for all future work on this project.

**End of Skill**

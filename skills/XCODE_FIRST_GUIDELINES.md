# Xcode-First Integration Guidelines (For All Skills)

This document defines the expected behavior when skills run on a project that the user created manually in Xcode.

## Core Principle

**The user always creates the Xcode project first.** Skills are "integrators", not "creators from scratch".

## Standard Project Layout (After User Creates in Xcode)

```
MyApp/
├── MyApp.xcodeproj/
├── MyApp/                    ← Main app target (keep mostly as-is)
│   ├── MyApp.swift
│   ├── ContentView.swift
│   └── Assets.xcassets/
├── MyAppTests/
├── MyAppUITests/
├── .gitignore (optional)
└── README.md (optional)
```

## Recommended Placement for New Folders

**Default: Place new top-level folders at the project root** (same level as `MyApp/`, `MyAppTests/`, etc.):

- `App/` (composition root, DependencyContainer, RootView)
- `Features/`
- `Core/`
- `DesignSystem/`
- `FeatureFlags/`

**Rationale**:
- Keeps the original Xcode target folder clean.
- Makes it much easier to extract modules into Swift Packages later.
- Reduces merge conflicts in the main target.

**Exception**: Very small utility folders can sometimes live inside the main target if strongly preferred by the user.

## Discovery Rules (Every Skill Should Do This)

1. Find the `.xcodeproj` or `.xcworkspace`.
2. Identify the main app target folder (usually the one with `Name.swift` where Name matches the project).
3. Check for existing:
   - `AGENTS.md`
   - `.gitignore`
   - `README.md`
   - Existing architecture/flag folders
4. Detect the scheme name (usually same as main target).

## File Update Strategy

| File Type              | Behavior                                                                 |
|------------------------|--------------------------------------------------------------------------|
| `YourApp.swift`        | Prefer updating the `@main` App struct to use new RootView + container   |
| `AGENTS.md`            | Always append new sections using clear headings. Never overwrite the whole file. |
| `.gitignore`           | Merge additions only. Never remove or rewrite user's existing rules.     |
| `README.md`            | Create only if missing or extremely minimal. Otherwise append a small section. |
| Existing folders       | Never delete or restructure. Add new folders alongside.                  |

## Safety & Idempotency Rules

- Skills must be safe to run more than once.
- Before creating a file/folder, check if it already exists.
- When appending to `AGENTS.md`, check if a similar section heading already exists. If it does, ask the user before overwriting that section.
- Never delete user files without explicit confirmation.
- When modifying `YourApp.swift`, show the diff or proposed change to the user before writing.

## User Communication Requirements

Every skill **must** clearly communicate the following at the end:

1. **What was done** — List files/folders created, modified, or merged.
2. **Manual Xcode steps** — Explicitly tell the user what they should do in Xcode's navigator (creating Groups, moving files into folders, etc.).
3. **Cleanup guidance** — Mention any old default files (like `ContentView.swift`) that can potentially be removed later.
4. **Next practical steps** — What the user should do immediately after the skill finishes (e.g. add SPM packages, initialize services, commit changes).
5. **AGENTS.md reminder** — Remind them to keep `AGENTS.md` in context for future sessions.

## AGENTS.md Contribution Pattern (Important)

All skills should follow this convention when contributing to `AGENTS.md`:

- Use clear `##` level headings.
- Prefer appending at the end rather than inserting in the middle.
- If a section with the same heading already exists, **ask the user** before replacing it.
- Good example headings:
  - `## Architecture`
  - `## Feature Flags`
  - `## GitHub & Contribution Workflow`
  - `## Testing Guidelines`

Keep the file as one coherent, living document rather than a collection of disconnected sections.

## Common Questions to Ask User

- Preferred location for new folders (default = project root)
- Whether they want an example feature / module included
- Whether to update or create `AGENTS.md`

---

**Follow these rules when refactoring or creating new skills.**
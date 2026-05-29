---
name: setup-swiftui-github
description: Runs after the user has manually created a new iOS SwiftUI project in Xcode targeting iOS 18+ / Swift 6.3+. Professionally configures GitHub for the project: modern CI (macos-26 + Xcode 26.5 via setup-xcode + caching), .gitignore, PR/issue templates, Dependabot, high-quality README + CONTRIBUTING, and AGENTS.md contribution workflow section. Uses safe merge strategies only. Xcode-first and idempotent. Pure GitHub hygiene skill — never touches Xcode project files or build settings.
---

# Setup SwiftUI GitHub (Professional Project Initialization)

**Important**: Before running this skill, read `XCODE_FIRST_GUIDELINES.md` (from the swiftui-grok-skills package). This skill follows Xcode-first integration rules (merge instead of overwrite, discover existing structure, never delete user work).

## Important Notes for This Skill

- **Idempotent and safe**: Safe to run multiple times. Merges `.gitignore` and `AGENTS.md`; creates `.github/` and supporting docs only if missing or minimal.
- **Always respects existing customizations**.
- **2026 modern baseline**: Targets Swift 6.3 language mode, Xcode 26.5, iOS 18.0 minimum deployment (build against latest SDK), professional GitHub Actions with caching and reliable Xcode selection.
- References the canonical patterns from https://github.com/Gaoridang/swiftui-grok-skills.

## Purpose

Add production-grade GitHub configuration and contribution standards to a SwiftUI iOS project the user created manually in Xcode. This is the first skill most people should run after `File > New > Project` for any serious app.

It covers the things that are tedious to get right but have huge long-term payoff:
- Version control hygiene (`.gitignore` that actually works)
- Reliable CI that catches real problems without false negatives
- Clear, low-friction contribution process
- Automated dependency updates (Dependabot)
- Living documentation + AGENTS.md integration so future AI sessions and human contributors stay aligned

## When to Use This Skill

- Right after creating a new SwiftUI project in Xcode 26+ and before the first `git push`
- When you want GitHub Actions CI that actually works on the latest runners without constant maintenance
- For solo or small-team projects that still want professional standards
- Perfect complement to `setup-swiftui-architecture` and `setup-swiftui-feature-flags`

**Avoid** for massive brownfield repos without explicit discussion.

---

## Step-by-Step Workflow

### Step 1: Project Discovery (Xcode-First)

- Locate the `.xcodeproj` (or `.xcworkspace`).
- Identify the primary app target name and scheme (usually matches the folder / `AppName.swift`).
- Inventory existing files:
  - `.git/` present?
  - `.gitignore`?
  - `README.md` (length and quality)?
  - `AGENTS.md`?
  - Any `.github/` already?
- Read the local `XCODE_FIRST_GUIDELINES.md` (or the one from the skills package) for merge rules.

Ask the user to confirm the scheme name if ambiguous.

### Step 2: Ask Clarifying Questions (One Message)

1. **Scheme / target name** (required for all CI jobs).
2. Do you want **basic build-only CI** or **full build + unit + UI test** jobs from day one?
3. Will you use **SwiftLint** and/or **SwiftFormat**? (we can add lint job + config skeletons).
4. Solo project or do you expect external contributors / PRs?
5. Should I create or enhance `AGENTS.md` with a "GitHub & Contribution Workflow" section?
6. Preferred default branch (`main` is strongly recommended and is the default here).
7. Any existing `.gitignore` or README content you want to preserve at all costs?

Also surface current state (is this repo already initialized/pushed? Any prior CI attempts?).

### Step 3: Create / Update GitHub Files (Follow XCODE_FIRST_GUIDELINES.md Strictly)

- `.github/workflows/`, `PULL_REQUEST_TEMPLATE.md`, `ISSUE_TEMPLATE/`, `dependabot.yml` → safe to create.
- `.gitignore` → **merge only** (append new high-value entries; never truncate or replace user's existing rules).
- `README.md` → create only if missing or extremely minimal; otherwise append a small high-signal section.
- `CONTRIBUTING.md` → create if missing (new in this refreshed skill).
- `AGENTS.md` → append a `## GitHub & Contribution Workflow` section (ask first if a similar heading already exists).

Never delete files.

### Step 4: Generate High-Quality, Up-to-Date 2026 Templates

Use the templates below. Substitute `{{SCHEME_NAME}}`, `{{APP_NAME}}`, `{{MIN_IOS}}` etc. from answers in Step 2.

Customize CI based on answers (tests? lint?).

### Step 5: Safety, Idempotency & Communication

- Before writing any file, check existence and content length.
- For merges, show a clear diff or summary of *added* lines.
- At the end, give the user the exact list of actions taken + next manual steps.

### Step 6: Post-Skill Next Steps & GitHub Hygiene

Provide:
1. Exact `git` commands for init / first commit / push (if not already done).
2. Recommended GitHub repo settings (branch protection on `main`, required status checks matching the CI jobs you created, "Allow squash merging" preferred).
3. How to pair this with the architecture and feature-flags skills.
4. Reminder to commit `Package.resolved` if using SPM.

---

## File Templates (Refreshed May 2026)

### 1. .gitignore (Modern Xcode + SwiftUI + Swift 6)

```gitignore
# Xcode
.DS_Store
build/
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/
*.xccheckout
*.moved-aside
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.build/
.swiftpm/
Package.resolved   # Uncomment if you prefer not to commit resolved packages

# CocoaPods / Carthage / fastlane (common even in SPM projects)
Pods/
Carthage/Build/
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output/

# App Store / Archives
*.ipa
*.dSYM.zip
*.dSYM

# Playgrounds
timeline.xctimeline
playground.xcworkspace

# SwiftUI Previews & environment
*.xcworkspace/xcuserdata/

# Secrets & signing (never commit real keys)
.env
.env.*
*.p12
*.p8
AuthKey_*.p8
*.mobileprovision
```

### 2. .github/workflows/ci.yml (Professional 2026 Baseline — Primary Recommendation)

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build-and-test:
    name: Build & Test
    runs-on: macos-26
    timeout-minutes: 60
    permissions:
      contents: read
      actions: write

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Select Xcode 26.5
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: '26.5'

      - name: Cache DerivedData + Swift Packages (irgaly)
        uses: irgaly/xcode-cache@v1
        with:
          key: xcode-${{ runner.os }}-${{ hashFiles('**/*.xcodeproj/**', '**/Package.resolved') }}

      - name: Resolve Swift Packages
        run: |
          xcodebuild -resolvePackageDependencies \
            -scheme "{{SCHEME_NAME}}" \
            -derivedDataPath ./DerivedData

      - name: Build & Test
        run: |
          set -o pipefail
          xcodebuild test \
            -scheme "{{SCHEME_NAME}}" \
            -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
            -configuration Debug \
            -derivedDataPath ./DerivedData \
            CODE_SIGNING_ALLOWED=NO \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGN_IDENTITY="" \
            -parallel-testing-enabled YES \
            -skipPackagePluginValidation \
            -skipMacroValidation \
            | xcbeautify --renderer github-actions

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: xcresult
          path: ./DerivedData/**/*.xcresult
          retention-days: 7
```

**Notes for the agent**:
- Offer a "build-only, no tests" lighter variant if the project has no tests yet.
- Ask about adding a separate SwiftLint job (or matrix) if they said yes to linting tools.
- The `irgaly/xcode-cache` + `maxim-lobanov/setup-xcode` combination is the current community gold standard for reliable, fast SwiftUI CI in 2026.

### 3. .github/workflows/ci-minimal.yml (Build-Only Alternative)

Provide this when the user chooses the lighter option. It uses the same runner + Xcode selection + caching but only the build step (much faster feedback on PRs).

### 4. .github/PULL_REQUEST_TEMPLATE.md

```markdown
## Description

<!-- Describe your changes in detail. Link any related issues. -->

## Type of Change

- [ ] Bug fix (non-breaking)
- [ ] New feature (non-breaking)
- [ ] Breaking change
- [ ] Documentation / CI only
- [ ] Refactor (no behavior change)

## How Has This Been Tested?

<!-- List simulators, test cases, or manual steps. -->

## Checklist

- [ ] My code follows the project's style and `AGENTS.md` guidelines
- [ ] I have performed a self-review
- [ ] I have added or updated tests (or explained why not needed)
- [ ] All new and existing tests pass locally and in CI
- [ ] I have updated documentation where appropriate
- [ ] No new warnings introduced
```

### 5. .github/ISSUE_TEMPLATE/bug_report.md and feature_request.md

Keep the high-quality versions from the previous skill (they are still excellent). Minor refresh of environment examples to iPhone 17 / iOS 18+ / Xcode 26.5.

### 6. .github/dependabot.yml

```yaml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    groups:
      actions:
        patterns:
          - "*"

  # Enable when you have SPM dependencies you want auto-updated
  # - package-ecosystem: "swift"
  #   directory: "/"
  #   schedule:
      interval: "weekly"
```

### 7. README.md (High-Quality Minimal Starter)

```markdown
# {{APP_NAME}}

Modern SwiftUI iOS application targeting iOS 18+.

## Requirements

- iOS 18.0+
- Xcode 26.5+
- Swift 6.3+

## Getting Started

1. Clone the repo
2. Open `{{APP_NAME}}.xcodeproj` in Xcode 26.5
3. Select the {{SCHEME_NAME}} scheme and run on iPhone 17 Pro simulator (or your device)

## Project Structure

This project follows the Xcode-first + skills approach from https://github.com/Gaoridang/swiftui-grok-skills.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and the contribution section in `AGENTS.md`.

## License

MIT (or your choice)
```

### 8. CONTRIBUTING.md (New — Recommended)

```markdown
# Contributing to {{APP_NAME}}

Thank you for your interest!

## Development Setup

1. Xcode 26.5+
2. Run `/setup-swiftui-github` (or follow the manual steps in the skill) if you haven't already
3. `git checkout -b feature/your-thing`

## Pull Requests

- Small and focused is strongly preferred
- All PRs must pass CI
- Use the PR template
- Update `AGENTS.md` when making architectural changes
- Conventional commits appreciated but not required

## Questions?

Open a discussion or issue first for anything non-trivial.
```

### 9. AGENTS.md GitHub & Contribution Workflow Section (Append)

```markdown
## GitHub & Contribution Workflow

- Work happens on short-lived feature branches from `main`
- Every PR must pass the CI workflow (build + tests on macos-26 + Xcode 26.5)
- Prefer small PRs; large refactors should be discussed first
- Update this `AGENTS.md` when you change architecture, add major dependencies, or modify CI
- Use the PR and issue templates — they exist to keep context high for both humans and AI agents
- Run the setup skills (`/setup-swiftui-*`) again after major structural changes if needed
- Never commit real secrets or provisioning profiles
```

---

## Final Guidance the Skill Must Always Give the User

At the very end of execution, output a clean summary containing:

- **Files created** (full paths)
- **Files merged/updated** and exactly what was added
- **Git commands** (if the repo is not yet initialized)
- **GitHub repo settings to configure** after push (branch protection, required checks named after the jobs you created, squash merges)
- **Next recommended skills**: `/setup-swiftui-architecture`, `/setup-swiftui-agents`, then `/setup-swiftui-feature-flags`
- High-level reminder: Write new code using modern Swift 6+ idioms (the detailed build settings recommendations now live in the AGENTS.md skill).

**End of Skill**

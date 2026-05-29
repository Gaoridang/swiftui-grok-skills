---
name: setup-swiftui-github
description: Runs after the user has manually created a new iOS SwiftUI project in Xcode (iOS 18+, Swift 6+). Adds professional GitHub configuration (.gitignore, CI, PR/issue templates, Dependabot, README) into the existing project using safe merge/update strategies. Can enhance AGENTS.md with contribution guidelines.
---

# Setup SwiftUI GitHub (Professional Project Initialization)

**Important**: Before running this skill, read `XCODE_FIRST_GUIDELINES.md`. This skill follows Xcode-first integration rules (merge instead of overwrite, etc.).

## Important Notes for This Skill

- This skill is **idempotent-friendly** — it should be safe to run multiple times.
- It will merge into existing `.gitignore` and `AGENTS.md` rather than overwriting.
- It will not delete any existing files.

## Purpose

This skill adds professional GitHub configuration and contribution standards into a project the user has already created in Xcode. It follows the integration rules defined in `XCODE_FIRST_GUIDELINES.md`.

It focuses on the things that matter most for long-term project health:
- Proper version control hygiene
- Automated CI that actually catches problems
- Clear contribution processes
- Dependency management automation
- High-quality documentation

## When to Use This Skill

- User just created a new iOS SwiftUI project in Xcode and wants to push it to GitHub immediately
- User wants professional GitHub setup without spending hours researching best practices
- User cares about good CI, clean PRs, and maintainable project structure
- Complements `setup-swiftui-feature-flags` (run both after creating a new project)

**Do not use** for very large existing repositories without discussion (this skill is optimized for greenfield projects).

---

## Step-by-Step Workflow

### Step 1: Discover the Project (Xcode-First)

This skill runs after the user has already created the project in Xcode.

- Find the `.xcodeproj` or `.xcworkspace`.
- Identify the main app target folder and scheme name (very important for CI).
- Check what already exists:
  - `.git` folder?
  - `.gitignore`?
  - `README.md`?
  - `AGENTS.md`?
- Read `XCODE_FIRST_GUIDELINES.md` for update/merge rules (especially for `.gitignore` and `README.md`).

Ask the user for the exact scheme name if it's not obvious from the folder structure.

### Step 2: Ask Clarifying Questions

Ask the following (can be in one message):

1. What is the **app name / scheme name**? (required for CI)
2. Do you want a basic CI that only **builds**, or also **runs unit + UI tests**?
3. Do you plan to use **SwiftLint** and/or **SwiftFormat**? (we can include them in CI)
4. Will this be a **solo project** or do you expect collaborators / contributors?
5. Do you want me to also update/create an `AGENTS.md` with GitHub contribution guidelines?
6. Any preference on default branch name? (`main` is strongly recommended)

Also check the current state of the project (does `.git` exist? Is it already pushed? Does `AGENTS.md` exist?).

### Step 3: Create / Update GitHub Files

Follow `XCODE_FIRST_GUIDELINES.md` for update strategy:

- Always create `.github/` and its contents (safe to add).
- **`.gitignore`**: Merge new entries. Never overwrite the user's existing file.
- **`README.md`**: Only create or lightly enhance if it's missing or very minimal.
- **AGENTS.md**: Append a "GitHub & Contribution Workflow" section if it exists or the user wants one.

Never delete or heavily modify files the user may have already customized.

### Step 4: Generate High-Quality Files

Use the templates below (they are modern and well-tested as of 2026).

Customize them with the actual app/scheme name.

### Step 5: Handle AGENTS.md (Highly Recommended)

If an `AGENTS.md` exists or the user wants one:
- Add a new section called **"GitHub & Contribution Workflow"**
- Include guidelines about PRs, conventional commits, CI expectations, etc.

This connects very well with the feature flags skill.

### Step 6: Safety, Idempotency & Final Output

Follow the rules in `XCODE_FIRST_GUIDELINES.md` (especially Safety & Idempotency and User Communication Requirements).

### Step 7: Provide Clear Next Steps

After scaffolding, give the user:

1. A clear summary of created vs updated files.
2. Manual Xcode steps (if any).
3. Exact commands for git init / first push.
4. Recommended GitHub repo settings (branch protection, etc.).
5. How this skill pairs with the architecture and feature flags skills.

---

## File Templates

### 1. .gitignore (Xcode + SwiftUI - Modern 2026 version)

```gitignore
## Xcode
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

## Swift Package Manager
.build/
.swiftpm/

## CocoaPods
Pods/

## Carthage
Carthage/Build/

## fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output/

## App Store
*.ipa
*.dSYM.zip
*.dSYM

## Playgrounds
timeline.xctimeline
playground.xcworkspace

## SwiftUI Previews
*.xcworkspace/xcuserdata/

## Environment & Secrets
.env
.env.*
*.p12
*.p8
AuthKey_*.p8

## OS generated files
Thumbs.db
```

### 2. .github/workflows/ci.yml (Recommended Starting Point)

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
  build:
    name: Build & Test
    runs-on: macos-15
    timeout-minutes: 30

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.3.app

      - name: Build
        run: |
          xcodebuild \
            -scheme "{{SCHEME_NAME}}" \
            -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
            -configuration Debug \
            build | xcbeautify

      - name: Run Unit Tests
        run: |
          xcodebuild \
            -scheme "{{SCHEME_NAME}}" \
            -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
            -configuration Debug \
            test | xcbeautify
```

**Note for the agent**: 
- Ask if they want to include `xcbeautify` (recommended for readable logs).
- Offer a version without tests first if they have no tests yet.

### 3. .github/PULL_REQUEST_TEMPLATE.md

```markdown
## Description

<!-- Describe your changes in detail -->

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?

<!-- Please describe the tests that you ran to verify your changes -->

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

### 4. .github/ISSUE_TEMPLATE/bug_report.md

```markdown
---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

## Describe the bug

A clear and concise description of what the bug is.

## To Reproduce

Steps to reproduce the behavior:

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected behavior

A clear and concise description of what you expected to happen.

## Screenshots

If applicable, add screenshots to help explain your problem.

## Environment

- Device: [e.g. iPhone 16 Pro]
- iOS Version: [e.g. 18.4]
- App Version: [e.g. 1.0.0]

## Additional context

Add any other context about the problem here.
```

### 5. .github/ISSUE_TEMPLATE/feature_request.md

```markdown
---
name: Feature request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## Is your feature request related to a problem? Please describe.

A clear and concise description of what the problem is.

## Describe the solution you'd like

A clear and concise description of what you want to happen.

## Describe alternatives you've considered

A clear and concise description of any alternative solutions or features you've considered.

## Additional context

Add any other context or screenshots about the feature request here.
```

### 6. .github/dependabot.yml

```yaml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5

  # Uncomment if you use Swift Package Manager dependencies
  # - package-ecosystem: "swift"
  #   directory: "/"
  #   schedule:
      interval: "weekly"
```

### 7. README.md (High-Quality Starter for SwiftUI App)

```markdown
# {{APP_NAME}}

A modern SwiftUI iOS application built for iOS 18+.

## Features

- Built with Swift 6 and modern SwiftUI
- Clean architecture with clear separation of concerns
- [Add your key features here]

## Requirements

- iOS 18.0+
- Xcode 16.3+
- Swift 6.0+

## Getting Started

1. Clone the repository
2. Open `{{APP_NAME}}.xcodeproj` in Xcode
3. Build and run

## Project Structure

```
{{APP_NAME}}/
├── {{APP_NAME}}/           # Main app target
├── {{APP_NAME}}Tests/      # Unit tests
└── {{APP_NAME}}UITests/    # UI tests
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) (coming soon) or open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

---

## AGENTS.md Integration (Optional but Powerful)

If the project uses or will use `AGENTS.md`, append or create a section like this:

```markdown
## GitHub & Contribution Workflow

- All work happens on feature branches created from `main`
- Use conventional commit messages when possible
- Every PR must pass CI before merging
- Prefer small, focused PRs over large ones
- Update `AGENTS.md` when making significant architectural changes
- Use the PR template — it exists for a reason
```

---

## Final Guidance to Give the User

After running the skill, always tell the user:

- What was created vs what was merged/updated.
- Any manual Xcode steps needed (rare for this skill, but mention if relevant).
- The exact commands to initialize git and do the first push.
- Recommended GitHub repository settings (branch protection rules, etc.).
- How this skill pairs with `setup-swiftui-architecture` and `setup-swiftui-feature-flags`.

---

**End of Skill**
```

**Notes for future improvement**:
- Can add a "release" workflow skeleton later
- Can add support for `fastlane` if the user wants more advanced CI/CD
- Can detect if the project already has some GitHub files and only fill gaps

This gives a very strong, practical starting point.
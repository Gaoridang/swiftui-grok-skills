# SwiftUI Grok Skills

A collection of high-quality Grok skills + canonical starter templates for initializing professional SwiftUI iOS projects (iOS 18+, Swift 6+).

## Purpose

These skills help you go from a brand new Xcode SwiftUI project to a well-structured, production-ready codebase with excellent AI agent guidance in minutes.

## Available Skills

| Skill | Description |
|-------|-------------|
| `setup-swiftui-github` | Adds professional GitHub setup (CI, templates, .gitignore, README, etc.) |
| `setup-swiftui-architecture` | Integrates a clean Feature-Sliced architecture (`App/`, `Features/`, `Core/`, `DesignSystem/`) |
| `setup-swiftui-feature-flags` | Sets up a production-grade LaunchDarkly feature flag system with type-safe patterns |

All skills are designed for **Xcode-first** workflow:
1. You create the project normally in Xcode.
2. You run the skills.
3. The skills intelligently integrate into your existing project.

## Installation

Copy the skill folders into your Grok skills directory:

### Windows
```powershell
# Copy skills
Copy-Item -Recurse "skills/setup-swiftui-*" "$env:USERPROFILE\.grok\skills\"
Copy-Item "skills/XCODE_FIRST_GUIDELINES.md" "$env:USERPROFILE\.grok\skills\"
```

### macOS / Linux
```bash
cp -r skills/setup-swiftui-* ~/.grok/skills/
cp skills/XCODE_FIRST_GUIDELINES.md ~/.grok/skills/
```

After copying, restart Grok or your terminal session.

## Usage (Recommended Order)

After creating a new project in Xcode:

```bash
/setup-swiftui-github
/setup-swiftui-architecture
/setup-swiftui-feature-flags
```

## Repository Structure

```
.
├── skills/                              # Ready-to-use Grok skills
│   ├── setup-swiftui-github/
│   ├── setup-swiftui-architecture/
│   ├── setup-swiftui-feature-flags/
│   └── XCODE_FIRST_GUIDELINES.md
│
├── starters/                            # Canonical high-quality starter templates
│   ├── swiftui-feature-flags-starter/
│   └── swiftui-architecture-starter/
│
└── README.md
```

## Why These Skills Exist

These were created to solve a common problem: starting new SwiftUI projects with good architecture, feature flagging discipline, and professional GitHub practices from day one — especially when working with AI coding agents.

## Contributing

These skills are opinionated but pragmatic. Feel free to fork and adapt them to your team's preferences.

---

**Created for use with Grok (xAI)**
# SwiftUI Grok Skills

A curated set of **Grok skills** and **canonical starter templates** for bootstrapping professional SwiftUI iOS apps (iOS 18+, Swift 6+).

These tools were built to help you start new projects with strong architecture, safe deployment practices (via feature flags), and solid GitHub hygiene — especially when working heavily with AI coding agents.

## The Skills

| Skill | What It Does |
|-------|--------------|
| `setup-swiftui-github` | Professional GitHub setup: CI workflows, PR/issue templates, Dependabot, `.gitignore`, and contribution guidelines |
| `setup-swiftui-architecture` | Integrates a clean **Feature-Sliced** architecture (`App/`, `Features/`, `Core/`, `DesignSystem/`) into an existing Xcode project |
| `setup-swiftui-feature-flags` | Adds a production-grade, type-safe **LaunchDarkly** feature flag system with excellent SwiftUI ergonomics and testing support |

All skills follow an **Xcode-first** philosophy:
1. You create the project normally in Xcode.
2. Run the skills.
3. The skills intelligently integrate into your existing structure.

## Installation

Copy the contents of the `skills/` folder into your local Grok skills directory:

### On Windows
```powershell
Copy-Item -Recurse "skills\setup-swiftui-*" "$env:USERPROFILE\.grok\skills\"
Copy-Item "skills\XCODE_FIRST_GUIDELINES.md" "$env:USERPROFILE\.grok\skills\"
```

### On macOS / Linux
```bash
cp -r skills/setup-swiftui-* ~/.grok/skills/
cp skills/XCODE_FIRST_GUIDELINES.md ~/.grok/skills/
```

Restart Grok after installation.

## Recommended Usage Order

After creating a new project in Xcode:

```bash
/setup-swiftui-github
/setup-swiftui-architecture
/setup-swiftui-feature-flags
```

## Repository Layout

```
.
├── skills/                    # The actual Grok skills (drop these into ~/.grok/skills/)
│   ├── setup-swiftui-*
│   └── XCODE_FIRST_GUIDELINES.md
│
├── starters/                  # High-quality reference implementations
│   ├── swiftui-architecture-starter/
│   └── swiftui-feature-flags-starter/
│
└── README.md
```

## Why This Exists

Starting new SwiftUI projects with good practices (especially when using AI agents) is painful. These skills + starters solve that by giving you:

- Clean, maintainable architecture from day one
- Proper feature flagging discipline (deploy fast, release safely)
- Professional GitHub setup
- Strong `AGENTS.md` guidance so future AI sessions stay consistent

## Contributing

These are opinionated but battle-tested patterns. Fork and adapt them to your team's needs.

---

**Built for Grok by xAI**
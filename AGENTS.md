# AGENTS.md

> **This file defines mandatory rules for all AI agents working in this repository.**
> Violations will result in rejected PRs and reverted changes.

---

## 🚨 ABSOLUTE REQUIREMENT: English Language Only

**This is the most important rule and must NEVER be violated.**

Everything in the project directory MUST be in English — without exception:

- Code, comments, documentation, commit messages
- Variable names, function names, type names, file names
- Error messages, log messages, test names, configuration files
- Pull request titles, descriptions, and review comments
- TODO comments, FIXME notes, and inline annotations

**Only exceptions:**

- Chat/conversation with users (any language is acceptable)
- User-facing UI text in localization files (`l10n/`) — these are localizable by design

**Any PR containing non-English content in code, comments, or technical documentation will be immediately rejected.**

---

## ⚠️ CRITICAL: Commit and Push Approval

AI Agents **MUST** ask for explicit user approval before:

- Creating any git commit (even if the user requested changes)
- Pushing to any remote branch

**Required process:**

1. Complete all changes
2. Show a clear summary of what was changed
3. Ask **"May I commit?"** → Wait for explicit **yes**
4. Commit with a proper conventional commit message
5. Ask **"May I push?"** → Wait for explicit **yes**
6. Push to the remote

**Never assume permission. Always ask. No exceptions.**

---

## 🎨 UI and Styling Rules

**All production code MUST follow these rules:**

- Use **only Material Design 3** components and theming — no custom widgets that bypass MD3
- Use **only the app theme** (`Theme.of(context)`) for all styling — no inline/embedded styles
- **No embedded strings** in UI code — all user-facing text must come from localization files (`l10n/`)
- **No custom CSS, custom fonts, or custom text styles** outside the theme system
- Full **localization (l10n) support** must be maintained everywhere — no hardcoded user-facing text
- All colors, typography, and spacing must come from the Material theme

**Exceptions:**

- Dummy/test pages under `pages/dummy/` are exempt during development
- Non-user-facing strings (log messages, debug labels) do not require localization

---

## 📚 Documentation Index

The `docs/` directory contains essential project documentation. Refer to these files when you need context about project conventions, architecture, or workflows:

| Document | Path | Description |
|----------|------|-------------|
| Architecture | [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | System architecture, layers, and design patterns |
| Branch Strategy | [`docs/BRANCH_STRATEGY.md`](docs/BRANCH_STRATEGY.md) | Git branching model and merge rules |
| Branding | [`docs/BRANDING.md`](docs/BRANDING.md) | Visual identity, colors, typography, and theming |
| Code of Conduct | [`docs/CODE_OF_CONDUCT.md`](docs/CODE_OF_CONDUCT.md) | Community behavior standards |
| Commit Strategy | [`docs/COMMIT_STRATEGY.md`](docs/COMMIT_STRATEGY.md) | Conventional commit format and allowed types |
| Community | [`docs/COMMUNITY.md`](docs/COMMUNITY.md) | Community participation guidelines |
| Configuration | [`docs/CONFIGURATION.md`](docs/CONFIGURATION.md) | Environment variables, settings, and CI/CD config |
| Contact | [`docs/CONTACT.md`](docs/CONTACT.md) | Communication channels and maintainer contacts |
| Contributing | [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) | How to contribute: PRs, reviews, and workflow |
| Development Guide | [`docs/DEVELOPMENT_GUIDE.md`](docs/DEVELOPMENT_GUIDE.md) | Dev setup, internal structure, and best practices |
| FAQ | [`docs/FAQ.md`](docs/FAQ.md) | Frequently asked questions |
| Getting Started | [`docs/GETTING_STARTED.md`](docs/GETTING_STARTED.md) | Quick setup and first run instructions |
| Labelling Strategy | [`docs/LABELLING_STRATEGY.md`](docs/LABELLING_STRATEGY.md) | GitHub label taxonomy for issues and PRs |
| Project Board | [`docs/PROJECT_BOARD.md`](docs/PROJECT_BOARD.md) | GitHub Projects board structure and usage |
| Project Structure | [`docs/PROJECT_STRUCTURE.md`](docs/PROJECT_STRUCTURE.md) | Full directory tree and file purposes |
| PR Strategy | [`docs/PR_STRATEGY.md`](docs/PR_STRATEGY.md) | Pull request conventions and review rules |
| Security | [`docs/SECURITY.md`](docs/SECURITY.md) | Security policy and vulnerability reporting |
| Style Guide | [`docs/STYLE_GUIDE.md`](docs/STYLE_GUIDE.md) | Dart/Flutter coding style, naming, and formatting |
| Summary | [`docs/SUMMARY.md`](docs/SUMMARY.md) | Overview of all documentation files |
| Support | [`docs/SUPPORT.md`](docs/SUPPORT.md) | How to get help and support channels |

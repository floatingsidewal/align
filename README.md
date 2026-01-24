# Align

A lightweight framework for keeping AI agents aligned with your project.

## Philosophy

`align/` is scaffolding — essential while building, removable when done.
`docs/` is permanent — what users and developers read forever.

## What It Does

- **Standards** — Document your coding patterns so agents follow them
- **Specs** — Structure feature planning for better builds
- **Support** — Create troubleshooting guides and runbooks

## Structure

```
align/
├── product/      # Mission, roadmap, tech decisions
├── standards/    # Coding standards for agent alignment
├── features/     # Feature specifications
└── support/      # Guides, troubleshooting, runbooks
```

## Commands

Available as Claude Code skills in `.claude/commands/`:

- **`/align`** — The main command. Auto-detects mode:
  - **Shape mode**: Plan new work, pull standards, optionally from GitHub issues
  - **Finalize mode**: Update specs, extract new standards, generate summary
- **`/align-status`** — Show current alignment state, gaps, and suggestions
- `/discover-standards` — Extract patterns from your codebase
- `/inject-standards` — Load relevant standards into context
- `/shape-spec` — Plan features with structure
- `/plan-product` — Document product context
- `/create-support-doc` — Document support procedures

## Getting Started

1. Copy `.claude/commands/` to your project
2. Create an `align/` directory
3. Run `/align` — it will guide you through setup
4. Or start with `/plan-product` to establish context first

## Acknowledgments

Heavily influenced and inspired by [Agent OS](https://github.com/buildermethods/agent-os)
by Brian Casel and the Builder Methods team. Align takes a more generalized approach
with added support documentation workflows.

## License

MIT

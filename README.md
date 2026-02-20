# Align

A lightweight framework for keeping AI agents aligned with your project.

## Philosophy

`align/` is scaffolding — essential while building, removable when done.
`docs/` is permanent — what users and developers read forever.

## What It Does

- **Standards** — Document your coding patterns so agents follow them
- **Specs** — Structure feature planning for better builds
- **Support** — Create troubleshooting guides and runbooks

## Quick Start by Scenario

### New Project (Greenfield)

Starting fresh? Begin with intent, let standards emerge as you build.

1. **`/plan-product`** — Define mission, roadmap, and tech stack
2. **`/align`** — Start shaping your first feature
3. Standards emerge naturally as you build and finalize work

### Existing Project (Midstream)

Joining an established codebase? Capture tribal knowledge first.

1. **`/discover-standards`** — Extract patterns already in your code
2. **`/plan-product`** — Document product context (can be brief)
3. **`/align-status`** — See current alignment state
4. **`/align`** — Start using the workflow for new features

## Daily Workflow

```
┌─────────────────────────────────────────────────────────┐
│                    Starting Work                         │
│                         ↓                                │
│              /align (shape mode)                         │
│         Plan work, pull standards, link issues           │
│                         ↓                                │
│                     Building                             │
│         /inject-standards as needed for context          │
│                         ↓                                │
│              /align (finalize mode)                      │
│    Update specs, extract new standards, summarize        │
│                         ↓                                │
│                 /align-status                            │
│              Check alignment health                      │
└─────────────────────────────────────────────────────────┘
```

## Structure

```
align/
├── product/      # Mission, roadmap, tech decisions
├── standards/    # Coding standards for agent alignment
├── features/     # Feature specifications
└── support/      # Guides, troubleshooting, runbooks
```

## Commands Reference

Available as Claude Code skills in `.claude/commands/`:

### Primary

- **`/align`** — The main command. Auto-detects mode:
  - **Shape mode**: Plan new work, pull standards, optionally from GitHub issues
  - **Finalize mode**: Update specs, extract new standards, generate summary
- **`/align-status`** — Show current alignment state, gaps, and suggestions

### Setup & Discovery

- **`/plan-product`** — Document product context (mission, roadmap, tech stack)
- **`/discover-standards`** — Extract coding patterns from your existing codebase

### During Work

- **`/inject-standards`** — Load relevant standards into agent context
- **`/shape-spec`** — Plan individual features with structure

### Support

- **`/create-support-doc`** — Document troubleshooting procedures and runbooks

## Getting Started

1. Copy `.claude/commands/` to your project
2. Create an `align/` directory
3. Follow the [Quick Start](#quick-start-by-scenario) for your scenario

## Acknowledgments

Heavily influenced and inspired by [Agent OS](https://github.com/buildermethods/agent-os)
by Brian Casel and the Builder Methods team. Align takes a more generalized approach
with added support documentation workflows.

## License

MIT

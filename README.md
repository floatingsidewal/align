# Align

A lightweight framework for keeping AI agents aligned with your project.

## Philosophy

`align/` is scaffolding — essential while building, removable when done.
`docs/` is permanent — what users and developers read forever.

## What It Does

- **Standards** — Document your coding patterns so agents follow them
- **Specs** — Structure feature planning for better builds
- **Support** — Create troubleshooting guides and runbooks
- **Overrides** — Temporary patches for production issues (human or agent-created)
- **Skills** — Project-specific skills that can be shipped and deployed
- **Automation** — CI/agent workflow definitions for GitHub Actions and support agents

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
├── support/      # Guides, troubleshooting, runbooks
├── overrides/    # Production override system
│   ├── registry.yml      # Machine-readable index
│   ├── active/           # Current overrides
│   ├── resolved/         # Historical overrides
│   └── templates/        # Override type templates
├── skills/       # Project-specific skills
│   └── manifest.yml      # Skill registry
└── automation/   # CI/Agent workflows
    ├── workflows/        # GitHub Actions
    ├── agents/           # Agent configurations
    └── triggers/         # Event-to-action mappings
```

## Commands Reference

Available as Claude Code slash commands (installed to `.claude/commands/`):

### Primary

- **`/align`** — The main command. Auto-detects mode:
  - **Shape mode**: Plan new work, pull standards, check active overrides
  - **Finalize mode**: Update specs, extract new standards, verify override compliance
- **`/align-status`** — Show current alignment state, gaps, overrides, and suggestions

### Setup & Discovery

- **`/plan-product`** — Document product context (mission, roadmap, tech stack)
- **`/discover-standards`** — Extract coding patterns from your existing codebase

### During Work

- **`/inject-standards`** — Load relevant standards into agent context (includes active addendums)
- **`/shape-spec`** — Plan individual features with structure

### Overrides

- **`/align-override`** — Create and manage production overrides
  - Create mode: Guided override creation (behavior-patch, content-addendum, procedure-update)
  - List mode: View active/expired overrides
  - Resolve mode: Mark overrides as absorbed, superseded, or expired
- **`/align-override-check`** — Check for active overrides relevant to current work

### Skills

- **`/align-ship`** — Package and deploy project-specific skills
  - Deploy skills from `align/skills/` to `~/.claude/skills/`
  - Choose standards bundling (bundled, referenced, or skip)
  - Track deployment status and versions

### Support

- **`/create-support-doc`** — Document troubleshooting procedures and runbooks

## Override System

Overrides are temporary patches that address production issues without modifying permanent standards.

### Override Types

| Type | Purpose | Example |
|------|---------|---------|
| **behavior-patch** | Modifies skill/command behavior | Extra validation step |
| **content-addendum** | Adds to standards/docs | Missing error codes |
| **procedure-update** | Temporary runbook change | Extra deploy step |

### Override Lifecycle

```
Production Issue → Create Override → Active → Resolution → Absorbed/Archived
       ↓                 ↓              ↓          ↓
   INC-XXX        OVR-YYYY-MMDD    Applied    PR merged
```

Overrides use structured IDs (`OVR-2026-0215-001`) for machine parsing and are automatically surfaced when running `/align` or `/inject-standards`.

## Skills System

Project-specific skills live in `align/skills/` and can be deployed to `~/.claude/skills/`.

```yaml
# align/skills/manifest.yml
skills:
  - name: create-api-endpoint
    version: "1.0.0"
    standards:
      referenced: [api/response-format, api/error-handling]
```

Deploy with `/align-ship` to make skills available in Claude Code.

## Automation

The `align/automation/` directory contains configurations for CI/CD and AI agents:

- **workflows/** — GitHub Actions for override processing
- **agents/** — Configurations for support triage, milestone planning
- **triggers/** — Event-to-action mappings (e.g., incident → override)

These enable AI agents in CI to create overrides, plan work, and respond to production events.

## Installation

### One-Time Setup

Clone the Align repo to a permanent location:

```bash
git clone https://github.com/floatingsidewal/align.git ~/align
```

### Per-Project Install

From any project directory (new or existing):

```bash
cd /path/to/your/project
~/align/scripts/install.sh
```

This creates the `align/` directory structure and copies commands to `.claude/commands/`.

### Update Commands

After pulling new versions of Align:

```bash
cd /path/to/your/project
~/align/scripts/install.sh --commands-only
```

Then follow the [Quick Start](#quick-start-by-scenario) for your scenario.

## Acknowledgments

Heavily influenced and inspired by [Agent OS](https://github.com/buildermethods/agent-os)
by Brian Casel and the Builder Methods team. Align takes a more generalized approach
with added support documentation workflows.

## License

MIT

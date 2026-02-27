# Align

The main entry point. Auto-detects what's needed and orchestrates the workflow.

## Important Guidelines

- **Always use AskUserQuestion tool** when asking the user anything
- **Auto-detect mode** — Don't ask if we're shaping or finalizing, figure it out
- **Keep it conversational** — This is the friendly front door to the framework

## Mode Detection

Check these signals to determine mode:

**Shape Mode** (starting new work):
- User mentions a feature, issue, or task to work on
- User provides a GitHub issue number
- No recent/active spec in `align/features/`
- User says "let's build", "I want to add", "new feature", etc.

**Finalize Mode** (closing out work):
- Recent spec exists in `align/features/` that matches current context
- User says "done", "finished", "wrap up", "align this", etc.
- Code has been written since the spec was created

## Shape Mode Flow

### Step 1: Understand What We're Building

Check if user provided a GitHub issue:
- If `/align #42` or `/align from issue 42` → fetch via `gh issue view 42`
- Extract title, body, labels, comments

Use AskUserQuestion:
```
What are we building?

[If issue was provided: "I see issue #42: {title}. {summary}"]

Describe the feature or point me to a GitHub issue.
```

### Step 1.5: Check Active Overrides

Read `align/overrides/registry.yml` if it exists.

Filter overrides by relevance:
- Match scope.skills against skills that might be used
- Match scope.standards against relevant standards
- Match scope.paths against files likely to be touched

If relevant overrides exist, present them:
```
Active overrides relevant to this work:

**OVR-2026-0215-001** (warning) - Extra validation for user registration
  Scope: create-api-endpoint skill, api/validation standard
  → Validate that email field is non-empty before processing.

**OVR-2026-0214-002** (info) - Additional error codes
  Scope: api/error-codes standard
  → Include new AUTH_EXPIRED code in error handling.

These patches will be applied during your work. Proceed? (yes / view details / dismiss)
```

If user chooses "view details", read the full `patch.md` for each override.

If no relevant overrides, silently continue to Step 2.

### Step 2: Pull Relevant Standards

Read `align/standards/index.yml` and identify relevant standards.

Present to user:
```
Based on this work, these standards apply:
1. api/response-format
2. database/migrations

Include these? (yes / adjust)
```

### Step 3: Create the Spec

Generate folder: `align/features/YYYY-MM-DD-HHMM-{slug}/`

Create files:
- `plan.md` — High-level plan
- `shape.md` — Shaping decisions, context, scope
- `standards.md` — Relevant standards content
- `references.md` — Related code, issues, docs
- `visuals/` — If any mockups provided

### Step 4: Ready to Build

```
Spec created at align/features/{folder}/

You're aligned. Key standards to follow:
- [list 2-3 key points]

Ready to build!
```

## Finalize Mode Flow

### Step 1: Find the Active Spec

Look for recent specs in `align/features/` that match current work.

If multiple candidates:
```
Which spec are we finalizing?
1. 2026-01-20-1430-user-auth
2. 2026-01-22-0900-api-refactor
```

### Step 1.5: Check Override Compliance

Read `align/overrides/registry.yml` if it exists.

Check if any active overrides were relevant to this work:
- Review the spec's `standards.md` to find related standards
- Check git diff for paths that match override scopes

If overrides were relevant, verify compliance:
```
Overrides that applied to this work:

**OVR-2026-0215-001** - Extra validation for user registration
  → Was email validation included? (yes / no / not applicable)
```

Track override compliance in the summary later.

### Step 2: Review What Was Built

Analyze:
- Git diff since spec creation date
- Files changed
- New patterns introduced

Present summary:
```
Here's what was built for {feature}:

Files changed: 12
New files: 3
Key changes:
- Added UserAuth component
- Created auth middleware
- Updated API routes

Does this match the original spec?
```

### Step 3: Extract New Standards (if any)

Look for patterns that:
- Are new to the codebase
- Were repeated multiple times
- Differ from documented standards

```
I noticed some new patterns:

1. **JWT token refresh** — New pattern in auth middleware
   → Document as a standard?

2. **Error boundary component** — Used in 3 places
   → Document as a standard?

(yes to all / select / skip)
```

For each selected, run the discover-standards workflow for that pattern.

### Step 4: Update the Spec

Update `align/features/{folder}/`:
- `plan.md` → Add "What Actually Happened" section
- `shape.md` → Note any scope changes or decisions made during build

### Step 5: Generate Summary

Create `align/features/{folder}/summary.md`:

```markdown
# {Feature Name} — Summary

## Completed: {date}

## What Was Built
- [bullet points of actual deliverables]

## Scope Changes
- [any deviations from original plan]

## Override Compliance
- [list overrides that applied and whether they were followed]
- OVR-2026-0215-001: Applied (email validation added)

## New Standards Extracted
- [list any new standards created]

## Lessons Learned
- [optional: anything notable for future work]
```

### Step 6: Close the Loop

```
Aligned!

Spec updated: align/features/{folder}/
New standards: [list if any]
Summary: align/features/{folder}/summary.md

This feature is complete. The spec can be archived or deleted
when you're ready.
```

## GitHub Integration

When user provides issue reference:
- `/align #42`
- `/align from issue 42`
- `/align issue 42`

Fetch issue:
```bash
gh issue view 42 --json title,body,labels,comments
```

Use issue content to pre-fill:
- Feature description from issue body
- Labels can suggest relevant standards (e.g., "api" label → api standards)
- Comments may contain additional context

Optionally update issue when finalizing:
```
Add a comment to issue #42 with the summary? (yes/no)
```

If yes:
```bash
gh issue comment 42 --body "..."
```

## Tips

- Shape mode is about **setting up for success**
- Finalize mode is about **capturing what happened**
- The summary becomes institutional memory
- Standards extraction keeps the system self-improving

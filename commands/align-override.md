# Align Override

Create and manage production overrides — temporary patches for skills, standards, and procedures.

## Important Guidelines

- **YAML-first** — All metadata in machine-readable YAML for agent parsing
- **Structured IDs** — Use format OVR-YYYY-MMDD-NNN (auto-generated)
- **Audit trail** — Every change is tracked in history.yml
- **Always use AskUserQuestion tool** when asking the user anything

## Usage Modes

### Create Mode (default)
```
/align-override
/align-override create
```
Interactive guided creation of a new override.

### List Mode
```
/align-override list
/align-override list active
/align-override list all
```
View active or all overrides.

### Resolve Mode
```
/align-override resolve OVR-2026-0215-001
```
Mark an override as resolved.

### Programmatic Mode (for agents/CI)
```
/align-override create --type behavior-patch --title "Extra validation" --scope.skills create-api-endpoint
```
Non-interactive creation for automation.

---

## Create Mode Flow

### Step 1: Choose Override Type

Use AskUserQuestion:
```
What type of override are you creating?

1. **Behavior Patch** — Modify how a skill or command works
2. **Content Addendum** — Add content to existing standards or docs
3. **Procedure Update** — Temporarily change a runbook or procedure

Which type? (1, 2, or 3)
```

### Step 2: Gather Basic Info

Use AskUserQuestion:
```
Describe the override:

**Title**: [short description]
**Why**: [what production issue or need does this address?]
**Severity**: info / warning / critical
```

### Step 3: Define Scope

Based on type, ask about scope:

**For behavior-patch:**
```
What does this patch affect?

- Skills: [list skill names, or "none"]
- Commands: [list command names, or "none"]
- Standards: [list standard paths, or "none"]
- File paths: [glob patterns, or "none"]
```

**For content-addendum:**
```
What standards or docs does this add content to?

- Standards: [list standard paths]
- Documents: [list doc paths]
```

**For procedure-update:**
```
What procedures does this modify?

- Runbooks: [list runbook names]
- Procedures: [list procedure names]
- Workflows: [list workflow names]
```

### Step 4: Capture the Patch Content

Use AskUserQuestion:
```
Describe the actual patch/change:

[For behavior-patch: What step to add, modify, or validation to include]
[For content-addendum: What content to add]
[For procedure-update: What procedure change to make]
```

### Step 5: Set References (Optional)

```
Any related references? (all optional)

- Incident: [INC-xxx or link]
- PR: [PR that will absorb this]
- Issue: [GitHub issue]
- Expires: [date when this should be reviewed, or leave blank]
```

### Step 6: Generate Override

1. Generate ID: `OVR-{YYYY}-{MMDD}-{NNN}`
   - NNN = next sequence number for that day (001, 002, etc.)
   - Check existing overrides to determine sequence

2. Create folder: `align/overrides/active/OVR-YYYY-MMDD-NNN/`

3. Create files:

**override.yml** (machine-readable):
```yaml
id: OVR-2026-0215-001
type: behavior-patch
status: active
title: "Add extra validation to user registration"
description: |
  Production incident showed users could submit empty email.
  Adding validation until proper fix is deployed.
scope:
  skills: [create-api-endpoint]
  standards: [api/validation]
  paths: []
severity: warning
created: 2026-02-15T10:30:00Z
created_by: human
expires: 2026-03-15T10:30:00Z
references:
  incident: INC-1234
  pr: ""
  issue: "#456"
patch:
  action: add_validation
  target: user_input
  content: |
    Validate that email field is non-empty before processing.
```

**patch.md** (human-readable):
```markdown
# OVR-2026-0215-001: Add extra validation to user registration

**Type:** Behavior Patch
**Severity:** Warning
**Created:** 2026-02-15
**Expires:** 2026-03-15

## Why This Override Exists

Production incident showed users could submit empty email.
Adding validation until proper fix is deployed.

## Scope

- **Skills:** create-api-endpoint
- **Standards:** api/validation

## The Patch

When working on user registration or the create-api-endpoint skill:

> Validate that email field is non-empty before processing.

## References

- Incident: INC-1234
- Tracking Issue: #456
```

**history.yml** (audit trail):
```yaml
events:
  - timestamp: 2026-02-15T10:30:00Z
    action: created
    by: human
    note: Initial creation
```

4. Update `align/overrides/registry.yml`:
   - Add entry to `active` array

### Step 7: Confirm

```
Override created: OVR-2026-0215-001

Location: align/overrides/active/OVR-2026-0215-001/
Severity: warning
Scope: create-api-endpoint skill, api/validation standard

This override will be surfaced when:
- Running /align with related work
- Injecting api/validation standard
- Using create-api-endpoint skill

To resolve: /align-override resolve OVR-2026-0215-001
```

---

## List Mode Flow

### Step 1: Parse Arguments

- `list` or `list active` → Show only active overrides
- `list all` → Show active and recently resolved

### Step 2: Read Registry

Read `align/overrides/registry.yml`

### Step 3: Display

**Active overrides:**
```
# Active Overrides (3)

| ID | Type | Severity | Title | Expires |
|----|------|----------|-------|---------|
| OVR-2026-0215-001 | behavior-patch | warning | Extra validation for user reg | 2026-03-15 |
| OVR-2026-0214-002 | content-addendum | info | Additional error codes | - |
| OVR-2026-0210-001 | procedure-update | critical | Extra deploy step | 2026-02-20 |

Use `/align-override resolve <id>` to resolve an override.
```

**If showing all:**
```
# Resolved Overrides (2)

| ID | Type | Resolution | Resolved |
|----|------|------------|----------|
| OVR-2026-0115-001 | behavior-patch | absorbed | 2026-02-01 |
| OVR-2026-0110-003 | content-addendum | expired | 2026-01-25 |
```

---

## Resolve Mode Flow

### Step 1: Find Override

Parse the override ID from arguments.

Look in `align/overrides/active/{id}/`

If not found:
```
Override not found: OVR-2026-0215-001

Active overrides:
- OVR-2026-0214-002
- OVR-2026-0210-001
```

### Step 2: Confirm Resolution

Use AskUserQuestion:
```
Resolving: OVR-2026-0215-001 - "Extra validation for user registration"

How was this resolved?

1. **Absorbed** — Proper fix was merged (PR/commit)
2. **Superseded** — Replaced by another override
3. **Expired** — No longer relevant, time-based expiry
4. **Invalid** — Override was incorrect or unnecessary

Which resolution? (1, 2, 3, or 4)
```

If absorbed: Ask for PR/commit reference
If superseded: Ask for new override ID

### Step 3: Update Files

1. Update `override.yml`:
   - Set `status: resolved`
   - Add `resolution`, `resolved_date`, `resolved_by`

2. Update `history.yml`:
   - Add resolution event

3. Move folder: `active/` → `resolved/`

4. Update `registry.yml`:
   - Remove from `active` array
   - Add to `resolved` array

### Step 4: Confirm

```
Override resolved: OVR-2026-0215-001

Resolution: absorbed
Reference: PR-789
Moved to: align/overrides/resolved/OVR-2026-0215-001/
```

---

## Programmatic Mode (for Agents/CI)

When arguments suggest programmatic mode (contains `--type`, `--title`, etc.):

Skip interactive prompts and parse arguments directly:

```
/align-override create --type behavior-patch --title "Extra validation" --scope.skills create-api-endpoint --severity warning --incident INC-1234
```

Parse arguments:
- `--type` → Override type
- `--title` → Title
- `--scope.skills` → Comma-separated skill names
- `--scope.standards` → Comma-separated standard paths
- `--scope.paths` → Comma-separated file globs
- `--severity` → info/warning/critical
- `--incident` → Incident reference
- `--pr` → PR reference
- `--issue` → Issue reference
- `--expires` → Expiration date
- `--content` → Patch content (or read from stdin)

Create override without prompts, output the ID:
```
Created: OVR-2026-0215-003
```

---

## ID Generation

Generate ID: `OVR-{YYYY}-{MMDD}-{NNN}`

1. Get current date: YYYY = year, MMDD = month + day
2. List existing override folders in `active/` and `resolved/`
3. Find highest sequence number for today
4. Increment to get NNN (zero-padded to 3 digits)

Example: If OVR-2026-0215-001 and OVR-2026-0215-002 exist, next is OVR-2026-0215-003

---

## Tips

- **Create overrides early** — Don't wait until the incident is over
- **Be specific in scope** — Narrow scope means fewer false positives
- **Set expiration** — Forces review even if fix is delayed
- **Link to tracking** — Always reference incident/issue for audit

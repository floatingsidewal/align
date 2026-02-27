# Align Override Check

Check for active overrides relevant to current work. Called automatically by `/align` but can also be invoked directly.

## Important Guidelines

- **Read-only** — This command only reads and reports
- **Context-aware** — Filters overrides based on current work
- **Non-blocking** — Reports but doesn't prevent work

## Usage

```
/align-override-check
/align-override-check api
/align-override-check src/users/
```

Arguments can be:
- Empty: Auto-detect from conversation context
- Standard path: Check overrides for specific standard
- File path: Check overrides for specific file/directory

## Process

### Step 1: Read Override Registry

Read `align/overrides/registry.yml`

If file doesn't exist or `active` array is empty:
```
No active overrides.
```

### Step 2: Determine Context

If arguments provided:
- Use them directly as scope filter

If no arguments:
- Analyze current conversation for:
  - Mentioned standards
  - File paths being discussed
  - Skills being used
  - Feature being worked on

### Step 3: Filter Relevant Overrides

For each active override, check if it's relevant:

```
Match criteria:
- scope.standards matches any context standard
- scope.paths matches any context file path (glob)
- scope.skills matches any context skill
- scope.commands matches any context command
```

### Step 4: Present Results

**If relevant overrides found:**

```
# Active Overrides for Current Work

## Critical (1)

**OVR-2026-0210-001** - Extra deploy step required
Type: procedure-update
Expires: 2026-02-20

> Before deploying, run the database migration verification script.
> This is required until the migration rollback feature is deployed.

---

## Warning (2)

**OVR-2026-0215-001** - Extra validation for user registration
Type: behavior-patch
Scope: create-api-endpoint, api/validation

> Validate that email field is non-empty before processing.

**OVR-2026-0214-002** - Additional error codes
Type: content-addendum
Scope: api/error-codes

> Include new AUTH_EXPIRED code in error handling.

---

View full details: `cat align/overrides/active/OVR-2026-0215-001/patch.md`
Resolve when done: `/align-override resolve OVR-2026-0215-001`
```

**If no relevant overrides:**

```
No active overrides relevant to current work.

Total active overrides: 3 (run `/align-override list` to see all)
```

### Step 5: Severity Ordering

Always present overrides in severity order:
1. **Critical** — Must be addressed, work may be blocked
2. **Warning** — Should be followed, but not blocking
3. **Info** — Awareness only, optional to apply

## Integration

This command is called internally by:
- `/align` (Shape mode, Step 1.5)
- `/align` (Finalize mode, Step 1.5)
- `/inject-standards` (to find addendums)

You can also call it directly anytime to check what overrides apply.

## Tips

- Run at the start of any significant work
- Pay attention to critical severity — these are blocking
- If an override seems wrong, check with the team before dismissing
- Expired overrides should be resolved, not ignored

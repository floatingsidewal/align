# Align Ship

Package and deploy skills from `align/skills/` to `~/.claude/skills/`.

## Important Guidelines

- **Non-destructive** — Backs up existing skills before overwriting
- **Standards-aware** — Can bundle or reference standards
- **Version tracking** — Records deployment info in manifest
- **Always use AskUserQuestion tool** when asking the user anything

## Usage

```
/align-ship                    # Interactive: select skills to deploy
/align-ship all                # Deploy all skills
/align-ship create-api-endpoint # Deploy specific skill
/align-ship --status           # Show deployment status only
```

## Process

### Step 1: Read Manifest

Read `align/skills/manifest.yml`

If manifest doesn't exist or has no skills:
```
No skills found in align/skills/manifest.yml

To create a skill:
1. Create a folder: align/skills/{skill-name}/
2. Add SKILL.md with the skill definition
3. Register it in manifest.yml
```

### Step 2: Show Available Skills

```
# Available Skills

| Skill | Version | Status | Description |
|-------|---------|--------|-------------|
| create-api-endpoint | 1.0.0 | deployed (current) | Scaffolds new API endpoints |
| run-migrations | 1.2.0 | deployed (outdated) | Database migration runner |
| generate-tests | 0.9.0 | not deployed | Test generator for components |

Select skills to deploy: (all / 1,3 / cancel)
```

Status values:
- **not deployed** — Skill exists in source but not in target
- **deployed (current)** — Deployed version matches source version
- **deployed (outdated)** — Deployed version is older than source
- **deployed (modified)** — Target has local modifications

### Step 3: Choose Standards Bundling

Use AskUserQuestion:
```
How should standards be included in deployed skills?

1. **Bundled** — Copy standard content into the skill (self-contained, larger)
2. **Referenced** — Use @path references (smaller, stays in sync with source)
3. **Skip** — Don't include standards (skill must work without them)

Which approach? (1, 2, or 3)
```

### Step 4: Check for Conflicts

For each selected skill, check if target exists:

```
Conflict detected:

~/.claude/skills/create-api-endpoint/ already exists
- Deployed version: 1.0.0
- Source version: 1.1.0
- Last modified: 2026-02-10

Options:
1. **Overwrite** — Replace with new version (backup created)
2. **Skip** — Keep existing, don't deploy this skill
3. **Diff** — Show differences before deciding

Which action? (1, 2, or 3)
```

### Step 5: Deploy Skills

For each skill:

1. **Backup** (if target exists and deployment.backup is true):
   ```
   cp -r ~/.claude/skills/{name} ~/.claude/skills/{name}.backup.{timestamp}
   ```

2. **Create target directory**:
   ```
   mkdir -p ~/.claude/skills/{name}
   ```

3. **Copy SKILL.md**:
   - If bundled standards: Inject standard content into SKILL.md
   - If referenced standards: Add @path references
   - If skip: Copy as-is

4. **Copy templates** (if skill has templates/):
   ```
   cp -r align/skills/{name}/templates/ ~/.claude/skills/{name}/templates/
   ```

5. **Update manifest**:
   - Set `deployed.path`
   - Set `deployed.version`
   - Set `deployed.date`

### Step 6: Verify Deployment

For each deployed skill:
- Check target exists
- Verify file sizes match
- Report any issues

### Step 7: Confirm

```
# Deployment Complete

Deployed 2 skills:
- create-api-endpoint (1.1.0) → ~/.claude/skills/create-api-endpoint/
- generate-tests (0.9.0) → ~/.claude/skills/generate-tests/

Skipped 1 skill:
- run-migrations (user chose to skip)

Backups created:
- ~/.claude/skills/create-api-endpoint.backup.20260215-103000/

To verify: /align-ship --status
```

---

## Status Mode

When called with `--status`:

### Step 1: Compare Source and Target

Read `align/skills/manifest.yml` and check each skill against `~/.claude/skills/`

### Step 2: Report

```
# Skill Deployment Status

| Skill | Source | Deployed | Status |
|-------|--------|----------|--------|
| create-api-endpoint | 1.1.0 | 1.1.0 | current |
| run-migrations | 1.2.0 | 1.0.0 | outdated |
| generate-tests | 0.9.0 | - | not deployed |

Recommendations:
- [ ] Deploy generate-tests: `/align-ship generate-tests`
- [ ] Update run-migrations: `/align-ship run-migrations`
```

---

## Creating a New Skill

To add a skill to the project:

### 1. Create Skill Folder

```
align/skills/{skill-name}/
├── SKILL.md          # Skill definition (required)
└── templates/        # Optional templates
    └── ...
```

### 2. Write SKILL.md

```markdown
# {Skill Name}

{Description of what this skill does}

## When to Use

{Guidance on when this skill applies}

## Process

{Step-by-step instructions}

## Standards

{Reference or include relevant standards}

## Examples

{Usage examples}
```

### 3. Register in Manifest

Add to `align/skills/manifest.yml`:

```yaml
skills:
  - name: {skill-name}
    description: {Short description}
    path: {skill-name}/
    version: "1.0.0"
    standards:
      bundled: []
      referenced: [api/response-format]
```

### 4. Deploy

```
/align-ship {skill-name}
```

---

## Tips

- **Version carefully** — Bump version when making changes
- **Test before shipping** — Run the skill locally first
- **Use references** — Referenced standards stay in sync automatically
- **Clean up backups** — Old backups accumulate over time
- **Document well** — Skills should be self-explanatory

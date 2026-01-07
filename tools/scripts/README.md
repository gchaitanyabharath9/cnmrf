# CNMRF Validation Scripts

PowerShell scripts for validating CNMRF repository structure and documentation quality.

## Purpose

**Alignment to Project Outline (Section 5):**  
Implements "Quality Gates (Windows) - verify-structure.ps1, lint-markdown.ps1, check-links.ps1, run-all.ps1"

## Scripts

### run-all.ps1
Runs all quality gate scripts in sequence.

**Usage:**
```powershell
.\tools\scripts\run-all.ps1
```

**Exit Code:**
- `0` - All quality gates passed
- `1` - One or more quality gates failed

---

### verify-structure.ps1
Validates repository structure against expected folder layout.

**Checks:**
- Required directories exist (`docs/`, `templates/`, `tools/`, `examples/`)
- Required README files exist
- Project Outline exists at `docs/governance/project-outline.md`

**Usage:**
```powershell
.\tools\scripts\verify-structure.ps1
```

**Exit Code:**
- `0` - Structure is valid
- `1` - Structure validation failed

---

### lint-markdown.ps1
Basic markdown linting and validation.

**Checks:**
- Markdown files have proper headings
- No broken internal references
- Consistent formatting

**Usage:**
```powershell
.\tools\scripts\lint-markdown.ps1
```

**Exit Code:**
- `0` - Markdown is valid
- `1` - Markdown validation failed

**Note:** This is a basic fallback linter. For comprehensive linting, use `markdownlint-cli` if available.

---

### check-links.ps1
Validates internal documentation links.

**Checks:**
- Internal markdown links point to existing files
- Anchor links reference existing headings
- No broken cross-references

**Usage:**
```powershell
.\tools\scripts\check-links.ps1
```

**Exit Code:**
- `0` - All links are valid
- `1` - Broken links found

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Quality Gates
on: [push, pull_request]
jobs:
  validate:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Quality Gates
        run: .\tools\scripts\run-all.ps1
        shell: pwsh
```

### Azure DevOps

```yaml
steps:
  - task: PowerShell@2
    displayName: 'Run Quality Gates'
    inputs:
      filePath: 'tools/scripts/run-all.ps1'
      pwsh: true
```

## Development

When adding new validation scripts:

1. Create script in `tools/scripts/`
2. Add execution to `run-all.ps1`
3. Document in this README
4. Test on Windows PowerShell and PowerShell Core

## Requirements

- **PowerShell 5.1+** or **PowerShell Core 7+**
- No external dependencies (scripts use built-in cmdlets)

## Troubleshooting

### Execution Policy

If scripts fail to run due to execution policy:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Path Issues

Run scripts from repository root:

```powershell
cd C:\Users\SOHAN\.gemini\antigravity\playground\cnmrf
.\tools\scripts\run-all.ps1
```

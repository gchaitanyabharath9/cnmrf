# CNMRF Tools

This directory contains validation scripts and quality gates for CNMRF.

## Purpose

**Alignment to Project Outline (Section 5):**  
Implements "Quality Gates - PowerShell scripts for validation (structure, links, markdown lint)"

## Contents

### [scripts](scripts/README.md)
PowerShell validation scripts for Windows environments

## Quality Gates

CNMRF provides automated quality gates to ensure:

- Repository structure integrity
- Documentation quality
- Link validity
- Markdown formatting

## Running Quality Gates

```powershell
# Run all quality gates
.\tools\scripts\run-all.ps1

# Run individual gates
.\tools\scripts\verify-structure.ps1
.\tools\scripts\lint-markdown.ps1
.\tools\scripts\check-links.ps1
```

## CI/CD Integration

Quality gates should be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Run Quality Gates
  run: .\tools\scripts\run-all.ps1
  shell: pwsh
```

## Quality Gate Criteria

All quality gates must pass before:
- Merging pull requests
- Releasing new versions
- Publishing templates

## Relationship to Project Outline

Quality gates enforce:

- **Documentation-Driven Principle** (Section 7) - Validate markdown quality
- **Self-Service Success Criterion** (Section 8) - Ensure documentation is complete
- **Comprehensibility Success Criterion** (Section 8) - Validate link integrity

## Contributing Quality Gates

New quality gates must:

1. Be implemented in PowerShell (Windows compatibility)
2. Provide clear pass/fail output
3. Include usage documentation
4. Be integrated into `run-all.ps1`

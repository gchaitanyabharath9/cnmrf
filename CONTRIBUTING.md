# Contributing to CNMRF

Thank you for your interest in contributing to the Cloud-Native Modernization Reference Framework (CNMRF)!

## Before You Contribute

Please read the [Project Outline](docs/governance/project-outline.md) to understand:

- What CNMRF **IS** (a reference framework)
- What CNMRF **IS NOT** (not a product, not commercial)
- Scope boundaries (what will and won't be included)
- Design principles

**All contributions must align with the Project Outline.**

## How to Contribute

### 1. Documentation Improvements

- Fix typos or unclear explanations
- Add examples or clarifications
- Improve diagrams

### 2. New Templates

- Must follow existing design principles
- Must include comprehensive README
- Must pass all quality gates
- Should include example ADR

### 3. New ADRs

- Use the ADR template (`docs/adr/0000-adr-template.md`)
- Document significant architectural decisions
- Explain alternatives considered
- Update ADR index in `docs/adr/README.md`

### 4. Quality Gate Improvements

- Enhance validation scripts
- Add new checks
- Improve error messages

## Contribution Process

### 1. Fork and Clone

```bash
git clone https://github.com/your-username/cnmrf.git
cd cnmrf
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Follow existing patterns and conventions
- Update documentation
- Add tests if applicable

### 4. Run Quality Gates

```powershell
.\tools\scripts\run-all.ps1
```

All quality gates must pass before submitting.

### 5. Commit Changes

```bash
git add .
git commit -m "Brief description of changes"
```

Use clear, descriptive commit messages.

### 6. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Create a pull request with:
- Clear description of changes
- Reference to related issues (if any)
- Explanation of how changes align with Project Outline

## Contribution Guidelines

### Documentation

- Use clear, concise language
- Include examples where helpful
- Use Mermaid for diagrams
- Follow markdown best practices

### Code Templates

- Include inline comments
- Provide comprehensive README
- Follow security baseline (non-root, no secrets)
- Include health checks, metrics, logging

### ADRs

- Use the template format
- Document rationale clearly
- List alternatives considered
- Update status as decisions evolve

## What We're Looking For

✅ **Documentation improvements**  
✅ **Bug fixes**  
✅ **New example implementations**  
✅ **Additional ADRs for common decisions**  
✅ **Quality gate enhancements**  
✅ **Multi-cloud compatibility improvements**  

## What We're NOT Looking For

❌ **Product features** (CNMRF is a framework, not a product)  
❌ **Vendor-specific implementations** (must be platform-neutral)  
❌ **UI dashboards** (outside scope)  
❌ **Runtime automation** (outside scope)  
❌ **Breaking changes to core principles** (requires governance approval)  

## Review Process

1. **Automated Checks:** Quality gates must pass
2. **Alignment Review:** Verify alignment with Project Outline
3. **Technical Review:** Code/documentation quality
4. **Approval:** At least one maintainer approval required
5. **Merge:** Squash and merge to main branch

## Questions?

- Review [Project Outline](docs/governance/project-outline.md)
- Check [Documentation](docs/README.md)
- Open a GitHub Discussion for questions

## Code of Conduct

- Be respectful and professional
- Focus on constructive feedback
- Assume good intentions
- Help create a welcoming community

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

---

Thank you for helping make CNMRF better! 🚀

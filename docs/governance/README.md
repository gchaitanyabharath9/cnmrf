# Governance Documentation

This directory contains project governance, scope control, and decision-making processes for CNMRF.

## Purpose

**Alignment to Project Outline (Section 9):**  
Implements governance and change control processes

## Contents

- **[Project Outline](project-outline.md)** - **THE FOUNDATIONAL DOCUMENT** defining CNMRF's identity, scope, and boundaries

## Project Outline

The [Project Outline](project-outline.md) is the **constitution** of CNMRF. It defines:

1. **Project Identity** - Name, type, license, target audience
2. **Purpose** - Why CNMRF exists
3. **What CNMRF IS** - Reference architecture, templates, ADRs, checklists
4. **What CNMRF IS NOT** - NOT a SaaS product, NOT an automation platform, NOT commercial
5. **Scope Boundaries (FROZEN)** - What WILL and WILL NOT be included
6. **Relationship to Other Work** - How CNMRF relates to papers and potential products
7. **Design Principles** - Platform-neutral, security by default, observability built-in, etc.
8. **Success Criteria** - Self-service adoption, multi-cloud compatibility, comprehensibility
9. **Governance & Change Control** - How to manage scope and principle changes
10. **Anti-Patterns to Avoid** - Feature creep, vendor bias, over-abstraction

## Governance Principles

### Scope Control

**Section 5 (Scope Boundaries) is FROZEN.**

Changes require:
1. Documented rationale
2. Review against "What CNMRF IS NOT" principles
3. Explicit approval in a governance ADR

### Design Principle Changes

**Section 7 (Design Principles) changes require:**
1. ADR documenting the change
2. Impact assessment on existing templates
3. Migration guide if breaking changes are introduced

### Template Additions

New templates must:
1. Align with existing design principles
2. Include comprehensive README and inline documentation
3. Pass all quality gate scripts
4. Include at least one example ADR demonstrating usage

## Anti-Patterns to Avoid

From Project Outline Section 10:

❌ **Feature Creep** - Resist adding "nice-to-have" features that blur framework/product lines  
❌ **Vendor Bias** - Do not optimize for one cloud provider at the expense of others  
❌ **Over-Abstraction** - Keep templates concrete and understandable  
❌ **Underdocumentation** - Every artifact must have clear purpose and usage guidance  
❌ **Implicit Dependencies** - All dependencies must be explicit and documented  

## When in Doubt

Refer back to:

- **Section 4:** What CNMRF IS NOT
- **Section 5:** Scope Boundaries
- **Section 7:** Design Principles

**CNMRF is a framework, not a product.**

## Contributing to Governance

Governance changes require:

1. Proposal via GitHub Issue or Discussion
2. ADR documenting the proposed change
3. Review by maintainers
4. Approval and merge

All governance decisions are documented and versioned in this repository.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

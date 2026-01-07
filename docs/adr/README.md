# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records documenting significant architectural decisions in CNMRF.

## Purpose

**Alignment to Project Outline (Section 5):**  
Implements "ADR Templates - Template + 3-5 example ADRs (auth, observability, resiliency, data management)"

**Design Principle (Section 7):**  
Supports "Opinionated but Adaptable" and "Documentation-Driven" principles by documenting the "why" behind opinions

## What is an ADR?

An Architecture Decision Record (ADR) is a document that captures an important architectural decision along with its context and consequences.

### When to Write an ADR

Write an ADR when:
- Making a significant architectural choice (e.g., authentication approach, observability stack)
- Choosing between multiple viable alternatives
- Establishing a pattern that will be reused across services
- Making a decision that impacts security, resiliency, or operational characteristics

### When NOT to Write an ADR

Do not write an ADR for:
- Implementation details within an already-decided pattern
- Tactical code-level decisions
- Decisions that are easily reversible

## ADR Index

| ID | Title | Status | Date |
|----|-------|--------|------|
| [0000](0000-adr-template.md) | ADR Template | Accepted | 2026-01-06 |
| [0001](0001-authentication-approach.md) | Authentication Approach | Accepted | 2026-01-06 |
| [0002](0002-observability-stack.md) | Observability Stack | Accepted | 2026-01-06 |
| [0003](0003-resiliency-patterns.md) | Resiliency Patterns | Accepted | 2026-01-06 |

## ADR Lifecycle

1. **Proposed** - ADR is drafted and under review
2. **Accepted** - ADR is approved and should be followed
3. **Deprecated** - ADR is no longer recommended but not yet replaced
4. **Superseded** - ADR has been replaced by a newer ADR (reference provided)

## Using the Template

1. Copy `0000-adr-template.md`
2. Rename with next sequential number: `XXXX-title-in-kebab-case.md`
3. Fill in all sections
4. Update the index table above
5. Submit for review

## ADR Format

All ADRs follow this structure:

- **Title** - Short, descriptive title
- **Status** - Proposed | Accepted | Deprecated | Superseded
- **Context** - What is the issue we're facing?
- **Decision** - What have we decided to do?
- **Consequences** - What are the positive and negative outcomes?
- **Alternatives Considered** - What other options were evaluated?

## Relationship to Project Outline

ADRs are critical to CNMRF's "Opinionated but Adaptable" principle (Section 7):

- **Opinionated:** ADRs document strong defaults based on best practices
- **Adaptable:** ADRs explain the rationale, allowing teams to make informed customizations
- **Traceable:** All architectural decisions are documented and versioned

## Contributing ADRs

When contributing a new ADR:

1. Ensure it aligns with [Project Outline](../governance/project-outline.md) scope
2. Use the template format
3. Provide clear rationale and alternatives
4. Update this index
5. Reference from relevant documentation or templates

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# CNMRF Documentation

This directory contains all documentation for the Cloud-Native Modernization Reference Framework.

## Documentation Structure

### [Architecture](architecture/README.md)
Reference architecture, system diagrams, and design patterns.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Architecture Guidance - Reference architecture docs, Mermaid diagrams, NFR baselines"

### [ADR (Architecture Decision Records)](adr/README.md)
Structured records of architectural decisions, templates, and examples.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "ADR Templates - Template + 3-5 example ADRs"

### [Security](security/README.md)
Security baselines, patterns, and implementation guidance.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Security Baselines - Non-root containers, RBAC templates, secret management patterns, network policies"

### [Resiliency](resiliency/README.md)
Resiliency patterns including circuit breakers, retries, timeouts, and graceful shutdown.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Resiliency Patterns - Circuit breakers, retries, timeouts, health checks, graceful shutdown"

### [Platform](platform/README.md)
Platform engineering guidance for building internal developer platforms on Kubernetes.

**Alignment to Project Outline:**  
Supports Section 7 Design Principle: "Platform-Neutral First"

### [CI/CD](cicd/README.md)
Reference CI/CD patterns and pipeline examples.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Quality Gates" and supports GitOps-ready principle

### [Governance](governance/README.md)
Project governance, scope control, and decision-making processes.

**Alignment to Project Outline:**  
Contains the foundational [Project Outline](governance/project-outline.md) that defines CNMRF's identity and boundaries

## Reading Path

### For Architects
1. [Project Outline](governance/project-outline.md) - Understand scope and principles
2. [Reference Architecture](architecture/README.md) - Review system design patterns
3. [ADR Index](adr/README.md) - Understand key decisions

### For Engineers
1. [Project Outline](governance/project-outline.md) - Understand what CNMRF is (and isn't)
2. [Security Baseline](security/README.md) - Review security requirements
3. [Resiliency Patterns](resiliency/README.md) - Implement resiliency patterns
4. Service templates in `/templates` - Start implementation

### For Platform Teams
1. [Platform Engineering Guide](platform/README.md) - Platform design patterns
2. [CI/CD Patterns](cicd/README.md) - Pipeline and GitOps setup
3. [Reference Architecture](architecture/README.md) - Overall system design

## Documentation Principles

All documentation in CNMRF follows these principles (from Section 7 of the Project Outline):

1. **Documentation-Driven:** Every template includes inline comments and corresponding docs
2. **Self-Service:** Teams can adopt CNMRF by reading documentation alone
3. **Comprehensible:** Engineers should understand purpose and usage within 30 minutes
4. **Traceable:** All decisions documented via ADRs with clear rationale

## Contributing to Documentation

When adding or updating documentation:

1. Ensure alignment with [Project Outline](governance/project-outline.md)
2. Reference relevant ADRs
3. Include diagrams where helpful (use Mermaid)
4. Provide concrete examples
5. Run `tools\scripts\lint-markdown.ps1` before committing

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

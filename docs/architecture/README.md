# Architecture Documentation

This directory contains reference architecture documentation for cloud-native modernization.

## Purpose

**Alignment to Project Outline (Section 5):**  
Implements "Architecture Guidance - Reference architecture docs, Mermaid diagrams, NFR baselines"

**Design Principle (Section 7):**  
Supports "Platform-Neutral First" and "Documentation-Driven" principles

## Contents

- **[Reference Architecture](reference-architecture.md)** - Core architectural patterns and system design
- **[NFR Baseline](nfr-baseline.md)** - Non-functional requirements baseline
- **Diagrams** - Mermaid diagrams illustrating system architecture

## Key Architectural Principles

Based on the Project Outline (Section 7), all architecture guidance follows:

1. **Platform-Neutral First**
   - Kubernetes as baseline abstraction
   - No cloud-specific APIs in core patterns
   - Cloud-specific extensions documented separately

2. **Security by Default**
   - Non-root containers
   - Least-privilege RBAC
   - External secret management

3. **Observability Built-In**
   - Structured logging (JSON)
   - Prometheus metrics
   - OpenTelemetry tracing

4. **Resiliency as Baseline**
   - Circuit breakers, retries, timeouts
   - Graceful shutdown
   - Resource limits and autoscaling

## Target Audience

- Enterprise architects designing cloud-native systems
- Platform teams establishing architectural standards
- Senior engineers making technology decisions

## How to Use

1. Start with [Reference Architecture](reference-architecture.md) for overall system design
2. Review [NFR Baseline](nfr-baseline.md) for non-functional requirements
3. Reference relevant ADRs in `/docs/adr` for decision rationale
4. Apply patterns to service templates in `/templates`

## Relationship to Templates

Architecture documentation provides the **WHY** and **WHAT**.  
Service templates in `/templates` provide the **HOW**.

All templates must align with architectural principles documented here.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

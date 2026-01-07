# Architecture Repository Structure

The CNMRF Architecture Repository organizes all architectural assets, aligned with the TOGAF Enterprise Continuum.

## 1. Repository Metamodel

```mermaid
graph TD
    Repo[Architecture Repository]
    
    Repo --> Meta[Architecture Metamodel]
    Repo --> Landscape[Architecture Landscape]
    Repo --> RefLib[Reference Library]
    Repo --> Standard[Standards Information Base]
    Repo --> Gov[Governance Log]
    
    Landscape --> Baseline[Baseline Arch]
    Landscape --> Target[Target Arch]
    
    RefLib --> Patterns[Patterns (CNMRF)]
    RefLib --> Templates[Templates (Spring/.NET)]
    
    Standard --> Principles[Principles]
    Standard --> Catalog[Product Catalog (SBB)]
    
    Gov --> Decisions[ADRs (Decisions)]
    Gov --> Compliance[Compliance Assessments]
```

## 2. Content Structure

### A. Architecture Metamodel
*   The structure of how we describe architecture (Diagrams, ADRs, Catalog).

### B. Architecture Landscape
*   **Strategic Architectures:** Long-term roadmaps (`docs/architecture/roadmap/`).
*   **Segment Architectures:** Domain-specific views (e.g., "Payments Architecture").
*   **Capability Architectures:** Solution designs for specific projects.

### C. Reference Library
*   **Reference Architectures:** The CNMRF Patterns (`docs/architecture/`, `docs/security/`, etc.).
*   **Guidelines:** Development guides (`docs/architecture/nfr-12factor.md`).
*   **Templates:** Starter code and project structures.

### D. Standards Information Base
*   **Principles:** `docs/governance/standards-catalog.md`.
*   **Standards Catalog:** The list of approved technologies (ABB/SBB).

### E. Governance Log
*   **Decisions:** Architecture Decision Records (`docs/adr/`).
*   **Compliance:** Records of ARB reviews and waiver approvals.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# TOGAF ADM Mapping Guide

## 1. Overview

This document maps the TOGAF Architecture Development Method (ADM) to the specific artifacts and activities within the CNMRF modernization lifecycle.

## 2. Phase Mapping

| TOGAF Phase | CNMRF Objective | Deliverables (Inputs/Outputs) |
| :--- | :--- | :--- |
| **Preliminary** | Establish Principles | `docs/governance/standards-catalog.md` (Principles), ARB Charter |
| **A: Vision** | Define Scope | Project Charter, Stakeholder Map, `docs/architecture/roadmap/state-transition.md` |
| **B: Business** | Domain Discovery | Context Maps, Event Storming Output, Business Capability Model |
| **C: Info Sys** | App/Data Design | `docs/architecture/end-to-end-view.md`, API Contracts (OpenAPI), Schema Registry |
| **D: Tech Arch** | Infrastructure | `docs/platform/`, IaC Repo (Terraform), CI/CD Strategy |
| **E: Opportunities**| Gap Analysis | Transition Architectures (Steps 1-N), TCO Analysis |
| **F: Migration** | Implementation Plan | Backlog / Roadmap, Migration Waves |
| **G: Governance** | Implementation | Architecture Compliance Reviews, Code Reviews, SAST/SCA Reports |
| **H: Change** | Ops & Improvement | Incident Reports, Architecture Debt Backlog, ADR updates |

## 3. Architecture Definitions

*   **Baseline Architecture:** The current state (Legacy Monolith). Documented in "As-Is" diagrams.
*   **Target Architecture:** The desired state (Cloud-Native Microservices). Documented in CNMRF reference patterns.
*   **Transition Architectures:** Interim states (e.g., "Hybrid with Strangler Fig") that bridge the gap.

## 4. Key Risks & Mitigations

*   **Risk:** Scope Creep in Phase A.
    *   **Mitigation:** Strict Business Capability mapping.
*   **Risk:** Technology drift in Phase G.
    *   **Mitigation:** Automated CI/CD guardrails and periodic ARB compliance checks.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

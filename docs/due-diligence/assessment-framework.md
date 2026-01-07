# Due Diligence Assessment Framework

## 1. Assessment Checklist

### A. Architecture
*   [ ] **Loose Coupling:** Are services independent?
*   [ ] **State:** Is state externalized (Redis/DB) or local (Memory)?
*   [ ] **Dependencies:** Are all rigid dependencies (mainframe, legacy MQ) mapped?

### B. Security
*   [ ] **Identity:** Is legacy Auth compatible with OIDC?
*   [ ] **Secrets:** Are secrets hardcoded?
*   [ ] **Data:** Is PII identified and tagged?

### C. Operations
*   [ ] **Logs:** Are logs structured (JSON) or unstructured text?
*   [ ] **Config:** Is configuration separate from code?
*   [ ] **Health:** Do health checks exist?

## 2. Risk Register

| ID | Application | Risk Description | Probability | Impact | Mitigation Plan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **R01**| OrderSvc | Relies on shared stored procedures | High | Critical | Migration to Java Logic |
| **R02**| UserDB | Contains unencrypted PII | Medium | High | Encrypt at rest before migration |

## 3. Evidence Artifacts

*   [ ] **Service Topology Map:** Visual dependency graph.
*   [ ] **Dependency Scan Report:** List of libraries and licenses.
*   [ ] **Performance Baseline:** Current TPS and Latency metrics.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# Environment Quality Gates

## 1. Governance Gates

### A. Environment Entry/Exit Checklist

| Gate | Dev (Exit) | SIT (Exit) | UAT (Exit) | Prod (Entry) |
| :--- | :--- | :--- | :--- | :--- |
| **Unit Tests** | 80% Coverage | N/A | N/A | N/A |
| **Static Analysis**| 0 Critical | N/A | N/A | N/A |
| **Contract Tests** | N/A | 100% Pass | N/A | N/A |
| **Performance** | N/A | N/A | Baseline Met | SLO Validation |
| **Security Scan** | Image Scan Pass| N/A | Pen Test (Major)| Final Sign-off |
| **Approver** | Tech Lead | QA Lead | Product Owner | Change Board |

## 2. Test Data Management Policy

*   **No PII in Non-Prod:** It is a violation of CNMRF policy to clone unmasked production data to Dev, SIT, or UAT.
*   **Synthetic Data:** Preferred for Dev. Generated via tools (Faker).
*   **Masking:** Required for SIT/UAT if using prod dumps. All PII fields (Name, Email, SSN) must be scrambled or substituted.

## 3. Templates

### Deployment Approval Checklist

*   [ ] **Artifact:** SHA matches scanned image?
*   [ ] **Config:** Reviewed for Prod values (no debug flags)?
*   [ ] **Database:** Schema migrations tested in UAT?
*   [ ] **Rollback:** Plan defined and tested?
*   [ ] **Alerts:** Validated and active?

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

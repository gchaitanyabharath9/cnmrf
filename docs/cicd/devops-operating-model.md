# DevOps Operating Model

## 1. Governance Structure

To support a cloud-native platform, the operating model transforms from distinct silos to cross-functional collaboration.

| Role | Responsibility | 
| :--- | :--- |
| **Product Team** | End-to-end service ownership, coding features, writing tests, defining SLIs. |
| **Platform Team** | Curating the "Golden Path," maintaining the IDP, K8s clusters, and CI/CD templates. |
| **SRE Team**| Managing observability platform, critical incident response, and defining SLO policy. |
| **SecOps** | Defining policy-as-code (OPA), managing identity (IdP), and audit. |

## 2. Infrastructure as Code (IaC) Lifecycle

Infrastructure is treated exactly like application code.

1.  **Code:** Defined in HCL (Terraform), Bicep, or ARM templates.
2.  **Review:** PR process with mandatory "Plan" review before "Apply."
3.  **State:** Remote state locking (S3/DynamoDB or Azure Storage Account).
4.  **Drift:** Periodic drift detection to ensure reality matches code.

## 3. Operational Readiness

Before going live, a service must pass the Operational Readiness Review (ORR):

*   [ ] **Observability:** Dashboards and Alerts created via code.
*   [ ] **Runbooks:** Documented steps for common incidents.
*   [ ] **Resiliency:** Circuit breaker thresholds tested.
*   [ ] **Secrets:** All secrets rotated and injected via Vault/K8s Secrets.
*   [ ] **Disaster Recovery:** RPO/RTO validation complete.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

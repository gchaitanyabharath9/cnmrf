# CNMRF Diagram Catalog

## 1. Inventory

| ID | Diagram Name | Notation | View Type | Audience | CNMRF Link |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **VIS-01** | Reference Architecture | Visio | Layered | Exec/Lead | `architecture/end-to-end-view.md` |
| **VIS-02** | TOGAF ADM Lifecycle | Visio | Process | Architect | `governance/togaf-adm-mapping.md` |
| **VIS-03** | Network Segments | Visio | Infrastructure | Security | `security/network/firewall-proxy-arch.md` |
| **UML-01** | API Security Flow | UML Sequence | Security | Dev/Sec | `security/api-security.md` |
| **UML-02** | B2B Onboarding | UML Sequence | Integration | Partner | `security/network/firewall-proxy-arch.md` |
| **UML-03** | Data Migration | UML Activity | Data | DBA | `migration/strategy-guide.md` |
| **AM-01** | Strategy & Motivation | ArchiMate | Business | Exec | `governance/standards-catalog.md` |
| **MER-01** | GitOps Promotion | Mermaid | Pipeline | DevOps | `cicd/promotion-model.md` |
| **MER-02** | Cost Governance | Mermaid | Loop | FinOps | `cost/billing-model/usage-projection.md` |

## 2. Visio Build Specs

### VIS-01: End-to-End Reference Architecture
*   **Page:** Widescreen (16:9)
*   **Layers:** L1 (Business), L2 (App), L3 (Data), L4 (Cloud Infra).
*   **Stencils:** "Cloud/Compute", "Database", "User", "Firewall".
*   **Style:** Flat design, vendor-neutral colors (Blue/Grey).

### VIS-03: Network Segments
*   **Containers:** "Internet", "DMZ", "Trusted", "Data".
*   **Connectors:** Red dashed (Untrusted), Green solid (mTLS).

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

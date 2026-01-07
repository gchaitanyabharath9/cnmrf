# DNS Strategy & Patterns

## 1. Split-Horizon & Zone Strategy

*   **Public Zone (`api.example.com`):** Resolves internet traffic to Public Load Balancer or CDN.
*   **Private Zone (`internal.example.com`):** Resolves internal traffic within VPC/Intranet boundaries.
*   **Service Discovery (`svc.cluster.local`):** Native Kubernetes/Platform resolution for east-west traffic.

**Trade-offs:** 
*   *Split-Horizon* increases complexity but is mandatory for Zero Trust network segmentation.

## 2. Global Traffic Management (GTM)

*   **Weighted Routing:** Percentage-based distribution (e.g., 95% v1, 5% v2). Useful for broad canary releases but suffers from DNS caching issues.
*   **Failover Routing:** Active/Passive switching based on Health Checks. Critical for DR.
*   **Geo-Routing:** Route users to nearest region based on IP.

## 3. TTL Strategy

| Environment | Record Type | TTL | Rationale |
| :--- | :--- | :--- | :--- |
| **Prod** | A / CNAME | 300s (5m) | Balance between cache efficiency and failover speed. |
| **Migration** | A / CNAME | 60s (1m) | Lowered during cutover windows to enable fast rollback. |
| **Internal** | SRV / A | 30s | Highly dynamic internal endpoints. |

## 4. Cutover Playbook

1.  **Preparation:** Lower TTL to 60s, 24 hours in advance.
2.  **Validation:** Verify new target endpoint health.
3.  **Switch:** Update DNS record to new target.
4.  **Verification:** Monitor traffic ramps and error rates.
5.  **Clean-up:** Restore TTL to 300s after stability confirmed.

## 5. Governance

*   **Access:** Only Network Admins or Automated Pipelines may alter Prod DNS.
*   **Audit:** All changes logged with: `User`, `Time`, `Old Value`, `New Value`, `Reason`.

## Diagram: Split-Horizon DNS

```mermaid
graph TD
    title Split-Horizon DNS Architecture
    
    User[External User] -->|Query api.corp.com| PubDNS[Public DNS]
    PubDNS -->|Resolves| PubIP[Public IP (DMZ LB)]
    
    Svc[Internal Service] -->|Query db.internal| PrivDNS[Private DNS]
    PrivDNS -->|Resolves| PrivIP[Private IP (DB)]
    
    subgraph "Trust Boundary"
    PubDNS
    end
    
    subgraph "Internal Network"
    PrivDNS
    end
```

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

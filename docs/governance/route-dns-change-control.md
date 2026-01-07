# Governance: Routing & DNS Change Control

## 1. Change Classification

*   **Standard Change:** New Service Path, Canary Weight Adjustment. (Peer Review).
*   **Major Change:** DNS Zone updates, WAF Rule changes, Global Failover. (ARB Approval).

## 2. Evidence Requirements

For every Production routing change:
1.  **Ticket:** JIRA/ServiceNow ID.
2.  **Plan:** YAML diff of the proposed route config.
3.  **Result:** `curl -I` verification of headers/status before & after.
4.  **Rollback:** Specific Git Revert commit ID ready to merge.

## 3. Environment Propagation

`Dev` -> `SIT` -> `UAT` -> `Prod`.
*Traffic rules must be promoted identically to code artifacts to prevent "it works in dev" routing failures.*

## Diagram: Traffic Shifting Comparison

```mermaid
graph TD
    title Traffic Shifting Layers
    
    subgraph "DNS Layer (Global)"
    DNS[DNS Record] -->|Weight 90/10| DC1
    DNS --> DC2
    end
    
    subgraph "LB Layer (Regional)"
    LB[Load Balancer] -->|Weight 50/50| VM_Pool_A
    LB --> VM_Pool_B
    end
    
    subgraph "Mesh Layer (Service)"
    Mesh[Sidecar Proxy] -->|Header: Beta| Pod_V2
    Mesh -->|Default| Pod_V1
    end
```

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

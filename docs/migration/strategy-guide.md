# Migration Strategy Guide

## 1. Decision Matrix (The "6 Rs")

| Strategy | Definition | Use Case | Effort | Value |
| :--- | :--- | :--- | :--- | :--- |
| **Rehost** | Lift & Shift VM to Cloud | Legacy COTS, Low-Code Apps | Low | Low |
| **Refactor**| Minor changes (Containerize) | Tomcat/IIS Web Apps | Medium | Medium |
| **Rearchitect**| Rewrite as Microservices | Monolithic Core Logic | High | High |
| **Replace** | Buy SaaS / COTS | Commodore HR System | Medium | High |

## 2. Integration Migration Strategy (Strangler Fig)

1.  **Intercept:** Place a facade (API Gateway) in front of the Legacy System.
2.  **Redirect:** Route new traffic (e.g., `/v2/orders`) to the Microservice.
3.  **Fallback:** Route unmatched traffic (e.g., `/v1/legacy`) to the Monolith.
4.  **Decommission:** Once 100% of traffic is routed, turn off the Monolith.

## 3. Data Migration Pattern

*   **Bulk Load:** Nightly export/import of historical data.
*   **Delta Sync:** Use Change Data Capture (Debezium) to replay live updates during transition.
*   **Cutover:**
    *   Stop Writes to Legacy.
    *   Wait for Delta Sync to reach 0 lag.
    *   Enable Writes on Cloud.

## 4. Rollback Strategy

If error rate > 1% during Cutover:
1.  **Stop Traffic** to Cloud.
2.  **Reverse Sync:** Replay Cloud writes back to Legacy (if Dual-Write enabled).
3.  **Switch DNS** back to Legacy Load Balancer.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

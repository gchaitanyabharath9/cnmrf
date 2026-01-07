# Migration Traffic Cutover

## 1. Cutover Strategies

| Method | Granularity | Rollback Speed | Best For |
| :--- | :--- | :--- | :--- |
| **DNS Switch** | Coarse (All/None) | Slow (TTL dependent) | Datacenter-level moves. |
| **LB Weighting** | Percentage | Fast | Monolith to Microservice split. |
| **Gateway Header** | Request Identity | Instant | Canary Testing (Internal). |

## 2. Cutover Playbook (Strangler Fig)

1.  **Dual Run:** Deploy New Service alongside Legacy.
2.  **Shadow:** Gateway relies traffic to New Service (fire-and-forget) to validate load.
3.  **Canary:** Route 1% of public traffic to New Service.
4.  **Ramp:** Increase to 10%, 50%, 100%.
5.  **Decommission:** Power down Legacy after 2-week stability.

## 3. Observability Gates

Before advancing any ramp step:
*   [ ] Error Rate < 0.1% (or baseline).
*   [ ] P99 Latency within 10% of baseline.
*   [ ] Saturation (CPU) < 70%.

## Diagram: Migration Flow

```mermaid
graph TD
    title Migration Traffic Shift
    
    Start((Start)) --> DualRun[Dual Run: Deploy V2]
    DualRun --> Shadow[Shadow Traffic: Verify Load]
    Shadow --> Canary[Canary: 1% Real Users]
    
    Canary --> Check{Healthy?}
    Check -->|No| Rollback[Revert to V1]
    Check -->|Yes| Ramp[Ramp to 100%]
    
    Ramp --> Decomm[Decommission V1]
```

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

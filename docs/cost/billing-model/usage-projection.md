# Usage & Billing Projection Model

## 1. Usage Dimensions

We model cost based on **Architecture Usage**, not vendor price lists (which change).

*   **Compute:** Request Rate (RPS) + Processing Time (ms).
*   **Storage:** Data Volume (GB) + IOPS.
*   **Network:** Egress Transfer (GB).
*   **Events:** Message Count + Retention Period.

## 2. Projection Templates

### A. Baseline (Current State)
*   **Users:** 10,000 Daily Active.
*   **Traffic:** 50 RPS peak.
*   **Storage:** 500 GB.
*   **Est. Units:** 2 Nodes (4vCPU each).

### B. Growth (Year 1)
*   **Users:** 50,000 (+400%).
*   **Traffic:** 250 RPS.
*   **Storage:** 2 TB.
*   **Est. Units:** 6 Nodes (Autoscaled).

## 3. Cost Guardrails

*   **Budgets:** Set alerts at 50%, 80%, and 100% of forecast estimate.
*   **Resource Quotas:** Hard limit on Namespace CPU/Memory to prevent accidental huge bills (e.g., crypto mining or loop bugs).
*   **Retention:** Enforce 30-day deletion on Dev logs, 90-day archive on Prod logs.

## 4. Comparison to Data Center

| Cost Driver | Data Center (CapEx) | Cloud Native (OpEx) |
| :--- | :--- | :--- |
| **Commitment** | 3-5 Year Server Buy | Pay-per-second / Month |
| **Capacity** | Peak sizing (Idle waste) | Autoscaling (Just-in-time) |
| **Ops Team** | Hardware Maintenance | Platform Engineering |

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# Cost Optimization Patterns

## 1. Minimal-Cost Build Strategies

*   **Cache Dependencies:** Store local Maven/NuGet caches on persistent volume or CI cache service to reduce download costs.
*   **Parallelism:** Fail fast. Don't run long integration tests if unit tests fail.
*   **Ephemeral Agents:** Use spot instances for CI build agents.

## 2. Runtime Cost Optimization

*   **Right-Sizing:** Use VPA (Vertical Pod Autoscaler) in "Off" mode to recommend CPU/RAM requests, then apply manually.
*   **Scale-to-Zero:** For non-prod dev environments or batch processors, scale replicas to 0 when idle (KEDA).
*   **Spot Instances:** Use Spot/Preemptible nodes for stateless services and batch jobs.
*   **Environment Shutdown:** Automatically delete ephemeral preview environments after PR merge.

## 3. Environment Strategy

| Env | Purpose | Sizing Strategy |
| :--- | :--- | :--- |
| **Dev** | Active Development | Namespace-per-team, minimal quotas, spot nodes. |
| **Test** | Integration Testing | Ephemeral environments created per PR. |
| **Stage** | Pre-Prod Verification | Mirror of Prod but with reduced redundancy (single AZ). |
| **Prod** | Live Traffic | Multi-AZ, Reserved/Savings Plan instances. |

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

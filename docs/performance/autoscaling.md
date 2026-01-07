# Autoscaling Architecture

## 1. Scaling Decisions

| Metric | Tool | Use Case |
| :--- | :--- | :--- |
| **CPU / Memory** | **HPA** (Horizontal Pod Autoscaler) | Stateless HTTP services with compute-bound workload. |
| **Queue Depth** | **KEDA** (Kubernetes Event-Driven Autoscaling) | Async workers processing Kafka/MQ messages. |
| **Request Rate** | **HPA + Custom Metrics** | High-throughput APIs where CPU isn't the bottleneck. |
| **Vertical** | **VPA** (Vertical Pod Autoscaler) | Stateful sets or single-threaded legacy apps (careful with restarts). |

## 2. Scale-to-Zero

**Intent:** Save cost by removing all replicas when idle.
**Usage:** Use KEDA ScaledObject with `minReplicaCount: 0`. Suitable for dev environments or sporadic batch processors. NOT for low-latency user-facing APIs (cold start penalty).

## 3. Capacity Planning

*   **Baseline:** Minimum replicas needed for p50 load + HA (min 2 per AZ).
*   **Burst:** Max replicas allowed by quota.
*   **Failover:** Ensure cluster has enough head-room to absorb a zonal failure (50% valid capacity).

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

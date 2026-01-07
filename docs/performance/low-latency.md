# Low-Latency & Tuning

## 1. Latency Budgeting (Sample)

**Target:** 500ms API Response (p99) at the Edge.

| Component | Budget | Mitigation |
| :--- | :--- | :--- |
| **Network (WAN)** | 100ms | Use CDN, TCP Fast Open, TLS 1.3 |
| **Gateway** | 50ms | Caching policies, keep-alive connections |
| **Service Logic** | 50ms | Async non-blocking I/O, optimized payload |
| **Database** | 200ms | Indexing, Read Replicas, Query Tuning |
| **Buffer** | 100ms | Retry jitter, variability |

## 2. Tuning Checklists

### Database
*   [ ] Indexes cover all `WHERE` and `JOIN` clauses.
*   [ ] Connection Pool: `maxLifetime` < DB timeout. `minIdle` maintained for bursts.
*   [ ] Read Replicas used for reporting/analytics queries.

### Kafka
*   [ ] **Linger.ms:** Set to 5-10ms to batch small messages (throughput vs latency tradeoff).
*   [ ] **Compression:** Use `snappy` or `lz4` for high volume.
*   [ ] **Fetch Min Bytes:** Tune for consumer batching.

### JVM (Spring Boot)
*   [ ] **G1GC:** Default for heaps > 4GB.
*   [ ] **Heap Size:** Set `Xms` = `Xmx` to prevent resizing jitter in containers.

### .NET (Core)
*   [ ] **Server GC:** Enabled by default. ensure `DOTNET_gcServer=1`.
*   [ ] **Tiered Compilation:** Enabled for faster startup and steady-state optimization.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

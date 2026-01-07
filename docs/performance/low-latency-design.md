# Low-Latency & High-Performance Design

## 1. Latency Budget Template

Defining measurable targets is the first step to high performance.

| Operation | P50 Target (Typical) | P95 Target (Outlier) | P99 Target (Worst Case) |
| :--- | :--- | :--- | :--- |
| **API Response (Read)** | 50ms | 100ms | 250ms |
| **API Response (Write)**| 100ms | 200ms | 500ms |
| **Database Query** | 5ms | 15ms | 50ms |
| **Messaging End-to-End**| 100ms | 500ms | 1s |

## 2. Design Pattern: Critical Path Optimization

**Concept:** Identify the blocking sequence of calls required to return a response to the user. Minimize this path relentlessly.

*   **Caching:** Place data closer to the user (Edge > Gateway > App Memory > Redis).
*   **Async Offloading:** If it doesn't need to happen *now* to answer the user, put it on a queue (e.g., sending emails, updating analytics).
*   **Payload Shaping:** Use GraphQL or "Field Filtering" to return only requested data (reducing network serialization).

## 3. Protocol Tuning Checklist

*   [ ] **HTTP/2:** Enable for multiplexing (Spring Boot / Kestrel).
*   [ ] **Compression:** Enable GZIP/Brotli for payloads > 1KB.
*   [ ] **Connection Pooling:** 
    *   Set `maxLifetime` < firewall timeouts.
    *   Use connection keep-alive.
*   [ ] **Protobuf:** Consider gRPC for high-volume internal east-west traffic.

## 4. Observability Signals (USE Method)

*   **Utilization:** CPU/Memory usage %.
*   **Saturation:** Thread pool depth, connection pool waiters.
*   **Errors:** HTTP 5xx rate, Exception counts.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

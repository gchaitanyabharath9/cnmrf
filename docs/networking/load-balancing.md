# Load Balancing Standards

## 1. Topologies & Responsibilities

| Type | Layer | Role | Target |
| :--- | :--- | :--- | :--- |
| **Network LB** | L4 | TCP/UDP Packet Distribution, Passthrough | Ingress Controller |
| **App LB / Ingress** | L7 | HTTP Routing, TLS Termination, WAF | Services |
| **Service Mesh** | L7 | mTLS, Retries, Fine-grained Traffic Shift | Pods/Containers |

## 2. Configuration Best Practices

*   **Health Checks:**
    *   *Mechanism:* Layer 7 HTTP GET `/health`.
    *   *Tuning:* `Interval=10s`, `Timeout=5s`, `UnhealthyThreshold=3`.
*   **Connection Draining:**
    *   *Setting:* `deregistration_delay` > `max_request_timeout` (e.g., 60s).
    *   *Intent:* Allow in-flight requests to complete during deployment churn.
*   **TLS Termination:**
    *   *Edge:* Terminate at L7 Ingress for inspection.
    *   *Internal:* Re-encrypt (mTLS) from Ingress to Service for Zero Trust.

## 3. Optimization

*   **Keep-Alive:** Enable to reuse backend TCP connections, reducing CPU overhead.
*   **Rate Limiting:** Apply at L7 Ingress for DDoS protection (e.g., 1000 req/sec per IP).
*   **Sticky Sessions:** **Avoid.** State should be externalized (Redis). Only use cookies for legacy app compat.

## Diagram: End-to-End Edge Routing

```mermaid
graph LR
    title End-to-End Edge Routing Path
    
    User[User Device] -->|DNS Query| DNS[Global DNS]
    DNS -->|A Record| CDN[CDN / WAF]
    CDN -->|Filtered Traffic| NLB[L4 Load Balancer]
    
    NLB -->|Passthrough| Ingress[L7 Ingress / Gateway]
    Ingress -->|TLS Terminate| Service[Microservice]
    
    subgraph "DMZ"
    CDN
    NLB
    end
    
    subgraph "Trusted Zone"
    Ingress
    Service
    end
```

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

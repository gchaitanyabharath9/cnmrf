# End-to-End Reference Architecture & Patterns

## 1. Intent
This document provides the high-level "North Star" architecture for the Cloud-Native Modernization Reference Framework (CNMRF). It illustrates how the diverse patterns (Security, Integration, Data) come together in a cohesive, production-ready system.

## 2. Global Architecture Diagram

```mermaid
graph TD
    user((User)) -->|HTTPS/WAF| CDN[CDN / Edge]
    CDN -->|HTTPS| GWAY[API Gateway\n(Apigee / DataPower)]
    
    subgraph "DMZ / Ingress Layer"
        GWAY -->|mTLS + JWT| ING[K8s Ingress Controller]
    end
    
    subgraph "Trusted Zone (Zero Trust)"
        ING -->|mTLS| A[Service A\n(BFF / Aggregator)]
        A -->|mTLS + Token Exchange| B[Service B\n(Domain Service)]
        A -->|Async Event| K[Kafka Cluster]
        
        B -->|mTLS| C[Service C\n(Core Data)]
        C -->|JDBC/TDS| DB[(Primary DB)]
        
        K -->|Consumer Group| D[Service D\n(Async Processor)]
        D -->|Archive| OBJ[(Object Store)]
    end
    
    subgraph "Identity Provider"
        IDP[PingFederate / OIDC]
    end
    
    GWAY -.->|Introspect| IDP
    A -.->|Validate| IDP
```

## 3. Core Layers

### North-South Traffic (The Front Door)
*   **CDN/WAF:** First line of defense.
*   **API Gateway (North-South):** (Apigee / DataPower). Handles authentication offload, coarse-grained authorization, rate limiting, and threat protection.
*   **Ingress Controller:** K8s entry point, handling routing to services.

### East-West Traffic (The Mesh)
*   **Service-to-Service:** Secured via mTLS (Service Mesh or Framework-level).
*   **Policies:** Zero Trust architecture. No request is trusted implicitly based on network location.
*   **Protocol:** HTTP/2 (gRPC) or REST over HTTP/1.1.

### Data & State
*   **Persistence:** Polyglot persistence (RDBMS for transactional, NoSQL for documents/graphs).
*   **Caching:** Distributed caching (Redis) for read-heavy workloads.
*   **Event Log:** Immutable event streams (Kafka) for decoupling.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

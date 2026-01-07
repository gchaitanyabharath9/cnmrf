# API Gateway Patterns

## 1. Role of the Gateway

The API Gateway (e.g., Google Apigee, IBM DataPower) acts as the single entry point for north-south traffic. It handles cross-cutting concerns before traffic hits the cluster.

## 2. Gateway vs. Service Mesh

| Feature | API Gateway (North-South) | Service Mesh (East-West) |
| :--- | :--- | :--- |
| **Primary Role** | Edge Security, Monetization, Partner API | Service-to-Service Reliability, mTLS |
| **Auth** | OAuth2, API Keys, Third-party Fed | mTLS, JWT Validation |
| **Routing** | DNS-based, Coarse Path | Latency-aware, Retry logic, Circuit breaking |
| **Network** | Public Internet -> DMZ | Private Cluster Network |

## 3. Common Policies

### Threat Protection
*   **JSON/XML Threat Protection:** Limit payload size, depth, and element count to prevent DoS.
*   **SQL Injection (SQLi) / XSS:** WAF rules at the edge.

### Traffic Management
*   **Spike Arrest:** smooths traffic bursts (e.g., 100ps). Protects upstream services from crashing.
*   **Quota:** Business limit (e.g., 5000 calls / month). Enforces monetization tiers.

### Mediation
*   **Header Injection:** Inject `X-Correlation-ID` if missing.
*   **Transformation:** JSON to XML (legacy) or masking sensitive fields.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

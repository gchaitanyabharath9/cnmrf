# Routing & Traffic Governance

## 1. Routing Strategies

*   **Host-Based:** `api.sales.corp` vs `api.hr.corp`. Strongest isolation.
*   **Path-Based:** `api.corp.com/sales` vs `api.corp.com/hr`. Efficient IP usage, requires strict prefix governance.
*   **Header-Based (Canary):** Key-value matching (e.g., `x-user-type: beta`). Instant, zero-downtime routing.

## 2. API Versioning

*   **Path Strategy:** `/v1/resources` is the standard.
*   **Deprecation:**
    1.  Publish `/v2`.
    2.  Add `Sunset` header to `/v1`.
    3.  Monitor logs for legacy usage.
    4.  Hard cutover after Sunset Date.

## 3. Governance: Route-as-Code

All routing rules must be defined declaratively (YAML/JSON) in Git.

### Generic Route Schema Example

```yaml
kind: RouteRule
metadata:
  name: checkout-service
spec:
  host: stored.corp.com
  rules:
    - match:
        path: /v1/checkout
        headers: { x-canary: "true" }
      backend: checkout-v2
      weight: 100
    - match:
        path: /v1/checkout
      backend: checkout-v1
      weight: 100
```

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

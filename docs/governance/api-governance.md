# API Governance & Lifecycle

## 1. API Design Standard

*   **Contract First:** All APIs must define an OpenAPI 3.0+ Spec **before** coding.
*   **Versioning:**
    *   **URI Versioning:** `/v1/orders` (Major versions).
    *   **Compatible Changes:** Additive fields only. No breaking changes in minor updates.
*   **Naming:** Use plural nouns (`/orders`, not `/order`). Kebab-case for URLs (`/customer-profiles`).

## 2. Lifecycle States

1.  **Draft:** Design phase. Mocking allowed.
2.  **Active:** Production ready. Supported.
3.  **Deprecated:** Sunset notice given. `Deprecation` header added.
4.  **Retired:** Endpoint returns 410 Gone.

## 3. Governance Gates (CI/CD)

The pipeline enforces governance via "Policy as Code" (e.g., OPA / Spectral).

*   **Linting:** `spectral lint openapi.yaml` (Ensures descriptions, examples present).
*   **Security:** `check-auth` (Ensures every operation has `security` scheme defined).

## 4. Evidence for Compliance

For every release, the following evidence is archived:
*   [ ] OpenAPI Spec (Artifact)
*   [ ] Linting Report (Pass/Fail)
*   [ ] Security Scan Report (SAST)
*   [ ] Approval Log (Change Record)

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

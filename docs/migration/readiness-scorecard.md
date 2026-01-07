# Migration Readiness Scorecard

**Application:** [Name]
**Date:** [YYYY-MM-DD]

## 1. Complexity Assessment

| Factor | Score (1-5) | Notes |
| :--- | :--- | :--- |
| **Code Coupling** | 3 | Highly modular but shared DB. |
| **Statefulness** | 5 | Stores session in memory (High effort). |
| **Dependencies** | 2 | Standard Maven libs. |
| **Data Gravity** | 4 | 5TB Oracle DB. |

**Total Score:** [Sum] (Lower is easier)

## 2. Readiness Gates

*   [ ] **Code:** Source available and builds clean?
*   [ ] **Tests:** Unit test coverage > 80%?
*   [ ] **Config:** All env vars externalized?
*   [ ] **Compliance:** PII scanned and tagged?
*   [ ] **Security:** Secrets removed from code?

## 3. Migration Path Decision

*   **Selected Strategy:** [Refactor / Rehost / Replace]
*   **Rationale:** [Justification]

---

**Sign-off:** [Lead Architect]

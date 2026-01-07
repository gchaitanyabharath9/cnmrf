# Environment Parity & Drift Control

## 1. What Must Be Consistent (Parity)
To validate "Build Once, Deploy Many", these elements must remain identical across **all** environments (Dev through Prod):

*   **Artifacts:** The exact same Docker image (SHA digest). No rebuilding per env.
*   **Operating System:** Same base OS and Kernel version.
*   **API Contracts:** Same OpenAPI spec versions.
*   **Runtime Config:** Same JVM/CLR flags (e.g., G1GC / Server GC).

## 2. What May Differ
*   **Scale:** Replica counts (e.g., Dev: 1, Prod: 10) and CPU/RAM requests.
*   **Log Level:** DEBUG in Dev, INFO/WARN in Prod.
*   **Data Volume:** Size of databases.
*   **Endpoints:** URLs for downstream dependencies (e.g., `dev-db` vs `prod-db`).

## 3. Drift Detection (GitOps)

Infrastructure drift occurs when manual changes are made (Snowflakes). CNMRF mitigates this via GitOps:

*   **Source of Truth:** The Git Config Repo.
*   **Enforcement:** ArgoCD/Flux automatically reverts any manual `kubectl edit` changes in UAT/Prod.
*   **Auditing:** Daily drift reports sent to SRE.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

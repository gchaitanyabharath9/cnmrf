# Storage & Data Patterns

## 1. Storage Decision Matrix

| Workload Type | Recommended Store | Pattern Example |
| :--- | :--- | :--- |
| **Transactional (ACID)** | RDBMS (Postgres, SQL Server) | Orders, Payments, Inventory |
| **Document / Flexible** | NoSQL (MongoDB, CosmosDB) | User Profiles, Catalogs, CMS |
| **High-Speed Read** | Cache (Redis, Memcached) | Session State, Leaderboards |
| **Unstructured / Archival**| Object Store (S3, Blob) | Images, PDF Reports, Backups |
| **Time-Series** | TSDB (Prometheus, Influx) | Metrics, IoT Sensor Data |

## 2. Encryption Standards

**Data at Rest:**
*   **Database:** Use Transparent Data Encryption (TDE) or volume-level encryption (LUKS/dm-crypt).
*   **Object Store:** Server-Side Encryption (SSE-S3 / SSE-KMS).
*   **Keys:** Management keys (CMK) must be rotated annually.

**Data in Transit:**
*   **External:** TLS 1.2 or 1.3 (Strict).
*   **Internal:** mTLS via Service Mesh preferred.
*   **JDBC/ODBC:** Force SSL mode (`sslmode=verify-full`).

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

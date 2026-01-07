# Platform Switchability & Exit Strategy

## 1. Anti-Lock-In Design Principles

*   **Contract First:** Dependencies interact via API Interfaces (OpenAPI/gRPC), not vendor SDKs directly.
*   **Abstraction Layers:** Use a "Hexagonal Architecture" port/adapter for Storage and Messaging.
*   **Open Standards:** Prefer OIDC over IAM-proprietary, SQL over DynamoDB/Cosmos-proprietary APIs, Kafka Protocol over Kinesis/EventHubs SDKs.

## 2. Abstraction Components

| Capability | Abstraction | Implementation (Swapable) |
| :--- | :--- | :--- |
| **Object Storage**| S3-Compatible API | AWS S3 / MinIO / Azure Blob |
| **Messaging** | Kafka Protocol / AMQP | MSK / EventHubs / RabbitMQ |
| **Secrets** | K8s Secret / CSI Driver | Vault / Secrets Manager / KeyVault |
| **IaC** | Terraform / OpenTofu | Provider: AWS / Azure / GCP |

## 3. Exit Checklist

If we must leave Provider X for Provider Y:

*   [ ] **Data:** Can we export DB snapshots to standard formats (CSV/Parquet/SQL Dump)?
*   [ ] **Compute:** Are containers standard OCI images (Docker)?
*   [ ] **Config:** Is configuration externalized (Env Vars)?
*   [ ] **DNS:** Do we control the domain name (TTL lowered)?

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

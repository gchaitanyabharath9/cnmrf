# Legacy & File Integration

## 1. File-Based Integration (SFTP/Batch)

**Intent:** reliability ingest data from systems that only support file exports.
**Usage:**
1.  **Ingest:** Transfer file to Object Storage (S3/Blob).
2.  **Trigger:** Object create event triggers Kafka message.
3.  **Process:** Stream processor reads file line-by-line (don't load fully into RAM).
4.  **Audit:** Record checksum and row count in metadata.

## 2. Canonical Data Model

**Intent:** Avoid N*N translation complexity.
**Usage:** Define a standardized schema (JSON Schema / Avro) for core entities (Customer, Order). All Adapters translate *to* and *from* this central model.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# Platform Exit Checklist

In the event of a vendor dispute or strategy shift, use this checklist to execute an exit.

## 1. Data Extrication
*   [ ] **Database:** Export snapshots to open formats (Postgres Dump, Parquet, CSV).
*   [ ] **Object Storage:** Sync buckets to new provider or on-prem using Rclone.
*   [ ] **Queues:** Drain all active topics.

## 2. Workload Portability
*   [ ] **Containers:** Verify `docker run` works without vendor-specific IAM roles.
*   [ ] **Secrets:** Rotate all keys; do not migrate old secrets.
*   [ ] **DNS:** Lower TTL to 5 minutes before switch.

## 3. Contractual
*   [ ] **Notice:** Send termination notice per SLA.
*   [ ] **Data Destruction:** Request certificate of deletion after migration.

---

**Authorized By:** [CTO/CIO]

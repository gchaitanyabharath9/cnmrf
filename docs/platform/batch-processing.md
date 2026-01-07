# Batch Processing Patterns

## 1. Orchestration vs. Scheduling

*   **Scheduling:** "Run this at 5 PM." (Cron)
*   **Orchestration:** "Run Job B after Job A succeeds, but only if File X exists." (Autosys, Airflow)

## 2. Patterns

### A. Kubernetes CronJob (Simple)
Best for standalone maintenance tasks (DB cleanup, report generation).

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: daily-report
spec:
  schedule: "0 0 * * *" # Daily at midnight
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: report-gen
            image: cnmrf/report-gen:v1
          restartPolicy: OnFailure
```

### B. Enterprise Orchestration (Autosys)
Best for complex dependencies across mainframe/distributed systems.
*   **Agent Pattern:** Run a K8s Pod as a "ephemeral agent" or trigger a K8s Job via API.
*   **File watcher:** Use sidecars to detect file landing.

### C. Application-Embedded (Quartz)
Best for micro-batching within a service. Use clustering to prevent double-execution.

**Spring Boot (Quartz)**
Ensure `spring.quartz.job-store-type=jdbc` is set to share state across replicas.

**.NET (Quartz.NET)**
Configure AdoJobStore to persist triggers in SQL Server.

## 3. Batch Microservices

For heavy processing:
1.  **Checkpointing:** Commit offsets/progress regularly. Don't process 1M records in one transaction.
2.  **Idempotency:** Re-running a failed batch must not duplicate data.
3.  **Resource Isolation:** Use separate K8s Node Pools for batch to avoid starving online APIs.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

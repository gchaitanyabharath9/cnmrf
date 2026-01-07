# NFR Checklist & 12-Factor Mapping

## 1. Non-Functional Requirements (NFR) Checklist

Every microservice compliant with CNMRF must meet these measurable targets.

| Category | Requirement | Target Metric |
| :--- | :--- | :--- |
| **Availability** | Uptime SLA | 99.9% (Standard) / 99.99% (Critical) |
| **Scalability** | Horizontal Scaling | Scale from N to N+X within 60s |
| **Performance** | API Latency (p99) | < 200ms (Sync), < 500ms (Complex agg) |
| **Resiliency** | Circuit Breaker | Open after 50% failure / 10s |
| **Observability**| Log Aggregation | All logs JSON structured, centralized |
| **Security** | Transit Encryption | TLS 1.2+ / mTLS everywhere |
| **Compliance** | Audit Logging | 100% of mutating actions logged |

## 2. 12-Factor App Mapping

| Factor | Concept | Spring Boot (Java) | .NET (Core/6+) |
| :--- | :--- | :--- | :--- |
| **I. Codebase** | One codebase, many deploys | Git Repo | Git Repo |
| **II. Dependencies** | Explicitly declare/isolate | Maven / Gradle (`pom.xml`) | NuGet (`.csproj`) |
| **III. Config** | Config in the environment | `application.yml` + Spring Cloud Config / K8s ConfigMap | `appsettings.json` + `IConfiguration` / K8s ConfigMap |
| **IV. Backing Services** | Treat as attached resources | Spring Data / JMS / Kafka Binders | EF Core / MassTransit / Dapr |
| **V. Build, Release, Run**| Strictly separate stages | CI Pipeline (Jenkins/GitHub Actions) builds Docker image | CI Pipeline builds container image |
| **VI. Processes** | Execute app as stateless | Standard Spring MVC/WebFlux | Standard ASP.NET Core Controllers |
| **VII. Port Binding** | Export services via port | Embedded Tomcat/Netty (server.port) | Kestrel (ASPNETCORE_URLS) |
| **VIII. Concurrency** | Scale out via process model | K8s Replicas (HPA) | K8s Replicas (HPA) |
| **IX. Disposability** | Fast startup/shutdown | Spring Lifecycle / Graceful Shutdown | IHostApplicationLifetime / Graceful Shutdown |
| **X. Dev/Prod Parity** | Keep dev/staging/prod similar | Docker Containers everywhere | Docker Containers everywhere |
| **XI. Logs** | Treat logs as event streams | SLF4J / Logback (JSON encoder) | Serilog (Console sink / JSON) |
| **XII. Admin Processes** | Run admin/mgmt tasks as one-off | K8s Jobs / Spring Batch | K8s Jobs / Hosted Services (BackgroundService) |

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

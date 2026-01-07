# CNMRF Reference Architecture

## Overview

This document defines the reference architecture for cloud-native microservices built using CNMRF patterns.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Architecture Guidance - Reference architecture docs, Mermaid diagrams, NFR baselines"

## Architecture Principles

Based on Project Outline Section 7:

1. **Platform-Neutral First** - Kubernetes baseline, no vendor lock-in
2. **Security by Default** - Non-root containers, least-privilege RBAC
3. **Observability Built-In** - Structured logging, metrics, tracing
4. **Resiliency as Baseline** - Circuit breakers, retries, graceful shutdown
5. **GitOps-Ready** - Declarative manifests, config as code

## High-Level Architecture

```mermaid
graph TB
    subgraph "External"
        Client[Client Applications]
        Monitoring[Monitoring System<br/>Prometheus/Grafana]
    end
    
    subgraph "Kubernetes Cluster"
        subgraph "Ingress Layer"
            Ingress[Ingress Controller<br/>TLS Termination]
        end
        
        subgraph "Application Layer"
            ServiceA[Microservice A<br/>Spring Boot]
            ServiceB[Microservice B<br/>.NET]
            ServiceC[Microservice C<br/>Spring Boot]
        end
        
        subgraph "Platform Services"
            SecretMgr[Secret Manager<br/>External Secrets Operator]
            ServiceMesh[Service Mesh<br/>Optional: Istio/Linkerd]
        end
        
        subgraph "Data Layer"
            DB[(Database)]
            Cache[(Cache<br/>Redis)]
            Queue[Message Queue<br/>RabbitMQ/Kafka]
        end
        
        subgraph "Observability"
            Logs[Logging<br/>Fluent Bit → Loki]
            Metrics[Metrics<br/>Prometheus]
            Traces[Tracing<br/>Jaeger/Tempo]
        end
    end
    
    Client -->|HTTPS| Ingress
    Ingress --> ServiceA
    Ingress --> ServiceB
    ServiceA -->|Circuit Breaker| ServiceB
    ServiceB -->|Circuit Breaker| ServiceC
    ServiceA --> DB
    ServiceB --> Cache
    ServiceC --> Queue
    
    ServiceA -.->|Metrics| Metrics
    ServiceB -.->|Metrics| Metrics
    ServiceC -.->|Metrics| Metrics
    
    ServiceA -.->|Logs| Logs
    ServiceB -.->|Logs| Logs
    ServiceC -.->|Logs| Logs
    
    ServiceA -.->|Traces| Traces
    ServiceB -.->|Traces| Traces
    ServiceC -.->|Traces| Traces
    
    Monitoring -->|Query| Metrics
    Monitoring -->|Query| Logs
    
    SecretMgr -.->|Inject Secrets| ServiceA
    SecretMgr -.->|Inject Secrets| ServiceB
    SecretMgr -.->|Inject Secrets| ServiceC
```

## Component Architecture

### Microservice Internal Architecture

```mermaid
graph LR
    subgraph "Microservice Pod"
        subgraph "Application Container"
            API[REST API Layer]
            Business[Business Logic]
            Data[Data Access Layer]
        end
        
        subgraph "Cross-Cutting Concerns"
            Health[Health Checks]
            Metrics[Metrics Endpoint]
            Logging[Structured Logging]
            CircuitBreaker[Circuit Breaker]
            Retry[Retry Logic]
        end
        
        API --> Business
        Business --> Data
        Business --> CircuitBreaker
        CircuitBreaker --> Retry
    end
    
    subgraph "Kubernetes Resources"
        Service[Service]
        ConfigMap[ConfigMap]
        Secret[Secret]
    end
    
    Health -.->|Probes| K8s[Kubernetes]
    Metrics -.->|Scrape| Prometheus[Prometheus]
    Logging -.->|Ship| LogAggregator[Log Aggregator]
    
    ConfigMap -.->|Mount| API
    Secret -.->|Mount| Data
```

## Deployment Architecture

### GitOps Flow

```mermaid
graph LR
    Developer[Developer] -->|1. Push Code| GitRepo[Git Repository]
    GitRepo -->|2. Trigger| CI[CI Pipeline]
    CI -->|3. Build & Test| Container[Container Image]
    Container -->|4. Push| Registry[Container Registry]
    CI -->|5. Update Manifest| GitOpsRepo[GitOps Repository]
    GitOpsRepo -->|6. Sync| ArgoCD[ArgoCD]
    ArgoCD -->|7. Deploy| K8s[Kubernetes Cluster]
    K8s -.->|8. Pull Image| Registry
```

## Security Architecture

### Defense in Depth

```mermaid
graph TB
    subgraph "Network Security"
        NetworkPolicy[Network Policies<br/>Pod-to-Pod Restrictions]
        TLS[TLS Everywhere<br/>mTLS Optional]
    end
    
    subgraph "Identity & Access"
        RBAC[RBAC<br/>Least Privilege]
        ServiceAccount[Service Accounts<br/>Per Service]
        PodSecurity[Pod Security Standards<br/>Restricted Profile]
    end
    
    subgraph "Secret Management"
        ExternalSecrets[External Secrets Operator]
        Vault[HashiCorp Vault /<br/>Cloud Secret Manager]
    end
    
    subgraph "Container Security"
        NonRoot[Non-Root User<br/>UID > 1000]
        ReadOnlyFS[Read-Only Root FS]
        NoPrivileged[No Privileged Containers]
    end
    
    subgraph "Runtime Security"
        ImageScanning[Image Scanning<br/>Trivy/Snyk]
        RuntimeProtection[Runtime Protection<br/>Falco Optional]
    end
```

## Observability Architecture

### Three Pillars

```mermaid
graph TB
    subgraph "Application"
        App[Microservice]
    end
    
    subgraph "Logs"
        App -->|JSON Logs| FluentBit[Fluent Bit]
        FluentBit --> Loki[Loki]
        Loki --> Grafana1[Grafana]
    end
    
    subgraph "Metrics"
        App -->|/metrics| Prometheus[Prometheus]
        Prometheus --> Grafana2[Grafana]
        Prometheus --> AlertManager[Alert Manager]
    end
    
    subgraph "Traces"
        App -->|OTLP| OtelCollector[OpenTelemetry Collector]
        OtelCollector --> Jaeger[Jaeger/Tempo]
        Jaeger --> Grafana3[Grafana]
    end
    
    subgraph "Unified View"
        Grafana1 -.-> Dashboard[Unified Dashboard]
        Grafana2 -.-> Dashboard
        Grafana3 -.-> Dashboard
    end
```

## Resiliency Patterns

### Circuit Breaker Pattern

```mermaid
stateDiagram-v2
    [*] --> Closed
    Closed --> Open: Failure Threshold Exceeded
    Open --> HalfOpen: Timeout Elapsed
    HalfOpen --> Closed: Success
    HalfOpen --> Open: Failure
    
    note right of Closed
        Normal operation
        Requests pass through
    end note
    
    note right of Open
        Fast fail
        No requests sent
    end note
    
    note right of HalfOpen
        Test recovery
        Limited requests
    end note
```

## Technology Stack

### Core Technologies

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Container Runtime** | Docker / containerd | Industry standard, OCI-compliant |
| **Orchestration** | Kubernetes 1.28+ | Platform-neutral baseline |
| **Service Framework (Java)** | Spring Boot 3.2+ | Production-ready, comprehensive ecosystem |
| **Service Framework (.NET)** | .NET 8+ | Modern, high-performance, cross-platform |
| **API Documentation** | OpenAPI 3.0 | Standard API specification |
| **Metrics** | Prometheus | CNCF standard, Kubernetes-native |
| **Logging** | JSON structured logs | Machine-readable, queryable |
| **Tracing** | OpenTelemetry | Vendor-neutral, future-proof |
| **Circuit Breaker (Java)** | Resilience4j | Lightweight, functional |
| **Circuit Breaker (.NET)** | Polly | Industry standard for .NET |
| **GitOps** | ArgoCD | Declarative, Kubernetes-native |
| **Helm** | Helm 3+ | Package management for Kubernetes |

### Optional/Cloud-Specific

| Component | Options | Notes |
|-----------|---------|-------|
| **Ingress** | NGINX, Traefik, AWS ALB, Azure App Gateway | Choose based on platform |
| **Service Mesh** | Istio, Linkerd, AWS App Mesh | Optional, adds complexity |
| **Secret Management** | Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager | Choose based on platform |
| **Container Registry** | Docker Hub, ECR, ACR, GCR, Harbor | Choose based on platform |

## Multi-Cloud Compatibility

### Kubernetes Distribution Support

CNMRF templates work on:

- **AWS EKS** - Elastic Kubernetes Service
- **Azure AKS** - Azure Kubernetes Service  
- **Google GKE** - Google Kubernetes Engine
- **Red Hat OpenShift** - Enterprise Kubernetes platform
- **On-Premises** - Vanilla Kubernetes, Rancher, etc.

### Platform-Specific Extensions

Cloud-specific features (e.g., AWS ALB Ingress, Azure Application Gateway) are **optional extensions**, not core requirements.

Core templates use:
- Standard Kubernetes Ingress
- Generic PersistentVolumeClaims
- Standard LoadBalancer services

## Non-Functional Requirements

See [NFR Baseline](nfr-baseline.md) for detailed requirements.

### Summary

| Category | Baseline Requirement |
|----------|---------------------|
| **Availability** | 99.9% uptime (3 nines) |
| **Performance** | P95 latency < 200ms for API calls |
| **Scalability** | Horizontal scaling via HPA |
| **Security** | Non-root, RBAC, secret management |
| **Observability** | Logs, metrics, traces for all services |
| **Resiliency** | Circuit breakers, retries, graceful shutdown |

## Design Decisions

Key architectural decisions are documented in ADRs:

- [ADR-0001: Authentication Approach](../adr/0001-authentication-approach.md)
- [ADR-0002: Observability Stack](../adr/0002-observability-stack.md)
- [ADR-0003: Resiliency Patterns](../adr/0003-resiliency-patterns.md)

## Implementation Guidance

### For New Services

1. Choose service template (`microservice-springboot` or `microservice-dotnet`)
2. Review this reference architecture
3. Implement business logic following the component architecture
4. Deploy using Helm chart from `infra-helm` template
5. Set up GitOps using `gitops-argocd` template

### For Existing Services

1. Review NFR baseline and identify gaps
2. Implement missing observability (health checks, metrics, logging)
3. Add resiliency patterns (circuit breakers, retries)
4. Containerize with non-root user
5. Create Helm chart following `infra-helm` template
6. Migrate to GitOps deployment

## Validation

Services should validate against:

- ✅ All health check endpoints respond correctly
- ✅ Metrics endpoint exposes Prometheus-compatible metrics
- ✅ Logs are structured JSON
- ✅ Container runs as non-root user
- ✅ Resource limits are defined
- ✅ Circuit breakers are configured
- ✅ Graceful shutdown is implemented

## References

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [12-Factor App](https://12factor.net/)
- [CNCF Cloud Native Definition](https://github.com/cncf/toc/blob/main/DEFINITION.md)
- [OpenTelemetry](https://opentelemetry.io/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)

---

**Next Steps:**
1. Review [NFR Baseline](nfr-baseline.md)
2. Study [ADRs](../adr/README.md) for decision rationale
3. Explore [Service Templates](../../templates/README.md)

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

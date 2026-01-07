# ADR-0002: Observability Stack Selection

**Status:** Accepted  
**Date:** 2026-01-06  
**Decision Makers:** CNMRF Architecture Team  

## Context

Cloud-native microservices require comprehensive observability to:

- Debug issues in distributed systems
- Monitor performance and availability
- Detect anomalies and security incidents
- Support SLO/SLA compliance
- Enable data-driven optimization

Observability encompasses three pillars:
1. **Logs:** What happened?
2. **Metrics:** How much/how many?
3. **Traces:** Where did time go?

Requirements:
- Platform-neutral (works on EKS, AKS, GKE, OpenShift)
- Open standards (no vendor lock-in)
- Kubernetes-native integration
- Cost-effective for self-hosted deployment
- Supports correlation between logs, metrics, and traces

## Decision

We will adopt the following observability stack:

### 1. Metrics: Prometheus

- **Prometheus** for metrics collection and storage
- **Grafana** for visualization and dashboards
- **AlertManager** for alerting

**Rationale:**
- CNCF graduated project, industry standard
- Native Kubernetes integration (service discovery)
- Pull-based model (services expose `/metrics` endpoint)
- PromQL for powerful querying
- Extensive ecosystem and integrations

### 2. Logging: Structured JSON + Fluent Bit + Loki

- **Structured JSON logs** from all services
- **Fluent Bit** for log collection and forwarding
- **Loki** for log aggregation and storage
- **Grafana** for log visualization

**Rationale:**
- Loki is Prometheus-like for logs (labels, not full-text indexing)
- Cost-effective storage (indexes labels, not content)
- Native Grafana integration
- Fluent Bit is lightweight and Kubernetes-native

### 3. Tracing: OpenTelemetry + Jaeger/Tempo

- **OpenTelemetry** for instrumentation (vendor-neutral)
- **Jaeger** or **Tempo** for trace storage and visualization
- **Grafana** for unified trace viewing

**Rationale:**
- OpenTelemetry is CNCF standard, future-proof
- Vendor-neutral (can switch backends without code changes)
- Automatic instrumentation for Spring Boot and .NET
- Jaeger is mature; Tempo integrates with Grafana/Loki

### Unified Dashboard: Grafana

- Single pane of glass for logs, metrics, and traces
- Correlation between observability signals
- Pre-built dashboards for common patterns

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Grafana (Unified UI)                   │
├─────────────────────────────────────────────────────────────┤
│  Metrics (Prometheus) │ Logs (Loki) │ Traces (Jaeger/Tempo) │
└─────────────────────────────────────────────────────────────┘
           ▲                    ▲                    ▲
           │                    │                    │
    ┌──────┴──────┐      ┌──────┴──────┐     ┌──────┴──────┐
    │ Prometheus  │      │  Fluent Bit │     │ OTel        │
    │ (scrape)    │      │  (collect)  │     │ Collector   │
    └──────┬──────┘      └──────┬──────┘     └──────┬──────┘
           │                    │                    │
    ┌──────▼──────────────────────▼────────────────────▼──────┐
    │              Microservices (Pods)                        │
    │  - /metrics endpoint (Prometheus format)                 │
    │  - JSON logs to stdout                                   │
    │  - OpenTelemetry instrumentation                         │
    └──────────────────────────────────────────────────────────┘
```

## Consequences

### Positive Consequences

- **Vendor-Neutral:** All components are open-source and platform-agnostic
- **Unified View:** Grafana provides single interface for all observability data
- **Cost-Effective:** Loki's label-based indexing reduces storage costs vs. Elasticsearch
- **Kubernetes-Native:** All tools integrate seamlessly with Kubernetes
- **Correlation:** Can correlate logs, metrics, and traces via trace IDs
- **Standard:** OpenTelemetry ensures future compatibility

### Negative Consequences

- **Operational Overhead:** Self-hosting requires managing Prometheus, Loki, Jaeger/Tempo
  - **Mitigation:** Use Helm charts for deployment; consider managed options for production
- **Learning Curve:** Teams must learn PromQL, LogQL, and Grafana
  - **Mitigation:** Provide training and pre-built dashboards
- **Storage:** Prometheus and Loki require persistent storage
  - **Mitigation:** Configure retention policies; use object storage for Loki

### Neutral Consequences

- Services must expose Prometheus metrics endpoint
- Services must log structured JSON
- Services must include OpenTelemetry instrumentation

## Alternatives Considered

### Alternative 1: ELK Stack (Elasticsearch, Logstash, Kibana)

**Description:**  
Traditional logging stack with full-text search

**Pros:**
- Powerful full-text search
- Mature ecosystem
- Rich visualization in Kibana

**Cons:**
- High resource consumption (Elasticsearch is heavy)
- Expensive at scale (storage and compute)
- Not metrics or tracing native (requires separate tools)
- Complex to operate

**Reason for Rejection:**  
ELK is overkill for most use cases and expensive to run. Loki provides sufficient log querying with lower cost.

### Alternative 2: Cloud-Native Solutions (CloudWatch, Azure Monitor, Stackdriver)

**Description:**  
Use cloud provider's native observability tools

**Pros:**
- Fully managed (no operational overhead)
- Deep integration with cloud services
- Auto-scaling and high availability

**Cons:**
- **Vendor lock-in** (violates platform-neutral principle)
- Higher cost at scale
- Different tools per cloud (no portability)
- Limited customization

**Reason for Rejection:**  
Cloud-native solutions violate CNMRF's platform-neutral principle. They are acceptable as **optional extensions** but not baseline.

### Alternative 3: Datadog / New Relic (Commercial SaaS)

**Description:**  
Commercial observability platforms

**Pros:**
- Fully managed
- Excellent UX
- Advanced features (APM, RUM, etc.)

**Cons:**
- **Expensive** at scale (per-host or per-GB pricing)
- Vendor lock-in
- Data leaves your infrastructure
- Not aligned with open-source framework principles

**Reason for Rejection:**  
Commercial SaaS violates CNMRF's open-source and cost-effective principles.

## Implementation Notes

### Service Requirements

All services must implement:

1. **Metrics Endpoint**
   - Expose `/metrics` in Prometheus format
   - Include RED metrics (Rate, Errors, Duration)
   - Include resource metrics (CPU, memory, GC)

2. **Structured Logging**
   - Log in JSON format to stdout
   - Include correlation ID (trace ID)
   - Include standard fields: timestamp, level, message, service, version

3. **Tracing Instrumentation**
   - Use OpenTelemetry SDK
   - Auto-instrument HTTP clients and servers
   - Propagate trace context across service boundaries

### Spring Boot Implementation

```xml
<!-- pom.xml -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
<dependency>
    <groupId>io.opentelemetry.instrumentation</groupId>
    <artifactId>opentelemetry-spring-boot-starter</artifactId>
</dependency>
```

```yaml
# application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,metrics,prometheus
  metrics:
    export:
      prometheus:
        enabled: true

logging:
  pattern:
    console: '{"timestamp":"%d{ISO8601}","level":"%level","service":"${spring.application.name}","trace":"%X{traceId}","span":"%X{spanId}","message":"%message"}%n'
```

### .NET Implementation

```csharp
// Program.cs
builder.Services.AddOpenTelemetry()
    .WithMetrics(metrics => metrics
        .AddPrometheusExporter()
        .AddMeter("Microsoft.AspNetCore.Hosting")
        .AddMeter("Microsoft.AspNetCore.Server.Kestrel"))
    .WithTracing(tracing => tracing
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddJaegerExporter());

// Structured logging
builder.Logging.AddJsonConsole();

app.MapPrometheusScrapingEndpoint();
```

### Kubernetes Deployment

```yaml
# Prometheus scrape annotation
apiVersion: v1
kind: Pod
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/metrics"
spec:
  containers:
  - name: app
    image: my-service:latest
```

**Timeline:**  
- Implement in all service templates immediately
- Deploy Prometheus, Loki, Jaeger/Tempo to reference cluster

**Dependencies:**
- Prometheus Operator (for Kubernetes deployment)
- Loki Helm chart
- Jaeger or Tempo Helm chart
- Grafana Helm chart

## Validation

Success metrics:

- ✅ All services expose `/metrics` endpoint
- ✅ Metrics appear in Prometheus
- ✅ Logs are structured JSON and queryable in Loki
- ✅ Traces appear in Jaeger/Tempo
- ✅ Grafana dashboards show correlated data
- ✅ Alerts fire correctly for SLO violations

**Review Date:** 2026-07-06 (6 months)

## References

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Loki](https://grafana.com/oss/loki/)
- [OpenTelemetry](https://opentelemetry.io/)
- [Jaeger Tracing](https://www.jaegertracing.io/)
- [Grafana Tempo](https://grafana.com/oss/tempo/)
- [CNMRF Reference Architecture - Observability](../architecture/reference-architecture.md#observability-architecture)

## Notes

- For production, consider managed Prometheus (e.g., Grafana Cloud, AWS Managed Prometheus) to reduce operational overhead
- Loki can use object storage (S3, GCS, Azure Blob) for cost-effective long-term retention
- OpenTelemetry Collector can be used for advanced trace processing and routing
- Pre-built Grafana dashboards will be provided in `/examples`

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

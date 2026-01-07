# Non-Functional Requirements (NFR) Baseline

## Overview

This document defines the baseline non-functional requirements for all microservices built using CNMRF patterns.

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "NFR baselines" within Architecture Guidance

## Purpose

NFRs ensure that services meet operational, security, and quality standards beyond functional requirements.

## NFR Categories

### 1. Availability

**Requirement:** Services must achieve **99.9% availability** (3 nines)

**Acceptable Downtime:**
- **Monthly:** 43.8 minutes
- **Weekly:** 10.1 minutes
- **Daily:** 1.4 minutes

**Implementation:**
- Multiple pod replicas (minimum 2 for production)
- Pod Disruption Budgets (PDB)
- Health checks (liveness, readiness)
- Graceful shutdown handling
- Rolling updates with zero downtime

**Validation:**
```yaml
# Minimum replica count
replicas: 2

# Pod Disruption Budget
minAvailable: 1
```

---

### 2. Performance

**Requirement:** API calls must meet the following latency targets:

| Metric | Target |
|--------|--------|
| **P50 (Median)** | < 50ms |
| **P95** | < 200ms |
| **P99** | < 500ms |

**Throughput:**
- Minimum 100 requests/second per pod
- Scale horizontally for higher throughput

**Implementation:**
- Efficient database queries (indexed, optimized)
- Connection pooling
- Caching for frequently accessed data
- Asynchronous processing for long-running tasks

**Validation:**
- Load testing with realistic traffic patterns
- Prometheus metrics monitoring
- Alerting on SLO violations

---

### 3. Scalability

**Requirement:** Services must scale horizontally based on load

**Horizontal Pod Autoscaling (HPA):**
- Scale based on CPU utilization (target: 70%)
- Scale based on memory utilization (target: 80%)
- Scale based on custom metrics (e.g., request rate)

**Limits:**
- Minimum replicas: 2 (production)
- Maximum replicas: 10 (configurable per service)

**Implementation:**
```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80
```

**Validation:**
- Load testing to verify autoscaling triggers
- Monitor scaling events in Kubernetes

---

### 4. Security

**Requirement:** All services must implement security by default

**Container Security:**
- ✅ Non-root user (UID > 1000)
- ✅ Read-only root filesystem (where possible)
- ✅ No privileged containers
- ✅ Security context constraints
- ✅ Minimal base images (distroless/alpine)

**Access Control:**
- ✅ Least-privilege RBAC
- ✅ Service accounts per service
- ✅ Network policies restricting pod-to-pod traffic
- ✅ Pod Security Standards (restricted profile)

**Secret Management:**
- ✅ No hardcoded secrets
- ✅ External secret providers (Vault, cloud secret managers)
- ✅ Secrets mounted as volumes, not environment variables
- ✅ Secret rotation support

**Network Security:**
- ✅ TLS for all external communication
- ✅ mTLS for service-to-service (optional)
- ✅ Ingress with TLS termination

**Implementation:**
See [Security Baseline](../security/security-baseline.md)

**Validation:**
- Container image scanning (Trivy, Snyk)
- RBAC policy review
- Secret management audit
- Network policy testing

---

### 5. Observability

**Requirement:** All services must be fully observable

**Logging:**
- ✅ Structured JSON logs
- ✅ Correlation IDs for request tracing
- ✅ Log levels: DEBUG, INFO, WARN, ERROR
- ✅ No sensitive data in logs

**Metrics:**
- ✅ Prometheus `/metrics` endpoint
- ✅ RED metrics (Rate, Errors, Duration)
- ✅ Resource metrics (CPU, memory)
- ✅ Business metrics (custom)

**Tracing:**
- ✅ OpenTelemetry instrumentation
- ✅ Distributed tracing for service-to-service calls
- ✅ Trace sampling (configurable)

**Health Checks:**
- ✅ Liveness probe: `/health/live`
- ✅ Readiness probe: `/health/ready`
- ✅ Startup probe (for slow-starting services)

**Implementation:**
See [Reference Architecture - Observability](reference-architecture.md#observability-architecture)

**Validation:**
- Verify metrics endpoint returns Prometheus-compatible data
- Verify logs are structured JSON
- Verify traces appear in tracing backend
- Verify health checks respond correctly

---

### 6. Resiliency

**Requirement:** Services must handle failures gracefully

**Circuit Breakers:**
- ✅ Configured for all external dependencies
- ✅ Failure threshold: 50% over 10 requests
- ✅ Open state duration: 60 seconds
- ✅ Half-open state: 3 test requests

**Retries:**
- ✅ Exponential backoff
- ✅ Maximum retry attempts: 3
- ✅ Jitter to prevent thundering herd
- ✅ Idempotent operations only

**Timeouts:**
- ✅ Request timeout: 30 seconds (default)
- ✅ Connection timeout: 5 seconds
- ✅ Idle timeout: 60 seconds

**Graceful Shutdown:**
- ✅ SIGTERM signal handling
- ✅ Connection draining (30 seconds)
- ✅ In-flight request completion
- ✅ Kubernetes preStop hook

**Resource Limits:**
- ✅ CPU requests and limits defined
- ✅ Memory requests and limits defined
- ✅ QoS class: Burstable or Guaranteed

**Implementation:**
See [Resiliency Patterns](../resiliency/resiliency-patterns.md)

**Validation:**
- Chaos engineering tests (pod kills, network latency)
- Circuit breaker state transitions
- Graceful shutdown testing
- Resource limit enforcement

---

### 7. Maintainability

**Requirement:** Services must be easy to understand, modify, and operate

**Code Quality:**
- ✅ Automated tests (unit, integration)
- ✅ Code coverage > 80%
- ✅ Linting and formatting enforced
- ✅ Dependency vulnerability scanning

**Documentation:**
- ✅ README with setup instructions
- ✅ OpenAPI specification for APIs
- ✅ Inline code comments
- ✅ ADRs for significant decisions

**Configuration:**
- ✅ Externalized configuration (ConfigMaps, Secrets)
- ✅ Environment-specific overrides
- ✅ No hardcoded values

**Deployment:**
- ✅ Helm chart for packaging
- ✅ GitOps for deployment
- ✅ Rollback capability
- ✅ Blue-green or canary deployment support

**Implementation:**
- Use service templates from `/templates`
- Follow documentation standards
- Use quality gates from `/tools/scripts`

**Validation:**
- Code review
- Automated testing in CI/CD
- Documentation review

---

### 8. Compliance

**Requirement:** Services should support common compliance frameworks

**Supported Frameworks:**
- CIS Kubernetes Benchmark
- NIST Cybersecurity Framework
- SOC 2 (Security and Availability)
- ISO 27001

**Implementation:**
- Security baseline alignment (see `/docs/security`)
- Audit logging
- Access control (RBAC)
- Data encryption (at rest and in transit)

**Note:** CNMRF provides technical patterns. Organizations must perform their own compliance assessments and certifications.

**Validation:**
- Security scanning
- Compliance checklist review
- Third-party audit (if required)

---

## NFR Validation Checklist

Use this checklist to validate services against NFR baseline:

### Availability
- [ ] Minimum 2 replicas in production
- [ ] Pod Disruption Budget configured
- [ ] Health checks implemented
- [ ] Graceful shutdown handling

### Performance
- [ ] Load testing completed
- [ ] P95 latency < 200ms
- [ ] Connection pooling configured
- [ ] Caching implemented (if applicable)

### Scalability
- [ ] HPA configured
- [ ] Autoscaling tested
- [ ] Resource requests/limits defined

### Security
- [ ] Non-root container
- [ ] No hardcoded secrets
- [ ] RBAC configured
- [ ] Network policies defined
- [ ] Image scanning passed

### Observability
- [ ] Structured JSON logging
- [ ] Prometheus metrics endpoint
- [ ] OpenTelemetry tracing
- [ ] Health check endpoints

### Resiliency
- [ ] Circuit breakers configured
- [ ] Retry logic with backoff
- [ ] Timeouts defined
- [ ] Graceful shutdown tested
- [ ] Chaos testing completed

### Maintainability
- [ ] Code coverage > 80%
- [ ] OpenAPI documentation
- [ ] README complete
- [ ] Helm chart created

### Compliance
- [ ] Security baseline met
- [ ] Audit logging enabled
- [ ] Compliance checklist reviewed

---

## Monitoring and Alerting

### Key Metrics to Monitor

| Metric | Threshold | Action |
|--------|-----------|--------|
| **Availability** | < 99.9% | Page on-call |
| **P95 Latency** | > 200ms | Investigate |
| **Error Rate** | > 1% | Investigate |
| **CPU Utilization** | > 80% | Scale up |
| **Memory Utilization** | > 90% | Scale up |
| **Pod Restarts** | > 3 in 10 min | Investigate |

### Alerting Rules

Implement alerts for:
- Service unavailability
- High error rates
- Latency SLO violations
- Resource exhaustion
- Security events

---

## Exceptions and Waivers

Services that cannot meet baseline NFRs must:

1. Document the exception in an ADR
2. Provide justification
3. Define compensating controls
4. Obtain approval from architecture review board

---

## References

- [Reference Architecture](reference-architecture.md)
- [Security Baseline](../security/security-baseline.md)
- [Resiliency Patterns](../resiliency/resiliency-patterns.md)
- [ADR Index](../adr/README.md)

---

**Next Steps:**
1. Review service against this baseline
2. Implement missing NFRs
3. Validate using checklist
4. Document exceptions in ADRs

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

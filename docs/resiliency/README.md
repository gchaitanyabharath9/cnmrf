# Resiliency Documentation

This directory contains resiliency patterns and implementation guidance for cloud-native services.

## Purpose

**Alignment to Project Outline (Section 5):**  
Implements "Resiliency Patterns - Circuit breakers, retries, timeouts, health checks, graceful shutdown"

**Design Principle (Section 7):**  
Implements "Resiliency as a Baseline" principle

## Resiliency Baseline

All CNMRF templates and patterns implement these resiliency patterns:

### Circuit Breakers
- Prevent cascading failures
- Fast-fail when downstream services are unhealthy
- Automatic recovery detection

### Retries with Backoff
- Exponential backoff for transient failures
- Maximum retry limits
- Jitter to prevent thundering herd

### Timeouts
- Request-level timeouts
- Connection timeouts
- Idle timeouts

### Health Checks
- Liveness probes (is the service running?)
- Readiness probes (is the service ready to accept traffic?)
- Startup probes (for slow-starting services)

### Graceful Shutdown
- SIGTERM signal handling
- Connection draining
- In-flight request completion
- Kubernetes preStop hooks

### Resource Limits
- CPU and memory limits
- Request/limit ratios for QoS
- Horizontal Pod Autoscaling (HPA)

## Contents

- **[Resiliency Patterns](resiliency-patterns.md)** - Comprehensive pattern catalog
- **[Health Check Guide](health-checks.md)** - Health check implementation
- **[Graceful Shutdown](graceful-shutdown.md)** - Shutdown handling patterns
- **[Resource Management](resource-management.md)** - Resource limits and autoscaling

## Resiliency as Baseline Principle

From Project Outline Section 7:

> **Resiliency as a Baseline**
> - Circuit breakers, retries, timeouts in service templates
> - Graceful shutdown and signal handling
> - Resource limits and autoscaling guidance

All templates in `/templates` implement these patterns out of the box.

## Target Audience

- Site Reliability Engineers (SREs) establishing reliability standards
- Platform teams building resilient infrastructure
- Software engineers implementing microservices
- Architects designing fault-tolerant systems

## How to Use

1. Review [Resiliency Patterns](resiliency-patterns.md) for pattern catalog
2. Implement health checks per [Health Check Guide](health-checks.md)
3. Configure graceful shutdown using [Graceful Shutdown](graceful-shutdown.md)
4. Set resource limits per [Resource Management](resource-management.md)
5. Test failure scenarios (chaos engineering)

## Testing Resiliency

Resiliency patterns must be tested:

- **Unit Tests:** Test circuit breaker logic, retry behavior
- **Integration Tests:** Test health check endpoints
- **Chaos Engineering:** Inject failures (pod kills, network latency)
- **Load Testing:** Verify autoscaling and resource limits

## Relationship to Templates

Resiliency documentation defines **patterns**.  
Service templates in `/templates` **implement** these patterns.

All templates include:
- Circuit breaker configuration (Resilience4j for Spring Boot, Polly for .NET)
- Health check endpoints
- Graceful shutdown handling
- Resource limits in Helm charts

## Observability Integration

Resiliency patterns generate observability data:

- **Metrics:** Circuit breaker state, retry counts, timeout rates
- **Logs:** Failure events, recovery events
- **Traces:** Request retries, timeout spans

See `/docs/architecture` for observability integration.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

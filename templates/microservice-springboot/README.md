# Spring Boot Microservice Template

Production-ready Spring Boot microservice template following CNMRF patterns.

## Overview

This template provides a minimal, production-ready Spring Boot microservice with:

- ✅ Health checks (liveness, readiness)
- ✅ Prometheus metrics
- ✅ Structured JSON logging
- ✅ OpenAPI documentation
- ✅ Circuit breakers (Resilience4j)
- ✅ Graceful shutdown
- ✅ Non-root container
- ✅ Helm chart for deployment

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Service Templates - Spring Boot microservice (health, metrics, logging, OpenAPI)"

## Technology Stack

- **Java:** 21 (LTS)
- **Spring Boot:** 3.2+
- **Build Tool:** Maven
- **Resiliency:** Resilience4j
- **Metrics:** Micrometer + Prometheus
- **API Docs:** SpringDoc OpenAPI
- **Logging:** Logback with JSON encoder

## Project Structure

```
microservice-springboot/
├── src/
│   ├── main/
│   │   ├── java/com/cnmrf/template/
│   │   │   ├── Application.java
│   │   │   ├── controller/
│   │   │   │   └── HealthController.java
│   │   │   ├── service/
│   │   │   │   └── ExampleService.java
│   │   │   └── config/
│   │   │       ├── SecurityConfig.java
│   │   │       └── ResiliencyConfig.java
│   │   └── resources/
│   │       ├── application.yml
│   │       └── logback-spring.xml
│   └── test/
│       └── java/com/cnmrf/template/
│           └── ApplicationTests.java
├── Dockerfile
├── pom.xml
└── README.md
```

## Quick Start

### Prerequisites

- Java 21+
- Maven 3.9+
- Docker (for containerization)

### Build and Run Locally

```bash
# Build
mvn clean package

# Run
java -jar target/cnmrf-template-1.0.0.jar

# Or use Maven
mvn spring-boot:run
```

### Access Endpoints

- **API:** http://localhost:8080/api/v1/example
- **Health (Live):** http://localhost:8080/health/live
- **Health (Ready):** http://localhost:8080/health/ready
- **Metrics:** http://localhost:8080/metrics
- **OpenAPI:** http://localhost:8080/swagger-ui.html

### Build Container Image

```bash
docker build -t cnmrf-template:latest .
docker run -p 8080:8080 cnmrf-template:latest
```

## Configuration

### Application Configuration (`application.yml`)

```yaml
server:
  port: 8080
  shutdown: graceful  # Enable graceful shutdown

spring:
  application:
    name: cnmrf-template
  lifecycle:
    timeout-per-shutdown-phase: 30s  # Wait 30s for graceful shutdown

management:
  endpoints:
    web:
      exposure:
        include: health,metrics,prometheus
      base-path: /
  endpoint:
    health:
      probes:
        enabled: true
  metrics:
    export:
      prometheus:
        enabled: true

# Resilience4j Configuration
resilience4j:
  circuitbreaker:
    instances:
      externalService:
        failure-rate-threshold: 50
        minimum-number-of-calls: 10
        wait-duration-in-open-state: 60s
  retry:
    instances:
      externalService:
        max-attempts: 3
        wait-duration: 1s
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SERVER_PORT` | HTTP port | 8080 |
| `LOG_LEVEL` | Logging level | INFO |
| `SPRING_PROFILES_ACTIVE` | Active profile | default |

## Features

### 1. Health Checks

**Liveness Probe:** `/health/live`
- Returns 200 if application is running
- Used by Kubernetes to restart unhealthy pods

**Readiness Probe:** `/health/ready`
- Returns 200 if application is ready to accept traffic
- Checks database connectivity, external dependencies

### 2. Metrics

Prometheus metrics exposed at `/metrics`:

- **HTTP metrics:** Request count, duration, errors
- **JVM metrics:** Memory, GC, threads
- **Custom metrics:** Business-specific metrics

### 3. Structured Logging

All logs output as JSON:

```json
{
  "timestamp": "2026-01-06T17:30:00.123Z",
  "level": "INFO",
  "service": "cnmrf-template",
  "trace": "abc123",
  "span": "def456",
  "message": "Request processed successfully"
}
```

### 4. Circuit Breaker

Resilience4j circuit breaker for external service calls:

```java
@CircuitBreaker(name = "externalService", fallbackMethod = "fallback")
public String callExternalService() {
    return restTemplate.getForObject("http://external/api", String.class);
}
```

### 5. OpenAPI Documentation

Interactive API documentation at `/swagger-ui.html`

### 6. Security

- Non-root user (UID 1001)
- Read-only root filesystem
- No hardcoded secrets
- JWT authentication ready (see ADR-0001)

## Deployment

### Kubernetes with Helm

```bash
# Install
helm install cnmrf-template ./helm \
  --namespace my-namespace \
  --set image.tag=1.0.0

# Upgrade
helm upgrade cnmrf-template ./helm \
  --namespace my-namespace \
  --set image.tag=1.1.0
```

See `../infra-helm` for Helm chart details.

### GitOps with ArgoCD

```bash
# Copy GitOps structure
cp -r ../gitops-argocd ./my-gitops-repo/apps/cnmrf-template
```

## Customization

### 1. Rename Package

Replace `com.cnmrf.template` with your package name:

```bash
# Linux/Mac
find src -type f -name "*.java" -exec sed -i 's/com\.cnmrf\.template/com.mycompany.myservice/g' {} +

# Windows PowerShell
Get-ChildItem -Path src -Filter *.java -Recurse | ForEach-Object {
    (Get-Content $_.FullName) -replace 'com\.cnmrf\.template', 'com.mycompany.myservice' | Set-Content $_.FullName
}
```

### 2. Add Business Logic

- Add controllers in `controller/` package
- Add services in `service/` package
- Add repositories in `repository/` package (if using database)

### 3. Add Dependencies

Edit `pom.xml` to add dependencies (e.g., database drivers, messaging clients)

### 4. Configure Resiliency

Edit `application.yml` to tune circuit breaker, retry, and timeout settings

## Testing

### Unit Tests

```bash
mvn test
```

### Integration Tests

```bash
mvn verify
```

### Load Testing

Use tools like Apache JMeter, Gatling, or k6 to validate performance against NFR baseline.

## Observability

### Logs

View structured logs:

```bash
kubectl logs -f deployment/cnmrf-template -n my-namespace
```

### Metrics

Query Prometheus:

```promql
# Request rate
rate(http_server_requests_seconds_count{service="cnmrf-template"}[5m])

# Error rate
rate(http_server_requests_seconds_count{service="cnmrf-template",status=~"5.."}[5m])

# P95 latency
histogram_quantile(0.95, rate(http_server_requests_seconds_bucket{service="cnmrf-template"}[5m]))
```

### Traces

View traces in Jaeger/Tempo using trace ID from logs.

## Compliance

This template meets CNMRF NFR baseline:

- ✅ **Availability:** Health checks, graceful shutdown
- ✅ **Performance:** Optimized for P95 < 200ms
- ✅ **Scalability:** Stateless, horizontally scalable
- ✅ **Security:** Non-root, no hardcoded secrets
- ✅ **Observability:** Logs, metrics, traces
- ✅ **Resiliency:** Circuit breakers, retries, timeouts

See [NFR Baseline](../../docs/architecture/nfr-baseline.md) for details.

## References

- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Resilience4j Documentation](https://resilience4j.readme.io/)
- [Micrometer Documentation](https://micrometer.io/docs)
- [CNMRF Reference Architecture](../../docs/architecture/reference-architecture.md)
- [ADR-0001: Authentication](../../docs/adr/0001-authentication-approach.md)
- [ADR-0002: Observability](../../docs/adr/0002-observability-stack.md)
- [ADR-0003: Resiliency](../../docs/adr/0003-resiliency-patterns.md)

## Support

For questions or issues:
- Review [CNMRF Documentation](../../docs/README.md)
- Check [ADRs](../../docs/adr/README.md) for design decisions
- Refer to [NFR Baseline](../../docs/architecture/nfr-baseline.md)

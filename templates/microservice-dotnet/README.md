# .NET Minimal API Microservice Template

Production-ready .NET minimal API microservice template following CNMRF patterns.

## Overview

This template provides a minimal, production-ready .NET microservice with:

- ✅ Health checks (liveness, readiness)
- ✅ Prometheus metrics
- ✅ Structured JSON logging
- ✅ OpenAPI documentation
- ✅ Circuit breakers (Polly)
- ✅ Graceful shutdown
- ✅ Non-root container
- ✅ Helm chart for deployment

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Service Templates - .NET minimal API (health, metrics, logging, OpenAPI)"

## Technology Stack

- **.NET:** 8.0 (LTS)
- **API Style:** Minimal APIs
- **Resiliency:** Polly
- **Metrics:** OpenTelemetry + Prometheus
- **API Docs:** Swashbuckle (OpenAPI)
- **Logging:** Serilog with JSON formatter

## Project Structure

```
microservice-dotnet/
├── src/
│   ├── Program.cs
│   ├── appsettings.json
│   ├── appsettings.Development.json
│   ├── Controllers/
│   │   └── ExampleController.cs
│   ├── Services/
│   │   └── ExampleService.cs
│   └── cnmrf-template.csproj
├── Dockerfile
└── README.md
```

## Quick Start

### Prerequisites

- .NET 8 SDK+
- Docker (for containerization)

### Build and Run Locally

```bash
# Restore dependencies
dotnet restore

# Build
dotnet build

# Run
dotnet run

# Or use watch mode for development
dotnet watch run
```

### Access Endpoints

- **API:** http://localhost:8080/api/v1/example
- **Health (Live):** http://localhost:8080/health/live
- **Health (Ready):** http://localhost:8080/health/ready
- **Metrics:** http://localhost:8080/metrics
- **OpenAPI:** http://localhost:8080/swagger

### Build Container Image

```bash
docker build -t cnmrf-template-dotnet:latest .
docker run -p 8080:8080 cnmrf-template-dotnet:latest
```

## Configuration

### Application Configuration (`appsettings.json`)

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "Kestrel": {
    "Endpoints": {
      "Http": {
        "Url": "http://0.0.0.0:8080"
      }
    }
  },
  "CircuitBreaker": {
    "FailureThreshold": 0.5,
    "SamplingDuration": "00:00:10",
    "MinimumThroughput": 10,
    "DurationOfBreak": "00:01:00"
  },
  "Retry": {
    "MaxRetryAttempts": 3,
    "InitialDelay": "00:00:01"
  }
}
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ASPNETCORE_URLS` | HTTP URLs | http://0.0.0.0:8080 |
| `ASPNETCORE_ENVIRONMENT` | Environment | Production |
| `Logging__LogLevel__Default` | Log level | Information |

## Features

### 1. Health Checks

**Liveness Probe:** `/health/live`
- Returns 200 if application is running
- Used by Kubernetes to restart unhealthy pods

**Readiness Probe:** `/health/ready`
- Returns 200 if application is ready to accept traffic
- Checks database connectivity, external dependencies

```csharp
builder.Services.AddHealthChecks()
    .AddCheck("self", () => HealthCheckResult.Healthy())
    .AddCheck("database", () => /* check database */);

app.MapHealthChecks("/health/live", new HealthCheckOptions
{
    Predicate = check => check.Name == "self"
});

app.MapHealthChecks("/health/ready");
```

### 2. Metrics

Prometheus metrics exposed at `/metrics`:

- **HTTP metrics:** Request count, duration, errors
- **Runtime metrics:** GC, memory, thread pool
- **Custom metrics:** Business-specific metrics

```csharp
builder.Services.AddOpenTelemetry()
    .WithMetrics(metrics => metrics
        .AddPrometheusExporter()
        .AddMeter("Microsoft.AspNetCore.Hosting")
        .AddMeter("Microsoft.AspNetCore.Server.Kestrel"));

app.MapPrometheusScrapingEndpoint();
```

### 3. Structured Logging

All logs output as JSON using Serilog:

```json
{
  "Timestamp": "2026-01-06T17:30:00.123Z",
  "Level": "Information",
  "MessageTemplate": "Request processed successfully",
  "Properties": {
    "Service": "cnmrf-template",
    "TraceId": "abc123",
    "SpanId": "def456"
  }
}
```

### 4. Circuit Breaker

Polly circuit breaker for external service calls:

```csharp
builder.Services.AddHttpClient("ExternalService")
    .AddPolicyHandler(GetCircuitBreakerPolicy())
    .AddPolicyHandler(GetRetryPolicy());

static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .CircuitBreakerAsync(
            handledEventsAllowedBeforeBreaking: 5,
            durationOfBreak: TimeSpan.FromSeconds(60));
}
```

### 5. OpenAPI Documentation

Interactive API documentation at `/swagger`

```csharp
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

app.UseSwagger();
app.UseSwaggerUI();
```

### 6. Security

- Non-root user (UID 1001)
- Read-only root filesystem
- No hardcoded secrets
- JWT authentication ready (see ADR-0001)

```csharp
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = builder.Configuration["Auth:Authority"];
        options.Audience = builder.Configuration["Auth:Audience"];
    });

app.UseAuthentication();
app.UseAuthorization();
```

## Deployment

### Kubernetes with Helm

```bash
# Install
helm install cnmrf-template-dotnet ./helm \
  --namespace my-namespace \
  --set image.tag=1.0.0

# Upgrade
helm upgrade cnmrf-template-dotnet ./helm \
  --namespace my-namespace \
  --set image.tag=1.1.0
```

See `../infra-helm` for Helm chart details.

### GitOps with ArgoCD

```bash
# Copy GitOps structure
cp -r ../gitops-argocd ./my-gitops-repo/apps/cnmrf-template-dotnet
```

## Customization

### 1. Rename Project

Replace `cnmrf-template` with your project name:

```bash
# Rename project file
mv cnmrf-template.csproj my-service.csproj

# Update namespace in Program.cs
# (No namespaces in minimal APIs, but update service name in config)
```

### 2. Add Business Logic

- Add endpoints in `Program.cs` or separate controller files
- Add services in `Services/` directory
- Add repositories in `Repositories/` directory (if using database)

### 3. Add Dependencies

```bash
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package StackExchange.Redis
```

### 4. Configure Resiliency

Edit `appsettings.json` to tune circuit breaker, retry, and timeout settings

## Testing

### Unit Tests

```bash
dotnet test
```

### Integration Tests

Create `tests/` directory with integration test project:

```bash
dotnet new xunit -n cnmrf-template.Tests
dotnet add reference ../src/cnmrf-template.csproj
```

### Load Testing

Use tools like Apache JMeter, Gatling, or k6 to validate performance against NFR baseline.

## Observability

### Logs

View structured logs:

```bash
kubectl logs -f deployment/cnmrf-template-dotnet -n my-namespace
```

### Metrics

Query Prometheus:

```promql
# Request rate
rate(http_server_request_duration_seconds_count{service="cnmrf-template-dotnet"}[5m])

# Error rate
rate(http_server_request_duration_seconds_count{service="cnmrf-template-dotnet",http_response_status_code=~"5.."}[5m])

# P95 latency
histogram_quantile(0.95, rate(http_server_request_duration_seconds_bucket{service="cnmrf-template-dotnet"}[5m]))
```

### Traces

Enable OpenTelemetry tracing:

```csharp
builder.Services.AddOpenTelemetry()
    .WithTracing(tracing => tracing
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddJaegerExporter());
```

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

## Performance

.NET 8 minimal APIs offer excellent performance:

- **Throughput:** 100,000+ requests/second (simple endpoints)
- **Latency:** Sub-millisecond P50 for in-memory operations
- **Memory:** Low GC pressure with modern .NET runtime

## References

- [.NET Documentation](https://learn.microsoft.com/en-us/dotnet/)
- [Minimal APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis)
- [Polly Documentation](https://www.pollydocs.org/)
- [OpenTelemetry .NET](https://opentelemetry.io/docs/languages/net/)
- [CNMRF Reference Architecture](../../docs/architecture/reference-architecture.md)
- [ADR-0001: Authentication](../../docs/adr/0001-authentication-approach.md)
- [ADR-0002: Observability](../../docs/adr/0002-observability-stack.md)
- [ADR-0003: Resiliency](../../docs/adr/0003-resiliency-patterns.md)

## Support

For questions or issues:
- Review [CNMRF Documentation](../../docs/README.md)
- Check [ADRs](../../docs/adr/README.md) for design decisions
- Refer to [NFR Baseline](../../docs/architecture/nfr-baseline.md)

# ADR-0003: Resiliency Patterns Implementation

**Status:** Accepted  
**Date:** 2026-01-06  
**Decision Makers:** CNMRF Architecture Team  

## Context

Microservices in distributed systems face various failure scenarios:

- Network failures (timeouts, connection refused)
- Downstream service failures (503, 500 errors)
- Cascading failures (one failure triggers others)
- Resource exhaustion (CPU, memory, connections)
- Transient errors (temporary unavailability)

Without resiliency patterns, these failures can:
- Cause cascading outages across services
- Degrade user experience
- Exhaust resources (connection pools, threads)
- Make debugging difficult

Requirements:
- Prevent cascading failures
- Handle transient errors gracefully
- Fail fast when downstream services are unhealthy
- Maintain service availability during partial failures
- Provide clear observability into failure patterns

## Decision

We will implement the following resiliency patterns in all CNMRF service templates:

### 1. Circuit Breaker

**Purpose:** Prevent cascading failures by failing fast when a downstream service is unhealthy

**Implementation:**
- **Java/Spring Boot:** Resilience4j CircuitBreaker
- **.NET:** Polly CircuitBreaker

**Configuration:**
```yaml
circuit-breaker:
  failure-rate-threshold: 50        # Open circuit if 50% of requests fail
  minimum-number-of-calls: 10       # Minimum calls before evaluating
  wait-duration-in-open-state: 60s  # Wait 60s before trying half-open
  permitted-calls-in-half-open: 3   # Allow 3 test calls in half-open
  sliding-window-size: 100          # Track last 100 calls
```

**States:**
- **Closed:** Normal operation, requests pass through
- **Open:** Fast-fail, requests immediately rejected
- **Half-Open:** Test recovery, limited requests allowed

### 2. Retry with Exponential Backoff

**Purpose:** Handle transient failures by retrying with increasing delays

**Implementation:**
- **Java/Spring Boot:** Resilience4j Retry
- **.NET:** Polly Retry

**Configuration:**
```yaml
retry:
  max-attempts: 3                   # Maximum 3 retry attempts
  wait-duration: 1s                 # Initial wait: 1 second
  exponential-backoff-multiplier: 2 # Double wait time each retry
  retry-on-exceptions:              # Retry only on specific exceptions
    - java.net.SocketTimeoutException
    - org.springframework.web.client.ResourceAccessException
```

**Backoff Sequence:**
- Attempt 1: Immediate
- Attempt 2: Wait 1s
- Attempt 3: Wait 2s
- Attempt 4: Wait 4s (if max-attempts = 4)

**Jitter:** Add randomness to prevent thundering herd

### 3. Timeouts

**Purpose:** Prevent indefinite waiting and resource exhaustion

**Implementation:**
- **Connection Timeout:** Time to establish connection
- **Request Timeout:** Time to complete request
- **Idle Timeout:** Time before closing idle connection

**Configuration:**
```yaml
timeouts:
  connection-timeout: 5s   # 5 seconds to connect
  request-timeout: 30s     # 30 seconds to complete request
  idle-timeout: 60s        # 60 seconds before closing idle connection
```

### 4. Bulkhead

**Purpose:** Isolate resources to prevent one failing component from exhausting all resources

**Implementation:**
- **Thread Pool Isolation:** Separate thread pools per downstream service
- **Semaphore Isolation:** Limit concurrent calls

**Configuration:**
```yaml
bulkhead:
  max-concurrent-calls: 25          # Maximum 25 concurrent calls
  max-wait-duration: 0              # Don't wait if limit reached (fail fast)
```

### 5. Rate Limiting

**Purpose:** Protect services from being overwhelmed by too many requests

**Implementation:**
- **Java/Spring Boot:** Resilience4j RateLimiter
- **.NET:** Polly RateLimiter

**Configuration:**
```yaml
rate-limiter:
  limit-for-period: 100             # 100 requests
  limit-refresh-period: 1s          # Per second
  timeout-duration: 0               # Fail immediately if limit exceeded
```

## Consequences

### Positive Consequences

- **Prevents Cascading Failures:** Circuit breakers stop failures from propagating
- **Handles Transient Errors:** Retries recover from temporary issues
- **Resource Protection:** Timeouts and bulkheads prevent resource exhaustion
- **Fast Failure:** Services fail fast instead of hanging
- **Observability:** Metrics expose circuit breaker state, retry counts, timeout rates
- **Improved Availability:** Services remain partially available during failures

### Negative Consequences

- **Complexity:** Additional configuration and testing required
  - **Mitigation:** Provide sensible defaults in templates
- **False Positives:** Circuit breakers may open during legitimate traffic spikes
  - **Mitigation:** Tune thresholds based on traffic patterns
- **Retry Amplification:** Retries can amplify load on downstream services
  - **Mitigation:** Use exponential backoff and jitter; limit retry attempts

### Neutral Consequences

- Services must include resiliency libraries (Resilience4j, Polly)
- Configuration must be tuned per service based on traffic patterns
- Monitoring dashboards must include resiliency metrics

## Alternatives Considered

### Alternative 1: No Resiliency Patterns (Fail Immediately)

**Description:**  
Let failures propagate without any retry or circuit breaking

**Pros:**
- Simple implementation
- No additional libraries

**Cons:**
- Cascading failures
- Poor user experience
- No handling of transient errors
- Resource exhaustion

**Reason for Rejection:**  
Unacceptable for production systems. Resiliency is a baseline requirement.

### Alternative 2: Service Mesh (Istio, Linkerd) for Resiliency

**Description:**  
Offload resiliency to service mesh infrastructure

**Pros:**
- Centralized configuration
- No code changes required
- Consistent across all services

**Cons:**
- Adds infrastructure complexity
- Not all environments have service mesh
- Less fine-grained control
- Violates "platform-neutral" if required

**Reason for Rejection:**  
Service mesh is **optional**, not baseline. CNMRF must work without it. Services should implement resiliency in code; service mesh can provide additional layer.

### Alternative 3: Manual Retry Logic

**Description:**  
Implement custom retry logic in each service

**Pros:**
- Full control
- No external dependencies

**Cons:**
- Error-prone (easy to get wrong)
- Inconsistent across services
- No standard metrics
- Reinventing the wheel

**Reason for Rejection:**  
Resilience4j and Polly are battle-tested libraries. No need to reinvent.

## Implementation Notes

### Spring Boot Implementation (Resilience4j)

```xml
<!-- pom.xml -->
<dependency>
    <groupId>io.github.resilience4j</groupId>
    <artifactId>resilience4j-spring-boot3</artifactId>
</dependency>
```

```java
@Service
public class DownstreamServiceClient {
    
    @CircuitBreaker(name = "downstreamService", fallbackMethod = "fallback")
    @Retry(name = "downstreamService")
    @TimeLimiter(name = "downstreamService")
    public String callDownstream() {
        return restTemplate.getForObject("http://downstream/api", String.class);
    }
    
    public String fallback(Exception e) {
        log.warn("Circuit breaker fallback triggered", e);
        return "Fallback response";
    }
}
```

```yaml
# application.yml
resilience4j:
  circuitbreaker:
    instances:
      downstreamService:
        failure-rate-threshold: 50
        minimum-number-of-calls: 10
        wait-duration-in-open-state: 60s
        permitted-number-of-calls-in-half-open-state: 3
  retry:
    instances:
      downstreamService:
        max-attempts: 3
        wait-duration: 1s
        exponential-backoff-multiplier: 2
  timelimiter:
    instances:
      downstreamService:
        timeout-duration: 30s
```

### .NET Implementation (Polly)

```csharp
// Program.cs
builder.Services.AddHttpClient("DownstreamService")
    .AddPolicyHandler(GetRetryPolicy())
    .AddPolicyHandler(GetCircuitBreakerPolicy())
    .AddPolicyHandler(GetTimeoutPolicy());

static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .WaitAndRetryAsync(
            retryCount: 3,
            sleepDurationProvider: retryAttempt => 
                TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
            onRetry: (outcome, timespan, retryCount, context) =>
            {
                Log.Warning($"Retry {retryCount} after {timespan}");
            });
}

static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .CircuitBreakerAsync(
            handledEventsAllowedBeforeBreaking: 5,
            durationOfBreak: TimeSpan.FromSeconds(60),
            onBreak: (outcome, duration) =>
            {
                Log.Warning($"Circuit breaker opened for {duration}");
            },
            onReset: () =>
            {
                Log.Information("Circuit breaker reset");
            });
}

static IAsyncPolicy<HttpResponseMessage> GetTimeoutPolicy()
{
    return Policy.TimeoutAsync<HttpResponseMessage>(TimeSpan.FromSeconds(30));
}
```

### Metrics

Expose resiliency metrics for monitoring:

```
# Circuit Breaker
resilience4j_circuitbreaker_state{name="downstreamService"} 0  # 0=closed, 1=open, 2=half-open
resilience4j_circuitbreaker_failure_rate{name="downstreamService"} 0.15

# Retry
resilience4j_retry_calls_total{name="downstreamService",kind="successful_without_retry"} 1000
resilience4j_retry_calls_total{name="downstreamService",kind="successful_with_retry"} 50
resilience4j_retry_calls_total{name="downstreamService",kind="failed_with_retry"} 5

# Timeout
http_client_requests_seconds{outcome="TIMEOUT"} 12
```

**Timeline:**  
Implement in all service templates immediately

**Dependencies:**
- Resilience4j (Spring Boot)
- Polly (. NET)
- Prometheus metrics integration

## Validation

Success metrics:

- ✅ Circuit breakers configured for all external dependencies
- ✅ Retries configured with exponential backoff
- ✅ Timeouts defined for all HTTP clients
- ✅ Metrics exposed for circuit breaker state, retry counts
- ✅ Chaos testing validates resiliency (pod kills, network latency)
- ✅ Fallback methods provide graceful degradation

**Chaos Engineering Tests:**
- Kill downstream pods → Circuit breaker opens
- Inject network latency → Timeouts trigger, retries succeed
- Inject 50% error rate → Circuit breaker opens after threshold

**Review Date:** 2026-07-06 (6 months)

## References

- [Resilience4j Documentation](https://resilience4j.readme.io/)
- [Polly Documentation](https://www.pollydocs.org/)
- [Release It! by Michael Nygard](https://pragprog.com/titles/mnee2/release-it-second-edition/)
- [Circuit Breaker Pattern (Martin Fowler)](https://martinfowler.com/bliki/CircuitBreaker.html)
- [CNMRF Resiliency Patterns](../resiliency/resiliency-patterns.md)
- [CNMRF NFR Baseline](../architecture/nfr-baseline.md)

## Notes

- Circuit breaker thresholds should be tuned based on actual traffic patterns
- Fallback methods should provide meaningful degraded functionality, not just error messages
- Monitor circuit breaker state changes and alert on prolonged open state
- Consider service mesh (Istio, Linkerd) for additional resiliency layer in production
- Idempotency is critical for safe retries—ensure operations are idempotent or use idempotency keys

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# Resilient Response Design

## 1. Standard Error Model

All APIs must return a consistent error structure (RFC 7807 Problem Details).

```json
{
  "type": "https://cnmrf.io/errors/inventory-out-of-stock",
  "title": "Inventory Unavailable",
  "status": 409,
  "detail": "Item 12345 could not be reserved.",
  "instance": "/orders/9876",
  "traceId": "b47ac10b-58cc..."
}
```

## 2. Idempotency

**Intent:** Allow clients to safely retry POST requests without duplicate side-effects.
**Pattern:** Client sends `Idempotency-Key` header. Server stores key + response in Redis for 24h. If seen again, return cached response immediately.

## 3. Resilience Pattern Implementation

| Pattern | Intent | Config |
| :--- | :--- | :--- |
| **Timeout** | Fail fast if dependency hangs | `2s` default api call |
| **Retry** | Handle transient network blips | `3` attempts, exp. backoff |
| **Circuit Breaker** | Stop calling failing service | Open after 50% fail rate |
| **Bulkhead** | Isolate resources (thread pools) | Limit concurrent calls to 20 |

## 4. Reference Snippets

### Spring Boot (Resilience4j)
```java
// Circuit Breaker annotation
@CircuitBreaker(name = "backendA", fallbackMethod = "fallback")
@RateLimiter(name = "backendA")
public String doSomething(String param) {
    // ...
}

// Fallback (Degraded Mode)
public String fallback(String param, Throwable t) {
    return "Cached Value";
}
```

### .NET (Polly)
```csharp
// Define Policy in Program.cs
var retryPolicy = HttpPolicyExtensions
    .HandleTransientHttpError()
    .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));

// Inject into HttpClient
builder.Services.AddHttpClient("BackendApi")
    .AddPolicyHandler(retryPolicy);
```

### Correlation ID Middleware (Concept)

**Spring Boot:** Use `OncePerRequestFilter` to read `X-Correlation-ID` or generate UUID, put in MDC.
**.NET:** Use middleware `app.Use(...)` to read header, put in `Activity.Current.SetTag`.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

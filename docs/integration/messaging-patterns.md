# Messaging & Integration Patterns

## 1. Event-Driven Architecture (Kafka)

**Intent:** Asynchronous decoupling of producers and consumers. Real-time stream processing.

```mermaid
graph LR
    subgraph "Producer"
        P[Service A] -->|Publish| T[Kafka Topic]
    end
    subgraph "Consumer Group"
        T -->|Partition 1| C1[Instance 1]
        T -->|Partition 2| C2[Instance 2]
    end
    C1 -.->|ErrorHandler| DLQ[Dead Letter Topic]
```

### Key Considerations
*   **Partitioning:** Use specific keys (e.g., CustomerID) to guarantee ordering.
*   **Consumer Groups:** Scale consumption by adding instances up to the number of partitions.
*   **Idempotency:** Consumers must handle duplicate messages gracefully.

**Spring Boot (Snippet)**
```yaml
spring:
  kafka:
    consumer:
      group-id: cnmrf-group
      auto-offset-reset: earliest
      enable-auto-commit: false # Manual Ack preferred
```

**.NET (Snippet)**
```csharp
// MassTransit / Kafka
services.AddMassTransit(x => {
    x.UsingKafka((context, k) => {
        k.Host("localhost:9092");
        k.TopicEndpoint<OrderEvent>("order-events", "cnmrf-group", e => {
             e.ConfigureConsumer<OrderConsumer>(context);
        });
    });
});
```

## 2. Command/Queue Architecture (MQ)

**Intent:** Point-to-point reliable delivery for transactional commands.

```mermaid
graph LR
    P[Sender] -->|Put| Q[Queue]
    Q -->|Get| C[Receiver]
    C -->|ACK| Q
    C -->|NACK/Fail| Q
    Q -.->|Backout Threshold| BQ[Backout/Poison Queue]
```

### Key Considerations
*   **At-Least-Once:** Assume message might be delivered twice.
*   **Poison Messages:** Always configure a backout queue to prevent infinite retry loops.
*   **Strict Ordering:** Only possible with single consumer or exclusive grouping (scalability bottleneck).

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# CNMRF Examples

This directory contains example implementations demonstrating how to use CNMRF templates and patterns.

## Purpose

**Alignment to Project Outline:**  
Provides concrete examples of template usage and pattern implementation

## Contents

Examples will demonstrate:

- Complete service implementations using templates
- Multi-service architectures
- GitOps deployment workflows
- Security and resiliency pattern integration

## Planned Examples

### Example 1: Simple REST API
- Spring Boot service using `microservice-springboot` template
- CRUD operations with health checks and metrics
- Helm deployment with GitOps structure

### Example 2: Multi-Service Application
- Spring Boot backend + .NET API gateway
- Service-to-service communication
- Shared observability and security patterns

### Example 3: Resiliency Patterns
- Circuit breaker demonstration
- Retry with exponential backoff
- Graceful degradation

## How to Use Examples

1. Review example README for context
2. Study implementation details
3. Compare to base templates in `/templates`
4. Adapt patterns to your use case

## Relationship to Templates

- **Templates** (`/templates`) - Minimal, reusable starting points
- **Examples** (`/examples`) - Complete, opinionated implementations

Examples show how templates can be customized and composed for real-world scenarios.

## Contributing Examples

When contributing examples:

1. Use templates from `/templates` as starting point
2. Document customizations and rationale
3. Include deployment instructions
4. Demonstrate specific patterns or use cases
5. Keep examples focused and understandable

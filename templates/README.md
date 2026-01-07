# CNMRF Templates

This directory contains reusable implementation templates for cloud-native services.

## Purpose

**Alignment to Project Outline (Section 5):**  
Implements "Service Templates - Spring Boot microservice, .NET minimal API (health, metrics, logging, OpenAPI)"  
Implements "Deployment Templates - Generic Helm chart, GitOps folder structure"

## Templates

### Service Templates

#### [microservice-springboot](microservice-springboot/README.md)
Production-ready Spring Boot microservice template with:
- Health checks (liveness, readiness)
- Prometheus metrics
- Structured JSON logging
- OpenAPI documentation
- Circuit breakers (Resilience4j)
- Graceful shutdown

#### [microservice-dotnet](microservice-dotnet/README.md)
Production-ready .NET minimal API template with:
- Health checks (liveness, readiness)
- Prometheus metrics
- Structured JSON logging
- OpenAPI documentation
- Circuit breakers (Polly)
- Graceful shutdown

### Infrastructure Templates

#### [infra-helm](infra-helm/README.md)
Generic Helm chart deployable for both Spring Boot and .NET services with:
- Non-root security context
- Resource limits
- Health probes
- Horizontal Pod Autoscaling
- ConfigMap and Secret mounting

#### [gitops-argocd](gitops-argocd/README.md)
GitOps folder structure for ArgoCD with:
- Base manifests
- Environment overlays (dev, staging, prod)
- Kustomization
- ArgoCD Application definitions

## Design Principles

All templates follow CNMRF design principles (Project Outline Section 7):

1. **Platform-Neutral First** - Work on EKS, AKS, GKE, OpenShift
2. **Security by Default** - Non-root, least-privilege, no hardcoded secrets
3. **Observability Built-In** - Logging, metrics, tracing
4. **Resiliency as Baseline** - Circuit breakers, retries, health checks
5. **Documentation-Driven** - Comprehensive README and inline comments

## Template Baseline

All service templates include:

✅ **Health Checks** - `/health/live` and `/health/ready` endpoints  
✅ **Metrics** - Prometheus `/metrics` endpoint  
✅ **Logging** - Structured JSON logging  
✅ **OpenAPI** - API documentation at `/swagger` or `/api-docs`  
✅ **Circuit Breakers** - Resilience4j (Spring Boot) or Polly (.NET)  
✅ **Graceful Shutdown** - SIGTERM handling  
✅ **Non-Root Container** - UID > 1000  
✅ **Resource Limits** - CPU and memory limits in Helm chart  

## How to Use

### 1. Choose a Template

Select based on your technology stack:
- **Java/Spring Boot:** `microservice-springboot/`
- **.NET:** `microservice-dotnet/`

### 2. Clone the Template

```powershell
# Copy template to your project
cp -r templates/microservice-springboot ../my-service
cd ../my-service
```

### 3. Customize

- Update `README.md` with your service details
- Modify application code in `src/`
- Update Helm chart values in `helm/values.yaml`
- Review and customize configuration

### 4. Deploy

```powershell
# Build container image
docker build -t my-service:latest .

# Deploy with Helm
helm install my-service helm/ --namespace my-namespace
```

### 5. Set Up GitOps

```powershell
# Copy GitOps structure
cp -r templates/gitops-argocd ../my-gitops-repo/apps/my-service
```

## Validation

All templates pass CNMRF quality gates:

```powershell
# Run quality gates
.\tools\scripts\run-all.ps1
```

## Relationship to Documentation

Templates implement patterns documented in `/docs`:

- **Architecture:** Templates follow reference architecture in `/docs/architecture`
- **Security:** Templates implement security baseline from `/docs/security`
- **Resiliency:** Templates implement patterns from `/docs/resiliency`
- **ADRs:** Templates reflect decisions in `/docs/adr`

## Contributing Templates

New templates must:

1. Align with [Project Outline](../docs/governance/project-outline.md)
2. Implement all design principles (Section 7)
3. Include comprehensive README
4. Pass all quality gate scripts
5. Include example ADR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details.

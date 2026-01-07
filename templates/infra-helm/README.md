# Generic Helm Chart for CNMRF Microservices

Production-ready Helm chart deployable for both Spring Boot and .NET microservices.

## Overview

This Helm chart provides Kubernetes deployment manifests following CNMRF patterns:

- ✅ Non-root security context
- ✅ Resource limits and requests
- ✅ Health probes (liveness, readiness, startup)
- ✅ Horizontal Pod Autoscaling (HPA)
- ✅ ConfigMap and Secret mounting
- ✅ Service and Ingress
- ✅ Pod Disruption Budget
- ✅ Network Policies

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Deployment Templates - Generic Helm chart"

## Chart Structure

```
infra-helm/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│   ├── pdb.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── serviceaccount.yaml
│   ├── networkpolicy.yaml
│   └── _helpers.tpl
└── README.md
```

## Quick Start

### Install

```bash
helm install my-service ./infra-helm \
  --namespace my-namespace \
  --create-namespace \
  --set image.repository=my-registry/my-service \
  --set image.tag=1.0.0
```

### Upgrade

```bash
helm upgrade my-service ./infra-helm \
  --namespace my-namespace \
  --set image.tag=1.1.0
```

### Uninstall

```bash
helm uninstall my-service --namespace my-namespace
```

## Configuration

### values.yaml

```yaml
# Image configuration
image:
  repository: cnmrf/template
  tag: latest
  pullPolicy: IfNotPresent

# Replica configuration
replicaCount: 2

# Service configuration
service:
  type: ClusterIP
  port: 80
  targetPort: 8080

# Resource limits
resources:
  requests:
    cpu: 100m
    memory: 256Mi
  limits:
    cpu: 500m
    memory: 512Mi

# Health probes
livenessProbe:
  httpGet:
    path: /health/live
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /health/ready
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5

# Autoscaling
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

# Security context
securityContext:
  runAsNonRoot: true
  runAsUser: 1001
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

### Common Overrides

```bash
# Set image
--set image.repository=my-registry/my-service
--set image.tag=1.2.3

# Set replicas
--set replicaCount=3

# Set resources
--set resources.requests.cpu=200m
--set resources.requests.memory=512Mi

# Enable ingress
--set ingress.enabled=true
--set ingress.host=my-service.example.com

# Set environment variables
--set env.LOG_LEVEL=DEBUG
```

## Features

### 1. Security by Default

- **Non-root user:** UID 1001
- **Read-only root filesystem**
- **No privilege escalation**
- **Dedicated ServiceAccount**
- **Network policies** (optional)

### 2. Resource Management

- **Requests and limits** for CPU and memory
- **QoS class:** Burstable (requests < limits)
- **Horizontal Pod Autoscaling** based on CPU/memory

### 3. High Availability

- **Minimum 2 replicas** in production
- **Pod Disruption Budget:** Ensures at least 1 pod available during disruptions
- **Anti-affinity:** Spread pods across nodes (optional)

### 4. Health Checks

- **Liveness probe:** Restart unhealthy pods
- **Readiness probe:** Remove unready pods from service
- **Startup probe:** Handle slow-starting applications

### 5. Configuration Management

- **ConfigMap:** Non-sensitive configuration
- **Secret:** Sensitive configuration (mounted as volumes)
- **Environment variables:** From ConfigMap/Secret

### 6. Networking

- **Service:** ClusterIP, NodePort, or LoadBalancer
- **Ingress:** HTTP/HTTPS routing with TLS
- **Network Policy:** Restrict pod-to-pod traffic

## Deployment Patterns

### Blue-Green Deployment

```bash
# Deploy green version
helm install my-service-green ./infra-helm \
  --namespace my-namespace \
  --set image.tag=2.0.0 \
  --set service.selector.version=green

# Switch traffic
kubectl patch service my-service -p '{"spec":{"selector":{"version":"green"}}}'

# Remove blue version
helm uninstall my-service-blue --namespace my-namespace
```

### Canary Deployment

```bash
# Deploy canary with 10% traffic
helm install my-service-canary ./infra-helm \
  --namespace my-namespace \
  --set image.tag=2.0.0 \
  --set replicaCount=1 \
  --set service.selector.version=canary

# Gradually increase canary replicas
helm upgrade my-service-canary ./infra-helm \
  --set replicaCount=2
```

## Multi-Environment Configuration

### Development

```yaml
# values-dev.yaml
replicaCount: 1
resources:
  requests:
    cpu: 50m
    memory: 128Mi
autoscaling:
  enabled: false
```

```bash
helm install my-service ./infra-helm \
  --namespace dev \
  --values values-dev.yaml
```

### Staging

```yaml
# values-staging.yaml
replicaCount: 2
resources:
  requests:
    cpu: 100m
    memory: 256Mi
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5
```

### Production

```yaml
# values-prod.yaml
replicaCount: 3
resources:
  requests:
    cpu: 200m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
podDisruptionBudget:
  enabled: true
  minAvailable: 2
```

## Monitoring

### Prometheus Annotations

```yaml
# Automatically added to pods
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"
  prometheus.io/path: "/metrics"
```

### Grafana Dashboards

Pre-built dashboards available in `/examples/dashboards/`

## Troubleshooting

### Pod Not Starting

```bash
# Check pod status
kubectl get pods -n my-namespace

# View pod events
kubectl describe pod <pod-name> -n my-namespace

# View logs
kubectl logs <pod-name> -n my-namespace
```

### Health Check Failures

```bash
# Test health endpoints
kubectl port-forward <pod-name> 8080:8080 -n my-namespace
curl http://localhost:8080/health/live
curl http://localhost:8080/health/ready
```

### Resource Limits

```bash
# View resource usage
kubectl top pods -n my-namespace

# Adjust limits
helm upgrade my-service ./infra-helm \
  --set resources.limits.memory=1Gi
```

## Compliance

This Helm chart meets CNMRF NFR baseline:

- ✅ **Availability:** Multiple replicas, PDB, health checks
- ✅ **Scalability:** HPA configured
- ✅ **Security:** Non-root, read-only FS, network policies
- ✅ **Resiliency:** Resource limits, graceful shutdown
- ✅ **Observability:** Prometheus annotations

See [NFR Baseline](../../docs/architecture/nfr-baseline.md) for details.

## References

- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [CNMRF Reference Architecture](../../docs/architecture/reference-architecture.md)
- [CNMRF Security Baseline](../../docs/security/security-baseline.md)

## Support

For questions or issues:
- Review [CNMRF Documentation](../../docs/README.md)
- Check [Helm Chart Templates](./templates/)
- Refer to [values.yaml](./values.yaml) for all configuration options

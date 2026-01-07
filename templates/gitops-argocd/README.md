# GitOps Structure for ArgoCD

GitOps folder structure and ArgoCD Application definitions for CNMRF microservices.

## Overview

This template provides a GitOps repository structure following best practices:

- ✅ Base manifests with Kustomize
- ✅ Environment overlays (dev, staging, prod)
- ✅ ArgoCD Application definitions
- ✅ Clear separation of concerns
- ✅ DRY principle (Don't Repeat Yourself)

**Alignment to Project Outline:**  
Implements Section 5 deliverable: "Deployment Templates - GitOps folder structure"  
Implements Section 7 principle: "GitOps-Ready"

## Structure

```
gitops-argocd/
├── apps/
│   └── my-service/
│       ├── base/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── kustomization.yaml
│       └── overlays/
│           ├── dev/
│           │   ├── kustomization.yaml
│           │   ├── patch-replicas.yaml
│           │   └── patch-resources.yaml
│           ├── staging/
│           │   ├── kustomization.yaml
│           │   ├── patch-replicas.yaml
│           │   └── patch-resources.yaml
│           └── prod/
│               ├── kustomization.yaml
│               ├── patch-replicas.yaml
│               ├── patch-resources.yaml
│               └── patch-hpa.yaml
└── argocd/
    └── applications/
        ├── my-service-dev.yaml
        ├── my-service-staging.yaml
        └── my-service-prod.yaml
```

## Quick Start

### 1. Copy Template

```bash
# Copy to your GitOps repository
cp -r gitops-argocd /path/to/your/gitops-repo/

# Rename service
mv apps/my-service apps/your-service-name
```

### 2. Update Base Manifests

Edit `apps/your-service-name/base/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: your-service-name
spec:
  replicas: 2  # Will be overridden by overlays
  template:
    spec:
      containers:
      - name: app
        image: your-registry/your-service:latest  # Tag will be updated by CI/CD
```

### 3. Configure Overlays

Each environment overlay patches base manifests:

**Dev:** `overlays/dev/kustomization.yaml`
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: dev

resources:
  - ../../base

patches:
  - path: patch-replicas.yaml
  - path: patch-resources.yaml

images:
  - name: your-registry/your-service
    newTag: dev-abc123  # Updated by CI/CD
```

### 4. Create ArgoCD Applications

Edit `argocd/applications/your-service-dev.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: your-service-dev
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/your-gitops-repo
    targetRevision: main
    path: apps/your-service/overlays/dev
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### 5. Apply ArgoCD Applications

```bash
kubectl apply -f argocd/applications/your-service-dev.yaml
kubectl apply -f argocd/applications/your-service-staging.yaml
kubectl apply -f argocd/applications/your-service-prod.yaml
```

## GitOps Workflow

### CI/CD Pipeline Updates Image Tag

```yaml
# Example GitHub Actions workflow
- name: Update GitOps Repository
  run: |
    cd gitops-repo
    kustomize edit set image your-registry/your-service:${{ github.sha }}
    git commit -am "Update image to ${{ github.sha }}"
    git push
```

### ArgoCD Detects Change and Syncs

ArgoCD automatically:
1. Detects commit in GitOps repository
2. Compares desired state (Git) vs. actual state (Kubernetes)
3. Syncs changes to Kubernetes cluster
4. Reports sync status

## Environment Configuration

### Development

- **Namespace:** `dev`
- **Replicas:** 1
- **Resources:** Minimal (50m CPU, 128Mi memory)
- **Autoscaling:** Disabled
- **Sync Policy:** Automated with self-heal

### Staging

- **Namespace:** `staging`
- **Replicas:** 2
- **Resources:** Moderate (100m CPU, 256Mi memory)
- **Autoscaling:** Enabled (2-5 replicas)
- **Sync Policy:** Automated with self-heal

### Production

- **Namespace:** `prod`
- **Replicas:** 3
- **Resources:** Production (200m CPU, 512Mi memory)
- **Autoscaling:** Enabled (3-20 replicas)
- **Sync Policy:** Manual approval for safety

## Kustomize Patterns

### Patch Replicas

```yaml
# overlays/prod/patch-replicas.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: your-service
spec:
  replicas: 3
```

### Patch Resources

```yaml
# overlays/prod/patch-resources.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: your-service
spec:
  template:
    spec:
      containers:
      - name: app
        resources:
          requests:
            cpu: 200m
            memory: 512Mi
          limits:
            cpu: 1000m
            memory: 1Gi
```

### Add HPA

```yaml
# overlays/prod/patch-hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: your-service
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: your-service
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## ArgoCD Features

### Automated Sync

```yaml
syncPolicy:
  automated:
    prune: true      # Delete resources not in Git
    selfHeal: true   # Revert manual changes
```

### Manual Sync (Production)

```yaml
syncPolicy:
  automated: null  # Disable automated sync
  syncOptions:
    - CreateNamespace=true
```

### Sync Waves

Control deployment order:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"  # Deploy after wave 0
```

### Health Checks

ArgoCD monitors:
- Deployment rollout status
- Pod health (liveness/readiness)
- Custom health checks

## Best Practices

### 1. Separate GitOps Repository

- **App Code:** `github.com/your-org/your-service`
- **GitOps Manifests:** `github.com/your-org/gitops-repo`

**Rationale:** Decouples application changes from deployment configuration

### 2. Use Kustomize for DRY

- Define base manifests once
- Patch per environment
- Avoid duplicating YAML

### 3. Immutable Image Tags

- Use commit SHA or semantic version
- Never use `latest` tag
- Enables rollback and audit trail

### 4. Environment Promotion

```bash
# Promote staging image to production
cd apps/your-service/overlays/prod
kustomize edit set image your-registry/your-service:staging-abc123
git commit -am "Promote staging-abc123 to production"
git push
```

### 5. Secrets Management

**Do NOT commit secrets to Git!**

Use External Secrets Operator:

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: your-service-secrets
spec:
  secretStoreRef:
    name: vault-backend
  target:
    name: your-service-secrets
  data:
  - secretKey: database-password
    remoteRef:
      key: your-service/database-password
```

## Monitoring

### ArgoCD UI

Access ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Open https://localhost:8080
```

### CLI

```bash
# Install ArgoCD CLI
brew install argocd  # Mac
choco install argocd-cli  # Windows

# Login
argocd login localhost:8080

# List applications
argocd app list

# Get application status
argocd app get your-service-prod

# Sync application
argocd app sync your-service-prod
```

## Troubleshooting

### Application Out of Sync

```bash
# View diff
argocd app diff your-service-prod

# Sync manually
argocd app sync your-service-prod
```

### Sync Failures

```bash
# View sync status
argocd app get your-service-prod

# View events
kubectl get events -n prod --sort-by='.lastTimestamp'
```

### Rollback

```bash
# View history
argocd app history your-service-prod

# Rollback to previous version
argocd app rollback your-service-prod <revision-number>
```

## Compliance

This GitOps structure meets CNMRF principles:

- ✅ **GitOps-Ready:** All config as code, declarative
- ✅ **Separation of Concerns:** Base + overlays
- ✅ **Auditability:** Git history tracks all changes
- ✅ **Rollback:** Git revert enables easy rollback
- ✅ **Multi-Environment:** Dev, staging, prod overlays

See [CI/CD Patterns](../../docs/cicd/gitops-structure.md) for details.

## References

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Kustomize Documentation](https://kustomize.io/)
- [GitOps Principles](https://opengitops.dev/)
- [CNMRF CI/CD Patterns](../../docs/cicd/README.md)

## Support

For questions or issues:
- Review [CNMRF Documentation](../../docs/README.md)
- Check [ArgoCD Best Practices](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)
- Refer to [Kustomize Examples](https://github.com/kubernetes-sigs/kustomize/tree/master/examples)

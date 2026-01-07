# CI/CD Documentation

This directory contains reference CI/CD patterns and pipeline examples for cloud-native services.

## Purpose

**Alignment to Project Outline (Section 5):**  
Supports "Quality Gates" deliverable and "GitOps-Ready" design principle

**Design Principle (Section 7):**  
Implements "GitOps-Ready" principle

## GitOps-Ready Principle

From Project Outline Section 7:

> **GitOps-Ready**
> - All infrastructure and config as code
> - Declarative manifests
> - Clear separation of app code and deployment config

## CI/CD Scope

CNMRF provides:

✅ **Reference pipeline patterns** (build, test, scan, deploy)  
✅ **GitOps folder structure** (see `/templates/gitops-argocd`)  
✅ **Quality gate examples** (see `/tools/scripts`)  

CNMRF does NOT provide:

❌ **Full CI/CD pipeline implementations** (see Project Outline Section 5)  
❌ **Platform-specific pipeline code** (teams must adapt to their CI/CD platform)  

## Contents

- **[Pipeline Patterns](pipeline-patterns.md)** - Reference CI/CD pipeline stages
- **[GitOps Structure](gitops-structure.md)** - GitOps folder organization
- **[Quality Gates](quality-gates.md)** - Automated quality checks

## Pipeline Stages

CNMRF reference pipelines include:

### 1. Build
- Compile application
- Run unit tests
- Generate artifacts (JAR, DLL, container image)

### 2. Security Scan
- Container image scanning (Trivy, Snyk)
- Dependency vulnerability scanning
- SAST (Static Application Security Testing)

### 3. Quality Gates
- Code coverage thresholds
- Linting (code, Dockerfile, Helm)
- Markdown link checking

### 4. Publish
- Push container image to registry
- Tag with commit SHA and semantic version

### 5. Deploy (GitOps)
- Update GitOps repository with new image tag
- ArgoCD detects change and deploys

## GitOps Structure

See `/templates/gitops-argocd` for complete folder structure.

```
gitops/
├── apps/
│   └── my-service/
│       ├── base/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   └── kustomization.yaml
│       └── overlays/
│           ├── dev/
│           ├── staging/
│           └── prod/
└── argocd/
    └── applications/
```

## Quality Gates

CNMRF provides PowerShell scripts in `/tools/scripts`:

- `verify-structure.ps1` - Validate repository structure
- `lint-markdown.ps1` - Lint markdown files
- `check-links.ps1` - Validate documentation links
- `run-all.ps1` - Run all quality gates

## CI/CD Platform Compatibility

CNMRF patterns work with:

- **GitHub Actions**
- **GitLab CI**
- **Azure DevOps Pipelines**
- **Jenkins**
- **Tekton**

Teams must adapt reference patterns to their specific CI/CD platform.

## How to Use

1. Review [Pipeline Patterns](pipeline-patterns.md) for reference stages
2. Adapt patterns to your CI/CD platform (GitHub Actions, GitLab CI, etc.)
3. Implement [Quality Gates](quality-gates.md) in your pipeline
4. Set up GitOps structure per [GitOps Structure](gitops-structure.md)
5. Configure ArgoCD to watch your GitOps repository

## Relationship to Templates

CI/CD documentation provides **pipeline patterns**.  
Service templates in `/templates` include **Dockerfiles** and **Helm charts** used by pipelines.  
GitOps template in `/templates/gitops-argocd` provides **deployment structure**.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

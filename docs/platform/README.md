# Platform Engineering Documentation

This directory contains guidance for building internal developer platforms using CNMRF patterns.

## Purpose

**Alignment to Project Outline (Section 7):**  
Supports "Platform-Neutral First" design principle

**Target Audience:**  
Platform engineering teams building Kubernetes-based internal developer platforms

## Platform-Neutral Principle

From Project Outline Section 7:

> **Platform-Neutral First**
> - Use Kubernetes as the baseline abstraction
> - Avoid cloud-specific APIs in core templates
> - Document cloud-specific extensions separately

## Platform Engineering Scope

CNMRF provides patterns for:

✅ **Kubernetes-based platforms** (EKS, AKS, GKE, OpenShift)  
✅ **Platform capabilities** (observability, security, GitOps)  
✅ **Developer experience** (templates, self-service)  

CNMRF does NOT provide:

❌ **Platform automation engines** (see Project Outline Section 4)  
❌ **UI dashboards** (see Project Outline Section 5)  
❌ **Vendor-specific implementations**  

## Contents

- **[Platform Design](platform-design.md)** - Platform architecture patterns
- **[Multi-Cloud Guidance](multi-cloud.md)** - Running on EKS, AKS, GKE, OpenShift
- **[Developer Experience](developer-experience.md)** - Self-service patterns

## Platform Capabilities

CNMRF templates provide baseline platform capabilities:

### Observability
- Structured logging (JSON)
- Prometheus metrics
- OpenTelemetry tracing
- Health check endpoints

### Security
- Non-root containers
- RBAC templates
- Secret management integration
- Network policies

### Resiliency
- Circuit breakers
- Retries with backoff
- Health checks
- Graceful shutdown

### GitOps
- Declarative manifests
- ArgoCD folder structure
- Environment separation

## Multi-Cloud Compatibility

CNMRF templates work on:

- **AWS EKS** - Elastic Kubernetes Service
- **Azure AKS** - Azure Kubernetes Service
- **Google GKE** - Google Kubernetes Engine
- **Red Hat OpenShift** - Enterprise Kubernetes platform

Cloud-specific extensions (e.g., AWS ALB Ingress, Azure Application Gateway) are documented separately but not required.

## How to Use

1. Review [Platform Design](platform-design.md) for architecture patterns
2. Choose your Kubernetes platform (EKS, AKS, GKE, OpenShift)
3. Review [Multi-Cloud Guidance](multi-cloud.md) for platform-specific notes
4. Deploy service templates from `/templates`
5. Configure GitOps structure from `/templates/gitops-argocd`

## Relationship to Templates

Platform documentation provides **context** for how templates fit into a broader platform.  
Service templates in `/templates` are **platform-agnostic** and work across all supported Kubernetes distributions.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

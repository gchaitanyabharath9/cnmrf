# Cloud-Native Modernization Reference Framework (CNMRF)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Framework](https://img.shields.io/badge/Type-Reference%20Framework-blue.svg)]()
[![Status](https://img.shields.io/badge/Status-Active-green.svg)]()

## What This Is

**CNMRF is an open-source architectural reference framework** that provides vendor-neutral, production-ready patterns for cloud-native modernization.

**This is a FRAMEWORK, not a product.** CNMRF provides reusable patterns, templates, and guidance that organizations can adopt to improve their cloud-native implementations. It is freely available under the Apache 2.0 license and designed for public benefit.

### Purpose

CNMRF exists to:

- **Standardize** implementation patterns for cloud-native modernization
- **Provide** vendor-neutral guidance usable across clouds and platforms  
- **Bridge** architectural principles and real-world implementation
- **Enable** consistent, secure, resilient system design

### What CNMRF Provides

- 📐 **Reference Architecture** - Comprehensive patterns with Mermaid diagrams
- 📋 **Service Templates** - Production-ready Spring Boot and .NET templates
- ✅ **Baselines** - Security, resiliency, and NFR requirements
- 📝 **Architecture Decision Records** - Documented best practices and rationale
- 🔧 **Deployment Patterns** - Helm charts and GitOps structures
- 🛡️ **Quality Gates** - Validation scripts for structure and documentation

## What This Is NOT

**Critical:** CNMRF is a reference framework, not a commercial product. Specifically:

❌ **NOT a SaaS Product** - No hosted services, dashboards, or managed offerings  
❌ **NOT an Automation Platform** - No runtime engines, orchestration, or workflow automation  
❌ **NOT a Commercial Offering** - No paid tiers, enterprise editions, or support contracts  
❌ **NOT Vendor-Specific** - Works across AWS EKS, Azure AKS, Google GKE, Red Hat OpenShift  
❌ **NOT Proprietary** - Open-source (Apache 2.0), freely available to all  
❌ **NOT a Full Platform** - Provides templates and patterns, not a complete runnable system  

**CNMRF's value lies in its reusability, neutrality, and public benefit—not in commercialization.**

## Quick Start

```powershell
# Clone the repository
git clone <repository-url>
cd cnmrf

# Validate structure
.\tools\scripts\run-all.ps1

# Explore templates
cd templates\microservice-springboot
# or
cd templates\microservice-dotnet
```

## Repository Structure

```
cnmrf/
├── docs/                          # All documentation
│   ├── architecture/              # Reference architecture and diagrams
│   ├── adr/                       # Architecture Decision Records
│   ├── security/                  # Security baselines and patterns
│   ├── resiliency/                # Resiliency patterns and guidance
│   ├── platform/                  # Platform engineering guidance
│   ├── cicd/                      # CI/CD reference patterns
│   └── governance/                # Project governance and scope control
├── templates/                     # Reusable implementation templates
│   ├── microservice-springboot/   # Spring Boot service template
│   ├── microservice-dotnet/       # .NET minimal API template
│   ├── infra-helm/                # Generic Helm chart
│   └── gitops-argocd/             # GitOps folder structure
├── examples/                      # Example implementations
└── tools/                         # Validation and quality scripts
    └── scripts/                   # PowerShell validation scripts
```

## Target Audience

- Enterprise architects leading cloud-native transformations
- Platform engineering teams building internal developer platforms
- Senior software engineers implementing microservices
- DevOps/SRE practitioners establishing operational standards

## Design Principles

1. **Platform-Neutral First** - Kubernetes baseline, no vendor lock-in
2. **Security by Default** - Non-root containers, least-privilege RBAC
3. **Observability Built-In** - Structured logging, metrics, tracing
4. **Opinionated but Adaptable** - Strong defaults, easy customization
5. **Documentation-Driven** - Every pattern documented and justified
6. **Resiliency as Baseline** - Circuit breakers, retries, graceful shutdown

## Documentation

- **[Project Outline](docs/governance/project-outline.md)** - Project identity, scope, and governance
- **[Architecture Guide](docs/architecture/README.md)** - Reference architecture and patterns
- **[ADR Index](docs/adr/README.md)** - Architecture decision records
- **[Security Baseline](docs/security/README.md)** - Security standards and patterns
- **[Resiliency Patterns](docs/resiliency/README.md)** - Resiliency implementation guidance

## Getting Started

### 1. Review the Project Outline
Start with [`docs/governance/project-outline.md`](docs/governance/project-outline.md) to understand CNMRF's purpose, scope, and boundaries.

### 2. Explore the Architecture
Read [`docs/architecture/README.md`](docs/architecture/README.md) for the reference architecture and design patterns.

### 3. Choose a Template
Select a service template based on your stack:
- **Spring Boot:** `templates/microservice-springboot/`
- **.NET:** `templates/microservice-dotnet/`

### 4. Review ADRs
Understand key decisions by reading [`docs/adr/README.md`](docs/adr/README.md).

### 5. Validate Your Implementation
Use quality gate scripts in `tools/scripts/` to validate your customizations.

## Contributing

CNMRF is an open-source project. Contributions are welcome following these guidelines:

1. All contributions must align with the [Project Outline](docs/governance/project-outline.md)
2. New templates must include comprehensive documentation
3. ADRs must be provided for significant architectural decisions
4. All quality gate scripts must pass

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Support

CNMRF is a reference framework, not a product. Support is community-driven:

- **Documentation:** All guidance is in the `docs/` folder
- **Issues:** Use GitHub Issues for bugs or clarifications
- **Discussions:** Use GitHub Discussions for questions and ideas

## Success Criteria

CNMRF is successful when:

✅ Teams can adopt it by reading documentation alone  
✅ Templates work on EKS, AKS, GKE, and OpenShift without modification  
✅ Engineers understand its purpose and usage within 30 minutes  
✅ Organizations can extend it without modifying core principles  

---

**CNMRF is a framework, not a product.** Its value lies in clarity, reusability, and neutrality.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

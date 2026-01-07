# Cloud-Native Modernization Reference Framework (CNMRF)

## Overview

CNMRF is an open-source, platform-neutral architectural reference framework created to address the implementation gap in cloud-native modernization. While architectural principles—such as microservices, containerization, and declarative infrastructure—are widely understood, organizations often lack standardized, production-ready patterns for implementing these principles consistently across diverse environments.

CNMRF provides vendor-neutral architectural patterns, service templates, and security baselines validated for AWS, Azure, Google Cloud, and Red Hat OpenShift. Its purpose is to enable organizations to adopt cloud-native architectures without vendor lock-in, ensuring portability, security, and resiliency by default.

## What This Is Not

CNMRF is a reference framework, not a commercial product. Specifically:

*   **Not a Product:** It is not a software product, SaaS offering, or managed service.
*   **Not a Platform:** It is not an automation platform or workflow engine.
*   **Not Commercial:** It has no pricing tiers, enterprise editions, or support contracts.
*   **Not Vendor-Specific:** It relies on standard Kubernetes APIs rather than proprietary cloud services.
*   **Not Tied to Employment:** It is an independent contribution, not affiliated with any specific employer or company.

## Intended Audience

This framework is designed for:

*   **Enterprise Architects:** Defining organization-wide standards for cloud adoption.
*   **Platform Engineers:** Building internal developer platforms (IDPs).
*   **Senior Technical Leaders:** Evaluating architectural strategies for multi-cloud environments.
*   **Software Engineers:** Implementing production-grade microservices.

## Design Principles

CNMRF is built on six core principles:

1.  **Platform-Neutral First:** Prioritize standard APIs over cloud-specific extensions to ensure portability.
2.  **Security by Default:** Enforce non-root execution, least privilege, and read-only filesystems as mandatory baselines.
3.  **Observability Built-In:** Include structured logging, metrics, and tracing in all templates.
4.  **Resiliency as Baseline:** Implement circuit breakers, retries, and graceful degradation patterns by default.
5.  **Opinionated but Adaptable:** Provide strong defaults based on industry best practices while allowing customization.
6.  **Documentation-Driven:** Ensure every architectural decision is documented and justified.

## Repository Structure

The repository is organized as follows:

*   `docs/`: Comprehensive documentation.
    *   `architecture/`: Reference architecture patterns and diagrams.
    *   `adr/`: Architecture Decision Records explaining rationale and trade-offs.
    *   `security/`: Security baselines and compliance standards.
    *   `resiliency/`: Patterns for system reliability and fault tolerance.
    *   `publication/`: Information regarding framework publication and copyright.
*   `templates/`: Reusable service templates (Spring Boot, .NET) and deployment charts.

## How to Use This Repository

1.  **Review Governance:** Start with `docs/governance/project-outline.md` to understand the framework's scope.
2.  **Study Architecture:** Consult `docs/architecture/README.md` for core design patterns.
3.  **Explore Decisions:** read `docs/adr/README.md` to understand the rationale behind key architectural choices.
4.  **Adopt Templates:** Use the reference implementations in `templates/` as a baseline for new services.

## Authorship & Independence

The Cloud-Native Modernization Reference Framework (CNMRF) is an original open-source contribution authored solely by **Chaitanya Bharath Gopu**.

This work was created independently as a contribution to the field of cloud-native architecture. It is not a work-for-hire and is not affiliated with, sponsored by, or endorsed by any current or former employer.

## 7. Citation
If you use CNMRF in your work, please cite it as:
> Gopu, C. B. (2026). Cloud-Native Modernization Reference Framework (CNMRF) [Computer software]. https://github.com/gchaitanyabharath9/cnmrf

See [CITATION.cff](CITATION.cff) for more details.

## 8. License
Copyright 2026 Chaitanya Bharath Gopu.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0


Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


## Copyright
Copyright (c) 2026 Chaitanya Bharath Gopu. All rights reserved.
This repository and its documentation are protected by intellectual property laws.

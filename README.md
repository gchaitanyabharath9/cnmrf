# Cloud-Native Modernization Reference Framework (CNMRF)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Version](https://img.shields.io/github/v/release/gchaitanyabharath9/cnmrf)](https://github.com/gchaitanyabharath9/cnmrf/releases)

**CNMRF** is a platform-neutral, vendor-agnostic reference framework designed to standardize the modernization of large-scale enterprise systems. It provides a comprehensive set of architectural patterns, governance models, and implementation guidelines to decouple business logic from underlying infrastructure.

## Core Objectives

*   **Prevent Vendor Lock-in**: Abstract cloud-provider specifics through a unified governance layer.
*   **Zero Trust Security**: Standardize identity propagation and policy enforcement across hybrid environments.
*   **Immutable Infrastructure**: Enforce GitOps-driven reconciliation for all platform resources.
*   **Operational Consistency**: Provide a single "Golden Path" for developers regardless of the target cloud (AWS, Azure, GCP).

## Technical Pillars

CNMRF is built upon four foundational pillars:

1.  **Governance**: Policy-as-Code (OPA/Gatekeeper) and architectural review standards.
2.  **Platform Engineering**: Self-service catalogs and standardized IDPs.
3.  **Security**: Identity federation (OIDC), mTLS everywhere, and secret management standardization.
4.  **Observability**: OpenTelemetry-based tracing and unified logging schemas.

## Documentation

Comprehensive documentation is available in the `docs/` directory:

*   [Authoritative Reference](docs/publication/CNMRF_Authoritative_Reference.md)
*   [Technical Architecture](docs/publication/CNMRF_Technical_Article.md)
*   [Security Standards](docs/security/README.md)

## Citation

If you use CNMRF in your research or architecture, please cite it using the metadata in `CITATION.cff` or:

> Gopu, C. B. (2026). Cloud-Native Modernization Reference Framework (CNMRF) [Computer software]. https://github.com/gchaitanyabharath9/cnmrf

## Contributing

We welcome contributions from the community. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and development process.

## License

Copyright (c) 2026 Chaitanya Bharath Gopu.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


## Governance & Stewardship

The Cloud-Native Modernization Reference Framework (CNMRF) is stewarded by an independently registered entity functioning solely as a non-profit-style publisher. Its operational mandate is strictly limited to the maintenance, integrity, and dissemination of the framework's core intellectual property.

### Neutrality Commitment
The stewardship entity maintains CNMRF as a vendor-neutral standard. It does not engage in commercial software consulting, resell cloud services, or endorse specific third-party vendors. This structural separation ensures that CNMRF's architectural patterns remain objective and free from commercial bias.

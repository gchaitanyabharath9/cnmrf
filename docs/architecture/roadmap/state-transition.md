# State Transition: Before, After, Target

## 1. State Definitions

*   **Current State (Before):** Monolithic applications running on virtualization in on-premises data centers. Manual deployments (quarterly), siloed teams, high licensing costs.
*   **Transitional State (Hybrid):** "Lift and Shift" of some workloads to cloud IaaS. Introduction of containers but lacking orchestration. High cost due to dual running (cloud + DC) and lack of optimization.
*   **Target State (CNMRF):** Fully cloud-native. Microservices on Kubernetes. Automated CI/CD. Zero Trust security. Cost-optimized via autoscaling and spot usage. 

## 2. Comparative Matrix

| Domain | Before (Legacy) | Target (CNMRF) |
| :--- | :--- | :--- |
| **Architecture** | Monolithic, Tightly Coupled | Microservices, Event-Driven |
| **Hosting** | Physical/Virtual Servers (Pets) | Kubernetes Nodes (Cattle) |
| **Deployment** | Manual, Scripted, Quarterly | GitOps, Automated, Daily |
| **Scalability** | Vertical (Add RAM/CPU) | Horizontal (Add Replicas) |
| **Security** | Perimeter Firewall (Castle & Moat)| Zero Trust (mTLS, Identity-aware) |
| **Observability**| Siloed Logs, Manual Checks | Distributed Tracing, Central Metrics |
| **Cost Model** | CapEx (Provision for Peak) | OpEx (Pay for Usage) |

## 3. Transition Principles

1.  **Strangler Fig Pattern:** Do not rewrite the monolith. Peel off capabilities into new microservices.
2.  **API First:** Define contracts (OpenAPI) before implementation.
3.  **Automate First:** Do not perform manual operations in the cloud. Defined in IaC from Day 1.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

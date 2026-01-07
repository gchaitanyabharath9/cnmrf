# IP Ownership & Protection Guide

## 1. Ownership & Attribution

While CNMRF is an open-source framework, protecting Intellectual Property (IP) and ensuring proper attribution is critical for governance.

### Standard Copyright Header
All source files should include:
```
Copyright [Year] [Owner/Organization]. Licensed under the Apache License, Version 2.0.
```

### NOTICE File
Maintain a `NOTICE` file in the root directory listing:
*   The primary copyright owner.
*   Third-party libraries used and their licenses.

## 2. What to Keep Private (Do Not Commit)

*   **Secrets:** API Keys, Passwords, Private Certificates.
*   **Internal Identifiers:** Customer Names, Account Numbers, Real IP addresses.
*   **Internal Docs:** Topology diagrams with specific server names/IPs.

## 3. Contribution Policy

*   **Internal:** All team members may contribute via Pull Request.
*   **External:** External contributors must sign a Contributor License Agreement (CLA) if required by the organization (Optional).

## 4. Evidence of Ownership (Provenance)

To proving ownership later (e.g., for audits or patent defense):
*   **Git History:** Do not squash merge history that destroys authorship.
*   **Release Tags:** Cryptographically sign tags (GPG).
*   **SBOM:** Generate a Software Bill of Materials for every release.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

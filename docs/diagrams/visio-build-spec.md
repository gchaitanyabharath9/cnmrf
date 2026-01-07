# Visio Build Specifications

Use these settings to create compliant diagrams in Microsoft Visio.

## 1. Page Setup
*   **Size:** Widescreen (16:9) or A3 Landscape.
*   **Grid:** Visible, snap-to-grid enabled.

## 2. Standard Layers
*   **L0_Background:** Title block, Copyright, Version, Classification (e.g., "Internal Use").
*   **L1_Network:** Zone containers (Internet -> DMZ -> Application -> Data).
*   **L2_Runtime:** Software components (Gateways, Pods, Databases).
*   **L3_Trust:** Security boundaries (Red dotted lines) indicating mTLS/Auth checks.

## 3. Stencils (Stock Visio)
*   **Containers:** "Rectangular Container" for Networks/Zones.
*   **Components:** "Software/Button" or "UML Component" for services.
*   **Databases:** "Database" or "Cylinder" for storage.
*   **Connectors:** "Dynamic connector" (Right-angle).

## 4. Connector Rules
*   **Solid Line:** Synchronous Call (HTTP/gRPC).
*   **Dashed Line:** Asynchronous Event (Kafka) or Dependency (Config).
*   **Arrow Head:** Points to the *dependee* (called service).

## 5. Exports
*   Always export as PDF (Vector) for documents.
*   Export as PNG (300dpi) for Wiki/Markdown embedding.

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

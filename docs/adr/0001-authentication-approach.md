# ADR-0001: Authentication Approach for Microservices

**Status:** Accepted  
**Date:** 2026-01-06  
**Decision Makers:** CNMRF Architecture Team  

## Context

Microservices in a cloud-native architecture require a standardized authentication mechanism that:

- Works across multiple services without coupling
- Supports both service-to-service and user-to-service authentication
- Integrates with Kubernetes-native security features
- Remains platform-neutral (works on EKS, AKS, GKE, OpenShift)
- Aligns with zero-trust security principles

Current challenges:
- Services need to verify caller identity without shared session state
- Different authentication needs for internal vs. external traffic
- Must support both synchronous (REST) and asynchronous (messaging) patterns
- Should not introduce vendor lock-in

## Decision

We will adopt **JWT (JSON Web Tokens)** as the primary authentication mechanism with the following approach:

### For User-to-Service Authentication

1. **OAuth 2.0 / OIDC** for user authentication
   - External identity provider (e.g., Keycloak, Auth0, cloud IAM)
   - JWT tokens issued upon successful authentication
   - Tokens contain user identity and claims

2. **API Gateway / Ingress** validates tokens at the edge
   - Centralized token validation
   - Invalid tokens rejected before reaching services
   - Valid tokens forwarded to services

3. **Services** extract identity from validated JWT
   - No additional validation required (trust the gateway)
   - Extract user context for authorization decisions
   - Log user identity for audit trails

### For Service-to-Service Authentication

1. **Kubernetes Service Accounts** with projected tokens
   - Each service has a dedicated ServiceAccount
   - Kubernetes issues short-lived JWT tokens
   - Tokens automatically rotated

2. **Optional: Service Mesh** for mTLS
   - Mutual TLS for encrypted, authenticated communication
   - Automatic certificate management
   - Not required for baseline implementation

### Token Structure

```json
{
  "sub": "user-id-or-service-account",
  "iss": "https://identity-provider",
  "aud": "service-name",
  "exp": 1704567890,
  "iat": 1704564290,
  "roles": ["user", "admin"],
  "scope": ["read", "write"]
}
```

## Consequences

### Positive Consequences

- **Stateless:** No session storage required; services remain stateless
- **Scalable:** Tokens can be validated independently by each service
- **Standard:** JWT is an industry standard with broad library support
- **Platform-Neutral:** Works across all Kubernetes distributions
- **Flexible:** Supports multiple identity providers
- **Secure:** Cryptographically signed tokens prevent tampering

### Negative Consequences

- **Token Revocation:** JWTs cannot be easily revoked before expiration
  - **Mitigation:** Use short token lifetimes (15 minutes) with refresh tokens
- **Token Size:** JWTs can be large if many claims are included
  - **Mitigation:** Keep claims minimal; use token introspection for detailed info
- **Clock Skew:** Token validation depends on synchronized clocks
  - **Mitigation:** Use NTP; allow small clock skew tolerance (5 minutes)

### Neutral Consequences

- Services must include JWT validation libraries
- Identity provider becomes a critical dependency
- Token expiration requires refresh token flow

## Alternatives Considered

### Alternative 1: API Keys

**Description:**  
Static API keys passed in headers for authentication

**Pros:**
- Simple to implement
- No external dependencies

**Cons:**
- Difficult to rotate securely
- No expiration mechanism
- No user context or claims
- Shared secrets are security risk

**Reason for Rejection:**  
API keys do not support user context, expiration, or secure rotation—critical for cloud-native systems.

### Alternative 2: Session-Based Authentication

**Description:**  
Server-side sessions stored in Redis or database

**Pros:**
- Easy revocation
- Familiar pattern

**Cons:**
- Requires shared session store (introduces coupling)
- Not stateless; impacts scalability
- Session store becomes single point of failure
- Violates 12-factor app principles

**Reason for Rejection:**  
Session-based auth introduces state and coupling, contradicting cloud-native principles.

### Alternative 3: mTLS Only

**Description:**  
Mutual TLS for all authentication (no JWTs)

**Pros:**
- Strong cryptographic authentication
- Encrypted communication

**Cons:**
- Complex certificate management
- Difficult to implement user authentication (only service-to-service)
- Requires service mesh or manual certificate handling
- No user claims or context

**Reason for Rejection:**  
mTLS is excellent for service-to-service but doesn't address user authentication. We adopt mTLS as **optional** for enhanced security.

## Implementation Notes

### Spring Boot Implementation

```java
// Add dependency: spring-boot-starter-oauth2-resource-server
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/health/**", "/metrics").permitAll()
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt());
        return http.build();
    }
}
```

### .NET Implementation

```csharp
// Add package: Microsoft.AspNetCore.Authentication.JwtBearer
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = "https://identity-provider";
        options.Audience = "service-name";
    });

app.UseAuthentication();
app.UseAuthorization();
```

### Kubernetes ServiceAccount Token

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service
---
apiVersion: v1
kind: Pod
metadata:
  name: my-service
spec:
  serviceAccountName: my-service
  containers:
  - name: app
    image: my-service:latest
    volumeMounts:
    - name: token
      mountPath: /var/run/secrets/kubernetes.io/serviceaccount
  volumes:
  - name: token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 3600
```

**Timeline:**  
Implement in all service templates immediately

**Dependencies:**
- Identity provider (Keycloak, Auth0, or cloud IAM)
- JWT validation libraries (Spring Security, .NET JwtBearer)

## Validation

Success metrics:

- ✅ All services validate JWTs correctly
- ✅ Invalid tokens are rejected with 401 Unauthorized
- ✅ User context is extracted and logged
- ✅ Service-to-service calls use Kubernetes ServiceAccount tokens
- ✅ No hardcoded secrets or API keys

**Review Date:** 2026-07-06 (6 months)

## References

- [RFC 7519: JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [OAuth 2.0 RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
- [OpenID Connect](https://openid.net/connect/)
- [Kubernetes Service Account Tokens](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [CNMRF Security Baseline](../security/security-baseline.md)

## Notes

- For services requiring higher security, enable mTLS via service mesh (Istio, Linkerd)
- Token refresh flow should be implemented in client applications
- Consider token introspection endpoint for real-time validation if revocation is critical

---

Copyright 2026 Chaitanya Bharath Gopu. Licensed under the Apache License, Version 2.0.

# 🛠 Incident Report: Application & Infrastructure Issues

**Incident Date:** 27/11/2025

**Reported By:** NURUN ISLAM NILOY

**Affected Systems:** Application pods, Kubernetes cluster, Docker images, Terraform-managed infrastructure

---

## 1️⃣ Summary

During recent deployment and testing of the application, several critical issues were identified that affected **application stability, performance, and infrastructure reliability**. The main problems included **memory leaks, latency spikes, readiness probe failures, autoscaling misconfigurations, sidecar-induced network instability, and Docker image inefficiencies**.

A coordinated set of fixes was applied across the **application code, Dockerfile, Kubernetes manifests, HPA configuration, network policies, and monitoring setup**, restoring normal operations and improving overall system resilience.

---

## 2️⃣ Impact

* **Application Performance:**

  * Latency increased due to `time.Sleep` calls and faulty endpoint handlers.
  * Counter inconsistencies under concurrent requests caused incorrect responses.

* **Infrastructure & Kubernetes:**

  * Pods failed readiness probes due to incorrect port configuration.
  * HPA did not scale dynamically, leading to potential resource underutilization.
  * Network instability from sidecars caused **20% request drops, 3-second timeouts, and 504 Gateway errors**.

* **Deployment & Security:**

  * Docker images ran as root and lacked CA certificates.
  * Binary copy paths were incorrect, causing runtime failures.

**Overall Business Impact:** Temporary unavailability of application endpoints, reduced performance, and increased error rates.

---

## 3️⃣ Root Cause

| Category          | Root Cause                                                                                                                                                                                       |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Application       | Memory leak and race conditions in variable handling; latency introduced by unnecessary sleep calls; faulty `/healthz` handler; counter read outside lock leading to concurrency inconsistencies |
| Dockerfile        | Missing CA certificates, wrong binary path, incorrect exposed port, no non-root user, inefficient layer caching                                                                                  |
| Kubernetes        | Incorrect `containerPort` and readiness probe ports; readiness probe intervals too short                                                                                                         |
| HPA               | Static CPU value (`500m`) prevented autoscaling based on actual load                                                                                                                             |
| Network & Sidecar | Misconfigured network policies, missing labels; sidecar induced request drops and timeouts                                                                                                       |

---

## 4️⃣ Timeline

| Time | Event                                                                                |
| ---- | ------------------------------------------------------------------------------------ |
| T0   | Deployment initiated                                                                 |
| T1   | Initial errors observed: readiness probe failures and slow responses                 |
| T2   | Investigation revealed application memory leak, latency issues, and faulty endpoints |
| T3   | Dockerfile and image issues identified (CA certs, binary path, root user)            |
| T4   | Kubernetes manifests updated (ports, readiness probe)                                |
| T5   | HPA misconfiguration corrected; autoscaling validated                                |
| T6   | Network and sidecar issues fixed; services and network policies validated            |
| T7   | Monitoring stack deployed (Grafana Loki, Prometheus, Promtail)                       |
| T8   | Verification completed; normal operations restored                                   |

---

## 5️⃣ Fixes Applied

### Application

* Removed or fixed memory-leaking variables and race conditions using locks/mutexes.
* Removed unnecessary `time.Sleep` calls.
* Corrected `/healthz` endpoint handler.
* Ensured counters are read consistently under concurrency.

### Dockerfile

* Updated to `golang:1.24` with multi-stage build.
* Installed CA certificates, corrected binary path, exposed correct port (8080), and created non-root user.
* Optimized build layers for caching efficiency.

### Kubernetes

* Updated `containerPort` and readiness probe to 8080.
* Increased readiness probe intervals.

### HPA

* Switched to `type: Utilization` with `averageUtilization: 50`.
* Validated scaling under load.

### Network & Sidecar

* Corrected network policy configurations and labels.
* Fixed service communication with main application.

### Monitoring

* Deployed Grafana Loki on EC2.
* Promtail and Prometheus deployed on the cluster for centralized logging and metrics.

---

## 6️⃣ Preventive Actions

* Implement **code reviews** focusing on concurrency, memory handling, and endpoint validation.
* Establish **Dockerfile best practices**: non-root users, CA certificates, correct port exposure.
* Ensure **Kubernetes manifests are validated** before deployment, including container ports and probes.
* Adopt **HPA with utilization-based metrics** by default.
* Implement **network policy and sidecar testing** in staging.
* Maintain `.dockerignore` to reduce unnecessary files in builds.

---

## 7️⃣ Monitoring & Alerting Improvements

* Centralized logging with **Grafana Loki** for real-time log aggregation.
* **Prometheus metrics** integrated with application and Kubernetes cluster.
* Alerts configured for:

  * Pod readiness failures
  * High memory usage or leaks
  * Latency spikes
  * Network errors (timeouts, 504s)
* Automated scaling verified through HPA utilization metrics.


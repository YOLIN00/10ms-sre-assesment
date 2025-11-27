
---

# Incident Report

**Date:** 25/11/2025

**Application:** Python Flask App

**Environment:** KIND (local Kubernetes cluster)

---

## 1. Summary

During recent deployment, the application experienced readiness and performance issues. Pods were not entering the ready state, and the `/healthz` endpoint returned errors. Additionally, the service exhibited unnecessary slowness due to artificial delays in the application code.

---

## 2. Impact

* Application pods were not marked as ready, causing temporary unavailability of endpoints.
* Health checks (`/healthz`) failed, triggering false alarms in monitoring systems.
* Requests experienced slower response times due to intentional delays in the code.

---

## 3. Root Cause

1. **Application Layer:**

   * `/healthz` endpoint returned HTTP 500 due to a bug in the code.
   * `/` endpoint handler introduced artificial delay via `time.sleep(random.randint(3,8))`.

2. **Kubernetes Deployment:**


   * Pods were initially configured with the incorrect port value (80) in two places: the `containerPort` and the  readiness  probe. This mismatch caused the readiness probes to fail. To resolve the issue, both the `containerPort` and the readiness probe port were updated to match the application’s listening port (8080).


---

## 4. Actions Taken / Fixes

1. **Application:**

   * Fixed `/healthz` endpoint to return HTTP 200.
   * Removed the `time.sleep` delay to improve service responsiveness.
   * Updated Flask version for stability.

2. **Dockerfile:**

   * Corrected exposed port to `8080`.
   * Replaced slim image with Alpine to reduce image size.
   * Optimized layer caching by copying `requirements.txt` first and installing dependencies before adding the application code.

3. **Kubernetes Deployment:**

   * Updated `containerPort` and `readiness probe port` to `8080`.
   * Verified pods are in ready state.
   * Confirmed service functionality using `kubectl port-forward`.
   * Added **resource requests and limits** for CPU and memory.

---

## 5. Preventive Actions

* Implement automated testing for health endpoints before deployment.
* Ensure Dockerfile and deployment YAML ports are aligned with application code.
* Remove artificial delays from production code.
* Use resource requests and limits to prevent pod starvation.
* Maintain proper image caching strategies to speed up builds.

---
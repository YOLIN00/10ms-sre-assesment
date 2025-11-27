# 📝 Application & Infrastructure Documentation

## 1️⃣ Application Fixes

### 🔹 Memory Leak & Race Condition

**Problem:**
A variable named `leak` was causing memory leaks and race conditions.

**Solution:**

* Temporarily commented the problematic code.
* Permanent fix: use locks/mutexes and allocate fixed-size memory for critical sections to prevent race conditions.


### 🔹 Latency Issue

**Problem:**
`time.Sleep(2 * time.Second)` introduced unnecessary latency.

**Solution:**

* Removed the sleep call to improve responsiveness.


### 🔹 Faulty `/healthz` Endpoint

**Problem:**
The `/healthz` endpoint contained faulty code affecting health checks.

**Solution:**

* Corrected the code and ensured proper endpoint functionality.


### 🔹 Counter Inconsistency Under Concurrency

**Problem:**
Counter variable incremented inside a lock but read outside, causing inconsistent values under concurrent access.

**Solution:**

* Store counter value in a local variable immediately after incrementing inside the lock to ensure consistency.


## 2️⃣ Dockerfile Enhancements

**🚨 Issues Identified:**

* Missing CA certificates → HTTPS connections failed.
* Incorrect binary path (`/build/app/server`) → runtime errors.
* Exposed port (80) did not match application’s listening port.
* No non-root user → security risk.
* Inefficient build layers → increased image size and build time.

**💡 Solutions Implemented:**

* Base image updated to `golang:1.24` with multi-stage build.
* Optimized layer caching by copying `go.mod` before full app code.
* Built static binary (`CGO_ENABLED=0`) for Alpine compatibility.
* Installed CA certificates and created a non-root user (`appuser`).
* Corrected binary path to `/build/server` and exposed port 8080.

**✅ Outcome:**
The image is now **secure, lean, functional, and production-ready**.


## 3️⃣ Kubernetes Fixes

**🚨 Problems:**

* Pods configured with incorrect port (80) in `containerPort` and readiness probe → probe failures.
* Readiness probe interval too short → premature failures.

**💡 Solutions:**

* Updated both `containerPort` and readiness probe to 8080.
* Increased probe interval and initial delay.
* Loaded image into kIND cluster using `kind load`.

**✅ Outcome:**
Pods now report as ready reliably.


## 4️⃣ Horizontal Pod Autoscaler (HPA)

**🚨 Problem:**
HPA used fixed CPU (`500m`), preventing dynamic scaling.

**💡 Solution:**

* Updated HPA to **type: Utilization** with `averageUtilization: 50`.
* Validated autoscaling by generating CPU load inside the pod using `kubectl exec` and running a continuous loop `while :; do :; done` to observe pods scaling up and down. As non-root user can't download stress package.

**✅ Outcome:**
Autoscaling now works dynamically, maintaining ~50% CPU utilization.


## 5️⃣ Network & Sidecar Issues
**Observations:**

 Please check the assumptions section in the README.md file.

* Network policies control traffic **between pods**, not containers within the same pod.
* Labels were missing, causing misconfigured policies.
* Sidecar issues caused:

  * Random 20% request drops
  * 3-second timeouts
  * 504 Gateway errors

**💡 Solutions:**

* Fixed sidecar 
* Service.yaml files are fixed to communicate correctly with the main application.


## 6️⃣ Terraform

**💡 Details:**

* All Terraform configurations and solutions are in the `iac/solution` folder.


## 7️⃣ Monitoring Setup (Bonus)

**Architecture:**

* **Grafana Loki** → Deployed on a separate EC2 instance.
* **Promtail & Prometheus** → Deployed on Kubernetes cluster for centralized logging and metrics.


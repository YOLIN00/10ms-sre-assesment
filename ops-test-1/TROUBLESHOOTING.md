### 1. Cause of Readiness Probe Failures

The readiness probe was failing because the Kubernetes deployment had an incorrect `containerPort` value configured. As a result, the probe could not receive a response from the application, marking the pod as “not ready.” Once the port was updated to match the application’s listening port (`8080`), the readiness probe began functioning correctly.

**Note:** The `EXPOSE` directive in the Dockerfile is purely declarative and does not impact runtime connectivity. Therefore, an incorrect port in the Dockerfile did not contribute to the readiness probe failure.

---

### 2. Cause of Service Slowness

The service performance was negatively impacted by the line:

```python
time.sleep(random.randint(3,8))
```

This introduced artificial delays in request processing, leading to slower responses.

---

### 3. Probable Root Causes

1. **Incorrect `containerPort` in Kubernetes deployment** – This caused the readiness probe to fail, resulting in pods being unavailable to the service.
2. **Incorrect port configuration in the readiness probe** – Reinforced the pod’s “not ready” status.
3. **Artificial delay in application code** – The `time.sleep()` call caused unnecessary service slowness.

---

### 4. Permanent Fixes Implemented

1. **Updated Kubernetes Deployment Ports:** All deployment files were corrected to reflect the application’s listening port (`8080`).
2. **Readiness Probe Correction:** The readiness probe was updated to use the correct port, ensuring accurate pod health reporting.
3. **Application Code Optimization:** The `time.sleep(random.randint(3,8))` line was removed to eliminate unnecessary delays.
4. **Dockerfile Optimization:** Ports were updated in the Dockerfile, and image layers were optimized using caching techniques to improve build efficiency. Alpine image used to reduce image size.

---

### 5. Outcome

* Readiness probes now correctly detect pod health.
* Service performance improved due to removal of artificial delays.
* Deployment processes are standardized with correct port configurations and optimized Docker images.

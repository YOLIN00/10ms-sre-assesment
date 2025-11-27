# Monitoring Setup

This folder contains configurations for setting up a monitoring stack using Prometheus, Loki, Grafana, and Promtail. The stack is designed to collect, store, and visualize logs and metrics from a Kubernetes cluster.

## Folder Structure

```
monitoring/
├── docker-compose.yaml  # Docker Compose setup for deploying EC2
├── prometheus.yaml      # Kubernetes manifests for Prometheus
├── promtail.yaml        # Kubernetes manifests for Promtail
```

## Components

### Prometheus
- **Purpose**: Collects metrics from Kubernetes and other targets.
- **Deployment**: Defined in `prometheus.yaml`.
- **Access**:
  - From outside the cluster: `http://<any-node-ip>:30090`
  - From within the cluster: `http://prometheus-internal.monitoring.svc.cluster.local:9090`
- **Configuration**:
  - Scrape configs for Kubernetes nodes, pods, and services.
  - Retention period: 15 days.

### Loki
- **Purpose**: Stores logs collected by Promtail.
- **Deployment**: Defined in `docker-compose.yaml`.
- **Access**: Exposed on port `3100`.

### Grafana
- **Purpose**: Visualizes metrics and logs from Prometheus and Loki.
- **Deployment**: Defined in `docker-compose.yaml`.
- **Access**: Exposed on port `3000`.
- **Default Credentials**:
  - Username: `admin`
  - Password: `admin`

### Promtail
- **Purpose**: Collects logs from Kubernetes pods and sends them to Loki.
- **Deployment**: Defined in `promtail.yaml`.
- **Configuration**:
  - Scrapes all pod logs.
  - Adds labels: `namespace`, `pod`, `container`, `node`.
  - Sends logs to Loki at `http://loki.logging.svc.cluster.local:3100`.

## Usage

### Deploying with Kubernetes
1. **Deploy Promtail**:
   ```bash
   kubectl apply -f promtail.yaml
   ```
2. **Deploy Prometheus**:
   ```bash
   kubectl apply -f prometheus.yaml
   ```
3. **Check Status**:
   ```bash
   kubectl get pods -n logging
   kubectl get pods -n logging
   ```
4. **View Logs**:
   ```bash
   kubectl logs -n logging -l app=promtail
   kubectl logs -n logging -l app=prometheus
   ```

### Deploying with Docker Compose
1. **Start Services**:
   ```bash
   docker-compose up -d
   ```
2. **Access Services**:
   - Grafana: `http://localhost:3000`
   - Loki: `http://localhost:3100`

### Adding Prometheus to Grafana
1. Login to Grafana.
2. Go to **Configuration → Data Sources → Add data source**.
3. Select **Prometheus**.
4. Enter the URL: `http://<k8s-node-ip>:30090`.
5. Click **Save & Test**.

## Useful PromQL Queries

### CPU Usage by Pod
```promql
sum(rate(container_cpu_usage_seconds_total{pod!="", namespace!=""}[5m])) by (pod, namespace) * 100
```

### Memory Usage by Pod (in MB)
```promql
sum(container_memory_working_set_bytes{pod!="", namespace!=""}) by (pod, namespace) / 1024 / 1024
```

### Pod Count by Namespace
```promql
count(kube_pod_info) by (namespace)
```

### Top 10 CPU Consuming Pods
```promql
topk(10, sum(rate(container_cpu_usage_seconds_total{pod!=""}[5m])) by (pod, namespace))
```

## Notes
- Ensure the `k8s metrics server` is enabled before deploying Prometheus.
- Update the Loki URL in the Promtail ConfigMap as Loki is hosted externally.
- Use persistent storage for Prometheus and Loki in production environments.

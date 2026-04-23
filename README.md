# kubernetes-event-exporter

Custom Docker image and Helm chart for [resmoio/kubernetes-event-exporter](https://github.com/resmoio/kubernetes-event-exporter), published to GHCR.

## Image

```
ghcr.io/obezpalko/kubernetes-event-exporter:<version>
```

Built from the upstream source with a minimal `golang:alpine` builder and a `distroless/static:nonroot` final image. Multi-arch: `linux/amd64` and `linux/arm64`.

## Helm chart

```
oci://ghcr.io/obezpalko/charts/kubernetes-event-exporter
```

### Install

```sh
helm install kubernetes-event-exporter \
  oci://ghcr.io/obezpalko/charts/kubernetes-event-exporter \
  --namespace monitoring --create-namespace \
  -f values.yaml
```

### Key values

| Value | Default | Description |
|-------|---------|-------------|
| `image.tag` | `""` (uses chart `appVersion`) | Image tag override |
| `config.logLevel` | `warn` | Log level |
| `config.logFormat` | `json` | Log format |
| `config.receivers` | stdout | List of receivers |
| `config.route` | match-all to stdout | Routing rules |
| `rbac.create` | `true` | Create ClusterRole and ClusterRoleBinding |
| `serviceAccount.create` | `true` | Create ServiceAccount |
| `metrics.enabled` | `true` | Expose Prometheus metrics on port 2112 |
| `metrics.serviceMonitor.enabled` | `false` | Create Prometheus Operator ServiceMonitor |

See [chart/values.yaml](chart/values.yaml) for the full list.

### Example config

```yaml
config:
  logLevel: info
  logFormat: json
  receivers:
    - name: stdout
      stdout: {}
  route:
    routes:
      - match:
          - receiver: stdout
```

## Automation

| Workflow | Trigger | Description |
|----------|---------|-------------|
| `sync.yaml` | Manual (`workflow_dispatch`) | Check for new upstream release, build image, scan for CVEs, update chart |
| `docker.yaml` | Git tag `v*` or `workflow_call` | Build and push multi-arch image to GHCR |
| `chart.yaml` | Push to `master` touching `chart/**` or `workflow_call` | Package and push Helm chart to GHCR |

To pick up a new upstream release, run the **Sync upstream releases** workflow manually from the Actions tab. Use the **Force build** option to rebuild without a new upstream tag.

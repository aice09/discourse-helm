# discourse-helm

A Helm chart repository for deploying [Discourse](https://www.discourse.org/) on Kubernetes.

## Repository layout

- `charts/discourse` contains the Helm chart.
- `examples` contains values files for common deployment profiles.
- `docs` contains operator documentation.
- `hack` and `scripts` contain local development helpers.
- `tests` is reserved for chart tests and rendered fixture coverage.

## Versions

The chart package version is `0.1.0`; the default Discourse app/image version is `2026.7.0-latest`. Helm `--version` selects the chart package version from a repository, while the Discourse app image is changed with `--set image.tag=...` or a values file. See `docs/versioning.md` for homelab validation steps before publishing to Artifactory.

## Quick start

```sh
helm install discourse ./charts/discourse -f examples/minimal/values.yaml
```

Render manifests locally:

```sh
make template
```

Run chart checks:

```sh
make test
```

## Production workloads

The chart renders the web Deployment plus production support workloads for Discourse:

- a dedicated Sidekiq Deployment for background jobs, email delivery, search indexing, plugin jobs, and scheduled work;
- pre-install/pre-upgrade migration Job support and an optional startup Job;
- optional PodDisruptionBudget, NetworkPolicy, ServiceMonitor, RBAC, and CronJob templates for operational hardening.

See `charts/discourse/values.yaml` for the corresponding `sidekiq`, `migrationJob`, `startupJob`, `podDisruptionBudget`, `networkPolicy`, `serviceMonitor`, `rbac`, and `cronJobs` settings.

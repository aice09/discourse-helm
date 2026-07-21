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

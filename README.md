# discourse-helm

A Helm chart repository for deploying [Discourse](https://www.discourse.org/) on Kubernetes.

## Repository layout

- `charts/discourse` contains the Helm chart.
- `examples` contains values files for common deployment profiles.
- `docs` contains operator documentation.
- `hack` and `scripts` contain local development helpers.
- `tests` is reserved for chart tests and rendered fixture coverage.

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

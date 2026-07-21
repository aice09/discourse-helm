# Installation

Install the chart with Helm:

```sh
helm install discourse ./charts/discourse -f examples/minimal/values.yaml
```

For production, start from `examples/production/values.yaml` and provide real SMTP, database, Redis, ingress, and object storage settings.

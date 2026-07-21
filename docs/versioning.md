# Versioning and local validation

## Chart version vs Discourse app version

This repository tracks two different versions:

- `Chart.yaml.version` is the Helm chart package version. Helm uses this when you run `helm install --version x.y.z` from a chart repository such as Artifactory.
- `Chart.yaml.appVersion` documents the default Discourse application/image version represented by the chart.

The initial chart uses chart version `0.1.0` and app version `2026.7.0-latest`.

> Note: the default image is `discourse/discourse`. Discourse currently describes this image as experimental rather than production-ready, so treat this chart as a homelab/staging starting point until you have validated your operational model.

## Selecting versions at install time

`helm install --version x.y.z` selects the chart package version; it does **not** override the Discourse app image tag.

Use `--set image.tag=...` or a values file to test a different Discourse image tag:

```sh
helm upgrade --install discourse oci://registry.example.com/helm/discourse \
  --version 0.1.0 \
  --namespace discourse \
  --create-namespace \
  --set image.tag=2026.7.0-latest \
  -f my-values.yaml
```

For local, unpackaged chart testing, use the chart directory instead of a repository reference:

```sh
helm upgrade --install discourse ./charts/discourse \
  --namespace discourse \
  --create-namespace \
  -f examples/minimal/values.yaml
```

## Homelab test plan before publishing to Artifactory

1. Create a namespace:

   ```sh
   kubectl create namespace discourse
   ```

2. Provision external dependencies. For PostgreSQL with CloudNativePG, create a cluster and note the generated application secret and the `*-rw` service name. For Redis, deploy your preferred Redis chart/operator and note the service and password secret.

3. Create a local values file, for example `my-values.yaml`:

   ```yaml
   discourse:
     hostname: discourse.home.arpa
     developerEmails: admin@home.arpa

   postgresql:
     host: discourse-postgres-rw.database.svc.cluster.local
     database: app
     username: app
     existingSecret: discourse-postgres-app
     usernameKey: username
     passwordKey: password

   redis:
     host: discourse-redis-master.cache.svc.cluster.local
     existingSecret: discourse-redis
     passwordKey: redis-password

   ingress:
     enabled: true
     className: nginx
     hosts:
       - host: discourse.home.arpa
         paths:
           - path: /
             pathType: Prefix
   ```

4. Validate the chart without installing anything:

   ```sh
   helm lint ./charts/discourse
   helm template discourse ./charts/discourse -n discourse -f my-values.yaml > /tmp/discourse.yaml
   kubectl apply --dry-run=server -f /tmp/discourse.yaml
   ```

5. Install into the homelab namespace:

   ```sh
   helm upgrade --install discourse ./charts/discourse \
     --namespace discourse \
     --create-namespace \
     -f my-values.yaml
   ```

6. Watch rollout and inspect failures:

   ```sh
   kubectl -n discourse rollout status deploy/discourse-discourse
   kubectl -n discourse get pods,svc,ingress,pvc
   kubectl -n discourse logs deploy/discourse-discourse --tail=200
   kubectl -n discourse describe pod -l app.kubernetes.io/name=discourse
   ```

7. If the test is successful, package the chart for Artifactory:

   ```sh
   helm package charts/discourse --destination dist
   helm push dist/discourse-0.1.0.tgz oci://artifactory.example.com/helm
   ```

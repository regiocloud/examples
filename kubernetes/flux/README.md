# Flux bootstrap for Github

To deploy flux, you need to set it up locally:

```shell
curl -s https://fluxcd.io/install.sh | sudo bash
```

Next you need to create a Github token on your Github Account. Visit https://github.com/settings/tokens and click on `Generate new token (classic)`. You will need the following scopes selected:

- repo
- admin:org
- admin:public_key

Click `Generate token` and copy the secret to a safe place.

You have need to make the token secret for flux known. Set environment variable or just run the command for prompt: `export GITHUB_TOKEN=XYZ`

Once everything has been completed, the cluster can be rolled out quickly:

```bash
flux bootstrap github \
  --owner=regiocloud \
  --repository=examples \
  --branch=main \
  --path=kubernetes/flux/clusters/production
```
As soon as the command has been executed, flux and all components from the path are rolled out on the cluster.

Alternatively, you can also add the following part to the shoot config and save it. The shoot will then reconcile and install flux and the specified repo:

```yaml
...
spec:
  ...
  extensions:
    - type: shoot-flux
      providerConfig:
        apiVersion: flux.extensions.gardener.cloud/v1alpha1
        kind: FluxConfig
        flux:
          version: v2.2.3
          registry: ghcr.io/fluxcd
          namespace: flux-system
        source:
          template:
            apiVersion: source.toolkit.fluxcd.io/v1
            kind: GitRepository
            spec:
              ref:
                branch: main
              url: https://github.com/regiocloud/examples
        kustomization:
          template:
            apiVersion: kustomize.toolkit.fluxcd.io/v1
            kind: Kustomization
            spec:
              path: kubernetes/flux/clusters/production
```

To get the Pulbic IP, you can run the following command and see the Public IP in the `External-IP` column:

``` shell
kubectl get svc --namespace ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   100.91.59.59    81.163.192.99   80:32293/TCP,443:31431/TCP   105m
ingress-nginx-controller-admission   ClusterIP      100.89.56.175   <none>          443/TCP                      105m
```

In `apps/production/nginx-values.yaml`, add the public ip to the domain `nginx-flux.<IP>.nip.io`. E.g. `nginx-flux.81.163.192.99.nip.io` where `81.163.192.99` is the external ip address of the resource of type `LoadBalancer`.

If changes are made to the repo, these are applied to the cluster after a short time. Depending on how the interval is set.

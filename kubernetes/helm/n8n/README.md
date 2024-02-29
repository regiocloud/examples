# n8n setup with postgres

First setup an ingress-nginx and cert-manager to have the possibility to reach your
apps from the outside:

```shell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade -i ingress-nginx --create-namespace -n ingress-nginx \
  -f ingress-values.yaml ingress-nginx/ingress-nginx

helm repo add jetstack https://charts.jetstack.io
helm upgrade -i cert-manager --create-namespace -n cert-manager \
  --set installCRDs=true jetstack/cert-manager
kubectl apply -f cert-issuer.yaml
```

When the public IP is available, set a subdomain that point to that IP.

``` shell
kubectl get svc --namespace ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   100.91.59.59    81.163.192.99   80:32293/TCP,443:31431/TCP   105m
ingress-nginx-controller-admission   ClusterIP      100.89.56.175   <none>          443/TCP                      105m
```

In `n8n-values.yaml`, the domain `n8n.example.regio.digital` is set. Replace this accordingly.
For a test, e.g. with `n8n.81.163.192.99.nip.io`. `81.163.192.99` is the external ip address of
the resource of type `LoadBalancer`.

Now you can setup the postgres chart and the app n8n, a Workflow Automation Tool:

```shell
# Postgres https://artifacthub.io/packages/helm/bitnami/postgresql
helm upgrade -i postgresql -f postgresql-values.yaml --create-namespace -n n8n \
  oci://registry-1.docker.io/bitnamicharts/postgresql --version 14.2.3

# n8n https://artifacthub.io/packages/helm/open-8gears/n8n
helm upgrade -i n8n -f n8n-values.yaml --create-namespace -n n8n \
  oci://8gears.container-registry.com/library/n8n --version 0.21.0
```

When finished, you can open the subdomain in a browser and setup the admin user in n8n.

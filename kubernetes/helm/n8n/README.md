# n8n setup with postgres

First setup an ingress-nginx and cert-manager to have the possibility to reach your apps from the outside:
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

Now you can setup the postgres chart and the app n8n, a Workflow Automation Tool:
```shell
# Postgres https://artifacthub.io/packages/helm/bitnami/postgresql
helm upgrade -i postgresql -f postgresql-values.yaml --create-namespace -n n8n oci://registry-1.docker.io/bitnamicharts/postgresql --version 14.2.3

# n8n https://artifacthub.io/packages/helm/open-8gears/n8n
helm upgrade -i n8n -f n8n-values.yaml --create-namespace -n n8n oci://8gears.container-registry.com/library/n8n --version 0.21.0
```

When finished, you can open the subdomain in a browser and setup the admin user in n8n.

# cnpg postgres operator setup

Setup the postgres operator CloudNativePG and initalize a db:

```shell
# CNPG (Postgres)
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm upgrade -i cnpg --create-namespace -n cnpg-system cnpg/cloudnative-pg

kubectl apply -f superuser-secret.yaml
kubectl apply -f database-secret.yaml
kubectl apply -f postgresql-cluster.yaml
```

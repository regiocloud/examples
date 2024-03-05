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

As soon as the command has been executed, flux and all components from the path are rolled out on the cluster. A deploy key is created in the repo itself so that flux can work with the repo via SSH in the future.

If changes are made to the repo, these are applied to the cluster after a short time. Depending on how the interval is set.

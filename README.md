# tanka-example
Example for using Grafana Tanka for kubernetes deployments that sets up the following resources in the respective Tanka environments.

### Infrastructure
- ingress-nginx
- cert-manager

### Monitoring
- Grafana
- InfluxDB
- Prometheus

### Application
- podinfo

## Setup

### Register pre-commit hook

```shell
ln -s $PWD/pre-commit.sh .git/hooks/pre-commit
```

### Getting a Development Shell

If you're using nix flakes:

```shell
nix develop
```

Otherwise, install the utilities listed in `flake.nix` manually.

## Applying Changes

First, you need to edit the `spec.json` files to your appropriate API server. Then, you should be able to run the following

```shell
tk apply environments/infrastructure
# The infrastructure environments needs to be deployed twice on the first attempt
# since it installs and references cert-manager CRDs. It's probably simple enough
# to fix this with an additional environment
tk apply environments/infrastructure
tk apply environments/monitoring
tk apply environments/application
```

Note that the infrastructure environment should be applied first since the default environment depends on it.
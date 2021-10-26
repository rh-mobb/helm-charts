# Helm Chart to set up federated Prometheus on ROSA

## Prerequisites

* A ROSA cluster
* Helm CLI

## Set environment variables

Set the following environment variables

```
export PROM_NAMESPACE=custom-prometheus
```

## Install Operators

This relies on the Prometheus and Grafana operators, you can deploy them from the OpenShift Console, or via the script found in `./files/deploy-operators.sh`.

```bash
./files/deploy-operators.sh
```

## Deploy the Helm Chart

```
helm install -n $PROM_NAMESPACE federated .
```
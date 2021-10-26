# Helm Chart to set up federated Prometheus on ROSA

This Helm chart will deploy a Prometheus server on ROSA and configure it to slurp in metrics from the cluster prometheus. It will also deploy Grafana and a set of graphs to duplicate the cluster dashboards as well as an example alert to show how to send alerts to a slack channel.

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

Run one of the following:

    ```bash
    curl -sSL https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/rosa-federated-prometheus/files/deploy-operators.sh | bash
    ```

    or if you've cloned down this repository

    ```bash
    ./files/deploy-operators.sh
    ```

## Deploy the Helm Chart

1. Add This Repository to your Helm

    ```bash
    helm repo add mobb https://rh-mobb.github.io/helm-charts/
    ```

1. Update your Repository

    ```bash
    helm repo update
    ```

1. Install a Chart

    ```bash
    helm install -n my-prometheus mobb/rosa-federated-prometheus
    ```

1. Find the Routes

    ```bash
    kubectl get routes
    ```

1. Access Grafana and Prometheus using the routes from above.
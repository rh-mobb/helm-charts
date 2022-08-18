# Helm Chart to set up federated Prometheus on ROSA

This Helm chart will deploy a Prometheus server on ROSA and configure it to slurp in metrics from the cluster prometheus. It will also deploy Grafana and a set of graphs to duplicate the cluster dashboards as well as an example alert to show how to send alerts to a slack channel.

## Prerequisites

* A ROSA cluster
* Helm CLI

## Prepare Environment

1. Set the following environment variables

    ```bash
    export NAMESPACE=federated-metrics
    ```

1. Create the namespace

    ```bash
    oc new-project $NAMESPACE
    ```

1. Add the MOBB chart repository to your Helm

    ```bash
    helm repo add mobb https://rh-mobb.github.io/helm-charts/
    ```

1. Update your repositories

    ```bash
    helm repo update
    ```

1. Use the `mobb/operatorhub` chart to deploy the needed operators

    ```bash
    helm upgrade -n $NAMESPACE federated-metrics-operators \
      mobb/operatorhub --install \
      --values https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/rosa-federated-prometheus/files/operatorhub.yaml
    ```

1. Wait until the two operators are running

    ```bash
    watch kubectl get pods -n $NAMESPACE
    ```

    ```
    NAME                                                   READY   STATUS    RESTARTS   AGE
    grafana-operator-controller-manager-775f8d98c9-822h7   2/2     Running   0          7m33s
    operatorhubio-dtb2v                                    1/1     Running   0          8m32s
    prometheus-operator-5cb6844699-t7wfd                   1/1     Running   0          7m29s
    ```

## Deploy the Helm Chart



1. Install a Chart

    ```bash
    helm upgrade --install -n $NAMESPACE monitoring \
      mobb/rosa-federated-prometheus
    ```

1. Find the Routes

    ```bash
    kubectl get routes
    ```

1. Access Grafana and Prometheus using the routes from above.

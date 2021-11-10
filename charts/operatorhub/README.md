# OperatorHub Chart

This Helm Chart is designed to help you deploy Operators to Kubernetes using OperatorHub (as deployed by default in OpenShift Clusters)

It will deploy a set of CatalogSources, OperatorGroups, and Subscriptions which will trigger OperatorHub to deploy the requested Operator.

See the defaults in `./values.yaml` for an example installing the Grafana Operator.

## Usage

1. Add This Repository to your Helm

    ```bash
    helm repo add mobb https://rh-mobb.github.io/helm-charts/
    ```

1. Update your Repository

    ```bash
    helm repo update && helm dependency update
    ```

1. Install a Chart

    ```bash
    helm install operators mobb/operatorhub
    ```
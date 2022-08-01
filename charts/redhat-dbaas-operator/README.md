# Helm Chart to deploy the Red Hat DBAAS Operator

This Helm chart will deploy the Red Hat DBAAS Operator.

## Prerequisites

* A ROSA 4.10 cluster
* Helm CLI

## Prepare Environment

1. Add the MOBB chart repository to your Helm

    ```bash
    helm repo add mobb https://rh-mobb.github.io/helm-charts/
    ```

1. Update your repositories

    ```bash
    helm repo update
    ```

## Deploy the Helm Chart


1. Use helm to deploy the DBAAS Operator

   ```bash
   helm upgrade --install -n redhat-dbaas-operator dbaas-operator \
      --create-namespace mobb/redhat-dbaas-operator
   ```

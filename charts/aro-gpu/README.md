# Helm Chart to set up GPU nodes on ARO clusters

This Helm chart will deploy GPU nodes on ARO clusters.

## Prerequisites

* An ARO 4.10 cluster
* Helm CLI
* [Azure GPU Quota](https://mobb.ninja/docs/aro/gpu/)

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



1. Install a Chart

    ```bash
    helm upgrade --install -n $NAMESPACE openshift-machine-api \
      gpu mobb/aro-gpu
    ```

1. Wait for the new GPU nodes to be available

    ```bash
    watch oc get machines
    ```


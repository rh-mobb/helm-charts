# Helm Chart to set up MachineAutoScaling on ARO clusters

This Helm chart will set up Machine Auto Scaling on ARO clusters.

## Prerequisites

* An ARO 4.10 cluster
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

By default this chart will set up autoscaling for all existing MachineSets with the same mix/max values. This may be fine for simple use cases but for cases where you have more than the default set of three you should specify the MachineSets you which to configure in the values file (`.Values.machineSets`).

1. Install a Chart

    ```bash
    helm upgrade --install -n openshift-machine-api \
      infra mobb/aro-machine-autoscaler
    ```

1. Wait for the new nodes to be available

    ```bash
    watch oc get machines
    ```


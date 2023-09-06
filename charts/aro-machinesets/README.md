# Helm Chart to set up extra MachineSets on ARO clusters

This Helm chart will set up extra MachineSets on ARO clusters.
The defaults are un-opinionated about the type of nodes.
See [./values.yaml](values.yaml) for configurable options, and how to make the machineset suitable as infra-nodes.


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



1. Install a Chart

    ```bash
    helm upgrade --install -n openshift-machine-api \
      infra mobb/aro-machinesets
    ```

1. Wait for the new nodes to be available

    ```bash
    watch oc get machines
    ```


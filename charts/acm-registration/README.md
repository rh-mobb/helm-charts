# Helm Chart to register OpenShift or Kubernetes clusters with Red Hat Advanced Cluster Manager

This Helm chart will add an OpenShift or Kubernetes cluster to an existing ACM instance. This is done entirely from the ACM Hub side, though it will require a working `kubeconfig` with appropriate credentials to allow ACM to install the `klusterlet` on the managed cluster on your behalf (see instructions below).

The following values **must** be set to run the chart:

- `clusterName`: The name of the managed cluster
- `kubeconfigPath`: The local path to a working `kubeconfig` file

The following values **may** be set or left unset to use defaults:

- `clusterSet`: The name of the clusterset to add the new cluster to, defaults to `default`

In order to run the example `oc` command in the instructions, it will be necessary to get the `oc login` command string from the OpenShift console by logging in and then clicking 'Copy login command' from the drop down where the logged-in username is shown in the top right corner.
## Prerequisites

* An OpenShift cluster running ACM
* Network connectivity between the ACM cluster and the cluster to be added to ACM
* Helm CLI
* `kubectl` or `oc` CLI tools

## Prepare the Environment


1. Add the MOBB chart repository to your Helm

    ```bash
    helm repo add mobb https://rh-mobb.github.io/helm-charts/
    ```

1. Update your repositories

    ```bash
    helm repo update
    ```

1. Get a working kubeconfig for the target cluster to pass as a Secret to Helm

    ```bash
    KUBECONFIG=kube.local <oc login command goes here>
    ```

## Deploy the Helm Chart


1. Install the Chart

    ```bash
    helm upgrade --install --debug my-cluster-acm-registration mobb/acm-registration --set clusterName=my-cluster --set kubeConfig="$(cat <path_to_kubeconfig>)"
    ```

1. Validate that the cluster shows up in ACM

    ```bash
    oc get managedclusters
    ```

1. Validate that the cluster actually registers

    ```bash
    oc describe managedcluster my-cluster
    # Make sure you see values under the 'Status' key
    # Also look for the Kubernetes and OpenShift versions
    ```


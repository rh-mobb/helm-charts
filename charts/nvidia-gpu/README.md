# Helm Chart to set up NVIDIA GPU nodes


## Prerequisites

* An ARO / ROSA cluster
* Helm CLI

## Prepare Environment

1. Create namespaces

    ```bash
    oc create namespace openshift-nfd
    oc create namespace nvidia-gpu-operator
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
    helm upgrade -n nvidia-gpu-operator nvidia-gpu-operator \
      mobb/operatorhub --install \
      --values https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/nvidia-gpu/files/operatorhub.yaml
    ```

1. Wait until the two operators are running

    ```bash
    watch kubectl get pods -n openshift-nfd
    ```

    ```
    NAME                                      READY   STATUS    RESTARTS   AGE
    nfd-controller-manager-7b66c67bd9-rk98w   2/2     Running   0          47s
    ```

    ```bash
    watch kubectl get pods -n nvidia-gpu-operator
    ```

    ```
    kubectl get pods -n nvidia-gpu-operator
    NAME                            READY   STATUS    RESTARTS   AGE
    gpu-operator-5d8cb7dd5f-c4ljk   1/1     Running   0          87s
    ```
## Deploy the Helm Chart

1. Install a Chart

    ```bash
    helm upgrade --install -n nvidia-gpu-operator nvidia-gpu \
      mobb/nvidia-gpu --disable-openapi-validation
    ```

1. Validate the NFD can see the GPU(s)

    ```bash
    oc describe node | egrep 'Roles|pci-10de' | grep -v master
    ```

    You should see output like:

    ```
    Roles:    worker
              feature.node.kubernetes.io/pci-10de.present=true
    ```
1. Verify the GPUs are available on the host

    ```bash
    oc project nvidia-gpu-operator
    for i in $(oc get pod -lopenshift.driver-toolkit=true --no-headers |awk '{print $1}'); do echo $i; oc exec -it $i -- nvidia-smi ; echo -e '\n' ;  done
    ```

# Helm Chart to set up Azure Files StorageClasses on ARO clusters

This Helm chart will deploy Azure Files StorageClass on ARO clusters.

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

1. Set some environment variables

    ```bash
    export NAMESPACE=aro-azfiles
    export AZURE_FILES_RESOURCE_GROUP=aro-mobb-rg
    export LOCATION=eastus
    export AZURE_STORAGE_ACCOUNT_NAME=aroazurefiles$USERNAME
    export ARO_RESOURCE_GROUP=aro-mobb-rg
    export CLUSTER=aro-mobb
    ```

> NOTE: the AZFiles is defined in the same RG as the ARO_RG, if you change set the proper SP permissions

## Deploy the Azure Storage Account for the Azure Files resource

1. Set up Azure Storage Account (define the AZ Files RG and Location)

    ```bash
    az group create -l $LOCATION -n $AZURE_FILES_RESOURCE_GROUP

    az storage account create \
        --name $AZURE_STORAGE_ACCOUNT_NAME \
        --resource-group $AZURE_FILES_RESOURCE_GROUP \
        --kind StorageV2 \
        --sku Standard_LRS
    ```

1. Setup the Resource Group permissions

    ```bash
    ARO_SERVICE_PRINCIPAL_ID=$(az aro show -g $ARO_RESOURCE_GROUP \
    -n $CLUSTER --query servicePrincipalProfile.clientId -o tsv)
    SCOPE=$(az aro show -g $ARO_RESOURCE_GROUP -n $CLUSTER \
    --query id -o tsv | cut -d'/' -f1-5)

    az role assignment create --role Contributor --scope $SCOPE \
    --assignee $ARO_SERVICE_PRINCIPAL_ID
    ```

## Deploy the Helm Chart

1. Fill the values.yaml with your LOCATION, AZURE_STORAGE_ACCOUNT_NAME and the AZURE_FILES_RESOURCE_GROUP.

1. Install Helm Chart

    ```bash
    helm upgrade --install -n $NAMESPACE aro-azfiles mobb/aro-files --create-namespace
    ```



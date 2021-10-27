# Mobb Helm Chart - alertmanager-cr

Creates a alertmanager instance using the alertmanager Operator

## TL;DR

Deploy the alertmanager Operator from OperatorHub, or YOLO from bash:

```bash
export NAMESPACE=alertmanager
curl -sSL https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/rosa-federated-prometheus/files/deploy-operators.sh | bash
```

Deploy from the alertmanager Helm Chart:

```bash
helm repo add mobb https://mobb.github.io/helm-charts
helm install -n alertmanager my-release mobb/alertmanager-cr
```

## Introduction

## Prerequisites

- OpenShift 4.x
- Helm 3.x

## Installing the Chart

Deploy the alertmanager Operator from OperatorHub, or YOLO from bash:

```bash
export NAMESPACE=alertmanager
curl -sSL https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/rosa-federated-prometheus/files/deploy-operators.sh | bash
```

> **Tip**: See [values.yaml](./values.yaml) for configurable parameters.


Deploy from the alertmanager Helm Chart:

```bash
helm repo add mobb https://mobb.github.io/helm-charts
helm install -n $NAMESPACE my-release mobb/alertmanager-cr
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
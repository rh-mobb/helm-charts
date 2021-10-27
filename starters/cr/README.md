# Mobb Helm Chart - grafana-cr

Creates a grafana instance using the Grafana Operator

## TL;DR

Deploy the Grafana Operator from OperatorHub, or YOLO from bash:

```bash
export NAMESPACE=grafana
curl -sSL https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/rosa-federated-prometheus/files/deploy-operators.sh | bash
```

Deploy from the Grafana Helm Chart:

```bash
helm repo add mobb https://mobb.github.io/helm-charts
helm install -n grafana my-release mobb/grafana-cr
```

## Introduction

## Prerequisites

- OpenShift 4.x
- Helm 3.x

## Installing the Chart

Deploy the Grafana Operator from OperatorHub, or YOLO from bash:

```bash
export NAMESPACE=grafana
curl -sSL https://raw.githubusercontent.com/rh-mobb/helm-charts/main/charts/rosa-federated-prometheus/files/deploy-operators.sh | bash
```

> **Tip**: See [values.yaml](./values.yaml) for configurable parameters.


Deploy from the Grafana Helm Chart:

```bash
helm repo add mobb https://mobb.github.io/helm-charts
helm install -n $NAMESPACE my-release mobb/grafana-cr
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
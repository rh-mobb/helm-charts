#!/bin/bash

if [[ -z $PROM_NAMESPACE ]]; then
  echo "Please set PROM_NAMESPACE environment variable"
  exit 1
fi

echo "--> Creating Namespace - $PROM_NAMESPACE"

cat << EOF | kubectl apply -f -
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${PROM_NAMESPACE}
EOF

echo "--> Deploying Prometheus Operator to $PROM_NAMESPACE"

cat << EOF | kubectl apply -f -
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: federated-metrics
  namespace: ${PROM_NAMESPACE}
spec:
  targetNamespaces:
  - ${PROM_NAMESPACE}
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: prometheus
  namespace: ${PROM_NAMESPACE}
spec:
  channel: beta
  installPlanApproval: Automatic
  name: prometheus
  source: community-operators
  sourceNamespace: openshift-marketplace
EOF

echo "--> Deploying Grafana Operator to $PROM_NAMESPACE"

cat << EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: operatorhubio-catalog
  namespace: ${PROM_NAMESPACE}
spec:
  sourceType: grpc
  image: quay.io/operator-framework/upstream-community-operators:latest
  displayName: Community Operators
  publisher: OperatorHub.io
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: grafana-operator
  namespace: ${PROM_NAMESPACE}
spec:
  channel: v4
  name: grafana-operator
  installPlanApproval: Automatic
  source: operatorhubio-catalog
  sourceNamespace: ${PROM_NAMESPACE}
EOF

echo "--> Waiting for Prometheus Operator to be ready"

while ! kubectl -n $PROM_NAMESPACE get sa prometheus-operator 2> /dev/null > /dev/null; do
  sleep 1
done

echo "--> Waiting for Grafana Operator to be ready"

while ! kubectl -n $PROM_NAMESPACE get crd grafanadashboards.integreatly.org 2> /dev/null > /dev/null; do
  sleep 1
done
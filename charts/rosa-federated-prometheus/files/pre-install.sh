#!/bin/bash

if [[ -z $NAMESPACE ]]; then
  echo "Please set NAMESPACE environment variable"
  exit 1
fi

echo "--> Creating Namespace - $NAMESPACE"

cat << EOF | kubectl apply -f -
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF

echo "--> Deploying Prometheus Operator to $NAMESPACE"

cat << EOF | kubectl apply -f -
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: federated-metrics
  namespace: ${NAMESPACE}
spec:
  targetNamespaces:
  - ${NAMESPACE}
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: prometheus
  namespace: ${NAMESPACE}
spec:
  channel: beta
  installPlanApproval: Automatic
  name: prometheus
  source: community-operators
  sourceNamespace: openshift-marketplace
EOF

echo "--> Deploying Grafana Operator to $NAMESPACE"

cat << EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: operatorhubio-catalog
  namespace: ${NAMESPACE}
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
  namespace: ${NAMESPACE}
spec:
  channel: v4
  name: grafana-operator
  installPlanApproval: Automatic
  source: operatorhubio-catalog
  sourceNamespace: ${NAMESPACE}
EOF

echo "--> Waiting for Prometheus Operator to be ready"

while ! kubectl -n $NAMESPACE get sa prometheus-operator 2> /dev/null > /dev/null; do
  sleep 1
done

echo "--> Waiting for Grafana Operator to be ready"

while ! kubectl -n $NAMESPACE get crd grafanadashboards.integreatly.org 2> /dev/null > /dev/null; do
  sleep 1
done
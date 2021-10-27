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

echo "--> Deploying OperatorGroup to $NAMESPACE"

cat << EOF | kubectl apply -f -
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: mobb-operators
  namespace: ${NAMESPACE}
spec:
  targetNamespaces:
  - ${NAMESPACE}
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

echo "--> Waiting for Grafana Operator to be ready"

while ! kubectl -n $NAMESPACE get pods | grep grafana-operator-controller 2> /dev/null > /dev/null; do
  sleep 1
done
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

echo "--> Deploying Prometheus Operator to $NAMESPACE"

cat << EOF | kubectl apply -f -
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

echo "--> Waiting for Prometheus Operator to be ready"

while ! kubectl -n $NAMESPACE get sa prometheus-operator 2> /dev/null > /dev/null; do
  sleep 1
done

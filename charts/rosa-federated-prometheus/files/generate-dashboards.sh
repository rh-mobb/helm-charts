#!/bin/bash

for dashboard in $(kubectl -n openshift-monitoring get cm | grep grafana-dashboard- | awk '{print $1}'); do

  kubectl -n openshift-monitoring get cm $dashboard -o json \
    | jq '.data | values[]' > files/dashboards/${dashboard}.json

done
# Deploy a public API / Ingress Proxy

This creates an in-cluster proxy that runs on a NLB that will proxy to both the OCP API and Console.

## Deploy

1. Set your cluster name

    ```bash
    export NAME=poc-cz-demo
    ```

1. Fetch the Domain of the cluster

    ```bash
    DOMAIN=$(rosa describe cluster -c $NAME -o json | jq -r .dns.base_domain)
    echo $DOMAIN
    ```

1. Fetch the ingress LB url

    ```bash
    LB=$(oc -n openshift-ingress get svc router-default -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    echo $LB
    ```

1. Deploy the proxy

    > you can set these in a values file as well as allow/deny rules (see `./values.yaml`)

    ```bash
    oc new-project api-proxy
    helm upgrade --install -n api-proxy api-proxy . \
      --set "ocp.clusterDomain=${NAME}.${DOMAIN}" \
      --set "ocp.ingressLB=${LB}"
    ```

1. Wait until the service has a LB attached

    ```bash
    oc get svc api-proxy-ocp-proxy-api -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
    ```

1. Use the hostname to create CNAMES in your cluster's public zone, or for dev uses cases can just do entries in `/etc/hosts`

    example:

    ```
    18.220.46.10 api.poc-cz-demo.71sf.p1.openshiftapps.com
    18.220.46.10 console-openshift-console.apps.poc-cz-demo.71sf.p1.openshiftapps.com
    18.220.46.10 oauth-openshift.apps.poc-cz-demo.71sf.p1.openshiftapps.com
    ```

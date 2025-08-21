# MOBB OpenShift OpenTelemetry Helm Chart

This Helm Chart is designed to deploy the OTEL Operator and an OTEL Collector that will emulate the Cluster Log Forwarder operator in OpenShift.

It can be configured to collect Audit, Infra, and App logs from the cluster, as well as receive OTLP and FluentForward (Fluent,Vector) protocols.

It currently supports the debug exporter to validate logs are flowing as well as the S3 and Loki exporters to send logs directly to S3, or to an OpenShift LokiStack.

See the `./values.yaml` file for configurable options.

> Note if you want to export to S3, you'll need to configure IRSA or add the credentials as environment variables. Documentation for doing these will be added later.

1. Deploy the OTEL Operator

    ```bash
    oc create namespace openshift-telemetry-operator
    helm upgrade -n openshift-telemetry-operator otel-operator \
    mobb/operatorhub --install \
    --values ./files/otel-operator.yaml
    ```

1. Deploy the OpenShift Cluster Observability Operator (If wanting to install the UIPlugin for viewing Loki logs from the OpenShift Console). If you skip this step set `uiPlugin.enabled` to `false`.

    ```bash
    oc create namespace openshift-cluster-observability-operator
    helm upgrade -n openshift-cluster-observability-operator ocoo-operators \
    mobb/operatorhub --install \
    --values ./files/ocoo-operator.yaml
    ```

1. Wait a few moments and then validate the operator is installed

    ```bash
    oc -n openshift-telemetry-operator rollout status \
      deployment/opentelemetry-operator-controller-manager
    ```

    ```
    deployment "opentelemetry-operator-controller-manager" successfully rolled out
    ```

1. Create the OpenTelemetry Collector

    ```bash
    oc create namespace opentelemetry-logging
    helm upgrade -n opentelemetry-logging ocp-otel . --install
    ```

1. fix needing this

```
oc adm policy  add-scc-to-user opentelemetry-logging-scc \
  -z ocp-otel-logging-collector

```
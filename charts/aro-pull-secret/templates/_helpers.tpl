{{/*
Expand the name of the chart.
*/}}
{{- define "aro-pull-secret.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "aro-pull-secret.dummy" -}}
{"apiVersion":"v1","data":{".dockerconfigjson":"eyJhdXRocyI6eyJhcm9zdmMuYXp1cmVjci5pbyI6eyJhdXRoIjoiZGFkc2Rha016UXhNell0TjJVMVl5MDBZV0V4TFRnNU9EQXRZakF3TWpnM00yTmlObU0yT201R01XUmpkVDExUXpkRE16VnlPRDB3ZVdjMlVYbGxWMXBMVFZaaVdFRksifX19Cg=="},"kind":"Secret","metadata":{"creationTimestamp":"2022-07-14T15:14:43Z","managedFields":[{"apiVersion":"v1","fieldsType":"FieldsV1","fieldsV1":{"f:data":{".":{},"f:.dockerconfigjson":{}},"f:type":{}},"manager":"cluster-bootstrap","operation":"Update","time":"2022-07-14T15:14:43Z"}],"name":"pull-secret","namespace":"openshift-config","resourceVersion":"1859","uid":"864ad900-a9a3-4fdd-a897-b0fde32b18d3"},"type":"kubernetes.io/dockerconfigjson"}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aro-pull-secret.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aro-pull-secret.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aro-pull-secret.labels" -}}
helm.sh/chart: {{ include "aro-pull-secret.chart" . }}
{{ include "aro-pull-secret.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aro-pull-secret.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aro-pull-secret.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "aro-pull-secret.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aro-pull-secret.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

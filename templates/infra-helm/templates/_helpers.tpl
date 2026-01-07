{{/*
Expand the name of the chart.
*/}}
{{- define "cnmrf-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "cnmrf-service.fullname" -}}
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
Selector labels
*/}}
{{- define "cnmrf-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cnmrf-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cnmrf-service.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "cnmrf-service.selectorLabels" . }}
{{- end }}

{{/*
------------------------------------------------------------------
VENDOR NEUTRAL ABSTRACTIONS
------------------------------------------------------------------
*/}}

{{/*
Ingress Annotations - Logic to switch vendors.
*/}}
{{- define "cnmrf-service.ingressAnnotations" -}}
{{- if eq .Values.platform.ingressController "alb" }}
kubernetes.io/ingress.class: alb
alb.ingress.kubernetes.io/scheme: internet-facing
alb.ingress.kubernetes.io/target-type: ip
{{- else if eq .Values.platform.ingressController "appgw" }}
kubernetes.io/ingress.class: azure/application-gateway
appgw.ingress.kubernetes.io/ssl-redirect: "true"
{{- else if eq .Values.platform.ingressController "nginx" }}
kubernetes.io/ingress.class: nginx
nginx.ingress.kubernetes.io/ssl-redirect: "true"
{{- end }}
{{- end }}

{{/*
Service Account Annotations - Logic for Identity.
*/}}
{{- define "cnmrf-service.saAnnotations" -}}
{{- if eq .Values.platform.provider "aws" }}
eks.amazonaws.com/role-arn: {{ .Values.serviceAccount.roleArn | default ("arn:aws:iam::ACCOUNT:role/" | printf "%s%s-role" (include "cnmrf-service.fullname" .)) }}
{{- else if eq .Values.platform.provider "azure" }}
azure.workload.identity/client-id: {{ .Values.serviceAccount.clientId | default "DEFAULT_CLIENT_ID" }}
{{- end }}
{{- end }}

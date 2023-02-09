{{/*
Expand the name of the chart.
*/}}
{{- define "egressd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "egressd.fullname" -}}
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
{{- define "egressd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "egressd.labels" -}}
helm.sh/chart: {{ include "egressd.chart" . }}
{{ include "egressd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "egressd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "egressd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "egressd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "egressd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "egressd.aggregator.fullname" -}}
{{ include "egressd.fullname" . }}-aggregator
{{- end }}

{{/*
Common aggregator labels
*/}}
{{- define "egressd.aggregator.labels" -}}
helm.sh/chart: {{ include "egressd.chart" . }}
{{ include "egressd.aggregator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "egressd.aggregator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "egressd.name" . }}-aggregator
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "egressd.export.http.addr" -}}
{{- if .Values.export.http.addr }}
{{- .Values.export.http.addr}}
{{- else }}
{{- printf "http://%s:80" (include "egressd.aggregator.fullname" .) }}
{{- end }}
{{- end }}

{{- define "egressd.export.file.addr" -}}
{{- if .Values.export.http.addr }}
{{- .Values.export.http.addr}}
{{- else }}
{{- printf "%s:6000" (include "egressd.aggregator.fullname" .) }}
{{- end }}
{{- end }}

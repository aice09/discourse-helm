{{- define "discourse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "discourse.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "discourse.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "discourse.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "discourse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "discourse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "discourse.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "discourse.createSecret" -}}
{{- if or (not .Values.postgresql.existingSecret) (not .Values.discourse.smtp.existingSecret) (not .Values.redis.existingSecret) (not .Values.discourse.s3.existingSecret) -}}true{{- end -}}
{{- end -}}
{{- define "discourse.envFrom" -}}
- configMapRef:
    name: {{ include "discourse.fullname" . }}
{{- if include "discourse.createSecret" . }}
- secretRef:
    name: {{ include "discourse.fullname" . }}
{{- end }}
{{- with .Values.extraEnvFrom }}
{{- toYaml . }}
{{- end }}
{{- end -}}

{{- define "discourse.secretEnv" -}}
- name: DISCOURSE_DB_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.postgresql.existingSecret }}
      key: {{ ternary .Values.postgresql.usernameKey "DISCOURSE_DB_USERNAME" (ne .Values.postgresql.existingSecret "") }}
- name: DISCOURSE_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.postgresql.existingSecret }}
      key: {{ ternary .Values.postgresql.passwordKey "DISCOURSE_DB_PASSWORD" (ne .Values.postgresql.existingSecret "") }}
- name: DISCOURSE_SMTP_USER_NAME
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.discourse.smtp.existingSecret }}
      key: {{ ternary .Values.discourse.smtp.usernameKey "DISCOURSE_SMTP_USER_NAME" (ne .Values.discourse.smtp.existingSecret "") }}
- name: DISCOURSE_SMTP_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.discourse.smtp.existingSecret }}
      key: {{ ternary .Values.discourse.smtp.passwordKey "DISCOURSE_SMTP_PASSWORD" (ne .Values.discourse.smtp.existingSecret "") }}
- name: DISCOURSE_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.redis.existingSecret }}
      key: {{ ternary .Values.redis.passwordKey "DISCOURSE_REDIS_PASSWORD" (ne .Values.redis.existingSecret "") }}
- name: DISCOURSE_S3_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.discourse.s3.existingSecret }}
      key: {{ ternary .Values.discourse.s3.accessKeyIdKey "DISCOURSE_S3_ACCESS_KEY_ID" (ne .Values.discourse.s3.existingSecret "") }}
- name: DISCOURSE_S3_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ default (include "discourse.fullname" .) .Values.discourse.s3.existingSecret }}
      key: {{ ternary .Values.discourse.s3.secretAccessKeyKey "DISCOURSE_S3_SECRET_ACCESS_KEY" (ne .Values.discourse.s3.existingSecret "") }}
{{- with .Values.extraEnv }}
{{- toYaml . }}
{{- end }}
{{- end -}}

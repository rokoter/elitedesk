{{- define "mineos.name" -}}
mineos
{{- end }}

{{- define "mineos.fullname" -}}
{{ include "mineos.name" . }}
{{- end }}

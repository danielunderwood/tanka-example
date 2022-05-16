local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

(import './config.libsonnet') +
{
  // use locals to extract the parts we need
  local deploy = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,
  local service = k.core.v1.service,
  local pvc = k.core.v1.persistentVolumeClaim,
  local vd = k.core.v1.volumeDevice,
  local host = 'grafana.example.com',
  // We don't really use the admin user, but it can be swapped on for initial setup or debugging
  // The secret should be available with
  // kubectl -n monitoring get secret grafana -o json | jq -r '.data["admin-password"]' | base64 -d
  local enableLocalAuth = false,
  // defining the objects:
  grafana: helm.template('grafana', '../charts/grafana', {
    namespace: 'monitoring',
    values: {
      ingress: {
        enabled: true,
        annotations: {
          'kubernetes.io/ingress.class': 'nginx',
          'cert-manager.io/cluster-issuer': 'letsencrypt-staging',
        },
        hosts: [host],
      },
      extraSecretMounts: [
        {
          name: 'github-oauth-mount',
          secretName: 'github-oauth',
          defaultMode: 400,
          mountPath: '/var/run/secrets/github_oauth',
          readOnly: true,
        },
      ],
      'grafana.ini': {
        server: {
          root_url: 'https://' + host,
        },
        auth: {
          disable_login_form: !enableLocalAuth,
        },
        'auth.basic': {
          enabled: enableLocalAuth,
        },
      },
      persistence: {
        enabled: true,
      },
      imageRenderer: {
        enabled: true,
      },
      datasources: [],
      resources: {
        requests: { memory: $._config.grafana.memory, cpu: $._config.grafana.cpu },
        limits: { memory: $._config.grafana.memoryLimit, cpu: $._config.grafana.cpuLimit },
      },
    },
  }),
}

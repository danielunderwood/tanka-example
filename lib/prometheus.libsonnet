local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  prometheus: helm.template('prometheus', '../charts/prometheus', {
    namespace: 'monitoring',
    values: {
      kubeStateMetrics: {
        enabled: true,
      },
      nodeExporter: {
        enabled: true,
      },
      persistentVolume: {
        enabled: true,
        size: '2Gi',
      },
    },
  }),
}

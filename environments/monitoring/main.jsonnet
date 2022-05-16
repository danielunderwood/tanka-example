local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

(import 'grafana.libsonnet') +
(import 'influx.libsonnet') +
(import 'prometheus.libsonnet') +
{
  local ns = k.core.v1.namespace,
  local ingress = k.networking.v1.ingress,
  // Config overrides for environment
  _config+:: {

  },
  // This is a bit weird, but it seems like the tanka way is to create an environment
  // for each namespace and deploy there rather than setting the namespace of resources
  namespace: ns.new(name=$._config.grafana.namespace),
}

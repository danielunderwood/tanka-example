local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
{
  podinfo: {
    deployment: k.apps.v1.deployment.new(
      name='podinfo',
      replicas=3,
      containers=[
        container.new(name='podinfo', image='stefanprodan/podinfo')
        + container.withPorts([k.core.v1.containerPort.new('http', 9898)]),
      ]
    ),
    service: k.util.serviceFor(self.deployment)
             + k.core.v1.service.mixin.spec.withType('NodePort'),
  },
}

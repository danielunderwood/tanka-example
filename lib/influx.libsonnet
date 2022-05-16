local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
(import './config.libsonnet') +
{
  local deploy = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,
  local service = k.core.v1.service,
  local pvc = k.core.v1.persistentVolumeClaim,
  influx: {
    pvc: pvc.new(name='influx-data')
         + pvc.spec.withAccessModes('ReadWriteOnce')
         + pvc.spec.resources.withRequests({ storage: $._config.influx.storage }),
    deployment: deploy.new(
                  name=$._config.influx.name,
                  replicas=1,
                  containers=[
                    container.new($._config.influx.name, $._images.influx)
                    + container.withPorts(
                      [port.new('db', 8086)],
                    )
                    + container.resources.withRequests({ cpu: $._config.influx.cpu, memory: $._config.influx.memory })
                    + container.resources.withLimits({ cpu: $._config.influx.cpuLimit, memory: $._config.influx.memoryLimit }),
                  ],
                )
                + deploy.pvcVolumeMount('influx-data', '/var/lib/influxdb')
                + deploy.spec.template.spec.withInitContainersMixin([
                  container.new('create-data-directory', 'alpine')
                  + container.withCommand(['chmod', '0777', '/var/lib/influxdb'])
                  + container.withVolumeMountsMixin([{ name: 'influx-data', mountPath: '/var/lib/influxdb' }]),
                ]),
    service: k.util.serviceFor(self.deployment)
             + service.mixin.spec.withType('NodePort'),
  },
}

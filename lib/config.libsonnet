{
  // Default config, which can be overridden in environments
  _config+:: {
    grafana: {
      port: 3000,
      name: 'grafana',
      namespace: 'monitoring',
      storage: '5Gi',
      // https://grafana.com/docs/grafana/latest/installation/requirements/
      cpu: '100m',
      memory: '256M',
      cpuLimit: '250m',
      memoryLimit: '512M',
    },
    influx: {
      name: 'influx',
      storage: '20Gi',
      // https://docs.influxdata.com/influxdb/v1.8/guides/hardware_sizing/
      cpu: '500m',
      memory: '1G',
      cpuLimit: '2',
      memoryLimit: '2G',
    },
  },

  _images+:: {
    grafana: 'grafana/grafana',
    influx: 'influxdb:1.8-alpine',
  },
}

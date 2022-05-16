local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local k = import 'k.libsonnet';
local helm = tanka.helm.new(std.thisFile);
local certManager = import 'github.com/jsonnet-libs/cert-manager-libsonnet/1.8/main.libsonnet';
local clusterIssuer = certManager.nogroup.v1.clusterIssuer;
local namespace = 'ingress-nginx';
local acmeEmail = 'admin@example.com';
{
  ingressNginxNamespace: k.core.v1.namespace.new(namespace),
  ingressNginx: helm.template('ingress-nginx', '../../charts/ingress-nginx', {
    namespace: namespace,
    values: {},
  }),
  certManager: helm.template('cert-manager', '../../charts/cert-manager', {
    namespace: namespace,
    values: {
      installCRDs: true,
    },
  }),
  // Staging issuer for testing
  stagingIssuer: clusterIssuer.new('letsencrypt-staging')
                 + clusterIssuer.spec.acme.withEmail(acmeEmail)
                 + clusterIssuer.spec.acme.withServer('https://acme-staging-v02.api.letsencrypt.org/directory')
                 // Should this be linked to some nginx chart value?
                 + clusterIssuer.spec.acme.withSolvers([{ http01: { ingress: { class: 'nginx' } } }])
                 + clusterIssuer.spec.acme.privateKeySecretRef.withName('letsencrypt-staging'),
  // Prod issuer for real certs
  prodIssuer: clusterIssuer.new('letsencrypt-prod')
              + clusterIssuer.spec.acme.withEmail(acmeEmail)
              + clusterIssuer.spec.acme.withServer('https://acme-v02.api.letsencrypt.org/directory')
              // Should this be linked to some nginx chart value?
              + clusterIssuer.spec.acme.withSolvers([{ http01: { ingress: { class: 'nginx' } } }])
              + clusterIssuer.spec.acme.privateKeySecretRef.withName('letsencrypt-prod'),
}

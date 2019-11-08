//local k = import 'k.libsonnet';
local k = import 'ksonnet-util/kausal.libsonnet';

k {
  namespace:
    $.core.v1.namespace.new('test'),

  local configMap = $.core.v1.configMap,
  configMap:
    configMap.new('configmap-test') +
    configMap.withData('aaa'),

  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local envFromSource = container.envFromType,
  container::
    container.new('memcached', 'memcached:1.1.1') +
    container.withPorts([containerPort.new(80, 'http')]) +
    container.withEnvFrom(
      envFromSource.new() +
      envFromSource.mixin.configMapRef.withName($.configMap.metadata.name)
    ) +
    container.withArgs([
      '--memcached.address=localhost:11211',
      '--web.listen-address=0.0.0.0:9150',
    ]),

  local deployment = $.apps.v1.deployment,
  deployment: deployment.new('deployment', 3, [$.container]) +
              deployment.mixin.metadata.withNamespace('test') +
              deployment.mixin.metadata.withLabels({
                a: 'b',
              }),
  service:
    $.util.serviceFor($.deployment),
}

/*
local container = k.apps.v1.deployment.mixin.spec.template.spec.containersType;
local containerPort = container.portsType;
local deployment = k.apps.v1.deployment;


local targetPort = 80;
local podLabels = { app: 'nginx' };


local nginxContainer =
  container.new('nginx', 'nginx:1.8.9') +
  container.ports(containerPort.containerPort(targetPort));

local nginxDeployment =
  deployment.new('nginx', 2, nginxContainer, podLabels);

k.core.v1.list.new(nginxContainer)
*/




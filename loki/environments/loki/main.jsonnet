local gateway = import 'loki/gateway.libsonnet';
local loki = import 'loki/loki.libsonnet';
local promtail = import 'promtail/promtail.libsonnet';

loki + promtail + gateway {
  _config+:: {
    namespace: 'loki',
    htpasswd_contents: 'loki:$apr1$EOFir2Ol$IR.hKXMzHyQPgdOY4N8WK/',
    storage_backend: 's3,dynamodb',
    dynamodb_region: 'us-east-1',
    s3_address: 'aaa',
    s3_bucket_name: 'bbb',
    clients: 'ccc',

    promtail_config+: {
      clients: [
        {
          scheme:: 'https',
          username:: 'user-id',
          password:: 'pw',
          hostname:: 'hn',
        },
      ],
      container_root_path: '/var/lib/docker',
    },

    replication_factor: 3,
    consul_replicas: 1,
  },
}

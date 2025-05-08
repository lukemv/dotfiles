{% set minio_client_url = "https://dl.min.io/client/mc/release/linux-amd64/mc" %}
profiles.minio-client.binary:
  file.managed:
    - name: /usr/local/bin/mc
    - source: {{ minio_client_url }}
    - skip_verify: True
    - mode: 0755


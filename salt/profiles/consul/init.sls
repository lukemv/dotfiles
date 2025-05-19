{% set consul_version = pillar.get("profiles.consul.consul_version", "1.19.1") %}
{% set consul_file_hash = pillar.get("profiles.consul.consul_file_hash", "aa48085aaa6f4130d0f1ee98c416dcd51b1b0f980d34f5b91834fd5b3387891c") %}

profiles.consul.packages:
  pkg.installed:
    - name: unzip

profiles.consul.download:
  file.managed:
    - name: /opt/consul_{{consul_version}}_linux_amd64.zip
    - source: "https://releases.hashicorp.com/consul/{{consul_version}}/consul_{{consul_version}}_linux_amd64.zip"
    - source_hash: {{consul_file_hash}}
    - skip_verify: False

profiles.consul.extract:
  archive.extracted:
    - name: /opt/consul_{{consul_version}}_linux_amd64
    - source: /opt/consul_{{consul_version}}_linux_amd64.zip
    - enforce_toplevel: False
    - source_hash: sha256={{consul_file_hash}}
    - source_hash_update: True
    - archive_format: zip
    - watch:
      - file: profiles.consul.download

profile.consul.symlink:
  file.symlink:
    - name: /usr/local/bin/consul
    - target: /opt/consul_{{consul_version}}_linux_amd64/consul
    - force: True
    - require:
      - archive: profiles.consul.extract

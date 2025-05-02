{%- set filename = "go1.24.2.linux-amd64.tar.gz" %}
{%- set url = "https://go.dev/dl/" ~ filename %}
{%- set go_dest = "/opt/downloads/" ~ filename %}
{%- set install_dir = "/usr/local/go" %}

profiles.golang.download:
  file.managed:
    - name: {{ go_dest }}
    - source: {{ url }}
    - skip_verify: True
    - makedirs: True
    - unless: test -d {{ install_dir }}

extract-go:
  archive.extracted:
    - name: /usr/local
    - source: {{ go_dest }}
    - archive_format: tar
    - enforce_toplevel: False
    - if_missing: {{ install_dir }}/bin/go
    - require:
      - file: profiles.golang.download


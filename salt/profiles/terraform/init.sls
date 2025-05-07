{% set terraform_version = "1.6.6" %}
{% set terraform_checksum = "d117883fd98b960c5d0f012b0d4b21801e1aea985e26949c2d1ebb39af074f00" %}

profiles.terraform.download:
  file.managed:
    - name: /tmp/terraform_{{ terraform_version }}_linux_amd64.zip
    - source: https://releases.hashicorp.com/terraform/{{ terraform_version }}/terraform_{{ terraform_version }}_linux_amd64.zip
    - source_hash: sha256={{ terraform_checksum }}

profiles.terraform.extract:
  archive.extracted:
    - name: /usr/local/bin
    - source: /tmp/terraform_{{ terraform_version }}_linux_amd64.zip
    - enforce_toplevel: False
    - archive_format: zip
    - require:
      - file: profiles.terraform.download

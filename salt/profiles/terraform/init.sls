{% set terraform_version = "1.7.4" %}

profiles.terraform.download:
  file.managed:
    - name: /tmp/terraform_{{ terraform_version }}_linux_amd64.zip
    - source: https://releases.hashicorp.com/terraform/{{ terraform_version }}/terraform_{{ terraform_version }}_linux_amd64.zip
    - skip_verify: True

profiles.terraform.extract:
  archive.extracted:
    - name: /usr/local/bin
    - source: /tmp/terraform_{{ terraform_version }}_linux_amd64.zip
    - enforce_toplevel: False
    - archive_format: zip
    - require:
      - file: profiles.terraform.download

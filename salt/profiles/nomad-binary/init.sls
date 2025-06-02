{% set package_ver = pillar.get('profiles.nomad-binary.package_ver', '1.9.4-1') %}

profiles.nomad-binary.hashicorp.repo:
  file.managed:
    - source: https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    - name: /etc/yum.repos.d/hashicorp.repo
    - skip_verify: True
    - mode: 0644
    - user: root

profiles.nomad-binary.package:
  pkg.installed:
    - name: nomad
    - version: {{ package_ver }}


{% set lazygit_ver = pillar.get("profiles.lazygit.version", "0.50.0") %}
{% set lazygit_archive_hash = pillar.get("profiles.lazygit.hash", "bb2bc0ac8b1e2678c650c5aa8a6fa1595e46f8825ce7e6a3833ca95768179881") %}
{% set lazygit_bin_path = "/usr/local/bin/lazygit" %}
{% set lazygit_downloads_dir = "/srv/lazygit/downloads" %}

profiles.lazygit.dir.downloads:
  file.directory:
    - name: {{ lazygit_downloads_dir }}
    - dir_mode: 755
    - user: root
    - group: root
    - makedirs: True

profiles.lazygit.download:
  file.managed:
    - name: "{{ lazygit_downloads_dir }}/lazygit_{{ lazygit_ver }}_linux_x84_64.tar.gz"
    - source: "https://github.com/jesseduffield/lazygit/releases/download/{{ lazygit_ver }}/lazygit_{{ lazygit_ver }}_Linux_x84_64.tar.gz"
    - source_hash: {{ lazygit_archive_hash }}
    - mode: 755
    - user: root
    - group: root

profiles.lazygit.extract:
  archive.extracted:
    - name: {{ lazygit_downloads_dir }}
    - source: "{{ lazygit_downloads_dir }}/lazygit_{{ lazygit_ver }}_linux_x84_64.tar.gz"
    - source_hash: {{ lazygit_archive_hash }}
    - mode: 755
    - enforce_toplevel: False
    - user: root
    - group: root
    - require:
      - file: profiles.lazygit.download

profiles.lazygit.link:
  file.symlink:
    - name: {{ lazygit_bin_path }}
    - target: {{ lazygit_downloads_dir }}/lazygit
    - mode: 755
    - require:
      - archive: profiles.lazygit.extract


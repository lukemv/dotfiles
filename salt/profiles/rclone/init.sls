{% set rclone_ver = pillar.get("profiles.rclone.version", "1.69.2") %}
{% set rclone_archive_hash = pillar.get("profiles.rclone.hash", "14aaed7163df57894c96f8aca94757f19065f9cb3cb8a84ff9c33234271e1d69") %}
{% set rclone_bin_path = "/usr/local/bin/rclone" %}
{% set rclone_downloads_dir = "/srv/rclone/downloads" %}

profiles.rclone.dir.downloads:
  file.directory:
    - name: {{ rclone_downloads_dir }}
    - dir_mode: 755
    - user: root
    - group: root
    - makedirs: True

profiles.rclone.download:
  file.managed:
    - name: "{{ rclone_downloads_dir }}/rclone-v{{ rclone_ver }}-linux-amd64.zip"
    - source: https://github.com/rclone/rclone/releases/download/v{{ rclone_ver }}/rclone-v{{ rclone_ver }}-linux-amd64.zip
    - source_hash: {{ rclone_archive_hash }}
    - mode: 755
    - user: root
    - group: root

profiles.rclone.extract:
  archive.extracted:
    - name: {{ rclone_downloads_dir }}
    - source: "{{ rclone_downloads_dir }}/rclone-v{{ rclone_ver }}-linux-amd64.zip"
    - source_hash: {{ rclone_archive_hash }}
    - user: root
    - group: root
    - require:
      - file: profiles.rclone.download

profiles.rclone.link:
  file.symlink:
    - name: {{ rclone_bin_path }}
    - target: {{ rclone_downloads_dir }}/rclone
    - mode: 755
    - require:
      - archive: profiles.rclone.extract


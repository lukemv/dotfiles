
{% set vector_ver = pillar.get("profiles.vector.version", "0.38.0") %}
{% set vector_archive_hash = pillar.get("profiles.vector.hash", "86bd28eadebd55937455364f8a10aa1f4bd66154bc8fe06cb5c6e63475c081a7") %}

{% set vector_bin_path = "/usr/local/bin/vector" %}
{% set vector_downloads_dir = "/srv/vector/downloads" %}
{% set vector_data_dir = "/srv/vector/data" %}

profiles.vector.dir.downloads:
  file.directory:
    - name: {{ vector_downloads_dir }}
    - dir_mode: 755
    - user: root
    - group: root
    - makedirs: True

profiles.vector.dir.data:
  file.directory:
    - name: {{ vector_data_dir }}
    - dir_mode: 755
    - user: root
    - group: root
    - makedirs: True

profiles.vector.download:
  file.managed:
    - name: {{ vector_downloads_dir }}/vector-{{ vector_ver }}-x86_64-unknown-linux-gnu.tar.gz
    - source: https://packages.timber.io/vector/{{ vector_ver }}/vector-{{ vector_ver }}-x86_64-unknown-linux-gnu.tar.gz
    - source_hash: {{ vector_archive_hash }}
    - mode: 755
    - user: root
    - group: root

profiles.vector.extract:
  archive.extracted:
    - name: {{ vector_downloads_dir }}
    - source: {{ vector_downloads_dir }}/vector-{{ vector_ver }}-x86_64-unknown-linux-gnu.tar.gz
    - source_hash: {{ vector_archive_hash }}
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: profiles.vector.download

profiles.vector.link:
  file.symlink:
    - name: {{ vector_bin_path }}
    - target: {{ vector_downloads_dir }}/vector-x86_64-unknown-linux-gnu/bin/vector
    - mode: 775
    - require:
      - archive: profiles.vector.extract

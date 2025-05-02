{% set fzf_ver = pillar.get("profiles.fzf.version", "0.55.0") %}
{% set fzf_archive_hash = pillar.get("profiles.fzf.hash", "4df2393776942780ddab2cea713ddaac06cd5c3886cd23bc9119a6d3aa1e02bd") %}
{% set fzf_bin_path = "/usr/local/bin/fzf" %}
{% set fzf_downloads_dir = "/srv/fzf/downloads" %}

profiles.fzf.dir.downloads:
  file.directory:
    - name: {{ fzf_downloads_dir }}
    - dir_mode: 755
    - user: root
    - group: root
    - makedirs: True

profiles.fzf.download:
  file.managed:
    - name: "{{ fzf_downloads_dir }}/fzf-{{ fzf_ver }}-linux_amd64.tar.gz"
    - source: "https://github.com/junegunn/fzf/releases/download/v{{ fzf_ver }}/fzf-{{ fzf_ver }}-linux_amd64.tar.gz"
    - source_hash: {{ fzf_archive_hash }}
    - mode: 755
    - user: root
    - group: root

profiles.fzf.extract:
  archive.extracted:
    - name: {{ fzf_downloads_dir }}
    - source: "{{ fzf_downloads_dir }}/fzf-{{ fzf_ver }}-linux_amd64.tar.gz"
    - source_hash: {{ fzf_archive_hash }}
    - mode: 755
    - enforce_toplevel: False
    - user: root
    - group: root
    - require:
      - file: profiles.fzf.download

profiles.fzf.link:
  file.symlink:
    - name: {{ fzf_bin_path }}
    - target: {{ fzf_downloads_dir }}/fzf
    - mode: 755
    - require:
      - archive: profiles.fzf.extract


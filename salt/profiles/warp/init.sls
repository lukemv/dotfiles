warp-download-dir:
  file.directory:
    - name: /opt/downloads
    - mode: 755
    - user: root
    - group: root

warp-download:
  file.managed:
    - name: /opt/downloads/warp_Linux_x86_64.tar.gz
    - source: https://github.com/minio/warp/releases/download/v1.1.4/warp_Linux_x86_64.tar.gz
    - user: root
    - group: root
    - skip_verify: True
    - mode: 644
    - require:
      - file: warp-download-dir

warp-extract:
  archive.extracted:
    - name: /opt/downloads/warp_extracted
    - source: /opt/downloads/warp_Linux_x86_64.tar.gz
    - archive_format: tar
    - enforce_toplevel: false
    - options: '--no-same-owner'
    - require:
      - file: warp-download

warp-install-bin:
  file.managed:
    - name: /usr/local/bin/warp
    - source: /opt/downloads/warp_extracted/warp
    - mode: 755
    - user: root
    - group: root
    - require:
      - archive: warp-extract

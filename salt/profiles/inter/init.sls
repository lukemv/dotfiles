profiles.inter.install-unzip:
  pkg.installed:
    - name: unzip

profiles.inter.download:
  file.managed:
    - name: /opt/downloads/Inter.zip
    - source: https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip
    - skip_verify: true
    - makedirs: true
    - mode: 644

profiles.inter.extract:
  archive.extracted:
    - name: /opt/downloads/inter
    - source: /opt/downloads/Inter.zip
    - archive_format: zip
    - enforce_toplevel: false
    - require:
      - file: profiles.inter.download

profiles.inter.fontdir:
  file.directory:
    - name: /home/lukem/.local/share/fonts/inter
    - user: lukem
    - group: lukem
    - mode: 755
    - makedirs: true

profiles.inter.cp:
  file.copy:
    - name: /home/lukem/.local/share/fonts/inter/InterVariable.ttf
    - source: /opt/downloads/inter/InterVariable.ttf
    - user: lukem
    - group: lukem
    - mode: 644

profiles.inter.update-cache:
  cmd.run:
    - name: fc-cache -fv
    - runas: lukem
    - require:
      - file: profiles.inter.cp


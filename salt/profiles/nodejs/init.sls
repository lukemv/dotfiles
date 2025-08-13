{% set node_version = "v23.11.0" %}

profiles.nodejs.install:
  cmd.run:
    - name: |
        mkdir -p /opt/nodejs
        cd /opt/nodejs
        curl -O https://nodejs.org/dist/{{ node_version }}/node-{{ node_version }}-linux-x64.tar.xz
        tar -xJf node-{{ node_version }}-linux-x64.tar.xz
        ln -s /opt/nodejs/node-{{ node_version }}-linux-x64/bin/node /usr/bin/node
        ln -s /opt/nodejs/node-{{ node_version }}-linux-x64/bin/npm /usr/bin/npm
        ln -s /opt/nodejs/node-{{ node_version }}-linux-x64/bin/npx /usr/bin/npx
    - creates: /usr/bin/node

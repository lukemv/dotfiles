{% set user = 'lukem' %}
{% set home = '/home/' + user %}
{% set systemd_user_dir = home + '/.config/systemd/user' %}

profiles.monitors.systemd.script:
  file.managed:
    - name: /usr/local/bin/monitors
    - source: salt://{{ slspath }}/files/monitors.sh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - makedirs: True

profiles.monitors.systemd.service:
  file.managed:
    - name: {{ systemd_user_dir }}/monitors.service
    - source: salt://{{ slspath  }}/files/monitors.service
    - user: {{ user }}
    - group: {{ user }}
    - mode: 644
    - makedirs: True

profiles.monitors.systemd.reload:
  cmd.run:
    - name: |
        export XDG_RUNTIME_DIR=/run/user/$(id -u {{ user }})
        export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
        systemctl --user daemon-reexec
        systemctl --user daemon-reload
    - runas: {{ user }}


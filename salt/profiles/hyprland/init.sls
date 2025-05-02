{%- set user = "lukem" %}
{%- set id = "1000" %}
{%- set services = ["waybar", "hyprpaper"] %}

{% for svc in services %}
profiles.hyprland.systemd.{{ svc }}:
  cmd.run:
    - name: systemctl --user enable --now {{ svc }}.service
    - runas: {{ user }}
    - env:
      - XDG_RUNTIME_DIR: /run/user/{{ id }}
{% endfor %}

swaylock:
  pkg.installed:
    - name: swaylock


{%- set user = "lukem" %}
{%- set id = "1000" %}
{%- set services = [
  "waybar",
  "hyprpaper",
  "monitors"] %}

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

# These utils are used for screenshots and annotations
{% set screenshot_utils = ["grim", "slurp", "swappy"] %}
{% for util in screenshot_utils %}
profiles.hyprland.pkg.{{ util }}:
  pkg.installed:
    - name: {{ util }}
{% endfor %}


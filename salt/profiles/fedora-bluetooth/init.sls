{% set bluetooth_packages = [
  "bluez",
  "blueman",
  "wireplumber pipewire",
  "pipewire-pulseaudio",
  "pipewire-alsa",
  "pipewire-jack",
] %}

{% for pkg in bluetooth_packages %}
profiles.fedora-bluetooth.package.{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{% endfor %}



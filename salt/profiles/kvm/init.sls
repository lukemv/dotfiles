{% set user = "lukem" %}
profiles.kvm.package:
  pkg.installed:
    - pkgs:
      - libguestfs
      - libguestfs-tools
      - libvirt
      - libvirt-daemon-kvm
      - python3-libvirt
      - qemu-kvm
      - virt-install
      - virt-manager
      - bridge-utils

# This adds users to the libvirt group. This group membership
# allows users to connect to the system virsh namespace to manage
# networks, domains and storage
profiles.kvm.group_membership:
  group.present:
    - name: libvirt
    - system: True
    - addusers:
      - lukem

profiles.kvm.service:
  service.running:
    - name: libvirtd
    - enable: True

{% set bridge_name = "br0" %}
{% set physical_iface = "wlp0s20f3" %}
{% set libvirt_net = "br0-net" %}
{% set net_xml_path = "/etc/libvirt/qemu/networks/{}.xml".format(libvirt_net) %}

create_bridge:
  cmd.run:
    - name: nmcli connection add type bridge autoconnect yes con-name {{ bridge_name }} ifname {{ bridge_name }}
    - unless: nmcli connection show {{ bridge_name }}

add_bridge_slave:
  cmd.run:
    - name: nmcli connection add type bridge-slave autoconnect yes con-name {{ bridge_name }}-slave ifname {{ physical_iface }} master {{ bridge_name }}
    - unless: nmcli connection show {{ bridge_name }}-slave

bring_up_bridge:
  cmd.run:
    - name: nmcli connection up {{ bridge_name }}

write_libvirt_net_xml:
  file.managed:
    - name: {{ net_xml_path }}
    - makedirs: True
    - contents: |
        <network>
          <name>{{ libvirt_net }}</name>
          <forward mode="bridge"/>
          <bridge name="{{ bridge_name }}"/>
        </network>


define_libvirt_network:
  cmd.run:
    - name: virsh net-define {{ net_xml_path }}
    - unless: virsh net-list --all | grep {{ libvirt_net }}
    - require:
      - file: write_libvirt_net_xml

autostart_libvirt_network:
  cmd.run:
    - name: virsh net-autostart {{ libvirt_net }}

start_libvirt_network:
  cmd.run:
    - name: virsh net-start {{ libvirt_net }}


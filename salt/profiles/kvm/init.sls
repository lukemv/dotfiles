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


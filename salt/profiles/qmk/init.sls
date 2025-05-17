# You still need to pip install -r requirements.txt
profiles.qmk.copr-arm-gcc:
  cmd.run:
    - name: dnf copr enable -y pschyska/arm-toolchain

profiles.qmk.dev-env:
  pkg.installed:
    - pkgs:
        - git
        - dfu-util
        - arm-none-eabi-gcc-cs
        - arm-none-eabi-newlib

profiles.qmk.zsa-qmk-clone:
  git.latest:
    - name: https://github.com/zsa/qmk_firmware.git
    - target: /home/lukem/zsa-qmk
    - user: lukem
    - submodules: True

profiles.qmk.udev-rules:
  file.managed:
    - name: /etc/udev/rules.d/50-qmk.rules
    - source: salt://{{ slspath }}/files/50-qmk.rules
    - mode: '0644'

profiles.qmk.udev-reload:
  cmd.run:
    - name: udevadm control --reload-rules && udevadm trigger
    - onchanges:
      - file: profiles.qmk.udev-rules

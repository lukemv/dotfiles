profiles.linger.run:
  cmd.run:
    - name: loginctl enable-linger lukem
    - unless: loginctl show-user lukem | grep -q '^Linger=yes'


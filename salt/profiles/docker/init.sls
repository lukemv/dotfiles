profiles.docker.repo:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: https://download.docker.com/linux/fedora/docker-ce.repo
    - makedirs: True
    - source_hash: d19388de1ab46e0547d04c576014bc857a60cd4d5ff37f50709b8337c88672a9

profiles.docker.packages:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-compose-plugin

profiles.docker.systemd.service:
  service.running:
    - name: docker.service
    - enable: True

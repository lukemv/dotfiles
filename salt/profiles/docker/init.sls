profiles.docker.repo:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: https://download.docker.com/linux/centos/docker-ce.repo
    - makedirs: True
    - skip_verify: True

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

profiles.docker.user_group:
  group.present:
    - name: docker
  user.present:
    - name: lukem
    - groups:
      - docker
    - require:
      - group: profiles.docker.user_group

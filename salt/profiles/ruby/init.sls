profiles.ruby.dependencies:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - make
      - git
      - curl
      - openssl-devel
      - readline-devel
      - bzip2
      - libyaml-devel

profiles.ruby.rbenv.permissions:
  file.directory:
    - name: /usr/local/rbenv
    - user: root
    - group: root
    - mode: 777

profiles.ruby.rbenv.repository:
  git.latest:
    - name: https://github.com/rbenv/rbenv.git
    - target: /usr/local/rbenv
    - require:
      - pkg: profiles.ruby.dependencies

profiles.ruby.rbenv.plugins.build:
  git.latest:
    - name: https://github.com/rbenv/ruby-build.git
    - target: /usr/local/rbenv/plugins/ruby-build
    - require:
      - git: profiles.ruby.rbenv.repository

profiles.ruby.rbenv.setup:
  cmd.run:
    - name: |
        export PATH="/usr/local/rbenv/bin:$PATH"
        eval "$(rbenv init -)"
        rbenv install 3.4.5
        rbenv global 3.4.5
        rbenv rehash
    - require:
      - git: profiles.ruby.rbenv.plugins.build
    - user: lukem
    - env:
      - PATH: /usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# rbenv install 3.4.3 && rbenv global 3.4.3


# # Install ruby-build as a plugin for rbenv

# # Install tmuxinator
# install_tmuxinator:
#   cmd.run:
#     - name: source /etc/profile.d/rbenv.sh && gem install tmuxinator
#     - require:
#       - cmd: install_ruby

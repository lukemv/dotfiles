profiles.tmuxinator.gem:
  cmd.run:
    - name: eval "$(rbenv init -)" && gem install tmuxinator
    - require:
      - cmd: profiles.ruby.rbenv.setup
    - user: lukem
    - env:
      - PATH: /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


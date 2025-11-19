# Formatters for nvim conform.nvim plugin
# These are the tools that checkhealth reported as missing

# Lua formatter via cargo
profiles.nvim-formatters.stylua:
  cmd.run:
    - name: cargo install stylua
    - runas: {{ pillar.get('profiles.nvim-formatters.user', 'lukem') }}
    - unless: test -f ~/.cargo/bin/stylua

# Go formatters via go install
profiles.nvim-formatters.goimports:
  cmd.run:
    - name: go install golang.org/x/tools/cmd/goimports@latest
    - runas: {{ pillar.get('profiles.nvim-formatters.user', 'lukem') }}
    - unless: test -f ~/code/bin/goimports

profiles.nvim-formatters.gofumpt:
  cmd.run:
    - name: go install mvdan.cc/gofumpt@latest
    - runas: {{ pillar.get('profiles.nvim-formatters.user', 'lukem') }}
    - unless: test -f ~/code/bin/gofumpt

# Python formatters via pip (user install)
profiles.nvim-formatters.black:
  cmd.run:
    - name: pip install --user black
    - runas: {{ pillar.get('profiles.nvim-formatters.user', 'lukem') }}
    - unless: test -f ~/.local/bin/black

profiles.nvim-formatters.isort:
  cmd.run:
    - name: pip install --user isort
    - runas: {{ pillar.get('profiles.nvim-formatters.user', 'lukem') }}
    - unless: test -f ~/.local/bin/isort

# JavaScript formatters via npm (global)
profiles.nvim-formatters.prettier:
  cmd.run:
    - name: npm install -g prettier
    - unless: command -v prettier

profiles.nvim-formatters.prettierd:
  cmd.run:
    - name: npm install -g @fsouza/prettierd
    - unless: command -v prettierd

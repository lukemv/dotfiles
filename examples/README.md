# Language playground

Scratch files for exercising this setup's per-language tooling — LSP,
treesitter highlighting, and formatting. Open a file and try the keymaps below.

The set is derived from what the Neovim config actually sets up: the LSP servers
(`lua_ls`, `pylsp`, `gopls`), the conform formatters, and the treesitter parsers
in `ensure_installed`.

## What each language has

| Language                   | LSP              | Formatter           | Treesitter |
|----------------------------|------------------|---------------------|------------|
| Go (`go/`)                 | gopls            | goimports + gofumpt | yes (+dap) |
| Python (`python/`)         | pylsp (flake8)   | isort + black       | yes        |
| Lua (`lua/`)               | lua_ls + lazydev | stylua              | yes        |
| Go templates (`gotmpl/`)   | gopls            | —                   | yes        |
| Rust (`rust/`)             | —                | rustfmt             | yes        |
| JavaScript (`javascript/`) | —                | prettier            | yes        |
| Terraform (`terraform/`)   | —                | terraform_fmt       | yes (hcl)  |
| C (`c/`)                   | —                | —                   | yes        |
| SQL (`sql/`)               | —                | —                   | yes        |
| JSON (`json/`)             | —                | —                   | yes        |

## Keymaps to try (leader = space)

LSP languages (Go / Python / Lua / templates):
- `gd` goto definition, `gr` references, `gI` implementation, `gD` declaration
- `K` hover docs
- `<leader>lr` rename, `<leader>la` code action, `<leader>ld` type definition
- `<leader>ls` document symbols
- `<leader>ff` format buffer (also runs automatically on `:w` via conform)
- `<leader>xx` diagnostics list (Trouble)

Go extras (in `.go` files):
- `<leader>gt` test, `<leader>ge` add `if err`, `<leader>gf` fill struct,
  `<leader>gj` add json tags

Formatting-only / treesitter-only languages: use `<leader>ff` or `:w` to see
formatting; highlighting is automatic.

## Notes
- The Go example is a real module (`go.mod`) so gopls gets full features.
- Rust / JS / C / SQL / JSON have no LSP configured here — add servers via
  `:Mason` (e.g. `rust-analyzer`, `ts_ls`, `clangd`) if you want full IDE features.
- Formatters need their binary installed; if `<leader>ff` does nothing on, say,
  Rust, install `rustfmt`. conform falls back to LSP formatting where it can.

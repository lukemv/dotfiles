local opts = {
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  wrap = true,
  swapfile = false,
  termguicolors = true,
  number = true,
  relativenumber = true,
  conceallevel = 2,
  undofile = true,
  mouse = "",
  clipboard = "unnamedplus",
  backup = false,
  writebackup = false,
  timeoutlen = 500,
}

for opt, val in pairs(opts) do
  vim.o[opt] = val
end

-- Send yanks to the host clipboard over OSC 52 when there is no local
-- clipboard tool -- i.e. on an SSH/tty box with no Wayland or X display.
--
-- Neovim only falls back to OSC 52 on its own when 'clipboard' is empty
-- (see provider/clipboard.vim), and 'clipboard' is unnamedplus above, so on
-- such a box no provider is selected at all and `y` never leaves Neovim.
-- tmux hid this: its provider branch runs `tmux load-buffer -w`, and
-- `set -g set-clipboard on` re-emits the text as OSC 52 to the outer
-- terminal. herdr sets no $TMUX, so that branch never fires; it does handle
-- OSC 52 from a pane, so emitting it directly works in both.
--
-- Copy only. OSC 52 reads make the terminal answer a query, which most
-- emulators refuse and which would stall every `p` under unnamedplus, so
-- paste comes from the unnamed register and the terminal's own paste
-- (ctrl+shift+v) brings the host clipboard back in.
local function has_local_clipboard()
  if vim.fn.has("mac") == 1 then
    return true
  end
  if vim.env.WAYLAND_DISPLAY ~= nil and vim.fn.executable("wl-copy") == 1 then
    return true
  end
  if vim.env.DISPLAY ~= nil and (vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1) then
    return true
  end
  return false
end

if not has_local_clipboard() then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste_from_unnamed()
    return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste_from_unnamed, ["*"] = paste_from_unnamed },
  }
end

-- Colorscheme is configured and applied in plugins/themes.lua (catppuccin's
-- config function, loaded with priority so it runs before other plugins).

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixWeirdCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl", "yaml", "yml" },
})

-- Neovim already detects Go templates as `gotexttmpl`/`gohtmltmpl`. gopls is
-- pointed at those filetypes in plugins/lsp.lua; here we just tell treesitter
-- to highlight text templates with the `gotmpl` parser.
vim.treesitter.language.register("gotmpl", { "gotexttmpl" })

-- The global conceallevel (2) hides JSON quotes/syntax. Turn conceal off for
-- JSON so it shows exactly as written, while keeping conceal elsewhere.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("JsonNoConceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})


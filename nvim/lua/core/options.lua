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

-- Colorscheme is configured and applied in plugins/themes.lua (catppuccin's
-- config function, loaded with priority so it runs before other plugins).

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixWeirdCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl", "yaml", "yml" },
})


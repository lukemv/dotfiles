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

-- Colorscheme is now loaded in plugins/themes.lua via the catppuccin config function
-- This was moved there to ensure the plugin is loaded before colorscheme configuration runs

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixWeirdCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl", "yaml", "yml" },
})


local opts = {
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  wrap = true,
  swapfile = false,
  termguicolors = true,
  number = true,
  relativenumber = true,
  conceallevel = 1,
  undofile = true,
  mouse = "",
  clipboard = "unnamedplus",
  backup = false,
  writebackup = false,
}

for opt, val in pairs(opts) do
  vim.o[opt] = val
end

local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixWeirdCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl", "yaml", "yml" },
})

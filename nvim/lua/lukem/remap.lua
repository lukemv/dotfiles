vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {noremap = true, silent = true})


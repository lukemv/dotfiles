local builtin = require('telescope.builtin')
-- pf: projects files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- cp: normal git search
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- ps: project search
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


local opts = {
	shiftwidth = 4,
	tabstop = 4,
	expandtab = true,
	wrap = false,
	swapfile = false,
	termguicolors = true,
	number = true,
	relativenumber = true,
}

-- Set options from table
for opt, val in pairs(opts) do
	vim.o[opt] = val
end

-- Set other options
local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)

-- Set commentstring for YAML files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "yml",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
})

-- Git related plugins
return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	{
		"tpope/vim-fugitive",
		config = function ()
			local map = require("helpers.keys").map
			-- TODO: Add fugitive keymaps here.
		end
	}
}

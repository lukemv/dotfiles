-- Miscelaneous fun stuff
return {
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
	-- Better buffer closing actions. Available via the buffers helper.
	{
		"kazhala/close-buffers.nvim",
		opts = {
			preserve_window_layout = { "this", "nameless" },
		},
	},
	"nvim-tree/nvim-web-devicons",
	"tpope/vim-sleuth",     -- Detect tabstop and shiftwidth automatically
	"tommcdo/vim-fubitive", -- Extend vim-fugitive to use bitbucket URL's
	"tpope/vim-commentary", -- Add comments and things
	"tpope/vim-surround",   -- Surround stuff with the ys-, cs-, ds- commands
	"vmware-archive/salt-vim", -- SaltStack development, syntax for salt files
	"mbbill/undotree",      -- Manages undo operations in the best way
}

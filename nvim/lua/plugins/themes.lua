-- Themes
return {
	"typicode/bg.nvim",
	"folke/tokyonight.nvim",
	"ellisonleao/gruvbox.nvim",

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000, -- load before other plugins so the colorscheme is applied first
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = false,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"rose-pine/nvim",
		name = "rose-pine",
	},

	"sainnhe/everforest",

	"savq/melange-nvim"
}

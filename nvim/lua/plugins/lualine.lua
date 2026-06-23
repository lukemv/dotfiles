-- Fancier statusline
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				-- "auto" derives the statusline palette from the active colorscheme,
				-- so it follows the catppuccin flavour and the light/dark toggle.
				theme = "auto",
				component_separators = "|",
				section_separators = "",
			},
		})
	end,
}

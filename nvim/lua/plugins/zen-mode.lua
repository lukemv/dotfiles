return {
	"folke/zen-mode.nvim",
	config = function()
		require("zen-mode").setup {
			window = {
				width = 1,
				height = 1,
			},
		}
	end,
}


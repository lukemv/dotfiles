return {
	"folke/zen-mode.nvim",
	config = function()
		require("zen-mode").setup {
			window = {
				backdrop = 1,
				width = 120,
				height = 0.8,
			},
		}
	end,
}


return {
	"folke/zen-mode.nvim",
	config = function()
		require("zen-mode").setup {
			window = {
				backdrop = 1,
				width = 1,
				height = 1,
			},
		}
	end,
}


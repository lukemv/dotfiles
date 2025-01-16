return {
	"folke/zen-mode.nvim",
	config = function()
		require("zen-mode").setup {
			window = {
				width = 0.85, -- width will always be 85% of the editor width
				height = 0.85, -- height will always be 85% of the editor height
			},
		}
	end,
}


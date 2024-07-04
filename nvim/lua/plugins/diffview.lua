return {
	-- View diffs in a nice way
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup()
	end,
}

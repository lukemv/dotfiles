return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>vv", function() require("neogit").open() end, desc = "Neogit (Status)" },
		{ "<leader>vc", function() require("neogit").open({ "commit" }) end, desc = "Neogit Commit" },
		{ "<leader>vp", function() require("neogit").open({ "pull" }) end, desc = "Neogit Pull" },
		{ "<leader>vP", function() require("neogit").open({ "push" }) end, desc = "Neogit Push" },
		{ "<leader>vl", function() require("neogit").open({ "log" }) end, desc = "Neogit Log" },
	},
	opts = {
		integrations = {
			diffview = false, -- prefer inline diffs over the heavy diffview UI
			telescope = true,
		},
		graph_style = "unicode",
		commit_editor = {
			kind = "tab",
		},
		mappings = {
			status = {
				-- j/k already navigate; <Tab> toggles diff; these make it more obvious
				["<c-j>"] = "GoToNextHunkHeader",
				["<c-k>"] = "GoToPreviousHunkHeader",
			},
		},
	},
}

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			spec = {
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Delete/Close" },
				{ "<leader>e", group = "Explore" },
				{ "<leader>f", group = "File" },
				{ "<leader>h", group = "Highlight" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>q", group = "Quit" },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Terminal/Toggle" },
				{ "<leader>u", group = "Undo Tree" },
				{ "<leader>v", group = "Version Control" },
				{ "<leader>x", group = "Trouble" },
				{ "<leader>z", group = "Zen" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
	},
}

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		config = function()
			local wk = require("which-key")
			wk.register(
				{
					["<leader>"] = {
						c = { name = "Code" },
						d = { name = "Delete/Close" },
						e = { name = "Explore" },
						f = { name = "File" },
						h = { name = "Highlight" },
						l = { name = "LSP" },
						q = { name = "Quit" },
						s = { name = "Search" },
						t = { name = "Terminal/Toggle" },
						u = { name = "Undo Tree" },
						v =	{ name = "Version Control" },
						x =	{ name = "Trouble" },
						z = { name = "Zen" },
					}
				}
			)
		end
	}
}


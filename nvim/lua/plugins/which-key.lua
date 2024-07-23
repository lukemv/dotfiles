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
						b = { name = "Debugging" },
						d = { name = "Delete/Close" },
						f = { name = "File" },
						g = { name = "Commentary" },
						l = { name = "LSP" },
						q = { name = "Quit" },
						s = { name = "Search" },
						u = { name = "Undo Tree" },
						v =	{ name = "Version Control" },
						x =	{ name = "Trouble" },
					}
				}
			)
		end
	}
}


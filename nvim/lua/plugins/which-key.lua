return {
	{
		"folke/which-key.nvim",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		config = function()
			local wk = require("which-key")
			wk.register(
				{
					["<leader>"] = {
						f = { name = "File" },
						c = { name = "ChatGPT" },
						d = { name = "Delete/Close" },
						q = { name = "Quit" },
						s = { name = "Search" },
						l = { name = "LSP" },
						u = { name = "Undo Tree" },
						b = { name = "Debugging" },
						g = { name = "Commentary" },
						t =	{ name = "Terminal" },
					}
				}
			)
		end
	}
}


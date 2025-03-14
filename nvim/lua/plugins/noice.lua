return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
	config = function()

		require("noice").setup({
			cmdline = {
				enabled = true,
				-- view for rendering the cmdline.
				-- Change to `cmdline` to get a classic
				-- cmdline at the bottom
				view = "cmdline_popup",
				opts = {}, -- global options for the cmdline. See section on views
				format = {
					-- title: set to anything or empty string to hide
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = {
							kind = "search",
							pattern = "^/",
							icon = " ",
							lang = "regex"
					},
					search_up = {
							kind = "search",
							pattern = "^%?",
							icon = " ",
							lang = "regex"
					},
					-- filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = {
							pattern = {
								"^:%s*lua%s+",
								"^:%s*lua%s*=%s*",
								"^:%s*=%s*"
							},
							icon = "",
							lang = "lua"
					},
					help = {
							pattern = "^:%s*he?l?p?%s+",
							icon = ""
					},
					input = {}, -- Used by input()
					-- lua = false, -- to disable a format, set to `false`
				},

			},

			messages = { enabled = false, },
			popupmenu = {
				enabled = true
			},
			signature = {
				enabled = true
			},
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split

				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})

	end,
}

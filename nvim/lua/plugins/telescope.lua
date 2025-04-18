-- Telescope fuzzy finding (all the things)
local actions = require('telescope.actions')
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires
			-- local dependencies to be built.
			-- Only load if `make` is available
			{ "nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = vim.fn.executable("make") == 1 },
		},
		config = function()

			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
						n = {
				      ["d"] = actions.delete_buffer
						}
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(telescope.load_extension, "fzf")
			local function set_find_command()
					return {
							"rg",
							"--files",
							"--hidden",
							"--iglob", "!.git/*",
							"--iglob", "!.venv/*",
							"--iglob", "!node_modules/*",
							"--follow"
					}
			end

			local map = require("helpers.keys").map
			map("n", "<leader>sr", require("telescope.builtin").oldfiles, "Search Recent Files")
			map("n", "<leader><space>", require("telescope.builtin").buffers, "Open buffers")
			map("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, "Search Current buffer")

			map("n", "<leader>sa", function()
					require("telescope.builtin").find_files({
							find_command = set_find_command(),
							no_ignore = true
					})
			end, "Search All Files")

			map("n", "<leader>sn", function()
				require("telescope.builtin").find_files({ search_dirs = { os.getenv("HOME") .. "/.notes" } })
			end, "Search Notes")

			-- I wasn't using this serch current word very often and I tend to take notes
			-- all day so this is better.
			map("n", "<leader>s.", function()
				require("telescope.builtin").live_grep({ search_dirs = { os.getenv("HOME") .. "/.notes" } })
			end, "Grep Notes")

			map("n", "<leader>s.", require("telescope.builtin").grep_string, "Search Current word")


			map("n", "<leader>s,", require("telescope.builtin").commands, "Search Commands")
			map("n", "<leader>s;", require("telescope.builtin").command_history, "Search Command History")
			map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Search Diagnostics")
			map("n", "<leader>sg", require("telescope.builtin").live_grep, "Search Grep")
			map("n", "<leader>sh", require("telescope.builtin").help_tags, "Search Help")
			map("n", "<leader>ss", require("telescope.builtin").git_status, "Search Git Status")
			-- Git stuff is hbre.
			map("n", "<leader>sb", require("telescope.builtin").git_bcommits, "Search Git Commits Buffer")
			map("n", "<leader>gl", require("telescope.builtin").git_commits, "Search Git Commits")

			map("n", "<C-p>", require("telescope.builtin").keymaps, "Search Keymaps")
		end,
	},
}

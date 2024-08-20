-- Telescope fuzzy finding (all the things)
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")

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

			-- map("n", "<leader>sf", require("telescope.builtin").find_files, "Files")
			map("n", "<leader>sf", function()
				require("telescope.builtin").git_files({ recurse_submodules = true, no_ignore = true })
			end, "Search Git Files")

			map("n", "<leader>sa", function()
				require("telescope.builtin").find_files({ recurse_submodules = true, hidden = true, no_ignore = true })
			end, "Search All Files")

			map("n", "<leader>s,", require("telescope.builtin").commands, "Search Commands")
			map("n", "<leader>s;", require("telescope.builtin").command_history, "Search Command History")
			map("n", "<leader>s.", require("telescope.builtin").grep_string, "Search Current word")
			map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Search Diagnostics")
			map("n", "<leader>sg", require("telescope.builtin").live_grep, "Search Grep")
			map("n", "<leader>sh", require("telescope.builtin").help_tags, "Search Help")
			map("n", "<leader>ss", require("telescope.builtin").git_stash, "Search Git Stash")
			-- Git stuff is here.
			map("n", "<leader>gb", require("telescope.builtin").git_bcommits, "Search Git Commits Buffer")
			map("n", "<leader>gl", require("telescope.builtin").git_commits, "Search Git Commits")

			map("n", "<C-p>", require("telescope.builtin").keymaps, "Search Keymaps")
		end,
	},
}

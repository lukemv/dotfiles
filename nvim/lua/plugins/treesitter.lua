-- Highlight, edit, and navigate code.
--
-- Both plugins track the `main` branch. The old `master` branch is frozen at
-- v0.10.0 and explicitly does not support Neovim 0.12 -- on 0.12 its injection
-- directives crash the highlighter ("attempt to call method 'range'"), because
-- a directive's `match` table now maps a capture to a *list* of nodes rather
-- than a single node.
--
-- `main` is a rewrite: there is no `.configs.setup{}`. Highlighting and indent
-- are enabled per-buffer via Neovim's own treesitter API, and
-- textobjects moved to an explicit-keymap API. Incremental selection was
-- dropped upstream entirely; it lives in `core.ts_incremental` now.
--
-- Requires `tree-sitter-cli` >= 0.26.1 on $PATH to build parsers.

local ENSURE_INSTALLED = {
	"c", "cpp", "go", "lua", "python", "rust", "vimdoc", "vim",
	-- `terraform` is a separate parser from `hcl`; .tf files use it.
	"hcl", "terraform",
	-- Go ecosystem (requested by go.nvim) + common formats
	"gomod", "gosum", "gowork", "gotmpl", "sql", "json", "comment",
	-- Parsers for the filetypes that used to come along for the ride via
	-- injections (markdown fences, shell scripts, config files).
	"markdown", "markdown_inline", "bash", "yaml", "toml", "diff", "query",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		-- `main` does not support lazy-loading, and its own docs say so.
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Async; a no-op for parsers that are already present.
			require("nvim-treesitter").install(ENSURE_INSTALLED)

			-- `main` ships no feature toggles -- highlight and indent are
			-- Neovim features we turn on per buffer. Keying off the parser
			-- rather than a filetype list means anything with an installed
			-- parser lights up, including filetypes registered elsewhere
			-- (see core/options.lua for gotmpl -> gotexttmpl).
			local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match)
					if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
						return
					end

					-- Treesitter indent is still flagged experimental upstream,
					-- and Python's is the usual offender -- keep the old opt-out.
					if ev.match ~= "python" then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			require("core.ts_incremental").setup({
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = "<c-s>",
				node_decremental = "<c-backspace>",
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
				},
				move = {
					set_jumps = true, -- whether to set jumps in the jumplist
				},
			})

			-- `main` sets no mappings of its own; each capture group is bound
			-- explicitly. These are the same keys the old `keymaps` tables had.
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- You can use the capture groups defined in textobjects.scm
			for lhs, capture in pairs({
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			}) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(capture, "textobjects")
				end, { desc = "Select " .. capture })
			end

			for lhs, spec in pairs({
				["]m"] = { move.goto_next_start, "@function.outer" },
				["]]"] = { move.goto_next_start, "@class.outer" },
				["]M"] = { move.goto_next_end, "@function.outer" },
				["]["] = { move.goto_next_end, "@class.outer" },
				["[m"] = { move.goto_previous_start, "@function.outer" },
				["[["] = { move.goto_previous_start, "@class.outer" },
				["[M"] = { move.goto_previous_end, "@function.outer" },
				["[]"] = { move.goto_previous_end, "@class.outer" },
			}) do
				local goto_fn, capture = spec[1], spec[2]
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					goto_fn(capture, "textobjects")
				end, { desc = "Go to " .. capture })
			end
		end,
	},
}

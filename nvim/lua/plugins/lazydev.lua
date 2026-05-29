-- Faster, smarter Lua LSP for editing Neovim config and plugins.
-- Replaces the archived neodev.nvim; configures lua_ls's library on the fly.
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}

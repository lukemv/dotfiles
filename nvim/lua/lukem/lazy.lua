local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ "sindrets/diffview.nvim" },
		{ "nvim-lua/plenary.nvim" },
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			config = function()
				local harpoon = require("harpoon")
				---@diagnostic disable-next-line: missing-parameter
				harpoon:setup()
				local function map(lhs, rhs, opts)
					vim.keymap.set("n", lhs, rhs, opts or {})
				end
				map("<leader>a", function()
					harpoon:list():append()
				end)
				map("<leader>h", function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end)
				map("<c-h><c-h>", function()
					harpoon:list():select(1)
				end)
				map("<c-h><c-j>", function()
					harpoon:list():select(2)
				end)
				map("<c-h><c-k>", function()
					harpoon:list():select(3)
				end)
				map("<c-h><c-l>", function()
					harpoon:list():select(4)
				end)
			end,
		},
		-- import any extras modules here
		-- { import = "lazyvim.plugins.extras.lang.typescript" },
		-- { import = "lazyvim.plugins.extras.lang.json" },
		-- { import = "lazyvim.plugins.extras.ui.mini-animate" },
		-- import/override with your plugins
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

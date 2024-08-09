return {
  'stevearc/conform.nvim',
  opts = {},
	setup = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				terraform = { "terraform_fmt" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		})
	end,
}
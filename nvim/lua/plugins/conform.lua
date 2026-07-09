return {
    'stevearc/conform.nvim',
    config = function()
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
                -- Go formatting (goimports includes gofmt)
                go = { "goimports", "gofumpt" },
                -- C / C++ (clang-format ships with the Mason clangd package,
                -- or install standalone via :MasonInstall clang-format)
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        })
    end,
}

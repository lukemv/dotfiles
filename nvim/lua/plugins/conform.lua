return {
    'stevearc/conform.nvim',
    -- No format_on_save: formatting is on demand only.
    keys = {
        {
            "<leader>fm",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = { "n", "v" },
            desc = "Format buffer/selection",
        },
    },
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
            -- No format_on_save: whole-file formatters (black/isort) blow up
            -- diffs. Format manually with <leader>f instead.
        })

        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            require("conform").format({ timeout_ms = 500, lsp_format = "fallback" })
        end, { desc = "Format buffer or selection" })
    end,
}

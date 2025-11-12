return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("go").setup({
      -- Disable lsp_cfg since we configure gopls in lsp.lua
      lsp_cfg = false,
      lsp_gofumpt = true,
      lsp_on_attach = nil, -- use the on_attach from lsp.lua

      -- Auto commands
      lsp_codelens = true,
      lsp_keymaps = false, -- use custom keymaps

      -- Formatting
      lsp_document_formatting = true,

      -- Import organization
      lsp_inlay_hints = {
        enable = true,
        only_current_line = false,
      },

      -- Diagnostics
      diagnostic = {
        hdlr = true,
        underline = true,
        virtual_text = { spacing = 0, prefix = '■' },
        signs = true,
        update_in_insert = false,
      },

      -- Test configuration
      run_in_floaterm = false,
      test_runner = 'go',

      -- DAP (debugging)
      dap_debug = true,
      dap_debug_gui = true,
      dap_debug_keymap = true,

      -- Misc
      trouble = true,
      luasnip = true,
    })

    -- Go-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Test commands
        vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>", vim.tbl_extend("force", opts, { desc = "Go test" }))
        vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFunc<cr>", vim.tbl_extend("force", opts, { desc = "Go test function" }))
        vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", vim.tbl_extend("force", opts, { desc = "Go coverage" }))

        -- Code generation
        vim.keymap.set("n", "<leader>gj", "<cmd>GoAddTag json<cr>", vim.tbl_extend("force", opts, { desc = "Add json tags" }))
        vim.keymap.set("n", "<leader>gy", "<cmd>GoAddTag yaml<cr>", vim.tbl_extend("force", opts, { desc = "Add yaml tags" }))
        vim.keymap.set("n", "<leader>gi", "<cmd>GoImpl<cr>", vim.tbl_extend("force", opts, { desc = "Implement interface" }))
        vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<cr>", vim.tbl_extend("force", opts, { desc = "Add if err" }))

        -- Navigation
        vim.keymap.set("n", "<leader>gd", "<cmd>GoDoc<cr>", vim.tbl_extend("force", opts, { desc = "Go doc" }))
        vim.keymap.set("n", "<leader>gf", "<cmd>GoFillStruct<cr>", vim.tbl_extend("force", opts, { desc = "Fill struct" }))

        -- Debugging
        vim.keymap.set("n", "<leader>gb", "<cmd>GoBreakToggle<cr>", vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
        vim.keymap.set("n", "<leader>gD", "<cmd>GoDebug<cr>", vim.tbl_extend("force", opts, { desc = "Start debug" }))
      end,
    })
  end,
  event = {"CmdlineEnter"},
  ft = {"go", 'gomod'},
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}

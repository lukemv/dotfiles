return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ["<C-h>"] = false,
      ["<C-j>"] = false,
      ["<C-k>"] = false,
      ["<C-l>"] = false,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Rebind window navigation for oil buffers only
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        local map = function(lhs, rhs)
          vim.keymap.set("n", lhs, rhs, { buffer = true, noremap = true, silent = true })
        end
        map("<C-h>", "<C-w>h")
        map("<C-j>", "<C-w>j")
        map("<C-k>", "<C-w>k")
        map("<C-l>", "<C-w>l")
      end,
    })
  end,
}


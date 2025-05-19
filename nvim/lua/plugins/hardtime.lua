-- plugins/hardtime.lua
return {
  "m4xshen/hardtime.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = {
    enabled = true,
    max_count = 3,
    disable_mouse = false,
    restriction_mode = "block", -- can be "block" or "hint"
    notification = true,
    hint = true,
    allow_different_key = true,
    restricted_keys = {
      ["<Up>"] = { "n", "x" },
      ["<Down>"] = { "n", "x" },
      ["<Left>"] = { "n", "x" },
      ["<Right>"] = { "n", "x" },
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["l"] = { "n", "x" },
      ["w"] = { "n", "x" },
      ["b"] = { "n", "x" },
    },
    disabled_filetypes = {
      "neo-tree",
      "lazy",
      "mason",
      "help",
      "qf",
      "netrw",
      "oil",
    },
  },
}

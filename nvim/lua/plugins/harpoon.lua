return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
   },
  config = function ()
    local harpoon = require('harpoon')
    harpoon:setup({})
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local make_finder = function()
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end
        return  require("telescope.finders").new_table({
          results = file_paths,
        })
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = make_finder(),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_buffer_number, map)
          map("i", "<C-d>", function()
            local state = require("telescope.actions.state")
            local selected_entry = state.get_selected_entry()
            local current_picker = state.get_current_picker(prompt_buffer_number)

            harpoon:list():remove_at(selected_entry.index)
            current_picker:refresh(make_finder())
            -- current_picker:set_selection(selected_entry.index)
            print("Removed from Harpoon")
          end)
          return true
        end,
      }):find()
    end

    local map = require("helpers.keys").map

    map("n", "<leader>jl", function()
      toggle_telescope(harpoon:list())
    end, "Harpoon List")

    map("n", "<leader>ja", function()
      harpoon:list():add()
      print("Added to Harpoon")
    end, "Harpoon Add")
  end,
}

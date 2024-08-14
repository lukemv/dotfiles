return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		-- REQUIRED
		harpoon:setup()

		local hadd = function()
				harpoon:list():add()
				local bufId = vim.api.nvim_buf_get_name(0)
				print("∙∙·▫▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ▫ₒₒ▫ᵒᴼᵒ☼)==> ", bufId)
		end

		vim.keymap.set("n", "<leader>a", hadd)

		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		-- I only keep 3 buffers in my list of harpoonable things
		-- If there are more than 3 things I find another way
		vim.keymap.set("n", "<S-h>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<S-j>", function() harpoon:list():select(2) end)
		-- Shift K is used to inspect the tag under the cursor
		vim.keymap.set("n", "<S-l>", function() harpoon:list():select(3) end)
		-- Toggle previous & next buffers stored within Harpoon list
		-- vim.keymap.set("n", "<S-h>", function() harpoon:list():prev() end)
		-- vim.keymap.set("n", "<S-l>", function() harpoon:list():next() end)
	end
}

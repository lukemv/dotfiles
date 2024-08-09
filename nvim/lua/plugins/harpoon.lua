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

		-- Note: I can't seem to find good keys for these :D
		vim.keymap.set("n", "<S-h>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<S-j>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<S-k>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<S-l>", function() harpoon:list():select(4) end)
		-- Toggle previous & next buffers stored within Harpoon list
		-- vim.keymap.set("n", "<S-h>", function() harpoon:list():prev() end)
		-- vim.keymap.set("n", "<S-l>", function() harpoon:list():next() end)
	end
}

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 100,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
		  on_attach = function(bufnr)
			local gitsigns = require('gitsigns')

			local map = require("helpers.keys").map

			-- Navigation
			map('n', ']c', function()
			  if vim.wo.diff then
				vim.cmd.normal({']c', bang = true})
			  else
				gitsigns.nav_hunk('next')
			  end
			end)

			map('n', '[c', function()
			  if vim.wo.diff then
				vim.cmd.normal({'[c', bang = true})
			  else
				gitsigns.nav_hunk('prev')
			  end
			end)

			-- Hunk-level operations (inline, at cursor)
			map('n', '<leader>vs', gitsigns.stage_hunk, "Stage hunk")
			map('n', '<leader>vr', gitsigns.reset_hunk, "Reset hunk")
			map('v', '<leader>vs', function() gitsigns.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, "Stage hunk")
			map('v', '<leader>vr', function() gitsigns.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, "Reset hunk")
			map('n', '<leader>vh', gitsigns.preview_hunk, "Preview hunk")
			map('n', '<leader>vR', gitsigns.reset_buffer, "Reset buffer")
			map('n', '<leader>vS', gitsigns.stage_buffer, "Stage buffer")
			map('n', '<leader>vb', gitsigns.toggle_current_line_blame, "Git Blame Toggle")
			map('n', '<leader>td', gitsigns.toggle_deleted, "Toggle deleted")

			-- Text object
			-- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		  end
		})
	end,
}

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
		  on_attach = function(bufnr)
			local gitsigns = require('gitsigns')
			gitsigns.setup({
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 100,
					ignore_whitespace = false,
					virt_text_priority = 100,
				}
			})

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

			map('n', '<leader>hr', gitsigns.reset_hunk, "Reset hunk")
			map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Stage hunk")
			map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Reset hunk")
			map('n', '<leader>hS', gitsigns.stage_buffer, "Stage buffer")
			map('n', '<leader>hu', gitsigns.undo_stage_hunk, "Undo stage hunk")
			map('n', '<leader>hR', gitsigns.reset_buffer, "Reset buffer")
			map('n', '<leader>hp', gitsigns.preview_hunk, "Preview hunk")
			map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, "Blame line")
			map('n', '<leader>tb', gitsigns.toggle_current_line_blame, "Toggle blame line")
			map('n', '<leader>hd', gitsigns.diffthis, "Diff this")
			map('n', '<leader>hD', function() gitsigns.diffthis('~') end, "Diff this (cached)")
			map('n', '<leader>td', gitsigns.toggle_deleted, "Toggle deleted")


			-- Text object
			map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		  end
		})
	end,
}

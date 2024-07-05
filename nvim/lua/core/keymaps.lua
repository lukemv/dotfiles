local map = require("helpers.keys").map

-- Blazingly fast way out of insert mode
map("i", "jk", "<esc>")

map("n", "<leader>rc", ":source %<CR>", "Source current file")
map("n", "<leader>tm", ":terminal<CR>:file ", "New named terminal")
map('n', "<leader>cp", ":let @\" = expand('%')<CR>", "Copy current path into buffer")

-- Quick access to some common actions
map("n", "<leader>fw", "<cmd>w<cr>", "Write")
map("n", "<leader>dw", "<cmd>close<cr>", "Close Window")
-- map("n", "<leader>fa", "<cmd>wa<cr>", "Write all")
map("n", "<leader>qq", "<cmd>q!<cr>", "Quit")
-- map("n", "<leader>qa", "<cmd>qa!<cr>", "Quit all")

-- Diagnostic keymaps
-- map('n', 'gx', vim.diagnostic.open_float, "Show diagnostics under cursor")

map("n", "<leader>e", ":Explore<CR>", "Vim file explorer")
-- Easier access to beginning and end of lines
-- LM: This doens't seem to work for me, perhaps there's
-- some sort of tmux escape sequence that's killing me.
map("n", "<M-h>", "^", "Go to beginning of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Better window navigation
-- LM: I probably can't live without these.
map("n", "<C-h>", "<C-w><C-h>", "Navigate windows to the left")
map("n", "<C-j>", "<C-w><C-j>", "Navigate windows down")
map("n", "<C-k>", "<C-w><C-k>", "Navigate windows up")
map("n", "<C-l>", "<C-w><C-l>", "Navigate windows to the right")

-- Move with shift-arrows
map("n", "<S-Left>", "<C-w><S-h>", "Move window to the left")
map("n", "<S-Down>", "<C-w><S-j>", "Move window down")
map("n", "<S-Up>", "<C-w><S-k>", "Move window up")
map("n", "<S-Right>", "<C-w><S-l>", "Move window to the right")

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Deleting buffers
local buffers = require("helpers.buffers")
map("n", "<leader>db", buffers.delete_this, "Current buffer")
map("n", "<leader>do", buffers.delete_others, "Other buffers")
map("n", "<leader>da", buffers.delete_all, "All buffers")

-- Diff binds
map("n", "<leader>vo", ":DiffviewOpen<CR>", "Diffview Open")
map("n", "<leader>vc", ":DiffviewClose<CR>", "Diffview Close")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Switch between light and dark modes
map("n", "<leader>ut", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end, "Toggle between light and dark themes")

-- Clear after search
map("n", "<leader>ur", "<cmd>nohl<cr>", "Clear highlights")

-- Terminal mappings
-- LM: This one doesn't work, it keeps opening a new terminal
-- randomly, I'll leave it commented out until I figure out what it's clashing with
-- map("n", "<C-m>", ":terminal<CR>", "Terminal Start")
map("t", "<Esc>", "<C-\\><C-n>", "Terminal Exit")

map("n", "<leader>u", ":UndotreeToggle<CR>", "Undotree Toggle")
map("n", "<leader>e", ":NvimTreeToggle<CR>", "NvimTree Toggle")

map("n", "<leader>gcom", ":Git commit<CR>", "Git Commit")
map("n", "<leader>gpf", ":Git push<CR>", "Git Commit")
map("n", "<leader>gs", ":Git status<CR>", "Git Status")


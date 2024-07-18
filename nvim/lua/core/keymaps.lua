local map = require("helpers.keys").map

-- Blazingly fast way out of insert mode
map("i", "jk", "<esc>")
-- Terminal mappings
-- LM: This one doesn't work, it keeps opening a new terminal
-- randomly, I'll leave it commented out until I figure out what it's clashing with
-- map("n", "<C-m>", ":terminal<CR>", "Terminal Start")
map("t", "<Esc>", "<C-\\><C-n>", "Terminal Exit")

map("t", "jk", "<C-\\><C-n>", "Terminal Escape")

map("n", "<leader>rc", ":source %<CR>", "Source current file")
map('n', "<leader>cp", ":let @+ = expand('%')<CR>", "Copy current path into clipboard")

map("n", "<leader>tt", ":terminal<CR>:file t-", "New named terminal")

-- Diagnostic keymaps
-- map('n', 'gx', vim.diagnostic.open_float, "Show diagnostics under cursor")
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

-- Navigate to other windows straight out of terminal insert mode
map("t", "<C-h>", "<C-\\><C-n><C-w><C-h>", "Terminal Escape and navigate to window left")
map("t", "<C-l>", "<C-\\><C-n><C-w><C-l>", "Terminal Escape and navigate windows right")
map("t", "<C-j>", "<C-\\><C-n><C-w><C-j>", "Terminal Escape and navigate to window down")
map("t", "<C-k>", "<C-\\><C-n><C-w><C-k>", "Terminal Escape and navigate windows up")

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
--
-- Deleting buffers
local buffers = require("helpers.buffers")
map("n", "<leader>db", buffers.delete_this, "Current buffer")
map("n", "<leader>do", buffers.delete_others, "Other buffers")
map("n", "<leader>da", buffers.delete_all, "All buffers")

local function write_and_delete()
  vim.cmd('w')
  buffers.delete_this()
end

-- Quick access to some common actions
map("n", "<leader>fw", "<cmd>w<cr>", "File Write")
-- Map the <leader>fe to the write_and_delete function
map('n', '<leader>fd', write_and_delete, "Write and exit")
map("n", "<leader>dw", "<cmd>close<cr>", "Close Window")
map("n", "<leader>fa", "<cmd>wa<cr>", "Write all")
map("n", "<leader>qq", "<cmd>q!<cr>", "Quit")
map("n", "<leader>qa", "<cmd>qa!<cr>", "Quit all")

-- Diff binds
local function toggle_diffview()
  if next(require('diffview.lib').views) == nil then
    vim.cmd('DiffviewOpen')
  else
    vim.cmd('DiffviewClose')
  end
end

-- Git workflow, it's not the most efficient but it
-- works for me
map("n", "<leader>vv", toggle_diffview, "Diffview Toggle")
map("n", "<leader>vc", ":Git commit<CR>", "Git Commit")

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

map("n", "<leader>u", ":UndotreeToggle<CR>", "Undotree Toggle")
map("n", "<leader>e", ":NvimTreeToggle<CR>", "NvimTree Toggle")



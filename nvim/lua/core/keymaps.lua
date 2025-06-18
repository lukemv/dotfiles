local map = require("helpers.keys").map

-- This is an addictive way of exiting insert mode.
map("i", "jk", "<esc>")

-- Terminal mappings
map("t", "<Esc>", "<C-\\><C-n>", "Terminal Exit")
map("t", "jk", "<C-\\><C-n>", "Terminal Escape")
-- Diagnostic keymaps
-- map('n', 'gx', vim.diagnostic.open_float, "Show diagnostics under cursor")

map("n", "<leader>|", "<cmd>vsplit<cr>", "Split Vertically")
map("n", "<leader>-", "<cmd>split<cr>", "Split Horizontally")

-- Zoomies
map('n', '<leader>z', ':ZenMode<CR>')

-- O is for 'Obsidian'
map('n', '<leader>ot', '<cmd>ObsidianToday<cr>', "Obsidian Today")
map('n', '<leader>oy', '<cmd>ObsidianYesterday<cr>', "Obsidian Yesterday")
map('n', '<leader>os', '<cmd>ObsidianSearch<cr>', "Obsidian Search")
map('n', '<leader>oi', '<cmd>ObsidianTemplate<cr>', "Obsidian Template")

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
map("n", "<leader>db", buffers.delete_this, "Delete Current buffer")
map("n", "<leader>do", buffers.delete_others, "Delete Other buffers")
map("n", "<leader>da", buffers.delete_all, "Delete All buffers")
map("n", "<leader>dw", "<cmd>close<cr>", "Close Window")

-- Quick access to some common actions
map("n", "<leader>fw", "<cmd>w<cr>", "File Write")
-- I never use this one, I should probably delete it.
local function write_and_delete()
  vim.cmd('w')
  buffers.delete_this()
end
map('n', '<leader>fv', "<cmd>wq!<cr>", "File Write & Quit (Save and Quit)")
map('n', '<leader>fd', write_and_delete, "File Write & Exit")
map("n", "<leader>fa", "<cmd>wa<cr>", "File Write all")
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

map("n", "<leader>vv", toggle_diffview, "Diffview Toggle")
map("n", "<leader>vc", ":Git commit<CR>", "Git Commit")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- File navigation is linked to 'e' for 'explore'
map("n", "<leader>eo", "<cmd>Oil .<cr>", "Oil Open")
map("n", "-", "<cmd>Oil<cr>", "Oil Open Parent")
map("n", "<leader>et", ":NvimTreeToggle<CR>", "NvimTree Toggle")

-- 'u' is linked to Undo tree
map("n", "<leader>u", ":UndotreeToggle<CR>", "Undotree Toggle")
--
-- Keybinds that don't really follow a good convention
map("n", "<leader>t", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  if buftype == "terminal" then
    -- In a terminal buffer: open new terminal in the same local cwd
    local term_cwd = vim.fn.getcwd(0)
    vim.cmd("tcd " .. term_cwd)
    vim.cmd("terminal")
  elseif bufname ~= "" then
    -- In a file buffer: open terminal in file's directory
    local dir = vim.fn.fnamemodify(bufname, ":p:h")
    vim.cmd("tcd " .. dir)
    vim.cmd("terminal")
  else
    -- In a non-file, non-terminal buffer: open terminal in global cwd
    vim.cmd("terminal")
  end
end, "Open terminal in file/terminal's directory or cwd")
map('n', "<leader>cp", ":let @+ = expand('%')<CR>", "Copy current path into clipboard")

-- Clear after search
map("n", "<leader>hl", "<cmd>nohl<cr>", "Clear highlights")
-- Switch between light and dark modes
map("n", "<leader>ut", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end, "Toggle between light and dark themes")

map('n', '<leader>gpp', "<cmd>GpChatNew<cr>", "GPT Chat New")
map('n', '<leader>gpd', "<cmd>GpChatDelete<cr>", "GPT Chat Delete")

map('n', '<leader>p', '"0p')
map('n', '<leader>P', '"0P')


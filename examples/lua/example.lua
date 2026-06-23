-- Lua playground — lua_ls LSP (lazydev provides the Neovim API), stylua format.
-- Try: `K` to hover, `gd` on greet, `<leader>ff` to format. Type `vim.` to see
-- Neovim API completion (thanks to lazydev).
local M = {}

---@param name string
---@param age integer
---@return string
function M.greet(name, age)
	return string.format("Hello, %s! You are %d.", name, age)
end

function M.main()
	print(M.greet("Luke", 30))
end

return M

-- Treesitter incremental selection.
--
-- nvim-treesitter's `main` branch dropped `incremental_selection` along with
-- the rest of the `configs.setup{}` API, and Neovim has no built-in
-- equivalent, so the feature is reimplemented here on top of the core
-- `vim.treesitter` API. Behaviour matches the old plugin: start from the node
-- under the cursor, grow to the parent, jump out to the enclosing scope, or
-- walk back down the way you came.
--
-- Wired up from plugins/treesitter.lua.

local M = {}

-- Selection history per buffer, so decrementing can retrace exactly the nodes
-- that were grown through rather than guessing at a child.
---@type table<integer, TSNode[]>
local stack = {}

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	group = vim.api.nvim_create_augroup("UserTSIncremental", { clear = true }),
	callback = function(ev)
		stack[ev.buf] = nil
	end,
})

---Visually select `node`, replacing any selection already active.
---@param bufnr integer
---@param node TSNode
local function set_selection(bufnr, node)
	local srow, scol, erow, ecol = node:range()

	-- Treesitter end columns are exclusive; Vim's visual selection is
	-- inclusive. A zero end column means the node stops at the line break,
	-- so it really ends at the end of the previous line.
	if ecol == 0 then
		erow = erow - 1
		ecol = #(vim.api.nvim_buf_get_lines(bufnr, erow, erow + 1, false)[1] or "")
	end
	ecol = math.max(ecol - 1, 0)

	-- Drop out of any current visual mode first, otherwise the cursor moves
	-- below extend the old selection instead of starting a new one.
	if vim.fn.mode():match("^[vV\22]") then
		vim.cmd("normal! \27")
	end

	vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { erow + 1, ecol })
end

---Smallest `@local.scope` from the locals query that strictly contains `node`.
---@param bufnr integer
---@param node TSNode
---@return TSNode|nil
local function enclosing_scope(bufnr, node)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then
		return nil
	end

	-- Query the language tree that actually owns the node, so scopes still
	-- resolve inside injections (a Lua block in a markdown fence, say).
	local langtree = parser:language_for_range({ node:range() }) or parser
	local query = vim.treesitter.query.get(langtree:lang(), "locals")
	local tree = langtree:trees()[1]
	if not query or not tree then
		return nil
	end

	local target = { node:range() }
	local best ---@type TSNode|nil

	for id, candidate in query:iter_captures(tree:root(), bufnr, 0, -1) do
		if query.captures[id] == "local.scope" then
			local range = { candidate:range() }
			-- Strictly larger, so repeated presses keep making progress.
			if vim.treesitter.node_contains(candidate, target) and not vim.deep_equal(range, target) then
				if not best or vim.treesitter.node_contains(best, range) then
					best = candidate
				end
			end
		end
	end

	return best
end

---@return integer bufnr, TSNode[] nodes
local function current(bufnr)
	stack[bufnr] = stack[bufnr] or {}
	return stack[bufnr]
end

function M.init_selection()
	local bufnr = vim.api.nvim_get_current_buf()

	-- `vim.treesitter.get_node` reads the existing tree rather than building
	-- one, and returns nil if nothing has parsed the buffer yet, so make sure
	-- there is a tree to look at first.
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then
		return
	end
	parser:parse(true)

	local node = vim.treesitter.get_node()
	if not node then
		return
	end

	stack[bufnr] = { node }
	set_selection(bufnr, node)
end

function M.node_incremental()
	local bufnr = vim.api.nvim_get_current_buf()
	local nodes = current(bufnr)
	if #nodes == 0 then
		return M.init_selection()
	end

	local node = nodes[#nodes]

	-- Skip ancestors that span exactly the same text, otherwise a press can
	-- look like it did nothing.
	local parent = node:parent()
	while parent and vim.deep_equal({ parent:range() }, { node:range() }) do
		parent = parent:parent()
	end

	if not parent then
		return
	end

	table.insert(nodes, parent)
	set_selection(bufnr, parent)
end

function M.scope_incremental()
	local bufnr = vim.api.nvim_get_current_buf()
	local nodes = current(bufnr)
	if #nodes == 0 then
		return M.init_selection()
	end

	local scope = enclosing_scope(bufnr, nodes[#nodes])
	if not scope then
		return
	end

	table.insert(nodes, scope)
	set_selection(bufnr, scope)
end

function M.node_decremental()
	local bufnr = vim.api.nvim_get_current_buf()
	local nodes = current(bufnr)
	if #nodes < 2 then
		return
	end

	table.remove(nodes)
	set_selection(bufnr, nodes[#nodes])
end

---@param keys table<string, string> the old `incremental_selection.keymaps` table
function M.setup(keys)
	-- init_selection starts from normal mode; the rest continue an active
	-- selection, which is how init and node_incremental can share a key.
	vim.keymap.set("n", keys.init_selection, M.init_selection, { desc = "Init treesitter selection" })
	vim.keymap.set("x", keys.node_incremental, M.node_incremental, { desc = "Increment node selection" })
	vim.keymap.set("x", keys.scope_incremental, M.scope_incremental, { desc = "Increment scope selection" })
	vim.keymap.set("x", keys.node_decremental, M.node_decremental, { desc = "Decrement node selection" })
end

return M

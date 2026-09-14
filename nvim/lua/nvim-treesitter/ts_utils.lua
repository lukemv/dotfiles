-- Compatibility shim for `nvim-treesitter.ts_utils`.
--
-- nvim-treesitter's `main` branch removed this module, but go.nvim still
-- requires it unconditionally -- GoIfErr, GoAddTag, GoFillStruct, GoImpl and
-- the Go comment handling all fail to load without it. Rather than pin
-- nvim-treesitter to a branch that crashes on Neovim 0.12, the handful of
-- functions go.nvim actually calls are reimplemented here on top of the core
-- `vim.treesitter` API, matching the old semantics.
--
-- This resolves ahead of the plugin because ~/.config/nvim is first on
-- 'runtimepath'. It deliberately defines no `init.lua`, so `require
-- 'nvim-treesitter'` itself still reaches the real plugin.
--
-- Drop this file once go.nvim supports nvim-treesitter `main`.

local M = {}

---True if `dest` is `source` or one of its ancestors.
---@param dest TSNode|nil
---@param source TSNode|nil
---@return boolean
function M.is_parent(dest, source)
	if not (dest and source) then
		return false
	end

	local current = source
	while current ~= nil do
		if current == dest then
			return true
		end
		current = current:parent()
	end

	return false
end

---Next named sibling of `node`.
---@param node TSNode
---@param allow_switch_parents? boolean descend into the parent's next sibling if `node` is last
---@param allow_next_parent? boolean fall back to that next sibling itself if it has no children
---@return TSNode|nil
function M.get_next_node(node, allow_switch_parents, allow_next_parent)
	local destination_node ---@type TSNode|nil
	local parent = node:parent()
	if not parent then
		return nil
	end

	local found_pos = 0
	for i = 0, parent:named_child_count() - 1, 1 do
		if parent:named_child(i) == node then
			found_pos = i
			break
		end
	end

	if parent:named_child_count() > found_pos + 1 then
		destination_node = parent:named_child(found_pos + 1)
	elseif allow_switch_parents then
		local next_node = M.get_next_node(parent)
		if next_node and next_node:named_child_count() > 0 then
			destination_node = next_node:named_child(0)
		elseif next_node and allow_next_parent then
			destination_node = next_node
		end
	end

	return destination_node
end

---Smallest named node at the cursor.
---@param winnr? integer
---@return TSNode|nil
function M.get_node_at_cursor(winnr)
	winnr = winnr or 0
	local cursor = vim.api.nvim_win_get_cursor(winnr)
	local bufnr = vim.api.nvim_win_get_buf(winnr)

	return vim.treesitter.get_node({
		bufnr = bufnr,
		pos = { cursor[1] - 1, cursor[2] },
	})
end

---Convert a 0-indexed, end-exclusive treesitter range to a 1-indexed Vim range.
---@param range integer[] {start_row, start_col, end_row, end_col}
---@param buf? integer
---@return integer srow, integer scol, integer erow, integer ecol
function M.get_vim_range(range, buf)
	---@type integer, integer, integer, integer
	local srow, scol, erow, ecol = unpack(range)
	srow = srow + 1
	scol = scol + 1
	erow = erow + 1

	if ecol == 0 then
		-- Use the value of the last col of the previous row instead.
		erow = erow - 1
		if not buf or buf == 0 then
			ecol = vim.fn.col({ erow, "$" }) - 1
		else
			ecol = #(vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1] or "")
		end
		ecol = math.max(ecol, 1)
	end

	return srow, scol, erow, ecol
end

---@param node TSNode
---@return table LSP Range
function M.node_to_lsp_range(node)
	local start_line, start_col, end_line, end_col = vim.treesitter.get_node_range(node)
	return {
		start = { line = start_line, character = start_col },
		["end"] = { line = end_line, character = end_col },
	}
end

return M

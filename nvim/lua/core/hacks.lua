-- Define blacklist as patterns, not exact strings
local blacklist_patterns = {
  "^push.+$",
  "^file.+$",   -- Matches any command starting with "file"
}

vim.api.nvim_create_user_command("FixHistory", function()
  vim.cmd("rshada")  -- Load saved command history

  local removed = {}

  for i = vim.fn.histnr(':') - 1, 1, -1 do
    local cmd = vim.fn.histget(':', i)
    for _, pattern in ipairs(blacklist_patterns) do
      if string.match(cmd, pattern) then
        vim.fn.histdel(':', i)
        removed[pattern] = true
        break
      end
    end
  end

  vim.cmd("wshada!")  -- Save cleaned history

  local patterns_removed = {}
  for pattern, _ in pairs(removed) do
    table.insert(patterns_removed, pattern)
  end

  if #patterns_removed > 0 then
    print("🧹 Removed commands matching: " .. table.concat(patterns_removed, ", "))
  else
    print("✅ History is already clean.")
  end
end, {})


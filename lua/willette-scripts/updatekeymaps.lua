local M = {}

---Escape hyphens for gsub pattern matching
---@param text string Text to escape
---@return string escaped Escaped text
local function escape_hyphen_for_gsub(text)
  return text:gsub("%-", "%%-")
end

---Update a keymap definition to use a named key from keymaps table
---Used for refactoring keymap definitions in neovim config
function M.update_keymap()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line, end_line = start_pos[2], end_pos[2]

  local lines = vim.fn.getline(start_line, end_line)
  if type(lines) == "string" then
    lines = { lines }
  end

  local keymap_lhs
  for _, line in ipairs(lines) do
    if line:find('vim.keymap.set') then
      keymap_lhs = line:match('vim.keymap.set%(".*",%s*"(.-)"')
      break
    end
  end

  if not keymap_lhs then
    vim.notify("No keymap lhs found in the highlighted text.", vim.log.levels.WARN)
    return
  end

  local new_key_description = vim.fn.input("Enter the keymap description: ")
  if not new_key_description or new_key_description == "" then
    return
  end

  local buffer = vim.fn.bufnr('%')
  local found_line = false
  local keymap_inserted = false
  local buf_lines = vim.fn.getbufline(buffer, 1, '$')

  for line_num, line in ipairs(buf_lines) do
    if line:find('^local keymaps =') then
      found_line = true
    end
    if found_line and line:find('^}') then
      vim.fn.append(line_num - 1, string.format('  ["%s"] = "%s",', new_key_description, keymap_lhs))
      keymap_inserted = true

      -- need to update start / end lines of keymap due to appended line above
      start_line = start_line + 1
      end_line = end_line + 1
      lines = vim.fn.getline(start_line, end_line)
      if type(lines) == "string" then
        lines = { lines }
      end
      break
    end
  end

  if not keymap_inserted then
    vim.notify("Failed to insert the new keymap. Make sure 'local keymaps =' table exists.", vim.log.levels.ERROR)
    return
  end

  -- Modify the highlighted lines with new keymap entry
  local pattern = 'vim.keymap.set%("n",%s*"' .. escape_hyphen_for_gsub(keymap_lhs) .. '"'
  local toreplace = 'vim.keymap.set("n", keymaps["' .. new_key_description .. '"]'
  for i, line in ipairs(lines) do
    lines[i], _ = line:gsub(pattern, toreplace)
  end

  vim.fn.setline(start_line, lines)

  vim.notify("Keymap updated successfully!", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('UpdateKeymap', M.update_keymap, { range = true })

return M

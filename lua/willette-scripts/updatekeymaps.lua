local M = {}

-- used for speeding up some maintenance on my neovim config
function M.update_keymap()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line, end_line = start_pos[2], end_pos[2]

  local lines = vim.fn.getline(start_line, end_line)

  local keymap_lhs
  for _, line in ipairs(lines) do
    if line:find('vim.keymap.set') then
      keymap_lhs = line:match('vim.keymap.set%("n",%s*"(.-)"')
      break
    end
  end

  if not keymap_lhs then
    print("No keymap lhs found in the highlighted text.")
    return
  end

  local new_key_description = vim.fn.input("Enter the keymap description: ")

  local buffer = vim.fn.bufnr('%')
  local found_line = false
  local keymap_inserted = false

  for line_num, line in ipairs(vim.fn.getbufline(buffer, 1, '$')) do
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
      break
    end
  end

  if not keymap_inserted then
    print("Failed to insert the new keymap.")
    return
  end

  -- Modify the highlighted lines with new keymap entry
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('vim.keymap.set%("n",%s*"' .. keymap_lhs .. '"',
      string.format('vim.keymap.set("n", keymaps["%s"]', new_key_description))
  end

  vim.fn.setline(start_line, lines)

  print("Keymap updated successfully!")
end

vim.api.nvim_create_user_command('UpdateKeymap', M.update_keymap, { range = true })

return M

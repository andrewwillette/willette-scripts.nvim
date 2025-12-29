local M = {}

local ws = require("willette-scripts")

---Open or create the diary entry for the current month
---Uses the diary_path from plugin config
---@return boolean success Whether the operation succeeded
---@return string|nil error Error message if failed
M.diary_entry = function()
  local diary_base = ws.config.diary_path
  local year = os.date("%Y")
  local month = os.date("%m")
  local year_path = diary_base .. "/" .. year
  local month_path = year_path .. "/" .. month
  local diary_file = month_path .. "/diary.md"

  -- If diary file exists, open it and return
  if vim.fn.filereadable(diary_file) == 1 then
    vim.cmd.edit(vim.fn.fnameescape(diary_file))
    return true, nil
  end

  -- Create year directory if needed
  if vim.fn.isdirectory(year_path) == 0 then
    local ok = vim.fn.mkdir(year_path, "p")
    if ok == 0 then
      vim.notify("Error creating year directory: " .. year_path, vim.log.levels.ERROR)
      return false, "error creating year directory"
    end
  end

  -- Create month directory if needed
  if vim.fn.isdirectory(month_path) == 0 then
    local ok = vim.fn.mkdir(month_path, "p")
    if ok == 0 then
      vim.notify("Error creating month directory: " .. month_path, vim.log.levels.ERROR)
      return false, "error creating month directory"
    end
  end

  -- Create empty diary file
  local ok = vim.fn.writefile({}, diary_file)
  if ok == -1 then
    vim.notify("Error creating diary file: " .. diary_file, vim.log.levels.ERROR)
    return false, "error creating diary file"
  end

  vim.cmd.edit(vim.fn.fnameescape(diary_file))
  return true, nil
end

return M

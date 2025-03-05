local M = {}

M.diaryentry = function()
  local home = vim.fn.expand("$HOME")
  local year = os.date("%Y")
  local month = os.date("%m")
  local absolutepathyear = home .. "/git/diary_journal/" .. year
  local absolutepathmonth = absolutepathyear .. "/" .. month
  local absolutepathdiary = absolutepathmonth .. "/" .. "diary.md"
  local dailyfileexists = io.open(absolutepathdiary, "r")
  if dailyfileexists ~= nil then
    vim.cmd("e " .. absolutepathdiary)
    return nil, nil
  end

  local createyeardircmd = "mkdir -p " .. absolutepathyear
  local handle = io.popen(createyeardircmd)
  if handle == nil then
    print("error creating year directory: " .. createyeardircmd)
    return nil, "error creating year directory: " .. createyeardircmd
  end
  handle:close()
  local createmonthcmd = "mkdir -p " .. absolutepathmonth
  handle = io.popen(createmonthcmd)
  if handle == nil then
    print("error creating month directory: " .. createmonthcmd)
    return nil, "error creating month directory: " .. createmonthcmd
  end

  handle:close()
  local diaryfileb, diaryfileerr = io.open(absolutepathdiary, "wb")
  if diaryfileb == nil or diaryfileerr ~= nil then
    print("error opening diary file: " .. diaryfileerr)
    return nil, diaryfileerr
  end
  diaryfileb:close()
  vim.cmd("e " .. absolutepathdiary)
end

return M

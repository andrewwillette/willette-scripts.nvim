local M = {}

---@return string|nil date the date for the next occurrence of the provided weekday, or nil if an error occurs
---@return string|nil error message if the provided weekday is invalid, or nil otherwise
local nextdatefordayofweek = function(weekday)
  local today = os.date("*t")
  local day = 0
  if weekday == "Sunday" then
    day = 1
  elseif weekday == "Monday" then
    day = 2
  elseif weekday == "Tuesday" then
    day = 3
  elseif weekday == "Wednesday" then
    day = 4
  elseif weekday == "Thursday" then
    day = 5
  elseif weekday == "Friday" then
    day = 6
  elseif weekday == "Saturday" then
    day = 7
  else
    return nil, "invalid day of the week provided: " .. weekday
  end
  local daysuntilweekday = day - today.wday
  if daysuntilweekday < 0 then
    daysuntilweekday = daysuntilweekday + 7
  end
  local nextmeetingday = os.time { year = today.year, month = today.month, day = today.day + daysuntilweekday }
  ---@diagnostic disable-next-line: return-type-mismatch
  return os.date("%Y-%m-%d", nextmeetingday), nil
end

---@class WeeklyNoteConfig
---@field public meetingname string name of the weekly meeting, used in filename construction
---@field public directory string the location for the weekly meeting files to be stored
---@field public template string filepath to a "template" used for initializing new meeting notes
---@field public dayofweek string the day of the week the meeting is held, "Monday", "Tuesday", etc.

---open a weekly note
---@param wnc WeeklyNoteConfig
---@return string|nil error message if an error occurs, or nil otherwise
M.openweeklynote = function(wnc)
  local nextmeetingdate, err = nextdatefordayofweek(wnc.dayofweek)
  if err ~= nil or nextmeetingdate == nil then
    vim.notify("error getting next meeting date: " .. err)
    return err
  end
  nextmeetingdate = nextmeetingdate:gsub("-", "_")
  local filename = wnc.meetingname .. "_" .. nextmeetingdate .. ".md"
  local fileexists = io.open(wnc.directory .. "/" .. filename, "r")
  if fileexists ~= nil then
    vim.cmd("e " .. wnc.directory .. "/" .. filename)
    return nil
  end
  local file, fileerr = io.open(wnc.directory .. "/" .. filename, "wb")
  if file == nil or fileerr ~= nil then
    vim.notify("error opening weekly meeting notes new file: " .. fileerr)
    return fileerr
  end
  local templateFile, tmplErr = io.open(wnc.template, "rb")
  if templateFile == nil then
    vim.vim.notify("error opening weekly meeting notes template file: " .. tmplErr)
    return tmplErr
  end
  local templatecontent = templateFile:read("*all")
  file:write(templatecontent)
  file:close()
  vim.cmd("e " .. wnc.directory .. "/" .. filename)
end

return M

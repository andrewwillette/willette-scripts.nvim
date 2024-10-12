local M = {}

---@class KeyOfDay
---@field key string
---@field date os.time

local keys = {
  "A",
  "A#",
  "B",
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
}

local keyIndex0 = {
  key = keys[0],
  date = os.time({ year = 2024, month = 10, day = 8 }),
}

M.days_difference = function(epoch1, epoch2)
  local diff_in_seconds = os.difftime(epoch2, epoch1)
  local diff_in_days = math.floor(diff_in_seconds / (60 * 60 * 24))
  return diff_in_days + 1
end

M.keyIndex0 = keyIndex0

M.getdifferencewithmod = function(difference) return difference % 12 end

M.keyofday = function()
  local current_date = os.date("*t")
  current_date.hour = 0
  current_date.min = 0
  current_date.sec = 0
  local start_of_day = os.time(current_date)
  local daysdifference = M.days_difference(keyIndex0.date, start_of_day)
  local key = M.getdifferencewithmod(daysdifference)
  return keys[key + 1]
end

return M

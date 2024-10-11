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

local sept26th2024 = {
  key = keys[0],
  date = os.time({ year = 2024, month = 9, day = 26 }),
}

function days_difference(epoch1, epoch2)
  local diff_in_seconds = os.difftime(epoch2, epoch1)
  local diff_in_days = math.floor(diff_in_seconds / (60 * 60 * 24))
  return diff_in_days
end

M.keyofday = function(date)
  local daysdifference = days_difference(sept26th2024.date, date)
  local key = daysdifference % 12
  print("key number is " .. key)
  print("key of day is " .. keys[key])
  print("days difference is " .. daysdifference)
  return key
end

return M

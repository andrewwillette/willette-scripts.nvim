local M = {}

function days_difference(epoch1, epoch2)
  -- Calculate the difference in seconds
  local diff_in_seconds = os.difftime(epoch2, epoch1)

  -- Convert seconds to days (1 day = 86400 seconds)
  local diff_in_days = diff_in_seconds / (60 * 60 * 24)

  return diff_in_days
end

M.keyofday = function()
  --- Oct 8th is Key of A
  --- each day goes up chromatically a half step
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
  -- print("day of oct8 is " .. os.date("%d", oct8))
  local oct8 = os.date("*t", os.time({ year = 2024, month = 10, day = 8 }))
  local today = os.date("*t")
  print(today.day)
  -- print(oct8.day)
  local key = keys[today.day % 12 + 1]
  return key
end

return M

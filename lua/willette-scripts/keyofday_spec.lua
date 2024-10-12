local keyofday = require("willette-scripts.keyofday")

describe("keyofday", function()
  it("should return the key of the day", function()
    local current_time = os.date("*t")

    -- Set the time to the beginning of the day (00:00:00)
    current_time.hour = 0
    current_time.min = 0
    current_time.sec = 0
    local start_of_day = os.time(current_time)
    vim.print("start of day day is: " .. os.date("%Y-%m-%d %H:%M:%S", start_of_day))
    vim.print("start of day day is: " .. os.date("%Y-%m-%d %H:%M:%S", start_of_day))

    local key = keyofday.keyofday(start_of_day)
    vim.print(key)
  end)
end)

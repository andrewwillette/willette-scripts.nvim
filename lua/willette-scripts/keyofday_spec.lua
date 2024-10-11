local keyofday = require("willette-scripts.keyofday")

describe("keyofday", function()
  it("should return the key of the day", function()
    local oct10 = os.time({ year = 2024, month = 10, day = 10 })
    local key = keyofday.keyofday(os.time())
  end)
end)

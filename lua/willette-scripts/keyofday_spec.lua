local keyofday = require("willette-scripts.keyofday")

describe("keyofday", function()
  it("should return the key of the day", function()
    local key = keyofday.keyofday(os.time())
    print(key)
  end)
end)

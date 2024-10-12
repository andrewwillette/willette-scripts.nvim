local keyofday = require("willette-scripts.keyofday")

describe("keyofday", function()
  it("should return the key of the day", function()
    local key = keyofday.keyofday()
    vim.print(key)
  end)
end)

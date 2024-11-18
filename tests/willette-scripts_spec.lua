local willettescripts = require("willette-scripts")

describe("willette-scripts", function()
  it("verifynvimplugin returns true for plugin installed on filepath", function()
    local ok, _ = willettescripts.verifynvimplugin("willette-scripts")
    assert.truthy(ok)
  end)

  it("getgitrepobase returns repo name", function()
    reponame = willettescripts.getgitrepobase()
    print(reponame)
  end)
end)

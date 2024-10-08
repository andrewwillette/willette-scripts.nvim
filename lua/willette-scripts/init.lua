local M = {}

-- return table of split inputstr by sep
local function splitstring(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, { str })
  end
  return t
end

M.initsplitterm = function(cmd)
  vim.cmd("split|terminal " .. cmd)
  -- vim.cmd("split +terminal " .. cmd)
  vim.cmd("startinsert!")
end

M._setinteralgitfiles = function()
  local gitfiles = io.popen("ls \"$HOME/git\"")
  if gitfiles then
    local filesParsed = gitfiles:read("*a")
    M._gitFiles = splitstring(filesParsed, "%s")
  else
    print("failed to read git files at \"$HOME/git\"")
  end
end

-- verifynvimplugin return true if plugin available
M.verifynvimplugin = function(requireString)
  local ok, module = pcall(require, requireString)
  if not ok then
    print("Missing " .. requireString .. " plugin.")
    return false, nil
  end
  return true, module
end

-- verifyvimcommand return true if cmd is successful
M.verifyvimcommand = function(cmdString)
  if not pcall(vim.cmd, cmdString) then
    print("vim cmd failed: " .. cmdString)
    return false
  end
  return true
end

M.verifyvimplugin = function(requireString)
  local scripts = vim.api.nvim_exec("scriptnames", true)
  local scriptsSplit = vim.split(scripts, "\n")
  for _, v in pairs(scriptsSplit) do
    if v:find(requireString, 1, true) then
      return true
    end
  end
  print("Missing " .. requireString .. " plugin.")
  return false
end

local function trimFile(str, sep)
  sep = sep or '/'
  return str:match("(.*" .. sep .. ")")
end

M.oneoffterminal = function(tcmd)
  M.initsplitterm(tcmd)
end

local function get_current_buffer_directory()
  local curBuf = vim.api.nvim_buf_get_name(0)
  local curDir = trimFile(curBuf)
  return curDir
end

-- terminalBuffer create a termainal at the current buffers directory
M.terminalbuffer = function()
  local curDir = get_current_buffer_directory()
  M.initsplitterm("cd " .. curDir .. "; exec zsh")
end

-- terminalBuffer create a termainal at the current git root directory
-- works because of plugin managing cwd to be git root
M.terminalgit = function()
  M.initsplitterm("")
end

M.oneoffterminaltab = function(tcmd)
  vim.cmd("tabe |terminal " .. tcmd)
  vim.cmd("startinsert")
end

M.reloadmoduleinkeymaps = function()
  vim.ui.input({ prompt = "Lib to reload: " }, function(input)
    local escaped = vim.pesc(input)
    for k, _ in pairs(package.loaded) do
      if string.match(k, escaped) then
        print("Reloading package " .. k)
        package.loaded[k] = nil
        require(k)
      end
    end
    -- reload init.lua
    local hm = os.getenv("HOME")
    dofile(hm .. "/git/willette_terminal/.config/nvim/lua/keymappings.lua")
  end)
end

M.chmod0777currentbuf = function()
  local curBuf = vim.api.nvim_buf_get_name(0)
  vim.cmd("silent !cm7 " .. curBuf)
end

-- get base directory name of current git repo
M.getgitrepobase = function()
  local out = vim.api.nvim_exec("!basename `git rev-parse --show-toplevel`", true)
  local lines = {}
  for s in out:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  local reponame = lines[2]
  return reponame
end

return M

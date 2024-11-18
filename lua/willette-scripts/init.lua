local M = {}

-- return table of split inputstr by sep
---@diagnostic disable-next-line: unused-local, unused-function
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
  vim.cmd("startinsert!")
end

M.verifynvimplugin = function(module)
  local ok, requiredmodule = pcall(require, module)
  if not ok then
    print("Missing " .. module .. " plugin.")
    return false, nil
  end
  return true, requiredmodule
end

M.verifyvimcommand = function(vimcmd)
  if not pcall(vim.cmd, vimcmd) then
    print("vim cmd failed: " .. vimcmd)
    return false
  end
  return true
end

M.verifyvimplugin = function(requireString)
  local scripts = vim.cmd("scriptnames")
  local scriptsSplit = vim.split(scripts, "\n")
  for _, v in pairs(scriptsSplit) do
    if v:find(requireString, 1, true) then
      return true
    end
  end
  print("Missing " .. requireString .. " plugin.")
  return false
end

local function trimfile(str, sep)
  sep = sep or '/'
  return str:match("(.*" .. sep .. ")")
end

M.oneoffterminal = function(tcmd)
  M.initsplitterm(tcmd)
end

local function get_current_buffer_directory()
  local curbuf = vim.api.nvim_buf_get_name(0)
  local curdir = trimfile(curbuf)
  return curdir
end

-- terminalBuffer create a termainal at the current buffers directory
M.terminalbuffer = function()
  local curdir = get_current_buffer_directory()
  M.initsplitterm("cd " .. curdir .. "; exec zsh")
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
  local curbuf = vim.api.nvim_buf_get_name(0)
  vim.cmd("silent !cm7 " .. curbuf)
end

-- get base directory name of current git repo
M.getgitrepobase = function()
  local out = vim.cmd("!basename `git rev-parse --show-toplevel`")
  local lines = {}
  for s in out:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  local reponame = lines[2]
  return reponame
end

---@diagnostic disable-next-line: unused-function, unused-local
local function searchandreplace(filename, search_string, replacement)
  -- Read the file lines
  local file = io.open(filename, "r")
  if not file then
    print("Cannot open file: " .. filename)
    return
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  -- Find the line matching the search_string and replace the next line
  for i, line in ipairs(lines) do
    if line:find(search_string) then
      if i < #lines then
        lines[i + 1] = replacement
      end
      break
    end
  end

  -- Write the modified lines to a temporary file
  local tmp_filename = filename .. ".tmp"
  file = io.open(tmp_filename, "w")
  if not file then
    print("Cannot write to temporary file: " .. tmp_filename)
    return
  end

  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()

  os.remove(filename)
  os.rename(tmp_filename, filename)
end

return M

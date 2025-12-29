local M = {}

---@class WilletteScriptsConfig
---@field diary_path string? Path to diary directory
---@field keymaps_path string? Path to keymaps.lua file
---@field shell string? Shell to use for terminal commands

---@type WilletteScriptsConfig
M.config = {
  diary_path = vim.fn.expand("$HOME") .. "/git/diary_journal",
  keymaps_path = nil,
  shell = vim.env.SHELL or "zsh",
}

---Configure the plugin with custom options
---@param opts WilletteScriptsConfig?
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---Open a split terminal with optional command
---@param cmd string Command to run in terminal
---@return number bufnr The terminal buffer number
M.init_split_term = function(cmd)
  vim.cmd("split|terminal " .. cmd)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = bufnr,
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end,
  })
  vim.cmd("startinsert!")
  return bufnr
end

---Verify if a Lua plugin module is loaded
---@param module string Module name to check
---@return boolean ok Whether the module loaded successfully
---@return table|nil requiredmodule The loaded module or nil
M.verify_nvim_plugin = function(module)
  local ok, requiredmodule = pcall(require, module)
  if not ok then
    vim.notify("Missing " .. module .. " plugin.", vim.log.levels.WARN)
    return false, nil
  end
  return true, requiredmodule
end

---Verify if a vim command can execute
---@param vimcmd string Vim command to test
---@return boolean success Whether the command executed successfully
M.verify_vim_command = function(vimcmd)
  if not pcall(vim.cmd, vimcmd) then
    vim.notify("vim cmd failed: " .. vimcmd, vim.log.levels.ERROR)
    return false
  end
  return true
end

---Verify if a vim plugin is loaded via scriptnames
---@param requireString string String to search for in scriptnames
---@return boolean found Whether the plugin was found
M.verify_vim_plugin = function(requireString)
  local scripts = vim.cmd("scriptnames")
  local scriptsSplit = vim.split(scripts, "\n")
  for _, v in pairs(scriptsSplit) do
    if v:find(requireString, 1, true) then
      return true
    end
  end
  vim.notify("Missing " .. requireString .. " plugin.", vim.log.levels.WARN)
  return false
end

---Extract directory path from file path
---@param str string File path
---@param sep string? Path separator (default: "/")
---@return string? dir Directory path or nil
local function trim_file(str, sep)
  sep = sep or '/'
  return str:match("(.*" .. sep .. ")")
end

---Open a one-off terminal in a split with command
---@param tcmd string Command to run
M.one_off_terminal = function(tcmd)
  M.init_split_term(tcmd)
end

---Get the directory of the current buffer
---@return string? dir Directory path or nil
local function get_current_buffer_directory()
  local curbuf = vim.api.nvim_buf_get_name(0)
  local curdir = trim_file(curbuf)
  return curdir
end

---Open terminal at the current buffer's directory
M.terminal_buffer = function()
  local curdir = get_current_buffer_directory()
  if curdir then
    M.init_split_term("cd " .. vim.fn.shellescape(curdir) .. "; exec " .. M.config.shell)
  else
    M.init_split_term("exec " .. M.config.shell)
  end
end

---Open terminal at the git root directory
M.terminal_git = function()
  M.init_split_term("")
end

---Open a one-off terminal in a new tab with command
---@param tcmd string Command to run
M.one_off_terminal_tab = function(tcmd)
  vim.cmd("tabe |terminal " .. tcmd)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = bufnr,
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end,
  })
  vim.cmd("startinsert")
end

---Reload a Lua module and optionally reload keymaps file
M.reload_module_in_keymaps = function()
  vim.ui.input({ prompt = "Lib to reload: " }, function(input)
    if not input or input == "" then
      return
    end
    local escaped = vim.pesc(input)
    for k, _ in pairs(package.loaded) do
      if string.match(k, escaped) then
        vim.notify("Reloading package " .. k, vim.log.levels.INFO)
        package.loaded[k] = nil
        require(k)
      end
    end
    -- reload keymaps if configured
    if M.config.keymaps_path then
      dofile(M.config.keymaps_path)
    end
  end)
end

---Make current buffer's file executable (chmod 777)
M.chmod_0777_currentbuf = function()
  local curbuf = vim.api.nvim_buf_get_name(0)
  local result = vim.fn.system("chmod 777 " .. vim.fn.shellescape(curbuf))
  if vim.v.shell_error ~= 0 then
    vim.notify("chmod failed: " .. result, vim.log.levels.ERROR)
  end
end

---Get base directory name of current git repo
---@return string|nil reponame Repository name or nil
M.get_git_repo_base = function()
  local result = vim.fn.system("basename $(git rev-parse --show-toplevel 2>/dev/null)")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(result)
end

return M

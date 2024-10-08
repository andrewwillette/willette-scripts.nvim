local M = {}

local verifyplugin = require("willette-scripts").verifynvimplugin
local verifyvimcmd = require("willette-scripts").verifyvimcommand

local function setLualine(scheme)
  local ok, llc = verifyplugin("lualine-config")
  if not ok or llc == nil then return end
  llc.setTheme(scheme)
end

local function monokaipro()
  require("monokai-pro").setup({
    transparent_background = false,
    terminal_colors = true,
    devicons = true, -- highlight the icons of `nvim-web-devicons`
    italic_comments = false,
    filter = "pro",  -- classic | octagon | pro | machine | ristretto | spectrum
    -- Enable this will disable filter option
    day_night = {
      enable = false,            -- turn off by default
      day_filter = "pro",        -- classic | octagon | pro | machine | ristretto | spectrum
      night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
    },
    inc_search = "background",   -- underline | background
    background_clear = {
      -- "float_win",
      "toggleterm",
      "telescope",
      "which-key",
      "renamer"
    }, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree"
    plugins = {
      bufferline = {
        underline_selected = false,
        underline_visible = false,
      },
      indent_blankline = {
        context_highlight = "default", -- default | pro
        context_start_underline = false,
      },
    },
    override = function(_) end,
  })
  vim.cmd [[colorscheme monokai-pro]]
  setLualine("monokai-pro")
end

local function onedark()
  require('onedark').setup {
    -- Main options --
    style = 'dark',               -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false,          -- Show/hide background
    term_colors = true,           -- Change terminal color as per the selected theme style
    ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = nil,                                                              -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
    code_style = {
      comments = 'none',
      keywords = 'none',
      functions = 'none',
      strings = 'none',
      variables = 'none'
    },

    -- Lualine options --
    lualine = {
      transparent = false, -- lualine center bar transparency
    },

    -- Custom Highlights --
    colors = {},     -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
      darker = true,     -- darker colors for diagnostic
      undercurl = true,  -- use undercurl instead of underline for diagnostics
      background = true, -- use background color for virtual text
    },
  }
  require('onedark').load()
end

local function moonfly()
  vim.g.moonflyItalics = false
  vim.cmd [[colorscheme moonfly]]
end

local function githublight()
  require("github-theme").setup({
    comment_style = "NONE",
    keyword_style = "NONE",
    function_style = "NONE",
    variable_style = "NONE",
    theme_style = "light",
    sidebars = { "qf", "vista_kind", "terminal", "packer" },

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    -- colors = { hint = "orange", error = "#ff0000" },

    -- -- Overwrite the highlight groups
    -- overrides = function(c)
    --   return {
    --     htmlTag = { fg = c.red, bg = "#282c34", sp = c.hint, style = "underline" },
    --     DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
    --     -- this will remove the highlight groups
    --     TSField = {},
    --   }
    -- end
  })
end

local function tundra()
  local ok, nvimtundra = verifyplugin("nvim-tundra")
  if not ok or nvimtundra == nil then return end
  nvimtundra.setup({
    transparent_background = false,
    editor = {
      search = {},
      substitute = {},
    },
    syntax = {
      booleans = { bold = true, italic = false },
      comments = { bold = true, italic = false },
      conditionals = {},
      constants = { bold = true },
      functions = {},
      keywords = {},
      loops = {},
      numbers = { bold = true },
      operators = { bold = true },
      punctuation = {},
      strings = {},
      types = { italic = false },
    },
    diagnostics = {
      errors = {},
      warnings = {},
      information = {},
      hints = {},
    },
    plugins = {
      lsp = true,
      treesitter = true,
      cmp = true,
      context = true,
      dbui = true,
      gitsigns = true,
      telescope = false,
    },
    overwrite = {
      colors = {},
      highlights = {},
    },
  })
  vim.opt.background = 'dark'
  vim.cmd('colorscheme tundra')
  setLualine("codedark")
end

local function kanagawa()
  local ok, kanag = verifyplugin("kanagawa")
  if not ok or kanag == nil then return end
  kanag.setup({
    compile = false,  -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false },
    statementStyle = { bold = false },
    typeStyle = {},
    transparent = false,   -- do not set background color
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
      palette = {},
      theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(_) -- add/modify highlights
      return {}
    end,
    theme = "wave",  -- Load "wave" theme when 'background' option is not set
    background = {   -- map the value of 'background' option to a theme
      dark = "wave", -- try "dragon" !
      light = "lotus"
    },
  })
  -- setup must be called before loading
  vim.cmd("colorscheme kanagawa")
  setLualine("nightfly")
end

local function kanagawabones()
  vim.o.background = "dark"
  vim.g.seoulbones = { italic_comments = false }
  if not verifyvimcmd("colorscheme kanagawabones") then return end
  setLualine("codedark")
end

local function seoulbonesdark()
  vim.o.background = "dark"
  vim.g.seoulbones = { italic_comments = false }
  if not verifyvimcmd("colorscheme seoulbones") then return end
  setLualine("seoul256")
end

local function seoulboneslight()
  vim.o.background = "light"
  vim.g.seoulbones = { italic_comments = false }
  if not verifyvimcmd("colorscheme seoulbones") then return end
  setLualine("seoul256")
end

local function configurecatppuccin()
  local ok, catppuccin = verifyplugin("catppuccin")
  if not ok or catppuccin == nil then return end
  catppuccin.setup({
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    no_italic = true,
    no_bold = true,
    transparent_background = false,
    term_colors = true,
    compile = {
      enabled = false,
      path = vim.fn.stdpath "cache" .. "/catppuccin",
    },
    styles = {
      comments = {},
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = {},
          hints = {},
          warnings = {},
          information = {},
        },
      },
      coc_nvim = false,
      lsp_trouble = false,
      cmp = true,
      lsp_saga = false,
      gitgutter = false,
      gitsigns = true,
      leap = false,
      telescope = true,
      nvimtree = true,
      neotree = {
        enabled = false,
        show_root = true,
        transparent_panel = false,
      },
      dap = {
        enabled = false,
        enable_ui = false,
      },
      which_key = false,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      dashboard = true,
      neogit = false,
      vim_sneak = false,
      fern = false,
      barbar = false,
      bufferline = true,
      markdown = true,
      lightspeed = false,
      ts_rainbow = false,
      hop = false,
      notify = true,
      telekasten = true,
      symbols_outline = true,
      mini = false,
      aerial = false,
      vimwiki = true,
      beacon = true,
      navic = false,
    },
    color_overrides = {},
    highlight_overrides = {},
  })
  return catppuccin
end

local function catpuccinlightlatte()
  configurecatppuccin()
  vim.g.catppuccin_flavour = "latte"
  if not verifyvimcmd("colorscheme catppuccin") then
    return
  end
  setLualine("onelight")
end

local function catpuccindarkfrappe()
  configurecatppuccin()
  vim.g.catppuccin_flavour = "frappe"
  if not verifyvimcmd("colorscheme catppuccin") then return end
  setLualine("horizon")
end

local function catpuccindarkmacchiato()
  configurecatppuccin()
  vim.g.catppuccin_flavour = "macchiato"
  if not verifyvimcmd("colorscheme catppuccin") then return end
  setLualine("horizon")
end

local function catpuccindarkmocha()
  configurecatppuccin()
  vim.g.catppuccin_flavour = "mocha"
  if not verifyvimcmd("colorscheme catppuccin") then return end
  setLualine("horizon")
end

local function greenisgood()
  vim.o.background = "dark"
  if not verifyvimcmd("colorscheme greenisgood") then return end
  setLualine("codedark")
end

local function monochrome()
  vim.o.background = "dark"
  if not verifyvimcmd("colorscheme monochrome") then return end
  setLualine("codedark")
end

local gruvboxmaterial = function()
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  vim.g.gruvbox_material_disable_italic_comment = 0
  if not verifyvimcmd("colorscheme gruvbox-material") then return end
  setLualine("gruvbox_dark")
end

local gruvboxlight = function()
  vim.o.background = "light"
  require("gruvbox").setup({
    undercurl = false,
    underline = false,
    bold = false,
    italic = false,
    strikethrough = false,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  })
  vim.cmd("colorscheme gruvbox")
  setLualine("gruvbox_light")
end

local gruvboxdark = function()
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  vim.g.gruvbox_italics = 0
  vim.g.gruvbox_bold = 0
  require("gruvbox").setup({
    undercurl = false,
    underline = false,
    bold = false,
    italic = {
      strings = false,
      comments = false,
      operators = false,
      folds = false,
    },
    strikethrough = false,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  })
  vim.cmd("colorscheme gruvbox")
  setLualine("gruvbox_dark")
end

local function rosepine(bg)
  local ok, rosepineplugin = verifyplugin("rose-pine")
  if not ok or rosepineplugin == nil then return end
  rosepineplugin.setup({
    --- @usage 'main' | 'moon'
    dark_variant = 'moon',
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = true,

    --- @usage string hex value or named color from rosepinetheme.com/palette
    groups = {
      background = 'base',
      panel = 'surface',
      border = 'highlight_med',
      comment = 'muted',
      link = 'iris',
      punctuation = 'subtle',

      error = 'love',
      hint = 'iris',
      info = 'foam',
      warn = 'gold',

      headings = {
        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
      }
      -- or set all headings at once
      -- headings = 'subtle'
    },

    -- Change specific vim highlight groups
    highlight_groups = {
      ColorColumn = { bg = 'rose' }
    }
  })
  vim.o.background = bg
  vim.cmd("colorscheme rose-pine")
end

local rosepinelight = function()
  rosepine "light"
  setLualine("ayu_light")
end

local rosepinedark = function()
  rosepine "dark"
  setLualine("ayu_dark")
end

local duskfoxdark = function()
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  if not verifyvimcmd("colorscheme duskfox") then return end
  setLualine("palenight")
end

local nightfoxdark = function()
  vim.opt.termguicolors = true
  vim.o.background = "dark"
  vim.cmd("colorscheme nightfox")
  setLualine("palenight")
end

local dayfoxlight = function()
  vim.opt.termguicolors = true
  vim.o.background = "light"
  if not verifyvimcmd("colorscheme dayfox") then return end
  setLualine("ayu_light")
end

local everforest = function()
  vim.o.background = "dark"
  vim.cmd("colorscheme everforest")
end

local colorscheme_table = {
  ["gruvbox dark"] = gruvboxdark,
  ["gruvbox light"] = gruvboxlight,
  ["gruvbox material"] = gruvboxmaterial,
  ["rosepine light"] = rosepinelight,
  ["rosepine dark"] = rosepinedark,
  ["duskfox dark"] = duskfoxdark,
  ["dayfox light"] = dayfoxlight,
  ["nightfox dark"] = nightfoxdark,
  ["greenisgood dark"] = greenisgood,
  ["monochrome dark"] = monochrome,
  ["seoulbones dark"] = seoulbonesdark,
  ["seoulbones light"] = seoulboneslight,
  ["catppuncin light latte"] = catpuccinlightlatte,
  ["catppuncin dark mocha"] = catpuccindarkmocha,
  ["catppuncin dark frappe"] = catpuccindarkfrappe,
  ["catppuncin dark macchiato"] = catpuccindarkmacchiato,
  ["kanagawabones"] = kanagawabones,
  ["kanagawa"] = kanagawa,
  ["tundra"] = tundra,
  ["moonfly"] = moonfly,
  ["onedark"] = onedark,
  ["monokaipro"] = monokaipro,
  ["everforest"] = everforest,
  ["githubLight"] = githublight,
}

local colorscheme_select = {}
for k, _ in pairs(colorscheme_table) do
  table.insert(colorscheme_select, k)
end

M.selectcolorscheme = function()
  require 'fzf-lua'.fzf_exec(colorscheme_select, {
    actions = {
      ['default'] = function(selected)
        colorscheme_table[selected[1]]()
      end
    }
  })
end

gruvboxdark()
return M

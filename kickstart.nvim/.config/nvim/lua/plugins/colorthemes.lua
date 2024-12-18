return {
  { 
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    enabled = true,
    config = function()
      require('tokyonight').setup {
        style = 'night',
        transparent = false,
        styles = {
          sidebars = 'normal',
          floats = 'normal',
        }
      }
    end,
    -- init = function()
      -- vim.cmd.colorscheme 'tokyonight'
    -- end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    enabled = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        transparent_background = false,
        vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = '#ace1af' }),
        custom_highlights = function(colors)
          return {
            -- Comment = { fg = '#7b7974' },
          }
        end,
      }
    end,
  },
  {
    'olimorris/onedarkpro.nvim',
    enabled = true,
    -- init = function()
    --   vim.cmd.colorscheme 'onedark_vivid'
    -- end,
    config = function()
      require('onedarkpro').setup {
        colors = {
          -- red = '#f46f2a',
          cursorline = '#564760',
        },
        highlights = {
          Comment = { italic = true },
        },
        options = {
          cursorline = true,
          transparency = false,
          lualine_transparency = true,
          highlight_inactive_windows = true,
        },
        styles = {
          types = 'italic',
        },
      }
    end,
  },
  {
    'sainnhe/gruvbox-material',
    enabled = true,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_dim_inactive_windows = 1
    end,
  },
  { 'projekt0n/github-nvim-theme', enabled = true },
  { -- display color codes in the editor
    'NvChad/nvim-colorizer.lua',
    opts = {
      filetypes = { '*' },
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- "Name" codes like Blue or blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = false, -- 0xAARRGGBB hex codes
      rgb_fn = false, -- CSS rgb() and rgba() functions
      hsl_fn = false, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = 'background', -- Set the display mode.
      -- Available methods are false / true / "normal" / "lsp" / "both"
      -- True is same as normal
      tailwind = false, -- Enable tailwind colors
      -- parsers can contain values used in |user_default_options|
      sass = { enable = false, parsers = { 'css' } }, -- Enable sass colors
      virtualtext = '■',
      -- update color values even if buffer is not focused
      -- example use: cmp_menu, cmp_docs
      always_update = false,
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
  },
  {
    'rebelot/kanagawa.nvim',
  },
}

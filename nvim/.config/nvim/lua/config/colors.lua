-- set colorscheme and overwrite highlights
vim.cmd.colorscheme 'tokyonight-night'
local colors = require('tokyonight.colors').setup()
local util = require 'tokyonight.util'
vim.api.nvim_set_hl(0, 'Tabline', { fg = colors.blue7, bg = '#e6e9ef' })
vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })

-- vim.cmd.colorscheme 'catppuccin-mocha'
-- local colors = require 'catppuccin.palettes.mocha'
-- local colors = require 'catppuccin.palettes.mocha'
-- vim.api.nvim_set_hl(0, 'Tabline', { fg = colors.green, bg = colors.mantle })
-- vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })

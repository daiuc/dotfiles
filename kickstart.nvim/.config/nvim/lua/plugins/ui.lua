return {
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  { -- filetree
    'nvim-tree/nvim-tree.lua',
    enabled = true,
    keys = {
      { '<leader>b', ':NvimTreeToggle<cr>', desc = 'toggle nvim-tree' },
    },
    config = function()
      require('nvim-tree').setup {
        disable_netrw = true,
        renderer = {
          symlink_destination = false,
        },
        view = {
          float = {
            enable = false,
          },
        },
        filters = {
          dotfiles = true,
          custom = {
            '_freeze',
            'docs',
            '.*logs.*',
          },
        },
        filesystem_watchers = {
          ignore_dirs = {
            'code',
            'data',
            '.*log.*',
            '^_.+',
            '\\..+',
          },
        },
        update_focused_file = {
          enable = false,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
        diagnostics = {
          enable = true,
        },
      }
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    opts = {
      options = {
        theme = 'auto',
        icons_enabled = true,
      },
    },
  },
}

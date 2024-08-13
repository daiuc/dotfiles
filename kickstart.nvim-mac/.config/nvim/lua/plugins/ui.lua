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
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>ol', ':Oil --float<cr>', desc = '[O]pen oi[l]' },
    },
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
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { 'MunifTanjim/nui.nvim', module = 'nui' },
      { 'rcarriga/nvim-notify', module = 'notify' },
    },
    config = function()
      require('noice').setup {
        background_colour = '#ace1af',
        cmdline = {
          enabled = true,
          view = 'cmdline_popup',
        },
        messages = {
          enabled = true,
        },
        popupmenu = {
          enabled = true,
        },
        notify = {
          enabled = true,
        },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
    end,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

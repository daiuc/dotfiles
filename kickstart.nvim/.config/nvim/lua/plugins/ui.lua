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
    opts = {},
    -- Optional dependencies
    dependencies = { 'echasnovski/mini.icons' },
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
  { -- make window bordoers colorful
    'nvim-zh/colorful-winsep.nvim',
    enabled = false,
    event = { 'WinLeave' },
    config = function()
      require('colorful-winsep').setup()
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    enabled = true,
    config = function()
      require('headlines').setup {
        quarto = {
          query = vim.treesitter.query.parse(
            'markdown',
            [[
                (fenced_code_block) @codeblock
                ]]
          ),
          codeblock_highlight = 'CodeBlock',
          treesitter_language = 'markdown',
        },
        markdown = {
          query = vim.treesitter.query.parse(
            'markdown',
            [[
                (fenced_code_block) @codeblock
                ]]
          ),
          codeblock_highlight = 'CodeBlock',
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { 'MunifTanjim/nui.nvim', module = 'nui' },
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      { 'rcarriga/nvim-notify', module = 'notify' },
    },
    config = function()
      require('noice').setup {
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
          -- command_palette = true, -- position the cmdline and popupmenu together
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

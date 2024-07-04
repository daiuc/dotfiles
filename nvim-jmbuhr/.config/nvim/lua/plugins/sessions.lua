return {

  {
    'rmagatti/auto-session',
    enabled = false,
    config = function()
      require('auto-session').setup {
        auto_session_suppress_dirs = {
          '~/',
          '~/Projects',
          '~/Downloads',
          '~/software',
          '/scratch/midway2/chaodai/',
          '/scratch/midway3/chaodai/',
          'Desktop',
          '/',
        },
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
        vim.keymap.set('n', '<leader>sl', require('auto-session.session-lens').search_session, { noremap = true }),
      }
    end,
  },
}

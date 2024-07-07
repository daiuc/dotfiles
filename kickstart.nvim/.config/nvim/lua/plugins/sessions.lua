return {
  {
    'rmagatti/auto-session',
    enabled = true,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('auto-session').setup {
        auto_session_suppress_dirs = {
          '~/',
          '~/Projects',
          '~/Downloads',
          '~/Desktop',
          '/',
        },
      }
    end,
  },
}
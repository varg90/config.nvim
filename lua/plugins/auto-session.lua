return {
  'rmagatti/auto-session',
  lazy = false,
  priority = 900,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    allowed_dirs = {
      vim.fn.expand '~/.config',
      vim.fn.expand '~/Projects',
    },
    -- switch sessions between git branches
    auto_session_use_git_branch = true,
    git_auto_restore_on_branch_change = true,
    -- explicitly set these options to true
    auto_save = true,
    auto_create = true,
    auto_restore = true,
    -- auto_restore_last_session = false,
    root_dir = vim.fn.stdpath 'data' .. '/sessions/',
    lazy_support = true,
    log_level = 'info',

    pre_save_cmds = { 'Neotree close' },
    post_restore_cmds = { 'Neotree show' },
  },
}

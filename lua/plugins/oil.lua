return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      is_always_hidden = function(name, _bufnr)
        local hide = {
          '.git',
          '.github',
          '.idea',
          '.ruby-lsp',
        }
        return vim.tbl_contains(hide, name)
      end,
    },
  },
  -- Optional dependencies
  -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  dependencies = { { 'nvim-tree/nvim-web-devicons', opts = {} } }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function(_, opts)
    require('oil').setup(opts)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'oil',
      callback = function()
        vim.b.codeium_enabled = false
      end,
    })
  end,
}

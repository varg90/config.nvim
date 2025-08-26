return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  dependencies = { { 'nvim-tree/nvim-web-devicons', opts = {} } }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require('oil').setup {}

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'oil',
      callback = function()
        vim.b.codeium_enabled = false
      end,
    })
  end,
}

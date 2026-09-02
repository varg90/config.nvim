return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = { char = '▏', highlight = 'IblIndent' },
    scope = { char = '▏', highlight = 'IblScope' },
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#363636' })
    vim.api.nvim_set_hl(0, 'IblScope', { fg = '#484848' })
    require('ibl').setup(opts)
  end,
}

return {
  'nvim-pack/nvim-spectre',
  init = function()
    vim.keymap.set('n', '<leader>F', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = 'Toggle Spectre',
    })
  end,
  config = function()
    require('spectre').setup()
  end,
}

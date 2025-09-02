return {
  'nvim-pack/nvim-spectre',
  init = function()
    vim.keymap.set(
      'n',
      '<leader>F',
      '<cmd>lua require("spectre").toggle()<CR>',
      {
        desc = 'Toggle Spectre',
      }
    )
    vim.keymap.set(
      'n',
      '<leader>f',
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      {
        desc = 'Search current word',
      }
    )
    vim.keymap.set(
      'v',
      '<leader>f',
      '<esc><cmd>lua require("spectre").open_visual()<CR>',
      {
        desc = 'Search current word',
      }
    )
  end,
  config = function()
    require('spectre').setup()
  end,
}

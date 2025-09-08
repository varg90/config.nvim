return {
  'nvim-pack/nvim-spectre',
  init = function()
    vim.keymap.set(
      'n',
      '<leader>R',
      '<cmd>lua require("spectre").toggle()<CR>',
      {
        desc = 'Toggle Spectre',
      }
    )
    vim.keymap.set(
      'n',
      '<leader>X',
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      {
        desc = 'Search current word',
      }
    )
    vim.keymap.set(
      'v',
      '<leader>F',
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

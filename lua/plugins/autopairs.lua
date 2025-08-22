return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {
      map_cr = true,
      map_bs = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      check_ts = false,
    }
  end,
}

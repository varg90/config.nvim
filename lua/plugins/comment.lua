return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup {
      padding = true, -- add space between comment and code
      sticky = true, -- keeps cursor position after commenting
      ignore = nil, -- ignore empty lines
    }
  end,
}

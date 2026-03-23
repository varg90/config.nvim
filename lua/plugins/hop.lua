return {
  {
    'smoka7/hop.nvim',
    version = '*',
    keys = {
      {
        '<Leader>j',
        function() require('hop').hint_words() end,
        desc = '[HOP] Jump to word',
      },
    },
    opts = {},
  },
}

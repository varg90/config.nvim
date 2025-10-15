return {
  'luukvbaal/statuscol.nvim',
  event = 'BufReadPre',
  config = function()
    require('statuscol').setup {
      setopt = true,
      segments = {
        {
          text = {
            function(args)
              return string.format('%2d ', args.relnum)
            end,
          },
          click = 'v:lua.ScRa',
        },
        {
          text = {
            function(args)
              return string.format('%3d ', args.lnum)
            end,
          },
          click = 'v:lua.ScLa',
        },
      },
    }
  end,
}

return {
  'luukvbaal/statuscol.nvim',
  event = 'BufReadPre',
  config = function()
    require('statuscol').setup {
      setopt = true,
      segments = {
        { text = { '%s' }, click = 'v:lua.ScSa' }, -- sign column
        {
          text = {
            function(args)
              return string.format('%3d ', args.lnum)
            end,
          },
          click = 'v:lua.ScLa',
        },
        {
          text = {
            function(args)
              return string.format('%3d ', args.relnum)
            end,
          },
          click = 'v:lua.ScRa',
        },
      },
    }
  end,
}

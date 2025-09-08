return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set(
        'n',
        '<leader>gb',
        ':Git blame<CR>',
        { desc = '[G]it [B]lame' }
      )
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = '[G]it [P]review hunk',
          })
        end,
      }
    end,
  },
}

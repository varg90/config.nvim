return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      lazy = true,
    },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_help = 1
    vim.g.db_ui_auto_execute_table_helpers = 1

    vim.keymap.set('n', '<leader>lD', function()
      require('helpers.fetch_db_connections').call()
      vim.cmd 'DBUI'
    end, { desc = 'Toggle [D]adBod UI' })
    vim.keymap.set('n', '<leader>ld', function()
      require('helpers.fetch_db_connections').call()
      vim.cmd 'DBUIToggle'
    end, { desc = 'Toggle [D]adBod UI' })
  end,
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'sql', 'mysql', 'plsql' },
      callback = function()
        require('cmp').setup.buffer {
          sources = {
            { name = 'vim-dadbod-completion' },
            { name = 'buffer' },
          },
        }
      end,
    })
  end,
}

return {
  'thoughtbot/vim-rspec',
  dependencies = { 'tpope/vim-rails', 'preservim/vimux' },
  config = function()
    vim.api.nvim_set_keymap(
      'n',
      '<leader>tt',
      ':A<CR>',
      { noremap = true, silent = true, desc = '[T]oggle Spec File' }
    )
    vim.api.nvim_set_keymap(
      'n',
      '<leader>tr',
      ':call RunNearestSpec()<CR>',
      { noremap = true, silent = true, desc = '[T]est [R]un Nearest' }
    )
    vim.api.nvim_set_keymap(
      'n',
      '<leader>tf',
      ':call RunCurrentSpecFile()<CR>',
      { noremap = true, silent = true, desc = '[T]est [F]ile' }
    )
    vim.api.nvim_set_keymap(
      'n',
      '<leader>tl',
      ':call RunLastSpec()<CR>',
      { noremap = true, silent = true, desc = '[T]est [L]ast' }
    )
    vim.keymap.set(
      'n',
      '<leader>bb',
      require('helpers.add_debug_breakpoint').call,
      { desc = 'Insert binding.pry [B]reakpoint' }
    )

    vim.g.rspec_command = '!bundle exec rspec {spec}'
    vim.g.rspec_runner = 'vimux'
  end,
}

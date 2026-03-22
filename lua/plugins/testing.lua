return {
  {
    'vim-test/vim-test',
    dependencies = { 'preservim/vimux' },
    config = function()
      -- [[ RSpec ]]
      vim.keymap.set('n', '<leader>tr', ':TestNearest<CR>', { noremap = true, silent = true, desc = '[T]est [R]un Nearest' })
      vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { noremap = true, silent = true, desc = '[T]est [F]ile' })
      vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { noremap = true, silent = true, desc = '[T]est [L]ast' })
      vim.keymap.set('n', '<leader>bb', require('helpers.add_debug_breakpoint').call, { desc = 'Insert binding.pry [B]reakpoint' })

      vim.g['test#strategy'] = 'vimux'
      vim.g['test#ruby#rspec#executable'] = vim.env.HOME .. '/.rbenv/shims/bundle exec rspec'
      vim.g['test#ruby#rspec#options'] = '--force-color --format documentation'

      vim.g.VimuxUseNearestPane = 0
      vim.g.VimuxOrientation = 'v'
      vim.g.VimuxHeight = 40
    end,
  },
  {
    'tpope/vim-rails',
    config = function()
      -- [[ Rails navigation (vim-rails) ]]
      local rails = require 'helpers.rails'
      vim.keymap.set('n', '<leader>tt', rails.goto_alternate, { desc = '[T]oggle spec/source' })
      vim.keymap.set('n', '<leader>ra', rails.goto_alternate, { desc = '[R]ails [A]lternate file' })
      vim.keymap.set('n', '<leader>rr', rails.goto_related, { desc = '[R]ails [R]elated file' })
      vim.keymap.set('n', '<leader>rm', rails.goto_model, { desc = '[R]ails [M]odel' })
      vim.keymap.set('n', '<leader>rc', rails.goto_controller, { desc = '[R]ails [C]ontroller' })
      vim.keymap.set('n', '<leader>rv', rails.goto_view, { desc = '[R]ails [V]iew' })
      vim.keymap.set('n', '<leader>rh', rails.goto_helper, { desc = '[R]ails [H]elper' })
      vim.keymap.set('n', '<leader>rs', rails.goto_service, { desc = '[R]ails [S]ervice' })
      vim.keymap.set('n', '<leader>rj', rails.goto_job, { desc = '[R]ails [J]ob' })
      vim.keymap.set('n', '<leader>rt', rails.goto_routes, { desc = '[R]ails rou[T]es' })
      vim.keymap.set('n', '<leader>rd', rails.goto_schema, { desc = '[R]ails [D]b schema' })
      vim.keymap.set('n', '<leader>rS', rails.goto_spec, { desc = '[R]ails [S]pec/source toggle' })
      vim.keymap.set('n', '<leader>rR', function()
        require('helpers.telescope_rails').goto_route()
      end, { desc = '[R]ails [R]outes picker' })

      -- [[ Gem navigation ]]
      vim.keymap.set('n', '<leader>og', function()
        require('helpers.gems').open_gem()
      end, { desc = '[O]pen [G]em source' })
    end,
  },
}

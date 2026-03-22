return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require 'telescope'
      local builtin = require 'telescope.builtin'
      local telescope_find_project_and_gems = require 'helpers.telescope_find_project_and_gems'

      telescope.setup {
        defaults = {
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
          file_ignore_patterns = { '.git/', 'node_modules/', 'vendor/' },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      telescope.load_extension 'notify'

      -- Telescope keymaps
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', telescope_find_project_and_gems.call, { desc = '[S]earch Project [F]iles + Gems' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })
      vim.keymap.set('n', '<leader>sm', '<cmd>Telescope treesitter<CR>', { desc = '[S]earch [M]ethods' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
      vim.keymap.set('n', '<leader>n', function()
        telescope.extensions.notify.notify()
      end, { desc = '[N]otification history (Telescope)' })
      vim.keymap.set('n', '<leader>N', '<cmd>Notifications<CR>', { desc = '[N]otifications history' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
      vim.keymap.set('n', '<leader>Y', ':%y+<CR>', { desc = 'Yank whole file to clipboard' })
      vim.keymap.set('n', '<leader>ll', ':Telescope telescope-alternate alternate_file<Cr>', { desc = 'Alternate file' })
    end,
  },
  {
    'xiantang/darcula-dark.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      vim.cmd.colorscheme 'darcula-dark'
    end,
  },
  {
    'otavioschwanck/telescope-alternate',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    init = function()
      local rails_mappings = require('mappings.ruby').get_rails_full_stack_mappings()
      local custom_mappings = {
        {
          'app/services/(.*)_services/(.*).rb',
          {
            { 'app/contracts/[1]_contracts/[2].rb', 'Contract' },
            { 'app/models/**/*[1].rb', 'Model', true },
          },
        },
        {
          'app/contracts/(.*)_contracts/(.*).rb',
          { { 'app/services/[1]_services/[2].rb', 'Service' } },
        },
        {
          'app/models/(.*).rb',
          { { 'db/helpers/**/*[1:pluralize]*.rb', 'Helper' } },
        },
        {
          'lib/generators/service/(.*)%.rb$',
          { { 'spec/generator/%1_spec.rb', 'Test' } },
        },
        {
          'spec/generator/(.*)_spec%.rb$',
          { { 'lib/generators/service/%1.rb', 'Source' } },
        },
      }

      vim.g.telescope_alternate = {
        mappings = require('helpers.merge_arrays').call(rails_mappings, custom_mappings),
        presets = { 'rails', 'rspec' },
        picker = 'telescope',
        open_only_one_with = 'current_pane',
      }
    end,
  },
}

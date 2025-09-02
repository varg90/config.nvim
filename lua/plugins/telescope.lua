-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',

      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
          file_ignore_patterns = { 'node_modules' },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local telescope = require 'telescope'
      local builtin = require 'telescope.builtin'
      vim.keymap.set(
        'n',
        '<leader>sh',
        builtin.help_tags,
        { desc = '[S]earch [H]elp' }
      )
      vim.keymap.set(
        'n',
        '<leader>sk',
        builtin.keymaps,
        { desc = '[S]earch [K]eymaps' }
      )
      vim.keymap.set(
        'n',
        '<leader>sf',
        builtin.find_files,
        { desc = '[S]earch [F]iles' }
      )

      local telescope_find_project_and_gems =
        require 'functions.telescope_find_project_and_gems'
      vim.keymap.set(
        'n',
        '<leader>sF',
        telescope_find_project_and_gems.call,
        { desc = '[S]earch Project [F]iles + Gems' }
      )

      vim.keymap.set(
        'n',
        '<leader>ss',
        builtin.builtin,
        { desc = '[S]earch [S]elect Telescope' }
      )
      vim.keymap.set(
        'n',
        '<leader>sw',
        builtin.grep_string,
        { desc = '[S]earch current [W]ord' }
      )
      vim.keymap.set(
        'n',
        '<leader>sg',
        builtin.live_grep,
        { desc = '[S]earch by [G]rep' }
      )
      vim.keymap.set(
        'n',
        '<leader>sd',
        builtin.diagnostics,
        { desc = '[S]earch [D]iagnostics' }
      )
      vim.keymap.set(
        'n',
        '<leader>sr',
        builtin.resume,
        { desc = '[S]earch [R]esume' }
      )
      vim.keymap.set(
        'n',
        '<leader>s.',
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
      )
      vim.keymap.set(
        'n',
        '<leader><leader>',
        builtin.buffers,
        { desc = '[ ] Find existing buffers' }
      )
      vim.keymap.set(
        'n',
        '<leader>sm',
        '<cmd>Telescope treesitter<CR>',
        { desc = 'Search Methods' }
      )
      vim.keymap.set(
        'n',
        '<leader>e',
        vim.diagnostic.open_float,
        { desc = 'Show line diagnostics' }
      )

      telescope.load_extension 'notify'
      vim.keymap.set('n', '<leader>n', function()
        telescope.extensions.notify.notify()
      end, { desc = '[N]otification history (Telescope)' })
      vim.keymap.set(
        'n',
        '<leader>N',
        '<cmd>Notifications<CR>',
        { desc = '[N]otifications history' }
      )

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        )
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      vim.keymap.set(
        'n',
        '<leader>Y',
        ':%y+<CR>',
        { desc = 'Yank whole file to clipboard' }
      )
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
      local rails_mappings =
        require('mappings.ruby').get_rails_full_stack_mappings()

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
        mappings = require('functions.merge_arrays').call(
          rails_mappings,
          custom_mappings
        ),
        presets = { 'rails', 'rspec' },
        picker = 'telescope',
        open_only_one_with = 'current_pane',
        vim.keymap.set(
          'n',
          '<leader>ll',
          ':Telescope telescope-alternate alternate_file<Cr>',
          { desc = '[TELESCOPE] Alternate file' }
        ),
      }
    end,
  },
}

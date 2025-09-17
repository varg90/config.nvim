return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
      require('neo-tree').setup {
        vim.keymap.set('n', '<leader>O', function()
          require('neo-tree.command').execute { toggle = true }
        end, { desc = 'T[O]ggle NeoTree' }),

        window = {
          width = 30,
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              '.DS_Store',
              '.git',
              '.github',
              '.idea',
              '.ruby-lsp',
            },
          },
        },
      }
    end,
  },
}

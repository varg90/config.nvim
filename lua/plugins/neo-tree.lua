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
        window = {
          position = 'right',
          width = 40,
        },
        -- hijack_netrw_behavior = 'disabled',
        close_if_last_window = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              '.DS_Store',
              '.git',
              '.idea',
              '.ruby-lsp',
            },
          },
        },
      }

      -- номера строк глобальные, в дереве они не нужны
      -- (statuscolumn гасит сам statuscol через ft_ignore)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neo-tree',
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,

    vim.keymap.set('n', '<leader>O', function()
      require('neo-tree.command').execute { toggle = true }
    end, { desc = 'T[O]ggle NeoTree' }),
  },
}

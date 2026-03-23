return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
  },
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'go',
      'ruby',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'sql',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    endwise = { enable = true },
    autotag = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
          ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
        },
        selection_modes = {
          ['@function.outer'] = 'V',
          ['@class.outer'] = '<C-v>',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']b'] = '@block.outer',
          [']m'] = '@function.outer',
        },
        goto_previous_start = {
          ['[b'] = '@block.outer',
          ['[m'] = '@function.outer',
        },
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    local function copy_ruby_class_name()
      local ts_utils = require 'nvim-treesitter.ts_utils'
      local node = ts_utils.get_node_at_cursor()
      local names = {}

      while node do
        if node:type() == 'class' or node:type() == 'module' then
          local name_node = node:field('name')[1]
          if name_node then
            table.insert(names, 1, vim.treesitter.get_node_text(name_node, 0))
          end
        end
        node = node:parent()
      end

      if #names > 0 then
        local full_name = table.concat(names, '::')
        vim.fn.setreg('+', full_name) -- Copy to system clipboard
        vim.notify('Copied class name: ' .. full_name)
      else
        vim.notify('No class/module found under cursor', vim.log.levels.WARN)
      end
    end

    vim.keymap.set(
      'n',
      'yC',
      copy_ruby_class_name,
      { desc = '[Y]ank [C]lass reference' }
    )
  end,
}

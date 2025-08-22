return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {
    ensure_installed = { 'bash', 'c', 'ruby', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'sql' },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    endwise = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- jump forward automatically like `f`
        keymaps = {
          -- Blocks include functions, if/else, while etc
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
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
}

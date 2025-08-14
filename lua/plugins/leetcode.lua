return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html',
  dependencies = {
    'nvim-telescope/telescope.nvim', -- optional, but useful
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    picker = { provider = 'telescope' },
    lang = 'ruby', -- or "python", "cpp", etc.
    keys = {
      { '<leader>lt', ':LeetCodeTest<CR>', desc = 'LeetCode: Test code' },
      { '<leader>lr', ':LeetCodeRun<CR>', desc = 'LeetCode: Run code' },
      { '<leader>ls', ':LeetCodeSubmit<CR>', desc = 'LeetCode: Submit solution' },
    },
  },
  lazy = false,
}

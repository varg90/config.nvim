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
  },
  lazy = false,
}

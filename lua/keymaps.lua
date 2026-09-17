-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  Run `:Telescope keymaps` to see all keymaps

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move selected lines up/down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Keep cursor centered when scrolling/searching.
-- Half-page scroll and centering in one winrestview call = one redraw, no visible jump.
local function scroll_half_page_centered(direction)
  local half = math.floor(vim.api.nvim_win_get_height(0) / 2)
  local line = vim.fn.line('.') + direction * half
  line = math.max(1, math.min(line, vim.fn.line('$')))
  vim.fn.winrestview({ lnum = line, topline = math.max(1, line - half) })
end
vim.keymap.set('n', '<C-d>', function() scroll_half_page_centered(1) end)
vim.keymap.set('n', '<C-u>', function() scroll_half_page_centered(-1) end)
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Buffer navigation
vim.keymap.set('n', '<Leader><Leader>', '<cmd>b#<CR>', { desc = 'Switch between last two buffers' })
vim.keymap.set('n', '<Leader>rab', ':%bd|e#<CR>', { desc = 'Remove all buffers except current' })

-- Handy shortcuts
vim.keymap.set('n', '<Leader>cp', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.fn.setreg('*', path)
  print('Copied: ' .. path)
end, { desc = 'Copy current file path' })
vim.keymap.set('n', '<leader>k', ':co.<CR>', { desc = 'Duplicate current line' })
vim.keymap.set('n', '<leader>w', ':wa<CR>', { desc = 'Save all buffers' })
vim.keymap.set('n', 'ga', 'gg<S-v>G', { desc = 'Select all' })

-- Quickfix navigation
vim.keymap.set('n', ']q', ':cn<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '[q', ':cN<CR>', { desc = 'Prev quickfix' })

-- Делает кастомные маппинги доступными из русской раскладки
-- (использует vim.opt.langmap из settings.lua; встроенные команды он покрывает и сам).
return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  priority = 1000, -- раньше остальных плагинов, чтобы обернуть vim.keymap.set
  config = function()
    require('langmapper').setup()
  end,
}

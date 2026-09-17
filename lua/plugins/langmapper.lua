-- Делает кастомные маппинги доступными из русской раскладки
-- (использует vim.opt.langmap из settings.lua; встроенные команды он покрывает и сам).
return {
  'Wansmer/langmapper.nvim',
  lazy = false,
  priority = 1000, -- раньше остальных плагинов, чтобы обернуть vim.keymap.set
  config = function()
    require('langmapper').setup()

    -- langmap не действует на getcharstr, а через него mini.ai и mini.surround
    -- читают символ текстового объекта: в русской раскладке `yiw` превращался в `yiц`.
    local to_latin = {}
    for _, pair in ipairs(vim.fn.split(vim.o.langmap, [[\\\@<!,]])) do
      local from, to = unpack(vim.fn.split(pair:gsub('\\(.)', '%1'), [[\zs]]))
      to_latin[from] = to
    end
    local getcharstr = vim.fn.getcharstr
    vim.fn.getcharstr = function(...)
      local char = getcharstr(...)
      return to_latin[char] or char
    end
  end,
}

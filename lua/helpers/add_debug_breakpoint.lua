local M = {}

-- adds binding.pry to the next line
function M.call()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_buf_get_lines(0, 0, row, false)
  local indent = ''

  -- Scan backwards for first non-blank line
  for i = #buf, 1, -1 do
    local line = buf[i]
    if line:match '%S' then
      indent = line:match '^%s*' or ''
      -- FIXME: Increase indent if line opens a Ruby block
      if
        line:match '^%s*(def|class|module|if|unless|while|for|do|case|begin)%f[%W]'
      then
        indent = indent .. '    '
      end
      break
    end
  end

  vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. 'binding.pry' })
end

return M

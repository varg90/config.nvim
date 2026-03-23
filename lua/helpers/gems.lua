local M = {}

function M.open_gem()
  local gem_name = vim.fn.expand '<cword>'
  if gem_name == '' or gem_name == nil then
    vim.notify('No gem name under cursor', vim.log.levels.WARN)
    return
  end
  local gem_path = vim.fn.system({ 'bundle', 'show', gem_name }):gsub('\n', '')
  if vim.v.shell_error ~= 0 then
    vim.notify('Gem not found: ' .. gem_name, vim.log.levels.ERROR)
    return
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(gem_path))
end

return M

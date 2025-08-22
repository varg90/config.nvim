local M = {}

function M.call()
  local git_dir = vim.fn.finddir('.git', '.;')
  if git_dir ~= '' then
    return vim.fn.fnamemodify(git_dir, ':h')
  else
    return vim.fn.getcwd()
  end
end

return M

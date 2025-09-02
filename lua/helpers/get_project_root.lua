local M = {}

function M.call()
  local path = vim.fn.getcwd()
  while path ~= '/' do
    if vim.fn.filereadable(path .. '/Gemfile') == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ':h') -- go up one directory
  end
  return vim.fn.getcwd() -- fallback
end

return M

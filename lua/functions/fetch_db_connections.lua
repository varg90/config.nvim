local M = {}
M.loaded = false

function M.setup()
  if M.loaded then
    return
  end

  local project_root = require('functions.get_project_root').call
  local db_yml = project_root .. '/config/database.yml'
  local project_name = vim.fn.fnamemodify(project_root, ':t'):gsub('[^%w%d]', '_')

  if vim.fn.filereadable(db_yml) == 1 then
    local db_script = vim.fn.stdpath 'config' .. '/lua/scripts/list_dbs_from_database_yml.rb'
    local output = vim.fn.systemlist { 'ruby', db_script, db_yml, 'development', 'test' }

    for _, line in ipairs(output) do
      local env, url = line:match '^(%w+)=(.+)$'
      if env and url then
        local db_name = project_name .. env
        vim.notify('Database loaded: ' .. db_name)
        vim.g[db_name] = url
      end
    end

    vim.notify 'Loaded all DB connections from database.yml'
  else
    vim.notify('No database.yml found', vim.log.levels.WARN)
  end

  M.loaded = true
end

return M

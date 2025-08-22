local M = {}
M.loaded = false

function M.call()
  if M.loaded then
    return
  end

  local project_root = require('functions.get_project_root').call()
  local db_yml = project_root .. '/config/database.yml'
  local project_name = vim.fn.fnamemodify(project_root, ':t'):gsub('[^%w%d]', '_')

  if vim.fn.filereadable(db_yml) == 1 then
    local db_script = vim.fn.stdpath 'config' .. '/lua/scripts/list_dbs_from_database_yml.rb'
    local output = vim.fn.systemlist { 'ruby', db_script, db_yml, 'development', 'test' }

    if not vim.g.dbs then
      vim.g.dbs = {}
    end

    local dbs = vim.g.dbs

    for _, line in ipairs(output) do
      local env, url = line:match '^(%w+)=(.+)$'
      if env and url then
        local db_name = project_name .. '_' .. env
        local db_exists = false
        for _, db in ipairs(dbs) do
          if db.name == db_name then
            db_exists = true
            vim.notify('Database already exists: ' .. db_name)
            break
          end
        end
        if not db_exists then
          table.insert(dbs, { name = db_name, url = url })
          vim.notify('Database loaded: ' .. db_name)
        end
      end
    end

    vim.g.dbs = dbs
  else
    vim.notify('No database.yml found', vim.log.levels.WARN)
  end

  M.loaded = true
end

return M

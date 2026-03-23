local M = {}

function M.goto_route()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  vim.notify('Loading routes...', vim.log.levels.INFO)

  local routes = {}
  vim.fn.jobstart({ 'bundle', 'exec', 'rails', 'routes' }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      for _, line in ipairs(data or {}) do
        -- Match lines that contain a controller#action (skip header lines)
        if line:match('%S+#%S+') and not line:match('^%s*Prefix') then
          table.insert(routes, line)
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 or #routes == 0 then
        vim.schedule(function()
          vim.notify('No routes found (exit code ' .. code .. ')', vim.log.levels.WARN)
        end)
        return
      end

      vim.schedule(function()
        pickers.new({}, {
          prompt_title = 'Rails Routes',
          finder = finders.new_table {
            results = routes,
          },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              if not selection then
                return
              end
              -- Extract controller#action from the end of the line
              local controller_action = selection[1]:match('(%S+#%S+)%s*$')
              if controller_action then
                local controller, action = controller_action:match('^(.-)#(.+)$')
                if controller then
                  vim.cmd('Econtroller ' .. controller)
                  vim.fn.search(action, 'w')
                end
              end
            end)
            return true
          end,
        }):find()
      end)
    end,
  })
end

return M

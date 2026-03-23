local M = {}

function M.goto_alternate()
  vim.cmd 'A'
end

function M.goto_related()
  local filename = vim.fn.expand '%:t'
  local rails_commands = {
    ['_controller.rb'] = 'Econtroller',
    ['_decorator.rb'] = 'Edecorator',
    ['_component.rb'] = 'Ecomponent',
    ['_job.rb'] = 'Ejob',
    ['_mailer.rb'] = 'Emailer',
    ['_service.rb'] = 'Eservice',
    ['_policy.rb'] = 'Epolicy',
    ['_serializer.rb'] = 'Eserializer',
    ['_uploader.rb'] = 'Euploader',
    ['_helper.rb'] = 'Ehelper',
    ['.rb'] = 'Emodel',
  }
  for suffix, cmd in pairs(rails_commands) do
    if filename:find(suffix .. '$') then
      vim.cmd(cmd)
      return
    end
  end
  vim.cmd 'A'
end

function M.goto_model()
  vim.cmd 'Emodel'
end

function M.goto_controller()
  vim.cmd 'Econtroller'
end

function M.goto_view()
  vim.cmd 'Eview'
end

function M.goto_helper()
  vim.cmd 'Ehelper'
end

function M.goto_service()
  vim.cmd 'Eservice'
end

function M.goto_job()
  vim.cmd 'Ejob'
end

function M.goto_spec()
  local filename = vim.fn.expand '%:t'
  if filename:find '_spec.rb$' then
    vim.cmd 'A'
  else
    vim.cmd 'As'
  end
end

function M.goto_routes()
  vim.cmd 'Routes'
end

function M.goto_migration()
  vim.cmd 'Emigration'
end

function M.goto_schema()
  vim.cmd 'Dsschema'
end

return M

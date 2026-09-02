local M = {}

local function try(cmd)
  if not pcall(vim.cmd, cmd) then
    vim.notify(cmd .. ': файл не найден', vim.log.levels.WARN)
  end
end

function M.goto_alternate()
  try('A')
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
      try(cmd)
      return
    end
  end
  try('A')
end

function M.goto_model()
  try('Emodel')
end

function M.goto_controller()
  try('Econtroller')
end

function M.goto_view()
  try('Eview')
end

function M.goto_helper()
  try('Ehelper')
end

function M.goto_service()
  try('Eservice')
end

function M.goto_job()
  try('Ejob')
end

function M.goto_spec()
  local filename = vim.fn.expand '%:t'
  if filename:find '_spec.rb$' then
    try('A')
  else
    try('As')
  end
end

function M.goto_routes()
  try('Routes')
end

function M.goto_migration()
  try('Emigration')
end

function M.goto_schema()
  try('Dsschema')
end

return M

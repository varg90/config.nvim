local M = {}

local mergeArrays = require('helpers.merge_arrays').call

function M.generate_spec_mapping(base_path, mapping)
  return {
    {
      base_path .. '/' .. mapping .. '/(.*).rb',
      {
        { 'spec/' .. mapping .. '/[1]_spec.rb', 'Test', true },
      },
    },
    {
      'spec/' .. mapping .. '/(.*)_spec.rb',
      {
        { base_path .. '/' .. mapping .. '/[1].rb', 'Model', true },
      },
    },
  }
end

function M.get_ruby_mappings()
  local ruby_mappings = {}

  for _, mapping in ipairs {
    'models',
    'serializers',
    'policies',
    'jobs',
    'helpers',
  } do
    ruby_mappings =
      mergeArrays(ruby_mappings, M.generate_spec_mapping('app', mapping))
  end

  for _, mapping in ipairs { 'request', 'service' } do
    ruby_mappings =
      mergeArrays(ruby_mappings, M.generate_spec_mapping('lib', mapping))
  end

  return ruby_mappings
end

function M.get_rails_api_mappings()
  local ruby_api_mappings = mergeArrays({
    {
      'app/controllers(.*)/(.*)_controller.rb',
      {
        { 'app/models/[2:singularize].rb', 'Model' },
        { 'app/serializers/[2:singularize]_serializer.rb', 'Serializer', true },
        { 'spec/controllers[1]/[2]_controller_spec.rb', 'Test', true },
      },
    },
    {
      'spec/controllers(.*)/(.*)_spec.rb',
      {
        { 'app/controllers[1]/[2].rb', 'Controller' },
      },
    },
    {
      'app/mailers(.*)/(.*)_mailer.rb',
      {
        { 'app/views/[1][2]_mailer/*.html.erb', 'View', true },
        { 'spec/mailers[1]/[2]_mailer_spec.rb', 'Test', true },
      },
    },
    {
      'spec/mailers(.*)/(.*)_spec.rb',
      {
        { 'app/mailers[1]/[2].rb', 'Mailer' },
      },
    },
    {
      'app/views/(.*)/(.*).html.(.*)',
      {
        { 'app/controllers/**/*[1]_controller.rb', 'Controller' },
        { 'app/mailers/**/*[1].rb', 'Mailer' },
        { 'app/models/[1:singularize].rb', 'Model' },
        { 'app/helpers/**/*[1]_helper.rb', 'Helper' },
      },
    },
    {
      'lib/tasks/(.*).thor',
      {
        { 'spec/tasks/[1]_spec.rb', 'Test', true },
      },
    },
    {
      'lib/tasks/(.*).rake',
      {
        { 'spec/tasks/[1]_spec.rb', 'Test', true },
      },
    },
    {
      'spec/tasks/(.*)_spec.rb',
      {
        { 'lib/tasks/[1].rake', 'Rake', true },
        { 'lib/tasks/[1].thor', 'THOR', true },
      },
    },
  }, M.get_ruby_mappings())

  return ruby_api_mappings
end

function M.get_rails_full_stack_mappings()
  local ruby_fs_mappings = mergeArrays({
    {
      'app/controllers(.*)/(.*)_controller.rb',
      {
        { 'app/models/[2:singularize].rb', 'Model' },
        { 'app/views/[1][2]/*.html.erb', 'View' },
        { 'app/helpers/**/*[2]_helper.rb', 'Helper' },
        { 'app/serializers/[2:singularize]_serializer.rb', 'Serializer', true },
        { 'spec/controllers[1]/[2]_controller_spec.rb', 'Test', true },
        { 'spec/requests[1]/[2]_spec.rb', 'Request', true },
        { 'app/views[1]/[2]/*.turbo_stream.erb', 'TS View', true },
        { 'app/views[1]/[2]/*.html.erb', 'View', true },
      },
    },
    {
      'app/services/(.*).rb',
      {
        { 'spec/services/[1]_spec.rb', 'Test', true },
      },
    },
    {
      'spec/services/(.*)_spec.rb',
      {
        { 'app/services/[1].rb', 'Service', true },
      },
    },
    {
      'app/components(.*)/(.*)_component.rb',
      {
        { 'app/components[1]/[2]_component.html.erb', 'View' },
        { 'app/components[1]/[2]_component_controller.js', 'JS' },
      },
    },
    {
      'app/components(.*)/(.*)_component.html.erb',
      {
        { 'app/components[1]/[2]_component.rb', 'Component' },
        { 'app/components[1]/[2]_component_controller.js', 'JS' },
      },
    },
    {
      'app/components(.*)/(.*)_component_controller.js',
      {
        { 'app/components[1]/[2]_component.rb', 'Component' },
        { 'app/components[1]/[2]_component.html.erb', 'View' },
      },
    },
    {
      'spec/controllers(.*)/(.*)_spec.rb',
      {
        { 'app/controllers[1]/[2].rb', 'Controller' },
      },
    },
    {
      'app/mailers(.*)/(.*)_mailer.rb',
      {
        { 'app/views/[1][2]_mailer/*.html.erb', 'View', true },
        { 'spec/mailers[1]/[2]_mailer_spec.rb', 'Test', true },
      },
    },
    {
      'spec/mailers(.*)/(.*)_spec.rb',
      {
        { 'app/mailers[1]/[2].rb', 'Mailer' },
      },
    },
    {
      'app/views/(.*)/(.*).html.(.*)',
      {
        { 'app/controllers/**/*[1]_controller.rb', 'Controller' },
        { 'app/mailers/**/*[1].rb', 'Mailer' },
        { 'app/models/[1:singularize].rb', 'Model' },
        { 'app/helpers/**/*[1]_helper.rb', 'Helper' },
      },
    },
    {
      'app/views/(.*)/(.*).turbo_stream.(.*)',
      {
        { 'app/controllers/**/*[1]_controller.rb', 'Controller' },
      },
    },
    {
      'lib/tasks/(.*).thor',
      {
        { 'spec/tasks/[1]_spec.rb', 'Test', true },
      },
    },
    {
      'lib/tasks/(.*).rake',
      {
        { 'spec/tasks/[1]_spec.rb', 'Test', true },
      },
    },
    {
      'spec/tasks/(.*)_spec.rb',
      {
        { 'lib/tasks/[1].rake', 'Rake', true },
        { 'lib/tasks/[1].thor', 'THOR', true },
      },
    },
  }, M.get_ruby_mappings())
  return ruby_fs_mappings
end

return M

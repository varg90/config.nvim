local M = {}

local Path = require 'plenary.path'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local previewers = require 'telescope.previewers'

function M.call()
  local project_root = vim.fn.getcwd()
  local gem_paths = vim.fn.systemlist 'ruby -e "puts Gem.path"'

  local search_paths = { project_root }
  for _, path in ipairs(gem_paths) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(search_paths, path .. '/gems')
    end
  end

  local results = {}
  local allowed_exts = { 'rb', 'erb', 'js', 'css', 'scss', 'html' }
  local ignored_dirs = { 'doc', 'test', 'spec' }

  for _, dir in ipairs(search_paths) do
    if vim.fn.isdirectory(dir) == 1 then
      -- Build fd command
      local fd_cmd =
        { 'fd', '--type f', '--hidden', '.', vim.fn.shellescape(dir) }
      for _, ext in ipairs(allowed_exts) do
        table.insert(fd_cmd, '--extension ' .. ext)
      end
      for _, ig in ipairs(ignored_dirs) do
        table.insert(fd_cmd, '--exclude ' .. ig)
      end

      -- Join into string and run
      local files = vim.fn.systemlist(table.concat(fd_cmd, ' '))
      vim.list_extend(results, files)
    end
  end

  -- Shorten display paths for gem files
  local display_results = {}
  local abs_map = {}
  for _, f in ipairs(results) do
    local rel = Path:new(f):make_relative(project_root)
    if rel == f then
      local parts = vim.split(f, Path.path.sep)
      local len = #parts
      if len > 5 then
        rel = '…'
          .. Path.path.sep
          .. table.concat({
            parts[len - 4],
            parts[len - 3],
            parts[len - 2],
            parts[len - 1],
            parts[len],
          }, Path.path.sep)
      end
    end
    table.insert(display_results, rel)
    abs_map[rel] = f
  end

  -- Launch Telescope picker
  pickers
    .new({}, {
      prompt_title = 'Project + Gems',
      finder = finders.new_table {
        results = display_results,
        entry_maker = function(entry)
          return {
            value = abs_map[entry],
            display = entry,
            ordinal = abs_map[entry],
          }
        end,
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      previewer = previewers.vim_buffer_cat.new {}, -- lazy preview
    })
    :find()
end

return M

local M = {}

function M.call(...)
  local result = {}
  local arrays = { ... }
  for _, t in ipairs(arrays) do
    t = t or {}
    if type(t) ~= 'table' then
      error 'merge: all arguments must be tables or nil'
    end
    table.move(t, 1, #t, #result + 1, result)
  end
  return result
end

return M

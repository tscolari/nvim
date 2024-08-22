local a = require('packer.async')
local async = a.sync

local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.has_module(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

local path_separator = package.config:sub(1, 1)
function M.path_join(paths)
  return table.concat(paths, path_separator)
end

function M.check_dependencies(dependencies)
  async(function()
    local missing = {}

    for _, deps in pairs(dependencies) do
      if type(deps) ~= 'table' then
        deps = { deps }
      end

      local found = false
      for _, dep in pairs(deps) do
        if vim.fn.executable(dep) == 1 then
          found = true
          break
        end
      end

      if not found then
        table.insert(missing, deps[1])
      end
    end

    if #missing > 0 then
      local missing_string = table.concat(missing, ", ")
      vim.notify(
        [[Missing dependencies (]] ..
        missing_string .. [[) detected. Please refer to the README for more information on how to install them.]],
        'error',
        { title = 'Config Dependencies' }
      )
    end
  end)()
end

return M

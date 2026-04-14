local M = {}

local plugins = require 'plugins.plugins'

M.add_all = function()
  for i = #plugins, 1, -1 do
    if plugins[i].enabled == false then
      table.remove(plugins, i)
    end
  end
  vim.pack.add(plugins, { load = true })
end

M.setup_all = function()
  for _, spec in ipairs(plugins) do
    M.setup(spec)
  end
end

function GetArgs(func)
  local args = {}
  for i = 1, debug.getinfo(func).nparams, 1 do
    table.insert(args, debug.getlocal(func, i))
  end
  return args
end

-- dependency injection by name
function ArgsFor(spec, func)
  local args = {}
  for i, arg in ipairs(GetArgs(func)) do
    if arg == 'spec' then
      args[i] = spec
    elseif spec.stupid_requires and spec.stupid_requires[arg] then
      local stupid = spec.stupid_requires[arg]
      if type(stupid) == 'string' then
        args[i] = require(stupid)
      elseif type(stupid) == 'table' then
        args[i] = require(stupid[1])[stupid[2]]
      end
    else
      args[i] = require(arg)
    end
  end
  return args
end

M.setup = function(spec)
  if spec.config then
    local args = ArgsFor(spec, spec.config)
    spec.config(unpack(args))
  end

  if spec.keys then
    local keys = spec.keys

    if type(spec.keys) == 'function' then
      local args = ArgsFor(spec, spec.keys)
      keys = spec.keys(unpack(args))
    end
    for _, key in ipairs(keys) do
      vim.keymap.set(key.mode or 'n', key[1], key[2], key[3])
    end
  end
end

return M

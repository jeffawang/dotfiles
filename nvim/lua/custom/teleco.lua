local scan = require 'plenary.scandir'
local explorer_actions = require 'snacks.explorer.actions'
local Path = require 'plenary.path'

local M = {}

function M.scandir(opts, cb)
  return scan.scan_dir(opts.cwd, {
    add_dirs = vim.F.if_nil(opts.add_dirs, true),
    only_dirs = vim.F.if_nil(opts.only_dirs, false),
    depth = vim.F.if_nil(opts.depth, 1),
    hidden = vim.F.if_nil(opts.hidden, false),
    respect_gitignore = false,
    on_insert = cb,
  })
end

function M.transform_path(path, cwd)
  local file = Path:new(path):make_relative(cwd)

  local is_dir = vim.fn.isdirectory(path) == 1

  if is_dir then
    -- one slash gets stripped/normalized out, lol
    file = file .. '//'
  end

  return {
    cwd = cwd,
    path = path,
    text = file,
    file = file,
    dir = is_dir,
  }
end

---@param opts snacks.picker.files.Config
---@type snacks.picker.finder
function M.teleco(opts, ctx)
  local cwd = not (opts.rtp or (opts.dirs and #opts.dirs > 0)) and vim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or '.') or nil
  local title = string.format('Select %s (%s)', opts.only_dirs and 'Dir' or 'File', cwd)
  ctx.picker.title = title
  return function(cb)
    M.scandir(opts, function(i)
      cb(M.transform_path(i, opts.cwd))
    end)
  end
end

function M.cd_find(picker, cwd)
  vim.api.nvim_buf_set_lines(picker.input.win.buf, 0, -1, false, { '' })
  picker:set_cwd(cwd)
  picker:find()
end

function new_file(picker, item, action)
  local value = vim.api.nvim_buf_get_lines(picker.input.win.buf, 0, -1, false)[1]
  local path = svim.fs.normalize(picker:dir() .. '/' .. value)
  local is_file = value:sub(-1) ~= '/'
  local dir = is_file and vim.fs.dirname(path) or path
  if is_file and vim.loop.fs_stat(path) then
    Snacks.notify.warn('File already exists:\n- `' .. path .. '`')
    return
  end
  vim.fn.mkdir(dir, 'p')
  if is_file then
    io.open(path, 'w'):close()
  end
  -- Tree:open(dir)
  -- Tree:refresh(dir)
  -- M.update(picker, { target = path })
  picker:find()
end

M.source = {
  finder = M.teleco,
  format = 'file',
  actions = {
    confirm = function(picker, item, action)
      if item == nil then
        new_file(picker, item, action)
      else
        require('snacks.picker.actions').confirm(picker, item, action)
      end
    end,
    tabselect = function(picker, item)
      if not item then
        return
      end
      if item.dir then
        M.cd_find(picker, item.path)
      else
        vim.api.nvim_buf_set_lines(picker.input.win.buf, 0, -1, false, { item.file })
        vim.api.nvim_win_set_cursor(0, { 1, #item.file })
      end
    end,
    bs = function(picker)
      if #picker.input.filter.pattern == 0 then
        local parent = Path:new(picker.opts.cwd):parent():absolute()
        M.cd_find(picker, parent)
      else
        local bs = vim.api.nvim_replace_termcodes('<bs>', true, false, true)
        vim.api.nvim_feedkeys(bs, 'n', false)
      end
    end,
  },
  win = {
    input = {
      keys = {
        ['<tab>'] = {
          'tabselect',
          mode = { 'n', 'i' },
        },
        ['<bs>'] = {
          'bs',
          mode = { 'n', 'i' },
        },
      },
    },
  },
}

return M

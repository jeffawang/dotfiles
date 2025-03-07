local scan = require 'plenary.scandir'
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

  return {
    cwd = cwd,
    path = path,
    text = file,
    file = file,
    dir = vim.fn.isdirectory(path) == 1,
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

M.source = {
  finder = M.teleco,
  format = 'file',
  actions = {
    blep = function(picker, item)
      if item.dir then
        M.cd_find(picker, item.path)
      else
        vim.api.nvim_buf_set_lines(picker.input.win.buf, 0, -1, false, { item.file })
        vim.api.nvim_win_set_cursor(0, { 1, #item.file })
      end
    end,
    bs = function(picker)
      local parent = Path:new(picker.opts.cwd):parent():absolute()
      M.cd_find(picker, parent)
    end,
  },
  win = {
    input = {
      keys = {
        ['<tab>'] = {
          'blep',
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

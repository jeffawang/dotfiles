local snacks = require 'snacks'
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local teleco = require 'custom.teleco'
local tags = require 'custom.tags'

local project = require 'projects_nvim'

local picker_overrides = {
  ---comment
  ---@param opts snacks.picker.Config
  ---@return snacks.picker.Config
  explorer = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      actions = {
        previous_window = function()
          local keys = vim.api.nvim_replace_termcodes('<c-w>p', true, false, true)
          vim.api.nvim_feedkeys(keys, 'n', false)
        end,
      },
      win = {
        input = { keys = {
          ['\\'] = 'previous_window',
        } },
        list = { keys = {
          ['\\'] = 'previous_window',
        } },
      },
    })
  end,
  grep = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      title = string.format('Grep (%s)', opts.cwd or vim.uv.cwd()),
    })
  end,
  grep_buffers = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      title = string.format('Grep Buffers (%s)', opts.cwd or vim.uv.cwd()),
    })
  end,
  teleco = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      title = string.format('Select File (%s)', opts.cwd or vim.uv.cwd()),
    })
  end,
  files = function(opts)
    if opts.cwd then
      return vim.tbl_deep_extend('force', opts, {
        title = string.format('Files (%s)', opts.cwd or vim.uv.cwd()),
      })
    end
    return opts
  end,
}

local function apply_picker_overrides(opts)
  -- window nav stuff....
  opts.win.input.keys['<C-J>'] = nil
  opts.win.input.keys['<C-K>'] = nil
  opts.win.input.keys['<C-U>'] = nil
  -- opts.win.input.keys['<C-D>'] = nil
  opts.win.input.keys['<C-H>'] = { 'toggle_hidden', mode = { 'i', 'n' } }
  opts.win.list.keys['<C-J>'] = nil
  opts.win.list.keys['<C-K>'] = nil
  -- opts.win.list.keys['<C-U>'] = { 'list_scroll_up', mode = { 'i', 'n' } }
  opts.win.list.keys['<C-D>'] = { 'list_scroll_down', mode = { 'i', 'n' } }
  opts.win.list.keys['<C-H>'] = { 'toggle_hidden', mode = { 'i', 'n' } }

  if picker_overrides[opts.source] then
    return picker_overrides[opts.source](opts)
  end
  return opts
end

local function switch_picker(picker, next_picker)
  if next_picker == picker.opts.source then
    return
  end
  local cwd = picker.opts.cwd or vim.uv.cwd()
  picker:close()
  snacks.picker.pick(next_picker, { cwd = cwd })
end

---@class snacks.picker.Config
local M = {
  enabled = true,
  -- 'folke/snacks.nvim',
  'jeffawang/snacks.nvim',
  dev = true,
  keys = {
    {
      '<leader>fp',
      function()
        snacks.picker.files {
          cwd = vim.fn.stdpath 'config',
          pattern = 'init.lua',
        }
      end,
      { desc = '[F]earch Neovim files' },
    },
    {
      '<leader>sn',
      function()
        snacks.picker.files {
          cwd = vim.fn.stdpath 'config',
        }
      end,
      { desc = '[S]earch [N]eovim files' },
    },

    {
      '<leader><space>',
      function()
        local cwd = vim.fn.expand '%:p:h'
        local project_root = project.file_project_root(cwd)
        snacks.picker.files { cwd = project_root }
      end,
    },
    { '<leader>ss', snacks.picker.pick },
    {
      '<leader>sp',
      function()
        local cwd = vim.fn.expand '%:p:h'
        local project_root = project.file_project_root(cwd)
        snacks.picker.grep {
          cwd = project_root,
          -- TODO: live doesn't work
          live = true,
          supports_live = true,
        }
      end,
    },
    {
      '<leader>sd',
      function()
        snacks.picker.grep {
          cwd = vim.fn.expand '%:p:h',
          need_search = false,
        }
      end,
    },
    {
      '<leader>sD',
      function()
        local cwd = vim.fn.expand '%:p:h'
        snacks.picker.pick('teleco', {
          cwd = cwd,
          only_dirs = true,
          show_empty = true,
          confirm = function(picker, item)
            picker:close()
            snacks.picker.pick('grep', item.path)
          end,
        })
      end,
    },

    {
      '<leader>pp',
      function()
        snacks.picker.projects { patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn' } }
      end,
    },
    { '<leader>fr', snacks.picker.recent },
    { '<leader>bb', snacks.picker.buffers },
    { '<leader>sr', snacks.picker.resume },
    { '<leader>sh', snacks.picker.help },

    { '<leader>sj', snacks.picker.jumps },
    { '<leader>sk', snacks.picker.keymaps },

    { 'gD', snacks.picker.lsp_references },
    { 'gd', snacks.picker.lsp_definitions },
    { 'gI', snacks.picker.lsp_implementations },
    { '<leader>ct', snacks.picker.lsp_type_definitions },
    {
      '<leader>ds',
      function()
        snacks.picker.lsp_symbols {}
      end,
    },
    { '<leader>cs', snacks.picker.lsp_workspace_symbols },
    { '<leader>ws', snacks.picker.lsp_workspace_symbols },

    { '<leader>sm', snacks.picker.marks },
    { '<leader>sj', snacks.picker.jumps },
    { '<leader>sw', snacks.picker.grep_word },

    {
      '<leader>st',
      function()
        snacks.picker.pick('tags', {})
      end,
    },

    {
      '<leader>.',
      function()
        vim.print 'from snacks'
        local cwd = vim.fn.expand '%:p:h'
        snacks.picker.pick('teleco', { cwd = cwd })
      end,
    },

    {
      '<leader>/',
      snacks.picker.grep_buffers,
    },

    {
      '<leader>gs',
      function()
        snacks.picker.explorer {
          tree = true,
          finder = 'git_status',
          format = 'git_status',
        }
      end,
    },

    {
      '\\',
      function()
        local current_pickers = Snacks.picker.get { source = 'explorer' }
        if #current_pickers > 0 then
          current_pickers[1].list.win:focus()
        else
          snacks.picker.explorer()
        end
      end,
    },
  },
  opts = {
    picker = {
      config = apply_picker_overrides,
      actions = {
        grepswitch = function(picker, _, _)
          switch_picker(picker, 'grep_buffers')
        end,
        filesswitch = function(picker, _, _)
          switch_picker(picker, 'files')
        end,
        telecoswitch = function(picker, _, _)
          switch_picker(picker, 'teleco')
        end,
        nextswitch = function(picker, _, _)
          local sources = { 'teleco', 'files', 'grep_buffers' }
          local next = sources[1]
          local curr = picker.init_opts.source

          for i, v in ipairs(sources) do
            if v == curr then
              next = sources[1 + (i % #sources)]
            end
          end

          local cwd = picker.opts.cwd or vim.uv.cwd()

          picker:close()
          snacks.picker.pick(next, { cwd = cwd })
        end,
      },
      win = {
        input = {
          keys = {
            ['<leader>/'] = {
              'grepswitch',
              mode = { 'n' },
            },
            ['<leader><space>'] = {
              'filesswitch',
              mode = { 'n' },
            },
            ['<leader>.'] = {
              'telecoswitch',
              mode = { 'n' },
            },
            ['<C-;>'] = {
              'nextswitch',
              mode = { 'i', 'n' },
            },
          },
        },
      },
      sources = {
        teleco = teleco.source,
        tags = tags.source,
        lsp_symbols = {
          filter = {
            default = {
              'Class',
              'Constructor',
              'Enum',
              'Field',
              'Function',
              'Interface',
              'Method',
              'Module',
              'Namespace',
              'Package',
              'Property',
              'Struct',
              'Trait',
              'Variable',
              'Constant',
            },
            --   go = { 'Variable' },
          },
        },
      },
      layout = {
        cycle = false,
        -- preview = 'main',
        preset = 'ivy',
      },
      matcher = {
        fuzzy = false,
        frecency = true,
        history_bonus = true,
      },
    },
  },
}

return M

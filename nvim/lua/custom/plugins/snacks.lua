local snacks = require 'snacks'
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

local teleco = require 'custom.teleco'
local tags = require 'custom.tags'

local picker_overrides = {
  grep = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      title = string.format('Grep (%s)', opts.cwd),
    })
  end,
  teleco = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      title = string.format('Select File (%s)', opts.cwd),
    })
  end,
  files = function(opts)
    return vim.tbl_deep_extend('force', opts, {
      title = string.format('Files (%s)', opts.cwd),
    })
  end,
}

local function apply_picker_overrides(opts)
  if picker_overrides[opts.source] then
    return picker_overrides[opts.source](opts)
  end
  return opts
end

---@class snacks.picker.Config
local M = {
  enabled = true,
  -- 'folke/snacks.nvim',
  'jeffawang/snacks.nvim',
  dev = true,
  keys = {
    { '<leader><space>', snacks.picker.files },
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

    -- TODO: figure out how to make this good

    { '<leader>ss', snacks.picker.pick },
    { '<leader>sp', snacks.picker.grep },
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
      '<leader>sD',
      function()
        local cwd = vim.fn.expand '%:p:h'
        snacks.picker.pick('teleco', {
          cwd = cwd,
          only_dirs = true,
          confirm = function(picker, item)
            picker:close()
            snacks.picker.pick('grep', item.path)
          end,
        })
      end,
    },

    {
      '<leader>.',
      function()
        local cwd = vim.fn.expand '%:p:h'
        snacks.picker.pick('teleco', { cwd = cwd })
      end,
    },

    {
      '<leader>/',
      snacks.picker.grep_buffers,
    },
  },
  opts = {
    picker = {
      config = apply_picker_overrides,
      actions = {
        blah = function(picker, _, _)
          local sources = { 'teleco', 'files', 'grep' }
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
            ['<C-;>'] = {
              'blah',
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

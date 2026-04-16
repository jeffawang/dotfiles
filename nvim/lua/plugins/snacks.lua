vim.pack.add {
  'https://github.com/jeffawang/snacks.nvim',
}

local snacks = require 'snacks'

snacks.setup {
  picker = {
    config = function(opts)
      local cwd = opts.cwd or vim.uv.cwd()
      if opts.source == 'grep' then
        opts.title = string.format('Grep (%s) {flags}', cwd)
      elseif opts.source == 'grep_buffers' then
        opts.title = string.format('Grep Buffers (%s) {flags}', cwd)
      elseif opts.source == 'teleco' then
        opts.title = string.format('Select File (%s) {flags}', cwd)
      elseif opts.source == 'files' then
        opts.title = string.format('Files (%s) {flags}', cwd)
      end
    end,
    actions = {
      previous_window = function()
        local keys = vim.api.nvim_replace_termcodes('<c-w>p', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
      end,
      grepswitch = function(picker, _, _)
        picker:close()
        snacks.picker.pick('grep_buffers', { cwd = picker.opts.cwd or vim.uv.cwd() })
      end,
      filesswitch = function(picker, _, _)
        picker:close()
        snacks.picker.pick('files', { cwd = picker.opts.cwd or vim.uv.cwd() })
      end,
      telecoswitch = function(picker, _, _)
        picker:close()
        snacks.picker.pick('teleco', { cwd = picker.opts.cwd or vim.uv.cwd() })
      end,
      explorer_open_all = function(picker, _, _)
        local Tree = require 'snacks.explorer.tree'
        local actions = require 'snacks.explorer.actions'
        Tree:walk(Tree:find(picker:cwd()), function(node)
          if node.dir then
            node.open = true
          end
        end, { all = true })
        actions.update(picker)
      end,
    },
    win = {
      keys = {
        ['<leader>/'] = { 'grepswitch', mode = { 'n' } },
        ['<leader><space>'] = { 'filesswitch', mode = { 'n' } },
        ['<leader>.'] = { 'telecoswitch', mode = { 'n' } },
        ['<C-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
      },
    },
    sources = {
      explorer = {
        git_untracked = true,
        layout = {
          preset = 'sidebar',
          hidden = { 'input' },
        },
        keys = {},
        win = {
          keys = {},
          list = {
            keys = {
              ['\\'] = 'previous_window',
              ['w'] = 'explorer_open_all',
              ['e'] = 'explorer_close_all',
              ['<C-j>'] = false,
              ['<C-k>'] = false,
              ['/'] = false,
              ['<A-/>'] = 'toggle_focus', -- go to the
            },
          },
          input = { keys = { ['\\'] = 'previous_window' } },
        },
      },
      teleco = require('custom.teleco').source,
      tags = require('custom.tags').source,
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
}

local keys = {
  {
    '<leader>fd',
    function()
      snacks.picker.files {
        cwd = '~/code/dotfiles/',
      }
    end,
    { desc = '[F]earch Neovim files' },
  },
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
    '<leader>fP',
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
      local project_root = require('projects_nvim').file_project_root(cwd)
      snacks.picker.files { cwd = project_root }
    end,
  },
  {
    '<leader>ss',
    function()
      snacks.picker.pick 'smart'
    end,
  },
  {
    '<leader>sS',
    function()
      snacks.picker.pick 'pickers'
    end,
  },
  {
    '<leader>sp',
    function()
      local cwd = vim.fn.expand '%:p:h'
      local project_root = require('projects_nvim').file_project_root(cwd)
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
          if item == nil then
            snacks.picker.pick 'grep'
          else
            snacks.picker.pick('grep', { cwd = item.path })
          end
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
  { '<leader>ct', snacks.picker.lsp_type_definitions, { desc = '[T]ype Definitions' } },
  { '<leader>ci', snacks.picker.lsp_implementations, { desc = '[I]mplementations' } },
  { '<leader>cc', snacks.picker.lsp_config, { desc = '' } },
  { '<leader>ds', snacks.picker.lsp_symbols, { desc = '[D]ocument [S]ymbols' } },
  { '<leader>cs', snacks.picker.lsp_workspace_symbols, { desc = 'Workspace Symbols' } },
  { '<leader>ws', snacks.picker.lsp_workspace_symbols, { desc = 'Workspace Symbols' } },

  { '<leader>sm', snacks.picker.marks },
  { '<leader>sj', snacks.picker.jumps },
  { '<leader>sw', snacks.picker.grep_word },

  { '<leader>sgd', snacks.picker.git_diff },
  { '<leader>sgb', snacks.picker.git_branches },
  { '<leader>sgf', snacks.picker.git_files },
  { '<leader>sgll', snacks.picker.git_log },
  { '<leader>sglf', snacks.picker.git_log_file },
  { '<leader>sgll', snacks.picker.git_log_line },
  { '<leader>sgs', snacks.picker.git_status },
  { '<leader>sgS', snacks.picker.git_stash },

  { '<leader>ghpr', snacks.picker.gh_pr },

  {
    '<leader>st',
    function()
      snacks.picker.pick('tags', {})
    end,
  },

  {
    '<leader>.',
    function()
      local cwd = vim.fn.expand '%:p:h'
      snacks.picker.pick('teleco', { cwd = cwd })
    end,
  },

  { '<leader>/', snacks.picker.grep_buffers },

  {
    ' \\g',
    function()
      -- local current_pickers = snacks.picker.get { source = 'explorer' }
      -- if #current_pickers > 0 then
      --   current_pickers[1].list.win:focus()
      -- else
      snacks.picker.explorer {
        title = 'Git Changes',
        finder = GitExplorer,
        live = true,
        watch = true,
        git_untracked = true,
        diagnostics = true,
        layout = {
          preset = 'sidebar',
          preview = false,
          hidden = { 'input' },
        },
      }
      -- end
    end,
  },

  {
    '\\',
    function()
      -- local current_pickers = snacks.picker.get { source = 'explorer' }
      -- if #current_pickers > 0 then
      --   current_pickers[1].list.win:focus()
      -- else
      snacks.picker.explorer()
      -- end
    end,
  },
}

for _, key in pairs(keys) do
  vim.keymap.set('n', key[1], key[2], key[3])
end

local explorer = require 'snacks.picker.source.explorer'
local Tree = require 'snacks.explorer.tree'

---@param opts snacks.picker.explorer.Config
---@type snacks.picker.finder
function GitExplorer(opts, ctx)
  local state = explorer.get_state(ctx.picker)

  -- initial on_find (typically for follow_file), has to be done both for:
  -- * regular explorer view
  -- * when git status refreshes the view
  local state_on_find = state.on_find
  state.on_find = nil
  local on_find = function()
    if state_on_find then
      state_on_find()
    end
    Tree:walk(Tree:find(ctx.picker:cwd()), function(node)
      if node.dir then
        node.open = true
      end
    end, { all = true })
  end

  if opts.git_status then
    require('snacks.explorer.git').update(ctx.filter.cwd, {
      untracked = opts.git_untracked,
      on_update = function()
        if ctx.picker.closed then
          return
        end
        ctx.picker.list:set_target()
        ctx.picker:find { on_done = on_find }
      end,
    })
  end

  if opts.diagnostics then
    require('snacks.explorer.diagnostics').update(ctx.filter.cwd)
  end

  return function(cb)
    if on_find then
      assert(ctx.picker.matcher.task:running())
      ctx.picker.matcher.task:on('done', vim.schedule_wrap(on_find))
    end
    local items = {} ---@type table<string, snacks.picker.explorer.Item>
    local top = Tree:find(ctx.filter.cwd)
    local last = {} ---@type table<snacks.picker.explorer.Node, snacks.picker.explorer.Item>
    Tree:get(ctx.filter.cwd, function(node)
      local parent = node.parent and items[node.parent.path] or nil
      local status = node.status
      if not status and parent and parent.dir_status then
        status = parent.dir_status
      end
      local item = {
        file = node.path,
        dir = node.dir,
        open = node.open,
        dir_status = node.dir_status or parent and parent.dir_status,
        text = node.path,
        parent = parent,
        hidden = node.hidden,
        ignored = node.ignored,
        status = (not node.dir or not node.open or opts.git_status_open) and status or nil,
        last = true,
        type = node.type,
        severity = (not node.dir or not node.open or opts.diagnostics_open) and node.severity or nil,
      }
      if last[node.parent] then
        last[node.parent].last = false
      end
      last[node.parent] = item
      if top == node then
        item.hidden = false
        item.ignored = false
      end
      items[node.path] = item
      if status then
        cb(item)
      end
    end, { hidden = opts.hidden, ignored = opts.ignored, exclude = opts.exclude, include = opts.include, expand = true })
  end
end

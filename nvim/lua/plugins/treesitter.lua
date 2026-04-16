vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
}

-- NOTE: requires cargo install --locked tree-sitter-cli
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath 'data' .. '/site',
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    },
  },
}

local tmpl = [[
;extends
  (return_statement) @return.outer
  (return_statement
    (expression_list (_) @return.value))
]]
for _, lang in ipairs(require('nvim-treesitter.config').get_installed()) do
  pcall(vim.treesitter.query.set, lang, 'textobjects', string.format(tmpl, lang))
end

require('nvim-treesitter').install {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'go',
}

require('treesitter-context').setup { mode = 'topline' }

require('nvim-treesitter-textobjects').setup {
  move = {
    enable = true,
    set_jumps = true,
  },
  select = {
    enable = true,
    lookahead = true,
    lookbehind = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'v', -- linewise
      ['@function.inner'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
    include_surrounding_whitespace = function(sel)
      local query_string = sel.query_string
      -- local selection_mode = sel.selection_mode
      local cases = {
        ['@function.inner'] = true,
        ['@function.outer'] = false,
        ['@parameter.outer'] = true,
        ['@parameter.inner'] = true,
      }
      return cases[query_string] or false
    end,
  },
}

-- select keybindings
local sel = require 'nvim-treesitter-textobjects.select'
local move = require 'nvim-treesitter-textobjects.move'
for _, map in pairs {
  { 'ia', sel.select_textobject, '@parameter.inner' },
  { 'aa', sel.select_textobject, '@parameter.outer' },
  { 'ar', sel.select_textobject, '@return.outer' },
  { 'a/', sel.select_textobject, '@comment.outer' },
  { 'i/', sel.select_textobject, '@comment.inner' },
  { 'af', sel.select_textobject, '@function.outer' },
  { 'if', sel.select_textobject, '@function.inner' },
  { 'aP', sel.select_textobject, '@call.outer' },
  { 'iP', sel.select_textobject, '@call.inner' },
  { 'ab', sel.select_textobject, '@block.outer' },
  { 'ib', sel.select_textobject, '@block.inner' },
  { 'as', sel.select_textobject, '@local.scope' },
  { 'is', sel.select_textobject, '@local.scope' },

  { ']a', move.goto_next_start, '@parameter.inner' },
  { '[a', move.goto_previous_start, '@parameter.inner' },
  { ']A', move.goto_next_end, '@parameter.outer' },
  { '[A', move.goto_previous_end, '@parameter.outer' },
  { ']r', move.goto_next_start, '@return.outer' },
  { '[r', move.goto_previous_start, '@return.outer' },
  { ']R', move.goto_next_end, '@return.value' },
  { '[R', move.goto_previous_end, '@return.value' },
  { ']/', move.goto_next_start, '@comment.outer' },
  { '[/', move.goto_previous_start, '@comment.outer' },
  { ']f', move.goto_next_start, '@function.outer' },
  { '[f', move.goto_previous_start, '@function.outer' },
  { ']P', move.goto_next_start, '@call.outer' },
  { '[P', move.goto_previous_start, '@call.inner' },
  { ']s', move.goto_next_start, '@local.scope' },
  { '[s', move.goto_previous_start, '@local.scope' },
} do
  local key, fn, query = map[1], map[2], map[3]
  local verb = fn == sel.select_textobject and 'select ' or 'move to '
  local mode = fn == sel.select_textobject and { 'x', 'o' } or { 'n', 'x', 'o' }

  vim.keymap.set(mode, key, function()
    fn(query, 'textobjects')
  end, { desc = verb .. query })
end

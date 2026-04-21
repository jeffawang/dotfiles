vim.pack.add {
  { src = 'https://github.com/folke/smear-cursor.nvim', version = '66b4e9ea6773debc78073b6d41c7c0cf5c0ad954' },
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/nvim-mini/mini.statusline',
  'https://github.com/jeffawang/project.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/szw/vim-maximizer',

  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
}

vim.cmd.colorscheme 'tokyonight-night'
vim.cmd.hi 'Comment gui=none'
require('bufferline').setup { options = { mode = 'tabs', separator_style = 'slant' } }
require('todo-comments').setup { signs = false }
require('smear_cursor').setup {
  hide_target_hack = false,
  dont_erase = false,
}

require('ufo').setup()
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('projects_nvim').setup { manual_mode = false }

s = require 'mini.statusline'
s.setup()

---@diagnostic disable-next-line: duplicate-set-field
s.section_location = function()
  return '%2l:%-2v'
end

require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.opt.timeoutlen
  delay = 500,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
    -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
    -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },

  spec = { -- Document existing key chains
    { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
    { '<leader>d', group = '[D]ocument' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}

vim.keymap.set('n', '<C-w>m', '<cmd>MaximizerToggle<cr>', { desc = 'toggle maximized split' })

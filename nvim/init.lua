vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = false

-- [[ Setting options ]]
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.scrolloff = 5

vim.opt.conceallevel = 2
vim.opt.concealcursor = ''

vim.opt.autochdir = true

vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'
vim.o.swapfile = false
vim.o.autochdir = true

-- NEW
--
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = { source = 'if_many' },
  jump = { float = true },
}

require 'plugins.ui'
require 'plugins.snacks'
require 'plugins.neotree'
require 'plugins.git'
require 'plugins.orgmode'
require 'plugins.lsp'
require 'plugins.cmp'
require 'plugins.code'
require 'plugins.treesitter'

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set({ 'i', 'n' }, '<C-j>', '<C-w>w', { desc = 'Move focus to the next window' })
vim.keymap.set({ 'i', 'n' }, '<C-k>', '<C-w>W', { desc = 'Move focus to the previous window' })

-- move line(s) up and down
vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

vim.keymap.set('n', '<leader>y', '"+y', { desc = 'yank into the system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'yank into the system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'yank to end of line into the system clipboard' })

vim.keymap.set('n', '<leader>tc', '<cmd>tabnew<cr>', { desc = 'create new tab' })
vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<cr>', { desc = 'close current tab' })
vim.keymap.set('n', '<leader>tf', '<cmd>tabnew %<cr>', { desc = 'open current buffer in new tab' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>oT', '<cmd>e term://%:p:h//$SHELL<cr>', { desc = 'open a terminal in the current window' })
vim.keymap.set('n', '<leader>ot', '<cmd>sp term://%:p:h//$SHELL<cr>', { desc = 'open a terminal in a new split' })
vim.keymap.set('n', '<leader>pt', '<cmd>sp term://$SHELL<cr>', { desc = 'open a terminal in a new split' })
vim.keymap.set('n', '<leader>pT', '<cmd>e term://$SHELL<cr>', { desc = 'open a terminal in a new split' })
vim.keymap.set('n', '<leader>tt', '<cmd>tabnew<cr><cmd>e term://$SHELL<cr>', { desc = 'open a terminal in a new terminal' })

vim.keymap.set('n', '<leader>vc', function()
  vim.o.conceallevel = (vim.o.conceallevel + 1) % 4
  print('set conceallevel=' .. vim.o.conceallevel)
end)

vim.keymap.set('n', '<leader>qr', function()
  local session = vim.fn.stdpath 'state' .. '/restart_session.vim'
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
  vim.cmd('restart source ' .. vim.fn.fnameescape(session))
end, { desc = 'Restart Neovim' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.diagnostic.config { float = { border = 'rounded' } }

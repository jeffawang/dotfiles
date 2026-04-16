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

-- NEW
--
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = { source = 'if_many' },
  jump = { float = true },
}

-- pack add and setup plugins
require 'plugins'

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode

vim.keymap.set({ 'i', 'n' }, '<C-j>', '<C-w>w', { desc = 'Move focus to the next window' })
vim.keymap.set({ 'i', 'n' }, '<C-k>', '<C-w>W', { desc = 'Move focus to the previous window' })
vim.keymap.set('n', '<C-S-J>', '<cmd>tabn<cr>', { desc = 'Move focus to the next tab' })
vim.keymap.set('n', '<C-S-K>', '<cmd>tabp<cr>', { desc = 'Move focus to the previous tab' })

vim.keymap.set('n', '<leader>y', '"+y', { desc = 'yank into the system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'yank into the system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'yank to end of line into the system clipboard' })

vim.keymap.set('n', '<leader>tc', '<cmd>tabnew<cr>', { desc = 'create new tab' })
vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<cr>', { desc = 'close current tab' })
vim.keymap.set('n', '<leader>tf', '<cmd>tabnew %<cr>', { desc = 'open current buffer in new tab' })

-- TODO:
vim.keymap.set('n', '<C-w>m', '<cmd>MaximizerToggle<cr>', { desc = 'toggle maximized split' })

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

vim.keymap.set('n', '<leader>qr', '<cmd>cq 1<cr>')

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

list_snips = function()
  local ft_list = require('luasnip').available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do
    ft_snips[item.trigger] = item.name
  end
  print(vim.inspect(ft_snips))
end

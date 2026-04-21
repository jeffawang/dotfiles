vim.pack.add {
  'https://github.com/sindrets/diffview.nvim',

  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/lazydev.nvim',

  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
}

require('nvim-autopairs').setup { check_ts = true }
-- If you want to automatically add `(` after selecting a function or method
--     local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
--     local cmp = require 'cmp'

require('trouble').setup {
  open_no_results = false,
  keys = {
    ['<tab>'] = 'fold_toggle',
    x = '<cmd>Trouble diagnostics<cr>',
  },
  modes = {
    symbols = {
      win = { position = 'left' },
    },
  },
}

require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

local keys = {
  -- trouble
  {
    '<leader>K',
    function()
      -- Try symbol hover first
      local _, winid = vim.lsp.buf.hover()
      -- If no LSP hover, fall back to diagnostics float
      vim.defer_fn(function()
        if not winid or not vim.api.nvim_win_is_valid(winid) then
          vim.diagnostic.open_float(nil, { border = 'rounded' })
        end
      end, 100)
    end,
    { desc = 'Hover or diagnostic' },
  },
  { '<leader>cK', vim.diagnostic.open_float, desc = 'Diagnostics at cursor' },
  { '<leader>cd', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
  { '<leader>cD', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
  { '<leader>cS', '<cmd>Trouble symbols toggle focus=true<cr>', desc = 'Symbols (Trouble)' },
  { '<leader>cl', '<cmd>Trouble lsp toggle focus=false open_no_results=true<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
  { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
  { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },

  -- conform
  {
    '<leader>df',
    function()
      require('conform').format { async = true, lsp_format = 'fallback' }
    end,
    desc = '[F]ormat buffer',
  },
}

for _, key in pairs(keys) do
  vim.keymap.set('n', key[1], key[2], key[3])
end

--   event = { 'BufWritePre' },
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style.
    local disable_filetypes = { c = true, cpp = true }
    return {
      timeout_ms = 500,
      lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format' },
    -- -- Conform can also run multiple formatters sequentially
    -- python = function(bufnr)
    --   if require('conform').get_formatter_info('ruff_format', bufnr).available then
    --     return { 'ruff_format' }
    --   else
    --     return { 'isort', 'black' }
    --   end
    -- end,
    go = { 'goimports', 'gofmt', stop_after_first = true },
    rust = { 'rustfmt' },
    -- You can use 'stop_after_first' to run the first available formatter from the list
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  },
}

local lint = require 'lint'
lint.linters_by_ft['markdown'] = { 'markdownlint' }
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    if vim.opt_local.modifiable:get() then
      require('lint').try_lint()
    end
  end,
})

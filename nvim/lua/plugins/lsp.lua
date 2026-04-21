vim.pack.add {
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

  -- deps
  'https://github.com/j-hui/fidget.nvim',
}

local lsps = {
  ['zls'] = true,
  ['astro-language-server'] = true,
  ['goimports'] = true,
  ['gopls'] = true,
  ['hclfmt'] = true,
  ['helm-ls'] = true,
  ['lua_ls'] = true,
  ['markdownlint'] = true,
  ['pyright'] = true,
  ['ruff'] = true,
  ['rust_analyzer'] = true,
  ['stylua'] = true, -- Used to format Lua code
  ['terraform-ls'] = true,
  ['terraformls'] = true,
  ['ts_ls'] = true,
}

require 'lspconfig'
require('fidget').setup()
require('mason').setup()
require('mason-tool-installer').setup {
  ensure_installed = vim.tbl_keys(lsps),
  auto_update = false,
}

for lsp, enabled in pairs(lsps) do
  vim.lsp.enable(lsp, enabled)
end

local keys = {
  { 'n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' } },
  { 'n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' } },
  { { 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' } },
}

for _, key in ipairs(keys) do
  vim.keymap.set(key[1], key[2], key[3], key[4])
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set('', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, { desc = '[T]oggle inlay [H]ints' })
    end
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
        end,
      })
    end
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, {
      -- Optional formating of items
      convert = function(item)
        -- Remove leading misc chars for abbr name,
        -- and cap field to 25 chars
        --local abbr = item.label
        --abbr = abbr:match("[%w_.]+.*") or abbr
        --abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
        --
        -- Remove return value
        --local menu = ""

        -- Only show abbr name, remove leading misc chars (bullets etc.),
        -- and cap field to 15 chars
        local abbr = item.label
        abbr = abbr:gsub('%b()', ''):gsub('%b{}', '')
        abbr = abbr:match '[%w_.]+.*' or abbr
        abbr = #abbr > 15 and abbr:sub(1, 14) .. '…' or abbr

        -- Cap return value field to 15 chars
        local menu = item.detail or ''
        menu = #menu > 15 and menu:sub(1, 14) .. '…' or menu

        return { abbr = abbr, menu = menu }
      end,
    })
  end,
})

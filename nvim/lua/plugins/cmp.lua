vim.pack.add {
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',

  'https://github.com/dcampos/nvim-snippy',
  'https://github.com/dcampos/cmp-snippy',
  'https://github.com/honza/vim-snippets',
}

local snippy = require 'snippy'
snippy.setup {}
require 'cmp_nvim_lsp'
require 'cmp_path'

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },

  completion = { completeopt = 'menu,menuone,noinsert' },
  mapping = cmp.mapping.preset.insert {
    -- Select the [n]ext item
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    -- Select the [p]revious item
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),

    -- Scroll the documentation window [b]ack / [f]orward
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-y>'] = cmp.mapping.confirm { select = true },

    -- Manually trigger a completion from nvim-cmp.
    ['<C-Space>'] = cmp.mapping.complete {},

    -- jump to next snippet thing
    ['<C-l>'] = cmp.mapping(function(fallback)
      if snippy.can_jump(1) then
        snippy.next()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-h>'] = cmp.mapping(function(fallback)
      if snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    {
      name = 'lazydev',
      -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      group_index = 0,
    },
    { name = 'nvim_lsp' },
    { name = 'snippy' },
    { name = 'path' },
  },
}

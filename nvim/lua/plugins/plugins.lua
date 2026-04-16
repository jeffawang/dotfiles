return {

  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/szw/vim-maximizer',

  -- coding
  {
    src = 'https://github.com/folke/trouble.nvim',
    name = 'trouble.nvim',
    config = function(spec, trouble)
      trouble.setup(spec.opts)
    end,
    opts = {
      open_no_results = false,
      keys = {
        -- ['<tab>'] = 'fold_toggle',
        x = '<cmd>Trouble diagnostics<cr>',
      },
      modes = {
        symbols = {
          win = { position = 'left' },
        },
      },
    },
    keys = {
      {
        '<leader>K',
        function()
          -- Try symbol hover first
          local bufnr, winid = vim.lsp.buf.hover()
          -- If no LSP hover, fall back to diagnostics float
          vim.defer_fn(function()
            if not winid or not vim.api.nvim_win_is_valid(winid) then
              vim.diagnostic.open_float(nil, { border = 'rounded' })
            end
          end, 50)
        end,
        { desc = 'Hover or diagnostic' },
      },

      {
        '<leader>cK',
        vim.diagnostic.open_float,
        desc = 'Diagnostics at cursor',
      },
      {
        '<leader>cd',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>cD',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cS',
        '<cmd>Trouble symbols toggle focus=true<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false open_no_results=true<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },

  {
    -- configures lua LSP for neovim, etc.
    src = 'https://github.com/folke/lazydev.nvim',
    -- TODO: ft
    ft = 'lua',
    config = function(spec, lazydev)
      lazydev.setup(spec.opts)
    end,
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    src = 'https://github.com/williamboman/mason.nvim',
    config = function(mason)
      mason.setup()
    end,
  },

  {
    src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      local servers = {
        ['helm-ls'] = {
          yamlls = {
            enabled = true,
            enabledForFilesGlob = '*.{yaml,yml}',
            path = 'yaml-language-server',
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'astro-language-server',
        'goimports',
        'gopls',
        'hclfmt',
        'markdownlint',
        'pyright',
        'ruff',
        'rust_analyzer',
        'stylua', -- Used to format Lua code
        'terraform-ls',
        'terraformls',
        'ts_ls',
        -- TODO: yamlls failed to install
        -- 'yamlls',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    -- Main LSP Configuration
    src = 'https://github.com/neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'j-hui/fidget.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>cr', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- highlight references of the word under cursor after a time
          --    See `:help CursorHold` for information about when this is executed
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- keymap: toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
    end,
  },

  -- TODO: conform lua doesn't respect spacing thing
  { -- Autoformat
    src = 'https://github.com/stevearc/conform.nvim',
    -- TODO: events
    event = { 'BufWritePre' },
    -- TODO: cmd
    cmd = { 'ConformInfo' },
    config = function(spec, conform)
      conform.setup(spec.opts)
    end,
    keys = function(conform)
      return {
        {
          '<leader>df',
          function()
            conform.format { async = true, lsp_format = 'fallback' }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      }
    end,
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
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
        go = { 'goimports', 'gofmt' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  {
    src = 'https://github.com/rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  {
    src = 'https://github.com/L3MON4D3/LuaSnip',
    -- TODO: build...?
    build = (function()
      -- Build Step is needed for regex support in snippets.
      -- This step is not supported in many windows environments.
      -- Remove the below condition to re-enable on windows.
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),
    dependencies = {
      -- `friendly-snippets` contains a variety of premade snippets.
      --    See the README about individual language/framework/plugin snippets:
      --    https://github.com/rafamadriz/friendly-snippets
    },
  },

  -- TODO:
  { -- Autocompletion
    src = 'https://github.com/hrsh7th/nvim-cmp',
    -- TODO: events
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function(cmp, luasnip)
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
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

          -- Accept ([y]es) the completion. Auto-import if LSP supports it and
          -- expand snippets
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- jump to next snippet thing
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    src = 'https://github.com/folke/todo-comments.nvim',
    -- TODO: events
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- NOTE: requires cargo install --locked tree-sitter-cli
  { -- Highlight, edit, and navigate code
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    -- TODO: build
    build = ':TSUpdate',
    -- TODO: main...?
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    config = function(spec)
      local ts = require 'nvim-treesitter'
      ts.setup(spec.opts)
      ts.install(spec.opts.ensure_installed)
    end,
    opts = {
      -- NOTE: these install things are deprecated, but we use them manually in config()
      install_dir = vim.fn.stdpath 'data' .. '/site',
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'go' },
      auto_install = true,

      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },

      indent = { enable = true, disable = { 'ruby' } },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
  },

  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    stupid_requires = {
      ['goto_next_start'] = { 'nvim-treesitter-textobjects.move', 'goto_next_start' },
      ['goto_next_end'] = { 'nvim-treesitter-textobjects.move', 'goto_next_end' },
      ['goto_previous_start'] = { 'nvim-treesitter-textobjects.move', 'goto_previous_start' },
      ['goto_previous_end'] = { 'nvim-treesitter-textobjects.move', 'goto_previous_end' },
      ['select_textobject'] = { 'nvim-treesitter-textobjects.select', 'select_textobject' },
      ['goto_next'] = { 'nvim-treesitter-textobjects.move', 'goto_next' },
      ['goto_previous'] = { 'nvim-treesitter-textobjects.move', 'goto_previous' },
      ['repeatable_move'] = 'nvim-treesitter-textobjects.repeatable_move',
    },
    config = function(spec)
      -- NOTE: not sure if this breaks stuff
      vim.g.no_plugin_maps = true
      require('nvim-treesitter-textobjects').setup(spec.opts)

      -- support return statements. Tested with go/lua, but depends on treesitter grammar.
      for _, lang in ipairs(require('nvim-treesitter.config').get_installed()) do
        local tmpl = ';extends \
                      (return_statement) @return.outer \
                      (return_statement \
                         (expression_list (_) @return.value))'
        pcall(vim.treesitter.query.set, lang, 'textobjects', string.format(tmpl, lang))
      end
    end,
    keys = function(goto_next_start, goto_previous_start, goto_next_end, goto_previous_end, goto_next, goto_previous, select_textobject, repeatable_move)
      local curry = function(fn, query, group)
        return function()
          fn(query, group)
        end
      end
      return {
        -- override (f, F, t, T) to work with treesitter but also do default behavior
        { ';', repeatable_move.repeat_last_move },
        { ',', repeatable_move.repeat_last_move_opposite },
        { 'f', repeatable_move.builtin_f_expr, { expr = true } },
        { 'F', repeatable_move.builtin_F_expr, { expr = true } },
        { 't', repeatable_move.builtin_t_expr, { expr = true } },
        { 'T', repeatable_move.builtin_T_expr, { expr = true } },

        { ']a', curry(goto_next_start, '@parameter.inner', 'textobjects'), { desc = 'next [A]rg' }, mode = { 'n', 'v', 'o' } },
        { '[a', curry(goto_previous_start, '@parameter.inner', 'textobjects'), { desc = 'previous [A]rg' }, mode = { 'n', 'v', 'o' } },
        { ']A', curry(goto_next_end, '@parameter.outer', 'textobjects'), { desc = 'next [A]rg outer' }, mode = { 'n', 'v', 'o' } },
        { '[A', curry(goto_previous_end, '@parameter.outer', 'textobjects'), { desc = 'previous [A]rg outer' }, mode = { 'n', 'v', 'o' } },
        { 'ia', curry(select_textobject, '@parameter.inner', 'textobjects'), { desc = '[I]n [A]rg' }, mode = { 'n', 'v', 'o' } },
        { 'aa', curry(select_textobject, '@parameter.outer', 'textobjects'), { desc = '[A]round [A]rg' }, mode = { 'n', 'v', 'o' } },

        { ']R', curry(goto_next_start, '@return.value', 'textobjects'), { desc = 'next [R]eturn statement' }, mode = { 'n', 'v', 'o' } },
        { '[R', curry(goto_previous_start, '@return.value', 'textobjects'), { desc = 'previous [R]eturn statement' }, mode = { 'n', 'v', 'o' } },
        { ']r', curry(goto_next_start, '@return.outer', 'textobjects'), { desc = 'next [R]eturn statement' }, mode = { 'n', 'v', 'o' } },
        { '[r', curry(goto_previous_start, '@return.outer', 'textobjects'), { desc = 'previous [R]eturn statement' }, mode = { 'n', 'v', 'o' } },
        { 'ar', curry(select_textobject, '@return.outer', 'textobjects'), { desc = '[A]round [R]eturn statement' }, mode = { 'n', 'v', 'o' } },

        { ']/', curry(goto_next_start, '@comment.outer', 'textobjects'), { desc = '[A]round [C]omment' }, mode = { 'n', 'v', 'o' } },
        { '[/', curry(goto_previous_start, '@comment.outer', 'textobjects'), { desc = '[A]round [C]omment' }, mode = { 'n', 'v', 'o' } },
        { 'a/', curry(select_textobject, '@comment.outer', 'textobjects'), { desc = '[A]round [C]omment' }, mode = { 'n', 'v', 'o' } },
        { 'i/', curry(select_textobject, '@comment.inner', 'textobjects'), { desc = '[I]n [C]omment' }, mode = { 'n', 'v', 'o' } },

        { ']f', curry(goto_next_start, '@function.outer', 'textobjects'), { desc = 'next [F]unction' }, mode = { 'n', 'v', 'o' } },
        { '[f', curry(goto_previous_start, '@function.outer', 'textobjects'), { desc = 'previous [F]unction' }, mode = { 'n', 'v', 'o' } },
        { 'af', curry(select_textobject, '@function.outer', 'textobjects'), { desc = '[A]round [F]unction' }, mode = { 'n', 'v', 'o' } },
        { 'if', curry(select_textobject, '@function.inner', 'textobjects'), { desc = '[I]n [F]unction' }, mode = { 'n', 'v', 'o' } },

        { ']P', curry(goto_next_start, '@call.outer', 'textobjects'), { desc = 'next [P]arameter list' }, mode = { 'n', 'v', 'o' } },
        { '[P', curry(goto_previous_start, '@call.inner', 'textobjects'), { desc = 'previous [P]arameter list' }, mode = { 'n', 'v', 'o' } },
        { 'aP', curry(select_textobject, '@call.outer', 'textobjects'), { desc = '[A]round [P]arameter list' }, mode = { 'n', 'v', 'o' } },
        { 'iP', curry(select_textobject, '@call.inner', 'textobjects'), { desc = '[I]n [P]arameter list' }, mode = { 'n', 'v', 'o' } },

        { 'ab', curry(select_textobject, '@block.outer', 'textobjects'), { desc = '[A]round [B]lock' }, mode = { 'n', 'v', 'o' } },
        { 'ib', curry(select_textobject, '@block.inner', 'textobjects'), { desc = '[I]n [B]lock' }, mode = { 'n', 'v', 'o' } },

        { ']s', curry(goto_next_start, '@local.scope', 'locals'), { desc = '[A]round [S]cope' }, mode = { 'n', 'v', 'o' } },
        { '[s', curry(goto_previous_start, '@local.scope', 'locals'), { desc = '[A]round [S]cope' }, mode = { 'n', 'v', 'o' } },
        { 'as', curry(select_textobject, '@local.scope', 'locals'), { desc = '[A]round [S]cope' }, mode = { 'n', 'v', 'o' } },
        { 'is', curry(select_textobject, '@local.scope', 'locals'), { desc = '[I]n [S]cope' }, mode = { 'n', 'v', 'o' } },
      }
    end,
    opts = {
      move = {
        enable = true,
        set_jumps = true,
      },
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        lookbehind = true,

        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should raeturn the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
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
    },
  },

  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-context',
    config = function(spec)
      require('treesitter-context').setup(spec.opts)
    end,
    opts = {
      mode = 'topline',
    },
  },

  -- TODO:
  { -- Linting
    src = 'https://github.com/mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function(lint)
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  {
    src = 'https://github.com/windwp/nvim-autopairs',
    -- event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  'https://github.com/kevinhwang91/promise-async',
  {
    src = 'https://github.com/kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function(ufo)
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup()
    end,
  },
}

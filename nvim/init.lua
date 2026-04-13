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

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.opt.clipboard = 'unnamedplus'
-- end)

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
-- vim.diagnostic.config {
--   severity_sort = true,
--   update_in_insert = false,
--   float = { source = 'if_many' },
--   jump = { float = true },
-- }

-- plugins
-- update with :lua vim.pack.update()

-- 'szw/vim-maximizer',
-- 'folke/smear-cursor.nvim'

-- local site = vim.fn.stdpath 'data' .. '/site'
-- vim.opt.packpath:prepend(vim.fn.stdpath 'data' .. '/site')
-- vim.pack.add {
--   { src = 'https://github.com/folke/trouble.nvim', name = 'trouble.nvim' },
-- }
-- vim.cmd.packadd 'trouble.nvim'
-- require('trouble').setup {}
--
--
local trouble_path = vim.fn.stdpath 'data' .. '/site/pack/core/opt/trouble.nvim'

vim.opt.runtimepath:append(trouble_path)

local plugins = {

  'https://github.com/nvim-lua/plenary.nvim',
  require 'custom.plugins.snacks',

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    src = 'https://github.com/folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    src = 'https://github.com/tpope/vim-fugitive',
    name = 'vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gB', '<cmd>Git blame<cr>', { desc = '[G]it [B]lame' })
    end,
  },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

  'https://github.com/sindrets/diffview.nvim', -- optional - Diff integration
  -- 'https://github.com/folke/snacks.nvim',

  {
    src = 'https://github.com/NeogitOrg/neogit',
    name = 'neogit',
    -- dependencies = {
    --   'nvim-lua/plenary.nvim', -- required
    --   'sindrets/diffview.nvim', -- optional - Diff integration
    -- },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {
        -- integrations = { snacks = true },
        disable_hint = true,
        status = {
          mode_text = {},
        },
      }

      vim.keymap.set('n', '<leader>gg', '<cmd>:Neogit<cr>', { desc = 'neogit' })
      vim.keymap.set('n', '<leader>gb', '<cmd>:Neogit branch<cr>', { desc = 'neogit' })
      vim.keymap.set('n', '<leader>gc', '<cmd>:Neogit commit<cr>', { desc = 'neogit' })
      -- git blame from gitsigns
    end,
  },
  {
    src = 'https://github.com/folke/trouble.nvim',
    name = 'trouble.nvim',
    config = function(spec)
      require('trouble').setup(spec.opts)
    end,
  },

  -- TODO:
  { -- Useful plugin to show you pending keybinds.
    src = 'https://github.com/folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
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

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- TODO:
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    src = 'https://github.com/folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  'https://github.com/hrsh7th/cmp-nvim-lsp',
  {
    src = 'https://github.com/williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/hrsh7th/nvim-cmp',

  -- TODO:
  {
    -- Main LSP Configuration
    src = 'https://github.com/neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'williamboman/mason.nvim',
        opts = {},
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      {
        'j-hui/fidget.nvim',
        opts = {},
      },

      -- Allows extra capabilities provided by nvim-cmp
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

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          -- map('gD', require('telescope.builtin').lsp_references, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- vim.lsp.config('yamlls', {
          --   settings = {
          --     yaml = {
          --       schemas = {
          --         ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json'] = '*.yaml',
          --       },
          --     },
          --   },
          -- })
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      -- if vim.g.have_nerd_font then
      --   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      --   local diagnostic_signs = {}
      --   for type, icon in pairs(signs) do
      --     diagnostic_signs[vim.diagnostic.severity[type]] = icon
      --   end
      --   vim.diagnostic.config { signs = { text = diagnostic_signs } }
      -- end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        ['helm-ls'] = {
          yamlls = {
            enabled = true,
            enabledForFilesGlob = '*.{yaml,yml}',
            path = 'yaml-language-server',
          },
        },
        -- TODO:
        -- lua_ls = {
        --   -- cmd = { ... },
        --   -- filetypes = { ... },
        --   -- capabilities = {},
        --   settings = {
        --     Lua = {
        --       completion = {
        --         callSnippet = 'Replace',
        --       },
        --       -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        --       -- diagnostics = { disable = { 'missing-fields' } },
        --     },
        --   },
        -- },
      }

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

  -- TODO:
  { -- Autoformat
    src = 'https://github.com/stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>df',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
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

  -- TODO:
  -- { -- Autocompletion
  --   src = 'https://github.com/hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     {
  --       'L3MON4D3/LuaSnip',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --         -- `friendly-snippets` contains a variety of premade snippets.
  --         --    See the README about individual language/framework/plugin snippets:
  --         --    https://github.com/rafamadriz/friendly-snippets
  --         {
  --           'rafamadriz/friendly-snippets',
  --           config = function()
  --             require('luasnip.loaders.from_vscode').lazy_load()
  --           end,
  --         },
  --       },
  --     },
  --     'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --   },
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     local luasnip = require 'luasnip'
  --     luasnip.config.setup {}
  --
  --     cmp.setup {
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the [n]ext item
  --         ['<C-n>'] = cmp.mapping.select_next_item(),
  --         ['<C-j>'] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         ['<C-p>'] = cmp.mapping.select_prev_item(),
  --         ['<C-k>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<C-y>'] = cmp.mapping.confirm { select = true },
  --         -- ['<Tab>'] = cmp.mapping.confirm { select = true },
  --         -- ['<Return>'] = cmp.mapping.confirm { select = true },
  --
  --         -- If you prefer more traditional completion keymaps,
  --         -- you can uncomment the following lines
  --         --['<CR>'] = cmp.mapping.confirm { select = true },
  --         --['<Tab>'] = cmp.mapping.select_next_item(),
  --         --['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ['<C-l>'] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { 'i', 's' }),
  --         ['<C-h>'] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { 'i', 's' }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       },
  --       sources = {
  --         {
  --           name = 'lazydev',
  --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
  --           group_index = 0,
  --         },
  --         { name = 'nvim_lsp' },
  --         { name = 'luasnip' },
  --         { name = 'path' },
  --       },
  --     }
  --   end,
  -- },

  {
    src = 'https://github.com/folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    src = 'https://github.com/akinsho/bufferline.nvim',
    opts = {
      options = {
        mode = 'tabs',
        separator_style = 'slant',
      },
    },
  },

  -- TODO:
  { -- Linting
    src = 'https://github.com/mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
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

  -- 'https://github.com/folke/lazydev.nvim',
  -- 'https://github.com/neovim/nvim-lspconfig',
  -- 'https://github.com/akinsho/bufferline.nvim',

  {
    src = 'https://github.com/windwp/nvim-autopairs',
    -- event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    src = 'https://github.com/lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text_pos = 'right_align',
        delay = 0,
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- -- Actions
        -- -- visual mode
        -- map('v', '<leader>hs', function()
        --   gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        -- end, { desc = 'git [s]tage hunk' })
        -- map('v', '<leader>hr', function()
        --   gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        -- end, { desc = 'git [r]eset hunk' })
        -- -- normal mode
        -- map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        -- map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        -- map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        -- map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        -- map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        -- map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        -- map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        -- map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        -- map('n', '<leader>hD', function()
        --   gitsigns.diffthis '@'
        -- end, { desc = 'git [D]iff against last commit' })
        -- -- Toggles
        -- map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })

        map('n', '<leader>glB', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        -- map('n', '<leader>gB', gitsigns.blame, { desc = '[T]oggle git show [b]lame' })
      end,
    },
  },

  'https://github.com/MunifTanjim/nui.nvim',
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    -- version = '*',
    dev = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    -- TODO:
    keys = {
      -- { '\\', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
      { '<leader>\\s', '<cmd>Neotree document_symbols<cr>', desc = 'NeoTree Document [S]ymbols' },
      { '<leader>\\b', '<cmd>Neotree buffers<cr>', desc = 'NeoTree [B]uffers' },
      { '<leader>\\g', '<cmd>Neotree git_status<cr>', desc = 'NeoTree [G]it status' },
      { '<leader>\\f', '<cmd>Neotree reveal<cr>', desc = 'NeoTree [G]it status' },
      { '<leader>g\\', '<cmd>Neotree git_status<cr>', desc = 'NeoTree [G]it status' },
    },
    opts = {
      default_component_configs = {
        name = {
          trailing_slash = true,
          highlight_opened_files = true,
        },
      },
      source_selector = {
        winbar = true,
        tabs_layout = 'equal',
        show_separator_on_edge = true,
        sources = {
          { source = 'filesystem' },
          { source = 'buffers' },
          { source = 'git_status' },
          { source = 'document_symbols' },
        },
      },
      reveal_force_cwd = true,
      use_popups_for_input = false,
      sources = {
        'filesystem',
        'buffers',
        'git_status',
        'document_symbols',
      },
      commands = {
        previous_window = function()
          local keys = vim.api.nvim_replace_termcodes('<c-w>p', true, false, true)
          vim.api.nvim_feedkeys(keys, 'n', false)
        end,
      },
      window = {
        mappings = {
          ['\\'] = 'previous_window',
          ['/'] = '', -- just search like a normal vim user ok?
          ['<space>'] = nil,
        },
      },
      filesystem = {
        search_limit = 500, -- max number of search results when using filters
        window = {
          mappings = {
            ['<tab>'] = 'toggle_node',
            ['F'] = 'filter_as_you_type',
          },
        },
        follow_current_file = {
          enabled = false, -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
      document_symbols = {
        window = {
          mappings = {
            ['<tab>'] = 'toggle_node',
          },
        },
      },
      git_status = {
        window = {
          mappings = {
            ['gg'] = '', -- just search like a normal vim user ok?
            ['gC'] = 'git_commit_and_push', -- just search like a normal vim user ok?
          },
        },
      },
    },
  },
  {
    src = 'https://github.com/nvim-orgmode/orgmode',
    enabled = true,
    event = 'VeryLazy',
    ft = { 'org' },
    dependencies = {
      'jeffawang/snacks.nvim',
    },
    config = function()
      require('orgmode').setup {
        org_startup_folded = 'inherit',
        org_hide_leading_stars = true,
        org_hide_emphasis_markers = true,
        org_blank_before_new_entry = {
          heading = false,
          plain_list_item = false,
        },
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/home.org',
        org_todo_keywords = {
          'TODO',
          'DOING',
          '|',
          'DONE',
        },
        org_todo_keyword_faces = {
          DOING = ':foreground yellow :weight bold',
        },
        org_agenda_custom_commands = {
          k = {
            description = 'Todos, including DOING',
            types = {
              {
                type = 'tags_todo',
                match = '/TODO|DOING',
                org_agenda_sorting_strategy = { 'todo-state-down', 'priority-down' }, -- See all options available on org_agenda_sorting_strategy
              },
            },
          },
          K = {
            description = 'Todos, including DOING and DONE',
            types = {
              {
                type = 'tags_todo',
                match = '/TODO|DOING|DONE',
                org_agenda_sorting_strategy = { 'todo-state-down', 'priority-down' }, -- See all options available on org_agenda_sorting_strategy
              },
            },
          },
          d = {
            description = 'Todos that are DONE',
            types = {
              {
                type = 'tags_todo',
                match = '/DONE',
                org_agenda_sorting_strategy = { 'todo-state-down', 'priority-down' }, -- See all options available on org_agenda_sorting_strategy
              },
            },
          },
        },
        org_capture_templates = {
          d = {
            description = 'Journal',
            template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
            target = '~/sync/org/journal.org',
          },
          j = {
            description = 'Journal',
            template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
            target = '~/orgfiles/journal.org',
          },
        },
        mappings = {
          org = {
            org_next_visible_heading = ']]',
            org_previous_visible_heading = '[[',
            org_forward_heading_same_level = ']}',
            org_backward_heading_same_level = '[{',
          },
        },
      }
    end,
    keys = {
      {
        '<leader>oiH',
        function()
          local org = require 'orgmode'
          org.action('org_mappings.insert_heading_respect_content', ' ')
          org.action 'org_mappings.do_demote'
        end,
        desc = 'Insert a heading as a child of the current one',
      },
      {
        '<leader>o>',
        function()
          require('orgmode').action 'org_mappings.todo_next_state'
        end,
      },
      {
        '<leader>o<',
        function()
          require('orgmode').action 'org_mappings.todo_prev_state'
        end,
      },
      {
        -- TODO: this doesn't overwrite the default binding...
        '<leader>oiT',
        function()
          local org = require 'orgmode'
          org.action 'org_mappings.insert_todo_heading'
          org.action 'org_mappings.do_demote'
        end,
        desc = 'Insert a todo as a child of the current one',
      },
      {
        -- TODO: make this open the default_notes_file
        '<leader>oh',
        '<cmd>e ~/orgfiles/home.org<cr>',
        desc = 'Open the home.org file',
      },
      {
        '<leader>oj',
        '<cmd>e ~/orgfiles/journal.org<cr>',
        desc = 'Open the journal.org file',
      },
      {
        '<leader>oH',
        function()
          require('snacks').picker.files {
            cwd = '~/orgfiles/',
            pattern = '',
          }
        end,
        desc = 'Fuzzy find orgfiles',
      },
    },
  },

  -- 'https://github.com/jeffawang/telescope-egrepify.nvim',
  {
    src = 'https://github.com/jeffawang/project.nvim',
    -- TODO
    dev = true,
    enabled = true,
    manual_mode = false,
    detection_methods = { 'pattern' },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'jeffawang/telescope-egrepify.nvim',
    },
    config = function()
      require('projects_nvim').setup {
        manual_mode = false,
      }
    end,
  },
}

for i = #plugins, 1, -1 do
  if plugins[i].enabled == false then
    table.remove(plugins, i)
  end
end

vim.pack.add(plugins, { load = true })

function GetArgs(func)
  local args = {}
  for i = 1, debug.getinfo(func).nparams, 1 do
    table.insert(args, debug.getlocal(func, i))
  end
  return args
end

for _, spec in ipairs(plugins) do
  if spec.config then
    spec.config(spec)
  end
  if spec.keys then
    local keys = spec.keys
    if type(spec.keys) == 'function' then
      local args = {}
      for i, arg in ipairs(GetArgs(spec.keys)) do
        vim.print(arg)
        args[i] = require(arg)
      end
      keys = spec.keys(unpack(args))
    end
    for _, key in ipairs(keys) do
      vim.keymap.set('n', key[1], key[2], key[3])
    end
  end
end

-- do
--   local to_add = {}
--   local to_configure = {}
--
--   for _, spec in ipairs(plugins) do
--     if type(spec) == 'string' then
--       table.insert(to_add, spec)
--     elseif type(spec) == 'table' then
--       table.insert(to_add, spec[1])
--       if spec.opts then
--         table.insert(to_configure, function()
--           require(spec[1]).setup(spec.opts)
--         end)
--       end
--       if spec.config then
--         table.insert(to_configure, spec.config)
--       end
--     end
--   end
--
--   -- TODO: lazy command loading
--
--   vim.pack.add(plugins, { load = true })
--   for _, f in ipairs(to_configure) do
--     f()
--   end
-- end

-- vim.pack.add {
--   'https://github.com/ibhagwan/fzf-lua',
--   -- 'https://github.com/tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
--   -- 'https://github.com/tpope/vim-surround',
--   -- 'https://github.com/nvim-treesitter/nvim-treesitter', -- requires tree-sitter cli
--   -- 'https://github.com/echasnovski/mini.nvim',
--   'https://github.com/tpope/vim-fugitive',
-- }

-- { -- Collection of various small independent plugins/modules
--   'echasnovski/mini.nvim',
--   config = function()
--     -- Better Around/Inside textobjects
--     --
--     -- Examples:
--     --  - va)  - [V]isually select [A]round [)]paren
--     --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--     --  - ci'  - [C]hange [I]nside [']quote
--     require('mini.ai').setup { n_lines = 500 }
--
--     -- Add/delete/replace surroundings (brackets, quotes, etc.)
--     --
--     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--     -- - sd'   - [S]urround [D]elete [']quotes
--     -- - sr)'  - [S]urround [R]eplace [)] [']
--     require('mini.surround').setup()
--
--     local statusline = require 'mini.statusline'
--     statusline.setup {
--       use_icons = true,
--     }
--
--     -- You can configure sections in the statusline by overriding their
--     -- default behavior. For example, here we set the section for
--     -- cursor location to LINE:COLUMN
--     ---@diagnostic disable-next-line: duplicate-set-field
--     statusline.section_location = function()
--       return '%2l:%-2v'
--     end
--
--     ---@diagnostic disable-next-line: duplicate-set-field
--     statusline.inactive = function()
--       if vim.g.ministatusline_disable == true or vim.b.ministatusline_disable == true then
--         return ''
--       end
--       return '%#MiniStatuslineInactive#%F%m%r%='
--     end
--   end,
-- },

-- END NEW

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

vim.keymap.set('n', '<C-w>m', '<cmd>MaximizerToggle<cr>', { desc = 'toggle maximized split' })

vim.keymap.set('n', '<leader>oT', '<cmd>e term://%:p:h//$SHELL<cr>', { desc = 'open a terminal in the current window' })
vim.keymap.set('n', '<leader>ot', '<cmd>sp term://%:p:h//$SHELL<cr>', { desc = 'open a terminal in a new split' })
vim.keymap.set('n', '<leader>pt', '<cmd>sp term://$SHELL<cr>', { desc = 'open a terminal in a new split' })
vim.keymap.set('n', '<leader>pT', '<cmd>e term://$SHELL<cr>', { desc = 'open a terminal in a new split' })
vim.keymap.set('n', '<leader>tt', '<cmd>tabnew<cr><cmd>e term://$SHELL<cr>', { desc = 'open a terminal in a new terminal' })

vim.keymap.set('n', '<leader>vc', function()
  vim.o.conceallevel = (vim.o.conceallevel + 1) % 4
  print('set conceallevel=' .. vim.o.conceallevel)
end)

-- exit with code 1. Can be used with this function to restart nvim quickly:
-- function nvr() {
--     while true; do
--         nvim "$@"
--         if [ $? -ne 1 ]; then
--             break
--         fi
--     done
-- }
vim.keymap.set('n', '<leader>qr', '<cmd>cq 1<cr>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- require('lazy').setup({
--
--   -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
--   -- 'folke/snacks.nvim',
--
--   -- {
--   --   'folke/trouble.nvim',
--   --   opts = {
--   --     open_no_results = false,
--   --     keys = {
--   --       -- ['<tab>'] = 'fold_toggle',
--   --       x = '<cmd>Trouble diagnostics<cr>',
--   --     },
--   --     modes = {
--   --       symbols = {
--   --         win = { position = 'left' },
--   --       },
--   --     },
--   --   }, -- for default options, refer to the configuration section for custom setup.
--   --   cmd = 'Trouble',
--   --   keys = {
--   --     {
--   --       '<leader>K',
--   --       function()
--   --         -- Try symbol hover first
--   --         local bufnr, winid = vim.lsp.buf.hover()
--   --         -- If no LSP hover, fall back to diagnostics float
--   --         vim.defer_fn(function()
--   --           if not winid or not vim.api.nvim_win_is_valid(winid) then
--   --             vim.diagnostic.open_float(nil, { border = 'rounded' })
--   --           end
--   --         end, 50)
--   --       end,
--   --       { desc = 'Hover or diagnostic' },
--   --     },
--   --
--   --     {
--   --       '<leader>cK',
--   --       vim.diagnostic.open_float,
--   --       desc = 'Diagnostics at cursor',
--   --     },
--   --     {
--   --       '<leader>cd',
--   --       '<cmd>Trouble diagnostics toggle<cr>',
--   --       desc = 'Diagnostics (Trouble)',
--   --     },
--   --     {
--   --       '<leader>cD',
--   --       '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
--   --       desc = 'Buffer Diagnostics (Trouble)',
--   --     },
--   --     {
--   --       '<leader>cS',
--   --       '<cmd>Trouble symbols toggle focus=true<cr>',
--   --       desc = 'Symbols (Trouble)',
--   --     },
--   --     {
--   --       '<leader>cl',
--   --       '<cmd>Trouble lsp toggle focus=false open_no_results=true<cr>',
--   --       desc = 'LSP Definitions / references / ... (Trouble)',
--   --     },
--   --     {
--   --       '<leader>xL',
--   --       '<cmd>Trouble loclist toggle<cr>',
--   --       desc = 'Location List (Trouble)',
--   --     },
--   --     {
--   --       '<leader>xQ',
--   --       '<cmd>Trouble qflist toggle<cr>',
--   --       desc = 'Quickfix List (Trouble)',
--   --     },
--   --   },
--   -- },
--
--   -- { -- Useful plugin to show you pending keybinds.
--   --   'folke/which-key.nvim',
--   --   event = 'VimEnter', -- Sets the loading event to 'VimEnter'
--   --   opts = {
--   --     -- delay between pressing a key and opening which-key (milliseconds)
--   --     -- this setting is independent of vim.opt.timeoutlen
--   --     delay = 500,
--   --     icons = {
--   --       -- set icon mappings to true if you have a Nerd Font
--   --       mappings = vim.g.have_nerd_font,
--   --       -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
--   --       -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
--   --       keys = vim.g.have_nerd_font and {} or {
--   --         Up = '<Up> ',
--   --         Down = '<Down> ',
--   --         Left = '<Left> ',
--   --         Right = '<Right> ',
--   --         C = '<C-…> ',
--   --         M = '<M-…> ',
--   --         D = '<D-…> ',
--   --         S = '<S-…> ',
--   --         CR = '<CR> ',
--   --         Esc = '<Esc> ',
--   --         ScrollWheelDown = '<ScrollWheelDown> ',
--   --         ScrollWheelUp = '<ScrollWheelUp> ',
--   --         NL = '<NL> ',
--   --         BS = '<BS> ',
--   --         Space = '<Space> ',
--   --         Tab = '<Tab> ',
--   --         F1 = '<F1>',
--   --         F2 = '<F2>',
--   --         F3 = '<F3>',
--   --         F4 = '<F4>',
--   --         F5 = '<F5>',
--   --         F6 = '<F6>',
--   --         F7 = '<F7>',
--   --         F8 = '<F8>',
--   --         F9 = '<F9>',
--   --         F10 = '<F10>',
--   --         F11 = '<F11>',
--   --         F12 = '<F12>',
--   --       },
--   --     },
--   --
--   --     -- Document existing key chains
--   --     spec = {
--   --       { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
--   --       { '<leader>d', group = '[D]ocument' },
--   --       { '<leader>r', group = '[R]ename' },
--   --       { '<leader>s', group = '[S]earch' },
--   --       { '<leader>w', group = '[W]orkspace' },
--   --       { '<leader>t', group = '[T]oggle' },
--   --       { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
--   --     },
--   --   },
--   -- },
--   -- {
--   --   'NeogitOrg/neogit',
--   --   dependencies = {
--   --     'nvim-lua/plenary.nvim', -- required
--   --     'sindrets/diffview.nvim', -- optional - Diff integration
--   --   },
--   --   config = function()
--   --     local neogit = require 'neogit'
--   --     neogit.setup {
--   --       -- integrations = { snacks = true },
--   --       disable_hint = true,
--   --       status = {
--   --         mode_text = {},
--   --       },
--   --     }
--   --
--   --     vim.keymap.set('n', '<leader>gg', '<cmd>:Neogit<cr>', { desc = 'neogit' })
--   --     vim.keymap.set('n', '<leader>gb', '<cmd>:Neogit branch<cr>', { desc = 'neogit' })
--   --     vim.keymap.set('n', '<leader>gc', '<cmd>:Neogit commit<cr>', { desc = 'neogit' })
--   --     -- git blame from gitsigns
--   --   end,
--   -- },
--
--   -- LSP Plugins
--   -- {
--   --   -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
--   --   -- used for completion, annotations and signatures of Neovim apis
--   --   'folke/lazydev.nvim',
--   --   ft = 'lua',
--   --   opts = {
--   --     library = {
--   --       -- Load luvit types when the `vim.uv` word is found
--   --       { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
--   --     },
--   --   },
--   -- },
--   -- {
--   --   -- Main LSP Configuration
--   --   'neovim/nvim-lspconfig',
--   --   dependencies = {
--   --     -- Automatically install LSPs and related tools to stdpath for Neovim
--   --     -- Mason must be loaded before its dependents so we need to set it up here.
--   --     -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
--   --     { 'williamboman/mason.nvim', opts = {} },
--   --     'williamboman/mason-lspconfig.nvim',
--   --     'WhoIsSethDaniel/mason-tool-installer.nvim',
--   --
--   --     -- Useful status updates for LSP.
--   --     { 'j-hui/fidget.nvim', opts = {} },
--   --
--   --     -- Allows extra capabilities provided by nvim-cmp
--   --     'hrsh7th/cmp-nvim-lsp',
--   --   },
--   --   config = function()
--   --     --  This function gets run when an LSP attaches to a particular buffer.
--   --     vim.api.nvim_create_autocmd('LspAttach', {
--   --       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--   --       callback = function(event)
--   --         local map = function(keys, func, desc, mode)
--   --           mode = mode or 'n'
--   --           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--   --         end
--   --
--   --         -- Rename the variable under your cursor.
--   --         --  Most Language Servers support renaming across files, etc.
--   --         map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--   --         map('<leader>cr', vim.lsp.buf.rename, 'Rename')
--   --
--   --         -- Execute a code action, usually your cursor needs to be on top of an error
--   --         -- or a suggestion from your LSP for this to activate.
--   --         map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
--   --
--   --         -- WARN: This is not Goto Definition, this is Goto Declaration.
--   --         --  For example, in C this would take you to the header.
--   --         -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--   --         -- map('gD', require('telescope.builtin').lsp_references, '[G]oto [D]eclaration')
--   --
--   --         -- The following two autocommands are used to highlight references of the
--   --         -- word under your cursor when your cursor rests there for a little while.
--   --         --    See `:help CursorHold` for information about when this is executed
--   --         --
--   --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
--   --         local client = vim.lsp.get_client_by_id(event.data.client_id)
--   --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
--   --           local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--   --           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--   --             buffer = event.buf,
--   --             group = highlight_augroup,
--   --             callback = vim.lsp.buf.document_highlight,
--   --           })
--   --
--   --           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--   --             buffer = event.buf,
--   --             group = highlight_augroup,
--   --             callback = vim.lsp.buf.clear_references,
--   --           })
--   --
--   --           vim.api.nvim_create_autocmd('LspDetach', {
--   --             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--   --             callback = function(event2)
--   --               vim.lsp.buf.clear_references()
--   --               vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--   --             end,
--   --           })
--   --         end
--   --
--   --         -- The following code creates a keymap to toggle inlay hints in your
--   --         -- code, if the language server you are using supports them
--   --         --
--   --         -- This may be unwanted, since they displace some of your code
--   --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
--   --           map('<leader>th', function()
--   --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--   --           end, '[T]oggle Inlay [H]ints')
--   --         end
--   --
--   --         -- vim.lsp.config('yamlls', {
--   --         --   settings = {
--   --         --     yaml = {
--   --         --       schemas = {
--   --         --         ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json'] = '*.yaml',
--   --         --       },
--   --         --     },
--   --         --   },
--   --         -- })
--   --       end,
--   --     })
--   --
--   --     -- Change diagnostic symbols in the sign column (gutter)
--   --     -- if vim.g.have_nerd_font then
--   --     --   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
--   --     --   local diagnostic_signs = {}
--   --     --   for type, icon in pairs(signs) do
--   --     --     diagnostic_signs[vim.diagnostic.severity[type]] = icon
--   --     --   end
--   --     --   vim.diagnostic.config { signs = { text = diagnostic_signs } }
--   --     -- end
--   --
--   --     -- LSP servers and clients are able to communicate to each other what features they support.
--   --     --  By default, Neovim doesn't support everything that is in the LSP specification.
--   --     --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--   --     --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--   --     local capabilities = vim.lsp.protocol.make_client_capabilities()
--   --     capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
--   --
--   --     -- Enable the following language servers
--   --     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--   --     --
--   --     --  Add any additional override configuration in the following tables. Available keys are:
--   --     --  - cmd (table): Override the default command used to start the server
--   --     --  - filetypes (table): Override the default list of associated filetypes for the server
--   --     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--   --     --  - settings (table): Override the default settings passed when initializing the server.
--   --     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--   --     local servers = {
--   --       ['helm-ls'] = {
--   --         yamlls = {
--   --           enabled = true,
--   --           enabledForFilesGlob = '*.{yaml,yml}',
--   --           path = 'yaml-language-server',
--   --         },
--   --       },
--   --       lua_ls = {
--   --         -- cmd = { ... },
--   --         -- filetypes = { ... },
--   --         -- capabilities = {},
--   --         settings = {
--   --           Lua = {
--   --             completion = {
--   --               callSnippet = 'Replace',
--   --             },
--   --             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--   --             -- diagnostics = { disable = { 'missing-fields' } },
--   --           },
--   --         },
--   --       },
--   --     }
--   --
--   --     local ensure_installed = vim.tbl_keys(servers or {})
--   --     vim.list_extend(ensure_installed, {
--   --       'astro-language-server',
--   --       'goimports',
--   --       'gopls',
--   --       'hclfmt',
--   --       'markdownlint',
--   --       'pyright',
--   --       'ruff',
--   --       'rust_analyzer',
--   --       'stylua', -- Used to format Lua code
--   --       'terraform-ls',
--   --       'terraformls',
--   --       'ts_ls',
--   --       'yamlls',
--   --     })
--   --
--   --     require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--   --
--   --     require('mason-lspconfig').setup {
--   --       handlers = {
--   --         function(server_name)
--   --           local server = servers[server_name] or {}
--   --           -- This handles overriding only values explicitly passed
--   --           -- by the server configuration above. Useful when disabling
--   --           -- certain features of an LSP (for example, turning off formatting for ts_ls)
--   --           server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--   --           require('lspconfig')[server_name].setup(server)
--   --         end,
--   --       },
--   --     }
--   --   end,
--   -- },
--
--   -- { -- Autoformat
--   --   'stevearc/conform.nvim',
--   --   event = { 'BufWritePre' },
--   --   cmd = { 'ConformInfo' },
--   --   keys = {
--   --     {
--   --       '<leader>df',
--   --       function()
--   --         require('conform').format { async = true, lsp_format = 'fallback' }
--   --       end,
--   --       mode = '',
--   --       desc = '[F]ormat buffer',
--   --     },
--   --   },
--   --   opts = {
--   --     notify_on_error = false,
--   --     format_on_save = function(bufnr)
--   --       -- Disable "format_on_save lsp_fallback" for languages that don't
--   --       -- have a well standardized coding style. You can add additional
--   --       -- languages here or re-enable it for the disabled ones.
--   --       local disable_filetypes = { c = true, cpp = true }
--   --       local lsp_format_opt
--   --       if disable_filetypes[vim.bo[bufnr].filetype] then
--   --         lsp_format_opt = 'never'
--   --       else
--   --         lsp_format_opt = 'fallback'
--   --       end
--   --       return {
--   --         timeout_ms = 500,
--   --         lsp_format = lsp_format_opt,
--   --       }
--   --     end,
--   --     formatters_by_ft = {
--   --       lua = { 'stylua' },
--   --       python = { 'ruff_format' },
--   --       -- -- Conform can also run multiple formatters sequentially
--   --       -- python = function(bufnr)
--   --       --   if require('conform').get_formatter_info('ruff_format', bufnr).available then
--   --       --     return { 'ruff_format' }
--   --       --   else
--   --       --     return { 'isort', 'black' }
--   --       --   end
--   --       -- end,
--   --       go = { 'goimports', 'gofmt' },
--   --       rust = { 'rustfmt', lsp_format = 'fallback' },
--   --       --
--   --       -- You can use 'stop_after_first' to run the first available formatter from the list
--   --       javascript = { 'prettierd', 'prettier', stop_after_first = true },
--   --       typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
--   --       javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
--   --     },
--   --   },
--   -- },
--
--   -- { -- Autocompletion
--   --   'hrsh7th/nvim-cmp',
--   --   event = 'InsertEnter',
--   --   dependencies = {
--   --     -- Snippet Engine & its associated nvim-cmp source
--   --     {
--   --       'L3MON4D3/LuaSnip',
--   --       build = (function()
--   --         -- Build Step is needed for regex support in snippets.
--   --         -- This step is not supported in many windows environments.
--   --         -- Remove the below condition to re-enable on windows.
--   --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--   --           return
--   --         end
--   --         return 'make install_jsregexp'
--   --       end)(),
--   --       dependencies = {
--   --         -- `friendly-snippets` contains a variety of premade snippets.
--   --         --    See the README about individual language/framework/plugin snippets:
--   --         --    https://github.com/rafamadriz/friendly-snippets
--   --         {
--   --           'rafamadriz/friendly-snippets',
--   --           config = function()
--   --             require('luasnip.loaders.from_vscode').lazy_load()
--   --           end,
--   --         },
--   --       },
--   --     },
--   --     'saadparwaiz1/cmp_luasnip',
--   --
--   --     -- Adds other completion capabilities.
--   --     --  nvim-cmp does not ship with all sources by default. They are split
--   --     --  into multiple repos for maintenance purposes.
--   --     'hrsh7th/cmp-nvim-lsp',
--   --     'hrsh7th/cmp-path',
--   --   },
--   --   config = function()
--   --     -- See `:help cmp`
--   --     local cmp = require 'cmp'
--   --     local luasnip = require 'luasnip'
--   --     luasnip.config.setup {}
--   --
--   --     cmp.setup {
--   --       snippet = {
--   --         expand = function(args)
--   --           luasnip.lsp_expand(args.body)
--   --         end,
--   --       },
--   --       completion = { completeopt = 'menu,menuone,noinsert' },
--   --
--   --       -- For an understanding of why these mappings were
--   --       -- chosen, you will need to read `:help ins-completion`
--   --       --
--   --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
--   --       mapping = cmp.mapping.preset.insert {
--   --         -- Select the [n]ext item
--   --         ['<C-n>'] = cmp.mapping.select_next_item(),
--   --         ['<C-j>'] = cmp.mapping.select_next_item(),
--   --         -- Select the [p]revious item
--   --         ['<C-p>'] = cmp.mapping.select_prev_item(),
--   --         ['<C-k>'] = cmp.mapping.select_prev_item(),
--   --
--   --         -- Scroll the documentation window [b]ack / [f]orward
--   --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--   --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--   --
--   --         -- Accept ([y]es) the completion.
--   --         --  This will auto-import if your LSP supports it.
--   --         --  This will expand snippets if the LSP sent a snippet.
--   --         ['<C-y>'] = cmp.mapping.confirm { select = true },
--   --         -- ['<Tab>'] = cmp.mapping.confirm { select = true },
--   --         -- ['<Return>'] = cmp.mapping.confirm { select = true },
--   --
--   --         -- If you prefer more traditional completion keymaps,
--   --         -- you can uncomment the following lines
--   --         --['<CR>'] = cmp.mapping.confirm { select = true },
--   --         --['<Tab>'] = cmp.mapping.select_next_item(),
--   --         --['<S-Tab>'] = cmp.mapping.select_prev_item(),
--   --
--   --         -- Manually trigger a completion from nvim-cmp.
--   --         --  Generally you don't need this, because nvim-cmp will display
--   --         --  completions whenever it has completion options available.
--   --         ['<C-Space>'] = cmp.mapping.complete {},
--   --
--   --         -- Think of <c-l> as moving to the right of your snippet expansion.
--   --         --  So if you have a snippet that's like:
--   --         --  function $name($args)
--   --         --    $body
--   --         --  end
--   --         --
--   --         -- <c-l> will move you to the right of each of the expansion locations.
--   --         -- <c-h> is similar, except moving you backwards.
--   --         ['<C-l>'] = cmp.mapping(function()
--   --           if luasnip.expand_or_locally_jumpable() then
--   --             luasnip.expand_or_jump()
--   --           end
--   --         end, { 'i', 's' }),
--   --         ['<C-h>'] = cmp.mapping(function()
--   --           if luasnip.locally_jumpable(-1) then
--   --             luasnip.jump(-1)
--   --           end
--   --         end, { 'i', 's' }),
--   --
--   --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--   --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--   --       },
--   --       sources = {
--   --         {
--   --           name = 'lazydev',
--   --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
--   --           group_index = 0,
--   --         },
--   --         { name = 'nvim_lsp' },
--   --         { name = 'luasnip' },
--   --         { name = 'path' },
--   --       },
--   --     }
--   --   end,
--   -- },
--
--   -- { -- You can easily change to a different colorscheme.
--   --   -- Change the name of the colorscheme plugin below, and then
--   --   -- change the command in the config to whatever the name of that colorscheme is.
--   --   --
--   --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--   --   'folke/tokyonight.nvim',
--   --   priority = 1000, -- Make sure to load this before all the other start plugins.
--   --   init = function()
--   --     -- Load the colorscheme here.
--   --     -- Like many other themes, this one has different styles, and you could load
--   --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--   --     vim.cmd.colorscheme 'tokyonight-night'
--   --
--   --     -- You can configure highlights by doing something like:
--   --     vim.cmd.hi 'Comment gui=none'
--   --   end,
--   -- },
--
--   -- Highlight todo, notes, etc in comments
--   -- { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
--
--   -- {
--   --   'akinsho/bufferline.nvim',
--   --   opts = {
--   --     options = {
--   --       mode = 'tabs',
--   --       separator_style = 'slant',
--   --     },
--   --   },
--   -- },
--
--   -- TODO:
--   -- { -- Collection of various small independent plugins/modules
--   --   'echasnovski/mini.nvim',
--   --   config = function()
--   --     -- Better Around/Inside textobjects
--   --     --
--   --     -- Examples:
--   --     --  - va)  - [V]isually select [A]round [)]paren
--   --     --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--   --     --  - ci'  - [C]hange [I]nside [']quote
--   --     require('mini.ai').setup { n_lines = 500 }
--   --
--   --     -- Add/delete/replace surroundings (brackets, quotes, etc.)
--   --     --
--   --     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--   --     -- - sd'   - [S]urround [D]elete [']quotes
--   --     -- - sr)'  - [S]urround [R]eplace [)] [']
--   --     require('mini.surround').setup()
--   --
--   --     local statusline = require 'mini.statusline'
--   --     statusline.setup {
--   --       use_icons = true,
--   --     }
--   --
--   --     -- You can configure sections in the statusline by overriding their
--   --     -- default behavior. For example, here we set the section for
--   --     -- cursor location to LINE:COLUMN
--   --     ---@diagnostic disable-next-line: duplicate-set-field
--   --     statusline.section_location = function()
--   --       return '%2l:%-2v'
--   --     end
--   --
--   --     ---@diagnostic disable-next-line: duplicate-set-field
--   --     statusline.inactive = function()
--   --       if vim.g.ministatusline_disable == true or vim.b.ministatusline_disable == true then
--   --         return ''
--   --       end
--   --       return '%#MiniStatuslineInactive#%F%m%r%='
--   --     end
--   --   end,
--   -- },
--   --
--   -- TODO:
--   -- { -- Highlight, edit, and navigate code
--   --   'nvim-treesitter/nvim-treesitter',
--   --   build = ':TSUpdate',
--   --   main = 'nvim-treesitter.configs', -- Sets main module to use for opts
--   --   -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--   --   opts = {
--   --     ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
--   --     -- Autoinstall languages that are not installed
--   --     auto_install = true,
--   --     highlight = {
--   --       enable = true,
--   --       -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--   --       --  If you are experiencing weird indenting issues, add the language to
--   --       --  the list of additional_vim_regex_highlighting and disabled languages for indent.
--   --       additional_vim_regex_highlighting = { 'ruby' },
--   --     },
--   --     indent = { enable = true, disable = { 'ruby' } },
--   --
--   --     incremental_selection = {
--   --       enable = true,
--   --       keymaps = {
--   --         init_selection = '<C-space>',
--   --         node_incremental = '<C-space>',
--   --         scope_incremental = false,
--   --         node_decremental = '<bs>',
--   --       },
--   --     },
--   --   },
--   -- },
--   --
--   -- TODO:
--   -- {
--   --   'nvim-treesitter/nvim-treesitter-context',
--   --   opts = {
--   --     mode = 'topline',
--   --   },
--   -- },
--   --
--   -- TODO:
--   -- {
--   --   'nvim-treesitter/nvim-treesitter-textobjects',
--   --   main = 'nvim-treesitter.configs',
--   --   opts = {
--   --     select = {
--   --       enable = true,
--   --       -- Automatically jump forward to textobj, similar to targets.vim
--   --       lookahead = true,
--   --
--   --       keymaps = {
--   --         -- You can use the capture groups defined in textobjects.scm
--   --         ['af'] = '@function.outer',
--   --         ['if'] = '@function.inner',
--   --         ['ab'] = '@block.outer',
--   --
--   --         -- You can optionally set descriptions to the mappings (used in the desc parameter of
--   --         -- nvim_buf_set_keymap) which plugins like which-key display
--   --         ['ib'] = { query = '@block.inner', desc = 'Select inner part of a class region' },
--   --         -- You can also use captures from other query groups like `locals.scm`
--   --         ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
--   --       },
--   --       -- You can choose the select mode (default is charwise 'v')
--   --       --
--   --       -- Can also be a function which gets passed a table with the keys
--   --       -- * query_string: eg '@function.inner'
--   --       -- * method: eg 'v' or 'o'
--   --       -- and should return the mode ('v', 'V', or '<c-v>') or a table
--   --       -- mapping query_strings to modes.
--   --       selection_modes = {
--   --         ['@parameter.outer'] = 'v', -- charwise
--   --         ['@function.outer'] = 'V', -- linewise
--   --         ['@class.outer'] = '<c-v>', -- blockwise
--   --       },
--   --       -- If you set this to `true` (default is `false`) then any textobject is
--   --       -- extended to include preceding or succeeding whitespace. Succeeding
--   --       -- whitespace has priority in order to act similarly to eg the built-in
--   --       -- `ap`.
--   --       --
--   --       -- Can also be a function which gets passed a table with the keys
--   --       -- * query_string: eg '@function.inner'
--   --       -- * selection_mode: eg 'v'
--   --       -- and should return true or false
--   --       include_surrounding_whitespace = true,
--   --     },
--   --   },
--   -- },
--
--   -- TODO:
--   -- {
--   --   'kevinhwang91/nvim-ufo',
--   --   dependencies = { 'kevinhwang91/promise-async' },
--   --   config = function()
--   --     vim.o.foldcolumn = '0'
--   --     vim.o.foldlevel = 99
--   --     vim.o.foldlevelstart = 99
--   --     vim.o.foldenable = true
--   --     require('ufo').setup()
--   --   end,
--   -- },
--
--   -- require 'kickstart.plugins.debug',
--   -- require 'kickstart.plugins.indent_line',
--   --
--   -- require 'kickstart.plugins.lint',
--   -- require 'kickstart.plugins.autopairs',
--
--   -- TODO:
--   { import = 'custom.plugins' },
-- }, {
--   ui = {
--     -- If you are using a Nerd Font: set icons to an empty table which will use the
--     -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--     icons = vim.g.have_nerd_font and {} or {
--       cmd = '⌘',
--       config = '🛠',
--       event = '📅',
--       ft = '📂',
--       init = '⚙',
--       keys = '🗝',
--       plugin = '🔌',
--       runtime = '💻',
--       require = '🌙',
--       source = '📄',
--       start = '🚀',
--       task = '📌',
--       lazy = '💤 ',
--     },
--   },
--   dev = {
--     path = '~/code/nvim-dev',
--     patterns = { 'jeffawang' },
--   },
-- })

-- when receiving OSC 51 (kinda arbitrarily chosen), open the file specified in the message
vim.api.nvim_create_autocmd({ 'TermRequest' }, {
  desc = 'Handles OSC signal',
  callback = function(_)
    if string.sub(vim.v.termrequest, 1, 5) == '\x1b]51;' then
      local arg = string.gsub(vim.v.termrequest, '\x1b]51;', '')
      vim.cmd 'wincmd p'
      vim.cmd.e(arg)
    end
  end,
})

-- when opening a new terminal, turn off its line numbers
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'turn off line numbers for new terminals',
  callback = function(_)
    vim.cmd 'setlocal nonumber norelativenumber'
  end,
})

local list_snips = function()
  local ft_list = require('luasnip').available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do
    ft_snips[item.trigger] = item.name
  end
  print(vim.inspect(ft_snips))
end

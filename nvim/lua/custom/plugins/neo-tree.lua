-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dev = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
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
}

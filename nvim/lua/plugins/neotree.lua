vim.pack.add {
  'https://github.com/nvim-neo-tree/neo-tree.nvim',

  -- deps
  'https://github.com/MunifTanjim/nui.nvim', -- dep
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
}

require('neo-tree').setup {
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
      ['<tab>'] = 'toggle_node',
      ['\\'] = 'previous_window',
      ['/'] = '', -- just search like a normal vim user ok?
      ['<space>'] = nil,
      ['gg'] = '', -- just search like a normal vim user ok?
      ['F'] = 'filter_as_you_type',
    },
  },
  filesystem = {
    search_limit = 500, -- max number of search results when using filters
    follow_current_file = {
      enabled = false, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
  },
}

local keys = {
  -- { '\\', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  { '<leader>\\s', '<cmd>Neotree document_symbols<cr>', desc = 'NeoTree Document [S]ymbols' },
  { '<leader>\\b', '<cmd>Neotree buffers<cr>', desc = 'NeoTree [B]uffers' },
  -- { '<leader>\\g', '<cmd>Neotree git_status<cr>', desc = 'NeoTree [G]it status' },
  { '<leader>\\f', '<cmd>Neotree reveal<cr>', desc = 'NeoTree [G]it status' },
  { '<leader>g\\', '<cmd>Neotree git_status<cr>', desc = 'NeoTree [G]it status' },
}

for _, key in pairs(keys) do
  vim.keymap.set('n', key[1], key[2], key[3])
end

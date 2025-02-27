-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>\\s', '<cmd>Neotree document_symbols<cr>', desc = 'NeoTree Document [S]ymbols' },
    { '<leader>\\b', '<cmd>Neotree buffers<cr>', desc = 'NeoTree [B]uffers' },
    { '<leader>\\g', '<cmd>Neotree git_status<cr>', desc = 'NeoTree [G]it status' },
    { '<leader>g\\', '<cmd>Neotree git_status<cr>', desc = 'NeoTree [G]it status' },
  },
  opts = {
    sources = {
      'filesystem',
      'buffers',
      'git_status',
      'document_symbols',
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<tab>'] = 'toggle_node',
          ['/'] = '', -- just search like a normal vim user ok?
        },
      },
    },
    document_symbols = {
      window = {
        mappings = {
          ['<tab>'] = 'toggle_node',
          ['/'] = '', -- just search like a normal vim user ok?
        },
      },
    },
  },
}

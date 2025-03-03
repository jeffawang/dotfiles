local snacks = require 'snacks'
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

---@class snacks.picker.Config
local M = {
  enabled = false,
  'folke/snacks.nvim',
  keys = {
    { '<leader><space>', snacks.picker.files },
    -- TODO: figure out how to make this good
    -- { '<leader>sp', snacks.picker.grep },

    -- {
    --   '<leader>.',
    --   function()
    --     snacks.picker.files {
    --       cwd = vim.fn.expand '%:p:h',
    --     }
    --   end,
    -- },
  },
  opts = {
    picker = {
      layout = {
        cycle = false,
        -- preview = 'main',
        preset = 'ivy',
      },
      matcher = {
        fuzzy = false,
        frecency = true,
        history_bonus = true,
      },
    },
  },
}

return M

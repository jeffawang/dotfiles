local actions = require 'snacks.picker.actions'
local M = {}

function M.tagstack(_)
  local tagstack = vim.fn.gettagstack()

  ---@type snacks.picker.finder.Item[]
  local items = {}

  for i, tag in ipairs(tagstack.items) do
    local bufnr = tag.from[1]
    local lnum = tag.from[2]
    local col = tag.from[3]
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    local line ---@type string?
    if vim.api.nvim_buf_is_valid(bufnr) then
      line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
    end

    local label = tagstack.curidx == i and '>' or ' '

    items[#items + 1] = {
      text = table.concat({ tag.tagname, bufname, line }, ' '),
      line = line,
      buf = bufnr,
      label = label,
      pos = { lnum, col },
      file = bufname,
      i = i,
    }
    table.sort(items, function(a, b)
      return a.i > b.i
    end)
  end

  return items
end

M.source = {
  finder = M.tagstack,
}

return M

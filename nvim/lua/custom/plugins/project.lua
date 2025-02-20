return {
  dir = '~/code/github/jeffawang/project.nvim',
  keys = {
    { '<leader>pp', '<cmd>Telescope projects<cr>' },
    {
      '<leader><Space>',
      function()
        local tele = require 'telescope.builtin'
        local proj = require 'project_nvim'
        tele.find_files { cwd = proj.last }
      end,
    },
    { '<leader>sp', '<cmd>Telescope egrepify<cr>' },
    -- { '<leader>l', '<cmd>Lazy! update<cr><cmd>qa<cr>' },
  },
  config = function()
    require('project_nvim').setup {
      manual_mode = false,
    }
  end,
}

-- Normal mode 	Insert mode 	Action
-- f 	<c-f> 	find_project_files
-- b 	<c-b> 	browse_project_files
-- d 	<c-d> 	delete_project
-- s 	<c-s> 	search_in_project_files
-- r 	<c-r> 	recent_project_files
-- w 	<c-w> 	change_working_directory

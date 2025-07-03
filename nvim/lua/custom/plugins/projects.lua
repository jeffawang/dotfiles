return {
  'jeffawang/projects.nvim',
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
}

-- Normal mode 	Insert mode 	Action
-- f 	<c-f> 	find_project_files
-- b 	<c-b> 	browse_project_files
-- d 	<c-d> 	delete_project
-- s 	<c-s> 	search_in_project_files
-- r 	<c-r> 	recent_project_files
-- w 	<c-w> 	change_working_directory

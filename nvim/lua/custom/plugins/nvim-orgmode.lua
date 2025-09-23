return {
  'nvim-orgmode/orgmode',
  enabled = true,
  event = 'VeryLazy',
  ft = { 'org' },
  dependencies = {
    'jeffawang/snacks.nvim',
  },
  config = function()
    require('orgmode').setup {
      org_agenda_files = '~/orgfiles/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
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
    }
  end,
  keys = {
    {
      '<leader>oh',
      '<cmd>e ~/orgfiles/home.org<cr>',
    },
    {
      '<leader>oH',
      function()
        require('snacks').picker.files {
          cwd = '~/orgfiles/',
          pattern = '',
        }
      end,
    },
  },
}

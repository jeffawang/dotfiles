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
}

#!/usr/bin/env bash

if [[ $(tmux show-options -wv synchronize-panes) = "on" ]]
then 
  tmux set-option -q window-status-current-bg blue
  tmux set-option -q synchronize-panes off
else
  tmux set-option -q window-status-current-bg green
  tmux set-option -q synchronize-panes on
fi
tmux display-message "$(tmux show-options -w synchronize-panes)"
tmux refresh-client

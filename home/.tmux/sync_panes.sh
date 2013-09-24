#!/usr/bin/env bash

if [[ $(tmux show-options -w synchronize-panes) = "synchronize-panes on" ]]
then 
  tmux set-option -q window-status-current-bg blue
  tmux set-option -q synchronize-panes off
else
  tmux set-option -q window-status-current-bg green
  tmux set-option -q synchronize-panes on
fi
tmux refresh-client

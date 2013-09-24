#!/bin/bash
tmux copy-selection
tmux save-buffer - | reattach-to-user-namespace pbcopy

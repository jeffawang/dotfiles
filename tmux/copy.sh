#!/bin/bash
tmux copy-selection
tmux save-buffer - | pbcopy

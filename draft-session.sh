#!/bin/bash

tmux new-session -d -s draft \
    \; set-buffer "vim -c DraftReturn" \
    \; paste-buffer -t draft: \
    \; send-keys -t draft: C-m

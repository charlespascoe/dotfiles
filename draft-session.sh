#!/bin/bash

tmux new-session -d -s draft \
    \; set-buffer "sleep 2; while true; do vim -c DraftReturn; sleep 5; done" \
    \; paste-buffer -t draft: \
    \; send-keys -t draft: C-m

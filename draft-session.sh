#!/bin/bash

tmux new-session -d -s draft \
    \; set-buffer "export DRAFT=1; sleep 2; while true; do vim -c DraftReturnMarkdown; sleep 5; done" \
    \; paste-buffer -t draft: \
    \; send-keys -t draft: C-m

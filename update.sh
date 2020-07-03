#!/bin/bash

cd ~/.dotfiles

if [ -n "$ALACRITTY_FONT_SIZE" ]; then
    cat alacritty.yml | sed -e "s/size: [0-9]\+\.[0-9]\+$/size: $ALACRITTY_FONT_SIZE/" > ~/.alacritty.yml
else
    cp alacritty.yml ~/.alacritty.yml
fi

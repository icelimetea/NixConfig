#!/usr/bin/env sh

if [[ -a $HOME/.emacs.d/bin/doom ]]; then
    $HOME/.emacs.d/bin/doom sync
fi

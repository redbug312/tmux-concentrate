#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

readonly current_bg=`tmux show-window-option -gv window-status-current-bg`
readonly border_bg=`tmux show-window-option -gv pane-active-border-bg`
readonly border_fg=`tmux show-window-option -gv pane-active-border-fg`

readonly concentrate_bg=`get_tmux_option @concentrate-bg $current_bg`
readonly concentrate_pad=`get_tmux_option @concentrate-pad 60`

concentrate_enable() {
    tmux split-window -bh -l $concentrate_pad bash -c 'tput reset && sleep infinity'
    tmux select-pane -R
    tmux split-window -h -l $concentrate_pad bash -c 'tput reset && sleep infinity'
    tmux select-pane -L
    tmux set-window-option pane-active-border-bg $concentrate_bg
    tmux set-window-option pane-active-border-fg $concentrate_bg
    tmux set-window-option @concentrate-enabled 1
}

concentrate_disable() {
    tmux kill-pane -t -1
    tmux kill-pane -t +1
    tmux set-window-option pane-active-border-bg $border_bg
    tmux set-window-option pane-active-border-fg $border_fg
    tmux set-window-option @concentrate-enabled 0
}

concentrate_toggle() {
    local enabled=`tmux show-window-option -v @concentrate-enabled`
    if [ -z $enabled ] || [ $enabled -eq 0 ]; then
        concentrate_enable
    else
        concentrate_disable
    fi
}

concentrate_toggle

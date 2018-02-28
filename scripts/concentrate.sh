#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

readonly current_bg=`tmux show-window-option -gv window-status-current-bg`
readonly border_bg=`tmux show-window-option -gv pane-active-border-bg`
readonly border_fg=`tmux show-window-option -gv pane-active-border-fg`

readonly concentrate_bg_default=$current_bg
readonly concentrate_width_default='50%'

readonly concentrate_bg=`get_tmux_option @concentrate-bg $concentrate_bg_default`
readonly concentrate_width=`get_tmux_option @concentrate-width $concentrate_width_default`

evaluate_padding() {
    local window_width=`tmux display -p '#{window_width}'`
    local pane_width=$concentrate_width

    if [[ $concentrate_width =~ \d*% ]]; then
        pane_width=$(( $window_width * ${concentrate_width%\%} / 100 ))
    fi

    if [ $pane_width -lt 0 ] || [ $pane_width -gt $window_width ]; then
        pane_width=$(( $window_width *  ${concentrate_width_default%\%} / 100 ))
    fi
    echo $(( ($window_width - $pane_width) / 2 ))
}

concentrate_enable() {
    local padding=`evaluate_padding`
    tmux split-window -bh -l $padding bash -c 'tput reset && sleep infinity'
    tmux select-pane -R
    tmux split-window -h -l $padding bash -c 'tput reset && sleep infinity'
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

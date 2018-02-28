#!/usr/bin/env bash

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=`tmux show-option -gqv $option`
    echo ${option_value:-$default_value}
}

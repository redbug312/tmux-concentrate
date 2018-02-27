#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

readonly key=`get_tmux_option @concentrate-key C`

tmux bind-key $key run-shell "$CURRENT_DIR/scripts/concentrate.sh"

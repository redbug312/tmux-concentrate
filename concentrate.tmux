#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

readonly concentrate_key_default='C'

readonly concentrate_key=`get_tmux_option @concentrate-key $concentrate_key_default`

tmux bind-key $concentrate_key run-shell "$CURRENT_DIR/scripts/concentrate.sh"

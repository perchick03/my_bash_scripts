#!/bin/bash

LAST_USED_COLOR="default"
CURRENT_COLOR="default"
# To run using console colors, set environment COLORS_ENABLED. (e.g., COLORS_ENABLED=1 script_with_logs.sh arg1 arg2...)
COLORS_ENABLED="${COLORS_ENABLED:=0}"


function enable_colors() {
  restore_last_color
  COLORS_ENABLED=1
}

function disable_colors(){
  reset_color
  COLORS_ENABLED=0
}


function restore_last_color() {
  set_console_color $LAST_USED_COLOR
}

function reset_color() {
  set_console_color "reset"
}

function clear_all() {
  set_console_color "clear_all"
}

function _set_color() {
  # source: https://stackoverflow.com/questions/29979966/tput-no-value-for-term-and-no-t-specified-error-logged-by-cron-process
  # more info: https://unix.stackexchange.com/a/521120
  # when $TERM is empty (non-interactive shell), then expand tput with '-T xterm-256color'
  if [[ ${TERM} == "" ]]; then
    tput "${@}"
  else
    tput -T xterm-256color "${@}"
  fi
}

# TODO: add bold, underline
function set_console_color(){
  # Color       #define       Value       RGB
  # --------------------------------------------
  # black     COLOR_BLACK       0     0, 0, 0
  # red       COLOR_RED         1     max,0,0
  # green     COLOR_GREEN       2     0,max,0
  # yellow    COLOR_YELLOW      3     max,max,0
  # blue      COLOR_BLUE        4     0,0,max
  # magenta   COLOR_MAGENTA     5     max,0,max
  # cyan      COLOR_CYAN        6     0,max,max
  # white     COLOR_WHITE       7     max,max,max
  [[ $COLORS_ENABLED -eq 0 ]] && return 0
  LAST_USED_COLOR=$CURRENT_COLOR

  arg="$1"
  # shellcheck disable=SC2034
  CURRENT_COLOR=$arg
  case $arg in
  "clear_all")
    LAST_USED_COLOR="default"
    CURRENT_COLOR="default"
    # Fall through
    ;&
  "reset")
    _set_color sgr0
    ;;
  "black")
    _set_color setaf 0
    ;;
  "red")
    _set_color setaf 1
    ;;
  "green")
    _set_color setaf 2
    ;;
  "yellow")
    _set_color setaf 3
    ;;
  "blue")
    _set_color setaf 4
    ;;
  "magenta")
    _set_color setaf 5
    ;;
  "cyan")
    _set_color setaf 6
    ;;
  "white")
    _set_color setaf 7
    ;;
  "default")
    # cyan
    _set_color setaf 6
    ;;
  *)
    echo "Error: unknown option $arg"
    shift
    ;;
  esac

}

trap 'set_console_color "clear_all"' EXIT

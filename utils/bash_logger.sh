#!/bin/bash

# Bash logger
# To use,
# source "utils/bash_logger.sh"
#
# Available log levels are "DEBUG" | "INFO" | "WARNING" | "ERROR"
# Note that currently we only support DEBUG and INFO
#
# Simple Usage:
#   log_info "some info log here"
#   2022-04-17.16:57:52.123::[INFO]::some info log here (/tmp/testing/testing_shfile.sh:23)
#
# To enable DEBUG severity, run with BASH_SEVERITY=DEBUG
#
# Debug level Usage:
#   2022-04-17.16:57:52.123::[DEBUG]::some debug (/tmp/testing/testing_shfile.sh:24)
#
# Enable Colors Usage:
#   COLORS_ENABLED=1 BASH_SEVERITY=DEBUG ./testing_shfile.sh



set -e

UTILS_DIR=${UTILS_DIR:=$(dirname "${BASH_SOURCE[0]}" | xargs realpath)}
source "$UTILS_DIR/console_colors.sh"

LOG_LEVEL_ERR=1

# TODO:
#   - support all severity levels. currently, default is INFO and you can set it to DEBUG, currently support debug and not debug (info) only

 # Use either "DEBUG" | "INFO" | "WARNING" | "ERROR"
SEVERITY_LEVELS=("DEBUG" "INFO" "WARNING" "ERROR" "NONE")
BASH_SEVERITY=${BASH_SEVERITY:="INFO"}


function set_log_level() {
  [[ -z ${1+x} ]] && { log_error "set_level requires one of ${SEVERITY_LEVELS[*]}"; return "$LOG_LEVEL_ERR"; }
  local new_log_level="$1"
  [[ ! "${SEVERITY_LEVELS[*]}" =~ $new_log_level ]] && { log_error "set_level requires one of ${SEVERITY_LEVELS[*]}"; return "$LOG_LEVEL_ERR"; }

  [[ "$new_log_level" != "DEBUG" && "$new_log_level" != "INFO" ]] && { log_error "Currently only support INFO and DEBUG log levels"; return "$LOG_LEVEL_ERR"; }

  BASH_SEVERITY="$new_log_level"
}


function _log_msg() {
  # Example:
  # 2022-04-17.16:57:52.123::[ERROR]::some error (/tmp/utils/bash_logger.sh:23)
  # Note that this method will return the line number two callers up, its not intended to be using inside a wrapper
  local level_severity="$1"
  shift

  HDR_FMT="%.23s::[${level_severity}]::%s (%s:%s) "
  MSG_FMT="${HDR_FMT}%s\n"

  # shellcheck disable=SC2059
  printf "$MSG_FMT" "$(date +%F.%T.%N)" "${@}" "${BASH_SOURCE[2]#*/}" "${BASH_LINENO[1]}"
}

function log_error() {
  # Example:
  # 2022-04-17.16:57:52.123::[ERROR]::some error (/tmp/test_scripts.sh:23)
  set_console_color "red"
  _log_msg "ERROR" "${@}"
  restore_last_color
}

function log_info() {
  # log info messages. this is the basic level
  # Example:
  # 2022-04-17.16:57:52.123::[INFO]::some info message (/tmp/test_scripts.sh:24)

  [[ $BASH_SEVERITY == "NONE" ]] && return
  set_console_color "cyan"
  _log_msg "INFO" "${@}"
  restore_last_color
}

function log_debug() {
  # Use debug level: BASH_SEVERITY=DEBUG /tmp/utils/test_scripts.sh
  # Example:
  # 2022-04-17.16:57:52.123::[DEBUG]::some debug (/tmp/test_scripts.sh:25)
  [[ $BASH_SEVERITY != "DEBUG" ]] && return
  set_console_color "blue"
  _log_msg "DEBUG" "${@}"
  restore_last_color
}


function log_warning() {
  # Example:
  # 2022-04-17.16:57:52.123::[WARNING]::some warning (/tmp/test_scripts.sh:26)
  set_console_color "yellow"
  _log_msg "WARNING" "${@}"
  restore_last_color
}

function log_failed() {
  # FAILED message, logged in red if colors are enabled
  # Example:
  # 2022-04-17.16:57:52.123::[FAILED]::TEST FAIL (/tmp/test_scripts.sh:27)
  set_console_color "red"
  _log_msg "FAILED" "${*}"
  restore_last_color
}

function log_ok() {
  # OK message, logged in green if colors are enabled
  # Example:
  # 2022-04-17.16:57:52.123::[OK]::TEST PASS (/tmp/test_scripts.sh:28)
  set_console_color "green"
  _log_msg "OK" "${*}"
  restore_last_color
}

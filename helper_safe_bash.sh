

#!/bin/bash
# Using env bash is considered harmful:
# https://unix.stackexchange.com/questions/206350/what-is-the-difference-if-i-start-bash-with-bin-bash-or-usr-bin-env-bash

# https://sipb.mit.edu/doc/safe-shell/
# GLOBBING IS NOT ALLOWED!!
set -euf -o pipefail

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'

# Other useful conventions and resources:
# http://bash3boilerplate.sh/
# https://github.com/progrium/bashstyle
# https://github.com/kward/shunit2
# https://github.com/koalaman/shellcheck

# --- Helper scripts begin ---
# https://dev.to/thiht/shell-scripts-matter

#/ Usage:
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
readonly DATE_FORMAT="%Y-%m-%d %H:%M:%S.%N"
info()    { echo "[`date +$DATE_FORMAT`] [INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[`date +$DATE_FORMAT`] [WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[`date +$DATE_FORMAT`] [ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[`date +$DATE_FORMAT`] [FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

cleanup() {
    # Remove temporary files
    # Restart services
    # ...
    info "Cleaning up before exit..."
}

assert_running_as_root() {
  if [[ ${EUID} -ne 0 ]]; then
      fatal "This script must be run as root!"
  fi
}

assert_command_is_available() {
  local cmd=${1}
  type ${cmd} >/dev/null 2>&1 || fatal "Cancelling because required command '${cmd}' is not available."
}

_get_abs_script_path() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    FILENAME=$(basename "$0") # This does not consider if the script was a symlink
    ABS_SCRIPT_PATH="$DIR/$FILENAME"
    readonly SOURCE
    readonly DIR
    readonly ABS_SCRIPT_PATH
    readonly FILENAME
}


# --- Helper scripts end ---

# https://stackoverflow.com/questions/2853803/in-a-shell-script-echo-shell-commands-as-they-are-executed
# set -x

# Code begins here...

main() {

    _get_abs_script_path

    # Script goes here
    # Important global vars:
    #  $ABS_SCRIPT_PATH
    #  $DIR : Script full dir path
    #  $FILENAME: Script filename
    # ...
    return
}

trap cleanup EXIT

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    main "$@"
fi

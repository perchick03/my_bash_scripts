#!/bin/bash

# ====================
# 		My Bash Notes
# ====================
: <<- 'comment'
Some of the stuff I picked up 
while learning bash scripting.
comment

# -e (exit on error), 
# -u (error on unset variables), 
# -o pipefail (return error if any command in a pipeline fails)
set -euo pipefail

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



# /dev/null - Accepts and discards all inputs and produces no output
# 2&1 - redirect standard error to standard output
# & - means whatever follows is a file descriptor, not a file name
command > /dev/null > 2&1 # - Don't shout while executing 


# find all directories fro current directory and remove them
find . -name __pycache__ -type d | xargs rm -rf


# find directory size 
sudo du -B 1 -sh ~/work/ | cut -f1

# Initialize MYVAR to "default" if it is not already set
MYVAR="${MYVAR:="defualt"}"


# Args

echo "# arguments called with ---->  ${@}     "
echo "# \$1 ---------------------->  $1       "
echo "# \$2 ---------------------->  $2       "
echo "# path to me --------------->  ${0}     "
echo "# parent path -------------->  ${0%/*}  "
echo "# my name ------------------>  ${0##*/} "
echo

# Notice on the next line, the first argument is called within double, 
# and single quotes, since it contains two words

$  /misc/shell_scripts/check_root/show_parms.sh "'hello there'" "'william'"

# ------------- RESULTS ------------- #

# arguments called with --->  'hello there' 'william'
# $1 ---------------------->  'hello there'
# $2 ---------------------->  'william'
# path to me -------------->  /misc/shell_scripts/check_root/show_parms.sh
# parent path ------------->  /misc/shell_scripts/check_root
# my name ----------------->  show_parms.sh

# ------------------------------------ #


display_usage()
{
    echo -e "Usage: $(basename "$0") [-h] 
      [--possible-env-var POSSIBLE-ENV_VAR]
      [--opt-positional {opt1,opt2}]
      [--packages-select [PKG_NAME [PKG_NAME ...]]]]\n"
    echo -e "**short script description** \n"
    echo -e "Optional arguments:"
    echo -e "  -h --help\n\t show this screen"
    echo -e "  -f --force\n\t force rebuild container "
    echo -e "  --clean\n\t remove container "
}

while [ $# -ne 0 ]
do
  arg="$1"
  case $arg in
  -h | --help)
    display_usage
    exit 0
    ;;
  
  -f | --force)
    shift
    ;;
   --clean)
    shift
    ;;
  *)
    break
  esac
done


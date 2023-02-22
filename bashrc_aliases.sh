# My bash aliases and helper functions

######### Navigation #########
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias 'downloads'='cd ~/Downloads'
alias labs='cd ~/labs'
alias proj='cd ~/projects'
alias play='cd ~/playground'

function mkdircd {
  [[ -z "$1" ]] && { echo "Usage: mkdircd [NEWDIR]"; return 1; }
  command mkdir -p "$1" && cd "$1"
}

function open () {
  xdg-open "$@">/dev/null 2>&1
}



######### Source Envrionment #########
alias rebash='source ~/.bashrc'
# TODO: resource venv after rebashing
# function rebash() {

#   local OLD_VENV="$VIRTUAL_ENV"
#   echo "OLD_VENV=$OLD_VENV"
#   source ~/.bashrc
#   if [[ ${OLD_VENV} != "" ]]; then
#     source "$OLD_VENV/bin/activate"
#   fi
  
# }
alias bashedit='subl ~/.bashrc'
alias bashalias='subl ~/.bash_aliases'

# Function to create and activate a Python virtual environment
function venv() {
  # Usage: venv [NAME]
  # Check if a virtual environment is currently active
  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    echo "Deactivate from ${VIRTUAL_ENV}"
    deactivate
  fi

  # Set the name of the virtual environment (defaults to "venv")
  local venv_name=${1:-venv}

  # Check if the virtual environment directory exists
  if [[ ! -d ${venv_name} ]]; then
    echo "Creating virtual environment ${venv_name} ..."
    if ! virtualenv "${venv_name}"; then
      echo "Failed to create virtual environment ${venv_name}"
      return 1
    fi
  fi

    # Activate the virtual environment
  echo "Activating virtual environment ${venv_name} ..."
  source "${venv_name}/bin/activate"
}


##### Quick Actions #####

function rename_file() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: rename_file old_path new_filename"
    return 1
  fi

  local old_path="$1"
  local new_filename="$2"

  if [ ! -e "${old_path}" ]; then
    echo "Error: ${old_path} does not exist."
    return 1
  fi

  local new_path="$(dirname -- ${old_path})/${new_filename}"

  if [ -e "${new_path}" ]; then
    echo "Error: ${new_path} already exists."
    return 1
  fi

  mv "${old_path}" "${new_path}"
  echo "Renamed ${old_path} to ${new_path}"
}

# Helper function that movies screenshots to my win VM folder automatically
function copyimage()
{
  # TODO- refactor this ugly code
  local filepath
  local DIR="$HOME/VMs/shared/images/"
  local curr_data=$(date +%Y-%m-%d_%T)
  if [ $# -eq 0 ]; then
    filename="$curr_data.png"
  else
    DIR=$(readlink -e "$(dirname "$1")")
    local FILE="$(basename "$1")"
    filename="$FILE.png"
      
  fi
  filepath="$DIR"/$filename
  echo "filepath $filepath"
  # xclip -selection clipboard -t image/png -o > /tmp/$filename
  xclip -selection clipboard -t image/png -o > "$filepath"
  echo -e "stored file in $filepath"
  open $filepath

}

######### Code #########
alias compile='g++ -std=c++2a -g -D DEBUG'
alias out='./a.out'
alias py='python3'
alias clbuild='rm -rf {build,dist,*.egg-info}'
alias whichvenv='set -x && echo $VIRTUAL_ENV && set +x'


######### Git #########
# git
alias brfdiff='gitk --all --date-order --'
alias gitchanges='for k in `git branch | sed s/^..//`; do echo -e `git log -1 --color=always --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k --`\\t"$k";done | sort ' 


######### Installation #########
alias install='sudo apt-get install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'

# purge required packages along with dependencies that are installed with those packages.
function aptremove_func() {  
  local pkg_name="$1"
  [[ -z "$pkg_name" ]] && { echo "Usage: aptremove PKG_NAME" && return 1; }
  sudo apt-get purge --auto-remove "$pkg_name" -y
}


# Function to install a Python package using pip and save it to a requirements file
function pipinstall() {
  local pkg="$1"
  local requirement_file="$2"

  if [[ -z "$pkg" ]]; then
    echo "Usage: pipinstall PKG"
    return 1
  fi
  
  if [[ -z "$requirement_file" ]]; then
    requirement_file="./requirements.txt"
  fi

  pip install "$pkg"

  # Get information about the last package installed using pip freeze
  local last_pkg_installed=$(pip freeze | grep -i "$pkg")

  # If requirement file exists, append package information to the file
  if [[ -f "$requirement_file" ]]; then
    echo last_pkg_installed >> $requirement_file
    echo "Added $last_pkg_installed to $requirement_file"
    
  # If requirement file doesn't exist, copy package information to clipboard
  else
    echo "copy last package to clipboard: $last_pkg_installed"
    echo "$last_pkg_installed" | xclip -selection clipboard
  fi

}


################# Labs #################


function labpy()
{
  local ORIGIN_PWD=$PWD
  local PYLABS="$HOME/labs/python"
  local lab_file="$1"

  cd "$PYLABS"
  if [ $# -eq 0 ]; then
    return  
  fi
  if [[ -d "$1" ]]; then
    cd "$1"
    lab_file="$2"
    if [[ -z "$lab_file" ]]; then
      return
    fi
  fi
  
  if find . -name $lab_file.py | grep -q "." ; then
    subl $lab_file.py
  else
    tee $lab_file.py <<EOF >/dev/null
import os
import sys


EOF
    subl $lab_file.py
  fi
  cd "$ORIGIN_PWD"
}


function labcpp()
{
  cd ~/labs
if (( $# == 1 )); then
  tee $1.cpp <<EOF >/dev/null
#include <iostream>
#include <vector>
#include <array>
#include <map>
#include <algorithm>
#include <memory>

using namespace std;

int main(int argc, char const *argv[])
{
  
    return 0;
}
EOF
  subl $1.cpp
fi
}


## Helpers 
function pylab()
{
  labpy "$@"
}

function cpplab()
{
  labcpp "$@"
}

#!/usr/bin/env bash
# Author      : Patricio Rojas Ortiz
# Description :  Allows you to install ansible ansible-lint on the workstation

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.

sudo apt install ansible ansible-lint
sudo apt install python3-pip
sudo pip install --upgrade ansible-lint   
ansible-lint --version   
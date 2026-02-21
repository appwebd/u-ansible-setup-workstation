#!/usr/bin/env bash
# Author      : Patricio Rojas Ortiz
# Description :  Allows you to install ansible ansible-lint on the workstation

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.

apt install ansible ansible-lint

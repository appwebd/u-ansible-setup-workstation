#!/usr/bin/env bash

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.
set +o history

# Copy your ssh key to the workstation
ssh-copy-id pro@192.168.1.89

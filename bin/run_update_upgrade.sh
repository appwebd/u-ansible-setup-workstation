#!/usr/bin/env bash
# Author      : Patricio Rojas Ortiz
# Description : Allows you to update multiple workstations

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.
set +o history

#| Option  | Purpose                                                 |
#| -vvv    | Provides full debugging details.                        |
#| --check | Performs a dry‑run simulation without making changes.   |
#| --diff  | Shows differences before applying.                      |


export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
ansible-playbook -i "inventory/inventory.ini" -v "playbooks/update_upgrade.yaml" -b -K -v

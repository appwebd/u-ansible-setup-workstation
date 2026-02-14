#!/usr/bin/env bash
# Author      : Patricio Rojas
# Description : Allows you to apply Wazuh and lynis recommendations primarily on a workstation.

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.
set +o history

#| Option  | Purpose                                                 |
#| -vvv    | Provides full debugging details.                        |
#| --check | Performs a dry‑run simulation without making changes.   |
#| --diff  | Shows differences before applying.                      |


export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
ansible-playbook -i inventory/inventory.ini  --vault-password-file .vault_password -v playbooks/setup_workstation.yaml -b -K

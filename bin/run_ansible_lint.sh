#!/usr/bin/env bash

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.

export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password

ansible-lint playbooks/setup_workstation.yaml
ansible-lint playbooks/remove_bloatware_packages.yaml
ansible-lint playbooks/remove_unused_accounts_groups.yaml
ansible-lint playbooks/shutdown.yaml
ansible-lint playbooks/update_upgrade.yaml

#!/bin/bash
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password

ansible-lint playbooks/setup_workstation.yaml
ansible-lint playbooks/remove_bloatware_packages.yaml
ansible-lint playbooks/remove_unused_accounts_groups.yaml

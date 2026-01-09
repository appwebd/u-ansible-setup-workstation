#!/bin/bash
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
ansible-playbook -i inventory/inventory.ini  --vault-password-file .vault_password -v playbooks/setup_workstation.yaml -b -K

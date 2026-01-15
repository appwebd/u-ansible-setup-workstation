#!/bin/bash
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
ansible-playbook -i inventory/inventory.ini  -v playbooks/shutdown.yaml -b -K

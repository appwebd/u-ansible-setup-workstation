#!/bin/bash
ansible-playbook -i inventory/inventory.ini --ask-vault-pass -vvv playbooks/setup_workstation.yaml -b -K
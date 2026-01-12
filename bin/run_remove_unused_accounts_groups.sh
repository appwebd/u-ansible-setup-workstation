#!/bin/bash
ansible-playbook -i inventory/inventory.ini -v playbooks/remove_unused_accounts_groups.yaml -b -K
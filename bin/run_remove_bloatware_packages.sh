#!/bin/bash
ansible-playbook -i inventory/inventory.ini -v playbooks/remove_bloatware_packages.yaml -b -K
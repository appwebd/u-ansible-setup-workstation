#!/bin/bash
ansible-playbook -i inventory/inventory.ini -vvv playbooks/remove_bloatware_packages.yaml -b -K
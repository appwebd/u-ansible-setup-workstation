#!/bin/bash
ansible-playbook -i inventory/inventory.ini -vvv playbooks/setup_workstation.yaml -b -K
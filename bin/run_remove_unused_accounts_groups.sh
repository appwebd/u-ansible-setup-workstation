#!/usr/bin/env bash
# Author      : Patricio Rojas Ortiz
# Description : Allows you to delete some accounts from the system. Review before use.

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.
set +o history

#| Option  | Purpose                                                 |
#| -vvv    | Provides full debugging details.                        |
#| --check | Performs a dry‑run simulation without making changes.   |
#| --diff  | Shows differences before applying.                      |


ansible-playbook -i inventory/inventory.ini -v playbooks/remove_unused_accounts_groups.yaml -b -K
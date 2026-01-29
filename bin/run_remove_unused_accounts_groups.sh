#!/usr/bin/env bash

set -euo pipefail          # Terminar al fallo, no usar variables no inicializadas y capturar errores de pipelines
set +o history

# | Opción  | Propósito                                              |
# | -vvv    | Proporciona detalle de debug completo.                 |
# | --check | Realiza una simulación (dry‑run) sin aplicar cambios.  |
# | --diff  | Muestra diferencias antes de aplicar.                  |

ansible-playbook -i inventory/inventory.ini -v playbooks/remove_unused_accounts_groups.yaml -b -K
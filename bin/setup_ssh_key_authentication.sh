#!/usr/bin/env bash

set -euo pipefail          # Terminar al fallo, no usar variables no inicializadas y capturar errores de pipelines
set +o history

# Copy your ssh key to the workstation
ssh-copy-id pro@192.168.1.89

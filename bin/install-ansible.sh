#!/usr/bin/env bash

set -euo pipefail          # Terminar al fallo, no usar variables no inicializadas y capturar errores de pipelines

apt install ansible ansible-lint

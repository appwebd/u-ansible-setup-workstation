#!/usr/bin/env bash

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.

apt install ansible ansible-lint

#!/usr/bin/env bash
# Author      : Patricio Rojas Ortiz
# Description : Allows you to install ansible ansible-lint on the workstation

set -euo pipefail          # Terminate on error, avoid using uninitialized variables, and capture pipeline errors.

PYTHON_VERSION="3.12"
echo "installing ansible  ... "
sudo apt install ansible python3 python3-pip sshpass libssl-dev git

uv init

uv python install "$PYTHON_VERSION"
uv python pin "$PYTHON_VERSION"

uv add ansible-core ansible-dev-tools ansible-lint yamllint pytest-testinfra
python3 -m pip install --user molecule ansible-lint

# Other plugins are:
# containers gce docker vagrant podman openstack default ec2 azure
python3 -m pip install --user "molecule-plugins[docker]"

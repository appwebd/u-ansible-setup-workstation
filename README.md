# Ansible Workstation Setup

![Ansible](https://img.shields.io/badge/Ansible-2.x-black?logo=ansible)
![Hardening](https://img.shields.io/badge/Security-Hardening-green)
![Static Badge](https://img.shields.io/badge/OS-Ubuntu%2024-red%3Flogo%3Dubuntu)
[![Development Status](https://img.shields.io/badge/Status-Development-yellow?style=for-the-badge&logo=github)](https://img.shields.io/badge/Status-Development-yellow?style=for-the-badge&logo=github)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project automates the preparation, hardening, and customization of a workstation based on **Ubuntu 24.04**.

It follows the hardening guides of *Lynis* and *Wazuh*, and installs a set of critical tools for auditing, intrusion detection, and access control.


## 🚀 Installation and Usage

1. **Install Ansible**  
   If you don't already have it installed, run the included script:

```bash
bash bin/install-ansible.sh
```

## Clone the Repository

```bash
git clone https://github.com/appwebd/u-ansible-setup-workstation.git
cd u-ansible-setup-workstation
```

## Configure Vault
Ansible uses `ansible-vault` to handle sensitive variables. Here it is used to generate a password for Tripwire.

```bash
# Create the vault and variable files
cd roles/setup_tripwire/vars/
ansible-vault create main.yml
```

Store the master password you used for `ansible-vault` in the `.vault_password` file:

```bash
echo "your_master_password" > .vault_password
chmod 600 .vault_password
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_password
```

This is primarily to automate the `ansible-lint` review so it doesn't prompt for the role's password.

## Project Structure

```text
.
├── bin/                     # Helper scripts (install-ansible, wrappers, lint, etc.)
├── inventory/               # Ansible inventory files
├── playbooks/               # High‑level playbooks
│   ├── setup_workstation.yaml
│   ├── update_upgrade.yaml
│   ├── remove_bloatware_packages.yaml
│   ├── remove_unused_accounts_groups.yaml
│   ├── shutdown.yaml
├── roles/                   # Ansible roles
│   ├── aide/
│   ├── auditd/
│   ├── configure-timezone/
│   ├── configure_local_login_banner/
│   ├── configure_login_defs/
│   ├── fail2ban/
│   ├── file_permission/
│   ├── gnome/
│   ├── grub_audit_backlog/
│   ├── hardening_debian/
│   ├── otpclient/
│   ├── remove_bloatware_packages/
│   ├── remove_unused_accounts_groups/
│   ├── rkhunter/
│   ├── sshd/
│   ├── sudo/
│   ├── suggested_software_packages/
│   ├── suggested_software_packages_desktop/
│   ├── sysstat/
│   ├── tripwire/
│   ├── unattended_upgrades/
│   └── update_upgrade/
├── .ansible/                # Ansible cache
├── .vault_password          # Master password for Ansible Vault
└── README.md
```

## Main Playbook Tasks

| Task                                | Script                                      |
|-------------------------------------|---------------------------------------------|
| Update packages on multiple servers | `bash bin/run_update_upgrade.sh`            |
| Shut down multiple servers          | `bash bin/run_shutdown.sh`                  |
| Ensure playbooks follow standards   | `bash bin/run_ansible_lint.sh`              |
| Configure SSH                       | `bash bin/setup_ssh_key_authentication.sh`  |
| Clean bloatware from Ubuntu         | `bash bin/run_remove_bloatware_packages.sh` |


## Core Roles

| Role | Purpose | Key File |
|------|---------|----------|
| `aide` | Install and configure AIDE | `tasks/main.yml` |
| `auditd` | Configure auditd and audit rules | `tasks/main.yml` |
| `fail2ban` | Protect against failed login attempts | `tasks/main.yml` |
| `gnome` | Configure desktop (banners, wallpaper, etc.) | `tasks/main.yml` |
| `hardening_debian` | Apply kernel, sysctl, and AppArmor hardening | `tasks/main.yml` |
| `remove_bloatware_packages` | Remove unnecessary packages | `tasks/main.yml` |
| `remove_unused_accounts_groups` | Clean unused accounts and groups | `tasks/main.yml` |
| `rkhunter` | Install and run Rootkit Hunter | `tasks/main.yml` |
| `sshd` | Harden SSH (key‑only access, port, banner, etc.) | `tasks/main.yml` |
| `sudo` | Configure sudo permissions and expiration policy | `tasks/main.yml` |
| `tripwire` | Install and configure Tripwire for change detection | `tasks/main.yml` |
| `unattended_upgrades` | Automate security patches | `tasks/main.yml` |
| `update_upgrade` | Run `apt update` and `apt upgrade` | `tasks/main.yml` |

## Ansible Lint Syntax Check

To ensure playbooks follow the standards:

```bash
# Run ansible-lint on all playbooks
bash bin/run_ansible_lint.sh
```

## 📚 Resources and Documentation

- [Ansible Official Docs](https://docs.ansible.com/)
- [Lynis Hardening Guide](https://cisofy.com/lynis/)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Debian Hardening](https://wiki.debian.org/SecureDebootstrap)
- [Ubuntu Security Standards](https://ubuntu.com/security/security-standards)
- [Ubuntu Hardening](https://ubuntu.com/engage/a-guide-to-infrastructure-hardening)

## 📜 License
This project is licensed under the MIT License. See the `LICENSE` file for details.
